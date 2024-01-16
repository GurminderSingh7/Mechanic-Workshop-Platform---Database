CREATE OR REPLACE PROCEDURE sp_checkInvalidEmailAddress(EmailAddress IN VARCHAR2)
AS
BEGIN
  IF NOT REGEXP_LIKE(EmailAddress, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$') THEN
    RAISE_APPLICATION_ERROR(-20003, 'The Email must be of the form: "XXX@XXXX.XXX"!');
  END IF;
END;
/


CREATE OR REPLACE PROCEDURE sp_checkInvalidTelephone(PhoneNumber IN VARCHAR)
AS
BEGIN
-- Check the format is OK, otherwise throw a unique error
IF NOT REGEXP_LIKE(PhoneNumber, '^\(\d{3}\) \d{3}-\d{4}$') THEN
RAISE_APPLICATION_ERROR (-20000, 'The telephone number must be of the form: "(xxx) xxx-xxxx"!');
END IF;
END;

CREATE TABLE Customers (

CusID int,
FirstName varchar(50),
LastName varchar(50),
PhoneNumber varchar(20),
EmailAddress varchar(60),
CONSTRAINT pk_CusID PRIMARY KEY (CusID)
);
ALTER TABLE Customers MODIFY FirstName VARCHAR2(50) NOT NULL;

ALTER TABLE Customers ADD CONSTRAINT unique_email UNIQUE (EmailAddress);
ALTER TABLE Customers ADD CONSTRAINT chk_phone_format CHECK (REGEXP_LIKE(PhoneNumber, '^\(\d{3}\) \d{3}-\d{4}$'));
ALTER TABLE Customers
ADD CONSTRAINT email_format_check
CHECK (REGEXP_LIKE(EmailAddress, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'));

CREATE OR REPLACE TRIGGER telephone_check
BEFORE INSERT OR UPDATE
ON Customers
FOR EACH ROW
DECLARE
var_tel varchar(45) := :NEW.PhoneNumber;
BEGIN
sp_checkInvalidTelephone (var_tel);
END;

CREATE OR REPLACE TRIGGER Email_check
BEFORE INSERT OR UPDATE
ON Customers
FOR EACH ROW
DECLARE
var_EM varchar(60) := :NEW.EmailAddress;
BEGIN
sp_checkInvalidEmailAddress (var_EM);
END;

CREATE TABLE Bicycle (
VINID varchar(60),
Make varchar(50),
Model_ varchar(50),
Size_ varchar(50),
CONSTRAINT pk_VINID PRIMARY KEY (VINID)
);

CREATE TABLE Mechanic (
MechID int,
FirstName varchar(50),
LastName varchar(50),
Experience int,
CONSTRAINT pk_MechID PRIMARY KEY (MechID)
);

CREATE TABLE Invoice (
InvoiceID INT PRIMARY KEY ,
Orderdatein date,
OrderDateOut date,
Price decimal(6,2),
CusID int,
VINID varchar(60),
CONSTRAINT fk_CusID FOREIGN KEY (CusID) REFERENCES customers(CusID),
CONSTRAINT fk_VINID FOREIGN KEY (VINID) REFERENCES Bicycle(VINID)
);

CREATE TABLE Problem (
ProID int,
Problem varchar(75),
InvoiceID int,
MechID int,
CONSTRAINT pk_ProID PRIMARY KEY (ProID),
CONSTRAINT fk_Invoice FOREIGN KEY (InvoiceID) REFERENCES Invoice (InvoiceID),
CONSTRAINT fk_MechID FOREIGN KEY (MechID) REFERENCES Mechanic(MechID)
);

INSERT INTO Customers VALUES ('101','John', 'Doe', '(123) 456-7890', 'john.doe@example.com');
INSERT INTO Customers VALUES (102, 'Jane', 'Smith', '(234) 567-8901', 'jane.smith@example.com');
INSERT INTO Customers VALUES (103, 'Bob', 'Johnson', '(345) 678-9012', 'bob.johnson@example.com');
INSERT INTO Customers VALUES (104, 'Alice', 'Williams', '(456) 789-0123', 'alice.williams@example.com');
INSERT INTO Customers VALUES (105, 'Charlie', 'Brown', '(567) 890-1234', 'charlie.brown@example.com');
INSERT INTO Customers VALUES (106, 'David', 'Wilson', '(678) 901-2345', 'david.wilson@example.com');
INSERT INTO Customers VALUES (107, 'Emma', 'Moore', '(789) 012-3456', 'emma.moore@example.com');
INSERT INTO Customers VALUES (108, 'Fay', 'Taylor', '(890) 123-4567', 'fay.taylor@example.com');
INSERT INTO Customers VALUES (109, 'Gary', 'Anderson', '(901) 234-5678', 'gary.anderson@example.com');
INSERT INTO Customers VALUES (110, 'Helen', 'Thomas', '(012) 345-6789', 'helen.thomas@example.com');
INSERT INTO Customers VALUES (111, 'Ivy', 'Jackson', '(123) 456-7890', 'ivy.jackson@example.com');
INSERT INTO Customers VALUES (112, 'James', 'White', '(234) 567-8901', 'james.white@example.com');
INSERT INTO Customers VALUES (113, 'Kate', 'Harris', '(345) 678-9012', 'kate.harris@example.com');
INSERT INTO Customers VALUES (114, 'Leo', 'Martin', '(456) 789-0123', 'leo.martin@example.com');
INSERT INTO Customers VALUES (115, 'Mia', 'Thompson', '(567) 890-1234', 'mia.thompson@example.com');

INSERT INTO Mechanic VALUES (201, 'Steve', 'Clark', 5);
INSERT INTO Mechanic VALUES (202, 'Amanda', 'Davis', 3);
INSERT INTO Mechanic VALUES (203, 'Brian', 'Evans', 4);
INSERT INTO Mechanic VALUES (204, 'Catherine', 'Fitzgerald', 2);
INSERT INTO Mechanic VALUES (205, 'Dennis', 'Garcia', 6);
INSERT INTO Mechanic VALUES (206, 'Eva', 'Hernandez', 1);
INSERT INTO Mechanic VALUES (207, 'Frank', 'Irwin', 5);
INSERT INTO Mechanic VALUES (208, 'Grace', 'Johnson', 2);
INSERT INTO Mechanic VALUES (209, 'Harry', 'Kelly', 3);
INSERT INTO Mechanic VALUES (210, 'Isabel', 'Lopez', 4);
INSERT INTO Mechanic VALUES (211, 'Jack', 'Martinez', 5);
INSERT INTO Mechanic VALUES (212, 'Karen', 'Nguyen', 1);
INSERT INTO Mechanic VALUES (213, 'Liam', 'Owens', 3);
INSERT INTO Mechanic VALUES (214, 'Megan', 'Patel', 4);
INSERT INTO Mechanic VALUES (215, 'Nathan', 'Quinn', 2);

INSERT INTO Bicycle VALUES('21HGD301', 'Trek', 'Marlin 5', 'Large');
INSERT INTO Bicycle VALUES('34ZWK402', 'Giant', 'Talon 3', 'Medium');
INSERT INTO Bicycle VALUES('45JGH503', 'Cannondale', 'Trail 7', 'Small');
INSERT INTO Bicycle VALUES('56LKM604', 'Specialized', 'Rockhopper', 'X-Large');
INSERT INTO Bicycle VALUES('67QPN705', 'Scott', 'Aspect 960', 'Medium');
INSERT INTO Bicycle VALUES('78RST806', 'Kona', 'Mahuna', 'Large');
INSERT INTO Bicycle VALUES('89UVX907', 'Marin', 'Pine Mountain 1', 'Small');
INSERT INTO Bicycle VALUES('90WVY108', 'Norco', 'Storm 1', 'Medium');
INSERT INTO Bicycle VALUES('12ABW209', 'Diamondback', 'Sync r', 'Large');
INSERT INTO Bicycle VALUES('23CDX310', 'Felt', 'Dispatch 9/70', 'Small');
INSERT INTO Bicycle VALUES('34EFY411', 'Jamis', 'DXT Comp', 'Medium');
INSERT INTO Bicycle VALUES('45GZH512', 'Mongoose', 'Argus Sport', 'Large');
INSERT INTO Bicycle VALUES('56HIJ613', 'Surly', 'Karate Monkey', 'Small');
INSERT INTO Bicycle VALUES('67JKL714', 'Salsa', 'Journeyman', 'Medium');
INSERT INTO Bicycle VALUES('78KLM815', 'GT', 'Aggressor Pro', 'Large');

INSERT INTO Invoice VALUES('1','2023-01-10', '2023-01-15', 150.00, 101, '21HGD301');
INSERT INTO Invoice VALUES('2','2023-02-20', '2023-02-25', 120.00, 102, '34ZWK402');
INSERT INTO Invoice VALUES(3,'2023-03-30', '2023-04-04', 200.00, 103, '45JGH503');
INSERT INTO Invoice VALUES(4,'2023-05-05', '2023-05-10', 180.00, 104, '56LKM604');
INSERT INTO Invoice VALUES(5,'2023-06-15', '2023-06-20', 160.00, 105, '67QPN705');
INSERT INTO Invoice VALUES(6,'2023-07-25', '2023-07-30', 170.00, 106, '78RST806');
INSERT INTO Invoice VALUES(7,'2023-08-05', '2023-08-10', 190.00, 107, '89UVX907');
INSERT INTO Invoice VALUES(8,'2023-09-15', '2023-09-20', 210.00, 108, '90WVY108');
INSERT INTO Invoice VALUES(9,'2023-10-25', '2023-10-30', 220.00, 109, '12ABW209');
INSERT INTO Invoice VALUES(10,'2023-11-05', '2023-11-10', 230.00, 110, '23CDX310');
INSERT INTO Invoice VALUES(11,'2023-12-15', '2023-12-20', 240.00, 111, '34EFY411');
INSERT INTO Invoice VALUES(12,'2024-01-25', '2024-01-30', 250.00, 112, '45GZH512');
INSERT INTO Invoice VALUES(13,'2024-02-05', '2024-02-10', 260.00, 113, '56HIJ613');
INSERT INTO Invoice VALUES(14,'2024-03-15', '2024-03-20', 270.00, 114, '67JKL714');
INSERT INTO Invoice VALUES(15,'2024-04-25', '2024-04-30', 280.00, 115, '78KLM815');


INSERT INTO Problem VALUES(301, 'Flat tire', 1, 201);
INSERT INTO Problem VALUES(302, 'Brake adjustment', 2, 202);
INSERT INTO Problem VALUES(303, 'Tune-up', 3, 203);
INSERT INTO Problem VALUES(304, 'Chain replacement', 4, 204);
INSERT INTO Problem VALUES(305, 'Wheel truing', 5, 205);
INSERT INTO Problem VALUES(306, 'Saddle adjustment', 6, 206);
INSERT INTO Problem VALUES(307, 'Handlebar adjustment', 7, 207);
INSERT INTO Problem VALUES(308, 'Headset adjustment', 8, 208);
INSERT INTO Problem VALUES(309, 'Pedal adjustment', 9, 209);
INSERT INTO Problem VALUES(310, 'Fork adjustment', 10, 210);
INSERT INTO Problem VALUES(311, 'Derailleur adjustment', 11, 211);
INSERT INTO Problem VALUES(312, 'Gear adjustment', 12, 212);
INSERT INTO Problem VALUES(313, 'Spoke replacement', 13, 213);
INSERT INTO Problem VALUES(314, 'Tire rotation', 14, 214);
INSERT INTO Problem VALUES(315, 'Suspension adjustment', 15, 215);

CREATE VIEW CustomerInvoices AS
SELECT c.CusID, c.FirstName, c.LastName, i.InvoiceID, i.Orderdatein, i.OrderDateOut, i.Price
FROM Customers c
JOIN Invoice i ON c.CusID = i.CusID;

CREATE TABLE Customers_History (
CusID INT,
FirstName VARCHAR(50),
LastName VARCHAR(50),
PhoneNumber VARCHAR(15),
EmailAddress VARCHAR(100),
STARTTIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ENDTIME TIMESTAMP,
Notes VARCHAR(255),
PRIMARY KEY (CusID, STARTTIME)
);

CREATE TABLE Invoice_History (
InvoiceID INT,
Orderdatein DATE,
OrderDateOut DATE,
Price DECIMAL(6,2),
CusID INT,
VINID VARCHAR(50),
STARTTIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ENDTIME TIMESTAMP,
Notes VARCHAR(255),
PRIMARY KEY (InvoiceID, STARTTIME),
FOREIGN KEY (CusID) REFERENCES Customers(CusID),
FOREIGN KEY (VINID) REFERENCES Bicycle(VINID)
);

CREATE TABLE Problem_History (
ProID INT,
ProblemDescription VARCHAR(255),
Price DECIMAL(6,2),
InvoiceID INT,
MechID INT,
STARTTIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ENDTIME TIMESTAMP,
Notes VARCHAR(255),
PRIMARY KEY (ProID, STARTTIME),
FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID),
FOREIGN KEY (MechID) REFERENCES Mechanic(MechID)
);

CREATE TRIGGER trg_CustomersHistory_AfterInsert
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
INSERT INTO Customers_History (CusID, FirstName, LastName, PhoneNumber, EmailAddress, STARTTIME)
VALUES (:NEW.CusID, :NEW.FirstName, :NEW.LastName, :NEW.PhoneNumber, :NEW.EmailAddress, CURRENT_TIMESTAMP);
END;

CREATE TRIGGER trg_InvoiceHistory_AfterUpdate
AFTER UPDATE ON Invoice
FOR EACH ROW
BEGIN
INSERT INTO Invoice_History (InvoiceID, Orderdatein, OrderDateOut, Price, CusID, VINID, STARTTIME)
VALUES (:OLD.InvoiceID, :OLD.Orderdatein, :OLD.OrderDateOut, :OLD.Price, :OLD.CusID, :OLD.VINID, CURRENT_TIMESTAMP);
END;

CREATE TRIGGER trg_InvoiceHistory_AfterDelete
AFTER DELETE ON Invoice
FOR EACH ROW
BEGIN
INSERT INTO Invoice_History (InvoiceID, Orderdatein, OrderDateOut, Price, CusID, VINID, STARTTIME)
VALUES (:OLD.InvoiceID, :OLD.Orderdatein, :OLD.OrderDateOut, :OLD.Price, :OLD.CusID, :OLD.VINID, CURRENT_TIMESTAMP);
END;

CREATE TRIGGER trg_CustomersHistory_AfterUpdate
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
INSERT INTO Customers_History (CusID, FirstName, LastName, PhoneNumber, EmailAddress, STARTTIME, ENDTIME)
VALUES (:OLD.CusID, :OLD.FirstName, :OLD.LastName, :OLD.PhoneNumber, :OLD.EmailAddress, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END;

CREATE TRIGGER trg_InvoiceHistory_AfterInsert
AFTER INSERT ON Invoice
FOR EACH ROW
BEGIN
INSERT INTO Invoice_History (InvoiceID, Orderdatein, OrderDateOut, Price, CusID, VINID, STARTTIME)
VALUES (:NEW.InvoiceID, :NEW.Orderdatein, :NEW.OrderDateOut, :NEW.Price, :NEW.CusID, :NEW.VINID, CURRENT_TIMESTAMP);
END;

CREATE OR REPLACE TRIGGER trg_ProblemHistory_AfterInsert
AFTER INSERT ON Problem
FOR EACH ROW
BEGIN
INSERT INTO Problem_History (PROID, PROBLEMDESCRIPTION, PRICE, INVOICEID, MECHID, STARTTIME)
VALUES (:NEW.PROID, NULL, NULL, :NEW.INVOICEID, :NEW.MECHID, CURRENT_TIMESTAMP);
END;

CREATE TRIGGER trg_ProblemHistory_AfterUpdate
AFTER UPDATE ON PROBLEM
FOR EACH ROW
BEGIN
INSERT INTO Problem_History (PROID, PROBLEMDESCRIPTION, PRICE, INVOICEID, MECHID, STARTTIME)
VALUES (:OLD.PROID, NULL, NULL, :OLD.INVOICEID, :OLD.MECHID, CURRENT_TIMESTAMP);
END;

CREATE TRIGGER trg_ProblemHistory_AfterDelete
AFTER DELETE ON PROBLEM
FOR EACH ROW
BEGIN
INSERT INTO Problem_History (PROID, PROBLEMDESCRIPTION, PRICE, INVOICEID, MECHID, STARTTIME)
VALUES (:OLD.PROID, NULL, NULL, :OLD.INVOICEID, :OLD.MECHID, CURRENT_TIMESTAMP);
END;

CREATE OR REPLACE TRIGGER check_dates_before_insert
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
IF :NEW.OrderDateOut < :NEW.Orderdatein THEN
RAISE_APPLICATION_ERROR(-20001, 'OrderDateOut cannot be earlier than Orderdatein');
END IF;
END;
SELECT* FROM CUSTOMERS;
INSERT INTO Customers VALUES ('116','najib', 'abdul', '(444) 444-4444', 'najib.abdul@example.com');

UPDATE CUSTOMERS 
SET PhoneNumber = '(794) 444-8929'
where CusID = 116;

delete from customers 
where CusID =116;
SELECT* FROM customerS_history
where CusID =116 ;
SELECT * FROM bicycle ;
INSERT INTO Invoice VALUES ('16', '26-12-02', '26-12-04', '444', NULL, '78KLM815');
UPDATE INVOICE 
SET PRICE ='888'
WHERE INVOICEID ='16';
DELETE FROM INVOICE WHERE INVOICEID=16;

INSERT INTO PROBLEM VALUES ('400', 'FRONT DESK', '15', '213');
UPDATE PROBLEM SET INVOICEID = 14
WHERE PROID = 400;
 DELETE FROM PROBLEM 
 WHERE PROID = 400;

SELECT * FROM  Problem_History;

CREATE VIEW RepairDetails AS
SELECT c.FirstName AS CustomerFirstName,
       c.LastName AS CustomerLastName,
       b.Make AS bicycleMake,
       b.Model_ AS BicycleModel,
       m.FirstName AS MechanicFirstName,
       m.LastName AS MechanicLastName,
       p.Problem AS RepairProblem,
       i.OrderDatein,
       i.OrderDateOut
FROM customers c
JOIN Invoice i ON c.CusID = i.CusID
JOIN Bicycle b ON i.VINID = b.VINID
JOIN Problem p ON i.InvoiceID = p.InvoiceID
JOIN Mechanic m ON p.MechID = m.MECHID;