INSERT INTO aircraft (type, fuelAmount, maxLoad) VALUES (B747, 59254, 50000), (B757, 45293, 60000), (B757, 54720, 60000), (B757, 23000, 60000), (B747, 57345, 50000)

INSERT INTO airport (airportCode, name) VALUES
('EWR', 'Newark International'),
('IAD', 'Dulles International Airport'),
('JFK' ,'JFK International Airport'),
('LAX' ,'Los Angeles Airport'),
('ORD' ,"O'Hare International Airport"),
('PHL' ,'Philadelphia Airport'),
('SEA' ,'Tacoma International Airport');

INSERT INTO `crew`(`crewID`, `pilotName`, `navigatorName`) VALUES 

("E4510", "Clarence Over", "Karim Abdul Jabar"),
("F4578", "Bill Buckner", "Mookie Wilson"),
("F5620", "Bob Johnson", "John Bobson"),
("J3476", "Jason Crabman", "Michael Pokemon"),
("N2063", "Molly Ringwald", "Allie Sheedie"),
("R4187", "Warren Moon", "Bernie Parmalee"),
("Z4538", "Jack Bauer", "Lisa Turtle")



INSERT INTO `cargo`(`skidID`, `weight`, `contents`, `fromMD`, `flightNumber`) VALUES
("1017",	6921, "20 Cases of Sombreros"),
("1048",	5743, "75 Lead Ingots"),
("1090",	8992, "12 Pieces luggage, 2 Pirate Chests"),
("1039",	6810, "500 Cases of SPAM"),
("1055",	3587, "83 Boxes of Mix Tapes"),
("1065",	8854, "Twelve Crates of Snakes"),
("1075",	4459, "3 Flux Capacitors")

INSERT INTO `flight`(`flightNumber`, `tailNumber`, `crewID`, `destination`, `origin`, `departureTime`, `arrivalTime`) VALUES
("ER902", "10000", "R4187", "ORD", "SEA", "2017-10-12 07:32:00", "2017-10-12 10:35:00"),
("FG218", "10001", "N2063", "IAD", "JFK", "2017-10-25 11:39:00", "2017-10-25 13:21:00"),
("JB237", "10002", "E4510", "EWR", "LAX", "2017-10-03 08:36:01", "2017-10-04 10:46:00"),
("NR110", "10003", "Z4538", "PHL", "LAX", "2017-10-02 16:40:00", "2017-10-02 20:37:00"),
("SP035", "10004", "J3476", "SEA", "IAD", "2017-09-22 17:08:00", "2017-09-22 20:25:00"),
("VH476", "10005", "F5620", "PHL", "ORD", "2017-11-08 10:46:00", "2017-10-08 14:09:00"),
("ZX070", "10006", "F4578", "ORD", "EWR", "2017-10-13 07:54:00", "2017-10-13 09:13:00")



SELECT flight.flightNumber, SUM(weight) AS Total
FROM cargo 
RIGHT JOIN flight
	ON flight.flightNumber = cargo.flightNumber


SELECT flight.flightNumber, SUM(weight) AS Total
FROM cargo 
RIGHT JOIN flight
	ON flight.flightNumber = cargo.flightNumber
WHERE flight.flightNumber IN (SELECT DISTINCT flightNumber FROM cargo)


SELECT cargo.flightNumber, SUM(weight) AS currentLoad FROM cargo GROUP BY flightNumber 


SELECT flight.flightNumber, flight.tailNumber, flight.crewID, flight.destination, flight.origin, flight.departureTime, flight.arrivalTime, `Load`.currentLoad FROM flight INNER JOIN (SELECT cargo.flightNumber, SUM(weight) AS currentLoad FROM cargo GROUP BY flightNumber) AS `Load` WHERE flight.flightNumber = `Load`.flightNumber 


SELECT flight.flightNumber, flight.tailNumber, flight.crewID, flight.destination, flight.origin, flight.departureTime, flight.arrivalTime, `Load`.currentLoad, aircraft.maxLoad
FROM flight
INNER JOIN
(SELECT cargo.flightNumber, SUM(weight) AS currentLoad FROM cargo GROUP BY flightNumber) AS `Load`
INNER JOIN aircraft
WHERE flight.flightNumber = `Load`.flightNumber 
AND flight.tailNumber = aircraft.tailNumber
AND `Load`.currentLoad < aircraft.maxLoad

