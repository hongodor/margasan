<template>
  <div id="app">
    <center><h1>Phrases</h1></center>
    <table class="table">
      <thead>
      <tr>
        <th>id</th>
        <th>Original</th>
        <th>Translated</th>
        <th>created at</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for='(phrase, index) in phrases'>
        <td>{{ index + 1 }}</td>
        <td>{{ phrase.original }}</td>
        <td>{{ phrase.translated }}</td>
        <td>{{ phrase.created_at }}</td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script>

const appUrl = window.location;
export default {
    name: 'phrase',

    data: function () {
      return {
          phrases: [],
          phrase: ''
      }
    },
    created() {
        this.fetchPhrase();
    },
    methods: {
        fetchPhrase() {
            fetch(appUrl + '.json')
                .then((res) => { return res.json() })
                .then((res) => { this.phrases = res })
        }
    }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
