/*
Cleaning Data in SQL Queries
*/

-- select all from the table
Select *
From nashville_housing;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select  SaleDate, convert(date,SaleDate)
From nashville_housing;

update nashville_housing
set SaleDate=convert(date,SaleDate);

alter table nashville_housing
add SaleDateConverted date;

update nashville_housing
set SaleDateConverted=convert(date,SaleDate);

-- dropping column name SaleDate

alter table nashville_housing
drop column SaleDate;


-- checking to see if there are any null values in the propertyaddress column

Select   *
From nashville_housing where PropertyAddress is null;

-- Populating the propertyaddress column with data

Select   a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From nashville_housing a
inner join nashville_housing b
on a.ParcelID=b.ParcelID  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From nashville_housing a
inner join nashville_housing b
on a.ParcelID=b.ParcelID  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

-- Spitting the PropertyAddress Coloumns into (address, city , state)



select SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1) as address, SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress)) as address_2
from nashville_housing;

alter table nashville_housing
add propertyspiltaddress nvarchar(255);

update nashville_housing
set propertyspiltaddress= SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1);

alter table nashville_housing
add propertyspiltcity nvarchar(255);

update nashville_housing
set propertyspiltcity= SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress));

--checking the newly created columns

select * from nashville_housing;



-- checking the contents of the property address
Select   PropertyAddress
From nashville_housing;



-- looking at the owneraddress column 

select owneraddress from nashville_housing;

-- using parsename to split the address withing the owneraddress column

select 
	PARSENAME(replace(OwnerAddress,',','.'),3),
	PARSENAME(replace(OwnerAddress,',','.'),2),
	PARSENAME(replace(OwnerAddress,',','.'),1)
from nashville_housing;

alter table nashville_housing
add Ownersplitaddress nvarchar(255);

update nashville_housing
set  Ownersplitaddress = PARSENAME(replace(OwnerAddress,',','.'),3);

alter table nashville_housing
add Ownersplitcity nvarchar(255);

update nashville_housing
set  Ownersplitcity = PARSENAME(replace(OwnerAddress,',','.'),2);

alter table nashville_housing
add Ownersplitstate nvarchar(255);

update nashville_housing
set  Ownersplitstate = PARSENAME(replace(OwnerAddress,',','.'),1);

-- checking the altered table

select * from nashville_housing;

-- changing y and n to yes and no in soldasvacant column

select  distinct(soldasvacant), count(SoldAsVacant)
From nashville_housing
group by soldasvacant
order by 2;

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from nashville_housing;

update nashville_housing
set SoldAsVacant=case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from nashville_housing;

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville_housing
)
SELECT *
From RowNumCTE
Where row_num > 1




Select *
From nashville_housing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From nashville_housing


ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress