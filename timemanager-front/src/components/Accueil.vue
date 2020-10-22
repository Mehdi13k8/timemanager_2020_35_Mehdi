<template>
  <div class="container">
    <template>
      <div id="app">
        <h1>Donut Chart</h1>
        <donut-chart
          id="donut"
          :data="donutData"
          :colors="arrayColors"
          resize="true"
        >
        </donut-chart>
      </div>
    </template>
  </div>
</template>

<script>
import { jquery } from './../../node_modules/jQuery/tmp/jquery';
import { DonutChart } from 'vue-morris'

export default {
  data() {
    return {
      userid: 1,
      workingtimes: [
        {
          start: "2020-10-20 08:00:00",
          end: "2020-10-20 17:00:00",
          id: 1,
        },
        {
          start: "2020-10-21 08:00:00",
          end: "2020-10-21 15:00:00",
          id: 2,
        },
      ],
      name: "Accueil",
      donutData: [
        { label: "Car", value: 40 },
        { label: "Motorcycle", value: 150 },
        { label: "airplane", value: 100 },
      ],
      arrayColors: ["#FF6384", "#73c000", "#FFCE56"],
    };
  },
  components: {
    DonutChart,
  },
  computed: {
    result: function () {
      return this.workingtimes.map((b) => {
        // tmp = Date.parse(b.end) - Date.parse(b.start)
        const tmp = Math.abs(Date.parse(b.end) - Date.parse(b.start));
        const diffTime = tmp / (1000 * 60 * 60); //millisec to heure
        b.workduration = diffTime; // traduit la valeur
        return b;
      });
    },
  },
  //   mounted () {
  //   axios
  //     .get('https://api.coindesk.com/v1/bpi/currentprice.json')
  //     .then(response => (this.info = response))
  // }
};
</script>
