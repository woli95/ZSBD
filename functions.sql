USE SportCenter
GO
-----------------------
--NOT USER IN FRONTED--
-----------------------







----------
--CLIENT--
----------
CREATE PROCEDURE create_client(@first_name VARCHAR(20), @second_name VARCHAR(20), @phone_number VARCHAR(20))
AS
    INSERT INTO client VALUES
	(@first_name, @second_name, @phone_number, NULL)
GO
CREATE PROCEDURE update_client(@clientId INT, @newFN VARCHAR(20), @newSN VARCHAR(20), @newPN VARCHAR(9), @newDId INT)
AS
    UPDATE client
    SET first_name=@newFN, second_name=@newSN, phone_number=@newPN, discount_id=@newDId
    WHERE id=@clientId
GO
CREATE FUNCTION get_client_list()
RETURNS TABLE
    AS
    RETURN
        SELECT *
        FROM client
GO
CREATE PROCEDURE delete_client(@clientId INT)
AS
    DELETE FROM client
    WHERE id = @clientId
GO



-------
--FEE--
-------
CREATE PROCEDURE create_fee(@description VARCHAR(1000), @cost INT)
AS
    INSERT INTO fee VALUES
	(@description, @cost)
GO
CREATE FUNCTION get_fee_list()
RETURNS TABLE
AS
    RETURN
	SELECT * FROM fee
GO
CREATE PROCEDURE update_fee(@feeId INT, @newDesc VARCHAR(1000), @newCost INT)
AS
    UPDATE fee
    SET description=@newDesc, cost=@newCost
    WHERE id=@feeId
GO
CREATE PROCEDURE delete_fee(@feeId INT)
AS
    DELETE FROM fee
    WHERE id = @feeId
GO




------------
--FACILITY--
------------
CREATE PROCEDURE create_facility(@name VARCHAR(50), @cost INT, @caretakerId INT)
AS
    INSERT INTO facility VALUES
	(@name, @cost, @caretakerId)
GO
CREATE FUNCTION get_facility_list()
RETURNS TABLE
AS
    RETURN
	SELECT * FROM facility
GO
CREATE PROCEDURE update_facility(@facilityID INT, @name VARCHAR(50), @cost INT, @caretakerId INT)
AS
    UPDATE facility
    SET name=@name, cost=@cost, caretaker_id=@caretakerId
    WHERE id=@facilityID
GO
CREATE PROCEDURE delete_facility(@facilityId INT)
AS
    DELETE FROM facility
    WHERE id = @facilityId
GO



-------------
--CARETAKER--
-------------
CREATE PROCEDURE create_caretaker(@first_name VARCHAR(20), @second_name VARCHAR(20), @phone_number VARCHAR(9))
AS
     INSERT INTO caretaker VALUES
	(@first_name, @second_name, @phone_number)
GO
CREATE PROCEDURE update_caretaker(@caretakerId INT, @first_name VARCHAR(20), @second_name VARCHAR(20), @phone_number VARCHAR(9))
AS
     UPDATE caretaker
     SET first_name=@first_name, second_name=@second_name, phone_number=@phone_number
     WHERE id=@caretakerId
GO
CREATE FUNCTION get_caretaker_list()
RETURNS TABLE
AS
    RETURN
	SELECT * FROM caretaker
GO
CREATE PROCEDURE delete_caretaker(@caretakerId INT)
AS
    DELETE FROM caretaker
    WHERE id = @caretakerId
GO




------------
--DISCOUNT--
------------
CREATE PROCEDURE update_discount(@discountId INT, @name VARCHAR(50), @factor FLOAT)
AS
     UPDATE discount
     SET name=@name, factor=@factor
     WHERE id=@discountId
GO
CREATE PROCEDURE create_discount(@name VARCHAR(50), @factor FLOAT)
AS
     INSERT INTO discount VALUES
	(@name, @factor)
GO
CREATE FUNCTION get_discount_list()
RETURNS TABLE
    AS
    RETURN
	    SELECT *
	    FROM discount
GO
CREATE PROCEDURE delete_discount(@discountId INT)
AS
    DELETE FROM discount
    WHERE id = @discountId
GO



