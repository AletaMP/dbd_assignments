
-- assignment 1 relational datamodel

-- create the database
CREATE DATABASE Company;
GO


-- create the tables
USE Company
go

CREATE TABLE Employee(
                         FName nvarchar(50),
                         Minit char(1),
                         LName nvarchar(50),
                         SSN numeric(9,0) not null,
                         BDate datetime,
                         Address nvarchar(50),
                         Sex char(1),
                         Salary numeric(10,2),
                         SuperSSN numeric(9,0),
                         Dno int
);
GO

CREATE TABLE Department (
                         DName nvarchar(50),
                         DNumber int not null,
			 BDate datetime,
                         MgrSSN numeric(9,0),
                         MgrStartDate datetime
);
GO


-- alter the tables

ALTER TABLE Employee
add primary key (SSN)
go

ALTER TABLE Department
add primary key(DNumber)
go

ALTER TABLE Employee
add foreign key (Dno)
references Department(DNumber)
go

ALTER TABLE Employee
add foreign key (SuperSSN)
references Employee
go

ALTER TABLE Department
add foreign key (MgrSSN)
references Employee
go


-- add the remaining relations and constraints

CREATE TABLE Dept_Locations(
	DNumber int not null references Department(DNumber),
	DLocation nvarchar(50) not null,
	primary key (DNumber, DLocation)
)
go

CREATE TABLE Project(
	PName nvarchar(50),
	PNumber int primary key not null,
	PLocation nvarchar(50),
	Dnum int references Department(DNumber)
)
go

CREATE TABLE Works_on(
        Essn numeric(9,0) not null references Employee(SSN),
        Pno int not null references Project(PNumber),
        Hours float,
	primary key (Essn, Pno)
)
go

CREATE TABLE Dependent(
	Essn numeric(9,0) not null REFERENCES Employee(SSN),
	Dependent_Name nvarchar(50) not null,
	Sex char(1),
	BDate datetime,
	Relationsship nvarchar(50),
	primary key (Essn, Dependent_name)
)
go

