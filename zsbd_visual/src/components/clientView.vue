<template>
  <div class="row">
    <div class="col s2 pink" style="border-right-color: lightsalmon;
                                    border-bottom-color: lightsalmon;
                                    border-right-style: solid;
                                    border-bottom-style: solid;
                                    border-right-width: 4px;
                                    border-bottom-width: 4px;">
      <ul>
        <button @click="chooseView('createClient')" class="row btn btn-block red" style="width: 200px;">Create client</button>
      </ul>
    </div>
    <form v-if="currentView === 'createClient'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="createClient"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="createClient_firstName" class="active">First name</label>
          <input type="text" id="createClient_firstName" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="createClient_secondName" class="active">Second name</label>
          <input type="text" id="createClient_secondName" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="createClient_phoneNumber" class="active">Phone number</label>
          <input type="number" id="createClient_phoneNumber" min="100000000" max="999999999" required>
        </div>
          <button type="submit" class="btn btn-block red lighten-3">Submit</button>
      </div>
    </form>
    <form v-if="currentView === 'updateClient'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="updateClient"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="updateClient_id" class="active">Client ID</label>
          <input type="text" id="updateClient_id" disabled/>
        </div>
        <div class="input-field">
          <label for="updateClient_firstName" class="active">First name</label>
          <input type="text" id="updateClient_firstName" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="updateClient_secondName" class="active">Second name</label>
          <input type="text" id="updateClient_secondName" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="updateClient_phoneNumber" class="active">Phone number</label>
          <input type="number" id="updateClient_phoneNumber" min="100000000" max="999999999" required>
        </div>
        <div class="input-field">
          <select id="updateClient_discount" v-model="discountIdUpdate">
            <option v-for="(item, index) in this.discountList" :key="index" :value="item.id">{{ item.name }} {{ Math.round(item.factor * 100, 0)}}%</option>
          </select>
          <label for="updateClient_discount">Discount name</label>
        </div>
        <button type="submit" class="btn btn-block red lighten-3">Submit</button>
      </div>
    </form>
    <div v-if="currentView === 'reservationsClient'"
         class="col s4">
      <table class="bordered red lighten-2 white-text">
        <thead>
          <tr>
            <th>ID</th>
            <th>Facility name</th>
            <th>Booked</th>
            <th>Date</th>
            <th>Hours</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in this.selectedClientReservations" :key="index">
            <td>{{ item["id"] }}</td>
            <td>{{ item["facility_name"] }}</td>
            <td>{{ item["ordered_date"] }}</td>
            <td>{{ item["order_date"] }}</td>
            <td>{{ item["duration_in_hours"] }}</td>
            <td>{{ item["status_name"]}}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="col s6 right">
      <table class="bordered red lighten-3 white-text">
        <thead>
          <tr>
            <th>ID</th>
            <th>Show Res.</th>
            <th>Update</th>
            <th>First name</th>
            <th>Second name</th>
            <th>Phone number</th>
            <th>Discount ID</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in this.clientList" :key="index">
            <td>{{ item["id"] }}</td>
            <td><button type="button" @click="showReservations(item)" class="btn btn-small btn-floating red">Res</button></td>
            <td><button type="button" @click="selectToUpdate(item)" class="btn btn-small btn-floating red">U</button></td>
            <td>{{ item["first_name"] }}</td>
            <td>{{ item["second_name"] }}</td>
            <td>{{ item["phone_number"] }}</td>
            <td>{{ item["discount_id"] }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import M from 'materialize-css';
export default {
  name: 'clientView',
  computed: {
    console: () => console
  },
  data() {
    return {
      backend_url: 'http://127.0.0.1:5000',
      currentView: null,
      clientList: null,
      selectedClient: null,
      selectedClientReservations: null,
      discountList: [],
      discountIdUpdate: '',
    }
  },
  methods: {
    async updateClientList() {
      await axios.get(this.backend_url.concat('/client/getlist')).then((response) => {
        this.clientList = response.data;
      }).catch((error) => {
        M.toast({ html: error.message });
      });
    },
    async updateDiscountList() {
      await axios.get(this.backend_url.concat('/discount/getlist')).then((response) => {
        this.discountList = response.data;
      }).catch((error) => {
        M.toast({ html: error.message });
      });
    },
    chooseView(viewToOpen) {
      this.currentView = viewToOpen;
    },
    async createClient() {
      const fn_field = document.getElementById('createClient_firstName');
      const sn_field = document.getElementById('createClient_secondName');
      const pn_field = document.getElementById('createClient_phoneNumber');
      await axios.post(this.backend_url.concat('/client/create'), {
        first_name: fn_field.value,
        second_name: sn_field.value,
        phone_number: pn_field.value,
      }).then((response) => {
        if (response.data === 'OK') {
          M.toast({ html: 'Client has been created' });
          this.updateClientList();
          fn_field.value = '';
          sn_field.value = '';
          pn_field.value = '';
        } else {
          M.toast({ html: response.data})
        }
      }).catch((error) => {
        M.toast( { html: 'Error while creating new client '.concat(error.message) });
      })
    },
    async selectToUpdate(item) {
      await this.chooseView('updateClient');
      this.selectedClient = item;
      this.discountIdUpdate = item["discount_id"];
      var elems = await document.querySelectorAll('select');
      await M.FormSelect.init(elems);
      document.getElementById('updateClient_id').value = item["id"];
      document.getElementById('updateClient_firstName').value = item["first_name"];
      document.getElementById('updateClient_secondName').value = item["second_name"];
      document.getElementById('updateClient_phoneNumber').value = item["phone_number"];
    },
    async updateClient() {
      const fn_field = document.getElementById('updateClient_firstName');
      const sn_field = document.getElementById('updateClient_secondName');
      const pn_field = document.getElementById('updateClient_phoneNumber');
      const discount_field = document.getElementById('updateClient_discount');
      let disc = discount_field.value;
      if (discount_field.value === '') {
        disc = 'NULL';
      }
      await axios.put(this.backend_url.concat('/client/', this.selectedClient["id"], '/update'), {
        first_name: fn_field.value,
        second_name: sn_field.value,
        phone_number: pn_field.value,
        discount_id: disc
      }).then(async(response) => {
        if (response.data === 'OK') {
          M.toast({ html: 'Client has been updated' });
        }
        await this.updateClientList();
      }).catch((error) => {
        M.toast({ html: 'Error while updating client '.concat(error.message) });
      });
    },
    /////////////////////
    async showReservations(item) {
      this.chooseView('reservationsClient');
      await axios.get(this.backend_url.concat('/client/', item["id"], '/getreservationlist')).then((response) => {
        if (response.data !== 'FAILURE') {
          this.selectedClientReservations = response.data
        }
      }).catch((error) => {
        M.toast({ html: 'Error while loading reservation list '.concat(error.message) });
      });
    }
  },
  async beforeMount() {
    await this.updateClientList();
    await this.updateDiscountList();
  },
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
  height:300px;
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