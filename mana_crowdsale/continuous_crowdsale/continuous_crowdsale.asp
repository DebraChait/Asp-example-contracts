contract ContinuousCrowdsale() issuer(10000000000000) {

    msg 
        start_crowdsale(int, address, nat, nat),
        buy_tokens(coin),
        sale_coins(coin),
        sale_tokens(token);

    var 
        timer_bucket: timer,
        bucket_size: int,
        issuance: nat,
        wallet: address,
        rate: nat,
        bucket_amount: nat := 0,
        sale_timer: timer,
        tokens_bought: nat := 0,
        token_to_send: token := Token.none,
        coinsRaised: nat := 0;
    
    initial Setup;

    state Setup:
    | a??start_crowdsale(bs, w, r, is) -> CrowdsaleOpen {
        bucket_size = bs;
        Timer.set(timer_bucket, bucket_size);
        wallet = w;
        rate = r;
        issuance = is;
    }

    state CrowdsaleOpen:
    | a??buy_tokens(c) when Coin.value(c) > 0 -> TrackSale {
        coinsRaised = coinsRaised + Coin.value(c);
        wallet!!sale_coins(c); 
        tokens_bought = rate * Coin.value(c);
        Token.issue(tokens_bought, token_to_send);
        a!!sale_tokens(token_to_send);
    }

    state TrackSale:
    | when Timer.is_active(timer_bucket) -> CheckMax {
        bucket_amount = bucket_amount + tokens_bought;
    }

    | when Timer.has_fired(timer_bucket) -> CheckMax {
        Timer.reset(timer_bucket);
        Timer.set(timer_bucket, bucket_size);
        bucket_amount = tokens_bought;
    }

    state CheckMax:
    | when bucket_amount < issuance -> CrowdsaleOpen {}

}   