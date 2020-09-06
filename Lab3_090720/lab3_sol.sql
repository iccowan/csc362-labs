/*
*   Lab 03: Creating Tables & Fields in SQL
*   CSC 362 Database Systems
*   Ian Cowan
*
*   This script creates the tables necessary to keep a record of movies,
*   consumers, and the consumer ratings on the movies.
*
*   Created 09/07/2020
*/

/* Drop the previous version of the database if it exists */
DROP DATABASE IF EXISTS movie_ratings;

/* Create the database */
CREATE DATABASE movie_ratings;

/* Use the appropriate database */
USE movie_ratings;

/* Now, create the 3 tables that we need and their fields */
/* movies Table */
CREATE TABLE movies (
    PRIMARY KEY        (movie_id),
    movie_id           INT(11) unsigned   NOT NULL AUTO_INCREMENT,
    movie_title        VARCHAR(256) 	    NOT NULL,
    movie_release_date DATE         	    NOT NULL,
    movie_genre        VARCHAR(256) 	    NOT NULL
);

/* consumers Table */
CREATE TABLE consumers (
    PRIMARY KEY (consumer_id),
    consumer_id          INT(11) unsigned NOT NULL AUTO_INCREMENT,
    consumer_first_name  VARCHAR(64)  	  NOT NULL,
    consumer_last_name   VARCHAR(64)  	  NOT NULL,
    consumer_address     VARCHAR(128) 	  NOT NULL,
    consumer_city        VARCHAR(64)  	  NOT NULL,
    consumer_state       CHAR(2)      	  NOT NULL,
    consumer_zip         INT(5)      	    NOT NULL
);

/* ratings Table */
CREATE TABLE ratings (
    PRIMARY KEY         (movie_id, consumer_id),
    movie_id            INT(11) unsigned     NOT NULL,
    FOREIGN KEY         (movie_id)
                        REFERENCES movies (movie_id)
                        ON DELETE RESTRICT,
    consumer_id         INT(11) unsigned     NOT NULL,
    FOREIGN KEY         (consumer_id)
                        REFERENCES consumers (consumer_id)
                        ON DELETE RESTRICT,
    rating_number_stars TINYINT(1) unsigned  NOT NULL,
    when_rated          DATETIME      	     NOT NULL
);

/* Seed the movies database with values */
INSERT INTO movies (movie_title, movie_release_date, movie_genre)
VALUES ('The Hunt for Red October', '1990-03-02', 'Action, Adventure, Thriller'),
       ('Lady Bird', '2017-12-01', 'Comedy, Drama'),
       ('Inception', '2010-08-16', 'Action, Adventure, Sci-Fi');

/* Seed the consumers table with values */
INSERT INTO consumers (consumer_first_name, consumer_last_name,
		       consumer_address, consumer_city, consumer_state, consumer_zip)
