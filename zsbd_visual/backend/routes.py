from main import app
from flask import request, jsonify
import json
import queries


@app.route('/client/<client_id>/getreservationlist', methods=['GET'])
@app.route('/client/getlist', methods=['GET'])
@app.route('/client/create', methods=['POST'])
@app.route('/client/<client_id>/update', methods=['PUT'])
def client(client_id=None):
    if request.path == '/client/getlist':
        result = queries.get_client_list()
        if result is not False:
            return jsonify(result)
        else:
            return jsonify('FAILURE')
    elif request.path == '/client/create':
        data = json.loads(request.data)
        if queries.create_client(data["first_name"], data["second_name"], data["phone_number"]) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')
    elif request.path == '/client/{}/update'.format(client_id):
        data = json.loads(request.data)
        if queries.update_client(client_id, data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')
    elif request.path == '/client/{}/getreservationlist'.format(client_id):
        result = queries.get_reservations_for_client(client_id)
        if result is not False:
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')


@app.route('/discount/create', methods=['POST'])
@app.route('/discount/getlist', methods=['GET'])
@app.route('/discount/<discount_id>/update', methods=['PUT'])
def discount(discount_id=None):
    if request.method == 'GET':
        result = queries.get_discount_list()
        if result is not False:
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'PUT':
        data = json.loads(request.data)
        if queries.update_discount(discount_id, data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'POST':
        data = json.loads(request.data)
        if queries.create_discount(data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')


@app.route('/fee/create', methods=['POST'])
@app.route('/fee/getlist', methods=['GET'])
@app.route('/fee/<fee_id>/update', methods=['PUT'])
def fee(fee_id=None):
    if request.method == 'POST':
        data = json.loads(request.data)
        if queries.create_fee(data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'GET':
        result = queries.get_fee_list()
        if result != 'FAILURE':
            return jsonify(result)
        else:
            return jsonify('FAILURE')
    elif request.method == 'PUT':
        data = json.loads(request.data)
        if queries.update_fee(fee_id, data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')


@app.route('/facility/create', methods=['POST'])
@app.route('/facility/<facility_id>/update', methods=['PUT'])
@app.route('/facility/getlist', methods=['GET'])
def facility(facility_id=None):
    if request.method == 'GET':
        result = queries.get_facility_list()
        if result != 'FAILURE':
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'POST':
        data = json.loads(request.data)
        if queries.create_facility(data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'PUT':
        data = json.loads(request.data)
        if queries.update_facility(facility_id, data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')


@app.route('/caretaker/<caretaker_id>/update', methods=['PUT'])
@app.route('/caretaker/create', methods=['POST'])
@app.route('/caretaker/getlist', methods=['GET'])
def caretaker(caretaker_id=None):
    if request.method == 'GET':
        result = queries.get_caretaker_list()
        if result is not False:
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'POST':
        data = json.loads(request.data)
        if queries.create_caretaker(data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'PUT':
        data = json.loads(request.data)
        if queries.update_caretaker(caretaker_id, data) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')


@app.route('/status/getlist', methods=['GET'])
def status():
    if request.path == '/status/getlist':
        result = queries.get_status_list()
        if result is not False:
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')


@app.route('/reservation/create', methods=['POST'])
@app.route('/reservation/getlist', methods=['GET'])
@app.route('/reservation/check', methods=['POST'])
@app.route('/reservation/check/exclude/<reservation_id>', methods=['POST'])
@app.route('/reservation/<reservation_id>/update', methods=['PUT'])
@app.route('/reservation/<reservation_id>/getfeelist', methods=['GET'])
@app.route('/reservation/<reservation_id>/addfee', methods=['POST'])
@app.route('/reservation/<reservation_id>/complete', methods=['GET'])
def reservation(reservation_id=0):
    if request.method == 'POST':
        if request.path == '/reservation/create':
            data = json.loads(request.data)
            if queries.create_reservation(data) is True:
                return jsonify('OK'), 200
            else:
                return jsonify('FAILURE')
        elif request.path == '/reservation/check' or request.path == '/reservation/check/exclude/{}'.format(reservation_id):
            data = json.loads(request.data)
            result = queries.check_reservation_date(data, reservation_id)
            if result is False:
                return jsonify('FAILURE'),
            elif result == 1:
                return jsonify('FREE'), 200
            elif result == 0:
                return jsonify('NOT FREE'), 200
            elif result == -1:
                return jsonify('BACKWARD ORDER'), 200
        elif request.path == '/reservation/{}/addfee'.format(reservation_id):
            if queries.add_fee_to_reservation(reservation_id, json.loads(request.data)["fee_id"]) is True:
                return jsonify('OK'), 200
            else:
                return jsonify('FAILURE')
    elif request.path == '/reservation/getlist':
        result = queries.get_reservation_list()
        if result is not False:
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')
    elif request.path == '/reservation/{}/getfeelist'.format(reservation_id):
        result = queries.get_fee_list_for_reservation(reservation_id)
        if result is not False:
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')
    elif request.path == '/reservation/{}/complete'.format(reservation_id):
        if queries.complete_reservation(reservation_id) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')
    elif request.method == 'PUT' and request.path == '/reservation/{}/update'.format(reservation_id):
        if queries.update_reservation(reservation_id, json.loads(request.data)) is True:
            return jsonify('OK'), 200
        else:
            return jsonify('FAILURE')


@app.route('/log/getlist/<sort_by>', methods=['GET'])
@app.route('/log/getlist', methods=['GET'])
def log(sort_by=None):
    if (request.path == '/log/getlist' or request.path == '/log/getlist/{}'.format(sort_by)) and request.method == 'GET':
        result = queries.get_log_list(sort_by)
        if result is not False:
            return jsonify(result), 200
        else:
            return jsonify('FAILURE')
