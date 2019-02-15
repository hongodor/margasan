<template>
  <div id="app">
    <div class="header">
      <h4><a v-bind:href="'/projects/' + chapter.project_id">{{ chapter.name }}</a></h4>
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
    <div class="container" id="tabs">
      <table class="table">
        <thead>
          <tr>
            <th>Event id</th>
            <th>Original</th>
            <th>Translated</th>
          </tr>
        </thead>
        <tbody>
        <tr v-for='(phrase, index) in phrases'>
          <td>{{ phrase.event_id}}</td>
          <td class="o">
            <div class="text">
               {{ phrase.original }}
            </div>
          </td>
          <td class="t">
            <div v-if="phrase.translated !== ''" class="chosen">
                {{ phrase.translated }}
            </div>
            <template v-for='(option, index2) in phrase.options'>
              <div v-bind:class = "(option.user_id === current_user.id)?'self':''">
                <p class="text">
                  {{ option.content }}
                </p>
                <span class="info">
                  <a v-if="chapter.user_id === current_user.id || current_user.role === 'admin'" @click="pickTranslated(option.id, phrase.id)" class="pick">Pick</a>
                  <a v-if="chapter.user_id === current_user.id || option.user_id === current_user.id || current_user.role === 'admin'" @click="deleteOption(option.id, index, index2)" class="delete">Delete</a>
                  <a v-bind:href="'/users/'+option.user_id" class="user">{{ option.author }}</a>
                  {{ format(option.updated_at) }}
                </span>
              </div>
            </template>
            <div class="form">
              <input v-model="phrase.option" class="form-input">
              <a class="form-send" @click="sendOption(phrase.id, index)">Send</a>
            </div>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>

</template>

<style scoped src="./phrases.css" lang="scss">
</style>

<script>
import axios from 'axios'
import cable from 'actioncable'
import modal from '../modal.vue'

let consumer;

if (!consumer) {
    consumer = cable.createConsumer();
}

export default {
    name: 'phrase',
    props: ['chapter', 'current_user'],
    components: {
        modal
    },

    data: function () {
      return {
          activetab: 1,
          phrases: this.chapter.phrases,
              //.sort(function(obj1, obj2) { return obj1.id - obj2.id;}),
          showModal: false,
          notice: {}
      }
    },
    created() {
        let that = this;
        consumer.subscriptions.create({ channel: "ChaptersChannel",  chapter_id: this.chapter.id }, {
            received ({option}) {
                let obj = JSON.parse(option);
                that.addOption(obj)
            },
        });
        this.chapter.phrases.forEach(function(element) {
            element.option = element.original;
        })
    },
    methods: {
        // response from actioncable
        format(input) { return new Date(input).toLocaleDateString('en-GB', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            hour12: false
          });
        },
        addOption(obj) {
            let opts = this.chapter.phrases.find(x => x.id === obj.phrase_id).options.filter(function (item) {
                return item.user_id === obj.user_id
            }).length;
            // check if option already exist
            if (opts === 0) {
                console.log('option not exist');
                this.chapter.phrases.find(x => x.id === obj.phrase_id).options.push(obj);
            } else {
                console.log('option already exist');
                // replace option
                this.chapter.phrases.find(x => x.id === obj.phrase_id).options.find(x => x.user_id === obj.user_id).content = obj.content
            }
        },
        sendOption(phraseId, index) {
            let thisUser = this.current_user.id;
            let opts = this.chapter.phrases[index].options.filter(function (item) {
                return item.user_id === thisUser
            });
            // check if option already exist
            // then options contain option from current user call editOption
            // else create new option
            if (opts.length > 0) {
                let option = this.chapter.phrases[index].options.find(x => x.user_id === thisUser)
                this.editOption(option.id, index)
            } else {
                axios.post('/options', {
                    content: this.chapter.phrases[index].option, phrase_id: phraseId
                });
                this.chapter.phrases[index].option = ''
            }

        },
        deleteOption(optionId, index, index2) {
            axios.delete('/options/'+optionId, {
            }).then((res) => {
                this.chapter.phrases[index].options.splice(index2, 1)
            }).catch((error) => {
                console.log(error);
                this.message(error.response.status, error.response.statusText)
            });
        },
        pickTranslated(id, phraseId) {
            axios.put('/phrases/'+phraseId, {
                phrase: { option_id: id }
            }).then((res) => {
                this.chapter.phrases.find(x => x.id === phraseId).translated = res.data.content
            }).catch((error) => {
                console.log(error);
                this.message(error.response.status, error.response.statusText)
            })
        },
        editOption(optionId, index) {
            axios.put('/options/'+optionId, {
                content: this.chapter.phrases[index].option
            }).then((res) => {
                //
            }).catch((error) => {
                console.log(error);
                this.message(error.response.status, error.response.statusText)
            });
        },
        message(type, text) {
          if(type === 403) {
              this.notice.body = "You are not authorized to perform this action.";
              this.notice.code = type;
              this.showModal = true;
              console.log(type, text)
          }
        }
    }
}

</script>
