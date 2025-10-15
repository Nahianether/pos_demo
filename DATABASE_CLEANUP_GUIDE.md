# Database Cleanup Guide

This guide will help you remove all dummy data from your backend database.

## What's the Problem?

Your backend database contains dummy/test data (Food, Groceries, Beverages, etc.) along with your real data (Part's and Accessories, Helmet). The Flutter app is correctly fetching from the API, but the API is returning this dummy data.

## Solution Steps

### Step 1: Locate Your Database

First, find where your backend database is located. Common locations:
- PostgreSQL: Usually running on `localhost:5432`
- MySQL: Usually running on `localhost:3306`
- SQLite: File in your backend project folder

### Step 2: Connect to Your Database

Choose the method based on your database type:

#### Option A: PostgreSQL
```bash
# Connect to PostgreSQL
psql -U your_username -d your_database_name

# Or if using default postgres user:
psql -U postgres -d pos_database
```

#### Option B: MySQL
```bash
# Connect to MySQL
mysql -u your_username -p your_database_name

# Or:
mysql -u root -p pos_database
```

#### Option C: Using a GUI Tool
- **pgAdmin** (for PostgreSQL)
- **MySQL Workbench** (for MySQL)
- **DBeaver** (works with all databases)

### Step 3: Preview What Will Be Deleted

Run the first part of the `cleanup_database.sql` script to see what will be deleted:

```sql
-- This is safe - it only shows data, doesn't delete anything
SELECT 'Categories to be deleted:' as info;
SELECT id, name, parent_id
FROM categories
WHERE id NOT IN (
    '296f350c-6725-4460-b719-3c3267798dec',
    '071649dc-cc45-4f6c-83fe-775d0ea8dd06'
);
```

You should see approximately 15 dummy categories (Food, Groceries, Beverages, etc.)

### Step 4: Run the Cleanup Script

#### Method 1: Copy and paste the SQL commands

1. Open the `cleanup_database.sql` file
2. **Uncomment** the DELETE statements (remove the `--` at the start of lines)
3. Copy the DELETE statements
4. Paste them into your database client
5. Execute the commands

#### Method 2: Run the entire file (PostgreSQL)

```bash
psql -U your_username -d your_database_name -f cleanup_database.sql
```

#### Method 3: Run the entire file (MySQL)

```bash
mysql -u your_username -p your_database_name < cleanup_database.sql
```

### Step 5: Verify the Cleanup

Run this query to verify only your real data remains:

```sql
-- Should show only 2 categories
SELECT id, name, parent_id FROM categories ORDER BY name;

-- Should show only your motorcycle parts and helmets
SELECT id, name, category_id FROM products ORDER BY name;
```

Expected results:
- **2 categories**: Part's and Accessories, Helmet
- **~21 products**: Clutch plates, helmets, brake pads, etc.

### Step 6: Test Your Flutter App

1. Hot restart your Flutter app (`r` in terminal or stop/start)
2. You should now see only:
   - Part's and Accessories
   - Helmet
3. No more Food, Groceries, or Beverages!

## Alternative: Manual Deletion

If you prefer to delete manually without SQL:

### Delete Dummy Categories:
```sql
DELETE FROM categories WHERE name IN (
    'Food',
    'Groceries',
    'Beverages',
    'Fast Food',
    'Snacks',
    'Desserts',
    'Bakery',
    'Soft Drinks',
    'Coffee & Tea',
    'Juices',
    'Water',
    'Dairy',
    'Canned Goods',
    'Frozen Foods',
    'Condiments'
);
```

### Delete All Products Not in Your Categories:
```sql
DELETE FROM products
WHERE category_id NOT IN (
    '296f350c-6725-4460-b719-3c3267798dec',  -- Part's and Accessories
    '071649dc-cc45-4f6c-83fe-775d0ea8dd06'   -- Helmet
);
```

## Troubleshooting

### "Foreign key constraint violation"
If you get this error, delete products first, then categories:

```sql
-- 1. First delete products
DELETE FROM products WHERE category_id IN (
    SELECT id FROM categories
    WHERE id NOT IN (
        '296f350c-6725-4460-b719-3c3267798dec',
        '071649dc-cc45-4f6c-83fe-775d0ea8dd06'
    )
);

-- 2. Then delete categories
DELETE FROM categories WHERE id NOT IN (
    '296f350c-6725-4460-b719-3c3267798dec',
    '071649dc-cc45-4f6c-83fe-775d0ea8dd06'
);
```

### "Permission denied"
Make sure you're connected with a user that has DELETE permissions.

### Still seeing dummy data in the app?
1. Make sure the backend server restarted
2. Hard restart your Flutter app (stop and start, not just hot reload)
3. Check if the API is caching responses

## Backup (Recommended)

Before running the cleanup, create a backup:

### PostgreSQL:
```bash
pg_dump -U your_username your_database_name > backup_before_cleanup.sql
```

### MySQL:
```bash
mysqldump -u your_username -p your_database_name > backup_before_cleanup.sql
```

## Need Help?

If you encounter any issues:
1. Check your database logs
2. Verify you're connected to the correct database
3. Make sure your backend server is running
4. Test the API endpoint directly: `http://localhost:3000/api/categories`
