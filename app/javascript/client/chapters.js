import createChannel from "client/cable";

let callback;

const chapters = createChannel("ChaptersChannel", {
    received(option) {
        console.log(option);
        if (callback) callback.call(null, option);
    }
});

// Sending a message: "perform" method calls a respective Ruby method
// defined in chapters_channel.rb. This is bridge between JS and Ruby!

function sendChapter(option) {
    chapters.perform("send_chapter", option);
}

function setCallback(fn) {
    callback = fn;
}

export { sendChapter, setCallback };