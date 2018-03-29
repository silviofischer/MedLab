mapping (address => bytes32) balanceHashes;

contract ZeroProof {
  // program used by the sender
  function senderFunction(x, w) {
    return (
      w.senderBalanceBefore > w.value &&
      sha256(w.value) == x.hashValue &&
      sha256(w.senderBalanceBefore) == x.hashSenderBalanceBefore &&
      sha256(w.senderBalanceBefore - w.value) == x.hashSenderBalanceAfter
    )
  }
  // program used by the receiver
  function receiverFunction(x, w) {
    return (
      sha256(w.value) == x.hashValue &&
      sha256(w.receiverBalanceBefore) == x.hashReceiverBalanceBefore &&
      sha256(w.receiverBalanceBefore + w.value) == x.hashReceiverBalanceAfter
    )
  }
  //zk-SNARKs used in token contract
  function transfer(address _to, bytes32 hashValue, bytes32 hashSenderBalanceAfter, bytes32 hashReceiverBalanceAfter, bytes zkProofSender, bytes zkProofReceiver) {
    bytes32 hashSenderBalanceBefore = balanceHashes[msg.sender];
    bytes32 hashReceiverBalanceBefore = balanceHashes[_to];

    bool senderProofIsCorrect = zksnarkverify(confTxSenderVk, [hashSenderBalanceBefore, hashSenderBalanceAfter, hashValue], zkProofSender);

  bool receiverProofIsCorrect = zksnarkverify(confTxReceiverVk, [hashReceiverBalanceBefore, hashReceiverBalanceAfter, hashValue], zkProofReceiver);

    if(senderProofIsCorrect && receiverProofIsCorrect) {
      balanceHashes[msg.sender] = hashSenderBalanceAfter;
      balanceHashes[_to] = hashReceiverBalanceAfter;
    }
  }

}
