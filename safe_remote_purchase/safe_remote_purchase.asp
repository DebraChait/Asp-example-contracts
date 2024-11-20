contract SafeRemotePurchase() {

    msg
        post(nat, coin), /* nat identifies the item, coin is deposit */
        withdraw_sale(),
        return_deposit(coin),
        purchase_item(nat, coin),
        purchaser(address),
        shipped_item(),
        item_shipped(),
        received_item(),
        deliver_payment(coin);
    
    var
        item: nat,
        seller_deposit: coin,
        value: nat,
        seller: address,
        buyer_deposit: coin,
        payment: coin,
        buyer: address;
    
    initial PostItem;
    
    state PostItem:
    | a??post(id, dep) when Coin.value(dep) > 0 && Coin.value(dep) % 2 == 0 -> ItemPosted {
        item = id;
        Coin.moveall(dep, seller_deposit);
        value = Coin.value(seller_deposit)/2;
        seller = a;
    } 

    state ItemPosted:
    | a??withdraw_sale() by seller -> PostItem {
        seller!!return_deposit(seller_deposit);
        seller = Address.none;
    }

    | a??purchase_item(id, p) when id == item && Coin.value(p) == 2 * value -> ShipItem {
        Coin.move(p, value, buyer_deposit);
        Coin.move(p, value, payment);
        buyer = a;
        seller!!purchaser(a);
    }

    state ShipItem:
    | a??shipped_item() by seller -> ReceivedItem {
        buyer!!item_shipped();
    }
    
    state ReceivedItem:
    /* note that this contract CAN enter a locked state! deposits are to discourage locking */
    | a??received_item() by buyer -> PostItem { 
        buyer!!return_deposit(buyer_deposit);
        seller!!return_deposit(seller_deposit);
        seller!!deliver_payment(payment);
        buyer = Address.none;
        seller = Address.none;
        value = 0;
    }

    
}