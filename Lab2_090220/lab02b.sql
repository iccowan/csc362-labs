/*
    Lab 02b: MariaDB Tutorial
    CSC 362 Database Systems
    Ian Cowan

    This script creates the instructor table that can be found in the
    DD textbook.

    Created 09/01/2020
*/

/* Create the database and drop the previous version if it exists */
DROP DATABASE IF EXISTS school;

CREATE DATABASE school;

USE school;

/* Create the table */
CREATE TABLE instructors (
    PRIMARY KEY (instructor_id),
    instructor_id   INT unsigned NOT NULL AUTO_INCREMENT,
    inst_first_name VARCHAR(20)  NOT NULL,
    inst_last_name  VARCHAR(20)  NOT NULL,
    campus_phone    CHAR(8)      NOT NULL
);

/* Insert the sample values from the textbook */
INSERT INTO instructors (inst_first_name, inst_last_name, campus_phone)
VALUES
    ('Kira', 'Bently', '363-9948'),
    ('Timothy', 'Ennis', '527-4992'),
    ('Shannon', 'Black', '336-5992'),
    ('Estela', 'Rosales', '322-6992');

/* Display the table */
SELECT * FROM instructors;
