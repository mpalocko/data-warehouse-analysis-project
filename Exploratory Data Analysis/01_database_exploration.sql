/* 
Database Exploration – This helps give us an overview of the database and see how many 
tables there are, what the names of columns/tables are. This helps provide the foundation 
of exploring the data.
*/

-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
