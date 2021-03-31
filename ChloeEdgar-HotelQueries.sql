USE hotel;

-- 1. Write a query that returns a list of reservations that end in July 2023
-- including the name of the guest, the room number(s), and the reservation dates.
SELECT 
	rm.roomId, 
    gt.firstName, 
    gt.lastName, 
    rn.startDate, 
    rn.endDate
FROM guests gs 
INNER JOIN guest gt
ON gs.guestId = gt.guestId
INNER JOIN reservation rn 
ON rn.reservationId = gs.reservationId
INNER JOIN roomsReserved rr
ON rr.reservationId = rn.reservationId
INNER JOIN room rm
ON rm.roomId = rr.roomId
WHERE MONTH(rn.endDate)=7 AND YEAR(rn.endDate)=2023;
/* 1. ANS:
# roomId, firstName, lastName, startDate, endDate
'205', 'Chloe', 'Edgar', '2023-06-28', '2023-07-02'
'303', 'Bettyann ', 'Seery', '2023-07-28', '2023-07-29'
'204', 'Walter', 'Holaway', '2023-07-13', '2023-07-14'
'401', 'Wilfred', 'Vise', '2023-07-18', '2023-07-21'
*/

-- 2. Write a query that returns a list of reservations for rooms with
-- a jacuzzi, displaying the guest's name, the room number, and the dates
-- of the reservation.
SELECT 
	rm.roomId, 
    gt.firstName, 
    gt.lastName, 
    rn.startDate, 
    rn.endDate
FROM guests gs 
INNER JOIN guest gt
ON gs.guestId = gt.guestId
INNER JOIN reservation rn 
ON rn.reservationId = gs.reservationId
INNER JOIN roomsReserved rr
ON rr.reservationId = rn.reservationId
INNER JOIN room rm
ON rm.roomId = rr.roomId
INNER JOIN roomAmenities ra
ON ra.roomId = rm.roomId
INNER JOIN amenity ay
ON ay.amenityId = ra.amenityId
WHERE ay.name = 'Jacuzzi';

/* 2. ANS
# roomId, firstName, lastName, startDate, endDate
'201', 'Karie ', 'Yang', '2023-03-06', '2023-03-07'
'203', 'Bettyann ', 'Seery', '2023-02-05', '2023-02-10'
'203', 'Karie ', 'Yang', '2023-09-13', '2023-09-15'
'205', 'Chloe', 'Edgar', '2023-06-28', '2023-07-02'
'207', 'Wilfred', 'Vise', '2023-04-23', '2023-04-24'
'301', 'Walter', 'Holaway', '2023-04-09', '2023-04-13'
'301', 'Mark', 'Simmer', '2023-11-22', '2023-11-25'
'303', 'Bettyann ', 'Seery', '2023-07-28', '2023-07-29'
'305', 'Duane ', 'Cullison', '2023-02-22', '2023-02-24'
'305', 'Bettyann ', 'Seery', '2023-08-30', '2023-09-01'
'307', 'Chloe', 'Edgar', '2023-03-17', '2023-03-20'
*/

