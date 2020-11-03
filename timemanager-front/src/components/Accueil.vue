<template>
  <div class="container">
    <template>
      <div id="app">
        azeza
        <!-- :bar-colors="osColors" -->
        <bar-chart
          id="bar"
          :data="this.getdays"
          xkey="Day"
          ykeys='[ "hours" ]'
          resize="true"
          labels='[ "Working hours per day" ]'
          bar-colors='[ "#65A2FF" ]'
          grid="true"
          grid-text-weight="bold"
          ymax="24"
        >
        </bar-chart>
      </div>
    </template>
  </div>
</template>

<script>
export default {
  beforeCreate: function () {
    this.ApiUrl = this.$hostname;
  },
  data() {
    return {
      // ApiUrl : '', // Prédéclaré mais before create se lance avant, donc useless  beforeCreate -> function 
      info: null,
      name: "Accueil",
      arrayColors: ["#FF6384", "#73c000", "#FFCE56"],
      barData: [
        { Day: "Monday", hours: 10, total: 24 },
        { Day: "Tuesday", hours: 10, total: 24 },
        { Day: "Wednesday", hours: 7, total: 24 },
        { Day: "Thursday", hours: 6, total: 24 },
        { Day: "Friday", hours: 1, total: 24 },
      ],
    };
  },
  components: {
    BarChart,
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
    getdays: function () {
      let mondayBool = false;
      let tuesdayBool = false;
      let wednesdayBool = false;
      let thursdayBool = false;
      let fridayBool = false;

      var arr = new Array();
      var obj;
      if (this.info) {
        for (var key in this.info.data) {
          obj = this.info["data"][key];
        }

        for (var inkey in obj) {
          obj.sort(function (a, b) {
            var keyA = new Date(a.start);
            var keyB = new Date(b.start);
            // Compare the 2 dates
            if (keyA < keyB) return -1;
            if (keyA > keyB) return 1;
            return 0;
          });
        }

        var i = 0;
        arr[0] = new Object();
        arr[1] = new Object();
        arr[2] = new Object();
        arr[3] = new Object();
        arr[4] = new Object();
        for (var inkey in obj) {
          // console.log(obj[inkey]['start']);
          // console.log(obj[inkey]['end']);
          // console.log(obj[inkey]['start']);
          const tmp = Math.abs(
            Date.parse(obj[inkey]["end"]) - Date.parse(obj[inkey]["start"])
          );
          const diffTime = tmp / (1000 * 60 * 60); //millisec to heure
          // b.workduration = diffTime; // traduit la valeur
          if (
            new Date(obj[inkey]["end"]).getDay() ===
            new Date(obj[inkey]["start"]).getDay()
          ) {
            // console.log(new Date(obj[inkey]['start']).getDay() + " Here 0 ");
            let hoursDay = new Date(obj[inkey]["start"]);
            // alert(new Date(obj[inkey]['start']).getDay());
            let day = hoursDay.getDay();
            switch (day) {
              case 1:
                if (mondayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Monday") {
                      // alert(" Hours === " + arr[idx]['Day']);
                      arr[0]["hours"] += diffTime;
                    }
                  }
                } else {
                  arr[0]["Day"] = "Monday";
                  arr[0]["hours"] = diffTime;
                }
                arr[0]["total"] = 24;
                mondayBool = true;
                break;
              case 2:
                if (tuesdayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Tuesday") {
                      arr[1]["hours"] += diffTime;
                    }
                  }
                } else {
                  arr[1]["hours"] = diffTime;
                  arr[1]["Day"] = "Tuesday";
                }
                arr[1]["total"] = 24;
                tuesdayBool = true;
                break;
              case 3:
                if (wednesdayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Wednesday") {
                      arr[2]["hours"] += diffTime;
                    }
                  }
                  // arr[i]['hours'] += diffTime;
                } else {
                  arr[2]["hours"] = diffTime;
                  arr[2]["Day"] = "Wednesday";
                }
                arr[2]["total"] = 24;
                wednesdayBool = true;
                break;
              case 4:
                if (thursdayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Thursday") {
                      arr[3]["hours"] += diffTime;
                    }
                  }
                } else {
                  arr[3]["Day"] = "Thursday";
                  arr[3]["hours"] = diffTime;
                  alert(i);
                  arr[3]["total"] = 24;
                }
                // arr[i]['total'] = 24;
                thursdayBool = true;
                break;
              case 5:
                if (fridayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Friday") {
                      // arr[4]['hours'] += diffTime;
                    }
                  }
                  // arr[i]['hours'] += diffTime;
                } else {
                  arr[4]["hours"] = diffTime;
                  arr[4]["Day"] = "Friday";
                }
                arr[4]["total"] = 24;
                fridayBool = true;
                break;
              default:
                break;
            }
            // console.log(" Day === " + hoursDay.getDay());
          }
          i++;
        }
        // ...

        // let objJson = JSON.stringify(this.info['data']['data']);
      }
      // return this.workingtimes.map((b) => {
      //   // tmp = Date.parse(b.end) - Date.parse(b.start)
      //   const tmp = Math.abs(Date.parse(b.end) - Date.parse(b.start));
      //   const diffTime = tmp / (1000 * 60 * 60); //millisec to heure
      //   b.workduration = diffTime; // traduit la valeur
      //   return b;
      // });
      if (mondayBool === false) {
        arr[0] = new Array();
        arr[0]["Day"] = "Monday";
        arr[0]["hours"] = 0;
        arr[0]["total"] = 24;
      }
      if (tuesdayBool === false) {
        arr[1] = new Array();
        arr[1]["Day"] = "Tuesday";
        arr[1]["hours"] = 0;
        arr[1]["total"] = 24;
      }
      if (wednesdayBool === false) {
        arr[2] = new Array();
        arr[2]["Day"] = "Wednesday";
        arr[2]["hours"] = 0;
        arr[2]["total"] = 24;
      }
      if (thursdayBool === false) {
        arr[3] = new Array();
        arr[3]["Day"] = "Thursday";
        arr[3]["hours"] = 0;
        arr[3]["total"] = 24;
      }
      if (fridayBool === false) {
        arr[4] = new Array();
        arr[4]["Day"] = "Friday";
        arr[4]["hours"] = 0;
        arr[4]["total"] = 24;
      }
      // console.log(arr);
      return arr;
    },
  },
  async mounted() {
    // Login pour le test, normalement tu delete ça antoine
    var userId = '';
    var jwt = '';
    var data = JSON.stringify({"email":"foo@bar.com","password":"Xdveg567"});
    var config = {
      method: 'post',
      url: this.ApiUrl + 'users/sign_in',
      headers: { 
        'Content-Type': 'application/json'
      },
      data : data
    };
    try {
    let tmp = await axios(config);
    jwt = tmp.data.jwt;
    }
    catch (err) {
    }


var config = {
  method: 'get',
      url: this.ApiUrl + 'users/my_user',
  headers: { 
    'Authorization': 'Bearer ' + jwt
  }
};

    try {
      let userData = await axios(config);
      userId = userData.data.id;
      console.log("var == " + userId);
    }
    catch (err) {
    }


    axios
      .get(
        this.ApiUrl + "workingtimes/" + userId + "?start=" +
          monday /*2019-10-21 08:52:16*/ +
          "&end=" +
          friday /*2021-10-21 20:52:16*/,
          { 
            headers: {
              'Authorization': 'Bearer ' + jwt
            }
          }
      )
      .then((response) => {
        this.info = response;
      });

    // .then((response) => (this.info = response));
  },
  methods: {
    rand(limit) {
      return Math.round(Math.random() * limit);
    },
    osColors() {
      console.log("osColors");
      return [];
    },
  },
};

