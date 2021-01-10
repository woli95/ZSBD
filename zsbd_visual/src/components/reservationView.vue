<template>
  <div class="row">
    <div class="col s2 pink" style="border-right-color: lightsalmon;
                                    border-bottom-color: lightsalmon;
                                    border-right-style: solid;
                                    border-bottom-style: solid;
                                    border-right-width: 4px;
                                    border-bottom-width: 4px;">
      <ul>
        <button @click="chooseView('createReservation')" class="row btn btn-block red" style="width: 200px;">Create reservation</button>
      </ul>
    </div>
    <form v-if="currentView === 'createReservation'"
          class="col s4 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="createReservation"
          action="javascript:void(0)">
      <div class="row">
        <div class="col">
          <div class="input-field">
            <select id="createReservation_clientId" v-model="createReservation_clientId">
              <option value="" disabled>Select client</option>
              <option v-for="(item, index) in this.clientList" :key="index" :value="item.id">{{ item.first_name }} {{ item.second_name }}</option>
            </select>
            <label for="createReservation_clientId">Client name</label>
          </div>
        </div>
        <form class="col" action="javascript:void(0)" onsubmit="void(0)">
          <div class="input-field">
            <input @input="filterClientList('create')" type="text" id="createReservation_searchClient"/>
            <label for="createReservation_searchClient">Filter clients</label>
          </div>
        </form>
      </div>
      <div class="row">
        <div class="col">
          <div class="input-field">
            <select id="createReservation_facilityId" v-model="createReservation_facilityId">
              <option value="" disabled>Select facility</option>
              <option v-for="(item, index) in this.facilityList" :key="index" :value="item.id">{{ item.name }}</option>
            </select>
            <label for="createReservation_facilityId">Facility name</label>
          </div>
        </div>
        <form class="col" action="javascript:void(0)" onsubmit="void(0)">
          <div class="input-field">
            <input @input="filterFacilityList('create')" type="text" id="createReservation_searchFacility"/>
            <label for="createReservation_searchFacility">Filter clients</label>
          </div>
        </form>
      </div>
      <div class="row">
        <div class="col s5">
          <div class="input-field">
            <input type="date" id="createReservation_orderDate" required/>
            <label for="createReservation_orderDate" class="active">Order date</label>
          </div>
        </div>
        <div class="col">
          <div class="input-field">
            <VueTimepicker id="createReservation_orderTime"
                           format="HH:mm"
                           :minute-interval="30"
                           v-model="createReservation_orderTime"
                           close-on-complete
                           :hour-range="[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]"
                           hide-disabled-hours
            />
            <label class="active">Order time</label>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col">
          <div class="input-field">
            <input type="number" id="createReservation_duration" min="1" required step="1"/>
            <label for="createReservation_duration" class="active">Duration in hours</label>
          </div>
        </div>
        <div class="col">
          <button type="button" class="btn btn-block red lighten-3" @click="checkIfTermIsFree">Check the availability of the date</button>
          <span>This term is :
            <b v-if="createReservation_isAvailable === null" style="color: darkorange">????</b>
            <b v-else-if="createReservation_isAvailable === true" style="color: greenyellow">FREE</b>
            <b v-else-if="createReservation_isAvailable === false" style="color: red">OCCUPIED</b>
          </span>
        </div>
      </div>
      <div class="input-field center-align">
        <button type="submit" class="btn btn-large btn-block red darken-1 center-align">Submit</button>
      </div>
    </form>
    <form v-if="currentView === 'updateReservation'"
          class="col s4 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="updateReservation"
          action="javascript:void(0)">
      <div class="row">
        <div class="col">
          <div class="input-field">
            <input type="text" id="updateReservation_reservationId" disabled/>
            <label for="updateReservation_reservationId" class="active">Reservation ID</label>
          </div>
        </div>
        <div class="col">
          <div class="input-field">
            <select id="updateReservation_clientId" v-model="updateReservation_clientId">
              <option value="" disabled>Select client</option>
              <option v-for="(item, index) in this.clientList" :key="index" :value="item.id">{{ item.first_name }} {{ item.second_name }}</option>
            </select>
            <label for="updateReservation_clientId">Client name</label>
          </div>
        </div>
        <form class="col" action="javascript:void(0)" onsubmit="void(0)">
          <div class="input-field">
            <input @input="filterClientList('update')" type="text" id="updateReservation_searchClient"/>
            <label for="updateReservation_searchClient">Filter clients</label>
          </div>
        </form>
      </div>
      <div class="row">
        <div class="col">
          <div class="input-field">
            <select id="updateReservation_facilityId" v-model="updateReservation_facilityId">
              <option value="" disabled>Select facility</option>
              <option v-for="(item, index) in this.facilityList" :key="index" :value="item.id">{{ item.name }}</option>
            </select>
            <label for="updateReservation_facilityId">Facility name</label>
          </div>
        </div>
        <form class="col" action="javascript:void(0)" onsubmit="void(0)">
          <div class="input-field">
            <input @input="filterFacilityList('update')" type="text" id="updateReservation_searchFacility"/>
            <label for="updateReservation_searchFacility">Filter clients</label>
          </div>
        </form>
      </div>
      <div class="row">
        <div class="col s5">
          <div class="input-field">
            <input type="date" id="updateReservation_orderDate" required/>
            <label for="updateReservation_orderDate" class="active">Order date</label>
          </div>
        </div>
        <div class="col">
          <div class="input-field">
            <VueTimepicker id="updateReservation_orderTime"
                           format="HH:mm"
                           :minute-interval="30"
                           v-model="updateReservation_orderTime"
                           close-on-complete
                           :hour-range="[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]"
                           hide-disabled-hours
            />
            <label class="active">Order time</label>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col">
          <div class="input-field">
            <input v-model="updateReservation_duration" type="number" id="updateReservation_duration" min="1" required step="1"/>
            <label for="updateReservation_duration" class="active">Duration in hours</label>
          </div>
        </div>
        <div class="col">
          <button type="button" class="btn btn-block red lighten-3" @click="updateCheckIfTermIsFree">Check the availability of the date</button>
          <span>This term is :
            <b v-if="updateReservation_isAvailable === null" style="color: darkorange">????</b>
            <b v-else-if="updateReservation_isAvailable === true" style="color: greenyellow">FREE</b>
            <b v-else-if="updateReservation_isAvailable === false" style="color: red">OCCUPIED</b>
          </span>
        </div>
      </div>
      <div class="row">
        <div class="col">
          <div class="input-field">
            <select id="updateReservation_statusId" v-model="updateReservation_statusId">
              <option value="" disabled>Select facility</option>
              <option v-for="(item, index) in this.statusList" :key="index" :value="item.id">{{ item.name }}</option>
            </select>
            <label for="updateReservation_statusId">Reservation status</label>
          </div>
        </div>
      </div>
      <div class="input-field center-align">
        <button type="submit" class="btn btn-large btn-block red darken-1 center-align">Submit</button>
      </div>
    </form>
    <div class="col s5 right">
      <table class="bordered red lighten-3 white-text">
        <thead>
        <tr>
          <th>ID</th>
          <th>Total cost(or complete)</th>
          <th>Update</th>
          <th>Client ID</th>
          <th>Facility ID</th>
          <th>Booked date</th>
          <th>Order date</th>
          <th>Order duration</th>
          <th>Status ID</th>
          <th>Fees</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(item, index) in this.reservationList" :key="index">
          <td>{{ item["id"] }}</td>
          <td v-if="item['status_id'] !== 4"><button @click="complete_this_reservation_and_calculate_cost(item)" class="btn btn-small btn-floating red">COM</button></td>
          <td v-else>{{ item["total_cost"] }}</td>
          <td><button type="button" @click="selectToUpdate(item)" class="btn btn-small btn-floating red">U</button></td>
          <td>{{ item["client_id"] }}</td>
          <td>{{ item["facility_id"] }}</td>
          <td>{{ item["ordered_date"] }}</td>
          <td>{{ item["order_date"] }}</td>
          <td>{{ item["duration_in_hours"] }}</td>
          <td>{{ item["status_id"] }}</td>
          <td><button type="button" @click="showFees(item['id'])" class="btn btn-small btn-floating red">S</button></td>
        </tr>
        </tbody>
      </table>
    </div>
    <div id="feesModal" class="modal">
      <div class="modal-content" >
        <div class="row">
          <div class="col">
            <h4>Add fee to this reservation</h4>
            <form action="javascript:void(0)"
                  @submit="addFeeToReservation">
              <div class="input-field" style="text-align: center">
                <select id="addFee_feeId" v-model="fee_fee_id">
                  <option value="" disabled>Select fee</option>
                  <option v-for="(item, index) in this.feeList" :key="index" :value="item['id']">{{ item["description"] }} - {{ item["cost"] }} PLN</option>
                </select>
                <label for="addFee_feeId"></label>
              </div>
              <button type="submit" class="btn btn-block red lighten-2">Submit</button>
            </form>
          </div>
          <div class="col">
            <h4>Current fees in reservation</h4>
            <table id="feetable" class="bordered red lighten-3 white-text">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Description</th>
                  <th>Cost</th>
                </tr>
              </thead>
              <tbody style="height: 200px !important;">
                <tr v-for="(item, index) in this.fee_reservationFeeList" :key="index">
                  <td>{{ item["id"] }}</td>
                  <td>{{ item["description"] }}</td>
                  <td>{{ item["cost"] }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import VueTimepicker from 'vue2-timepicker/src/vue-timepicker';
import axios from 'axios';
import M from 'materialize-css';
import _ from 'lodash';
export default {
  name: 'caretakerView',
  components: { VueTimepicker },
  computed: {
    console: () => console
  },
  data() {
    return {
      backend_url: 'http://127.0.0.1:5000',
      currentView: null,
      clientList: null,
      facilityList: null,
      reservationList: null,
      statusList: null,
      createReservation_clientId: '',
      createReservation_facilityId: '',
      createReservation_orderTime: '',
      createReservation_isAvailable: null,
      updateReservation_reservationId: '',
      updateReservation_clientId: '',
      updateReservation_facilityId: '',
      updateReservation_duration: '',
      updateReservation_orderTime: '',
      updateReservation_isAvailable: null,
      updateReservation_statusId: '',
      fee_reservation_id: null,
      fee_fee_id: '',
      feeList: null,
      fee_reservationFeeList: null,
    }
  },
  methods: {
    chooseView(viewToOpen) {
      this.currentView = viewToOpen;
      const select1 = document.getElementById(viewToOpen.concat('_clientId'));
      const select2 = document.getElementById(viewToOpen.concat('_facilityId'));
      M.FormSelect.init(select1);
      M.FormSelect.init(select2);
      },
    async getFacilityList() {
      let list = [];
      await axios.get(this.backend_url.concat('/facility/getlist')).then((response) => {
        if (response.data !== 'FAILURE') {
          list = response.data;
        } else {
          M.toast({ html: 'Error while getting facility list '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting facility list '.concat(error.message) });
      });
      return list;
    },
    async getClientList() {
      let list = [];
      await axios.get(this.backend_url.concat('/client/getlist')).then((response) => {
        if (response.data !== 'FAILURE') {
          list = response.data;
        } else {
          M.toast({ html: 'Error while getting client list '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting client list '.concat(error.message)} );
      });
      return list;
    },
    async getStatusList() {
      let list = [];
      await axios.get(this.backend_url.concat('/status/getlist')).then(async(response) => {
        if (response.data !== 'FAILURE')
          list = response.data;
        else
          M.toast({ html: 'Error while getting status list '.concat(response.data) });
      }).catch((error) => {
        M.toast({ html: 'Error while getting status list'.concat(error.message) });
      });
      return list;
    },
    async getReservationList() {
      let list = [];
      await axios.get(this.backend_url.concat('/reservation/getlist')).then(async (response) => {
        if (response.data !== 'FAILURE') {
          list = response.data;
        } else {
          M.toast({ html: 'Error while getting client list '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting client list '.concat(error.message) });
      });
      return list;
    },
    async getFeeList() {
      let list = [];
      await axios.get(this.backend_url.concat('/fee/getlist')).then((response) => {
        if (response.data !== 'FAILURE')
          list = response.data
        else
          M.toast({ html: 'Error while updating fee list '.concat(response.data) });
      }).catch((error) => {
        M.toast({ html: 'Error while updating fee list '.concat(error.message) });
      });
      return list;
    },
    async filterClientList(action_type) {
      const searchValue = document.getElementById(action_type.concat('Reservation_searchClient')).value;
      let clientList = [];
      clientList = await this.getClientList();
      clientList = _.filter(clientList, (item) => {
          if(item.first_name.concat(' ', item.second_name).toLowerCase().indexOf(searchValue.toLowerCase()) > -1) {
            return true;
        }
      });
      this.clientList = clientList;
      var elems = await document.querySelectorAll('select');
      await M.FormSelect.init(elems);
    },
    async filterFacilityList(action_type) {
      const searchValue = document.getElementById(action_type.concat('Reservation_searchFacility')).value;
      let facilityList = [];
      facilityList = await this.getFacilityList();
      facilityList = _.filter(facilityList, (item) => {
        if (item.name.toLowerCase().indexOf(searchValue.toLowerCase()) > -1) {
          return true;
        }
      });
      this.facilityList = facilityList;
      var elems = await document.querySelectorAll('select');
      await M.FormSelect.init(elems);
    },
    async createReservation() {
      if (this.createReservation_isAvailable === false) {
        M.toast({ html: 'Your term is occupied, please choose another one' });
      } else if (this.createReservation_isAvailable === null) {
        M.toast({ html: 'Before submit you have to check if order term is available' });
      } else if (this.createReservation_clientId === '') {
        M.toast({ html: 'You have to select client to make a reservation' });
      } else if (this.createReservation_facilityId === '') {
        M.toast({ html: 'You have to select facilityId to make a reservation' });
      } else {
        let selected_date_value = document.getElementById('createReservation_orderDate').value;
        let fullDatetimeOfOrder = new Date(selected_date_value + ' ' + this.createReservation_orderTime);
        fullDatetimeOfOrder.setHours(fullDatetimeOfOrder.getHours()+1);
        fullDatetimeOfOrder = fullDatetimeOfOrder.toISOString().slice(0, 19).replace('T', ' ');
        await axios.post(this.backend_url.concat('/reservation/create'), {
          facility_id: this.createReservation_facilityId,
          client_id: this.createReservation_clientId,
          duration_in_hours: document.getElementById('createReservation_duration').value,
          order_date: fullDatetimeOfOrder,
        }).then(async (response) => {
          if (response.data === 'OK') {
            M.toast({ html: 'Reservation has been created' });
            this.currentView = null;
            this.reservationList = await this.getReservationList();
          } else {
            M.toast({ html: 'Error while creating reservation '.concat(response.data) });
          }
        }).catch((error) => {
          M.toast({ html: 'Error while creating reservation '.concat(error.message) });
        })
      }
    },
    async checkIfTermIsFree() {
      const date_value = document.getElementById('createReservation_orderDate').value;
      const duration_value = document.getElementById('createReservation_duration').value;
      const dataRegexExpression = new RegExp(/^\d{4}-\d{2}-\d{2}$/);
      const timeRegexExpression = new RegExp(/^\d{2}:\d{2}$/);
      if (this.createReservation_facilityId === '') {
        M.toast({ html: 'You have to select facility' });
      } else if (date_value === '' || dataRegexExpression.test(date_value) === false) {
        M.toast({ html: 'You have to select valid full order date' });
      } else if (timeRegexExpression.test(this.createReservation_orderTime) === false) {
        M.toast({ html: 'Please enter time of order' });
      } else if (duration_value === '' || duration_value.toString() === '0') {
        M.toast({ html: 'Please enter duration of order' });
      } else {
        let selected_date_value = document.getElementById('createReservation_orderDate').value;
        let fullDatetimeOfOrder = new Date(selected_date_value + ' ' + this.createReservation_orderTime);
        fullDatetimeOfOrder.setHours(fullDatetimeOfOrder.getHours()+1);
        fullDatetimeOfOrder = fullDatetimeOfOrder.toISOString().slice(0, 19).replace('T', ' ');
          await axios.post(this.backend_url.concat('/reservation/check'), {
            facility_id: this.createReservation_facilityId,
            order_date: fullDatetimeOfOrder,
            duration_in_hours: duration_value,
          }).then((response) => {
            if (response.data === 'FREE') {
              this.createReservation_isAvailable = true;
            } else if (response.data === 'NOT FREE') {
              this.createReservation_isAvailable = false;
            } else if (response.data === 'BACKWARD ORDER') {
              this.createReservation_isAvailable = null;
              M.toast({ html : 'Cannot create order with backward date' });
            } else {
              M.toast({ html: 'Error while checking availability of term '.concat(response.data) });
              this.createReservation_isAvailable = null;
            }
          }).catch((error) => {
            M.toast({ html: 'Error while checking availability of term '.concat(error.message) });
          });
      }
    },
    //UPDATE FUNCTIONS
    async selectToUpdate(item) {
      this.updateReservation_clientId = item["client_id"];
      this.updateReservation_facilityId = item["facility_id"];
      this.updateReservation_statusId = item["status_id"];
      this.updateReservation_reservationId = item["id"];
      this.updateReservation_duration = item["duration_in_hours"];
      let order_date = new Date(item["order_date"]);
      order_date = order_date.toISOString().slice(0, 10);
      this.updateReservation_orderTime = item["order_date"].slice(17, 22);
      await this.chooseView('updateReservation');
      document.getElementById('updateReservation_orderDate').value = order_date;
      document.getElementById('updateReservation_reservationId').value = item["id"];
      var elem= await document.querySelectorAll('select');
      await M.FormSelect.init(elem);
    },
    async updateReservation() {
      if (this.updateReservation_isAvailable !== true) {
        M.toast({ html: 'Your term is occupied, please choose another one' });
      } else if (this.updateReservation_clientId === '') {
        M.toast({ html: 'You have to select client to make a reservation' });
      } else if (this.updateReservation_facilityId === '') {
        M.toast({ html: 'You have to select facilityId to make a reservation' });
      } else {
        let selected_date_value = document.getElementById('updateReservation_orderDate').value;
        let fullDatetimeOfOrder = new Date(selected_date_value + ' ' + this.updateReservation_orderTime);
        fullDatetimeOfOrder.setHours(fullDatetimeOfOrder.getHours()+1);
        fullDatetimeOfOrder = fullDatetimeOfOrder.toISOString().slice(0, 19).replace('T', ' ');
        console.log(fullDatetimeOfOrder)
        await axios.put(this.backend_url.concat('/reservation/', this.updateReservation_reservationId, '/update'), {
          client_id: this.updateReservation_clientId,
          facility_id: this.updateReservation_facilityId,
          order_date: fullDatetimeOfOrder,
          duration_in_hours: document.getElementById('updateReservation_duration').value,
          status_id: this.updateReservation_statusId
        }).then(async (response) => {
          if (response.data === 'OK') {
            M.toast({ html:'Reservation has been updated' });
            this.reservationList = await this.getReservationList();
            this.chooseView('');
          } else {
            M.toast({ html: 'Error while updating reservation '.concat(response.data) });
          }
        }).catch((error) => {
          M.toast({ html: 'Error while updating reservation '.concat(error.message) });
        });
      }
    },
    async updateCheckIfTermIsFree() {
      const date_value = document.getElementById('updateReservation_orderDate').value;
      const duration_value = document.getElementById('updateReservation_duration').value;
      const dataRegexExpression = new RegExp(/^\d{4}-\d{2}-\d{2}$/);
      const timeRegexExpression = new RegExp(/^\d{2}:\d{2}$/);
      if (this.updateReservation_facilityId === '') {
        M.toast({ html: 'You have to select facility' });
      } else if (date_value === '' || dataRegexExpression.test(date_value) === false) {
        M.toast({ html: 'You have to select valid full order date' });
      } else if (timeRegexExpression.test(this.updateReservation_orderTime) === false) {
        M.toast({ html: 'Please enter time of order' });
      } else if (duration_value === '' || duration_value.toString() === '0') {
        M.toast({ html: 'Please enter duration of order' });
      } else {
        let selected_date_value = document.getElementById('updateReservation_orderDate').value;
        let fullDatetimeOfOrder = new Date(selected_date_value + ' ' + this.updateReservation_orderTime);
        fullDatetimeOfOrder.setHours(fullDatetimeOfOrder.getHours()+1);
        fullDatetimeOfOrder = fullDatetimeOfOrder.toISOString().slice(0, 19).replace('T', ' ');
        await axios.post(this.backend_url.concat('/reservation/check/exclude/', document.getElementById('updateReservation_reservationId').value), {
          facility_id: this.updateReservation_facilityId,
          order_date: fullDatetimeOfOrder,
          duration_in_hours: duration_value,
        }).then((response) => {
          if (response.data === 'FREE') {
            this.updateReservation_isAvailable = true;
          } else if (response.data === 'NOT FREE') {
            this.updateReservation_isAvailable = false;
          } else if (response.data === 'BACKWARD ORDER') {
            this.updateReservation_isAvailable = null;
            M.toast({ html : 'Cannot create order with backward date' });
          } else {
            M.toast({ html: 'Error while checking availability of term '.concat(response.data) });
            this.updateReservation_isAvailable = null;
          }
        }).catch((error) => {
          M.toast({ html: 'Error while checking availability of term '.concat(error.message) });
        });
      }
    },
    //FEE
    async showFees(reservationId) {
      this.fee_reservation_id = reservationId;
      await this.getFeesForReservation();
      var elem = await document.querySelectorAll('select');
      await M.FormSelect.init(elem);
      var elems = document.querySelectorAll('.modal');
      M.Modal.init(elems);
      var instance = M.Modal.getInstance(elems[0]);
      instance.open();
    },
    async getFeesForReservation () {
      await axios.get(this.backend_url.concat('/reservation/', this.fee_reservation_id ,'/getfeelist')).then((response) => {
        if (response.data !== 'FAILURE')
          this.fee_reservationFeeList = response.data
        else
          M.toast({ html: 'Error while updating reservation fee list '.concat(response.data) });
      }).catch((error) => {
        M.toast({ html: 'Error while updating reservation fee list '.concat(error.message) });
      });
    },
    async addFeeToReservation() {
      await axios.post(this.backend_url.concat('/reservation/', this.fee_reservation_id, '/addfee'), {
        fee_id: this.fee_fee_id,
      }).then(async(response) => {
        if (response.data === 'OK') {
          M.toast({html: 'Fee has been added to reservation'});
          await this.getFeesForReservation();
        } else
          M.toast({html: 'Error while adding fee to reservation '.concat(response.data) });
      }).catch((error) => {
        M.toast({ html: 'Error while adding fee to reservation '.concat(error.message) });
      })
    },
    //COMPLETE RESERVATIONS
    async complete_this_reservation_and_calculate_cost(reservation) {
      await axios.get(this.backend_url.concat('/reservation/',reservation["id"], '/complete')).then(async(response) => {
        if (response.data === 'OK') {
          M.toast({ html: 'Reservation has been completed'});
          this.reservationList = await this.getReservationList();
        }
      }).catch((error) => {
        M.toast({ html: 'Error while completing a reservation '.concat(error.message) });
      });
    }
  },
  async beforeMount() {
    this.clientList = await this.getClientList();
    this.facilityList = await this.getFacilityList();
    this.reservationList = await this.getReservationList();
    this.statusList = await this.getStatusList();
    this.feeList = await this.getFeeList();
  }
}
</script>
<style scoped>
input[type=number]::-webkit-outer-spin-button,
input[type=number]::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type=number] {
  -moz-appearance:textfield;
}
tbody {
  display:block;
  height:550px;
  overflow:auto;
}
thead, tbody tr {
  display:table;
  width:100%;
  table-layout:fixed;
}
thead {
  width: calc( 100% - 1em )
}
table {
  width:100%;
}
</style>