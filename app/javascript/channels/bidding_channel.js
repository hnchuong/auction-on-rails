import consumer from "channels/consumer"

biddingChannel = consumer.subscriptions.create("BiddingChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected to BiddingChannel")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("disconnected")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
  }
});

windows.biddingChannel = biddingChannel;