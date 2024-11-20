## Overview of Open Auction files
* simple_open_auction.asp: contract for running an open auction, including ghost variables for proofs. can trigger beneficiary.asp upon transitioning to its final state by inputting the appropriate address as a contract parameter.
* simple_open_auction.proof: proof file for proving various safety proofs of simple_open_auction.asp, including that maxBid and maxBidder variables are set correctly, that refunds are distributed correctly, and that cryptocurrency is only sent to bidders
* simple_open_auction.vpr: compiled Viper file of simple_open_auction.asp and simple_open_auction.proof
* refunds_correct.proof: proof file for proving that refunds in simple_open_auction.asp are correct (distilled from simple_open_auction.proof)
* refunds_correct.vpr: compiled Viper file of simple_open_auction.asp and refunds_correct.proof
* only_refund_bidders.proof: proof file for proving that cryptocurrency is sent strictly to bidders (distilled from simple_open_auction.proof)
* only_refund_bidders.vpr: compiled Viper file of simple_open_auction.asp and only_refund_bidders.proof
* reachability.proof: (liveness) proof file for proving that simple_open_auction.asp always terminates
* reachability.vpr: compiled Viper file of simple_open_auction.asp and reachability.proof
* beneficiary.asp: contract for receiving the winner of simple_open_auction.asp and the winning bid (in cryptocurrency)
