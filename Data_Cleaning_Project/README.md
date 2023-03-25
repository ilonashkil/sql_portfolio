# Nashville Housing Data Cleaning Project

This project involves cleaning and standardizing a dataset of Nashville housing sales data. The dataset contains information on housing sales from 2013 to 2018 and is provided in CSV format.

The goal of this project is to perform various data cleaning tasks on the dataset to ensure data consistency, standardize date formats, populate missing data, and remove duplicates.

### 1. Standardize Date Format:
The "SaleDate" column was updated to a standard date format using the TO_DATE function.

### 2. Populate Property Address data: 
Missing "PropertyAddress" data was populated by matching the "ParcelID" with other records that have the same "ParcelID" and a non-null "PropertyAddress".

### 3. Breaking out Address into Individual Columns: 
The "PropertyAddress" and "OwnerAddress" columns were split into separate columns for street, city, and state.

### 4. Remove Duplicates: 
Duplicate records were removed based on a combination of columns that uniquely identify each record.

### 5. Delete Unused Columns: 
The "OwnerAddress", "PropertyAddress", and "TaxDistrict" columns were dropped since they are no longer needed.