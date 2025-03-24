// filepath: app/javascript/auction_list.js
import consumer from "channels/consumer";

document.addEventListener("DOMContentLoaded", () => {
  const auctionDivs = document.querySelectorAll(".auction");
  const activeAuctionsDiv = document.querySelector("#active-auctions");

  auctionDivs.forEach((auctionDiv) => {
    const auctionId = auctionDiv.dataset.auctionId;

    consumer.subscriptions.create(
      { channel: "AuctionChannel", auction_id: auctionId },
      {
        connected() {
          console.log(`Connected to AuctionChannel for auction_id: ${auctionId}`);
        },
        disconnected() {
          console.log(`Disconnected from AuctionChannel for auction_id: ${auctionId}`);
        },
        received(data) {
          console.log(`Received data for auction_id: ${auctionId}`, data);

          fetch("/auctions/" + auctionId, {
            headers: {
              "Accept": "text/vnd.turbo-stream.html"
            }
          })
          .then(response => response.text())
          .then(html => Turbo.renderStreamMessage(html));
        },
      }
    );
  });

  if (activeAuctionsDiv) {
    console.log("Active Auctions Div Found", consumer);
    consumer.subscriptions.create(
      { channel: "ActiveAuctionsChannel" },
      {
        connected() {
          console.log("Connected to ActiveAuctionsChannel");
        },
        disconnected() {
          console.log("Disconnected from ActiveAuctionsChannel");
        },
        received(data) {
          console.log("Received data for ActiveAuctionsChannel", data);
          const auctionId = data.auction_id;

          fetch("/auctions/" + auctionId, {
            headers: {
              "Accept": "text/vnd.turbo-stream.html"
            }
          })
          .then(response => response.text())
          .then(html => Turbo.renderStreamMessage(html));
        },
      }
    )
  }
});
