-- This SQL Project Displays my ability to create and alter tables. I also did some queries that showcase basic SQL skills

CREATE TABLE disney(
PRIMARY KEY(name),
name VARCHAR(20) UNIQUE NOT NULL,
popularity INTEGER NOT NULL,
votes INTEGER NOT NULL
)


ALTER TABLE disney
	ADD kindness INTEGER NOT NULL,
	ADD	intelligence INTEGER NOT NULL,
	ADD	courage INTEGER NOT NULL;




INSERT INTO disney(
	name, 
	popularity, 
	votes,
	kindness,
	intelligence,
	courage )

VALUES

('Belle', 1, 539, 9, 9, 7),
('Mulan', 2, 341, 6, 8, 9),
('Rapunzel', 3, 291, 8, 8, 7),
('Ariel', 4, 281, 8, 4, 7),
('Elsa', 5, 267, 7, 7, 7),
('Moana', 6, 251, 7, 7, 9),
('Jasmine', 7, 243, 8, 6, 8),
('Cinderella',8, 204, 9, 4, 5),
('Merida', 9, 187, 7, 7, 9),
('Tiana', 10, 126, 8, 9, 7),
('Anna', 11, 109, 8, 7, 7),
('Snow White',12, 95, 8, 5, 4),
('Aurora',13, 89, 6, 4, 4),
('Pocahontas',14, 77, 8, 8, 9),
('Esmeralda',15, 43, 9, 6, 7);


SELECT * FROM disney;



--Ordering the princess by popularity 

SELECT * 
FROM disney
ORDER BY popularity DESC
LIMIT 5;



--Find the average votes for all princesses'


SELECT ROUND(AVG(votes))
AS avg_votes
FROM disney
GROUP BY votes;


-- Add a new column for princesses' with an courage greater than 7 (call them fearless), and less than 6 (call them timid)

SELECT name,
CASE
	WHEN courage> 7 THEN 'fearless'
	WHEN courage < 6 THEN 'timid'
	ELSE 'brave'
END AS courage_rank
FROM disney
GROUP BY name, courage_rank;

-- Finding out Total Score for each princess

SELECT *, SUM(kindness+intelligence+courage) AS total
FROM disney
GROUP BY name
ORDER BY total DESC;