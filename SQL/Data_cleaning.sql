/*
========================================
========================================

			Data Cleaning
	
========================================
========================================
----------------------------------------
			Data Quality Checks
----------------------------------------
*/
-- 1. Check Missing Values
SELECT COUNT(Row_ID), COUNT(Order_ID), COUNT(Order_Date), COUNT(Ship_Date), COUNT(Ship_Mode), COUNT(Customer_ID),
		COUNT(Customer_Name), COUNT(Segment), COUNT(Country), COUNT(City), COUNT(State), COUNT(Postal_Code),
		COUNT(Region), COUNT(Product_ID), COUNT(Category), COUNT(Sub_Category), COUNT(Product_Name), COUNT(Sales),
		COUNT(Quantity), COUNT(Discount), COUNT(Profit)
FROM Sample_Superstore;

-- 2. Check Duplicate Records
SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country, City, State, Postal_Code,
		Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit, COUNT(*) AS Duplicate_count
FROM Sample_Superstore
GROUP BY Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country, City, State, Postal_Code,
		Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

-- 3. Validate Identifier Length (Found len(Postal_Code) <> 5, then added leading zeros to 4-digit postal codes)
SELECT
    Order_ID,
    LENGTH(Order_ID) AS order_id_length,
    Customer_ID,
    LENGTH(Customer_ID) AS customer_id_length,
    Postal_Code,
    LENGTH(Postal_Code) AS postal_code_length,
    Product_ID,
    LENGTH(Product_ID) AS product_id_length
FROM Sample_Superstore;

SELECT Order_ID
FROM Sample_Superstore
WHERE LENGTH(Order_ID) <> 14;

SELECT Customer_ID
FROM Sample_Superstore
WHERE LENGTH(Customer_ID) <> 8;

SELECT Postal_Code
FROM Sample_Superstore
WHERE LENGTH(Postal_Code) <> 5
GROUP BY Postal_Code;

SELECT Product_ID
FROM Sample_Superstore
WHERE LENGTH(Product_ID) <> 15;

-- 4. Detect encoding issues in Customer_Name
SELECT Customer_Name
FROM Sample_Superstore
WHERE Customer_Name LIKE '%�%'
GROUP BY Customer_Name;

-- 5. Check data types
SELECT
    name AS column_name,
    type AS data_type
FROM pragma_table_info('Sample_Superstore');

/*
----------------------------------------
			Create Clean Table
----------------------------------------
*/
-- Create Clean Table with Standardized Data Types (Postal_Code: INTEGER -> TEXT, Discount: INTEGER -> REAL)
CREATE TABLE Sample_Superstore_clean (
	Order_ID TEXT,
	Order_Date TEXT,
	Ship_Date TEXT,
	Ship_Mode TEXT,
	Customer_ID TEXT,
	Customer_Name TEXT,
	Segment TEXT,
	Country TEXT, 
	City TEXT,
	State TEXT,
	Postal_Code TEXT,
	Region TEXT,
	Product_ID TEXT,
	Category TEXT,
	Sub_Category TEXT,
	Product_Name TEXT,
	Sales REAL,
	Quantity INTEGER,
	Discount REAL,
	Profit REAL);

-- Insert Distinct Records into Clean Table
INSERT INTO Sample_Superstore_clean
SELECT DISTINCT -- Remove Duplicate Data
	Order_ID,
	Order_Date, 
	Ship_Date, 
	Ship_Mode, 
	Customer_ID, 
	Customer_Name, 
	Segment, 
	Country, 
	City, 
	State, 
	Postal_Code, 
	Region,
	Product_ID, 
	Category, 
	Sub_Category, 
	Product_Name, 
	Sales, 
	Quantity, 
	Discount, 
	Profit 
FROM Sample_Superstore;

-- Standardize postal codes by adding leading zeros อันนี้ว่าจะเอาไปใส่เป็นหัวข้อใน github
-- Added leading zeros to 4-digit postal codes
UPDATE Sample_Superstore_clean
SET Postal_Code = '0' || Postal_Code
WHERE LENGTH(Postal_Code) = 4;

-- Correct character encoding issues in Customer_Name
UPDATE Sample_Superstore_clean
SET Customer_Name = 'Anna Häberlin'
WHERE Customer_Name = 'Anna H�berlin';

UPDATE Sample_Superstore_clean
SET Customer_Name = 'Barry Französisch'
WHERE Customer_Name = 'Barry Franz�sisch';

UPDATE Sample_Superstore_clean
SET Customer_Name = 'Neil Französisch'
WHERE Customer_Name = 'Neil Franz�sisch';

UPDATE Sample_Superstore_clean
SET Customer_Name = 'Peter Bühler'
WHERE Customer_Name = 'Peter B�hler';

UPDATE Sample_Superstore_clean
SET Customer_Name = 'Resi Pölking'
WHERE Customer_Name = 'Resi P�lking';

UPDATE Sample_Superstore_clean
SET Customer_Name = 'Roy Französisch'
WHERE Customer_Name = 'Roy Franz�sisch';

/*
----------------------------------------
			Validate Cleaned Data
----------------------------------------
*/
-- 1. Check Missing Values
SELECT COUNT(Order_ID), COUNT(Order_Date), COUNT(Ship_Date), COUNT(Ship_Mode), COUNT(Customer_ID),
		COUNT(Customer_Name), COUNT(Segment), COUNT(Country), COUNT(City), COUNT(State), COUNT(Postal_Code),
		COUNT(Region), COUNT(Product_ID), COUNT(Category), COUNT(Sub_Category), COUNT(Product_Name), COUNT(Sales),
		COUNT(Quantity), COUNT(Discount), COUNT(Profit)
FROM Sample_Superstore_clean;

-- 2. Check Duplicate Values 
SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country, City, State, Postal_Code,
		Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit, COUNT(*) AS Duplicate_count
FROM Sample_Superstore_clean
GROUP BY Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country, City, State, Postal_Code,
		Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

-- 3. Validate Postal_Code Length
SELECT Postal_Code
FROM Sample_Superstore_clean
WHERE LENGTH(Postal_Code) <> 5
GROUP BY Postal_Code;

-- 4. Validate Customer Names
SELECT Customer_Name
FROM Sample_Superstore_clean
WHERE Customer_Name LIKE '%�%'
GROUP BY Customer_Name;

-- 5. Verify Data Types
SELECT
    name,
    type
FROM pragma_table_info('Sample_Superstore_clean');