contract Crowdsale() issuer(10000000000000) {

    msg 
        start_crowdsale(int, address, nat),
        buy_tokens(coin),
        sale_coins(coin),
        sale_tokens(token);

    var 
        wallet: address,
        rate: nat,
        sale_timer: timer,
        tokens_bought: nat := 0,
        token_to_send: token := Token.none,
        coinsRaised: nat := 0;
    
    initial Setup;

    state Setup:
    | a??start_crowdsale(time, w, r) -> CrowdsaleOpen {
        Timer.set(sale_timer, time);
        wallet = w;
        rate = r;
    }

    state CrowdsaleOpen:
    | a??buy_tokens(c) when Timer.is_active(sale_timer) && Coin.value(c) > 0 -> CrowdsaleOpen {
        /* update state */
        coinsRaised = coinsRaised + Coin.value(c);
        /* collect funds */
        wallet!!sale_coins(c);
        tokens_bought = rate * Coin.value(c);
        Token.issue(tokens_bought, token_to_send);
        a!!sale_tokens(token_to_send);
    }

    | when Timer.has_fired(sale_timer) -> CrowdsaleClosed {}

    state CrowdsaleClosed:

}   