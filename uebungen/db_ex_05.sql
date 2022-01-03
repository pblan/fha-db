# author: a.voss@fh-aachen.de
# SQL-Commands Unit 0x05

# Schemas abfragen
SHOW SCHEMAS;
SHOW DATABASES;

# Schema anlegen, auflisten, als Default festlegen, löschen
CREATE SCHEMA MATSE_Test1;
SHOW SCHEMAS LIKE '%matse%';
USE MATSE_Test1;
DROP SCHEMA MATSE_Test1;
SHOW SCHEMAS;

# Tabellen in Schema abfragen, ggf. Schemaname anpassen
SHOW TABLES FROM matse_mhist;
SHOW TABLES FROM matse_mhist like 's%';

# Tabellenstruktur abfragen
# SHOW COLUMNS FROM abteilung FROM matse_mhist;
SHOW COLUMNS FROM matse_mhist.abteilung;
DESCRIBE matse_mhist.abteilung;

# Schema für die Tabellenkommandos anlegen
CREATE SCHEMA matse_bsp;
SHOW SCHEMAS LIKE '%matse%';
USE matse_bsp;

# Schema ist noch leer
SHOW TABLES FROM matse_bsp;

# Tabelle 'objekte' anlegen
CREATE TABLE objekte (
  id int primary key,
  name char(10) unique not null,
  kommentar varchar(255),
  nummer int(5),
  zahl decimal(8,3) default 0.0,
  erzeugt datetime default now(),
  wichtig boolean not null default true
);
SHOW COLUMNS FROM matse_bsp.objekte;

# Beispieldaten anlegen
INSERT INTO objekte (id,name) VALUES ('1','mueller');
INSERT INTO objekte (id,name,nummer) VALUES ('2','meier','3');
SELECT * FROM objekte;

# Tabelle ändern, Attribut hinzufüen
ALTER TABLE objekte ADD (
  image blob,
  eps double default 0.01
);
SELECT * FROM objekte;
SHOW COLUMNS FROM matse_bsp.objekte;

# Defaultwert ändern
ALTER TABLE objekte MODIFY eps float default 0.002;
SELECT * FROM objekte;
SHOW COLUMNS FROM matse_bsp.objekte;
# Name und Defaultwert ändern
ALTER TABLE objekte CHANGE eps feps float default 0.003;
SELECT * FROM objekte;
SHOW COLUMNS FROM matse_bsp.objekte;

# Attribute löschen
ALTER TABLE objekte DROP feps;
ALTER TABLE objekte DROP image;
SELECT * FROM objekte;
SHOW COLUMNS FROM matse_bsp.objekte;

ALTER TABLE objekte RENAME TO elemente;
SELECT * FROM elemente;

TRUNCATE TABLE elemente;
SELECT * FROM elemente;

DROP TABLE elemente;
SHOW TABLES FROM matse_bsp;


CREATE TABLE person (
person_id INT NOT NULL,
name VARCHAR(50) NOT NULL,
PRIMARY KEY (person_id)
);
INSERT INTO person (person_id,name) VALUES ('11','MIA');
INSERT INTO person (person_id,name) VALUES ('12','LEA');
SELECT * FROM person;

CREATE TABLE tier (
tier_id INT NOT NULL,
name VARCHAR(50) NOT NULL,
person_id INT NULL,
PRIMARY KEY (tier_id),
INDEX person_idx (person_id ASC),
CONSTRAINT fk_person FOREIGN KEY
(person_id) REFERENCES person (person_id) );

INSERT INTO tier (tier_id,name,person_id) VALUES ('1','Wuff','11');
INSERT INTO tier (tier_id,name) VALUES ('2','Bello');
SELECT * FROM tier M LEFT OUTER JOIN person F ON M.person_id=F.person_id;

### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###

# A5.1:

CREATE SCHEMA matse_sport;
USE matse_sport;

# A5.2:

