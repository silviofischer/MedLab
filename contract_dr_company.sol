pragma solidity ^0.4.21;

contract DrCompany {
  // dr = seller, company = buyer, patient = owner
  uint public value;
  string private data;
  address public doctor;
  address public company;
  address public patient;
  address public uploader;
  enum state { Created, Locked, Inactive }
  State public state;

  function DataUpload() public uploading {
    uploader = msg.sender;
    data = msg.data;
    require(msg.data == string);
  }

  function Purchase() public payable {
    doctor = msg.sender;
    value = msg.value / 2;
    require((2 * value) == msg.value);
  }

  modifier condition(bool _condition) {
    reqire(_condition);
    _;
  }

  modifier onlyBuyer() {
     require(msg.sender == company);
     _;
  }

  modifier onlySeller() {
     require(msg.sender == doctor);
     _;
  }

  modifier inState(State _state) {
     require(state == _state);
     _;
  }

  event Aborted();
  event PurchaseConfirmed();
  event ItemReceived();

  function abort()
    public
    onlySeller
    inState(State.Created)
  {
    emit Aborted();
    state = State.Inactive;
    doctor.transfer(this.balance);
  }

  function confirmPurchase()
    public
    inState(State.Created)
    condition(msg.value == (2 * value))
    payable
  {
    emit PurchaseConfirmed();
    company = msg.sender;
    state = State.Locked;
  }

  function confirmReceived()
    public
    onlyBuyer
    inState(State.Locked)
  {
    emit ItemReceived();
    state = State.Inactive;

    company.transfer(value);
    doctor.transfer(this.balance);
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

  var testIdentity= {
              type: 'ethereum',
              display: '0x54dbb737eac5007103e729e9ab7ce64a6850a310',
              privateKey: '52435b1ff11b894da15d87399011841d5edec2de4552fdc29c8299574436924d',
              publicKey: '029678ad0aa2fbd7f212239e21ed1472e84ca558fecf70a54bbf7901d89c306191',
              foreign: false
          };
  var message = "foobar";
  var bitcore = require('bitcore-lib');
  var ECIES = require('bitcore-ecies');

      /**
       * encrypt the message with the publicKey of identity
       * @param  {{privateKey: ?string, publicKey: string}} identity
       * @param  {string} message
       * @return {string}
       */
      var encrypt = function(identity, message) {

          /*
           * this key is used as false sample, because bitcore would crash when alice has no privateKey
           */
          var privKey = new bitcore.PrivateKey('52435b1ff21b894da15d87399011841d5edec2de4552fdc29c8299574436925d');
          var alice = ECIES().privateKey(privKey).publicKey(new bitcore.PublicKey(identity.publicKey));
          var encrypted = alice.encrypt(message);

          return encrypted.toString('hex');
      };

      /**
       * decrypt the message with the privateKey of identity
       * @param  {{privateKey: ?string, publicKey: string}}   identity
       * @param  {string}   encrypted
       * @return {string}   message
       */
      var decrypt = function(identity, encrypted) {
          var privKey = new bitcore.PrivateKey(identity.privateKey);
          var alice = ECIES().privateKey(privKey);

          var decryptMe = new Buffer(encrypted, 'hex');

          var decrypted = alice.decrypt(decryptMe);
          return decrypted.toString('ascii');
      };



  var enc = encrypt(testIdentity, message);
  var dec = decrypt(testIdentity, enc);

  if(dec!=message){
    alert('error');
  }else{
    alert('sucess');
  }

}
