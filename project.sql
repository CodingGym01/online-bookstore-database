CREATE TABLE books(
Book_ID	SERIAL	PRIMARY KEY,
Title	VARCHAR(100),	
Author	VARCHAR(100),	
Genre	VARCHAR(50),	
Published_Year	INT,	
Price	NUMERIC(10,2),	
Stock INT
);

DROP TABLE IF EXISTS books;

COPY
Books(Book_ID,	Title,	Author,	Genre,	Published_Year,	Price,	Stock)
FROM 'C:/sers/Harsh chauhan/Downloads/PostgreSQL/SQL_Resume_Project-main/Books.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM books;

CREATE TABLE Customers(
Customer_ID	SERIAL	PRIMARY KEY,
Name	VARCHAR(100),	
Email	VARCHAR(100),	
Phone	VARCHAR(15)	,
City	VARCHAR(50),	
Country	VARCHAR(150)	
);

DROP TABLE IF EXISTS Customers;

SELECT * FROM Customers;

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders(
Order_ID	SERIAL	PRIMARY KEY,
Customer_ID	INT	REFERENCES Customers(Customer_ID),
Book_ID	INT REFERENCES Books(Book_ID),
Order_Date	DATE,	
Quantity	INT	,
Total_Amount	NUMERIC(10,2)	
);


SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre
SELECT * FROM books
WHERE genre= 'Fiction';

-- 2) Find books published after the year 1950
SELECT * FROM books
WHERE published_year>1950;

-- 3) List all customers from the Canada
SELECT * FROM Customers
WHERE country='Canada';

-- 4) Show orders placed in November 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
SELECT SUM(stock) AS total_stock
FROM books;

SELECT SUM(stock) AS fiction_stock FROM books
WHERE genre = 'Fiction';

-- 6) Find the details of the most expensive book
SELECT * FROM books
ORDER BY price DESC;
LIMIT 3;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT * FROM Orders
WHERE quantity>1
ORDER BY quantity;

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT 
  CONCAT('₹', total_amount) AS amount_with_rupee
FROM Orders
WHERE total_amount > 20;

SELECT * 
FROM Orders
WHERE total_amount > 20;


-- 9) List all genres available in the Books table
SELECT COUNT(genre) AS total_genres
FROM books;

SELECT COUNT(DISTINCT genre) AS unique_genre
FROM books;

SELECT genre FROM books;

-- 10) Find the book with the lowest stock
SELECT * FROM books
ORDER BY stock;

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue
FROM Orders;


-- Advance Queries
-- 1) Retrieve the total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS total_book_sold
FROM books b
JOIN
Orders o
ON b.book_id = o.book_id
GROUP BY genre;

-- 2) Find the average price of books in the "Fantasy" genre
SELECT * FROM books;
SELECT * FROM orders;

SELECT genre, AVG(price) AS avg_price FROM books
WHERE genre='Fantasy'
GROUP BY genre;


-- 3) List customers who have placed at least 2 orders
SELECT * FROM Customers;

SELECT c.name, o.quantity
FROM customers c
JOIN
Orders o 
ON c.customer_id = o.customer_id
WHERE quantity>=2;

SELECT c.name, o.customer_id COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id 
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id)>=2;


-- 4) Find the most frequently ordered book
SELECT o.book_id, b.title, COUNT(Order_id) AS ORDER_COUNT
FROM orders o
JOIN 
books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC
LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre
SELECT * FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3; 

-- 6) Retrieve the total quantity of books sold by each author
SELECT * FROM books;
SELECT * FROM orders;

SELECT b.author, SUM(o.quantity) AS total_quantity
FROM books b
JOIN 
orders o
ON b.book_id = o.book_id
GROUP BY author;

-- 7) List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, c.name, o.total_amount
FROM customers c
JOIN 
Orders o
ON c.customer_id = o.customer_id
WHERE total_amount>30
ORDER BY total_amount;

-- 8) Find the customer who spent the most on orders
SELECT c.name, o.total_amount
FROM Customers c
JOIN
Orders o
ON c.customer_id = o.customer_id
ORDER BY total_amount DESC
LIMIT 1;

SELECT c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;


-- 9) Calculate the stock remaining after fulfilling all orders
SELECT 
  b.book_id,
  b.title, b.stock, COALESCE(SUM(o.quantity), 0) AS order_quqntity,
  b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_stock
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock;