-- 3. Write a query that returns all rooms reserved for a specific guest
-- including the guest's name, the room(s) reserved, the starting date of
-- the reservation, and how many people were included in the reservation.
-- (choose a guest's name from the existing data.)
SELECT DISTINCT
	rm.roomId, 
    gt.firstName, 
    gt.lastName, 
    rn.startDate, 
    rn.endDate,
    gs.quantityAdults + gs.quantityChildren AS quantity_people
FROM guests gs 
INNER JOIN guest gt
ON gs.guestId = gt.guestId
INNER JOIN reservation rn 
ON rn.reservationId = gs.reservationId
INNER JOIN roomsReserved rr
ON rr.reservationId = rn.reservationId
INNER JOIN room rm
ON rm.roomId = rr.roomId
INNER JOIN roomAmenities ra
ON ra.roomId = rm.roomId
INNER JOIN amenity ay
ON ay.amenityId = ra.amenityId
WHERE gt.firstName = 'Wilfred' AND gt.lastName = 'Vise';

/* 3. ANS
# roomId, firstName, lastName, startDate, endDate, quantity_people
'207', 'Wilfred', 'Vise', '2023-04-23', '2023-04-24', '2'
'401', 'Wilfred', 'Vise', '2023-07-18', '2023-07-21', '6'
*/

-- 4. Write a query that returns a list of rooms, reservation ID and per-room
-- cost for each reservation. The results should include all rooms, whether
-- or not there is a reservation associated with the room.
SELECT
    rm.roomId,
    rn.reservationId,
   CASE WHEN (gs.quantityAdults - rt.standardOccupancy)>0  -- when there are extra adults
		THEN rm.basePrice*DATEDIFF(rn.endDate, rn.startDate)+(gs.quantityAdults - rt.standardOccupancy)*rt.extraPersonCost -- add the extra charge per person
        ELSE rm.basePrice*DATEDIFF(rn.endDate, rn.startDate) END AS total_room_cost
FROM room rm  -- Left table
LEFT JOIN roomsReserved rr 
ON rr.roomId = rm.roomId 
LEFT JOIN reservation rn
ON rn.reservationId = rr.reservationId
LEFT JOIN roomType rt
ON rt.roomTypeId = rm.roomTypeId
LEFT JOIN guests gs
ON gs.reservationId = rn.reservationId
ORDER BY roomId;

/* 4. ANS
# roomId, reservationId, total_room_cost
'201', '4', '199.99'
'202', '7', '349.98'
'203', '2', '999.95'
'203', '21', '399.98'
'204', '16', '184.99'
'205', '15', '699.96'
'206', '12', '599.96'
'206', '23', '449.97'
'207', '10', '174.99'
'208', '13', '599.96'
'208', '20', '149.99'
'301', '9', '799.96'
'301', '24', '599.97'
'302', '6', '884.95'
'302', '25', '699.96'
'303', '18', '199.99'
'304', '8', '874.95'
'304', '14', '184.99'
'305', '3', '349.98'
'305', '19', '349.98'
'306', NULL, NULL
'307', '5', '524.97'
'308', '1', '299.98'
'401', '11', '1199.97'
'401', '17', '1219.97'
'401', '22', '1199.97'
'402', NULL, NULL
/*

-- 5. Write a query that returns all rooms with a capacity of three or more and that
-- are reserved on any date in Aril 2023.
SELECT 
	rm.roomId,
    rt.maximumOccupancy,
    rn.startDate,
    rn.endDate
FROM  room rm -- left table
LEFT JOIN roomsReserved rr
ON rm.roomId = rr.roomId
INNER JOIN reservation rn
ON rn.reservationId = rn.reservationId
INNER JOIN roomType rt
ON rt.roomTypeId = rm.roomTypeId 
WHERE rt.maximumOccupancy>=3 AND MONTH(startDate)=4
ORDER BY roomId;
/* 5. ANS
# roomId	roomId	maximumOccupancy	startDate	endDate
201	201	4	2023-04-09	2023-04-13
201	201	4	2023-04-23	2023-04-24
202	202	4	2023-04-09	2023-04-13
202	202	4	2023-04-23	2023-04-24
203	203	4	2023-04-09	2023-04-13
203	203	4	2023-04-23	2023-04-24
204	204	4	2023-04-09	2023-04-13
204	204	4	2023-04-23	2023-04-24
301	301	4	2023-04-09	2023-04-13
301	301	4	2023-04-23	2023-04-24
302	302	4	2023-04-09	2023-04-13
302	302	4	2023-04-23	2023-04-24
303	303	4	2023-04-09	2023-04-13
303	303	4	2023-04-23	2023-04-24
304	304	4	2023-04-09	2023-04-13
304	304	4	2023-04-23	2023-04-24
401	401	8	2023-04-09	2023-04-13
401	401	8	2023-04-23	2023-04-24
402	402	8	2023-04-09	2023-04-13
402	402	8	2023-04-23	2023-04-24
*/

-- 5. Write a query that returns all rooms with a capacity of three or more and 
-- that are reserved on any date in April 2023.
SELECT 
	rm.roomId,
    rt.maximumOccupancy,
    rn.reservationId,
    rn.startDate,
    rn.endDate
FROM room rm
INNER JOIN roomsReserved rr
ON rr.roomId = rm.roomId
INNER JOIN reservation rn 
ON rn.reservationId = rr.reservationId 
INNER JOIN roomType rt
ON rt.roomTypeId = rm.roomTypeId
WHERE rt.maximumOccupancy>=4 AND MONTH(rn.startDate)=4;

/* 5.ANS
# roomId, maximumOccupancy, reservationId, startDate, endDate
'301', '4', '9', '2023-04-09', '2023-04-13'
*/

-- 6. Write a query that returns a list of all guest names and the no. of reservations
-- per guest, sorted starting with the guest with the most reservations and then by the 
-- guest's last name.
SELECT 
    gt.firstName,
    gt.lastName,
    count(gs.guestId) reservationCount
FROM guest gt
INNER JOIN guests gs
ON gs.guestId = gt.guestId
INNER JOIN reservation rn 
ON rn.reservationId = gs.reservationId
GROUP BY gt.guestId
ORDER BY reservationCount DESC, gt.lastName;

/*  6. ANS
# firstName, lastName, reservationCount
'Mark', 'Simmer', '4'
'Bettyann ', 'Seery', '3'
'Duane ', 'Cullison', '2'
'Chloe', 'Edgar', '2'
'Walter', 'Holaway', '2'
'Aurore', 'Luechtefeld', '2'
'Maritza', 'Tilton', '2'
'Joleen', 'Tison', '2'
'Wilfred', 'Vise', '2'
'Karie ', 'Yang', '2'
'Zachery', 'Seery', '1'
*/

-- 7. Write a query that displays the name, address and phone number of
-- a guest based on their phone number. (Choose a phone number from the
-- existing data).
SELECT 
	gt.firstName,
    gt.lastName,
    gt.address,
    gt.city,
    gt.stateAbbr,
    gt.zip,
    gt.phone
FROM guest gt
WHERE gt.phone = '(377) 507-0974';
/* 7. ANS
# firstName, lastName, address, city, stateAbbr, zip, phone
'Aurore', 'Luechtefeld', '762 Wild Rose Street', 'Saginaw', 'MI', '48601', '(377) 507-0974'
*/



