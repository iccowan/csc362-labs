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

-- Drop the previous version of the database if it exists
DROP DATABASE IF EXISTS movie_ratings;

-- Create the database
CREATE DATABASE movie_ratings;

-- Use the appropriate database
USE movie_ratings;

-- Now, create the 3 tables that we need and their fields
-- movies Table
SHOW CREATE TABLE movies(
    PRIMARY KEY  (movie_id),
    movie_id     INT(11)      NOT NULL UNSIGNED AUTO_INCREMENT,
    movie_title  VARCHAR(256) NOT NULL,
    release_date DATE         NOT NULL,
    genre        VARCHAR(256) NOT NULL
);

-- consumers Table
SHOW CREATE TABLE consumers(
    PRIMARY KEY (consumer_id),
    consumer_id INT(11)      NOT NULL UNSIGNED AUTO_INCREMENT,
    first_name  VARCHAR(64)  NOT NULL,
    last_name   VARCHAR(64)  NOT NULL,
    address     VARCHAR(128) NOT NULL,
    city        VARCHAR(64)  NOT NULL,
    state       CHAR(2)      NOT NULL,
    zip         INT(5)       NOT NULL
);

-- ratings Table
SHOW CREATE TABLE ratings(
    PRIMARY KEY  (movie_id, consumer_id),
    movie_id     INT(11)    NOT NULL UNSIGNED,
    FOREIGN KEY  (movie_id)
                 REFERENCES movies (movie_id)
                 ON DELETE RESTRICT,
    consumer_id  INT(11)    NOT NULL UNSIGNED,
    FOREIGN KEY  (consumer_id)
                 REFERENCES consumers (consumer_id)
                 ON DELETE RESTRICT,
    number_stars TINYINT(1) NOT NULL UNSIGNED,
    when_rated   DATE       NOT NULL
);