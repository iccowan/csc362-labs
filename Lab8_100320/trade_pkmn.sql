/* Create the database */
DROP DATABASE IF EXISTS trade_pkmn;
CREATE DATABASE trade_pkmn;
USE trade_pkmn;

/* Create the tables */
CREATE TABLE trainers (
    PRIMARY KEY  (trainer_id),
    trainer_id   INT(11) unsigned NOT NULL AUTO_INCREMENT,
    trainer_name VARCHAR(128) NOT NULL
);

CREATE TABLE pokemon (
    PRIMARY KEY (pokemon_id),
    pokemon_id  VARCHAR(64) NOT NULL,
    trainer_id  INT(11) unsigned NOT NULL,
    FOREIGN KEY (trainer_id)
                REFERENCES trainers (trainer_id)
);

/* Seed the tables with some sample data */
INSERT INTO trainers (trainer_name)
VALUES ('Ian'),
       ('Patrick'),
       ('Danny'),
       ('TK'),
       ('Sean'),
       ('Newcomb'),
       ('Drake'),
       ('Owen');

INSERT INTO pokemon (pokemon_id, trainer_id)
VALUES ('poke1', 1),
       ('poke2', 2),
       ('poke3', 1),
       ('poke4', 3);

DELIMITER $$

CREATE FUNCTION get_trainer_id(poke_id VARCHAR(64)) RETURNS INT
BEGIN
    RETURN (SELECT trainer_id
             FROM pokemon
            WHERE pokemon_id = poke_id);
END $$

DELIMITER ;