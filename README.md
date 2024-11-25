## Guide to repository
This repository contains examples of smart contracts written in Asp, a language that eases construction of trustworthy smart contracts. The repository accompanies the paper "Constructing Trustworthy Smart Contracts" that will appear in VMCAI 2025. (Extended version available [here](https://arxiv.org/abs/2411.14563).)

Each folder contains an Asp contract, along with any proof files for the contract. Asp contracts end in .asp, while proof files end in .proof. Proof verification consists of compiling the contract and proof to Viper. 
The compiled Viper files are attached (ending in .vpr), and can be verified independently with Viper. These files rely on domains encoded in Viper to support Asp's abstract types. For verification, the file ADT_encoding.vpr must be found in the same directory as the file under verification.

## Overview of examples
Most of the examples in Asp are modeled on existing examples in other languages. The following is an overview of the examples, properties proven, and the original sources.

#### Mana Crowdsale
* Modeled on [VerX](https://github.com/eth-sri/verx-benchmarks/blob/master/Mana/main.sol)
* A series of contracts which sell tokens in exchange for native cryptocurrency
* Proofs are provided to verify that the Mana Continuous Crowdsale does not exceed its sale limits, and that the Mana Crowdsale ends under expected conditions

#### Open Auction
* Modeled on [2vyper](https://github.com/viperproject/2vyper/blob/master/tests/resources/examples/auction.vy)
* Creates an open auction, sending the final winner and the winning bid (in the form of cryptocurrency) upon completion
* Safety property proofs include that bidders are refunded correctly, that refunds are sent strictly to bidders, and that the maxBid and maxBidder variables indeed store the highest bid and corresponding bidder
* A liveness proof verifies that the auction always terminates

#### Safe Remote Purchase
* Modeled on [2vyper](https://github.com/viperproject/2vyper/blob/master/tests/resources/examples/safe_remote_purchase.vy)
* Facilitates the sale of an offchain item for native cryptocurrency
* Proofs verify that cryptocurrency held in escrow from the seller and the buyer during the contract both are of the expected value

#### Token Bank
  * Modeled on [Move](https://github.com/move-language/move/blob/main/language/documentation/examples/experimental/basic-coin/sources/BasicCoin.move)
  * token_bank.asp: defines a bank of tokens which allows users to deposit, withdraw, transfer, mint, and burn.
  * Move provides specifications proving that each operation behaves as expected. Such a proof is unnecessary in Asp as token behavior is guaranteed by the abstract Token type.
    
#### Vending Machine
  * Demonstrates the state machine structure of Asp contracts with a simple vending machine contract

## Asp implementation
The Asp compilers and encoding of Asp abstract types are implemented in about 3000 lines of OCaml and 100 lines of Viper. Implementations will be made open-source pending organizational approvals.
