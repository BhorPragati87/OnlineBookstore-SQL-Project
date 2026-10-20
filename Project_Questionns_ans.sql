CREATE DATABASE OnlineBookstore;
-- Switch to the database
use OnlineBookstore;
-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE
'C:/Users/ASUS/Downloads/Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/ASUS/Downloads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/ASUS/Downloads/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM Books;
SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
  
select * from books
where genre = "Fiction";

-- 2) Find books published after the year 1950:
select * from books
where Published_Year > 1950;

-- 3) List all customers from the Canada:
SELECT *
FROM Customers
WHERE TRIM(Country) LIKE '%Canada%';

-- 4) Show orders placed in November 2023:
 select * from orders
 where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
    select sum(Stock) as total_stock
    from books;

-- 6) Find the details of the most expensive book:
   select * from books
   order by Price desc
   limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders
where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where Total_AmounT >20;

-- 9) List all genres available in the Books table:
select distinct genre FROM Books;

-- 10) Find the book with the lowest stock:
select * FROM BOOKS 
order by STOCK asc
limit 1;

-- 11) Calculate the total revenue generated from all orders:

select sum(Total_Amount) as total_revenue from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT 
    b.genre, SUM(O.Quantity) AS total_number_books
FROM
    BOOKS B
        JOIN
    ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT 
    genre, AVG(PRICE) AS avg_price
FROM
    books
WHERE
    genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT 
    Customer_ID, COUNT(Order_ID) AS Order_ID
FROM
    orders
GROUP BY Customer_ID
HAVING Order_ID >= 2;

-- 4) Find the most frequently ordered book:
SELECT 
    b.book_id, b.Title, COUNT(o.order_id) AS count_book
FROM
    orders o
        JOIN
    books b ON o.book_id = b.book_id
GROUP BY book_id
ORDER BY count_book DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT 
    *
FROM
    books
WHERE
    genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:
     SELECT 
    b.author, SUM(O.quantity) AS TOTAL_quantity
FROM
    ORDERS O
        JOIN
    BOOKS B ON B.BOOK_ID = O.BOOK_ID
GROUP BY b.author
ORDER BY TOTAL_quantity;

-- 7) List the cities where customers who spent over $30 are located:
		SELECT DISTINCT
    c.city, total_amount
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.Total_Amount > 30;

-- 8) Find the customer who spent the most on orders:
  SELECT 
    c.customer_id, c.name, SUM(o.Total_Amount) AS max_order
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY max_order DESC
LIMIT 1;
   
-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT 
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.Quantity), 0) AS order_quantity,
    b.stock - COALESCE(SUM(o.Quantity), 0) AS remaining_order_quantity
FROM
    books b
        LEFT JOIN
    orders o ON b.book_id = o.book_id
GROUP BY b.book_id;