---------------
--RESERVATION--
---------------
CREATE PROCEDURE create_reservation(@clientId INT, @facilityId INT, @duration_in_hours INT, @order_date DATETIME)
AS
    INSERT INTO reservation (client_id, facility_id, ordered_date, order_date,  duration_in_hours, status_id, total_cost)  VALUES
        (@clientId, @facilityID, GETDATE(), @order_date, @duration_in_hours, (SELECT id FROM status WHERE name='Confirmed'), NULL)
GO


CREATE FUNCTION get_reservation_list()
RETURNS TABLE
    AS
    RETURN
        SELECT *
        FROM reservation
GO


CREATE FUNCTION get_reservations_for_this_day_and_facility(@date DATETIME, @facilityID INT, @exclude_reservation_id INT)
RETURNS TABLE
    AS
    RETURN
        SELECT *
        FROM reservation
        WHERE facility_id=@facilityID AND CAST(order_date AS DATE)=CAST(@date AS DATE) AND id != @exclude_reservation_id
GO


CREATE FUNCTION check_reservation_availability(@facilityId INT, @order_date DATETIME, @duration_in_hours INT, @exclude_reservation_id INT)
RETURNS INT
    AS
    BEGIN
        DECLARE @result INT = 1
        IF GETDATE() >= @order_date
            SET @result = -1
        ELSE
            BEGIN
                DECLARE @tmp INT = 1
                WHILE @tmp <= @duration_in_hours
                    BEGIN
                        IF EXISTS(SELECT *
                                  FROM get_reservations_for_this_day_and_facility(@order_date, @facilityId, @exclude_reservation_id)
                                  WHERE order_date = @order_date OR
                                        @order_date BETWEEN DATEADD(MINUTE, -1, order_date) AND DATEADD(MINUTE, -1, DATEADD(HOUR, duration_in_hours, order_date)) OR
                                        DATEADD(HOUR, @tmp, @order_date) BETWEEN DATEADD(MINUTE, 1, order_date) AND DATEADD(MINUTE, -1, DATEADD(HOUR, duration_in_hours, order_date)))
                            BEGIN
                                SET @result = 0
                                BREAK
                            END
                        SET @tmp = @tmp+1
                    END
            END
        RETURN @result
    END
GO
CREATE PROCEDURE update_reservation(@reservationId INT, @client_id INT, @facility_id INT, @order_date DATETIME, @duration_in_hours INT, @status_id INT)
AS
    UPDATE reservation
    SET client_id = @client_id, facility_id=@facility_id, order_date=@order_date, duration_in_hours=@duration_in_hours, status_id=@status_id
    WHERE id=@reservationId
GO


CREATE FUNCTION get_reservations_for_client(@clientId INT)
RETURNS TABLE
AS
    RETURN
        SELECT reservation.id, facility.name AS facility_name, reservation.ordered_date, reservation.order_date, reservation.duration_in_hours, status.name AS status_name
        FROM reservation
        INNER JOIN facility on facility.id = reservation.facility_id
        INNER JOIN status on status.id = reservation.status_id
        WHERE reservation.client_id = @clientId
GO


CREATE FUNCTION calculate_total_price(@reservationId INT)
RETURNS INT
AS
    BEGIN
        DECLARE @primary_cost INT = (SELECT duration_in_hours*facility.cost
                                     FROM reservation
                                     INNER JOIN facility on facility.id = reservation.facility_id
                                     WHERE reservation.id = @reservationId)
        DECLARE @fees_cost INT =    (SELECT SUM(fee.cost)
                                     FROM fee
                                     INNER JOIN reservation_fee on fee.id = reservation_fee.fee_id
                                     WHERE reservation_fee.reservation_id = @reservationId
                                     GROUP BY reservation_fee.reservation_id)
        RETURN (@primary_cost + ISNULL(@fees_cost, 0))
    END
GO
CREATE PROCEDURE complete_reservation (@reservation_id INT)
AS
    UPDATE reservation
    SET status_id = (SELECT id FROM status WHERE name='completed'),
        total_cost =(SELECT dbo.calculate_total_price(@reservation_id))
    WHERE id=@reservation_id
GO
CREATE PROCEDURE delete_reservation (@reservationId INT)
AS
    DELETE FROM reservation
    WHERE id = @reservationId
