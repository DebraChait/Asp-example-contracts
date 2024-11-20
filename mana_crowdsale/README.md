## Overview of Mana Crowdsale files
#### Capped Crowdsale
* capped_crowdsale.asp: contract for a crowdsale that ends with the firing of a timer or when a limit on sales is reached
#### Continuous Crowdsale
* continuous_crowdsale.asp: contract for a crowdsale that runs continuously, but limits sales over chunks of time
#### Crowdsale
* crowdsale.asp: contract for a crowdsale that ends with the firing of a timer
#### Mana Continuous Crowdsale
* mana_continuous_crowdsale.asp: contract for a continuous crowdsale with the ability to be paused and subsequently unpaused by contract owner
* mana_continuous_crowdsale.proof: proof file for verifying that mana_continuous_crowdsale.asp does not exceed sales limit per time chunk
* mana_continuous_crowdsale.vpr: compiled Viper file of mana_continuous_crowdsale.asp and mana_continuous_crowdsale.proof
#### Mana Crowdsale
* mana_crowdsale.asp: contract for a pausable crowdsale that allows specified addresses to purchase tokens at a discounted rate. contract can trigger mana_continuous_crowdsale.asp upon transitioning to its final state by inputting the address of the (deployed) compiled Solidity file for mana_continuous_crowdsale.asp, and modifying the (deployed) address of mana_continuous_crowdsale.asp to be the owner of mana_crowdsale.asp
* mana_crowdsale.proof: proof file for verifying that the crowdsale ends when it reaches the sale limit or the timer has fired
* mana_crowdsale.vpr: compiled Viper file of mana_crowdsale.asp and mana_crowdsale.proof
