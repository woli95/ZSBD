<template>
  <div class="row">
    <div class="col s2 pink" style="border-right-color: lightsalmon;
                                    border-bottom-color: lightsalmon;
                                    border-right-style: solid;
                                    border-bottom-style: solid;
                                    border-right-width: 4px;
                                    border-bottom-width: 4px;">
      <ul>
        <button @click="chooseView('createCaretaker')" class="row btn btn-block red" style="width: 100%;">Add new caretaker</button>
      </ul>
    </div>
    <form v-if="currentView === 'createCaretaker'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="createCaretaker"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="createCaretaker_firstName" class="active">First name</label>
          <input type="text" id="createCaretaker_firstName" minlength="2" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="createCaretaker_secondName" class="active">Second name</label>
          <input type="text" id="createCaretaker_secondName" minlength="2" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="createCaretaker_phoneNumber" class="active">Phone number</label>
          <input type="number" id="createCaretaker_phoneNumber" min="100000000" max="999999999" step="1" required>
        </div>
        <button type="submit" class="btn btn-block red lighten-3">Submit</button>
      </div>
    </form>
    <form v-if="currentView === 'updateCaretaker'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="updateCaretaker"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="updateCaretaker_id" class="active">Discount ID</label>
          <input type="text" id="updateCaretaker_id" disabled/>
        </div>
        <div class="input-field">
          <label for="updateCaretaker_firstName" class="active">First name</label>
          <input type="text" id="updateCaretaker_firstName" minlength="2" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="updateCaretaker_secondName" class="active">Second name</label>
          <input type="text" id="updateCaretaker_secondName" minlength="2" maxlength="20" required/>
        </div>
        <div class="input-field">
          <label for="updateCaretaker_phoneNumber" class="active">Phone number</label>
          <input type="number" id="updateCaretaker_phoneNumber" min="100000000" maxlength="999999999" step="1" required/>
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
          <th>First name</th>
          <th>Second name</th>
          <th>Phone number</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(item, index) in this.caretakerList" :key="index">
          <td>{{ item["id"] }}</td>
          <td><button type="button" @click="selectToUpdate(item)" class="btn btn-small btn-floating red">U</button></td>
          <td>{{ item["first_name"] }}</td>
          <td>{{ item["second_name"] }}</td>
          <td>{{ item["phone_number"] }}</td>
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
  name: 'caretakerView',
  computed: {
    console: () => console
  },
  data() {
    return {
      backend_url: 'http://127.0.0.1:5000',
      currentView: null,
      caretakerList: [],
      selectedCaretaker: null,
    }
  },
  methods: {
    async updateCaretakerList() {
      await axios.get(this.backend_url.concat('/caretaker/getlist')).then((response) => {
        this.caretakerList = response.data;
      }).catch((error) => {
        M.toast({html: 'Error while loading discount list '.concat(error.message) });
      });
    },
    chooseView(viewToOpen) {
      this.currentView = viewToOpen;
    },
    async createCaretaker() {
      const fn_field = document.getElementById('createCaretaker_firstName');
      const sn_field = document.getElementById('createCaretaker_secondName');
      const pn_field = document.getElementById('createCaretaker_phoneNumber');
      await axios.post(this.backend_url.concat('/caretaker/create'), {
        first_name: fn_field.value,
        second_name: sn_field.value,
        phone_number: pn_field.value.toString()
      }).then((response) => {
        if (response.data === 'OK') {
          M.toast({html: 'Caretaker has been added'});
          this.updateCaretakerList();
          fn_field.value = '';
          sn_field.value = '';
          pn_field.value = '';
        } else {
          M.toast({html: 'Error while adding new caretaker'.concat(response.data) })
        }
      }).catch((error) => {
        M.toast({html: 'Error while adding new caretaker '.concat(error.message) });
      })
    },
    async selectToUpdate(item) {
      await this.chooseView('updateCaretaker');
      this.selectedCaretaker = item;
      document.getElementById('updateCaretaker_id').value = item["id"];
      document.getElementById('updateCaretaker_firstName').value = item["first_name"];
      document.getElementById('updateCaretaker_secondName').value = item["second_name"];
      document.getElementById('updateCaretaker_phoneNumber').value = item["phone_number"];
    },
    async updateCaretaker() {
      const fn_field = document.getElementById('updateCaretaker_firstName');
      const sn_field = document.getElementById('updateCaretaker_secondName');
      const pn_field = document.getElementById('updateCaretaker_phoneNumber');
      await axios.put(this.backend_url.concat('/caretaker/', this.selectedCaretaker["id"], '/update'), {
        first_name: fn_field.value,
        second_name: sn_field.value,
        phone_number: pn_field.value.toString()
      }).then(async (response) => {
        if (response.data === 'OK') {
          M.toast({html: 'Caretaker has been updated'});
        }
        await this.updateCaretakerList();
      }).catch((error) => {
        M.toast({html: 'Error while updating caretaker '.concat(error.message)});
      });
    },
  },
  async beforeMount() {
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