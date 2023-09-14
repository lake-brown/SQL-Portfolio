--Data Cleaning

--The dataset contains Home value data for Nashville housing the capital city of U.S. state of Tennessee. The dataset contains 19 columns and 56,477 rows of data.

--Imported Nashville Housing for Cleaning csv.



-- Standardize DATE Format
-- convert from time stamp to date


SELECT saledate
FROM nash;

ALTER TABLE nash
ALTER COLUMN saledate TYPE DATE;


--Populate property address
-- when null plasce property address

SELECT n1.parcelid, n1.propertyaddress, n2.parcelid, n2.propertyaddress
FROM nash n1
INNER JOIN nash n2
ON n1.parcelid = n2.parcelid 
AND n1.uniqueid <> n2.uniqueid
WHERE n1.propertyaddress is null;


--This query will update the propertyaddress in the nash table
--It aliases the nash table as n1 for the table being updated and n2 for the table being joined. 
--It sets the propertyaddress in n1 to the non-null value of propertyaddress from n2 if the conditions are met.
--It uses a JOIN condition on parcelid and uniqueid to identify the rows to update.

UPDATE nash AS n1
SET propertyaddress = COALESCE(n1.propertyaddress,n2.propertyaddress)
FROM nash AS n2
WHERE n1.parcelid = n2.parcelid 
AND n1.uniqueid <> n2.uniqueid
AND n1.propertyaddress IS NULL;



--  Breaking out Address into Individule Columns (Address,City, State)
--propertyaddress

SELECT 
SUBSTRING(propertyaddress FROM 1 FOR POSITION(',' IN propertyaddress) - 1) AS address,
SUBSTRING(propertyaddress FROM POSITION(',' IN propertyaddress)+1 ) AS address2
FROM nash;

-- Add the new columns to the table
ALTER TABLE nash
ADD COLUMN property_split_address VARCHAR(255), 
ADD COLUMN property_split_city VARCHAR(255);    

-- Update the new columns with values from the existing propertyaddress column
UPDATE nash
SET address = SPLIT_PART(propertyaddress, ',', 1),
city = SPLIT_PART(propertyaddress, ',', 2);

--owneraddress

SELECT
  split_part(replace(owneraddress, ',', '.'), '.', 1) AS address,
  split_part(replace(owneraddress, ',', '.'), '.', 2) AS city,
  split_part(replace(owneraddress, ',', '.'), '.', 3) AS state
FROM nash;





-- Add the new columns to the table
ALTER TABLE nash
ADD COLUMN owner_split_address VARCHAR(255), 
ADD COLUMN owner_split_city VARCHAR(255),
ADD COLUMN owner_split_state VARCHAR(255);   

-- Update the new columns with values from the existing owneraddress column
UPDATE nash
SET owner_split_address = SPLIT_PART(owneraddress, ',', 1),
    owner_split_city = SPLIT_PART(owneraddress, ',', 2),
    owner_split_state = SPLIT_PART(owneraddress, ',', 3)



--check 
SELECT owner_split_address, owner_split_city, owner_split_state
FROM nash;


-- Change Y and N to Yes and NO in 'soldasvacant'
SELECT
CASE WHEN soldasvacant = 'Y' THEN 'Yes'
 WHEN soldasvacant = 'N' THEN 'No'
 ELSE soldasvacant
 END AS soldasvacant
FROM nash;

UPDATE nash
SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN 'Yes'
 WHEN soldasvacant = 'N'THEN 'No'
 ELSE soldasvacant
 END 

--Column Name Change:

ALTER TABLE nash
RENAME COLUMN soldasvacant TO sold_as_vacant;

-- Explanation of Column Name Change:
-- The column "soldasvacant" was renamed to "sold_as_vacant" for improved readability.


---Remove Duplicates

WITH row_numCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
ORDER BY uniqueid
) AS row_num
FROM nash
)

SELECT *
FROM row_numCTE
WHERE row_num >1 ;


-- Deleted Duplicates

WITH row_numCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
ORDER BY uniqueid
) AS row_num
FROM nash
)

DELETE FROM nash
WHERE uniqueid IN (
SELECT uniqueid
FROM row_numCTE
WHERE row_num > 1);

--Checked

WITH row_numCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
ORDER BY uniqueid
) AS row_num
FROM nash
)

SELECT *
FROM row_numCTE
WHERE row_num >1 ;


--Instead of deleting Unused Columns, I created a view.
--I thought this approach was a better choice, especially if i need those columns for future analysis. 

CREATE VIEW nash_Subset AS
SELECT
uniqueid,	
parcelid,	
landuse,
property_split_Address,
property_split_city,	
saledate,	
saleprice,	
legalreference,	
sold_as_vacant,	
ownername,	
owner_split_address,
owner_split_city,
owner_split_state,	
acreage,	
landvalue,	
buildingvalue,	
totalvalue,
yearbuilt,	
bedrooms,	
fullbath,	
halfbath

FROM nash;

-- Testing created view with some sample queries to ensure that it returns the data I expect.

SELECT * FROM nash_Subset;

SELECT uniqueid, parcelid, saleprice FROM nash_Subset;

SELECT uniqueid, parcelid, saleprice
FROM nash_Subset
WHERE saleprice > 100000
ORDER BY saleprice DESC;

SELECT AVG(acreage) AS avg_acreage, MAX(totalvalue) AS max_totalvalue
FROM nash_Subset;

SELECT *
FROM nash_Subset
LIMIT 10;






