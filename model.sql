USE model
GO
IF EXISTS(SELECT 1 FROM master.dbo.sysdatabases WHERE name='SportCenter') DROP DATABASE SportCenter
GO
CREATE DATABASE SportCenter
GO
USE SportCenter
GO
CREATE TABLE discount(
	id INT IDENTITY(1,1) NOT NULL,
	name VARCHAR(50),
	factor FLOAT NOT NULL,
	CHECK(factor BETWEEN 0.01 AND 1.0),
	CONSTRAINT pk_discount PRIMARY KEY CLUSTERED(id)
)
CREATE TABLE client(
	id INT IDENTITY(1,1) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	second_name VARCHAR(20) NOT NULL,
	phone_number VARCHAR(9) NOT NULL,
	discount_id INT,
	CONSTRAINT pk_client PRIMARY KEY CLUSTERED(id),
	CONSTRAINT fk_discount FOREIGN KEY (discount_id) REFERENCES discount(id)
)
CREATE TABLE fee(
	id INT IDENTITY(1,1) NOT NULL,
	description VARCHAR(1000) NOT NULL,
	cost INT NOT NULL,
	CONSTRAINT pk_fee PRIMARY KEY CLUSTERED(id)
)
CREATE TABLE status(
	id INT IDENTITY(1, 1) NOT NULL,
	name VARCHAR(35) NOT NULL,
	CONSTRAINT pk_status PRIMARY KEY CLUSTERED(id)
)
CREATE TABLE caretaker(
        id INT IDENTITY(1,1) NOT NULL,
        first_name VARCHAR(20) NOT NULL,
        second_name VARCHAR(20) NOT NULL,
        phone_number VARCHAR(9),
        CONSTRAINT pk_caretaker PRIMARY KEY CLUSTERED(id)
)
CREATE TABLE facility(
        id INT IDENTITY(1,1) NOT NULL,
        name VARCHAR(50) NOT NULL,
        cost INT NOT NULL,
        caretaker_id INT NOT NULL,
        CONSTRAINT pk_facility PRIMARY KEY CLUSTERED(id),
        CONSTRAINT fk_caretaker FOREIGN KEY (caretaker_id) REFERENCES caretaker(id)
)
CREATE TABLE reservation(
	id INT IDENTITY(1,1) NOT NULL,
	client_id INT NOT NULL,
	facility_id INT NOT NULL,
	ordered_date DATETIME NOT NULL,
	order_date DATETIME NOT NULL,
	duration_in_hours INT NOT NULL,
	status_id INT NOT NULL DEFAULT(1),
	total_cost INT DEFAULT NULL,
	CHECK (duration_in_hours >= 1),
	CHECK (order_date > ordered_date),
	CHECK (total_cost IS NULL OR total_cost >= 0),
	CONSTRAINT pk_reservation PRIMARY KEY CLUSTERED(id),
	CONSTRAINT fk_facility FOREIGN KEY (facility_id) REFERENCES facility(id),
	CONSTRAINT fk_status FOREIGN KEY (status_id) REFERENCES status(id),
	CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES client(id),
)
CREATE TABLE reservation_fee(
    reservation_id INT NOT NULL,
    fee_id INT NOT NULL,
    CONSTRAINT fk_reservation FOREIGN KEY (reservation_id) REFERENCES reservation(id),
    CONSTRAINT fk_fee FOREIGN KEY (fee_id) REFERENCES fee(id)
)
CREATE TABLE log(
    id INT IDENTITY(1, 1) NOT NULL,
    table_name VARCHAR(15) NOT NULL,
    action_type VARCHAR(15) NOT NULL,
    action_date DATETIME NOT NULL,
    description VARCHAR(1000) NOT NULL,
    object_id INT NOT NULL,
    CONSTRAINT logs_pk PRIMARY KEY CLUSTERED(id)
)