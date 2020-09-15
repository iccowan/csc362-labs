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
/* rugs table */
CREATE TABLE rugs (
    PRIMARY KEY    (rug_id),
    rug_id         INT(11) unsigned NOT NULL AUTO_INCREMENT,
    description    VARCHAR(64)      NOT NULL,
    purchase_price FLOAT(7,2)       NOT NULL,
    date_acquired  DATE             NOT NULL,
    markup         INT(3)           NOT NULL,
    list_price     FLOAT(7,2)       NOT NULL
);

/* customers Table */
CREATE TABLE customers (
    PRIMARY KEY      (customer_id),
    customer_id      INT(11) unsigned NOT NULL AUTO_INCREMENT,
    customer_name    VARCHAR(64)      NOT NULL,
    customer_address VARCHAR(256)     NOT NULL,
    customer_phone   VARCHAR(10),
    is_active        TINYINT(1)       NOT NULL DEFAULT(1)
);

/* purchases Table */
CREATE TABLE purchases (
    PRIMARY KEY   (purchase_id),
    FOREIGN KEY   (customer_id)
                  REFERENCES customers (customer_id)
                  ON DELETE RESTRICT,
    FOREIGN KEY   (rug_id)
                  REFERENCES rugs (rug_id)
                  ON DELETE RESTRICT,
    purchase_id   INT(11) unsigned NOT NULL AUTO_INCREMENT,
    customer_id   INT(11) unsigned NOT NULL,
    rug_id        INT(11) unsigned NOT NULL,
    date_of_sale  DATE             NOT NULL,
    sale_price    FLOAT(7,2)       NOT NULL,
    profit        FLOAT(7,2)       NOT NULL,
    date_returned DATE
);

/* trials Table */
CREATE TABLE trials (
    PRIMARY KEY        (trial_id),
    FOREIGN KEY        (customer_id)
                       REFERENCES customers (customer_id)
                       ON DELETE RESTRICT,
    FOREIGN KEY        (rug_id)
                       REFERENCES rugs (rug_id)
                       ON DELETE RESTRICT,
    trial_id           INT(11) unsigned NOT NULL AUTO_INCREMENT,
    customer_id        INT(11) unsigned NOT NULL,
    rug_id             INT(11) unsigned NOT NULL,
    start_date         DATE             NOT NULL,
    end_date           DATE             NOT NULL,
    actual_return_date DATE
);

/*
*   This trigger will run every time a new record is inserted into
*   the trials table and confirm that the customer doesn't already have
*   4 or more active trials.
*/
DELIMITER $$
CREATE TRIGGER max_trials
    BEFORE INSERT ON trials
    FOR EACH ROW
BEGIN
        IF (SELECT COUNT(*)
              FROM trials
             WHERE trials.customer_id = NEW.customer_id
               AND trials.actual_return_date IS NULL) >= 4
        THEN
            SIGNAL SQLSTATE '14000'
               SET MESSAGE_TEXT='Unable to create new trial. This customer already has 4 or more active trials.';
        END IF;
END;
$$
DELIMITER ;

/* Seed some values into the database */
/* Insert some rugs */
INSERT INTO rugs (description, purchase_price, date_acquired, markup, list_price)
VALUES
    ('Turkey Ushak 1925 5x7 Wool', 625.00, '2017/04/06', 100, 1250.00),
    ('Iran Tabriz 1910 10x14 Silk', 28000.00, '2017/04/06', 75, 49000.00),
    ('India Agra 2017 Wool 8x10', 1200.00, '2017/06/15', 100, 2400.00),
    ('India Agra 2017 Wool 4x6', 450.00, '2017/06/15', 120, 990.00),
    ('India Agra 2019 Wool 4x6', 450.00, '2019/06/15', 120, 990.00),
    ('India Agra 2018 Wool 8x10', 1200.00, '2018/06/15', 100, 2400.00),
    ('India Agra 2020 Wool 8x10', 1400.00, '2020/06/15', 100, 2800.00),
    ('India Agra 2019 Wool 8x10', 1400.00, '2019/06/15', 100, 2800.00);

/* Insert some customers */
INSERT INTO customers (customer_name, customer_address, customer_phone)
VALUES
    ('Akira Ingram', '68 Country Drive, Roseville, MI 48066', '9262526716'),
    ('Meredith Spencer', '9044 Piper Lane, North Royalton, OH 44133', '8175305994'),
    ('Marco Page', '747 East Harrison Lab, Atlanta, GA, 30303', '5887996535'),
    ('Sandra Page', '747 East Harrison Lab, Atlanta, GA, 30303', '9976972666'),
    ('Bria Le', '386 Silver Spear Court, Coraopolis, PA 15108', '9994943316'),
    ('Gloria Gomez', '78 Corona Rd., Fullerton, CA 92831', '8679262585');

/* Insert some purchases */
INSERT INTO purchases (customer_id, rug_id, date_of_sale, sale_price, profit, date_returned)
VALUES
    (6, 1, '2017/12/14', 990, 365, NULL),
    (2, 2, '2017/12/24', 40000, 12000, '2017/12/26');

/* Insert some trials that should work correctly */
INSERT INTO trials (customer_id, rug_id, start_date, end_date)
VALUES
    (1, 6, '2020/08/13', '2020/10/13'),
    (1, 7, '2020/09/13', '2020/11/13'),
    (1, 5, '2020/06/22', '2020/08/22'),
    (1, 4, '2020/09/13', '2020/11/13'),
    (3, 3, '2020/09/14', '2020/11/14');

/* Look at the table */
      SELECT customer_name, rug_id, start_date, end_date, actual_return_date
        FROM trials
NATURAL JOIN customers;

/* Now, let's insert a trial value that should break the database as a test */
INSERT INTO trials (customer_id, rug_id, start_date, end_date)
VALUES
    (1, 8, '2020/09/21', '2020/11/21');

/* Look at the table */
      SELECT customer_name, rug_id, start_date, end_date, actual_return_date
        FROM trials
NATURAL JOIN customers;

/* Now, let's say one rug was returned so the previous insertion should now work */
UPDATE trials
   SET trials.actual_return_date = '2020/09/14'
 WHERE trials.trial_id = 3;

/* Look at the table */
      SELECT customer_name, rug_id, start_date, end_date, actual_return_date
        FROM trials
NATURAL JOIN customers;

 /* Now, try the insertion again */
INSERT INTO trials (customer_id, rug_id, start_date, end_date)
VALUES
    (1, 8, '2020/09/21', '2020/11/21');

/* Finally, look at the table one more time */
      SELECT customer_name, rug_id, start_date, end_date, actual_return_date
        FROM trials
NATURAL JOIN customers;