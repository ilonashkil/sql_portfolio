-- Standardize Date Format
ALTER TABLE nashville_housing
    ALTER COLUMN "SaleDate" TYPE DATE USING TO_DATE("SaleDate", 'Month DD, YYYY');

-- Populate Property Address data (from similar ParcelID)
SELECT *
FROM nashville_housing
-- WHERE "PropertyAddress" IS NULL
ORDER BY "ParcelID";

UPDATE nashville_housing AS t1
SET "PropertyAddress" = t2."PropertyAddress"
FROM (SELECT DISTINCT "ParcelID", "PropertyAddress"
      FROM nashville_housing
      WHERE "PropertyAddress" IS NOT NULL) AS t2
WHERE t1."ParcelID" = t2."ParcelID"
  AND t1."PropertyAddress" IS NULL;


-- Breaking out Address into Individual Columns (Address, City, State)
ALTER TABLE nashville_housing
    ADD COLUMN property_street text;
ALTER TABLE nashville_housing
    ADD COLUMN property_city text;

UPDATE nashville_housing
SET property_street = TRIM(SUBSTRING("PropertyAddress", 1, POSITION(',' IN "PropertyAddress") - 1)),
    property_city   = TRIM(SPLIT_PART("PropertyAddress", ',', 2));


ALTER TABLE nashville_housing
    ADD COLUMN owner_street TEXT;
ALTER TABLE nashville_housing
    ADD COLUMN owner_city TEXT;
ALTER TABLE nashville_housing
    ADD COLUMN owner_state TEXT;

UPDATE nashville_housing
set owner_street = SPLIT_PART(REPLACE("OwnerAddress", ',', '.'), '.', 1),
    owner_city = SPLIT_PART(REPLACE("OwnerAddress", ',', '.'), '.', 2),
    owner_state = SPLIT_PART(REPLACE("OwnerAddress", ',', '.'), '.', 3);


    -- Remove Duplicates
WITH row_num_cte AS (SELECT *,
                            ROW_NUMBER() OVER (
                                PARTITION BY "ParcelID", "PropertyAddress", "SalePrice", "SaleDate", "LegalReference"
                                ORDER BY "UniqueID"
                                ) row_number
                     FROM nashville_housing)

DELETE
FROM nashville_housing
WHERE ("UniqueID", "ParcelID", "PropertyAddress", "SalePrice", "SaleDate", "LegalReference") IN
      (SELECT "UniqueID", "ParcelID", "PropertyAddress", "SalePrice", "SaleDate", "LegalReference"
       FROM row_num_cte
       WHERE row_number > 1);


-- Delete Unused Columns
ALTER TABLE nashville_housing
    DROP COLUMN "OwnerAddress",
    DROP COLUMN "PropertyAddress",
    DROP COLUMN "TaxDistrict"
