<template>
<table class="table">
  <thead>
    <tr>
      <th scope="col">Debut</th>
      <th scope="col">Fin</th>
      <th scope="col">Nombre Heures</th>
      <th scope="col">Edit</th>
      <th scope="col">Delete</th>
    </tr>
  </thead>
  <tbody>
    <template v-for="wrktime in result">
    <tr>
        <td>{{wrktime.start}}</td>
        <td>{{wrktime.end}}</td>
        <td>{{wrktime.workduration}}</td>
        <td><button type="button" class="btn btn-secondary">Edit</button></td>
        <td><button type="button" class="btn btn-warning">Delete</button></td>
    </tr>
    </template>
  </tbody>
</table>
</template>

<script>
export default {
  data () {
    return {
      workingtimes: [{
          start: "2020-10-20 08:00:00",
          end: "2020-10-20 17:00:00",
        },
        {
        start: "2020-10-21 08:00:00",
        end: "2020-10-21 15:00:00",
      }],
      name: "Accueil"
    }
  },
  computed: {
    result: function() {
      return this.workingtimes.map((b) => {
        // tmp = Date.parse(b.end) - Date.parse(b.start)
        const tmp =  Math.abs(Date.parse(b.end) - Date.parse(b.start));
        const diffTime = (tmp / (1000 * 60 * 60)); //millisec to heure
        b.workduration = diffTime // traduit la valeur
        return b
      });
    }
  }
  //   mounted () {
  //   axios
  //     .get('https://api.coindesk.com/v1/bpi/currentprice.json')
  //     .then(response => (this.info = response))
  // }
}
</script>

<style scoped>
/* body {
  font-family: Helvetica Neue, Arial, sans-serif;
  font-size: 14px;
  color: #444;
}

table {
  border: 2px solid #42b983;
  border-radius: 3px;
  background-color: #fff;
}

th {
  background-color: #42b983;
  color: rgba(255, 255, 255, 0.66);
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

td {
  background-color: #f9f9f9;
}

th,
td {
  min-width: 120px;
  padding: 10px 20px;
}

th.active {
  color: #fff;
}

th.active .arrow {
  opacity: 1;
}

.arrow {
  display: inline-block;
  vertical-align: middle;
  width: 0;
  height: 0;
  margin-left: 5px;
  opacity: 0.66;
}

.arrow.asc {
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-bottom: 4px solid #fff;
}

.arrow.dsc {
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-top: 4px solid #fff;
} */
</style>
