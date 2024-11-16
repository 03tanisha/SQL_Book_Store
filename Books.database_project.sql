-- creating database 
create database books ;

-- use database 
use books;

-- create table Books
create table Books (
book_id int primary key,
title varchar(100),
author_id int,
genre_id int,
published_year int,
price decimal(5,2),
available_copies int,
foreign key (author_id) references  Authors(author_id),
foreign key (genre_id) references Genres(genre_id)
);


-- create table Authors
create table Authors(
author_id int primary key,
first_name varchar(50),
last_name varchar(50),
birth_year int,
nationality varchar(50)
);

-- create table Genres
create table Genres (
genre_id int primary key,
genre_name varchar(50)
);


-- create table Members
create table Members(
member_id int primary key,
first_name varchar(50),
last_name varchar(50),
membership_date date,
email varchar(50),
phone_number varchar(50)
);


-- create table Borrow Transactions 
create table Borrow_Transactions (
transaction_id int primary key,
book_id int,
member_id int,
borrow_date date,
due_date date,
return_date date,
foreign key (book_id) references Books(book_id),
foreign key (member_id) references Members (member_id)
);


-- Insert the Data

-- Book Table
insert  into Books (book_id, title, author_id, genre_id, published_year, price, available_copies) values
(1, 'To Kill a Mockingbird',  101,  1,  1960,  15.99,  5),
(2, 'Elizabeth', 102, 2, 1949, 12.99, 3),
(3, 'Moby Dick', 103, 1, 1851, 18.99, 2),
(4, 'The Match', 104, 2, 1867, 24.45, 5),
(5, 'Gulliver Travel', 105, 3, 1945, 10.34, 20),
(6, 'Pride' ,106, 2, 1960, 34.43, 2),
(7, 'Prejudice', 107, 3, 1980, 21.22, 6);

-- Author Table
insert into Authors (author_id, first_name, last_name, birth_year, nationality) values
(101, 'Harper', 'Lee', 1926, 'American'),
(102, 'George', 'Orwell', 1903, 'British'),
(103, 'Herman', 'Melville', 1819, 'American'),
(104, 'William', 'Shakespeare', 1912, 'American'),
(105, 'Jane', 'Auston', 1923, 'British'),
(106, 'E.M.', 'Forster', 1932, 'American'),
(107, 'Roald', 'Dahld', 1911, 'American');


-- Genre Table
insert into Genres (genre_id, genre_name) values
(1, 'Fiction'),
(2, 'Science Fiction'),
(3, 'Classic');


-- Borrow Transaction  Table 
insert into Borrow_Transactions (transaction_id, book_id, member_id, borrow_date, due_date, return_date) values
(2001, 1, 01, '2023-01-05', '2023-01-20', '2023-01-18'),
(2002, 2, 02, '2023-01-10', '2023-01-25', NULL),
(2003, 3, 03, '2023-01-12', '2023-01-27', '2023-01-22'),
(2004, 4, 04, '2023-02-05', '2023-02-15', '2023-02-10'),
(2005, 5, 05, '2023-02-10', '2023-02-20', '2023-02-17'),
(2006, 6, 06, '2023-11-03', '2023-11-20', '2023-11-15'),
(2007, 7, 07, '2023-06-21', '2023-06-30', '2023-06-25');


-- Member table
insert into Members(member_id, first_name, last_name, membership_date, email, phone_number) values
(01, 'Ram', 'Gupta', '2022-12-03', 'ram@gmai.com', '123-456-789'),
(02, 'Rahul', 'Malhotra', '2022-11-02', 'rahul2@gmial.com', '456-123-654'),
(03, 'R.K.', 'Narayan', '2022-10-12', 'rknarayan@gmail.com', '4546-873-106'),
(04, 'Sahil', 'Sharma', '2023-01-01', 'ssharma@gmai.com', '721-908-345'),
(05, 'Tripti', 'Talwar', '2022-11-12', 'tripti@gmail.com', '236-452-763'),
(06, 'Kiran', 'Das', '2023-01-02', 'kirand@gmail.com', '453-675-323'),
(07, 'Chetan', 'Sharma', '2022-11-12', 'sharma@gmail.com', '734-236-741');


-- BUSINESS PROBLEMS

-- 1.)  Most Borrowed Books
select b.title, count(*) as borrow_count
from borrow_transactions as bt
join books as b
on bt.book_id = b.book_id
group by b.title
order by borrow_count desc ;

-- Every book has the same count i.e. 1 


-- 2.) Overdue Books 
select b.title, m.first_name, m.last_name, bt.due_date
from books as b
join borrow_transactions as bt
on b.book_id = bt.book_id
join members as m
on bt.member_id = m.member_id
-- group by b.title, m.first_name, m.last_name
where bt.return_date is null and bt.due_date < curdate();

-- Rahul Malhotra has bought the book Elizabeth with the due date 2023-01-25.


-- 3.) Returned Books
select b.title, m.first_name, m.last_name, bt.due_date
from books as b 
join borrow_transactions as bt
on b.book_id = bt.book_id
join members as m
on bt.member_id = m.member_id
where bt.return_date  is not null;


-- Ram Gupta, R.K. Narayan, Sahil Sharma, Tripti Talwar, Kiran Das, Chetan Sharma these all have Due date
-- indicating that they havn't returned their books.


-- 4.) Average Borrow Duration 
-- Find the average duration (in days) between the borrow and return dates for each book.
select b.title, avg(datediff(bt.return_date, bt.borrow_date)) as avg_borrow_duration, m.first_name
from borrow_transactions as bt
join books as b
on bt.book_id = b.book_id
join members as m
on bt.member_id = m.member_id
where bt.return_date is not null
group by b.title, m.first_name;

-- Ram took mximum days to return date the book i.e. 13 
-- while chetan return the book in only 4 days.


-- 5.) Genre-wise Borrowing Analysis
-- Track the popularity of book genres (how often each genre is borrowed) and which genres are most in demand.
select g.genre_name, count(*) as genre_count
from genres as g
join books as b
on  b.genre_id = g.genre_id
group by  g.genre_name
order by genre_count desc;

-- Science Fiction has 3(max) genre_count
-- Fiction and Classic both have 2-2 genre_count.
 
-- 6.) Monthly Borrowing Trends
-- Analyzing borrowing frequency by month 
select month(borrow_date) as borrow_month, count(transaction_id) as monthly_borrows
from borrow_transactions 
group by borrow_month
order by monthly_borrows desc;

-- January month has the highest count(3) in which books has been borrowed 

-- 7.) Availability of Books 
select b.title, b.available_copies
from books as b
join (
       select book_id, count(book_id) as borrow_count
       from borrow_transactions
       group by book_id
       order by borrow_count desc) as popular_books
on b.book_id = popular_books.book_id
where b.available_copies > 0 
order by available_copies desc;

-- Gulliver travel has the maximum number of available copies(20).



