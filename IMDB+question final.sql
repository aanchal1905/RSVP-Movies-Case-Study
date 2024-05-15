USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
DESCRIBE movie;


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';








-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	SUM(CASE WHEN id is NULL THEN 1 ELSE 0 END) AS NULL_ID,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS NULL_TITLE,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS NULL_YR,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS NULL_DATE,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS NULL_DURATION,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS NULL_COUNTRY,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS NULL_INCOME,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS NULL_LANGUAGES,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS NULL_COMPANY
FROM movie;

-- country - 20, income, 3274, language - 194, company - 528



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
DESCRIBE movie;

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT year, COUNT(id) as no_of_movies
FROM movie
GROUP BY year
ORDER BY year;
/* Output:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+
*/

SELECT MONTH(date_published) AS MNTH, COUNT(id) as no_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);
/*
MNTH  no_of_movies
1		804
2		640
3		824
4		680
5		625
6		580
7		493
8		678
9		809
10		801
11		625
12		438
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

DESCRIBE movie;

SELECT country, COUNT(id) as no_of_movies
FROM movie
WHERE year = '2019'
and country = 'USA' or country = 'India'
GROUP BY country;
/* Output:
country no_of_movies
India	 1007
USA		 592
*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
DESCRIBE genre;

SELECT genre
FROM genre
GROUP BY genre;

/* OUTPUT:
genre
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
DESCRIBE genre;
DESCRIBE movie;

SELECT g.genre, COUNT(id) as no_of_movies
FROM movie m 
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(ID) DESC;

/* OUTPUT:
genre     no_of_movies
Drama		4285
Comedy		2412
Thriller	1484
Action		1289
Horror		1208
Romance		906
Crime		813
Adventure	591
Mystery		555
Sci-Fi		375
Fantasy		342
Family		302
Others		100




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH genre_count AS
(
SELECT movie_id, COUNT(genre) AS ct_movies
FROM genre
GROUP BY movie_id 
HAVING ct_movies = 1
)
SELECT COUNT(movie_id) as no_of_movies
FROM genre_count;

/*OUTPUT:
no_of_movies
3289
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, ROUND(AVG(m.duration),2) as avg_duration
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY ROUND(AVG(m.duration),2) DESC; 

/* OUTPUT:
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
	Action				112.88
	Romance				109.53
	Crime				107.05
	Drama				106.77
	Fantasy				105.14
	Comedy				102.62
	Adventure			101.87
	Mystery				101.80
	Thriller			101.58
	Family				100.97
	Others				100.16
	Sci-Fi				97.94
	Horror				92.72
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rnk AS
(
SELECT genre, COUNT(movie_id) as no_of_movies,
RANK() OVER(ORDER BY COUNT(movie_id) DESC) as genre_rank
FROM genre
GROUP BY genre
)

SELECT * FROM genre_rnk
WHERE genre = 'Thriller';

/* OUTPUT:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|	1484			|			3		  |
+---------------+-------------------+---------------------+

*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
DESCRIBE RATINGS;

SELECT
	MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
ratings;

/* Output:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|			10.0	|	       100		  |	   725138	    	 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+

*/


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT m.title, r.avg_rating, 
DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS rank_movie
FROM movie m 
INNER JOIN ratings r 
ON m.id = r.movie_id
LIMIT 10;

/* OUTPUT:
title                   avg_rating  rank_movie
Kirket						10.0	1
Love in Kilnerry			10.0	1
Gini Helida Kathe			9.8		2
Runam						9.7		3
Fan							9.6		4
Android Kunjappan Version 	5.25	9.6	4
Yeh Suhaagraat Impossible	9.5		5
Safe						9.5		5
The Brighton Miracle		9.5		5
Shibu						9.4		6
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT r.median_rating, COUNT(movie_id) as movie_ct
FROM ratings r 
GROUP BY r.median_rating
ORDER BY r.median_rating;

/* OUTPUT:
median_rating	movie_ct
1				94
2				119
3				283
4				479
5				985
6				1975
7				2257
8				1030
9				429
10				346

*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, COUNT(m.id) as movie_count, 
DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) as prod_company_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE avg_rating > 8 
AND production_company is NOT NULL
GROUP BY m.production_company
ORDER BY COUNT(m.id) DESC;

/* ANSWER: Dream Warrior Picture and National Theatre Live with 3 as the movie count. */

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

DESCRIBE ratings;

SELECT g.genre, COUNT(m.id) as movie_count
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE MONTH(date_published) = 3
AND year = '2017'
AND country = 'USA'
AND total_votes > 1000
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, r.avg_rating, g.genre
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE m.title like 'The%'
AND r.avg_rating > 8
ORDER BY r.avg_rating DESC; 

