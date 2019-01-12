
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


    table {
      max-width: 100%;
      background-color: transparent;
    }
    .table {
      margin: 5px 0;
      border-collapse: collapse;
      border-spacing: 0;
      border: 1px solid #616161;
      tbody td {
        border: 1px solid #616161;
        vertical-align: top;
        padding: 0;
        .chosen {
          background: darken(#e5eaff, 5%);
          p {
            margin: 0 10px;
            line-height: 0.9em;
            word-wrap: break-word;
          }
        }
      }
      .text {
        margin: 5px 10px;
        line-height: 0.9em;
        word-wrap: break-word;
      }
      td.o {
        width: 40%;
        max-width: 500px;
      }
      td.t {
        div {
          border-bottom: 1px solid  #7f7f7f;
          position: relative;
          padding-bottom: 7px;
        }
        width: 60%;
        .info {
          font-size: 17px;
          margin: 10px;
          a.pick {
            background-color: #82d56a;
            border-radius: 3px;
            text-decoration: none;
          }
          a.delete {
            background-color: #ff7e76;
            border-radius: 3px;
            text-decoration: none;
          }
          a:hover {
            cursor: pointer;
            text-decoration: underline;
          }
        }
        div.form {
          margin: 5px 10px;
        }
      }
      td.t > div:last-child {border-bottom:none;}
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
          <td class="o">
            <div>
              <p  class="text">
                <template v-for="line in phrase.original.split('\n')">
                {{ line }} <br>
                </template>
              </p>
            </div>
          </td>
          <td class="t">
            <div v-if="phrase.translated !== ''" class="chosen">
              <p>
                <template v-for="line in phrase.translated.split('\n')">
                  {{ line }} <br>
                </template>
              </p>
            </div>
            <template v-for='(option, index2) in phrase.options'>
              <div>
                <p class="text">
                  <template v-for="line in option.content.split('\n')" >
                    {{ line }} <br>
                  </template>
                </p>
                <span class="info">
                  <a v-if="chapter.user_id === current_user.id || current_user.role === 'admin'" @click="pickTranslated(option.id, phrase.id)" class="pick">Pick</a>
                  <a v-if="chapter.user_id === current_user.id || option.user_id === current_user.id || current_user.role === 'admin'" @click="deleteOption(option.id, index, index2)" class="delete">Delete</a>
                  <a v-bind:href="'/users/'+option.user_id" class="user">{{ option.author }}</a>
                  {{ option.created_at}}
                </span>
              </div>
            </template>
            <div class="form">
              <textarea v-model="phrase.option"></textarea>
              <a @click="sendOption(phrase.id, index)">Send</a>
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
        // response from actioncable
        addOption(obj) {
            let opts = this.phrases.find(x => x.id === obj.phrase_id).options.filter(function (item) {
                return item.user_id === obj.user_id
            }).length
            // check if option already exist
            if (opts === 0) {
                console.log('option not exist')
                this.phrases.find(x => x.id === obj.phrase_id).options.push(obj);
            } else {
                console.log('option already exist')
                // replace option
                this.phrases.find(x => x.id === obj.phrase_id).options.find(x => x.user_id === obj.user_id).content = obj.content
            }
        },
        sendOption(phraseId, index) {
            let thisUser = this.current_user.id
            let opts = this.phrases[index].options.filter(function (item) {
                return item.user_id === thisUser
            })
            // check if option already exist
            // then options contain option from current user call editOption
            // else create new option
            if (opts.length > 0) {
                let option = this.phrases[index].options.find(x => x.user_id === thisUser)
                this.editOption(option.id, index)
            } else {
                axios.post('/options', {
                    content: this.phrases[index].option, phrase_id: phraseId
                });
                this.phrases[index].option = ''
            }

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
        editOption(optionId, index) {
            axios.put('/options/'+optionId, {
                content: this.phrases[index].option
            }).then((res) => {
                //
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
