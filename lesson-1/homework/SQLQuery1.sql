use lessons;
go


--=========================
--       Task 1
--=========================


drop table if exists student;
CREATE TABLE student (
    id INTEGER,
    name VARCHAR(100),
    age INTEGER
);
ALTER TABLE student
ALTER COLUMN id INT NOT NULL;

--=========================
--       Task 2
--=========================

drop table if exists product;

CREATE TABLE product (
    product_id INT CONSTRAINT UQ_product_product_id UNIQUE,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);


ALTER TABLE product
DROP CONSTRAINT UQ_product_product_id;


ALTER TABLE product
ADD CONSTRAINT UQ_product_id_name UNIQUE (product_id, product_name);


--=========================
--       Task 3
--=========================
drop table if exists orders;

CREATE TABLE orders (
    order_id INT CONSTRAINT PK_orders_order_id PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE
);

ALTER TABLE orders
DROP CONSTRAINT PK_orders_order_id;


ALTER TABLE orders
ADD CONSTRAINT PK_orders_order_id PRIMARY KEY (order_id);



--=========================
--       Task 4
--=========================
drop table if exists category;

CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);


CREATE TABLE item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category_id INT CONSTRAINT FK_item_category FOREIGN KEY REFERENCES category(category_id)
);


ALTER TABLE item
DROP CONSTRAINT FK_item_category;


ALTER TABLE item
ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id);


--=========================
--       Task 5
--=========================
drop table if exists account;  
CREATE TABLE account (
    account_id INT PRIMARY KEY,
    balance DECIMAL(10, 2) CHECK (balance >= 0),  
    account_type VARCHAR(50) CHECK (account_type IN ('Saving', 'Checking')) 
);

insert into account
values 
(1, 2.5, 'Saving'),
(2, 2.5, 's')
select * from account;



ALTER TABLE account
DROP CONSTRAINT CK__account__account__6FE99F9F;

ALTER TABLE account
DROP CONSTRAINT [CK__account__balance__6EF57B66];


insert into account
values 
(3, 2.5, 'Saving'),
(4, 2.5, 's')

select * from account;


ALTER TABLE account
ADD CONSTRAINT CK_account_balance CHECK (balance >= 0);

ALTER TABLE account
ADD CONSTRAINT CK_account_account_type CHECK (account_type IN ('Saving', 'Checking'));

--=========================
--       Task 6
--=========================

DROP TABLE IF EXISTS customer

CREATE TABLE customer
(
    customer_id INT PRIMARY KEY,
	name VARCHAR(55),
	city VARCHAR(255) CONSTRAINT DF_city DEFAULT 'Uknown'
);

ALTER TABLE customer DROP CONSTRAINT DF_city;

ALTER TABLE customer ADD CONSTRAINT DF_city DEFAULT 'Uknown' FOR city;


-- Task 7

DROP TABLE IF EXISTS invoice;

CREATE TABLE invoice
(
	invoice_id INT IDENTITY(1, 1), --default values are also 1 and 1
	amount DECIMAL(10,2)
);

INSERT INTO invoice (amount)
VALUES
	(100.50),
	(200.75),
	(150.00),
	(300.25),
	(400.80);

SELECT * FROM invoice;

SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id) VALUES (100);

SET IDENTITY_INSERT invoice OFF;

-- Task 8

DROP TABLE IF EXISTS books;

CREATE TABLE books
(
	book_id INT PRIMARY KEY IDENTITY,
	title VARCHAR(255) NOT NULL,
	price DECIMAL(10,2) CHECK(price > 0),
	genre VARCHAR(255) DEFAULT 'Unknown'
)

INSERT INTO books (title, price) VALUES ('Untitled Book', 20.00);

INSERT INTO books (title, price, genre) VALUES (NULL, 10.99, 'Mystery');

INSERT INTO books (title, price, genre) VALUES ('Free Book', 0, 'Education');

INSERT INTO books (title, price, genre) VALUES ('Free Book', 0.01, 'Education');

SELECT * FROM books;


-- task 9

DROP DATABASE IF EXISTS library;

CREATE DATABASE library;

USE library;

DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Loan;

CREATE TABLE Book (
    book_id INT IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year INT CHECK (published_year > 0)
);

CREATE TABLE Member (
    member_id INT IDENTITY PRIMARY KEY,
    name VARCHAR(55) NOT NULL,
    email VARCHAR(255) UNIQUE DEFAULT 'No email',
    phone_number VARCHAR(20) NOT NULL
);


CREATE TABLE Loan (
    loan_id INT IDENTITY PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT FK_Book FOREIGN KEY (book_id) REFERENCES Book(book_id),
    CONSTRAINT FK_Member FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

INSERT INTO Member (name, email, phone_number) 
VALUES
	('Alice', 'alice@example.com', '123-456-7890'),
	('Bob', 'bob@example.com', '987-654-3210'),
	('John', 'john@example.com', '555-666-7777');


INSERT INTO Book (title, author, published_year) VALUES
    ('1984', 'George Orwell', 1949),
    ('To Kill a Mockingbird', 'Harper Lee', 1960),
    ('The Great Gatsby', 'F.Scott Fitzgerald', 1925);



INSERT INTO Loan (book_id, member_id, loan_date) VALUES (1, 1, '2024-02-01');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 2, '2024-02-03');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (3, 3, '2024-02-05');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 1, '2024-02-10');


SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM Loan;


