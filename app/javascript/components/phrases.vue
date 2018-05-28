
<style lang="scss" scoped>
  .header {
    font-size: 1.5em;
    text-align: center;
    letter-spacing: -1px;
    font-weight: normal;
  }
  .container {
    text-align: left;
    overflow: hidden;
    margin: 0 auto;
    .table {
      margin: 10px;
      vertical-align: top;
      border-collapse: collapse;
      border: 1px solid;
      thead th {
        padding: 10px;
        text-transform: uppercase;
      }
      td {
        border: 1px solid;
        vertical-align: text-top;
        padding: 0px 10px;
        .translated {
          .option {
            border-bottom: 1px solid #8b8b8b;
            position: relative;
            .information {

            }
          }
        }
        .content {
          padding:6px 8px 0;
          margin:0;
          line-height:130%;
          word-wrap: break-word;
        }
      }
    }
  }
</style>



<template>
  <div id="app">
    <div class="header">
      <h4>{{ chapter.name }}</h4>
      <span>{{ chapter.status }}</span>
    </div>
    <div id="modal">
      <div id="show-modal" @click="showModal = true"></div>
      <!-- use the modal component, pass in the prop -->
      <modal v-if="showModal" @close="showModal = false">
        <!--
          you can use custom content here to overwrite
          default content
        -->
        <h3 slot="header">{{ notice.code }}</h3>
        <div slot="body">{{ notice.body }}</div>
      </modal>
    </div>
    <div class="container">
      <table class="table">
        <thead>
          <tr>
            <th>Original</th>
            <th>Translated</th>
          </tr>
        </thead>
        <tbody>
        <tr v-for='(phrase, index) in phrases'>
          <td>
            <div class="origin">
              <p>
                {{ phrase.original }}
              </p>
            </div>
          </td>
          <td>
            <div class="translated">
              <div class="option">
                <div v-for="line in  phrase.translated .split('\n')" class="content">
                  {{ line }} <br>
                </div>
              </div>
              <div v-for='(option, index2) in phrase.options'>
                <div class="option">
                  <div v-for="line in option.content.split('\n')" class="content">
                    {{ line }} <br>
                  </div>
                  <div class="information">
                    <template v-if="chapter.user_id === current_user.id">
                      <a @click="pickTranslated(option.id, phrase.id)">Pick</a>
                    </template>
                    <template v-if="chapter.user_id === current_user.id || option.user_id === current_user.id">
                      <a @click="editOption(option.id, index, index2)">Edit</a>
                      <a @click="deleteOption(option.id, index, index2)">Delete</a>
                    </template>
                    <a v-bind:href="'/users/'+option.user_id">{{ option.author }}</a>
                  </div>
                </div>
              </div>
              <div class="form">
                <textarea v-model="phrase.option"></textarea>
                <button @click="sendOption(phrase.id, index)">Send</button>
              </div>
            </div>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import cable from 'actioncable'
import modal from './modal.vue'

let consumer;

if (!consumer) {
    consumer = cable.createConsumer();
}

export default {
    name: 'phrase',
    props: ['chapter','current_user'],

    components: {
        modal
    },

    data: function () {
      return {
          showModal: false,
          phrases: [],
          notice: {}
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
            let opts = this.phrases.find(x => x.id === obj.phrase_id).options.filter(function (item) {
                return item.user_id === obj.user_id
            }).length
            // check if option already exist
            if (opts === 0) {
                this.phrases.find(x => x.id === obj.phrase_id).options.push(obj);
            } else {
                this.phrases.find(x => x.id === obj.phrase_id).options.find(x => x.user_id === obj.user_id).content = obj.content
            }
        },
        sendOption(phraseId, index) {
            
            axios.post('/options', {
                content: this.phrases[index].option, phrase_id: phraseId
            });
            this.phrases[index].option = ''
        },
        deleteOption(optionId, index, index2) {
            axios.delete('/options/'+optionId, {
            }).then((res) => {
                this.phrases[index].options.splice(index2, 1)
            }).catch((error) => {
                console.log(error)
                this.message(error.response.status, error.response.statusText)
            });
        },
        pickTranslated(id, phraseId) {
            axios.post('/phrases', {
                phrase_id: phraseId, option_id: id
            }).then((res) => {
                this.phrases.find(x => x.id === phraseId).translated = res.data.content
            }).catch((error) => {
                console.log(error)
                this.message(error.response.status, error.response.statusText)
            })
        },
        editOption(optionId, index, index2) {
            console.log(optionId, index, index2)
            axios.put('/options/'+optionId, {
                content: this.phrases[index].option
            }).then((res) => {

            }).catch((error) => {
                console.log(error)
                this.message(error.response.status, error.response.statusText)
            });
        },
        message(type, text) {
          if(type === 403) {
              this.notice.body = "You are not authorized to perform this action."
              this.notice.code = type
              this.showModal = true
              console.log(type, text)
          }
        }
    }
}

</script>
