-- Defining the Database
DROP DATABASE IF EXISTS hotel;
CREATE DATABASE hotel;
USE hotel;

CREATE TABLE roomType ( 
	roomTypeId INT NOT NULL AUTO_INCREMENT, 
    roomTypeName VARCHAR(15),
    standardOccupancy INT NOT NULL,
    maximumOccupancy INT NOT NULL,
    extraPersonCost DECIMAL(10,2),
    CONSTRAINT pk_roomTypes
		PRIMARY KEY (roomTypeId)
);

CREATE TABLE guest (
	guestId INT NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    address VARCHAR(256),
    city VARCHAR(100) ,
    stateAbbr CHAR(2),
    zip CHAR(5),
    phone VARCHAR(14),
    CONSTRAINT pk_guest
		PRIMARY KEY (guestId)
    );
    
CREATE TABLE room (
	roomId INT NOT NULL,
    adaAccessible BOOLEAN NOT NULL,
    roomTypeId INT NOT NULL,
    basePrice DOUBLE(10,2),
    CONSTRAINT pk_room
		PRIMARY KEY (roomId),
	CONSTRAINT fk_room_roomType
		FOREIGN KEY (roomTypeId)
		REFERENCES roomType(roomTypeId)
);

CREATE TABLE amenity (
	amenityId INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_amenity
		PRIMARY KEY (amenityId)
);

CREATE TABLE reservation (
	reservationId INT NOT NULL AUTO_INCREMENT,
    startDate DATE NOT NULL, 
    endDate DATE NOT NULL,
    CONSTRAINT pk_reservation
		PRIMARY KEY (reservationId)
);

CREATE TABLE roomAmenities (
	roomId INT NOT NULL,
	amenityId INT NOT NULL,
    CONSTRAINT pk_roomAmenities
		PRIMARY KEY (amenityId, roomId),
	CONSTRAINT fk_roomAmenities_room
		FOREIGN KEY (roomId)
        REFERENCES room(roomId),
	CONSTRAINT fk_roomAmenities_amenity
		FOREIGN KEY (amenityId)
        REFERENCES amenity(amenityId)
);

CREATE TABLE roomsReserved (
	roomId INT NOT NULL,
    reservationId INT NOT NULL,
    CONSTRAINT pk_roomsReserved
		PRIMARY KEY (roomId, reservationId),
	CONSTRAINT fk_roomsReserved_room
		FOREIGN KEY (roomId)
        REFERENCES room(roomId),
	CONSTRAINT fk_roomsReserved_reservation
		FOREIGN KEY (reservationId)
        REFERENCES reservation(reservationId)
);

CREATE TABLE guests (
	guestId INT NOT NULL,
    reservationId INT NOT NULL,
    quantityAdults INT NOT NULL,
    quantityChildren INT NOT NULL,
    CONSTRAINT pk_guestId
		PRIMARY KEY (guestId, reservationId),
	CONSTRAINT fk_guests_guest
		FOREIGN KEY (guestId)
        REFERENCES guest(guestId),
	CONSTRAINT fk_guests_reservation
		FOREIGN KEY (reservationId)
        REFERENCES reservation(reservationId)
);
        
        

    
    
    