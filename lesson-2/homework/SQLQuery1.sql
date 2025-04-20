use lessons;
go

--1

drop table if exists test_identity;
create table test_identity
(
	id INT IDENTITY(1, 1),
	name VARCHAR(50) NOT NULL
);

INSERT INTO test_identity (name) VALUES ('Alice');
INSERT INTO test_identity (name) VALUES ('John');
INSERT INTO test_identity (name) VALUES ('Charlie');
INSERT INTO test_identity (name) VALUES ('David');
INSERT INTO test_identity (name) VALUES ('Eve');


DELETE FROM test_identity WHERE id=2;
SELECT * FROM test_identity;
INSERT INTO test_identity (name)
SELECT 'John';
SELECT * FROM test_identity;


DELETE FROM test_identity;
SELECT * FROM test_identity;
INSERT INTO test_identity (name)
SELECT 'John';
SELECT * FROM test_identity;


TRUNCATE TABLE test_identity;
SELECT * FROM test_identity;
INSERT INTO test_identity (name)
SELECT 'John';
SELECT * FROM test_identity;


/*
1. the count of identity remains at the point where it stopped (the data inside table is erased)
2. the count of identity gets reseted to starting point (the data inside table is erased)
3. the table would be deleted completely
*/


--2 

drop table if exists data_types_demo;
create table data_types_demo
(
	id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	name varchar(50) NOT NULL,
	price  DEC(12, 2) CHECK (price>=0),
	created_date DATETIME DEFAULT GETDATE(),
	is_available BIT DEFAULT 1,
	product_image VARBINARY(MAX)
);

INSERT INTO data_types_demo (name, price, is_available, product_image) 
SELECT 'Mac', 999.99, 1, NULL;

SELECT * FROM data_types_demo;


--3

drop table if exists photos;
create table photos
(
	id UNIQUEIDENTIFIER DEFAULT NEWID(),
	photo VARBINARY(MAX)
);

insert into photos (photo)
select * from openrowset(
BULK 'C:\Users\AKTIV\sql\lesson-2\homework\images.jpg', SINGLE_BLOB
) AS img;

select * from photos;


--4

drop table if exists student;
create table student
(
	name VARCHAR(50) NOT NULL,
	classes INT CHECK(classes >=0),
	tution_per_class DEC(10, 2) CHECK(tution_per_class >= 0),
	total_tution AS (classes * tution_per_class) PERSISTED
);

INSERT INTO student
VALUES 
    ('John', 5, 299.00), 
    ('Alice', 3, 199.00), 
    ('Smith', 4, 149.50);

SELECT * FROM student;




