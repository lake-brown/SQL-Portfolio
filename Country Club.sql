-- querying a database i imported with multiple tables

#1. How many facilities have a cost to guests of 10 or more.

SELECT COUNT(*) FROM cd.facilities 
WHERE guestcost >= 10;


#2. How many  slots were booked per facility in the month of September 2012.

SELECT facid, sum(slots) AS "Total Slots"
FROM cd.bookings 
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01' GROUP BY facid ORDER BY SUM(slots);

#2. Produce a list of facilities with more than 1000 slots booked. 

SELECT facid, sum(slots) AS total_slots 
FROM cd.bookings 
GROUP BY facid 
HAVING SUM(slots) > 1000 
ORDER BY facid;

#3. What facilities charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? 

SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 AND
(membercost < monthlymaintenance/50.0);

#4 what are the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT cd.bookings.starttime AS start, cd.facilities.name 
AS name 
FROM cd.facilities 
INNER JOIN cd.bookings
ON cd.facilities.facid = cd.bookings.facid 
WHERE cd.facilities.facid IN (0,1) 
AND cd.bookings.starttime >= '2012-09-21' 
AND cd.bookings.starttime < '2012-09-22' 
ORDER BY cd.bookings.starttime;



