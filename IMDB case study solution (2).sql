USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name,
       table_rows
FROM   information_schema.tables
WHERE  table_type = 'BASE TABLE'
       AND table_schema = 'imdb' ;






-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Count(*) - Count(id)                    AS id_nulls_count,
       Count(*) - Count(title)                 AS title_nulls_count,
       Count(*) - Count(date_published)        AS date_published_nulls_count,
       Count(*) - Count(duration)              AS duration_nulls_count,
       Count(*) - Count(country)               AS country_nulls_count,
       Count(*) - Count(worlwide_gross_income) AS worlwide_gross_income_nulls_count,
       Count(*) - Count(languages)             AS languages_nulls_count,
       Count(*) - Count(production_company)    AS production_company_nulls_count
FROM   movie;








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

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
SELECT year,
       Count(title) AS number_of_movies
FROM   movie
GROUP  BY year;

SELECT Month(date_published) AS month_num,
       Count(title)          AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num 








/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT country,
       Count(title) AS movies_produced
FROM   movie
WHERE  year = '2019'
       AND ( country LIKE '%USA%'
              OR country LIKE '%India%' ); 








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre ;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
WITH genre_movies
     AS (SELECT genre,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) movie_rank
         FROM   genre
         GROUP  BY genre)
SELECT genre
FROM   genre_movies
WHERE  movie_rank = 1 ;







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH one_genre_movies
     AS (SELECT movie_id,
                Count(genre) genre_count
         FROM   genre
         GROUP  BY movie_id
         HAVING genre_count = 1)
SELECT Count(movie_id) AS one_genre_movies_count
FROM   one_genre_movies ;








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
SELECT genre,
       Avg(duration) AS avg_duration
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
GROUP  BY genre;








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
SELECT genre,
       Count(movie_id) as movie_count,
       Rank()
         OVER (
           ORDER BY Count(movie_id) DESC) genre_rank
FROM   genre g
WHERE  genre = 'thriller'
GROUP  BY genre; 









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
SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings ;




    

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
WITH movie_ranking
     AS (SELECT m.title,
                avg_rating,
                Dense_rank()
                  OVER (
                    ORDER BY avg_rating DESC ) AS movie_rank
         FROM   ratings r
                INNER JOIN movie m
                        ON m.id = r.movie_id)
SELECT *
FROM   movie_ranking
WHERE  movie_rank <= 10 ;







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
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating ;





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
WITH hit_movies
     AS (SELECT production_company,
                Count(id)                    AS movie_count,
                Dense_rank()
                  OVER (
                    ORDER BY Count(id) DESC) prod_company_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   hit_movies
WHERE  prod_company_rank = 1 ;








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
SELECT genre,
       Count(id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country = 'USA'
       AND r.total_votes > 1000 ;









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
SELECT title,
       avg_rating,
       genre
FROM   genre g
       INNER JOIN ratings r using (movie_id)
       INNER JOIN movie m
               ON m.id = g.movie_id
WHERE  avg_rating > 8
       AND title LIKE 'The%'
GROUP  BY genre ;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT Count(title) AS movies_count
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01' ;












-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country,
       Sum(total_votes) total_votes
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  country IN ( 'Germany', 'Italy' )
GROUP  BY country ;



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
SELECT Count(*) - Count(NAME)             AS name_nulls,
       Count(*) - Count(height)           AS height_nulls,
       Count(*) - Count(date_of_birth)    AS date_of_birth_nulls,
       Count(*) - Count(known_for_movies) AS known_for_movies_nulls
FROM   names ;




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
WITH top_genre AS
(
           SELECT     genre,
                      Count(title) count_title
           FROM       genre g
           INNER JOIN movie m
           ON         m.id=g.movie_id
           INNER JOIN ratings r
           ON         m.id=r.movie_id
           AND        avg_rating > 8
           GROUP BY   genre
           ORDER BY   count_title DESC limit 3)
SELECT     NAME              AS director_name,
           Count(d.movie_id) AS movie_count
FROM       names n
INNER JOIN director_mapping d
ON         n.id=d.name_id
INNER JOIN genre g
ON         g.movie_id=d.movie_id
INNER JOIN ratings r
ON         r.movie_id=d.movie_id
INNER JOIN top_genre
ON         g.genre =top_genre.genre
WHERE      avg_rating>8
GROUP BY   director_name
ORDER BY   movie_count DESC limit 3;








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
WITH actor_movie_rank
     AS (SELECT NAME                                 AS actor_name,
                Count(r.movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(r.movie_id) DESC) AS actor_rank
         FROM   role_mapping r
                INNER JOIN names n
                        ON n.id = r.name_id
                INNER JOIN ratings r1
                        ON r1.movie_id = r.movie_id
         WHERE  r.category = 'actor'
                AND median_rating >= 8
         GROUP  BY actor_name)
SELECT *
FROM   actor_movie_rank
WHERE  actor_rank < 3 ;









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
WITH prod_company_rank
     AS (SELECT production_company,
                Sum(total_votes)                     vote_count,
                Rank()
                  OVER (
                    ORDER BY Sum(total_votes) DESC ) prod_comp_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         GROUP  BY production_company)
SELECT *
FROM   prod_company_rank
WHERE  prod_comp_rank < 4 







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

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
SELECT NAME AS actor_name,
       Sum(total_votes) AS total_votes,
       Count(m.id)		AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)      AS actor_avg_rating,
       Rank()
         OVER(
           ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC) AS actor_rank
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN role_mapping AS r1
               ON m.id = r1.movie_id
       INNER JOIN names AS n
               ON r1.name_id = n.id
WHERE  category = 'actor'
       AND country = 'india'
GROUP  BY NAME
HAVING movie_count >= 5; 








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
SELECT NAME AS actor_name,
       Sum(total_votes) AS total_votes,
       Count(m.id) AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)  AS actor_avg_rating,
       Rank()
         OVER(
           ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC) AS
       actor_rank
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN role_mapping AS r1
               ON m.id = r1.movie_id
       INNER JOIN names AS n
               ON r1.name_id = n.id
