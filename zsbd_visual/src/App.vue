<template>
  <div>
    <nav>
      <div class="nav-wrapper" style="border-bottom-width: 5px; border-bottom-color: lightsalmon;border-bottom-style: solid">
        <a @click="showView(null)" class="brand-logo" style="margin-left: 10px">SportCenter</a>
        <ul class="right">
          <li><a @click="showView('clients')">Clients</a></li>
          <li><a @click="showView('reservations')">Reservations</a></li>
          <li><a @click="showView('facilities')">Facilities</a></li>
          <li><a @click="showView('discounts')">Discounts</a></li>
          <li><a @click="showView('caretakers')">Caretakers</a></li>
          <li><a @click="showView('fees')">Fees</a></li>
          <li><a @click="showView('logs')">Logs</a></li>
        </ul>
      </div>
    </nav>
    <clientView v-if="currentView === 'clients'"/>
    <feesView v-if="currentView === 'fees'"/>
    <facilityView v-if="currentView === 'facilities'"/>
    <discountView v-if="currentView === 'discounts'"/>
    <caretakerView v-if="currentView === 'caretakers'"/>
    <reservationView v-if="currentView === 'reservations'"/>
    <logView v-if="currentView === 'logs'"/>
  </div>
</template>

<script>
import M from 'materialize-css';
import clientView from '@/components/clientView';
import feesView from '@/components/feesView';
import facilityView from '@/components/facilityView';
import discountView from '@/components/discountView';
import caretakerView from '@/components/caretakerView';
import reservationView from '@/components/reservationView';
import logView from '@/components/logView'
export default {
  name: 'App',
  components: {
    clientView,
    feesView,
    facilityView,
    discountView,
    caretakerView,
    reservationView,
    logView
  },
  data() {
    return {
      materializeCssInstance: M,
      backend_url: 'http://127.0.0.1:5000',
      currentView: null,
    }
  },
  methods: {
    showView(viewToShow) {
      this.currentView = viewToShow;
    }
  }
}
</script>

<style>
</style>
