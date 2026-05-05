# Alembic Migration Recipes

> Patterns cho migration phức tạp. Dùng khi autogen không đủ.

---

## 1. Add NOT NULL column to table có data (2-step deploy)

**❌ SAI — fail trên prod nếu table có rows:**
```python
op.add_column("products", sa.Column("category_id", sa.Integer, nullable=False))
```

**✅ ĐÚNG — 2 migrations:**

```python
# Migration 1: add nullable + backfill
def upgrade():
    op.add_column("products", sa.Column("category_id", sa.Integer, nullable=True))

    # Backfill (nếu có default category)
    op.execute("UPDATE products SET category_id = 1 WHERE category_id IS NULL")

# Migration 2: set NOT NULL (chạy sau khi deploy code mới)
def upgrade():
    op.alter_column("products", "category_id", nullable=False)
```

**Tại sao 2-step:** giữa 2 deploys có khoảng vài phút mà code cũ đang chạy với column nullable. Code mới đảm bảo luôn set value. Sau đó set NOT NULL safe.

---

## 2. Add index trên large table (no-downtime)

**❌ SAI — block writes:**
```python
op.create_index("ix_products_shop_id", "products", ["shop_id"])
```

**✅ ĐÚNG — concurrent:**
```python
def upgrade():
    # PostgreSQL only — disable transaction
    with op.get_context().autocommit_block():
        op.create_index(
            "ix_products_shop_id",
            "products",
            ["shop_id"],
            postgresql_concurrently=True,
            if_not_exists=True,
        )
```

**Tại sao:** `CONCURRENTLY` không lock table. Trade-off: chậm hơn (2x time), nhưng app vẫn read/write bình thường.

---

## 3. Rename column (multi-step deploy)

**❌ SAI — code break giữa deploy:**
```python
op.alter_column("orders", "status", new_column_name="order_status")
```

**✅ ĐÚNG — 4-step:**

```python
# Migration 1: add new column, backfill from old
def upgrade():
    op.add_column("orders", sa.Column("order_status", sa.String, nullable=True))
    op.execute("UPDATE orders SET order_status = status")

# Deploy code: write to BOTH old and new column
# class Order: status = ..., order_status = ...
# In service: order.status = X; order.order_status = X

# Migration 2: set NOT NULL on new column
def upgrade():
    op.alter_column("orders", "order_status", nullable=False)

# Deploy code: read from new column only
# Remove status references in code

# Migration 3: drop old column
def upgrade():
    op.drop_column("orders", "status")
```

---

## 4. Drop column safely (2-step deploy)

```python
# Step 1 (deploy code first — không reference column)
# Remove all `model.column` reads/writes from code
# Remove from Pydantic schema

# Migration 1: just deploy code change, NO migration yet

# Step 2 (after code deployed)
def upgrade():
    op.drop_column("table_name", "column_name")
```

**Tại sao:** nếu drop column trước, code cũ đang chạy sẽ crash khi access.

---

## 5. Change column type (lossy → lossless)

**❌ SAI — fail nếu data không cast được:**
```python
op.alter_column("products", "price", type_=sa.Numeric(14, 2))
```

**✅ ĐÚNG — explicit cast:**
```python
def upgrade():
    op.alter_column(
        "products",
        "price",
        type_=sa.Numeric(14, 2),
        postgresql_using="price::numeric(14,2)",  # explicit cast
    )
```

**Float → Decimal special:**
```python
# Backup first!
op.execute("UPDATE products SET price_temp = ROUND(price::numeric, 2)")
op.drop_column("products", "price")
op.alter_column("products", "price_temp", new_column_name="price")
```

---

## 6. Data migration (KHÔNG autogen được)

```python
"""Backfill order_code for existing orders.

Revision ID: abc123
Revises: previous_rev
"""
from alembic import op
import sqlalchemy as sa
from datetime import datetime

def upgrade():
    # Get connection
    conn = op.get_bind()

    # Process in batches (avoid memory blow-up trên large table)
    BATCH_SIZE = 1000
    offset = 0

    while True:
        result = conn.execute(
            sa.text("SELECT id, created_at FROM orders WHERE order_code IS NULL ORDER BY id LIMIT :limit OFFSET :offset"),
            {"limit": BATCH_SIZE, "offset": offset}
        ).fetchall()

        if not result:
            break

        for row in result:
            order_id, created_at = row
            code = f"ORD-{created_at.strftime('%y%m%d')}-{order_id:03d}"
            conn.execute(
                sa.text("UPDATE orders SET order_code = :code WHERE id = :id"),
                {"code": code, "id": order_id}
            )

        offset += BATCH_SIZE

def downgrade():
    op.execute("UPDATE orders SET order_code = NULL")
```

**Rules:**
- Process trong batches (1000 rows/batch) — KHÔNG `SELECT *` rồi loop
- Backup data trước khi run migration phá hủy
- Test trên staging clone DB trước production
- Have rollback plan (`downgrade()`)

---

## 7. Add unique constraint (handle duplicates first)

```python
def upgrade():
    # Step 1: find duplicates
    duplicates = op.get_bind().execute(sa.text("""
        SELECT shop_id, slug, COUNT(*) as cnt
        FROM products
        GROUP BY shop_id, slug
        HAVING COUNT(*) > 1
    """)).fetchall()

    if duplicates:
        # Step 2: dedupe (append id to slug)
        for shop_id, slug, _ in duplicates:
            op.execute(sa.text(f"""
                UPDATE products
                SET slug = slug || '-' || id
                WHERE shop_id = :shop_id AND slug = :slug
                  AND id NOT IN (
                    SELECT MIN(id) FROM products
                    WHERE shop_id = :shop_id AND slug = :slug
                  )
            """), {"shop_id": shop_id, "slug": slug})

    # Step 3: add unique constraint
    op.create_unique_constraint(
        "uq_products_shop_slug",
        "products",
        ["shop_id", "slug"]
    )
```

---

## 8. Common autogen issues to manually fix

### Server defaults not detected
```python
# Autogen MISSES this
op.add_column("orders", sa.Column("created_at", sa.DateTime(timezone=True),
                                   server_default=sa.func.now()))
```

### Enum type changes
```python
# Add new enum value (postgres-specific)
op.execute("ALTER TYPE order_status ADD VALUE 'returned'")

# Remove enum value — phải recreate type (complex!)
# Tip: better to use String column with CHECK constraint
```

### Column comment / table comment
```python
op.alter_column("products", "price", comment="Giá bán hiển thị (Decimal)")
op.create_table_comment("products", "Bảng sản phẩm chính")
```

---

## TESTING MIGRATIONS

```bash
# Run on local
alembic upgrade head

# Run on staging (clone of production)
DATABASE_URL=$STAGING_DB alembic upgrade head

# Rollback test
alembic downgrade -1
alembic upgrade head  # re-apply, must succeed

# Check current version
alembic current

# History
alembic history --verbose
```

**Production deploy order:**
1. Test migration trên staging clone DB
2. Backup production DB
3. Apply migration during low-traffic window
4. Monitor logs/metrics for 30 minutes
5. If error → rollback migration + previous code deploy

---

## ALEMBIC TIPS

```bash
# Generate migration với detection
alembic revision --autogenerate -m "add_field_to_table"

# Generate empty migration (cho data migration thuần)
alembic revision -m "backfill_order_codes"

# Apply 1 step
alembic upgrade +1

# Apply specific revision
alembic upgrade abc123

# Show SQL without applying (preview)
alembic upgrade head --sql > preview.sql
```
