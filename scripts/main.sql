CREATE DATABASE MediaOrganizerApp;
USE MediaOrganizerApp;

DROP TABLE IF EXISTS dbo.[user];

CREATE TABLE [user] ( 
    id INT IDENTITY(1,1) PRIMARY KEY, 
    email NVARCHAR(255) UNIQUE NOT NULL, 
    passwordHash NVARCHAR(255) NOT NULL,
    firstName NVARCHAR(255) NOT NULL,
    lastName NVARCHAR(255) NOT NULL,
);