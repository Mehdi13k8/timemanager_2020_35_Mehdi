// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'

import './../node_modules/jquery/dist/jquery.min.js';
import './../node_modules/bootstrap/dist/css/bootstrap.min.css';
import './../node_modules/bootstrap/dist/js/bootstrap.min.js';
// Import for Css & Js
import Raphael from 'raphael/raphael'
global.Raphael = Raphael

Vue.prototype.$hostname = 'http://localhost:4000/api/v1/' // Url de L'api Chez moi avec Docker !!!

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
  beforeCreate: function () {
  }

})
