import consumer from "./consumer";

const subscribeToAuction = (auctionId) => {
  consumer.subscriptions.create(
    { channel: "AuctionChannel", auction_id: auctionId },
    {
      connected() {
        console.log(`Connected to Auction ${auctionId}`);
      },
      received(data) {
        console.log("Received:", data);
        document.getElementById(`highest_bid_${auctionId}`).textContent = `$${data.highest_bid}`;
      },
      disconnected() {
        console.log(`Disconnected from Auction ${auctionId}`);
      }
    }
  );
};

export { subscribeToAuction };