import Vue from 'vue'
import Router from 'vue-router'
import Accueil from '@/components/Accueil'
import Test from '@/components/Test'
import axios from 'axios'

Vue.use(Router, axios)

export default new Router({
  routes: [
    {
      path: '/test',
      name: 'Test',
      component: Test
    },
    {
      path: '/',
      name: 'Accueil',
      component: Accueil
    }
  ]
})
