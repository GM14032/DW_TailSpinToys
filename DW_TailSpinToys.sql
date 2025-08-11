CREATE DATABASE DW_TailSpinToys;
GO
USE DW_TailSpinToys;
GO

CREATE TABLE DimChunk
(
    ChunkSK INT IDENTITY(1,1) PRIMARY KEY,
    KitType NCHAR(3) NOT NULL,
    Channels TINYINT NOT NULL
);

CREATE TABLE DimRegion
(
    RegionSK INT IDENTITY(1,1) PRIMARY KEY,
    RegionID_BK INT NOT NULL,         
    RegionName NVARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    CurrentFlag BIT NOT NULL
);

CREATE TABLE DimState
(
    StateSK INT IDENTITY(1,1) PRIMARY KEY,
    StateID_BK INT NOT NULL,          
    StateCode NVARCHAR(2) NOT NULL,
    StateName NVARCHAR(50) NOT NULL,
    TimeZone NVARCHAR(10) NOT NULL,
    RegionSK INT NOT NULL,           
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    CurrentFlag BIT NOT NULL
);

CREATE TABLE DimProduct
(
    ProductSK INT IDENTITY(1,1) PRIMARY KEY,
    ProductID_BK INT NOT NULL,       
    ProductSKU NVARCHAR(50) NOT NULL,
    ProductName NVARCHAR(50) NOT NULL,
    ProductCategory NVARCHAR(50) NOT NULL,
    ItemGroup NVARCHAR(50) NOT NULL,
    ChunkSK INT NOT NULL,            
    RetailPrice MONEY NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    CurrentFlag BIT NOT NULL
);

CREATE TABLE DimTime
(
    TimeSK INT IDENTITY(1,1) PRIMARY KEY,
    Date DATE NOT NULL,
    Day TINYINT NOT NULL,
    Month TINYINT NOT NULL,
    Year SMALLINT NOT NULL
);
CREATE TABLE FactSales
(
    FactSK INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber NCHAR(10) NOT NULL,
    OrderDateSK INT NOT NULL,         
    ShipDateSK INT NULL,              
    ProductSK INT NOT NULL,           
    StateSK INT NOT NULL,              
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(9,2) NOT NULL,
    DiscountAmount DECIMAL(9,2) NOT NULL,
    PromotionCode NVARCHAR(20) NULL
);

INSERT INTO DimTime (Date, Year,  Month, Day)
VALUES ('1900-01-01', 1900, 1, 1);

DECLARE @StartDate DATE = '2018-01-01';
DECLARE @EndDate DATE = '2025-12-31';

WITH Dates AS (
    SELECT @StartDate AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM Dates
    WHERE DateValue < @EndDate
)
INSERT INTO DimTime ( Date, Day, Month, Year)
SELECT
    DateValue,
    DAY(DateValue),
    MONTH(DateValue),
    YEAR(DateValue)
FROM Dates
OPTION (MAXRECURSION 0);