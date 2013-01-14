--DROP TABLE IF EXISTS ships;
--DROP TABLE IF EXISTS fleets;
--DROP TABLE IF EXISTS pilots;

CREATE TABLE pilots
(
`id`	INT NOT NULL,
`name`	VARCHAR(32) NOT NULL,
PRIMARY KEY(`id`)
);

CREATE TABLE fleets
(
`id`				INT NOT NULL AUTO_INCREMENT,
`name`				VARCHAR(16) NOT NULL,
`fc`				INT NOT NULL,
`creation_time`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`motd`				TEXT,
`password`			VARCHAR(16),
`public`			INT(1) DEFAULT 1 NOT NULL,
PRIMARY KEY(`id`)
) ENGINE=InnoDB;

CREATE TABLE ships
(
`fleet`			INT NOT NULL,
`owner`			INT NOT NULL,
`dna`			VARCHAR(1024),
`last_ping`		UNSIGNED INT, -- future use as clients will callback to the server every 10-20 seconds
PRIMARY KEY(`id`),
UNIQUE KEY(`owner`,`fleet`)
) ENGINE=InnoDB;

-- Delete ships attached to a fleet when the fleet that they are attached to is deleted.
ALTER TABLE ships ADD CONSTRAINT fk_fleet FOREIGN KEY(fleet) REFERENCES fleets(id) ON DELETE CASCADE
