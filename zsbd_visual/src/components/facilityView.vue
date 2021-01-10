<template>
  <div class="row">
    <div class="col s2 pink" style="border-right-color: lightsalmon;
                                    border-bottom-color: lightsalmon;
                                    border-right-style: solid;
                                    border-bottom-style: solid;
                                    border-right-width: 4px;
                                    border-bottom-width: 4px;">
      <ul>
        <button @click="chooseView('createFacility')" class="row btn btn-block red" style="width: 200px;">Add new facility</button>
      </ul>
    </div>
    <form v-if="currentView === 'createFacility'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="createFacility"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="createFacility_name" class="active">Name</label>
          <input type="text" id="createFacility_name" maxlength="50" required/>
        </div>
        <div class="input-field">
          <label for="createFacility_cost" class="active">Cost per hour</label>
          <input type="number" id="createFacility_cost" min="0" max="999999999" required>
        </div>
        <div class="input-field">
          <select id="createFacility_caretaker" v-model="createFacility_caretakerId">
            <option value="" disabled></option>
            <option v-for="(item, index) in this.caretakerList" :key="index" :value="item.id">{{ item.first_name }} {{ item.second_name }}</option>
          </select>
          <label for="createFacility_caretaker">Caretaker name</label>
        </div>
        <button type="submit" class="btn btn-block red lighten-3">Submit</button>
      </div>
    </form>
    <form v-if="currentView === 'updateFacility'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="updateFacility"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="updateFacility_id" class="active">Facility ID</label>
          <input type="text" id="updateFacility_id" disabled/>
        </div>
        <div class="input-field">
          <label for="updateFacility_name" class="active">Name</label>
          <input type="text" id="updateFacility_name" minlength="5" maxlength="1000" required/>
        </div>
        <div class="input-field">
          <label for="updateFacility_cost" class="active">Cost</label>
          <input type="number" id="updateFacility_cost" min="5" max="999999999" required>
        </div>
        <div class="input-field">
          <select id="updateFacility_caretaker" v-model="updateFacility_caretakerId">
            <option value="" disabled></option>
            <option v-for="(item, index) in this.caretakerList" :key="index" :value="item.id">{{ item.first_name }} {{ item.second_name }}</option>
          </select>
          <label for="updateFacility_caretaker">Caretaker name</label>
        </div>
        <button type="submit" class="btn btn-block red lighten-3">Submit</button>
      </div>
    </form>
    <div class="col s5 right">
      <table class="bordered red lighten-3 white-text">
        <thead>
        <tr>
          <th>ID</th>
          <th>Update</th>
          <th>Name</th>
          <th>Cost</th>
          <th>Caretaker ID</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(item, index) in this.facilityList" :key="index">
          <td>{{ item["id"] }}</td>
          <td><button type="button" @click="selectToUpdate(item)" class="btn btn-small btn-floating red">U</button></td>
          <td>{{ item["name"] }}</td>
          <td>{{ item["cost"] }}</td>
          <td>{{ item["caretaker_id"] }}</td>
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
  name: 'facilityView',
  computed: {
    console: () => console
  },
  data() {
    return {
      backend_url: 'http://127.0.0.1:5000',
      currentView: null,
      facilityList: null,
      caretakerIdCreate: '',
      selectedFacility: null,
      createFacility_caretakerId: '',
      updateFacility_caretakerId: '',
      caretakerList: null,
    }
  },
  methods: {
    async chooseView(viewToOpen) {
      this.currentView = await viewToOpen;
      var elems = await document.querySelectorAll('select');
      await M.FormSelect.init(elems);
      var elem= await document.querySelectorAll('select');
      await M.FormSelect.init(elem);
    },
    async createFacility() {
      const name_field = document.getElementById('createFacility_name');
      const cost_field = document.getElementById('createFacility_cost');
      await axios.post(this.backend_url.concat('/facility/create'), {
        name: name_field.value,
        cost: cost_field.value,
        caretaker_id: this.createFacility_caretakerId
      }).then(async(response) => {
        if (response.data === 'OK') {
          M.toast({ html: 'Facility has been added' });
          name_field.value = '';
          cost_field.value = '';
          this.createFacility_caretakerId = '';
          var elems = await document.querySelectorAll('select');
          await M.FormSelect.init(elems);
          await this.updateFacilityList();
        } else {
          M.toast({ html: 'Error while creating facility '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while creating facility '.concat(error.message) });
      });
    },
    async updateFacility() {
      const name_field = document.getElementById('updateFacility_name');
      const cost_field = document.getElementById('updateFacility_cost');
      await axios.put(this.backend_url.concat('/facility/', this.selectedFacility["id"], '/update'), {
        name: name_field.value,
        cost: cost_field.value,
        caretaker_id: this.updateFacility_caretakerId
      }).then(async (response) => {
        if (response.data === 'OK') {
          M.toast({ html: 'Facility has been updated' });
          await this.updateFacilityList();
        } else {
          M.toast({ html: 'Error while updating facility '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while updating facility '.concat(error.message) });
      });
    },
    async updateFacilityList() {
      await axios.get(this.backend_url.concat('/facility/getlist')).then((response) => {
        if (response.data !== 'FAILURE') {
          this.facilityList = response.data
        } else {
          M.toast({ html: 'Failure while getting facility list '.concat(response.data)})
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting facility list '.concat(error.message) });
      });
    },
    async updateCaretakerList() {
      await axios.get(this.backend_url.concat('/caretaker/getlist')).then((response) => {
        if (response.data !== 'FAILURE') {
          this.caretakerList = response.data
        } else {
          M.toast({ html: 'Failure while getting caretaker list '.concat(response.data)})
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting caretaker list '.concat(error.message) });
      });
    },
    async selectToUpdate(item) {
      this.updateFacility_caretakerId = item["caretaker_id"]
      await this.chooseView('updateFacility');
      this.selectedFacility = item;
      var elem= await document.querySelectorAll('select');
      await M.FormSelect.init(elem);
      document.getElementById('updateFacility_id').value = item["id"];
      document.getElementById('updateFacility_name').value = item["name"];
      document.getElementById('updateFacility_cost').value = item["cost"];
    },
  },
  async beforeMount() {
    await this.updateFacilityList();
    await this.updateCaretakerList();
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