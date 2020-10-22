<template>
  <div id="app">
    <User 
      v-if="user.id === 0"
      id="user-profile"
      :user=user
      :changeUser="changeUser"
    />
    <router-view/>
  </div>
</template>

<script>
import User from '@/components/User';

export default {
  name: 'App',
  components: { User },
  data() {
    return {
      user: {
        email: '',
        username: '',
        id: 0
      }
    }
  },
  methods: {
    changeUser(user) {
      this.user = user;
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
  padding: 2% 10%;
}
#user-profile {
  width: 50%;
  margin: 2% auto;
}
</style>
