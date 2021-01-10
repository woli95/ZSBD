<template>
  <div class="row">
    <div class="col s2 pink" style="border-right-color: lightsalmon;
                                    border-bottom-color: lightsalmon;
                                    border-right-style: solid;
                                    border-bottom-style: solid;
                                    border-right-width: 4px;
                                    border-bottom-width: 4px;">
      <ul>
        <button @click="chooseView('createFee')" class="row btn btn-block red" style="width: 200px;">Add new fee</button>
      </ul>
    </div>
    <form v-if="currentView === 'createFee'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="createFee"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="createFee_description" class="active">Description</label>
          <input type="text" id="createFee_description" minlength="5" maxlength="1000" required/>
        </div>
        <div class="input-field">
          <label for="createFee_cost" class="active">Cost</label>
          <input type="number" id="createFee_cost" min="0" max="999999999" required>
        </div>
        <button type="submit" class="btn btn-block red lighten-3">Submit</button>
      </div>
    </form>
    <form v-if="currentView === 'updateFee'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="updateFee"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="updateFee_id" class="active">Fee ID</label>
          <input type="text" id="updateFee_id" disabled/>
        </div>
        <div class="input-field">
          <label for="updateFee_description" class="active">Description</label>
          <input type="text" id="updateFee_description" minlength="5" maxlength="1000" required/>
        </div>
        <div class="input-field">
          <label for="updateFee_cost" class="active">Cost</label>
          <input type="number" id="updateFee_cost" min="5" max="999999999" required>
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
          <th>Description</th>
          <th>Cost</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(item, index) in this.feeList" :key="index">
          <td>{{ item["id"] }}</td>
          <td><button type="button" @click="selectToUpdate(item)" class="btn btn-small btn-floating red">U</button></td>
          <td>{{ item["description"] }}</td>
          <td>{{ item["cost"] }}</td>
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
  name: 'feesView',
  data() {
    return {
      backend_url: 'http://127.0.0.1:5000',
      currentView: null,
      feeList: null,
      selectedFee: null,
    }
  },
  methods: {
    chooseView(viewToOpen) {
      this.currentView = viewToOpen;
    },
    async updateFeeList() {
      await axios.get(this.backend_url.concat('/fee/getlist')).then((response) => {
        if (response.data !== 'FAILURE') {
          this.feeList = response.data
        } else {
          M.toast({ html: 'Failure while getting fee list '.concat(response.data)})
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting fee list '.concat(error.message) });
      });
    },
    async createFee() {
      const desc_field = document.getElementById('createFee_description');
      const cost_field = document.getElementById('createFee_cost');
      await axios.post(this.backend_url.concat('/fee/create'), {
        description: desc_field.value,
        cost: cost_field.value
      }).then(async(response) => {
        if (response.data === 'OK') {
          M.toast({ html: 'Fee has been added' });
          desc_field.value = '';
          cost_field.value = '';
          await this.updateFeeList();
        } else {
          M.toast({ html: 'Error while createing fee '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while creating fee '.concat(error.message) });
      });
    },
    async selectToUpdate(item) {
      await this.chooseView('updateFee');
      this.selectedFee = item;
      document.getElementById('updateFee_id').value = item["id"];
      document.getElementById('updateFee_description').value = item["description"];
      document.getElementById('updateFee_cost').value = item["cost"];
    },
    async updateFee() {
      const desc_field = document.getElementById('updateFee_description');
      const cost_field = document.getElementById('updateFee_cost');
      await axios.put(this.backend_url.concat('/fee/', this.selectedFee["id"], '/update'), {
        description: desc_field.value,
        cost: cost_field.value
      }).then(async(response) => {
        if (response.data === 'OK') {
          M.toast({ html: 'Fee has been updated '});
          await this.updateFeeList();
        } else {
          M.toast({ html: 'Error while updating fee '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while updating fee '.concat(error.message) });
      });
    }
  },
  async beforeMount() {
    await this.updateFeeList();
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