SELECT flight.flightNumber, flight.tailNumber, flight.crewID, flight.destination, flight.origin, flight.departureTime, flight.arrivalTime
FROM flight
INNER JOIN
((SELECT cargo.flightNumber, SUM(weight) AS currentLoad FROM cargo GROUP BY flightNumber) AS `Load`
INNER JOIN aircraft
WHERE (flight.flightNumber IN `Load` 
AND flight.tailNumber = aircraft.tailNumber
AND `Load`.currentLoad < aircraft.maxLoad)
OR flight.flightNumber NOT IN `Load`

SELECT DISTINCT flight.flightNumber 
FROM flight
INNER JOIN cargo
WHERE flight.flightNumber IN (SELECT DISTINCT flightNumber FROM cargo)
OR
flight.flightNumber NOT IN (SELECT DISTINCT flightNumber FROM cargo)


SELECT DISTINCT flight.flightNumber, flight.tailNumber, flight.crewID, flight.destination, flight.origin, flight.departureTime, flight.arrivalTime, `Load`.currentLoad
FROM flight
INNER JOIN
(SELECT cargo.flightNumber, SUM(weight) AS currentLoad FROM cargo GROUP BY flightNumber) AS `Load`
INNER JOIN aircraft
WHERE flight.flightNumber 
IN (SELECT DISTINCT flightNumber FROM cargo)
AND flight.tailNumber = aircraft.tailNumber
AND `Load`.currentLoad < aircraft.maxLoad
OR flight.flightNumber 
NOT IN (SELECT DISTINCT flightNumber FROM cargo)


SELECT DISTINCT flight.flightNumber, flight.tailNumber, flight.crewID, flight.destination, flight.origin, flight.departureTime, flight.arrivalTime FROM flight 
INNER JOIN (SELECT cargo.flightNumber, SUM(weight) AS currentLoad FROM cargo GROUP BY flightNumber) AS `Load` 
INNER JOIN aircraft 
WHERE flight.flightNumber IN (SELECT DISTINCT flightNumber FROM flight) 
AND flight.tailNumber = aircraft.tailNumber 
OR `Load`.currentLoad < aircraft.maxLoad 

SELECT DISTINCT flight.flightNumber, shipment.currentLoad FROM flight LEFT JOIN (SELECT cargo.flightNumber, SUM(cargo.weight) AS currentLoad FROM cargo GROUP BY cargo.flightNumber) AS shipment ON flight.flightNumber = shipment.flightNumber 

SELECT DISTINCT flight.flightNumber, flight.tailNumber, flight.crewID, flight.destination, flight.origin, flight.departureTime, flight.arrivalTime, shipment.currentLoad, aircraft.maxLoad FROM flight LEFT JOIN (SELECT cargo.flightNumber, SUM(cargo.weight) AS currentLoad FROM cargo GROUP BY cargo.flightNumber) AS shipment ON flight.flightNumber = shipment.flightNumber LEFT JOIN aircraft ON flight.tailNumber = aircraft.tailNumber WHERE shipment.currentLoad < aircraft.maxLoad OR shipment.currentLoad IS NULL 


SELECT DISTINCT cargo.flightNumber 
FROM cargo
INNER JOIN flight
ON cargo.flightNumber = flight.flightNumber
INNER JOIN aircraft
ON flight.tailNumber = aircraft.tailNumber
INNER JOIN
(SELECT flightNumber, SUM(cargo.weight) AS currentLoad FROM cargo GROUP BY flightNumber) AS shipment
ON shipment.flightNumber = flight.flightNumber
WHERE cargo.flightNumber = "FG218" 
AND currentLoad + 3000 <= maxLoad


INSERT INTO cargo (weight, contents, fromMD, flightNumber) VALUES (3000, "Lambs", 1, "FG218")
SELECT LAST_INSERT_ID() 