GO


-------------------
--RESERVATION_FEE--
-------------------
CREATE FUNCTION get_fee_list_for_reservation(@reservation_id INT)
RETURNS TABLE
AS
    RETURN
        SELECT id, description, cost
        FROM fee
        INNER JOIN reservation_fee on fee.id = reservation_fee.fee_id
        WHERE reservation_fee.reservation_id = @reservation_id
GO
CREATE PROCEDURE add_fee_to_reservation(@reservation_id INT, @fee_id INT)
AS
    INSERT INTO reservation_fee VALUES
        (@reservation_id, @fee_id)
GO
CREATE PROCEDURE delete_fee_from_reservation(@reservationId INT, @feeId INT)
AS
    DELETE FROM reservation_fee
    WHERE fee_id = @feeId AND reservation_id = @reservationId
GO



-------
--LOG--
-------
CREATE FUNCTION get_log_list()
RETURNS TABLE
    AS
    RETURN
        SELECT *
        FROM log
GO




----------
--STATUS--
----------
CREATE FUNCTION get_status_list()
RETURNS TABLE
AS
    RETURN
        SELECT * FROM status
GO




----------------------
-- INSERT TRIGGERS --
---------------------
CREATE TRIGGER trigger_discount_insert
ON discount
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'discount', 'insert(create)', GETDATE(), CONCAT('Discount " ', name, '" has been created'), id
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_discount_insert', 11, 1)
END
GO

CREATE TRIGGER trigger_client_insert
ON client
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'client', 'insert(create)', GETDATE(), CONCAT('Client "', first_name, ' ', second_name, '" has been inserted'), id
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_client_insert', 11, 1)
END
GO

CREATE TRIGGER trigger_fee_insert
ON fee
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'fee', 'insert(create)', GETDATE(), CONCAT('Fee "', description, '" has been created'), id
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_fee_insert', 11, 1)
END
GO

CREATE TRIGGER trigger_status_insert
ON status
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'status', 'insert(create)', GETDATE(), CONCAT('Status "', name, '" has been created'), id
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_status_insert', 11, 1)
END
GO

CREATE TRIGGER trigger_caretaker_insert
ON caretaker
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'caretaker', 'insert(create)', GETDATE(), CONCAT('Caretaker "', first_name, ' ', second_name, '" has been inserted'), id
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_caretaker_insert', 11, 1)
END
GO

CREATE TRIGGER trigger_facility_insert
ON facility
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'facility', 'insert(create)', GETDATE(), CONCAT('Facility "', name, '" has been created'), id
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_facility_insert', 11, 1)
END
GO

CREATE TRIGGER trigger_reservation_insert
ON reservation
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'reservation', 'insert(create)', GETDATE(), CONCAT('Reservation by client id: "', client_id, '" on facility "', facility_id, '" has been created'), id
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_reservation_insert', 11, 1)
END
GO

CREATE TRIGGER trigger_reservation_fee_insert
ON reservation_fee
AFTER INSERT
AS
BEGIN
	DECLARE @number_of_inserted INT = @@ROWCOUNT;
	IF @number_of_inserted >= 1
		BEGIN
			INSERT INTO log
			SELECT 'reservation_fee', 'insert(create)', GETDATE(), CONCAT('Fee id "', fee_id, '" on reservation id "', reservation_id,'" has been added'), 0
			FROM INSERTED;
		END
	ELSE
		RAISERROR('Error ??? trigger_reservation_fee_insert', 11, 1)
END
GO





---------------------
-- UPDATE TRIGGERS --
---------------------

CREATE TRIGGER trigger_discount_update
ON discount
FOR UPDATE
AS
BEGIN
	DECLARE @number_of_updated INT = @@ROWCOUNT;
	IF @number_of_updated >= 1
		BEGIN
		    INSERT INTO log
			SELECT 'discount', 'update', GETDATE(), CONCAT('Update: ', CASE
			                                                                WHEN INSERTED.name = DELETED.name THEN ''
			                                                                ELSE CONCAT('name(', DELETED.name, ' ==> ', INSERTED.name,') ')
			                                                           END,
			                                                           CASE
			                                                                WHEN INSERTED.factor = DELETED.factor THEN ''
			                                                                ELSE CONCAT('factor(', DELETED.factor, ' ==> ', INSERTED.factor,') ')
			                                                           END)
			                                                           , INSERTED.id
			FROM INSERTED, DELETED;
		END
	ELSE
		RAISERROR('Error ??? trigger_discount_update', 11, 1)
