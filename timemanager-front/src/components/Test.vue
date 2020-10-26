<template>
  <div class="container">
    Test
    <h3>Line Chart <small>(with values modified every 5 seconds)</small></h3>
    <div v-if="lineData.length != 0">
      <line-chart
        id="line"
        :data="lineData"
        xkey="day"
        ykeys='[ "a", "b" ]'
        parseTime="false"
        resize="true"
        labels='[ "Serie A", "Serie B" ]'
        line-colors='[ "#FF6384", "#36A2EB" ]'
        grid="true"
        grid-text-weight="bold"
      >
      </line-chart>
    </div>
  </div>
</template>

<script>
import Raphael from "raphael/raphael";
global.Raphael = Raphael;
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


export default {
  data() {
    return {
      info: [],
      lineData: [] /*[
            { year: '2013', a: 10, b: 5 },
            { year: '2014', a: 40, b: 15 },
            { year: '2015', a: 20, b: 25 },
            { year: '2016', a: 30, b: 20 },
          ],*/,
      name: "Test",
    };
  },
  components: {
    DonutChart,
    BarChart,
    LineChart,
    AreaChart,
  },
  mounted() {
      const static_userid = 1;
    setInterval(() => {
      axios
        .get(
          "http://localhost:4000/api/workingtimes/"+static_userid+"?start=" +
            monday /*2019-10-21 08:52:16*/ +
            "&end=" +
            friday /*2021-10-21 20:52:16*/
        )
        .then((response) => {
          this.info = response;
        });

      axios.get("http://localhost:4000/api/users/all").then((response) => {
        this.info_all = response;
      });

      let mondayBool = false;
      let tuesdayBool = false;
      let wednesdayBool = false;
      let thursdayBool = false;
      let fridayBool = false;

      var arr = new Array();
      var obj;
      var obj_all_users;
      var obj_all_usersWrktme = [];
      if (this.info && this.info_all) {
        for (var key in this.info.data) {
          obj = this.info["data"][key];
        }
        for (var key in this.info_all.data) {
          obj_all_users = this.info_all["data"][key];
            for (var inkey in obj_all_users) {
                // console.log(obj_all_users[inkey].id);
                axios.get("http://localhost:4000/api/workingtimes/"+obj_all_users[inkey].id+"?start="+monday+"&end="+friday).then((response) => {
                  this.info_all_worktimz = response;
                });
                if (this.info_all_worktimz)
                for (var key_all_wtz in this.info_all_worktimz.data) {
                  var obj_all_wrtz = this.info_all_worktimz.data[key_all_wtz];
                  // for (var objallwrtz_key in obj_all_wrtz.data) {
                  //   obj_all_usersWrktme = obj_all_wrtz.data[objallwrtz_key];
                  // }
                }
            }
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

        if (obj_all_wrtz) {
        // console.log(obj_all_usersWrktme);
        for (var inkey_all_wrtz in obj_all_wrtz) {
          obj_all_wrtz.sort(function (a, b) {
            var keyA = new Date(a.start);
            var keyB = new Date(b.start);
            // Compare the 2 dates
            if (keyA < keyB) return -1;
            if (keyA > keyB) return 1;
            return 0;
        });
      }
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
          if (
            new Date(obj[inkey]["end"]).getDay() ===
            new Date(obj[inkey]["start"]).getDay()
          ) {
            let hoursDay = new Date(obj[inkey]["start"]);
            let day = hoursDay.getDay();
            switch (day) {
              case 1:
                if (mondayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Monday") {
                      arr[0]["hours"] += diffTime;
                      // console.log(diffTime);
                    }
                  }
                } else {
                  arr[0]["day"] = "Monday";
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
                  arr[1]["day"] = "Tuesday";
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
                } else {
                  arr[2]["hours"] = diffTime;
                  arr[2]["day"] = "Wednesday";
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
                  arr[3]["day"] = "Thursday";
                  arr[3]["hours"] = diffTime;
                  alert(i);
                  arr[3]["total"] = 24;
                }
                thursdayBool = true;
                break;
              case 5:
                if (fridayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Friday") {
                    }
                  }
                } else {
                  arr[4]["hours"] = diffTime;
                  arr[4]["day"] = "Friday";
                }
                arr[4]["total"] = 24;
                fridayBool = true;
                break;
              default:
                break;
            }
          }
          i++;
        }

        // Gestion des heures "moyenne" par rapport a tous les "users"
        for (var inkey in obj_all_wrtz) {
          // console.log(obj[inkey]['start']);
          // console.log(obj[inkey]['end']);
          // console.log(obj[inkey]['start']);
          const tmp = Math.abs(
            Date.parse(obj_all_wrtz[inkey]["end"]) - Date.parse(obj_all_wrtz[inkey]["start"])
          );
          const diffTime = tmp / (1000 * 60 * 60); //millisec to heure
              console.log(new Date(obj_all_wrtz[inkey]["end"]).getDay() + "cal 1");
              console.log(new Date(obj_all_wrtz[inkey]["start"]).getDay() + "call 2");
          if (
            new Date(obj_all_wrtz[inkey]["end"]).getDay() ===
            new Date(obj_all_wrtz[inkey]["start"]).getDay()
          ) {
            let hoursDay = new Date(obj_all_wrtz[inkey]["start"]);
            let day = hoursDay.getDay();
            switch (day) {
              case 1:
                if (mondayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Monday") {
                      arr[0]["hours"] += diffTime;
                      // console.log(diffTime);
                    }
                  }
                } else {
                  arr[0]["day"] = "Monday";
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
                  arr[1]["day"] = "Tuesday";
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
                } else {
                  arr[2]["hours"] = diffTime;
                  arr[2]["day"] = "Wednesday";
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
                  arr[3]["day"] = "Thursday";
                  arr[3]["hours"] = diffTime;
                  // alert(i);
                  arr[3]["total"] = 24;
                }
                thursdayBool = true;
                break;
              case 5:
                if (fridayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].Day === "Friday") {
                    }
                  }
                } else {
                  arr[4]["hours"] = diffTime;
                  arr[4]["day"] = "Friday";
                }
                arr[4]["total"] = 24;
                fridayBool = true;
                break;
              default:
                break;
            }
          }
          i++;
        }
      }
      if (mondayBool === false) {
        arr[0] = new Array();
        arr[0]["day"] = "Monday";
        arr[0]["hours"] = 0;
        arr[0]["total"] = 24;
        arr[0]["a"] = 0;
        arr[0]["b"] = 0;
      }
      if (tuesdayBool === false) {
        arr[1] = new Array();
        arr[1]["day"] = "Tuesday";
        arr[1]["hours"] = 0;
        arr[1]["total"] = 24;
        arr[1]["a"] = 0;
        arr[1]["b"] = 0;
      }
      if (wednesdayBool === false) {
        arr[2] = new Array();
        arr[2]["day"] = "Wednesday";
        arr[2]["hours"] = 0;
        arr[2]["total"] = 24;
        arr[2]["a"] = 0;
        arr[2]["b"] = 0;
      }
      if (thursdayBool === false) {
        arr[3] = new Array();
        arr[3]["day"] = "Thursday";
        arr[3]["hours"] = 0;
        arr[3]["total"] = 24;
        arr[3]["a"] = 0;
        arr[3]["b"] = 0;
      }
      if (fridayBool === false) {
        arr[4] = new Array();
        arr[4]["day"] = "Friday";
        arr[4]["hours"] = 0;
        arr[4]["total"] = 24;
        arr[4]["a"] = 0;
        arr[4]["b"] = 0;
      }
      // console.log(arr);

      this.lineData = [
        { day: "Monday", a: this.rand(100), b: this.rand(100) },
        { day: "Tuesday", a: this.rand(100), b: this.rand(100) },
        { day: "Wednesday", a: this.rand(100), b: this.rand(100) },
        { day: "Thursday", a: this.rand(100), b: this.rand(100) },
        { day: "Friday", a: this.rand(100), b: this.rand(100) },
      ];
      this.lineData[0] = arr[0];
      this.lineData[1] = arr[1];
      this.lineData[2] = arr[2];
      this.lineData[3] = arr[3];
      this.lineData[4] = arr[4];
    }, 1000);
  },
  methods: {
    rand(limit) {
      return Math.round(Math.random() * limit);
    },
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
};
</script>

<style>
</style>