/* Output:
The Brighton Miracle	9.5	Drama
The Colour of Darkness	9.1	Drama
The Blue Elephant 2	8.8	Drama
The Blue Elephant 2	8.8	Horror
The Blue Elephant 2	8.8	Mystery
The Irishman	8.7	Crime
The Irishman	8.7	Drama
The Mystery of Godliness: The Sequel	8.5	Drama
The Gambinos	8.4	Crime
The Gambinos	8.4	Drama
Theeran Adhigaaram Ondru	8.3	Action
Theeran Adhigaaram Ondru	8.3	Crime
Theeran Adhigaaram Ondru	8.3	Thriller
The King and I	8.2	Drama
The King and I	8.2	Romance
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT m.title, r.median_rating, g.genre
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE m.title like 'The%'
AND r.median_rating > 8
ORDER BY r.median_rating DESC; 

/*There seems to be multiple movies with medain rating as 9 and 10, however, 
in case of avg_rating the case is not the same*/  

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT r.median_rating, COUNT(m.id) as movie_count
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE m.date_published between '2018-04-01' and '2019-04-01'
AND r.median_rating = 8
GROUP BY r.median_rating;
-- 361 movies in total


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT m.languages, r.total_votes
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE languages like 'German' or languages like 'Italian'
GROUP BY m.languages, r.total_votes
ORDER BY r.total_votes DESC;
-- Answer is Yes



/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

DESCRIBE names;

SELECT 
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_null,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_null,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_null,
	SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movied_null
FROM names;

/* OUTPUT:
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			17335	|	       13431	  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH genre_top3 AS 
(
SELECT g.genre, COUNT(g.movie_id) as no_of_movies
FROM genre g
INNER JOIN ratings r
ON g.movie_id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY genre
ORDER BY no_of_movies DESC
LIMIT 3
),
director_top3 AS 
(
SELECT n.name as director_name, COUNT(g.movie_id) as no_of_movies,
ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) as director_rnk
FROM names n
INNER JOIN director_mapping d
on n.id = d.name_id
INNER JOIN genre g 
ON d.movie_id = g.movie_id
INNER JOIN ratings r
ON r.movie_id = g.movie_id,
genre_top3
WHERE g.genre in (genre_top3.genre) AND r.avg_rating > 8 
GROUP BY n.name
ORDER BY COUNT(g.movie_id) DESC
)

SELECT director_name, no_of_movies 
FROM director_top3
WHERE director_rnk <= 3;

/* OUTPUT:
James Mangold	4	
Soubin Shahir	3	
Joe Russo		3	

James Mangold can be hired as the director for RSVP's next project.
*/ 

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
DESCRIBE role_mapping;

SELECT n.name as Actor_name, COUNT(r.movie_id) as no_of_movies
FROM names n
INNER JOIN role_mapping ro
ON n.id = ro.name_id
INNER JOIN ratings r 
ON ro.movie_id = r.movie_id
WHERE r.median_rating >= 8
AND ro.category = 'actor'
GROUP BY n.name
ORDER BY COUNT(r.movie_id) DESC
LIMIT 2;

/* OUTPUT:
Mammootty	8
Mohanlal	5
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, SUM(total_votes) as vote_count,
DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) as prod_comp_rank
FROM movie m
INNER JOIN ratings r 
ON m.id = r.movie_id 
GROUP BY production_company
ORDER BY SUM(total_votes) DESC
LIMIT 3;

/* OUTPUT:

Marvel Studios			2656967		1
Twentieth Century Fox	2411163		2
Warner Bros.			2396057		3

Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.
*/

/*
Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actor_name, SUM(total_votes) AS total_votes,
COUNT(m.id) AS movie_count, ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
ROW_NUMBER() OVER (ORDER BY  ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM names n
INNER JOIN role_mapping rm 
ON n.id = rm.name_id
INNER JOIN ratings r 
ON rm.movie_id = r.movie_id
INNER JOIN movie m 
ON m.id = rm.movie_id
WHERE category = "actor"
AND country LIKE "%india%"
GROUP BY name
HAVING movie_count >= 5;

/*

Vijay Sethupathi	23114	5	8.42	1

*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actress_name, SUM(total_votes) AS total_votes,
COUNT(m.id) AS movie_count, ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
ROW_NUMBER() OVER (ORDER BY  ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM names n
INNER JOIN role_mapping rm 
ON n.id = rm.name_id
INNER JOIN ratings r 
ON rm.movie_id = r.movie_id
INNER JOIN movie m 
ON m.id = rm.movie_id
WHERE category = "actress"
AND country LIKE "%india%"
AND languages LIKE "%hindi%"
GROUP BY name
HAVING movie_count >= 3;

/*
	actress_name	total_votes	movie_count	actor_avg_rating	actor_rank
	Taapsee Pannu	18061			3			7.74				1
	Kriti Sanon		21967			3			7.05				2
	Divya Dutta		8579			3			6.88				3
	Shraddha Kapoor	26779			3			6.63				4
	Kriti Kharbanda	2549			3			4.80				5
	Sonakshi Sinha	4025			4			4.18				6
*/



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title, r.avg_rating,
CASE 
	WHEN r.avg_rating > 8 THEN 'Superhit movies'
    WHEN r.avg_rating between 7 and 8 THEN 'Hit movies'
    WHEN r.avg_rating between 5 and 7 THEN 'One-time-watch movies'
    WHEN r.avg_rating < 5 THEN 'Flop movies'
    ELSE 'No Rating'
