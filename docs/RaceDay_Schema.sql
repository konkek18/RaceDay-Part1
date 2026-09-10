-- ============================================
-- RACEDAY DATABASE SCHEMA - PART 1
-- SQL Server (SSMS) Compatible
-- ============================================

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'RaceDayDB')
    DROP DATABASE RaceDayDB;
GO

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

-- 1. USERS TABLE
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    DateRegistered DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- 2. VENUES TABLE
CREATE TABLE Venues (
    VenueID INT IDENTITY(1,1) PRIMARY KEY,
    VenueName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Province NVARCHAR(50) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0)
);
GO

-- 3. EVENTS TABLE
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    VenueID INT NOT NULL,
    EventName NVARCHAR(100) NOT NULL,
    EventDate DATETIME NOT NULL,
    Description NVARCHAR(500) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Upcoming'
        CHECK (Status IN ('Upcoming', 'Ongoing', 'Completed', 'Cancelled')),
    CONSTRAINT FK_Events_Users FOREIGN KEY (OrganiserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Events_Venues FOREIGN KEY (VenueID) REFERENCES Venues(VenueID)
);
GO

-- 4. CATEGORIES TABLE
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName NVARCHAR(50) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL CHECK (DistanceKm > 0),
    AgeGroup NVARCHAR(20) NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL CHECK (EntryFee >= 0),
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);
GO

-- 5. ENROLMENTS TABLE
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')),
    BibNumber NVARCHAR(10) NULL UNIQUE,
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- 6. RESULTS TABLE
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NULL,
    OverallPosition INT NULL,
    CategoryPosition INT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'DNS'
        CHECK (Status IN ('DNS', 'DNF', 'Finished')),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID)
);
GO

-- SEED DATA
INSERT INTO Users (Email, PasswordHash, FullName, Role) VALUES
('thabo@runevents.co.za', 'hash123', 'Thabo Nkosi', 'Organiser'),
('linda@cycle.co.za', 'hash456', 'Linda van der Merwe', 'Organiser'),
('siya@runner.com', 'hash789', 'Siya Mthembu', 'Participant'),
('emily@walk.co.za', 'hash101', 'Emily Jacobs', 'Participant');

INSERT INTO Venues (VenueName, Address, City, Province, Capacity) VALUES
('Moses Mabhida Stadium', '44 Isaiah Ntshangase Rd', 'Durban', 'KwaZulu-Natal', 5000),
('Green Point Park', 'Fritz Sonnenberg Rd', 'Cape Town', 'Western Cape', 3000),
('FNB Stadium', 'Nasrec Rd', 'Johannesburg', 'Gauteng', 8000);

INSERT INTO Events (OrganiserID, VenueID, EventName, EventDate, Description, Status) VALUES
(1, 1, 'Durban City Marathon', '2026-10-15 06:00:00', 'Annual marathon through Durban.', 'Upcoming'),
(2, 2, 'Cape Town Cycle Tour', '2026-11-20 05:30:00', 'Cycle tour around the Cape Peninsula.', 'Upcoming'),
(1, 3, 'Soweto 10km Run', '2026-12-05 07:00:00', 'Community run through Soweto.', 'Upcoming');

INSERT INTO Categories (EventID, CategoryName, DistanceKm, AgeGroup, EntryFee) VALUES
(1, 'Full Marathon 42.2km Senior', 42.20, '18-39', 250.00),
(1, 'Half Marathon 21.1km Veteran', 21.10, '40-59', 180.00),
(1, '10km Fun Run', 10.00, 'All ages', 80.00),
(2, '109km Elite', 109.00, '18-35', 400.00),
(2, '109km Open', 109.00, '36-55', 350.00),
(2, '42km Family Ride', 42.00, 'All ages', 150.00),
(3, '10km Senior', 10.00, '18-40', 120.00),
(3, '5km Walk', 5.00, 'All ages', 60.00);

INSERT INTO Enrolments (ParticipantID, CategoryID, Status, BibNumber) VALUES
(3, 1, 'Confirmed', 'A1234'),
(4, 4, 'Pending', NULL),
(3, 7, 'Confirmed', 'B5678');

INSERT INTO Results (EnrolmentID, FinishTime, OverallPosition, CategoryPosition, Status) VALUES
(1, '03:45:22', 120, 5, 'Finished'),
(3, '00:48:15', 45, 3, 'Finished');