CREATE TABLE IF NOT EXISTS sportler (
  id INT(11) NOT NULL,
  name VARCHAR(100) NOT NULL,
  geburtsdatum DATETIME NOT NULL,
  preisgeld DECIMAL(12,2) NULL DEFAULT 0,
  ist_mann boolean not null default 1,
  PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS wettkampf (
  id INT(11) NOT NULL,
  bezeichnung VARCHAR(100) NOT NULL,
  fuer_maenner TINYINT(1) NOT NULL,
  PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS team (
  id INT(11) NOT NULL,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS nimmt_teil_an (
  id INT(11) NOT NULL,
  sportler_id INT(11) NOT NULL,
  team_id INT(11) NULL DEFAULT NULL,
  wettkampf_id INT(11) NOT NULL,
  platz INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX fk1_idx (sportler_id ASC),
  INDEX fk2_idx (team_id ASC),
  INDEX fk3_idx (wettkampf_id ASC),
  CONSTRAINT fk1 FOREIGN KEY (sportler_id) REFERENCES sportler (id),
  CONSTRAINT fk2 FOREIGN KEY (team_id) REFERENCES team (id),
  CONSTRAINT fk3 FOREIGN KEY (wettkampf_id) REFERENCES wettkampf (id));

CREATE TABLE IF NOT EXISTS pfeift (
  id INT(11) NOT NULL,
  sportler_id INT(11) NOT NULL,
  wettkampf_id INT(11) NOT NULL,
  PRIMARY KEY (id),
  INDEX fk4_idx (sportler_id ASC),
  INDEX fk5_idx (wettkampf_id ASC),
	CONSTRAINT fk4 FOREIGN KEY (sportler_id) REFERENCES sportler (id),
	CONSTRAINT fk5 FOREIGN KEY (wettkampf_id) REFERENCES wettkampf (id)
);

# Daten

INSERT INTO `sportler` (`id`, `name`, `geburtsdatum`, `ist_mann`) VALUES ('101', 'Anna', '1990-2-1', '0');
INSERT INTO `sportler` (`id`, `name`, `geburtsdatum`, `ist_mann`) VALUES ('102', 'Olga', '1991-3-1', '0');
INSERT INTO `sportler` (`id`, `name`, `geburtsdatum`, `preisgeld`, `ist_mann`) VALUES ('111', 'Enie', '1992-4-1', '100', '0');
INSERT INTO `sportler` (`id`, `name`, `geburtsdatum`, `preisgeld`, `ist_mann`) VALUES ('112', 'Antje', '1993-5-1', '200', '0');
INSERT INTO `sportler` (`id`, `name`, `geburtsdatum`, `preisgeld`, `ist_mann`) VALUES ('121', 'Boris', '1990-6-1', '3000', '1');
INSERT INTO `sportler` (`id`, `name`, `geburtsdatum`, `preisgeld`, `ist_mann`) VALUES ('122', 'Ivan', '1991-7-1', '4000', '1');

INSERT INTO `team` (`id`, `name`) VALUES ('12345', 'Team NL');
INSERT INTO `team` (`id`, `name`) VALUES ('98765', 'Team PL');

INSERT INTO `wettkampf` (`id`, `bezeichnung`, `fuer_maenner`) VALUES ('56', 'Tennis Vorrunde Doppel', '0');
INSERT INTO `wettkampf` (`id`, `bezeichnung`, `fuer_maenner`) VALUES ('98', 'Tennis Finale Einzel', '1');
INSERT INTO `wettkampf` (`id`, `bezeichnung`, `fuer_maenner`) VALUES ('99', 'Tennis Finale Einzel', '0');

INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `team_id`, `wettkampf_id`) VALUES ('1', '101', '98765', '56');
INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `team_id`, `wettkampf_id`) VALUES ('2', '102', '98765', '56');
INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `team_id`, `wettkampf_id`) VALUES ('3', '111', '12345', '56');
INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `team_id`, `wettkampf_id`) VALUES ('4', '112', '12345', '56');
INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `wettkampf_id`) VALUES ('5', '101', '99');
INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `wettkampf_id`) VALUES ('6', '111', '99');
INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `wettkampf_id`) VALUES ('7', '121', '98');
INSERT INTO `nimmt_teil_an` (`id`, `sportler_id`, `wettkampf_id`) VALUES ('8', '122', '98');

INSERT INTO `pfeift` (`id`, `sportler_id`, `wettkampf_id`) VALUES ('1', '121', '56');
INSERT INTO `pfeift` (`id`, `sportler_id`, `wettkampf_id`) VALUES ('2', '122', '99');
INSERT INTO `pfeift` (`id`, `sportler_id`, `wettkampf_id`) VALUES ('3', '101', '98');

# Test

SELECT * FROM sportler;
SELECT * FROM wettkampf;
SELECT * FROM team;
SELECT * FROM pfeift;
SELECT * FROM nimmt_teil_an;

# falls man die Tabellen nochmal anlegen möchte
#DROP TABLE nimmt_teil_an;
#DROP TABLE pfeift;
#DROP TABLE sportler;
#DROP TABLE wettkampf;
#DROP TABLE team;

# A5.3: wer nimmt an mehr als 1 wettb. teil

SELECT sportler_id,count(*) FROM nimmt_teil_an
GROUP BY sportler_id HAVING count(*)>1;

SELECT S.name,count(*) FROM nimmt_teil_an
JOIN sportler S ON sportler_id=S.id
GROUP BY sportler_id HAVING count(*)>1;

# A5.4: wer pfeift keinen wettbewerb

SELECT S.name FROM sportler S
WHERE NOT exists (SELECT * FROM pfeift P WHERE P.sportler_id=S.id);

# A5.5: welche teams spielen in welchen wettbewerben

SELECT T.name, W.bezeichnung FROM nimmt_teil_an N
INNER JOIN wettkampf W ON N.wettkampf_id=W.id
INNER JOIN team T ON N.team_id=T.id
WHERE N.team_id IS NOT NULL
GROUP BY N.wettkampf_id, N.team_id ;

# A5.6: welche sportler stehen in einem finale?

SELECT S.name, W.bezeichnung FROM nimmt_teil_an N
INNER JOIN sportler S ON N.sportler_id=S.id
INNER JOIN wettkampf W ON N.wettkampf_id=W.id
WHERE N.wettkampf_id IN (
SELECT W.id FROM wettkampf W WHERE W.bezeichnung LIKE '%finale%'
);

