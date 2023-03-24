/* Marvel Heroes and Villains
 Based on the website http://marvel.wikia.com/Main_Page
 with popularity data from http://observationdeck.io9.com/something-i-found-marvel-character-popularity-poll-cb-1568108064 
 and power grid data from http://marvel.wikia.com/Power_Grid#Power
 Collected by: https://www.khanacademy.org/profile/Mentrasto/
 */

-- Table 1: Characters
CREATE TABLE Characters 
(ID INTEGER PRIMARY KEY,
name TEXT,
gender TEXT,
alignment TEXT,
hometown TEXT);

INSERT INTO Characters VALUES(1,'Spider Man','Male','Good','USA');
INSERT INTO Characters VALUES(2,'Iron Man','Male','Neutral','USA');
INSERT INTO Characters VALUES(3,'Hulk','Male','Good','USA');
INSERT INTO Characters VALUES(4,'Wolverine','Male','Good','Canada');
INSERT INTO Characters VALUES(5,'Thor','Male','Good','Asgard');
INSERT INTO Characters VALUES(6,'Green Goblin','Male','Bad','USA');
INSERT INTO Characters VALUES(7,'Magneto','Male','Neutral','Germany');
INSERT INTO Characters VALUES(8,'Thanos','Male','Bad','Titan');


--Table 2: Abilities
CREATE TABLE Abilities 
(ID INTEGER PRIMARY KEY,
strength INTEGER,
speed INTEGER,
durability INTEGER,
fighting_skills INTEGER);

INSERT INTO Abilities VALUES(1,4,3,3,4);
INSERT INTO Abilities VALUES(2,6,5,6,4);
INSERT INTO Abilities VALUES(3,7,3,7,4);
INSERT INTO Abilities VALUES(4,4,2,4,7);
INSERT INTO Abilities VALUES(5,7,7,6,4);
INSERT INTO Abilities VALUES(6,4,3,4,3);
INSERT INTO Abilities VALUES(7,3,5,4,4);
INSERT INTO Abilities VALUES(8,7,7,6,4);


--Table 3: Measures
CREATE TABLE Measures 
(ID INTEGER PRIMARY KEY,
height_m NUMERIC,
weight_kg NUMERIC);

INSERT INTO Measures VALUES(1,1.78,75.75);
INSERT INTO Measures VALUES(2,1.98,102.58);
INSERT INTO Measures VALUES(3,2.44,635.29);
INSERT INTO Measures VALUES(4,1.6,88.46);
INSERT INTO Measures VALUES(5,1.98,290.3);
INSERT INTO Measures VALUES(6,1.93,174.63);
INSERT INTO Measures VALUES(7,1.88,86.18);
INSERT INTO Measures VALUES(8,2.01,446.79);

-- Find the name, height and weight of all characters sorted by height in descending order:
SELECT Characters.name, Measures.height_m, Measures.weight_kg
FROM Characters
JOIN Measures ON Characters.ID = Measures.ID
ORDER BY Measures.height_m DESC;

-- Find the names of all characters with a durability score of 7 or higher:
SELECT Characters.name
FROM Characters
JOIN Abilities ON Characters.ID = Abilities.ID
WHERE Abilities.durability >= 7;

-- Find the name and fighting skills score of the strongest character:
SELECT Characters.name, Abilities.fighting_skills
FROM Characters
JOIN Abilities ON Characters.ID = Abilities.ID
WHERE Abilities.strength = (SELECT MAX(strength) FROM Abilities);

