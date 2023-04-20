/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject2].[dbo].[NashvilleHousing]

  --Cleaning data in SQL Queries

  Select *
  From PortfolioProject2..NashvilleHousing

  --Standardize Sales Date

  Select SaleDateConverted, Convert(date,SaleDate)
  From PortfolioProject2..NashvilleHousing

  Update NashvilleHousing
  SET SaleDate = Convert(date,SaleDate)

  Alter table NashvilleHousing
  Add SaleDateConverted Date;

  Update NashvilleHousing
  SET SaleDateConverted = Convert(date,SaleDate)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


  --Populate Property Address Data

  Select *
  From PortfolioProject2..NashvilleHousing
  --Where PropertyAddress is null 
  Order by ParcelID

  
  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.Propertyaddress, b.propertyaddress)
  From PortfolioProject2..NashvilleHousing a
  Join PortfolioProject2..NashvilleHousing b
	on a.parcelID = b.parcelid
	And a.[UniqueID] <> b.[UniqueID]
  Where a.PropertyAddress is null 



  Update a
  Set PropertyAddress = ISNULL(a.Propertyaddress, b.propertyaddress)
  From PortfolioProject2..NashvilleHousing a
  Join PortfolioProject2..NashvilleHousing b
	on a.parcelID = b.parcelid
	And a.[UniqueID] <> b.[UniqueID]
  Where a.PropertyAddress is null 



  -----------------------------------------------------------------------------------------------------------------------------------------------

  --Breaking Out Address Into Individual Columns (Address, City, State)


  Select PropertyAddress
  From PortfolioProject2..NashvilleHousing
  --Where PropertyAddress is null 
  --Order by ParcelID


  Select
  SUBSTRING (propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
  , SUBSTRING (propertyaddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as Address

  From PortfolioProject2..NashvilleHousing


  Alter table NashvilleHousing
  Add PropertySplitAddress Nvarchar(255);

  Update NashvilleHousing
  SET PropertySplitAddress = SUBSTRING (propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1)


  Alter table NashvilleHousing
  Add PropertySplitCity Nvarchar(255);

  Update NashvilleHousing
  SET PropertySplitCity = SUBSTRING (propertyaddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))


  Select *
  From PortfolioProject2..NashvilleHousing



  Select owneraddress
  From PortfolioProject2..NashvilleHousing


  Select
  PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
  ,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
  ,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
  From PortfolioProject2..NashvilleHousing



   Alter table NashvilleHousing
  Add OwnerSplitAddress Nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)


  Alter table NashvilleHousing
  Add OwnerSplitCity Nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)



   Alter table NashvilleHousing
  Add OwnerSplitState Nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)


  
  Select *
  From PortfolioProject2..NashvilleHousing


  -- Change Y and N to Yes and No in 'Sold as Vacant' Column



  Select Distinct(soldasvacant), Count(Soldasvacant)
  From PortfolioProject2..NashvilleHousing
  Group by Soldasvacant
  Order by 2


  Select SoldAsVacant
  , Case When SoldAsVacant = 'Y' then 'Yes'
	     When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 End
  From PortfolioProject2..NashvilleHousing


  Update NashvilleHousing
  Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
	     When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 End



--Remove Duplicates

With RowNumCTE As(
Select *,
	Row_Number() Over (
	Partition by ParcelID, 
			     PropertyAddress,
			     SalePrice,
			     SaleDate,
			     LegalReference
			     Order by
			     UniqueID
			     ) row_number 

From PortfolioProject2..NashvilleHousing
--Order by ParcelID
)
Select * 
From RowNumCTE
Where row_number > 1
--Order by PropertyAddress

-----------------------------------------------------------------------------------------------------------------------------


--Delete Unused Columns


Select *
  From PortfolioProject2..NashvilleHousing


  Alter Table PortfolioProject2..NashvilleHousing
  Drop Column OwnerAddress, TaxDistrict, PropertyAddress

  Alter Table PortfolioProject2..NashvilleHousing
  Drop Column SaleDate