END
GO

CREATE TRIGGER trigger_client_update
ON client
FOR UPDATE
AS
BEGIN
	DECLARE @number_of_updated INT = @@ROWCOUNT;
	IF @number_of_updated >= 1
		BEGIN
            INSERT INTO log
			SELECT 'client', 'update', GETDATE(), CONCAT('Update: ', CASE
			                                                             WHEN INSERTED.first_name = DELETED.first_name THEN ''
			                                                             ELSE CONCAT('first_name(', DELETED.first_name, ' ==> ', INSERTED.first_name,') ')
			                                                         END,
			                                                         CASE
			                                                             WHEN INSERTED.second_name = DELETED.second_name THEN ''
			                                                             ELSE CONCAT('second_name(', DELETED.second_name, ' ==> ', INSERTED.second_name,') ')
			                                                         END,
			                                                         CASE
			                                                             WHEN INSERTED.phone_number = DELETED.phone_number THEN ''
			                                                             ELSE CONCAT('phone_number(', DELETED.phone_number, ' ==> ', INSERTED.phone_number,') ')
			                                                         END,
			                                                         CASE
			                                                             WHEN INSERTED.discount_id = DELETED.discount_id THEN ''
			                                                             ELSE CONCAT('discount_id(', DELETED.discount_id, ' ==> ', INSERTED.discount_id,') ')
			                                                         END)
			                                                           , INSERTED.id
			FROM INSERTED, DELETED;
		END
	ELSE
		RAISERROR('Error ??? trigger_client_update', 11, 1)
END
GO

CREATE TRIGGER trigger_fee_update
ON fee
FOR UPDATE
AS
BEGIN
	DECLARE @number_of_updated INT = @@ROWCOUNT;
	IF @number_of_updated >= 1
		BEGIN
            INSERT INTO log
			SELECT 'fee', 'update', GETDATE(), CONCAT('Update: ', CASE
			                                                          WHEN INSERTED.description = DELETED.description THEN ''
			                                                          ELSE CONCAT('description(', DELETED.description, ' ==> ', INSERTED.description,') ')
			                                                      END,
			                                                      CASE
			                                                          WHEN INSERTED.cost = DELETED.cost THEN ''
			                                                          ELSE CONCAT('cost(', DELETED.cost, ' ==> ', INSERTED.cost,') ')
			                                                      END)
			                                                          , INSERTED.id
			FROM INSERTED, DELETED;
		END
	ELSE
		RAISERROR('Error ??? trigger_fee_update', 11, 1)
END
GO

CREATE TRIGGER trigger_status_update
ON status
FOR UPDATE
AS
BEGIN
	DECLARE @number_of_updated INT = @@ROWCOUNT;
	IF @number_of_updated >= 1
		BEGIN
            INSERT INTO log
			SELECT 'status', 'update', GETDATE(), CONCAT('Update: ', CASE
			                                                             WHEN INSERTED.name = DELETED.name THEN ''
			                                                             ELSE CONCAT('name(', DELETED.name, ' ==> ', INSERTED.name,') ')
			                                                         END)
			                                                           , INSERTED.id
			FROM INSERTED, DELETED;
		END
	ELSE
		RAISERROR('Error ??? trigger_status_update', 11, 1)
END
GO

