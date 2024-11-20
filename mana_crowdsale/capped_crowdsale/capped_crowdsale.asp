contract CappedCrowdsale() issuer(10000000000000) {

    msg 
        start_crowdsale(nat, int, address, nat),
        buy_tokens(coin),
        sale_coins(coin),
        sale_tokens(token);

    var 
        max_coins: nat,
        wallet: address,
        rate: nat,
        sale_timer: timer,
        tokens_bought: nat := 0,
        token_to_send: token := Token.none,
        coinsRaised: nat := 0;
    
    initial Setup;

    state Setup:
    | a??start_crowdsale(mc, time, w, r) -> CrowdsaleOpen {
        Timer.set(sale_timer, time);
        max_coins = mc;
        wallet = w;
        rate = r;
    }

    state CrowdsaleOpen:
    | a??buy_tokens(c) when Timer.is_active(sale_timer) && Coin.value(c) > 0 && coinsRaised < max_coins -> CrowdsaleOpen {
        coinsRaised = coinsRaised + Coin.value(c);
        wallet!!sale_coins(c); 
        tokens_bought = rate * Coin.value(c);
        Token.issue(tokens_bought, token_to_send);
        a!!sale_tokens(token_to_send);
    }

    | when Timer.has_fired(sale_timer) || coinsRaised >= max_coins -> CrowdsaleClosed {}

    state CrowdsaleClosed:

}   