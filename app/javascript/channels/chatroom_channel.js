// import consumer from "channels/consumer"

import consumer from "./consumer";

consumer.subscriptions.create("ChatroomChannel", {
  connected() {
    console.log("Connected to ChatroomChannel");
  },
  received(data) {
    const chatBox = document.querySelector("#chat-box");
    chatBox.insertAdjacentHTML(
        "beforeend",
        `<p><strong>${data.username}:</strong> ${data.content}</p>`
    );
  },
  speak(message) {
    return this.perform("speak", message);
  },
});

