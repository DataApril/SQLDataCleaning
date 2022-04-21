SELECT *
FROM NashvilleHousing

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
From NashvilleHousing

Update NashvilleHousing
Set SaleDate=CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted=CONVERT(Date,SaleDate)

-----------------------------------------------------------------

--Populate Property Address data

SELECT *
From NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

---------------------------------------------------------------------

-- breaking out address out individual columns (Address, City, State)

SELECT PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 


-- Owner Address 

SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSpiltAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSpiltAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSpiltCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSpiltCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 


ALTER TABLE NashvilleHousing
Add OwnerSpiltState Nvarchar(255);



SELECT *
FROM NashvilleHousing
------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
Group by SoldAsVacant
Order by 2


SELECT SoldAsVacant
,CASE When SoldAsVacant='Y' Then 'Yes'
	  When SoldAsVacant='N' Then 'No'
	  ELSE SoldAsVacant
	  END
FROM NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant='Y' Then 'Yes'
	  When SoldAsVacant='N' Then 'No'
	  ELSE SoldAsVacant
	  END


------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 ProPertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM NashvilleHousing
--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num>1
--ORDER BY PropertyAddress


SELECT *
FROM NashvilleHousing


-------------------------------------------------------------------
-- Delete Unused Columns 

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate