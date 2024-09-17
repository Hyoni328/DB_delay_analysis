/***************************
1. Setting up the environment
***************************/

-- DROP DATABASE IF EXISTS deutschebahn;
-- CREATE DATABASE deutschebahn;
USE deutschebahn;



/***************************
2. Creating the table
***************************/

-- All
DROP TABLE IF EXISTS timetable;
CREATE TABLE timetable (
	timetable_id INT AUTO_INCREMENT,
    line VARCHAR(8) NOT NULL,
    `path` VARCHAR (4000),
    eva_nr INT,
    category INT,
    station VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    zip INT,
    `long` FLOAT,
    lat FLOAT,
    arrival_plan DATETIME,
    departure_plan DATETIME,
    arrival_change DATETIME,
    departure_change DATETIME,
    arrival_delay_m INT,
    departure_delay_m INT,
    info VARCHAR (100),
    arrival_delay_check VARCHAR (10),
    departure_delay_check VARCHAR (10),
    PRIMARY KEY (timetable_id)
);

    
    
    
-- Station
DROP TABLE IF EXISTS station;
CREATE TABLE station (
    station_id INT AUTO_INCREMENT,
    eva_nr INT,
    category INT,
    station VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    zip INT,
    `long` FLOAT,
    `lat` FLOAT,
    PRIMARY KEY (station_id)
);

SELECT *
FROM station;


/***************************
3. Question
***************************/
-- 1. Most delayed Line
## Total

SELECT *
FROM timetable;

## total train line 
SELECT 
	city,
    line,
    CONCAT(city, ' ', line) AS city_line,
    COUNT(*) AS total_train
FROM timetable
GROUP BY city, line
LIMIT 100; 

## delayed train line
SELECT 
	city, 
    line, 
	CONCAT(city, ' ', line) AS city_line,
    COUNT(*) AS delay_train,
    AVG(arrival_delay_m) avg_arr_delay,
    AVG(departure_delay_m) avg_dep_delay 
FROM timetable
WHERE arrival_delay_check = 'delay' or departure_delay_check = 'delay'
GROUP BY city, line
LIMIT 100;


## join 2 tables
WITH total_train_by_line AS (
SELECT 
	city,
    line,
    CONCAT(city, ' ', line) AS city_line,
    COUNT(*) AS total_train
FROM timetable
GROUP BY city, line),
delayed_train_by_line AS (
SELECT 
	city, 
    line, 
	CONCAT(city, ' ', line) AS city_line,
    COUNT(*) AS delay_train,
	AVG(arrival_delay_m) avg_arr_delay,
    AVG(departure_delay_m) avg_dep_delay 
FROM timetable
WHERE arrival_delay_check = 'delay' or departure_delay_check = 'delay'
GROUP BY city, line)
SELECT
	t.city,
    t.line,
    total_train,
    delay_train,
    delay_train / total_train *100 AS delay_rate,
	avg_arr_delay,
    avg_dep_delay 
FROM total_train_by_line t
JOIN delayed_train_by_line d USING (city_line)
ORDER BY delay_rate, total_train DESC;