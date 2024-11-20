/* inspired by 2vyper example: https://github.com/viperproject/2vyper/blob/master/tests/resources/examples/auction.vy */


contract SimpleAuction(beneficiary: address, bidding_time: int) where beneficiary != Address.none && bidding_time > 0 {

    msg
        start,
        bid(coin),
        bid_lost(coin),
        winner(coin, address);

    var 
        tmr: timer,
        maxBid: coin := Coin.none,
        maxBidder: address := Address.none;

    ghost var
        oldmaxBid: int := 0,
        oldmaxBidder: address := Address.none,
        currentBid: int := 0,
        currentBidder: address := Address.none,
        balance: int := 0,
        winningBid: int,
        bidded: map[address, int] default 0,
        refunded: map[address, int] default 0;
    
    initial StartAuction;
    
    state StartAuction:
    | a??start by owner -> AuctionOpen { 
        Timer.set(tmr, bidding_time); 
    } 

    state AuctionOpen:
        | a??bid(c) when Timer.is_active(tmr) && Coin.value(c) > Coin.value(maxBid) notby beneficiary -> AuctionOpen {    
                /* update ghost variables */
                Map.set(bidded, a, Map.get(bidded,a) + Coin.value(c));
                balance = balance + Coin.value(c);
                currentBid = Coin.value(c);
                currentBidder = a;
                oldmaxBid = Coin.value(maxBid);
                oldmaxBidder = maxBidder;

                /* update ghost send map and return defeated bid */
                Map.set(refunded, maxBidder, Map.get(refunded, maxBidder) + Coin.value(maxBid));
                balance = balance - Coin.value(maxBid);
                maxBidder!!bid_lost(maxBid);

                /* store new maxes */
                maxBidder = a;
                Coin.moveall(c,maxBid);
            }
        
        | when Timer.has_fired(tmr) -> AuctionClosed {
                /* update ghost vars and send beneficiary the highest bid */
                Map.set(refunded, beneficiary, Map.get(refunded, beneficiary) + Coin.value(maxBid));
                winningBid = Coin.value(maxBid);
                balance = balance - Coin.value(maxBid);
                beneficiary!!winner(maxBid, maxBidder);
            }

    state AuctionClosed:

}