import { jquery } from "./../../node_modules/jQuery/tmp/jquery";
import { DonutChart, BarChart, LineChart, AreaChart } from "vue-morris";
import axios from "axios";
let d = new Date();
var day = d.getDay();
let diff = d.getDate() - day + (day == 0 ? -6 : 1); // adjust when day is sunday

let lundi = new Date();
var distance = diff - d.getDate();
lundi.setDate(d.getDate() + distance);
// alert(lundi.toString()); // Distance est forcément "négatif" ex 12 + (-3) = 9
let vendredi = new Date();
vendredi.setDate(lundi.getDate() + 5 - 1);
// alert(vendredi.toString()); // Distance est forcément "négatif" ex 12 + (-3) = 9

// console.log(vendredi.getFullYear() + "-" + (vendredi.getMonth()+1) + "-" + vendredi.getDate() + " " + vendredi.getHours() + "-" + vendredi.getMinutes() + "-" + vendredi.getSeconds());
let twoDigit;
if (vendredi.getHours() < 10) twoDigit = "0" + twoDigit;
else twoDigit = vendredi.getHours();

// let friday = vendredi.getFullYear() + "-" + ((vendredi.getMonth()+1)<10?'0':'') + (vendredi.getMonth()+1) + "-" + (vendredi.getDate()<10?'0':'') + vendredi.getDate() + " " + (vendredi.getHours()<10?'0':'') + vendredi.getHours() + ":" + (vendredi.getMinutes()<10?'0':'') + vendredi.getMinutes() + ":" + (vendredi.getSeconds()<10?'0':'') + vendredi.getSeconds();
// let monday = lundi.getFullYear() + "-" + ((lundi.getMonth()+1)<10?'0':'') + (lundi.getMonth()+1) + "-" + (lundi.getDate()<10?'0':'') + lundi.getDate() + " " + (lundi.getHours()<10?'0':'') + lundi.getHours() + ":" + (lundi.getMinutes()<10?'0':'') + lundi.getMinutes() + ":" + (lundi.getSeconds()<10?'0':'') + lundi.getSeconds();
let friday =
  vendredi.getFullYear() +
  "-" +
  (vendredi.getMonth() + 1 < 10 ? "0" : "") +
  (vendredi.getMonth() + 1) +
  "-" +
  (vendredi.getDate() < 10 ? "0" : "") +
  vendredi.getDate() +
  " " +
  "23" +
  ":" +
  "59" +
  ":" +
  (vendredi.getSeconds() < 10 ? "0" : "") +
  vendredi.getSeconds();
let monday =
  lundi.getFullYear() +
  "-" +
  (lundi.getMonth() + 1 < 10 ? "0" : "") +
  (lundi.getMonth() + 1) +
  "-" +
  (lundi.getDate() < 10 ? "0" : "") +
  lundi.getDate() +
  " " +
  "00" +
  ":" +
  "00" +
  ":" +
  (lundi.getSeconds() < 10 ? "0" : "") +
  lundi.getSeconds();
// alert(monday);

</script>
