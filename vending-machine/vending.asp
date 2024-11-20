/* A typical vending machine contract.
 *
 * A customer enters coins, then asks for either a chocolate or a coffee;
 * the machine dispenses the product and returns change.
 * 
 * The machine continues working until explicitly stopped by the contract owner,
 * at which point the accumulated payments are withdrawn by the owner.
 */

contract Vending {

 msg enter(coin), refund(coin); // customer money transfers
 msg choose_chocolate, choose_coffee, dispense_chocolate, dispense_coffee; // customer choices and products
 msg stop, collect, withdraw(coin);      // owner money transfers and control
 msg cancel;                    // reset customer

 var total: coin,  // accumulated payments
     paid: coin;   // amount paid by current customer

 var customer: address; // current customer

 var
    cost_of_chocolate: nat := 10,       // constants
    cost_of_coffee: nat := 20;

 initial Wait;
  
 state Wait: 
    // new customer arrives
    | a??enter(c) -> Pay_and_Choose {
        customer = a; Coin.moveall(c,paid);
    }

    // owner chooses to stop vending
    | a??stop by owner -> Withdraw_and_Halt {}

    // owner decides to collect accumulated payments
    | a??collect by owner -> Withdraw_and_Reset {}


 state Pay_and_Choose: 
    // customer adds money
    | a??enter(c) by customer -> Pay_and_Choose {
        Coin.moveall(c,paid); }

    // customer chooses
    | a??choose_chocolate when Coin.value(paid) >= cost_of_chocolate by customer -> Get_Chocolate {
        Coin.move(paid,cost_of_chocolate,total);
    }
    | a??choose_coffee when Coin.value(paid) >= cost_of_coffee by customer -> Get_Coffee {
        Coin.move(paid,cost_of_coffee,total); 
    }

    // cancel: customer is refunded. Necessary to avoid adversarial lockout
    | a??cancel -> Refund {}
    

 state Get_Chocolate:
    | -> Refund { customer!!dispense_chocolate; }

 state Get_Coffee:
    | -> Refund { customer!!dispense_coffee; }

 state Refund:
    // return change to the customer
    | -> Wait { customer!!refund(paid); customer = Address.none; }


 state Withdraw_and_Reset:
    | -> Wait { owner!!withdraw(total); }
    
 state Withdraw_and_Halt:
    | -> Halt { owner!!withdraw(total); }
    
 state Halt:
    // machine is halted; do nothing

}
