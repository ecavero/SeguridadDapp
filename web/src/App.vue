<template>
  <div id="app">
    <div v-if="autorizado">
      <h4>Bienvenido</h4>
    </div>
    <div v-if="!autorizado">
      <h4>Usuario no autorizado</h4>
      <button @click="inscribir()">Inscribirse</button>
    </div>
  </div>

</template>

<script>
import Web3 from 'web3'
import Prueba from '../../build/contracts/Prueba.json'
export default {
  name: 'app',
  data () {
    return {
      cuenta: '',
      contrato: null,
      autorizado: false
    }
  },
  mounted: async function()  {
    await this.cargarWeb3()
    await this.cargarCuentas()
  },
  methods: {
    async cargarWeb3() {
      if (window.ethereum) {
        window.web3 = new Web3(window.ethereum)
        await window.ethereum.enable()
      } else if (window.web3){
        window.web3 = new Web3(window.web3.currentProvider())
      } else {
        alert('No hay metamask');
      }
    },
    async cargarCuentas() {
      const web3 = window.web3
      const cuentas = await web3.eth.getAccounts()
      this.cuenta = cuentas[0]
      let idRed = await web3.eth.net.getId()
      let red = Prueba.networks[idRed]
      if (red) {
        this.contrato = new web3.eth.Contract(Prueba.abi, red.address)
        this.autorizado = await this.contrato.methods.autorizado().call({from: this.cuenta})
      }
    },
    async inscribir() {
      this.contrato.methods.agregarCuenta().send({from: this.cuenta}).once('receipt', (receipt) => {
        this.autorizado = true
      })
      
    },
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
}

h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
