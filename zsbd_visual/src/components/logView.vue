<template>
  <div>
    <div class="row">
      <table class="bordered red lighten-3 white-text">
        <thead>
          <tr>
            <th>ID</th>
            <th>Table name</th>
            <th>Action type</th>
            <th>Action date</th>
            <th>Table object ID</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in this.logList" :key="index">
            <td>{{ item["id"] }}</td>
            <td>{{ item["table_name"] }}</td>
            <td>{{ item["action_type"] }}</td>
            <td>{{ item["action_date"]}}</td>
            <td>{{ item["object_id"] }}</td>
            <td>{{ item["description"] }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="row center">
      <button @click="sort('id')" class="btn btn-block col red lighten-1" style="margin: 20px">Default sort by id</button>
      <button @click="sort('table_name')" class="btn btn-block col red lighten-1" style="margin: 20px">Sort by table name</button>
      <button @click="sort('action_type')" class="btn btn-block col red lighten-1" style="margin: 20px">Sort by action type</button>
      <button @click="sort('action_date')" class="btn btn-block col red lighten-1" style="margin: 20px">Sort by action date</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import M from 'materialize-css';
export default {
  name: 'logView',
  data() {
    return {
      backend_url: 'http://127.0.0.1:5000',
      logList: null,
    }
  },
  methods: {
    async updateLogList() {
      await axios.get(this.backend_url.concat('/log/getlist')).then(async(response) => {
        if (response.data !== 'FAILURE') {
          this.logList = response.data;
        } else {
          M.toast({ html: 'Error while getting log list '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting log list '.concat(error.message) });
      });
    },
    async sort(sortBy) {
      await axios.get(this.backend_url.concat('/log/getlist/', sortBy)).then(async(response) => {
        if (response.data !== 'FAILURE') {
          this.logList = response.data;
        } else {
          M.toast({ html: 'Error while getting log list '.concat(response.data) });
        }
      }).catch((error) => {
        M.toast({ html: 'Error while getting log list '.concat(error.message) });
      });
    }
  },
  async beforeMount() {
    await this.updateLogList();
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
  height:450px;
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