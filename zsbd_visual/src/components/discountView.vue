<template>
  <div class="row">
    <div class="col s2 pink" style="border-right-color: lightsalmon;
                                    border-bottom-color: lightsalmon;
                                    border-right-style: solid;
                                    border-bottom-style: solid;
                                    border-right-width: 4px;
                                    border-bottom-width: 4px;">
      <ul>
        <button @click="chooseView('createDiscount')" class="row btn btn-block red" style="width: 200px;">Add new discount</button>
      </ul>
    </div>
    <form v-if="currentView === 'createDiscount'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="createDiscount"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="createDiscount_name" class="active">Discount name</label>
          <input type="text" id="createDiscount_name" maxlength="50" required/>
        </div>
        <div class="input-field">
          <label for="createDiscount_factor" class="active">Factor (0.xy)</label>
          <input type="number" id="createDiscount_factor" min="0.01" max="1.0" step="0.01" required>
        </div>
        <button type="submit" class="btn btn-block red lighten-3">Submit</button>
      </div>
    </form>
    <form v-if="currentView === 'updateDiscount'"
          class="col s2 "
          style="margin-left: 30px;
                 margin-top: 10px;"
          @submit="updateDiscount"
          action="javascript:void(0)">
      <div class="row">
        <div class="input-field">
          <label for="updateDiscount_id" class="active">Discount ID</label>
          <input type="text" id="updateDiscount_id" disabled/>
        </div>
        <div class="input-field">
          <label for="updateDiscount_name" class="active">Discount name</label>
          <input type="text" id="updateDiscount_name" maxlength="50" required/>
        </div>
        <div class="input-field">
          <label for="updateDiscount_factor" class="active">Factor (0.xy)</label>
          <input type="number" id="updateDiscount_factor" min="0.01" max="1.00" step="0.01" required/>
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
          <th>Discount name</th>
          <th>Factor</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(item, index) in this.discountList" :key="index">
          <td>{{ item["id"] }}</td>
          <td><button type="button" @click="selectToUpdate(item)" class="btn btn-small btn-floating red">U</button></td>
          <td>{{ item["name"] }}</td>
          <td>{{ Math.round(item["factor"]*100, 2) }}%</td>
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
  name: 'discountView',
  computed: {
    console: () => console
  },
  data() {
    return {
      backend_url: 'http://127.0.0.1:5000',
      currentView: null,
      discountList: [],
      selectedDiscount: null,
    }
  },
  methods: {
    async updateDiscountList() {
      await axios.get(this.backend_url.concat('/discount/getlist')).then((response) => {
        this.discountList = response.data;
      }).catch((error) => {
        M.toast({html: error.message});
      });
    },
    chooseView(viewToOpen) {
      this.currentView = viewToOpen;
    },
    async createDiscount() {
      const n_field = document.getElementById('createDiscount_name');
      const f_field = document.getElementById('createDiscount_factor');
      await axios.post(this.backend_url.concat('/discount/create'), {
        name: n_field.value,
        factor: f_field.value,
      }).then((response) => {
        if (response.data === 'OK') {
          M.toast({html: 'Discount has been created'});
          this.updateDiscountList();
          n_field.value = '';
          f_field.value = '';
        } else {
          M.toast({html: response.data})
        }
      }).catch((error) => {
        M.toast({html: 'Error while creating new discount '.concat(error.message)});
      })
    },
    async selectToUpdate(item) {
      await this.chooseView('updateDiscount');
      this.selectedDiscount = item;
      document.getElementById('updateDiscount_id').value = item["id"];
      document.getElementById('updateDiscount_name').value = item["name"];
      document.getElementById('updateDiscount_factor').value = item["factor"];
    },
    async updateDiscount() {
      const n_field = document.getElementById('updateDiscount_name');
      const f_field = document.getElementById('updateDiscount_factor');
      await axios.put(this.backend_url.concat('/discount/', this.selectedDiscount["id"], '/update'), {
        name: n_field.value,
        factor: f_field.value,
      }).then(async (response) => {
        if (response.data === 'OK') {
          M.toast({html: 'Discount has been updated'});
        }
        await this.updateDiscountList();
      }).catch((error) => {
        M.toast({html: 'Error while updating discount '.concat(error.message)});
      });
    },
    /////////////////////
  },
  async beforeMount() {
    await this.updateDiscountList();
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