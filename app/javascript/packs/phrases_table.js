/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.
import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue'
import App from '../components/phrases_list/phrases.vue'
import axios from 'axios'

Vue.use(TurbolinksAdapter);

Vue.component('modal', {
    template: '#modal-template'
});

document.addEventListener('DOMContentLoaded', () => {
  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const el = document.body.appendChild(document.createElement('app'));
  const element = document.getElementById("chapter-id");
  const props = JSON.parse(element.getAttribute('data'));
  const app = new Vue({
    el,
    mixin: [TurbolinksAdapter],
    render: h => h(App,{ props } )
  })
});


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the using turbolinks, install 'vue-turbolinks':
//
// yarn add 'vue-turbolinks'
//
// Then uncomment the code block below:
//

// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
//
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
