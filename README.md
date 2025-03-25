A simple real-time auction system where sellers list items for auction and buyers place bids in real time. The focus is on implementing real-time updates using AnyCable and WebSockets.

## Run
`bin/dev`

## Technologies used:
- The frontend uses built-in Rails views and Stimulus.js for real-time updates.
- Assets pipeline with propshaft
- Anycable as drop-in replacement for ActionCable.
- TailwindCSS for styling. No framework is used.

## Main flows:

### Sellers:
- after login, the seller is presented by Seller dashboard, where it show all of his auction items.
- Sellers can select menu item to create new auction items.
- Each auction item will have following statuses:
  - Initial/inactive (WHITE): the auction is not open for bidding. There're a button for seller to open the auction.
  - Active (YELLOW): the auction is open for bidding.
  - Bidding (GREEN): there're biddings going on in the auction.
  - Closed (GREY): the auction will be automatically closed after the bidding period.

### Buyers:
- after login, the buyer is presented by Buyer dashboard, where it show all auctions items ready to bid.
- On each auction item, buyer can input the amount of bid and submit it.

## Realtime update features:
- When a new auction is started (and ready for biding), the new auction will be shown in the BUYER dashboard screen.
- When an auction is closed (due to duration finished), its status will be updated in the SELLER and BUYER dashboard screen.
- When a new bid is placed, the auction status will be updated (e.g. from ACTIVE to BIDDING) in the SELLER and BUYER dashboard screen.
  For BUYER, the bidding status will be updated if he/she is currently the highest bidder (CYAN) or outbid (RED).

## Limitations:
- The UI is ugly, with a big dashboard for buyer and seller which show everything.
- The frontend code is not well organized and clean:
  - with tailwindcss classes repetition.
  - turbo seems to be more limited than ujs/jquery
  - activecable/anycable is not well documented.
