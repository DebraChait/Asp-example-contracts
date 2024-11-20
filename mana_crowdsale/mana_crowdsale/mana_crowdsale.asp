contract ManaCrowdsale() issuer(10000000000000) {

    msg 
        start_crowdsale(int),
        buy_tokens(coin),
        sale_coins(coin),
        sale_tokens(token),
        setup_crowdsale(nat, address, nat, nat),
        reset_rate(nat),
        add_to_whitelist(address, nat),
        pref_rate_change(nat),
        finalize(address, nat, address, nat),
        start_continuous_crowdsale(nat, address, nat);

    var 
        max_coins: nat,
        wallet: address,
        rate: nat,
        pref_rate: nat,
        sale_timer: timer,
        tokens_bought: nat := 0,
        token_to_send: token := Token.none,
        coinsRaised: nat := 0,
        whitelist: map[address, bool] default false,
        whitelist_rate: map[address, nat] default pref_rate;
    
    initial Setup;

    state Setup:
    | a??setup_crowdsale(mc, w, r, pr) when r > 0 && pr > 0 by owner -> Setup {
        max_coins = mc;
        wallet = w;
        rate = r;
        pref_rate = pr;
    }

    | a??reset_rate(r) when r > 0 by owner -> Setup {
        rate = r;
    }

    | a??add_to_whitelist(b, r) when r > 0 by owner -> Setup {
        Map.set(whitelist, b, true);
        Map.set(whitelist_rate, b, r);
        b!!pref_rate_change(r);
    }

    | a??buy_tokens(c) when Coin.value(c) > 0 && coinsRaised < max_coins && Map.get(whitelist, a) -> Setup {
        coinsRaised = coinsRaised + Coin.value(c);
        wallet!!sale_coins(c);
        tokens_bought = Map.get(whitelist_rate, a) * Coin.value(c);
        Token.issue(tokens_bought, token_to_send);
        a!!sale_tokens(token_to_send);
    }

    | a??start_crowdsale(time) by owner -> CrowdsaleOpen {
        Timer.set(sale_timer, time);
    }


    state CrowdsaleOpen:
    | a??buy_tokens(c) when Timer.is_active(sale_timer) && Coin.value(c) > 0 && coinsRaised < max_coins -> CrowdsaleOpen {
        coinsRaised = coinsRaised + Coin.value(c);
        wallet!!sale_coins(c);
        if Map.get(whitelist, a) { rate = Map.get(whitelist_rate, a);};
        tokens_bought = rate * Coin.value(c);
        Token.issue(tokens_bought, token_to_send);
        a!!sale_tokens(token_to_send);
    }

    | a??add_to_whitelist(b, r) when r > 0 by owner -> CrowdsaleOpen {
        Map.set(whitelist, b, true);
        Map.set(whitelist_rate, b, r);
        b!!pref_rate_change(r);
    }

    | when Timer.has_fired(sale_timer) || coinsRaised >= max_coins -> FinalizeCrowdsale {
    }

    
    state FinalizeCrowdsale:
    | a??finalize(continuous_sale, bs, w, r) when continuous_sale != Address.none by owner -> CrowdsaleClosed {
        /* Once finalized, can start a continuous sale */
        continuous_sale!!start_continuous_crowdsale(bs, w, r);
    }

    state CrowdsaleClosed:

}   