WHERE  category = 'actress'
       AND country = 'India'
       AND languages = 'Hindi'
GROUP  BY NAME
HAVING movie_count >= 3; 







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT CASE
         WHEN avg_rating < 5 THEN 'Flop movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating > 8 THEN 'Superhit movies'
       END AS movie_category
FROM   ratings r
       INNER JOIN genre g
               ON r.movie_id = g.movie_id
WHERE  genre = 'Thriller' 








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
SELECT genre,
       Round(Avg(duration))                                   AS avg_duration,
       Round(SUM(Avg(duration))
               over(
                 ORDER BY genre ROWS unbounded preceding), 1) AS
       running_total_duration,
       Round(Avg(Avg(duration))
               over(
                 ORDER BY genre ROWS 10 preceding), 2)        AS
       moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 






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
WITH top_3_genre
     AS (WITH top_genre
              AS (SELECT genre,
                         Count(movie_id)                    AS movie_count,
                         Rank()
                           OVER(
                             ORDER BY Count(movie_id) DESC) AS genre_rank
                  FROM   genre
                  GROUP  BY genre)
         SELECT *
          FROM   top_genre
          WHERE  genre_rank <= 3),
     top_5_movie
     AS (SELECT year,
                title                                    AS movie_name,
                worlwide_gross_income,
                Rank()
                  OVER (
                    ORDER BY worlwide_gross_income DESC) AS movie_rank
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
         WHERE  g.genre IN (SELECT genre
                            FROM   top_3_genre))
SELECT *
FROM   top_5_movie
WHERE  movie_rank <= 5 






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
WITH ranking
     AS (SELECT production_company,
                Count(m.id)                  AS movie_count,
                Rank()
                  over(
                    ORDER BY Count(id) DESC) AS comp_rank
         FROM   movie AS m
                inner join ratings AS r
                        ON m.id = r.movie_id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company)
SELECT *
FROM   ranking
WHERE  comp_rank < 3; 





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
WITH actress_ranking
     AS (SELECT n.NAME
                AS
                actress_name
                   ,
                Sum(r.total_votes)
                   AS total_votes,
                Count(g.movie_id)
                AS
                   movie_count,
                Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2)
                AS
                actress_avg_rating,
                Rank()
                  OVER(
                    ORDER BY Count(g.movie_id) DESC)
                AS
                   actress_rank
         FROM   genre AS g
                INNER JOIN movie AS m
                        ON g.movie_id = m.id
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping AS r1
                        ON m.id = r1.movie_id
                INNER JOIN names AS n
                        ON r1.name_id = n.id
         WHERE  g.genre = 'drama'
                AND r1.category = 'actress'
                AND r.avg_rating > 8
         GROUP  BY n.NAME)
SELECT *
FROM   actress_ranking
WHERE  actress_rank <= 3; 






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

SELECT name_id           AS director_id,
       name              AS director_name,
       Count(d.movie_id) AS number_of_movies,
       r.avg_rating      AS avg_rating,
       r.total_votes     AS total_votes,
       m.date_published,
       Sum(total_votes)  AS total_votes,
       Min(avg_rating)   AS min_rating,
       Max(avg_rating)   AS max_rating,
       Sum(duration)     AS total_duration
FROM   director_mapping AS d
       INNER JOIN names AS n
               ON d.name_id = n.id
       INNER JOIN movie AS m
               ON d.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
GROUP  BY director_id
ORDER  BY number_of_movies DESC
LIMIT  9; 





