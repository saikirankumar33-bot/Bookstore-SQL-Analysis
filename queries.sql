-- ============================================
-- 📚 Bookstore SQL Analysis Queries
-- Author: Sai Kiran Bhallamudi
-- ============================================


-- ============================================
-- 🔹 BASIC QUERIES
-- ============================================

-- 1. Retrieve all books in Fiction genre
SELECT *
FROM books
WHERE genre = 'Fiction';


-- 2. Find books published after 1950
SELECT title, genre, published_year
FROM books
WHERE published_year > 1950;


-- 3. List all customers from Canada
SELECT *
FROM customers
WHERE country = 'Canada';


-- 4. Show orders placed in November 2023
SELECT *
FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5. Retrieve total stock of all books
SELECT SUM(stock) AS total_stock
FROM books;


-- 6. Find the most expensive book
SELECT *
FROM books
ORDER BY price DESC
LIMIT 1;


-- 7. Show all customers who ordered more than 1 book
SELECT *
FROM orders
WHERE quantity > 1;


-- 8. Retrieve orders where total amount exceeds $20
SELECT *
FROM orders
WHERE total_amount > 20;


-- 9. List all unique genres
SELECT DISTINCT genre
FROM books;


-- ============================================
-- 🔹 ADVANCED QUERIES
-- ============================================

-- 10. Total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS books_sold
FROM books b
JOIN orders o ON b.book_id = o.book_id
GROUP BY b.genre;


-- 11. Average price of books in Fantasy genre
SELECT genre, AVG(price) AS avg_price
FROM books
WHERE genre = 'Fantasy'
GROUP BY genre;


-- 12. Customers who placed at least 2 orders
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;


-- 13. Most frequently ordered book
SELECT b.book_id, b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY order_count DESC
LIMIT 1;


-- 14. Top 3 most expensive Fantasy books
SELECT title, price
FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;


-- 15. Total quantity sold by each author
SELECT b.author, SUM(o.quantity) AS total_sold
FROM books b
JOIN orders o ON b.book_id = o.book_id
GROUP BY b.author;


-- 16. Cities where customers spent more than $30
SELECT DISTINCT c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;


-- 17. Top 5 customers by total spending
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 5;


-- 18. Remaining stock after fulfilling all orders
SELECT 
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS total_sold,
    (b.stock - COALESCE(SUM(o.quantity), 0)) AS remaining_stock
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock
ORDER BY remaining_stock DESC;


-- ============================================
-- 🔹 BONUS INSIGHT QUERY
-- ============================================

-- 19. Stock status (Low / Sufficient)
SELECT 
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS total_sold,
    (b.stock - COALESCE(SUM(o.quantity), 0)) AS remaining_stock,
    CASE 
        WHEN (b.stock - COALESCE(SUM(o.quantity), 0)) < 10 THEN 'Low Stock'
        ELSE 'Sufficient'
    END AS stock_status
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock;
