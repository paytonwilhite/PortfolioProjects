/* 

Cleaning Data with SQL Queries

*/

select *
from [Portfolio Project]..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

select SaleDateConverted
from [Portfolio Project]..NashvilleHousing


Update NashvilleHousing 
SET SaleDate = CONVERT(Date, SaleDate)

select saledate
from [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-----------------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data

select *
from [Portfolio Project]..NashvilleHousing
where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET  PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-----------------------------------------------------------------------------------------------------------------------------------
-- Break Address into Individual Columns (Address, City, State, etc.)

select PropertyAddress
from [Portfolio Project]..NashvilleHousing

select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
from [Portfolio Project]..NashvilleHousing

alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
Set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
Set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



select OwnerAddress
from [Portfolio Project]..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1)
from [Portfolio Project]..NashvilleHousing

alter table NashvilleHousing
Add SplitOwnerAddress nvarchar(255);

update NashvilleHousing
Set SplitOwnerAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

alter table NashvilleHousing
Add SplitOwnerCity nvarchar(255);

update NashvilleHousing
Set SplitOwnerCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

alter table NashvilleHousing
Add SplitOwnerState nvarchar(255);

update NashvilleHousing
Set SplitOwnerState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)


-----------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
Case 
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
from [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = 
Case 
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End

Select distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2


-----------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE as 
(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) row_num
from [Portfolio Project]..NashvilleHousing
)
delete
from RowNumCTE
where row_num > 1


WITH RowNumCTE as 
(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) row_num
from [Portfolio Project]..NashvilleHousing
)
select *
from RowNumCTE
where row_num > 1


-----------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

alter table [Portfolio Project]..NashvilleHousing
drop column OwnerAddress, TaxDistrict

alter table [Portfolio Project]..NashvilleHousing
drop column SaleDate