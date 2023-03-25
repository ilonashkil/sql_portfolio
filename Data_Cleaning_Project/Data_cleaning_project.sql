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
    owner_state = SPLIT_PART(REPLACE("OwnerAddress", ',', '.'), '.', 3)
