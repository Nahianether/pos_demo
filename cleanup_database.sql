-- =====================================================
-- SQL Script to Clean Dummy Data from POS Database
-- =====================================================
-- This script removes all dummy/test data while keeping
-- your real data (Part's and Accessories, Helmet, etc.)
-- =====================================================

-- Step 1: Show what will be deleted (for verification)
SELECT 'Categories to be deleted:' as info;
SELECT id, name, parent_id
FROM categories
WHERE id NOT IN (
    '296f350c-6725-4460-b719-3c3267798dec',  -- Part's and Accessories
    '071649dc-cc45-4f6c-83fe-775d0ea8dd06'   -- Helmet
);

SELECT 'Products to be deleted:' as info;
SELECT id, name, category_id
FROM products
WHERE category_id NOT IN (
    '296f350c-6725-4460-b719-3c3267798dec',  -- Part's and Accessories
    '071649dc-cc45-4f6c-83fe-775d0ea8dd06'   -- Helmet
);

-- =====================================================
-- UNCOMMENT THE LINES BELOW TO ACTUALLY DELETE THE DATA
-- =====================================================

-- Step 2: Delete products that belong to dummy categories
-- DELETE FROM products
-- WHERE category_id NOT IN (
--     '296f350c-6725-4460-b719-3c3267798dec',  -- Part's and Accessories
--     '071649dc-cc45-4f6c-83fe-775d0ea8dd06'   -- Helmet
-- );

-- Step 3: Delete dummy categories
-- DELETE FROM categories
-- WHERE id NOT IN (
--     '296f350c-6725-4460-b719-3c3267798dec',  -- Part's and Accessories
--     '071649dc-cc45-4f6c-83fe-775d0ea8dd06'   -- Helmet
-- );

-- Step 4: Verify cleanup (should only show your 2 categories)
-- SELECT 'Remaining Categories:' as info;
-- SELECT id, name, parent_id FROM categories ORDER BY name;

-- SELECT 'Remaining Products:' as info;
-- SELECT id, name, category_id FROM products ORDER BY name;