END AS movie_type
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN genre g
on m.id = g.movie_id
WHERE g.genre = 'Thriller';

/* OUTPUT(Only top 5 rows as of now): 
	Der müde Tod		7.7		Hit movies
	Fahrenheit 451	 	4.9		Flop movies
	Pet Sematary		5.8		One-time-watch movies
	Dukun				6.9		One-time-watch movies
	Back Roads			7.0		Hit movies
*/

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre, ROUND(AVG(duration),2) as avg_duration,
SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre) as running_total_duration,
ROUND(AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) as moving_avg_duration
FROM movie m 
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY genre
ORDER BY genre;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH genre_top3 as
(
SELECT g.genre, COUNT(m.id) as movie_count
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC
LIMIT 3
),
movie_top5 as
(
SELECT g.genre, m.year, m.title, m.worlwide_gross_income, 
ROW_NUMBER() OVER(PARTITION BY m.year ORDER BY worlwide_gross_income DESC) as movie_rnk
FROM movie m 
INNER JOIN genre g
ON g.movie_id = m.id
WHERE g.genre in (SELECT genre FROM genre_top3) 
)

SELECT * FROM movie_top5 
WHERE movie_rnk <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT * FROM 
(
SELECT production_company, COUNT(m.id) as movie_count,
ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) as prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE r.median_rating >= 8
AND production_company is NOT NULL
AND POSITION(',' IN languages)>0
GROUP BY production_company
) a
WHERE a.prod_comp_rank <= 2;

/* OUTPUT: 
Star Cinema				7	1
Twentieth Century Fox	4	2
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name, SUM(r.total_votes) AS total_votes,
COUNT(m.id) AS movie_count, AVG(r.avg_rating) AS actress_Avg_rating,
ROW_NUMBER() OVER (ORDER BY count(m.id) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping ro
ON n.id = ro.name_id
INNER JOIN movie m 
ON m.id = ro.movie_id
INNER JOIN ratings r 
ON r.movie_id = m.id
INNER JOIN genre g 
ON g.movie_id = m.id
WHERE avg_rating > 8
AND category = "actress"
AND genre = "drama"
GROUP BY n.name
ORDER BY COUNT(m.id) desc
LIMIT 3;

/*

Parvathy Thiruvothu		4974	2	8.20000	1
Susan Brown				656		2	8.95000	2
Amanda Lawrence			656		2	8.95000	3

*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
DROP VIEW IF EXISTS avg_diff_btw_dates;

CREATE VIEW avg_diff_btw_dates AS
WITH movie_dates AS (
    SELECT
        nm.id AS director_id,
        nm.name AS director_name,
        m.id AS movie_id,
        m.date_published AS movie_date,
        LEAD(m.date_published, 1) OVER (PARTITION BY nm.name ORDER BY m.date_published) AS next_movie_date
    FROM names nm
    INNER JOIN director_mapping dm 
    ON nm.id = dm.name_id
    INNER JOIN movie m 
    ON dm.movie_id = m.id
)
SELECT
    director_id,
    director_name,
    AVG(DATEDIFF(next_movie_date, movie_date)) AS avg_inter_movie_days
FROM movie_dates
GROUP BY director_id, director_name;

WITH top_directors AS (
    SELECT
        nm.id AS director_id,
        nm.name AS director_name,
        COUNT(DISTINCT dm.movie_id) AS number_of_movies,
        ROUND(AVG(r.avg_rating), 2) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_duration,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT dm.movie_id) DESC) AS director_rank
    FROM names nm
    INNER JOIN director_mapping dm 
    ON nm.id = dm.name_id
    INNER JOIN movie m 
    ON dm.movie_id = m.id
    INNER JOIN ratings r 
    ON m.id = r.movie_id
    GROUP BY director_id, director_name
)


SELECT
    td.director_id,
    td.director_name,
    td.number_of_movies,
    AVGD.avg_inter_movie_days AS avg_inter_movie_days,
    td.avg_rating,
    td.total_votes,
    td.min_rating,
    td.max_rating,
    td.total_duration
FROM
    top_directors td
LEFT JOIN
    avg_diff_btw_dates AVGD ON td.director_id = AVGD.director_id
WHERE
    td.director_rank <= 9;


/*

nm1777967	A.L. Vijay	5	176.7500	5.42	1754	3.7	6.9	613
nm2096009	Andrew Jones	5	190.7500	3.02	1989	2.7	3.2	432
nm0001752	Steven Soderbergh	4	254.3333	6.48	171684	6.2	7.0	401
nm0425364	Jesse V. Johnson	4	299.0000	5.45	14778	4.2	6.5	383
nm0515005	Sam Liu	4	260.3333	6.23	28557	5.8	6.7	312
nm0814469	Sion Sono	4	331.0000	6.03	2972	5.4	6.4	502
nm0831321	Chris Stokes	4	198.3333	4.33	3664	4.0	4.6	352
nm2691863	Justin Price	4	315.0000	4.50	5343	3.0	5.8	346
nm6356309	Özgür Bakar	4	112.0000	3.75	1092	3.1	4.9	374

*/








