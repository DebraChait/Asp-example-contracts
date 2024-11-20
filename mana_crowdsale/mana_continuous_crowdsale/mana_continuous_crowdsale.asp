contract ManaContinuousCrowdsale() issuer(10000000000000) {

    msg 
        start_crowdsale(int, address, nat, int),
        buy_tokens(coin),
        sale_coins(coin),
        sale_tokens(token),
        change_wallet(address),
        change_rate(nat),
        new_rate(nat),
        pause(),
        unpause(),
        modify_owner(address);

    var 
        timer_bucket: timer,
        bucket_issuance: int,
        wallet: address,
        rate: nat,
        inflation: int,
        bucket_size: int,
        bucket_amount: nat := 0,
        sale_timer: timer,
        tokens_bought: nat := 0,
        token_to_send: token := Token.none,
        coinsRaised: nat := 0;

    ghost var 
        sale_completed: bool := false;
    
    initial Setup;

    state Setup:
    | a??start_crowdsale(bs, w, r, inf) when bs > 0 by owner -> CrowdsaleOpen {
        Timer.set(timer_bucket, bs);
        bucket_size = bs;
        wallet = w;
        rate = r;
        inflation = inf;
        bucket_issuance = 1000 * inflation / 100;
        bucket_issuance = bucket_issuance / bucket_size;
    }

    | a??modify_owner(b) by owner -> Setup {
        Address.change_owner(b);
    }

    state CrowdsaleOpen:
    | a??buy_tokens(c) when Coin.value(c) > 0 /*&& !paused*/ -> TrackSale {
        coinsRaised = coinsRaised + Coin.value(c);
        wallet!!sale_coins(c);
        tokens_bought = rate * Coin.value(c);
        Token.issue(tokens_bought, token_to_send);
        a!!sale_tokens(token_to_send);
        sale_completed = false;
    }

    | a??change_wallet(b) by owner -> CrowdsaleOpen {
        wallet = b;
    }

    | a??change_rate(r) by owner -> CrowdsaleOpen {
        rate = r;
        log!!new_rate(rate);
    }

    | a??pause() by owner -> Paused {}

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
    | when bucket_amount < bucket_issuance -> CrowdsaleOpen {
        sale_completed = true;
    }

    state Paused:
    | a??unpause() by owner -> CrowdsaleOpen {}

}   