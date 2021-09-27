/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM PortfolioProjects.NashvilleHousing;
-----------------------------------------------------------------------------------
----- Standardize Date Format
SELECT SaleDate, CAST(SaleDate AS DATE) AS Date
FROM PortfolioProjects.NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CAST(SaleDate AS DATE);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CAST(SaleDate AS DATE);




-----------------------------------------------------------------------------------
----- Populate Property Address data

SELECT *
FROM PortfolioProjects.NashvilleHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.NashvilleHousing a
JOIN PortfolioProjects.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.NashvilleHousing a
JOIN PortfolioProjects.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
WHERE WHERE a.PropertyAddress IS NULL;


-----------------------------------------------------------------------------------
---- Breaking out Address Into Individul Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProjects.NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM PortfolioProjects.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress));

SELECT *
FROM PortfolioProjects.NashvilleHousing;

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProjects.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE NashvilleHousing
ADD PropertySplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);


 
-----------------------------------------------------------------------------------
---- Change Y and N to Yes and No in 'Sold as Vacant' Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjects.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
      ELSE SoldAsVacant
      END
FROM PortfolioProjects.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
      ELSE SoldAsVacant
      END;



-----------------------------------------------------------------------------------
---- Remove Duplicates

WITH RowNumCTE AS (
SELECT *
	ROW_NUMBER() OVER (
    PARTITON BY ParcelID, 
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
    ORDER BY
		UniqueID
        ) row_num
    
FROM PortfolioProjects.NashvilleHousing
ORDER BY ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
-------- ORDER BY PropertyAddress








-----------------------------------------------------------------------------------
----- Delete Unused Columns

SELECT *
FROM PortfolioProjects.NashvilleHousing

ALTER TABLE PortfolioProjects.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







-----------------------------------------------------------------------------------





