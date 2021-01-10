from main import create_connection
import json


def get_client_list():
    try:
        conn = create_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM get_client_list();')
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def create_client(first_name, second_name, phone_number):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC create_client '{}', '{}', '{}'".format(first_name, second_name, phone_number))
        connection.commit()
        return True
    except:
        return False


def update_client(clientId, data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC update_client {}, '{}', ".format(clientId, data["first_name"]) +
                       "'{}', '{}', {}".format(data["second_name"], data["phone_number"], data["discount_id"]))
        connection.commit()
        return True
    except:
        return False


def create_discount(data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC create_discount '{}', {}".format(data["name"], data["factor"]))
        connection.commit()
        return True
    except:
        return False

def get_discount_list():
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute('SELECT * FROM get_discount_list()')
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns,row)))
        return results
    except:
        return False


def update_discount(discountId, data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC update_discount {}, '{}', {}".format(discountId, data["name"], data["factor"]))
        connection.commit()
        return True
    except:
        return False


def get_fee_list():
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM get_fee_list()")
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def create_fee(data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC create_fee '{}', {}".format(data["description"], data["cost"]))
        connection.commit()
        return True
    except:
        return False


def update_fee(feeId, data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC update_fee {}, '{}', {}".format(feeId, data["description"], data["cost"]))
        connection.commit()
        return True
    except:
        return False


def get_fee_list_for_reservation(reservationId):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM get_fee_list_for_reservation({})".format(reservationId))
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def add_fee_to_reservation(reservation_id, fee_id):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC add_fee_to_reservation {}, {}".format(reservation_id, fee_id))
        connection.commit()
        return True
    except:
        return False

def create_facility(data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC create_facility '{}', {}, {}".format(data["name"], data["cost"], data["caretaker_id"]))
        connection.commit()
        return True
    except:
        return False


def update_facility(facilityId, data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC update_facility {}, '{}', {}, {}".format(facilityId, data["name"], data["cost"], data["caretaker_id"]))
        connection.commit()
        return True
    except:
        return False


def get_facility_list():
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM get_facility_list()")
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def create_caretaker(data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC create_caretaker '{}', '{}', '{}'".format(data["first_name"], data["second_name"], data["phone_number"]))
        connection.commit()
        return True
    except:
        return False


def update_caretaker(caretakerId, data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC update_caretaker {}, '{}', '{}', '{}'".format(caretakerId, data["first_name"], data["second_name"], data["phone_number"]))
        connection.commit()
        return True
    except:
        return False


def get_caretaker_list():
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM get_caretaker_list()")
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def create_reservation(data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC create_reservation {}, {}, {}, '{}'".format(data["client_id"], data["facility_id"], data["duration_in_hours"], data["order_date"]))
        connection.commit()
        return True
    except:
        return False


def get_reservation_list():
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM get_reservation_list()")
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
          results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def check_reservation_date(data, exclude_reservation_id):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT dbo.check_reservation_availability({}, '{}', {}, {})".format(data["facility_id"], data["order_date"], data["duration_in_hours"], exclude_reservation_id))
        return cursor.fetchall()[0][0]
    except:
        return False


def update_reservation(reservationId, data):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC update_reservation {}, {}, {}, '{}', {}, {}".format(reservationId, data["client_id"], data["facility_id"], data["order_date"], data["duration_in_hours"], data["status_id"]))
        connection.commit()
        return True
    except:
        return False


def get_log_list(sort_by):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        if sort_by is None:
            cursor.execute("SELECT * FROM get_log_list()")
        else:
            cursor.execute("SELECT * FROM get_log_list() ORDER BY '{}'".format(sort_by))
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def get_status_list():
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM get_status_list()")
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def get_reservations_for_client(client_id):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM get_reservations_for_client({})".format(client_id))
        results = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    except:
        return False


def complete_reservation(reservation_id):
    try:
        connection = create_connection()
        cursor = connection.cursor()
        cursor.execute("EXEC complete_reservation {}".format(reservation_id))
        connection.commit()
        return True
    except:
        return False
