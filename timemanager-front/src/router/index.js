import Vue from 'vue'
import Router from 'vue-router'
import Accueil from '@/components/Accueil'
import axios from 'axios'

Vue.use(Router, axios)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Accueil',
      component: Accueil
    }
  ]
})
