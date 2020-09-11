/*
*   Lab 05: Flying Carpets Gallery
*   CSC 362 Database Systems
*   Ian Cowan
*
*   This script creates the database and tables required for the
*   Flying Carpets Gallery storage of rugs, customers, purchases,
*   and trials.
*
*   Created 09/15/2020
*/

/* Create the database and drop the old version if it exists */
DROP DATABASE IF EXISTS flying_carpets;

CREATE DATABASE flying_carpets;

USE flying_carpets;

/* Create the necessary tables */
CREATE TABLE rugs (
    PRIMARY_KEY (rug_id),
    rug_id INT(11) unsigned NOT NULL AUTO_INCREMENT,
    description VARCHAR(64) NOT NULL,
    purchase_price FLOAT(7,2) NOT NULL,
    date_acquired DATE NOT NULL,
    markup INT(3) NOT NULL,
    list_price FLOAT(7,2) NOT NULL
);

CREATE TABLE customers (
    PRIMARY_KEY (customer_id),
    customer_id INT(11) unsigned NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(64) NOT NULL,
    customer_address VARCHAR(256) NOT NULL,
    customer_phone VARCHAR(10),
    is_active TINYINT(1) NOT NULL DEFAULT(1)
);