-- loading data using local infile

load data local infile "C:\\Users\\USER\\Desktop\\New Text Document (4).txt" into table movies fields TERMINATED BY '	';



-- Lets explore the movies data set

SELECT 
    *
FROM
    movies;

-- Top 10 highest grossing movies of all time

SELECT 
    name, gross, year
FROM
    movies
ORDER BY gross DESC
LIMIT 10;

-- Top 10 highest grossing genre

SELECT 
    genre, SUM(gross) AS total_collection
FROM
    movies
GROUP BY genre
ORDER BY total_collection DESC
LIMIT 10;

-- Highest grossing movies for each genre

SELECT 
    genre, name
FROM
    movies
GROUP BY genre
HAVING MAX(gross);

-- Highest rated movies (imdb rating) having a rating greater than 7

SELECT 
    name, score
FROM
    movies
WHERE
    score > 7
ORDER BY score DESC;

-- Number of movies having a rating greater than 7 on imdb

SELECT DISTINCT
    COUNT(name)
FROM
    movies
WHERE
    score > 7;

-- Top 10 movies with highest budgets

SELECT 
    name, budget
FROM
    movies
ORDER BY budget DESC
LIMIT 10;

-- Top 10 Movies with highest run times (in minutes)

SELECT 
    name, runtime, country
FROM
    movies
ORDER BY runtime DESC
LIMIT 10;

-- Top 10 movies made in India

SELECT 
    name, score, country, year
FROM
    movies
WHERE
    country = 'India'
ORDER BY score DESC
LIMIT 10;

-- Top 10 movies made in Italy

SELECT 
    name, score, country, year
FROM
    movies
WHERE
    country = 'Italy'
ORDER BY score DESC
LIMIT 10;

-- Top 10 movies made in the USA

SELECT 
    name, score, country, year
FROM
    movies
WHERE
    country = 'United States'
ORDER BY score DESC
LIMIT 10;

-- Top 10 movies with the highest collection to budget ratio

SELECT 
    name,
    country,
    score,
    (gross / budget) AS gross_to_budget_ratio
FROM
    movies
ORDER BY gross_to_budget_ratio DESC
LIMIT 10;

-- Top 20 least rated movies from imdb

SELECT 
    name, country, score AS rating
FROM
    movies
WHERE
    score <> 0
ORDER BY rating
LIMIT 20;






