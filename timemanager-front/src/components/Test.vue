<template>
  <div class="container">
    Test
    <h3>Line Chart <small>(with values modified every 10 seconds)</small></h3>
    <div v-if="lineData.length != 0">
        <!-- label-colors='[ "#FF6384", "#36A2EB" ]' -->
      <line-chart
        id="line"
        :data="lineData"
        xkey="day"
        ykeys='[ "a", "b" ]'
        parseTime="false"
        resize="true"
        labels='[ "Ta journee", "Journee moyenne des employees" ]'
        line-colors='[ "#FF6384", "#36A2EB" ]'
        grid="true"
        grid-text-weight="bold"
        ymax="24"
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
  beforeCreate: function () {
    this.ApiUrl = this.$hostname;
  },
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
  async mounted() {
    var userId = "";
    var jwt = "";
    var data = JSON.stringify({ email: "foo@bar.com", password: "Xdveg567" });
    var config = {
      method: "post",
      url: this.ApiUrl + "users/sign_in",
      headers: {
        "Content-Type": "application/json",
      },
      data: data,
    };
    try {
      let tmp = await axios(config);
      jwt = tmp.data.jwt;
    } catch (err) {}

    var config = {
      method: "get",
      url: this.ApiUrl + "users/my_user",
      headers: {
        Authorization: "Bearer " + jwt,
      },
    };

    try {
      let userData = await axios(config);
      userId = userData.data.id;
      console.log(userId.id);
    } catch (err) {}

    setInterval(async () => {
      let mondayBool = false;
      let tuesdayBool = false;
      let wednesdayBool = false;
      let thursdayBool = false;
      let fridayBool = false;
      var arr = new Array();
      arr[0] = new Object();
      arr[1] = new Object();
      arr[2] = new Object();
      arr[3] = new Object();
      arr[4] = new Object();
      axios
        .get(
          this.ApiUrl +
            "workingtimes/" +
            userId +
            "?start=" +
            monday /*2019-10-21 08:52:16*/ +
            "&end=" +
            friday /*2021-10-21 20:52:16*/,
          {
            headers: {
              Authorization: "Bearer " + jwt,
            },
          }
        )
        .then((response) => {
          this.info = response;
        });

      try {
        let tmpInf = await axios.get(this.ApiUrl + "users/all", {
          headers: {
            Authorization: "Bearer " + jwt,
          },
        });
        this.info_all = tmpInf;
        // .then((response) => {
        //         this.info_all = await response;
        //       });
      } catch (err) {}

      var obj;
      var obj_all_users;
      var obj_all_usersWrktme = [];
      let MondayallHours = 0;
      let MondayUserNb = 0;
      let TuesdayallHours = 0;
      let TuesdayUserNb = 0;
      let WednesdayallHours = 0;
      let WednesdayUserNb = 0;
      let ThursdayallHours = 0;
      let ThursdayUserNb = 0;
      let FridayallHours = 0;
      let FridayUserNb = 0;
      if (this.info && this.info_all) {
        for (var key in this.info.data) {
          obj = this.info["data"][key];
        }
        for (var key in this.info_all.data) {
          obj_all_users = this.info_all["data"][key];
          for (var inkey in obj_all_users) {
            // console.log(obj_all_users[inkey].id);
            axios
              .get(
                this.ApiUrl +
                  "workingtimes/" +
                  obj_all_users[inkey].id +
                  "?start=" +
                  monday +
                  "&end=" +
                  friday,
                {
                  headers: {
                    Authorization: "Bearer " + jwt,
                  },
                }
              )
              .then((response) => {
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
                    if (arr[idx].day === "Monday") {
                      arr[0]["hours"] += diffTime;
                      arr[0]["a"] = arr[0]["hours"];
                    }
                  }
                } else {
                  arr[0]["b"] = 0;
                  arr[0]["day"] = "Monday";
                  arr[0]["hours"] = diffTime;
                  arr[0]["total"] = 24;
                  arr[0]["a"] = arr[0]["hours"];
                  mondayBool = true;
                }
                break;
              case 2:
                if (tuesdayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].day === "Tuesday") {
                      arr[1]["hours"] += diffTime;
                      arr[1]["a"] = arr[1]["hours"];
                    }
                  }
                } else {
                  arr[1]["b"] = 0;
                  arr[1]["day"] = "Tuesday";
                  arr[1]["hours"] = diffTime;
                  arr[1]["total"] = 24;
                  arr[1]["a"] = arr[1]["hours"];
                  tuesdayBool = true;
                }
                break;
              case 3:
                if (wednesdayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].day === "Wednesday") {
                      arr[2]["hours"] += diffTime;
                      arr[2]["a"] = arr[2]["hours"];
                    }
                  }
                } else {
                  arr[2]["b"] = 0;
                  arr[2]["day"] = "Wednesday";
                  arr[2]["hours"] = diffTime;
                  arr[2]["total"] = 24;
                  arr[2]["a"] = arr[2]["hours"];
                  wednesdayBool = true;
                }
                break;
              case 4:
                if (thursdayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].day === "Thursday") {
                      arr[3]["hours"] += diffTime;
                      arr[3]["a"] = arr[3]["hours"];
                    }
                  }
                } else {
                  arr[3]["b"] = 0;
                  arr[3]["day"] = "Thursday";
                  arr[3]["hours"] = diffTime;
                  arr[3]["total"] = 24;
                  arr[3]["a"] = arr[3]["hours"];
                  thursdayBool = true;
                }
                break;
              case 5:
                if (fridayBool === true) {
                  for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].day === "Friday") {
                      arr[4]["hours"] += diffTime;
                      arr[4]["a"] = arr[4]["hours"];
                    }
                  }
                } else {
                  arr[4]["b"] = 0;
                  arr[4]["day"] = "Thursday";
                  arr[4]["hours"] = diffTime;
                  arr[4]["total"] = 24;
                  arr[4]["a"] = arr[4]["hours"];
                  fridayBool = true;
                }
                break;
              default:
                break;
            }
          }
          // i++;
        }

        // Gestion des heures "moyenne" par rapport a tous les "users"
        let tmpv2;
        for (var keyUser in this.info_all.data.data) {
          MondayallHours = 0;
          TuesdayallHours = 0;
          WednesdayallHours = 0;
          ThursdayallHours = 0;
          FridayallHours = 0;
          try {
            let tmp = await axios.get(
              this.ApiUrl +
                "workingtimes/" +
                this.info_all.data.data[keyUser].id + // UserId
                "?start=" +
                monday /*2019-10-21 08:52:16*/ +
                "&end=" +
                friday /*2021-10-21 20:52:16*/,
              {
                headers: {
                  Authorization: "Bearer " + jwt,
                },
              }
            );
            tmpv2 = tmp;
          } catch (err) {}
          let UsersWorkTms = tmpv2.data.data;
          let FlagMondayOneUser = false;
          let FlagTuesdayOneUser = false;
          let FlagWednesdayOneUser = false;
          let FlagThursdayOneUser = false;
          let FlagFridayOneUser = false;
        for (var inkey in UsersWorkTms) {
          const tmp = Math.abs(
            Date.parse(UsersWorkTms[inkey]["end"]) -
              Date.parse(UsersWorkTms[inkey]["start"])
          );
          const diffTime = tmp / (1000 * 60 * 60); //millisec to heure
          if (
            new Date(UsersWorkTms[inkey]["end"]).getDay() ===
            new Date(UsersWorkTms[inkey]["start"]).getDay()
          ) {
            let hoursDay = new Date(UsersWorkTms[inkey]["start"]);
            let day = hoursDay.getDay();
            switch (day) {
              case 1:
                MondayallHours += diffTime;
                if (FlagMondayOneUser == false)
                  MondayUserNb++;
                FlagMondayOneUser = true;
                break;
              case 2:
                TuesdayallHours += diffTime;
                TuesdayUserNb++;
                break;
              case 3:
                WednesdayallHours += diffTime;
                if (FlagWednesdayOneUser == false)
                  WednesdayUserNb++;
                FlagWednesdayOneUser = true;
                break;
              case 4:
                ThursdayallHours += diffTime;
                if (FlagThursdayOneUser == false)
                  ThursdayUserNb++;
                FlagThursdayOneUser = true;
                break;
              case 5:
                FridayallHours += diffTime;
                if (FlagFridayOneUser == false)
                  FridayUserNb++;
                FlagFridayOneUser = true;
                break;
              default:
                break;
            }
          }
          // i++;
        }
        // alert(MondayallHours);
        // alert(JSON.stringify(tmpv2));
        if (arr[0]["b"] == undefined)
          arr[0]["b"] = 0;
        if (arr[1]["b"] == undefined)
          arr[1]["b"] = 0;
        if (arr[2]["b"] == undefined)
          arr[2]["b"] = 0;
        if (arr[3]["b"] == undefined)
          arr[3]["b"] = 0;
        if (arr[4]["b"] == undefined)
          arr[4]["b"] = 0;
        if (this.info_all.data.data.length > 1) {
          MondayallHours > 0 ? arr[0]["b"] += MondayallHours: null ;
          TuesdayallHours > 0 ? arr[1]["b"] += TuesdayallHours: null ;
          WednesdayallHours > 0 ? arr[2]["b"] += WednesdayallHours: null ;
          ThursdayallHours > 0 ? arr[3]["b"] += ThursdayallHours: null ;
          FridayallHours > 0 ? arr[4]["b"] += FridayallHours: null ;
          } else {
          MondayallHours > 0 ? arr[0]["b"] = MondayallHours: null ;
          TuesdayallHours > 0 ? arr[1]["b"] = TuesdayallHours: null ;
          WednesdayallHours > 0 ? arr[2]["b"] = WednesdayallHours: null ;
          ThursdayallHours > 0 ? arr[3]["b"] = ThursdayallHours: null ;
          FridayallHours > 0 ? arr[4]["b"] = FridayallHours: null ;
          }
        }
      }
      if (mondayBool === false) {
        arr[0]["day"] = "Monday";
        arr[0]["hours"] = 0;
        arr[0]["total"] = 24;
        arr[0]["a"] = 0;
      if (arr[0]["b"] == undefined)
        arr[0]["b"] = 0;
      }
      if (tuesdayBool === false) {
        arr[1]["day"] = "Tuesday";
        arr[1]["hours"] = 0;
        arr[1]["total"] = 24;
        arr[1]["a"] = 0;
      if (arr[1]["b"] == undefined)
        arr[1]["b"] = 0;
      }
      if (wednesdayBool === false) {
        arr[2]["day"] = "Wednesday";
        arr[2]["hours"] = 0;
        arr[2]["total"] = 24;
        arr[2]["a"] = 0;
        if (arr[2]["b"] == undefined)
          arr[2]["b"] = 0;
      }
      if (thursdayBool === false) {
        arr[3]["day"] = "Thursday";
        arr[3]["hours"] = 0;
        arr[3]["total"] = 24;
        arr[3]["a"] = 0;
        if (arr[3]["b"] == undefined)
          arr[3]["b"] = 0;
      }
      if (fridayBool === false) {
        arr[4]["day"] = "Friday";
        arr[4]["hours"] = 0;
        arr[4]["total"] = 24;
        arr[4]["a"] = 0;
        if (arr[4]["b"] == undefined)
          arr[4]["b"] = 0;
      }
      // Bar Bleu pour la moyenne des gens le lundi
      // MondayallHours > 0 ? arr[0]["b"] += MondayallHours: null;
      // alert(arr[3]["b"]);
        if (arr[0]["b"] > 0)
          arr[0]["b"] /= MondayUserNb;

      // TuesdayallHours > 0 ? arr[1]["b"] += TuesdayallHours: null;
        if (arr[1]["b"] > 0)
          arr[1]["b"] /= TuesdayUserNb;

      // WednesdayallHours > 0 ? arr[2]["b"] += ThursdayallHours: null;
        if (arr[2]["b"] > 0)
          arr[2]["b"] /= WednesdayUserNb;
        // alert(WednesdayUserNb);
      // ThursdayallHours > 0 ? arr[3]["b"] += ThursdayallHours: null;
        if (arr[3]["b"] > 0)
          arr[3]["b"] /= ThursdayUserNb;

      // FridayallHours > 0 ? arr[4]["b"] += FridayallHours: null;
        if (arr[4]["b"] > 0)
          arr[4]["b"] /= FridayUserNb;

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