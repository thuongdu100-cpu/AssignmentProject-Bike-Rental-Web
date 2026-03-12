	/* =========================================
   BIKE RENTAL – SQL Server (Unicode Version)
   ========================================= */
IF DB_ID(N'BikeRental') IS NULL
    CREATE DATABASE BikeRental;
GO
USE BikeRental;
GO

/* ========== DROP (để chạy lại) ========== */
IF OBJECT_ID(N'dbo.Payments','U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID(N'dbo.Rentals','U') IS NOT NULL DROP TABLE dbo.Rentals;
IF OBJECT_ID(N'dbo.Bikes','U') IS NOT NULL DROP TABLE dbo.Bikes;
IF OBJECT_ID(N'dbo.BikeModels','U') IS NOT NULL DROP TABLE dbo.BikeModels;
IF OBJECT_ID(N'dbo.PricingPlans','U') IS NOT NULL DROP TABLE dbo.PricingPlans;
IF OBJECT_ID(N'dbo.Stations','U') IS NOT NULL DROP TABLE dbo.Stations;
IF OBJECT_ID(N'dbo.Users','U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID(N'dbo.Roles','U') IS NOT NULL DROP TABLE dbo.Roles;
GO

/* ========== ROLES ========== */
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    RoleDescription NVARCHAR(255)
);
GO

/* ========== USERS ========== */
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(20),
    RoleID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

/* ========== STATIONS ========== */
CREATE TABLE Stations (
    StationID INT IDENTITY(1,1) PRIMARY KEY,
    StationCode NVARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    Capacity INT NOT NULL CHECK (Capacity >= 0),
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);
GO

/* ========== BIKE MODELS ========== */
CREATE TABLE BikeModels (
    ModelID INT IDENTITY(1,1) PRIMARY KEY,
    ModelName NVARCHAR(100) NOT NULL,
    Brand NVARCHAR(100),
    TypeName NVARCHAR(30) NOT NULL,   -- standard, ebike, cargo
    WeightKg DECIMAL(5,2),
    HasBattery BIT DEFAULT 0,
    CONSTRAINT CK_BikeModels_Type CHECK (TypeName IN (N'standard',N'ebike',N'cargo'))
);
GO

/* ========== BIKES (THÊM ẢNH XE) ========== */
CREATE TABLE Bikes (
    BikeID INT IDENTITY(1,1) PRIMARY KEY,
    SerialNumber NVARCHAR(50) NOT NULL UNIQUE,
    ModelID INT NOT NULL REFERENCES BikeModels(ModelID),
    CurrentStationID INT NULL REFERENCES Stations(StationID),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN (N'available',N'in_use',N'lost',N'maintenance')),
    BatteryPercent TINYINT CHECK (BatteryPercent BETWEEN 0 AND 100),
    ImageURL NVARCHAR(500) NULL,   -- đường dẫn hoặc URL ảnh xe
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO
CREATE INDEX IX_Bikes_Station_Status ON Bikes(CurrentStationID, Status);
GO

/* ========== PRICING PLANS ========== */
CREATE TABLE PricingPlans (
    PlanID INT IDENTITY(1,1) PRIMARY KEY,
    PlanName NVARCHAR(100) NOT NULL UNIQUE,
    UnlockFee DECIMAL(10,2) DEFAULT 0,
    PricePerMin DECIMAL(10,2) DEFAULT 0,
    FreeMinutes INT DEFAULT 0,
    DailyCap DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

/* ========== RENTALS ========== */
CREATE TABLE Rentals (
    RentalID BIGINT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL REFERENCES Users(UserID),
    BikeID INT NOT NULL REFERENCES Bikes(BikeID),
    PlanID INT NULL REFERENCES PricingPlans(PlanID),
    StartStationID INT NOT NULL REFERENCES Stations(StationID),
    EndStationID INT NULL REFERENCES Stations(StationID),
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NULL,
    CostAmount DECIMAL(10,2),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN (N'ongoing',N'completed',N'canceled')),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO
CREATE INDEX IX_Rentals_User ON Rentals(CustomerID, StartTime);
CREATE INDEX IX_Rentals_Bike ON Rentals(BikeID, StartTime);
GO

/* ========== PAYMENTS ========== */
CREATE TABLE Payments (
    PaymentID BIGINT IDENTITY(1,1) PRIMARY KEY,
    RentalID BIGINT NOT NULL REFERENCES Rentals(RentalID),
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Currency NVARCHAR(10) DEFAULT N'VND',
    Method NVARCHAR(20) NOT NULL CHECK (Method IN (N'cash',N'card',N'ewallet')),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN (N'pending',N'paid',N'failed',N'refunded')),
    TransactionRef NVARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

/* ========== DỮ LIỆU MẪU ========== */
INSERT INTO Roles (RoleName, RoleDescription)
VALUES 
(N'Admin',N'Toàn quyền quản lý hệ thống'),
(N'Staff',N'Nhân viên quản lý xe và trạm'),
(N'Customer',N'Khách hàng thuê xe');

INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
VALUES 
(N'Admin User', N'admin@gmail.com', N'1', N'0123456789', 1),
(N'Staff User', N'staff@gmail.com', N'1', N'0987654321', 2),
(N'Khách hàng A', N'cust@gmail.com', N'1', N'0909090909', 3);

INSERT INTO Stations (StationCode, Name, Address, Capacity)
VALUES 
(N'ST01', N'Công viên Trung tâm', N'123 Đường Chính', 30),
(N'ST02', N'Bờ sông Riverside', N'456 Đường Ven Sông', 20);

INSERT INTO BikeModels (ModelName, Brand, TypeName, WeightKg, HasBattery)
VALUES 
(N'City Bike', N'Velo', N'standard', 15.5, 0),
(N'EcoRide E1', N'Eco', N'ebike', 22.0, 1);

INSERT INTO Bikes (SerialNumber, ModelID, CurrentStationID, Status, BatteryPercent, ImageURL)
VALUES 
(N'SN0001', 1, 1, N'available', NULL, N'https://fxbike.vn/wp-content/uploads/2025/05/Banner2.jpg'),
(N'SN0002', 2, 1, N'available', 95, N'https://embed-ssl.wistia.com/deliveries/3507c3f3559ef346b55c0617f05e631f83802dc7.webp?image_crop_resized=1920x1080');

INSERT INTO PricingPlans (PlanName, UnlockFee, PricePerMin, FreeMinutes, DailyCap)
VALUES 
(N'Gói Cơ bản', 2000, 500, 5, 100000),
(N'Gói Cao cấp', 3000, 400, 10, 80000);
GO


/* ========== DỮ LIỆU MẪU BỔ SUNG ========== */

/* ROLES đã có */

/* USERS (thêm khách hàng & nhân viên mới) */
INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
VALUES 
(N'Nguyễn Văn B', N'customer1@gmail.com', N'1', N'0911111111', 3),
(N'Trần Thị C', N'customer2@gmail.com', N'1', N'0922222222', 3),
(N'Lê Văn D', N'staff2@gmail.com', N'1', N'0933333333', 2),
(N'Phạm Thị E', N'staff3@gmail.com', N'1', N'0944444444', 2);

/* STATIONS (thêm vài trạm mới) */
INSERT INTO Stations (StationCode, Name, Address, Capacity)
VALUES
(N'ST03', N'Trạm Đại học FPT', N'Khu Công nghệ cao, Quận 9', 40),
(N'ST04', N'Trạm Trung tâm Thương mại', N'789 Đường Số 9', 25),
(N'ST05', N'Trạm Ga Metro', N'12 Nguyễn Văn Linh', 30);

/* BIKE MODELS (thêm các mẫu mới) */
INSERT INTO BikeModels (ModelName, Brand, TypeName, WeightKg, HasBattery)
VALUES
(N'Cargo Pro', N'UrbanMove', N'cargo', 35.0, 0),
(N'E-Scoot 300', N'Voltix', N'ebike', 19.0, 1),
(N'Street Rider', N'Velo', N'standard', 16.0, 0);

/* BIKES (mỗi trạm có vài xe) */
INSERT INTO Bikes (SerialNumber, ModelID, CurrentStationID, Status, BatteryPercent, ImageURL)
VALUES
(N'SN0003', 1, 2, N'available', NULL, N'https://xebaonam.com/mediacenter/media/images/1155/products/1155/2663/s500_500/xe-may-dien-vinfast-klara-mau-xam-1593239879.jpg'),
(N'SN0004', 2, 2, N'in_use', 60, N'https://thanhnien.mediacdn.vn/Uploaded/chicuong/2022_02_21/vinfast-vento-3-1232.jpg'),
(N'SN0005', 3, 3, N'available', 88, N'https://www.baolongan.vn/image/news/2024/20240825/images/VinFast%20DrgnFly-bao-long-an-1.webp'),
(N'SN0006', 4, 3, N'maintenance', NULL, N'https://cdn.24h.com.vn/upload/1-2025/images/2025-03-16/Gia-xe-may-dien-VinFast-moi-nhat-thang-3-2025-re-nhat-tu-179-trieu-dong-vin1-1742111770-156-width740height606.jpg'),
(N'SN0007', 5, 4, N'available', 90, N'https://sonq1.com.vn/sonq1/upload/images/295675203_2712662575545446_4675514911691924429_n.jpg');


/* PRICING PLANS (thêm các gói mở rộng) */
INSERT INTO PricingPlans (PlanName, UnlockFee, PricePerMin, FreeMinutes, DailyCap)
VALUES
(N'Gói Sinh viên', 1000, 300, 10, 50000),
(N'Gói Gia đình', 2500, 350, 15, 90000),
(N'Gói Du lịch', 5000, 450, 20, 120000);

/* RENTALS (thêm vài lượt thuê xe mẫu) */
INSERT INTO Rentals (CustomerID, BikeID, PlanID, StartStationID, EndStationID, StartTime, EndTime, CostAmount, Status)
VALUES
(3, 1, 1, 1, 2, '2025-11-10 08:00', '2025-11-10 08:45', 12000, N'completed'),
(4, 2, 2, 1, 1, '2025-11-11 09:15', '2025-11-11 09:45', 9000, N'completed'),
(5, 15, 3, 2, 3, '2025-11-11 07:30', NULL, NULL, N'ongoing'),
(6, 16, 4, 3, NULL, '2025-11-11 10:00', NULL, NULL, N'ongoing'),
(4, 17, 1, 2, 4, '2025-11-09 14:10', '2025-11-09 14:45', 8000, N'completed'),
(3, 18, 2, 1, 2, '2025-11-07 16:00', '2025-11-07 17:15', 18000, N'completed');

/* PAYMENTS (tương ứng với các rental đã hoàn thành) */
INSERT INTO Payments (RentalID, Amount, Method, Status, TransactionRef)
VALUES
(7, 12000, N'ewallet', N'paid', N'TXN001'),
(8, 9000, N'card', N'paid', N'TXN002'),
(10, 8000, N'cash', N'paid', N'TXN003'),
(11, 18000, N'ewallet', N'paid', N'TXN004');
GO
