<template>
  <div id="app">
    <center><h1>{{ chapter.name }}</h1></center>
    <center><h1>{{ chapter.status }}</h1></center>
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
        <td>{{ index + 1 }}/{{ phrase.id }}</td>
        <td>{{ phrase.original }}</td>
        <td>{{ phrase.translated }}
          <input  v-model="phrase.option">
          <button @click="addOption(phrase.id, index)">Send</button>
          <ul v-for='(option, idx) in phrase.options'>
            <li>{{option.content}} <button @click="pickTranslated(option.id, phrase.id)">Pick</button></li>
          </ul>
        </td>
        <td>{{ phrase.createdAt }}</td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios'

export default {
    name: 'phrase',
    props: ['chapter'],
    data: function () {
      return {
          phrases: []
      }
    },
    created() {
        this.fetchPhrase();
    },
    methods: {
        fetchPhrase() {
            fetch('/chapters/'+ this.chapter.id + '.json')
                .then((res) => { return res.json() })
                .then((res) => { this.phrases = res })
        },
        addOption(phraseId, index) {
            console.log(this.phrases[index].option)
            axios.post('/options', {
                content: this.phrases[index].option, phrase_id: phraseId
            }).then((res) => {
                this.phrases[index].options.push(res.data)
                this.phrases[index].option = ''
            }).catch((error) => {
                this.errors = error.response.statusText
                console.log(this.errors)
            })
        },
        pickTranslated(id, phraseId) {
            axios.post('/phrases', {
                phrase_id: phraseId, option_id: id
            }).then((res) => {
                this.phrases.find(x => x.id === phraseId).translated = res.data.content
            }).catch((error) => {
                this.errors = error.response.statusText
                console.log(this.errors)
            })
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
