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
    PRIMARY KEY (pokemon_id, trainer_id),
    pokemon_id  VARCHAR(64) NOT NULL,
    trainer_id  INT(11) unsigned NOT NULL,
    FOREIGN KEY (trainer_id)
                REFERENCES trainers (trainer_id)
);

/* Seed the tables with some sample data */
INSERT INTO trainers (trainer_name)
VALUES ('Ian'),
       ('Patrick');

INSERT INTO pokemon (pokemon_id, trainer_id)
VALUES ('poke1', 1),
       ('poke2', 2);

/* Create functions to get a trainer's id and set a trainer's id for pokemon */
DROP FUNCTION IF EXISTS get_trainer_id;

CREATE FUNCTION get_trainer_id(poke_id VARCHAR(64)) RETURNS INT
RETURN (SELECT trainer_id
          FROM pokemon
         WHERE pokemon_id = poke_id);

/* Create a function to trade pokemon between 2 trainers */
DELIMITER //

CREATE PROCEDURE trade_pokemon(IN pokemon1 VARCHAR(64), IN pokemon2 VARCHAR(64))
BEGIN
    START TRANSACTION;
        SET @pokemon1_trainer = (get_trainer_id(pokemon1));
        SET @pokemon2_trainer = (get_trainer_id(pokemon2));

        UPDATE pokemon
           SET trainer_id = @pokemon1_trainer
         WHERE pokemon_id = pokemon2;

        UPDATE pokemon
           SET trainer_id = @pokemon2_trainer
         WHERE pokemon_id = pokemon1;
    COMMIT;
END //

DELIMITER ;

/* Let's show off our work */
      SELECT pokemon_id, trainer_name
        FROM trainers
NATURAL JOIN pokemon;

/* Trade poke1 and poke2 */
CALL trade_pokemon('poke1', 'poke2');

/* Show the results again */
      SELECT pokemon_id, trainer_name
        FROM trainers
NATURAL JOIN pokemon;