VALUES ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', 46342),
       ('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincetown', 'NJ', 08088),
       ('Norobu', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', 37076),
       ('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', 06512);

/* Seed the ratings table with values */
INSERT INTO ratings (movie_id, consumer_id, rating_number_stars, when_rated)
VALUES (1, 1, 4, '2010-09-02 10:54:19'),
       (1, 3, 3, '2012-08-05 15:00:01'),
       (1, 4, 1, '2016-10-02 23:58:12'),
       (2, 3, 2, '2017-03-27 00:12:48'),
       (2, 4, 4, '2018-08-02 00:54:42');

/* Confirm that all of the tables were created correctly */
SHOW CREATE TABLE movies;
SHOW CREATE TABLE consumers;
SHOW CREATE TABLE ratings;

/* Preview the tables */
SELECT *
  FROM movies;
SELECT *
  FROM consumers;
SELECT *
  FROM ratings;

/* Generate a report of the ratings using natural join */
SELECT consumer_first_name, consumer_last_name, movie_title, rating_number_stars
  FROM movies
       NATURAL JOIN ratings
       NATURAL JOIN consumers;

/*
*   The problem with the movies table at this point is that we have a multi-value
*   field (genre field). We will fix this by using a subset table that will allow
*   us to enter multiple genres for each movie.
*/

--------------------------------------------------------------------------------

/*
*   Drop the database and we'll begin from scratch 
*   so we don't have to deal with foreign key constraints.
*/
DROP DATABASE IF EXISTS movie_ratings;
CREATE DATABASE movie_ratings;
USE movie_ratings;

/* Now, create the 3 tables that we need and their fields */
/* movies Table */
CREATE TABLE movies (
    PRIMARY KEY        (movie_id),
    movie_id           INT(11) unsigned     NOT NULL AUTO_INCREMENT,
    movie_title        VARCHAR(256) 	    NOT NULL,
    movie_release_date DATE         	    NOT NULL
);

/* movie_genres Table */
/* Subset table of movies to store the movie genres */
CREATE TABLE movie_genres (
    PRIMARY KEY (movie_id, movie_genre),
    movie_id    INT(11) unsigned        NOT NULL,
    FOREIGN KEY (movie_id)
                REFERENCES movies (movie_id)
                ON DELETE RESTRICT,
    movie_genre VARCHAR(32)             NOT NULL
);

/* consumers Table */
CREATE TABLE consumers (
    PRIMARY KEY (consumer_id),
    consumer_id          INT(11) unsigned NOT NULL AUTO_INCREMENT,
    consumer_first_name  VARCHAR(64)  	  NOT NULL,
    consumer_last_name   VARCHAR(64)  	  NOT NULL,
    consumer_address     VARCHAR(128) 	  NOT NULL,
    consumer_city        VARCHAR(64)  	  NOT NULL,
    consumer_state       CHAR(2)      	  NOT NULL,
    consumer_zip         INT(5)      	  NOT NULL
);

/* ratings Table */
CREATE TABLE ratings (
    PRIMARY KEY         (movie_id, consumer_id),
    movie_id            INT(11) unsigned        NOT NULL,
    FOREIGN KEY         (movie_id)
                        REFERENCES movies (movie_id)
                        ON DELETE RESTRICT,
    consumer_id         INT(11) unsigned        NOT NULL,
    FOREIGN KEY         (consumer_id)
                        REFERENCES consumers (consumer_id)
                        ON DELETE RESTRICT,
    rating_number_stars TINYINT(1) unsigned     NOT NULL,
    when_rated          DATETIME      	        NOT NULL
);

/* Seed the movies database with values */
INSERT INTO movies (movie_title, movie_release_date)
VALUES ('The Hunt for Red October', '1990-03-02'),
       ('Lady Bird', '2017-12-01'),
       ('Inception', '2010-08-16');

/* Seed the movie genres database with values */
INSERT INTO movie_genres (movie_id, movie_genre)
VALUES (1, 'Action'),
       (1, 'Adventure'),
       (1, 'Thriller'),
       (2, 'Comedy'),
       (2, 'Drama'),
       (3, 'Action'),
       (3, 'Adventure'),
       (3, 'Sci-Fi');

/* Seed the consumers table with values */
INSERT INTO consumers (consumer_first_name, consumer_last_name,
		       consumer_address, consumer_city, consumer_state, consumer_zip)
VALUES ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', 46342),
       ('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincetown', 'NJ', 08088),
       ('Norobu', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', 37076),
       ('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', 06512);

/* Seed the ratings table with values */
INSERT INTO ratings (movie_id, consumer_id, rating_number_stars, when_rated)
VALUES (1, 1, 4, '2010-09-02 10:54:19'),
       (1, 3, 3, '2012-08-05 15:00:01'),
       (1, 4, 1, '2016-10-02 23:58:12'),
       (2, 3, 2, '2017-03-27 00:12:48'),
       (2, 4, 4, '2018-08-02 00:54:42');

/* Confirm that all of the tables were created correctly */
SHOW CREATE TABLE movies;
SHOW CREATE TABLE movie_genres;
SHOW CREATE TABLE consumers;
SHOW CREATE TABLE ratings;

/* Preview the tables */
SELECT *
  FROM movies;
SELECT *
  FROM movie_genres;
SELECT *
  FROM consumers;
SELECT *
  FROM ratings;

/* Natural join to view genres of the movies
SELECT movie_title, movie_genre
FROM movies
    NATURAL JOIN movie_genres; */