CREATE TRIGGER trigger_caretaker_update
ON caretaker
FOR UPDATE
AS
BEGIN
	DECLARE @number_of_updated INT = @@ROWCOUNT;
	IF @number_of_updated >= 1
		BEGIN
            INSERT INTO log
			SELECT 'caretaker', 'update', GETDATE(), CONCAT('Update: ', CASE
			                                                                WHEN INSERTED.first_name = DELETED.first_name THEN ''
			                                                                ELSE CONCAT('first_name(', DELETED.first_name, ' ==> ', INSERTED.first_name,') ')
			                                                           END,
			                                                           CASE
			                                                               WHEN INSERTED.second_name = DELETED.second_name THEN ''
			                                                               ELSE CONCAT('second_name(', DELETED.second_name, ' ==> ', INSERTED.second_name,') ')
			                                                           END,
			                                                           CASE
			                                                               WHEN INSERTED.phone_number = DELETED.phone_number THEN ''
			                                                               ELSE CONCAT('phone_number(', DELETED.phone_number, ' ==> ', INSERTED.phone_number,') ')
			                                                           END)
			                                                           , INSERTED.id
			FROM INSERTED, DELETED;
		END
	ELSE
		RAISERROR('Error ??? trigger_caretaker_update', 11, 1)
END
GO

CREATE TRIGGER trigger_facility_update
ON facility
FOR UPDATE
AS
BEGIN
	DECLARE @number_of_updated INT = @@ROWCOUNT;
	IF @number_of_updated >= 1
		BEGIN
            INSERT INTO log
			SELECT 'facility', 'update', GETDATE(), CONCAT('Update: ', CASE
			                                                               WHEN INSERTED.name = DELETED.name THEN ''
			                                                               ELSE CONCAT('name(', DELETED.name, ' ==> ', INSERTED.name,') ')
			                                                           END,
			                                                           CASE
			                                                               WHEN INSERTED.cost = DELETED.cost THEN ''
			                                                               ELSE CONCAT('cost(', DELETED.cost, ' ==> ', INSERTED.cost,') ')
			                                                           END,
			                                                           CASE
			                                                               WHEN INSERTED.caretaker_id = DELETED.caretaker_id THEN ''
			                                                               ELSE CONCAT('caretaker_id(', DELETED.caretaker_id, ' ==> ', INSERTED.caretaker_id,') ')
			                                                           END)
			                                                               , INSERTED.id
			FROM INSERTED, DELETED;
		END
	ELSE
		RAISERROR('Error ??? trigger_facility_update', 11, 1)
END
GO

CREATE TRIGGER trigger_reservation_update
ON reservation
FOR UPDATE
AS
BEGIN
	DECLARE @number_of_updated INT = @@ROWCOUNT;
	IF @number_of_updated >= 1
		BEGIN
            INSERT INTO log
			SELECT 'reservation', 'update', GETDATE(), CONCAT('Update: ', CASE
			                                                                  WHEN INSERTED.client_id = DELETED.client_id THEN ''
			                                                                  ELSE CONCAT('client_id(', DELETED.client_id, ' ==> ', INSERTED.client_id,') ')
			                                                              END,
			                                                              CASE
			                                                                  WHEN INSERTED.facility_id = DELETED.facility_id THEN ''
			                                                                  ELSE CONCAT('facility_id(', DELETED.facility_id, ' ==> ', INSERTED.facility_id,') ')
			                                                              END,
			                                                              CASE
			                                                                  WHEN INSERTED.ordered_date = DELETED.ordered_date THEN ''
			                                                                  ELSE CONCAT('ordered_date(', DELETED.ordered_date, ' ==> ', INSERTED.ordered_date,') ')
			                                                              END,
			                                                              CASE
			                                                                  WHEN INSERTED.order_date = DELETED.order_date THEN ''
			                                                                  ELSE CONCAT('order_date(', DELETED.order_date, ' ==> ', INSERTED.order_date,') ')
			                                                              END,
			                                                              CASE
			                                                                  WHEN INSERTED.duration_in_hours = DELETED.duration_in_hours THEN ''
			                                                                  ELSE CONCAT('duration_in_hours(', DELETED.duration_in_hours, ' ==> ', INSERTED.duration_in_hours,') ')
			                                                              END,
			                                                              CASE
			                                                                  WHEN INSERTED.status_id = DELETED.status_id THEN ''
			                                                                  ELSE CONCAT('status_id(', DELETED.status_id, ' ==> ', INSERTED.status_id,') ')
			                                                              END)
			                                                                  , INSERTED.id
			FROM INSERTED, DELETED;
		END
	ELSE
		RAISERROR('Error ??? trigger_facility_update', 11, 1)
END
GO





---------------------
-- DELETE TRIGGERS --
---------------------