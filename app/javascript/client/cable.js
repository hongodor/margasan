import cable from "actioncable";

let consumer;

function createChannel(name, ...args) {
    if (!consumer) {
        consumer = cable.createConsumer();
    }
    console.log({ channel: name,  chapter_id: 2}, ...args);
    return consumer.subscriptions.create({ channel: name,  chapter_id: 2}, ...args);
}

export default createChannel;