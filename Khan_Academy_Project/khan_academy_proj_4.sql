/* TASK 
 Think about your favorite apps, and pick one that stores your data- like a game that stores scores, an app that lets you post updates, etc. Now in this project, you're going to imagine that the app stores your data in a SQL database (which is pretty likely!), and write SQL statements that might look like their own SQL.
 
 CREATE a table to store the data.
 INSERT a few example rows in the table.
 Use an UPDATE to emulate what happens when you edit data in the app.
 Use a DELETE to emulate what happens when you delete data in the app.
 */

 
CREATE TABLE rides (
    ID INTEGER PRIMARY KEY,
    destination TEXT,
    payment_type TEXT,
    duration INTEGER,
    cost INTEGER
);


INSERT INTO rides VALUES (1,'Tel Aviv','Card',45,24);
INSERT INTO rides VALUES (2,'Kiryat Gat','Scan',45,13);
INSERT INTO rides VALUES (3,'Tel Aviv','Card',45,24);
INSERT INTO rides VALUES (4,'Kiryat Gat','Card',58,13);
INSERT INTO rides VALUES (5,'Tel Aviv','Scan',45,24);
INSERT INTO rides VALUES (6,'Be`er Sheva','Scan',67,17);
INSERT INTO rides VALUES (7,'Tel Aviv','Card',45,24);
INSERT INTO rides VALUES (8,'Kiryat Gat','Scan',58,13);
INSERT INTO rides VALUES (9,'Haifa','Tap',87,48);
INSERT INTO rides VALUES (10,'Kiryat Gat','Scan',58,13);


SELECT
    *
FROM
    rides;


UPDATE
    rides
SET
    destination = 'Hezeliya'
WHERE
    id = 9;


SELECT
    *
FROM
    rides
ORDER BY
    id ASC;


DELETE FROM
    rides
WHERE
    id = 6
    OR id = 7;


SELECT
    *
FROM
    rides
ORDER BY
    id ASC;