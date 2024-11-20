/* original code: https://github.com/move-language/move/blob/main/language/documentation/examples/experimental/basic-coin/sources/BasicCoin.move */

contract BasicCoin() issuer(100000000000000000) {

    msg 
        openAccount(),
        mint(nat, address),
        burn(nat, address),
        getBalance(address),
        balance(int),
        transfer(nat, address),
        deposit(token, address),
        withdraw(nat),
        withdrawnTokens(token);

    var 
        accounts: map[address, token] default Token.none;

    initial Bank;

    state Bank:
     | a??openAccount() when !(Map.in(a, accounts)) -> Bank {
        Map.set(accounts, a, Token.none);
        /* ensures balance is 0 */
    }

    | a??mint(x, b) when Map.in(b, accounts) -> Bank {
      Token.issue(x, Map.ref(accounts,b));
    } 

    | a??burn(x, b) -> Bank {
      Token.burn(Map.ref(accounts, b), x); 
    }

    | a??getBalance(b) when Map.in(a, accounts) -> Bank {
       a!!balance(Token.value(Map.get(accounts, b)));
    }

    | a??transfer(x, b) when Map.in(a, accounts) && Map.in(b, accounts) notby b -> Bank {
       Token.move(Map.ref(accounts, a), x, Map.ref(accounts, b));
        /* ensures transfer amounts are correct */
    }

    | a??deposit(t, b) when Map.in(b, accounts) -> Bank {
        Token.moveall(t, Map.ref(accounts, b)); 
        /* ensures final balance is correct */
    }

    | a??withdraw(x) when Map.in(a, accounts) && Token.value(Map.get(accounts, a)) >= x -> Bank {
        a!!withdrawnTokens(Map.ref(accounts, a)); 
    }

}