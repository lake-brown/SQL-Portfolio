--In this SQL query i am showcasing ability to perform common joins in database with multiple tables.



---What are the shows that involve magic?

SELECT *
FROM anime
FULL OUTER JOIN category
ON anime.series_id = category.series_id
WHERE category.genre LIKE '%Magic%'

--Which anime has the most episodes?

SELECT anime.title, anime.rating, category.genre, anime.episodes FROM anime
INNER JOIN category
ON anime.series_id = category.series_id
ORDER BY episodes DESC;

--How many titles are PG-13?

SELECT COUNT(*) FROM anime
WHERE rating LIKE 'PG-13%';
  
What are the shows that have a rating PG-13?

SELECT anime.title, anime.rating, category.genre, anime.episodes FROM anime
LEFT JOIN category
ON anime.series_id = category.series_id
WHERE rating LIKE 'PG-13%'
ORDER BY episodes DESC;
  
  