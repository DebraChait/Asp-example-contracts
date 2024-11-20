contract Beneficiary(auction: address) {
    msg 
        winner(coin, address),
        final_winner(nat);

    initial AcceptBid;

    state AcceptBid:
    | a??winner(amt, addr) by auction -> FinalState { 
        log!!final_winner(Coin.value(amt));  
    }

    state FinalState:
}