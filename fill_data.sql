select * from [user];

set IDENTITY_INSERT [USER] ON
INSERT into [USER] (ID, name, FAMILY, age, sex,USERNAME, pass)
VALUES 
(1,'sara', 'ahmadi',15,1, 's.ahmadi','123'),
(2,'sina', 'moghadam',16,0, 's.ahmadi','123'),
(3,'fatemeh', 'kamali',14,1, 's.ahmadi','123'),
(5,'nastaran', 'shayesteh',17,1, 's.ahmadi','123'),
(7,'kimia', 'ahmadi',18,1, 's.ahmadi','123'),
(8,'hamid', 'amoozgar',16,0, 's.ahmadi','123'),
(9,'ali', 'kazemi',18,0, 's.ahmadi','123'),
(10,'yaser', 'akbari',17,0, 's.ahmadi','123'),
(11,'arash', 'roozbehani',15,0, 's.ahmadi','123'),
(12,'mehran', 'salari',16,0, 's.ahmadi','123'),
(13,'golnar', 'saadat',18,1, 's.ahmadi','123'),
set IDENTITY_INSERT [USER] OFF

CREATE TABLE CITY (
    ID BIGINT IDENTITY(1,1), 
    NAME NVARCHAR(MAX),
    CONSTRAINT PK_CITY PRIMARY KEY (ID)
);

CREATE TABLE ADDRESS (
    ID BIGINT IDENTITY(1,1), 
    CITYID BIGINT,
    USERID BIGINT,
    ADDRESS NVARCHAR(MAX),
    POSTALCODE VARCHAR(10)
    CONSTRAINT PK_ADDRESS PRIMARY KEY (ID)
    CONSTRAINT FK_CITYID_CITY FOREIGN KEY (CITYID)
    REFERENCES CITY(ID),
    CONSTRAINT FK_USERID_USER FOREIGN KEY (USERID)
    REFERENCES [USER](ID)
);

INSERT into CITY
VALUES ('TEHRAN') , ('SHIRAZ') , ('AHVAZ')

INSERT into ADDRESS (CITYID , USERID , ADDRESS)
VALUEs 
    (1,1, 'khiaban 1'),
    (1,2, 'khiaban 2'),
    (1,3, 'khiaban 3'),
    (2,10, 'khiaban 41'),
    (2,5, 'khiaban 15'),
    (2,13, 'khiaban 51'),
    (3,9, 'khiaban 16'),
    (3,12, 'khiaban 61'),
    (1,11, 'khiaban 17'),
    (2,8, 'khiaban 10'),
    (1,7, 'khiaban 12')
;