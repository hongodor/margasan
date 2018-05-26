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
          <button @click="sendOption(phrase.id, index)">Send</button>
          <ul v-for='(option, idx) in phrase.options'>
            <li>{{option.id}}</li>
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
import cable from "actioncable";

let consumer;

if (!consumer) {
    consumer = cable.createConsumer();
}

export default {
    name: 'phrase',
    props: ['chapter'],
    data: function () {
      return {
          phrases: []
      }
    },
    created() {
        let that = this;
        this.fetchPhrase();
        consumer.subscriptions.create({ channel: "ChaptersChannel",  chapter_id: this.chapter.id }, {
            received ({option}) {
                let obj = JSON.parse(option);
                that.addOption(obj)
            },
        });
    },
    methods: {
        fetchPhrase() {
            fetch('/chapters/'+ this.chapter.id + '.json')
                .then((res) => { return res.json() })
                .then((res) => { this.phrases = res })
        },
        addOption(obj) {
            this.phrases.find(x => x.id === obj.phrase_id).options.push(obj);
        },
        sendOption(phraseId, index) {
            axios.post('/options', {
                content: this.phrases[index].option, phrase_id: phraseId
            });
            this.phrases[index].option = ''
        },
        pickTranslated(id, phraseId) {
            axios.post('/phrases', {
                phrase_id: phraseId, option_id: id
            }).then((res) => {
                this.phrases.find(x => x.id === phraseId).translated = res.data.content
            }).catch((error) => {
                this.errors = error.response.statusText;
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
