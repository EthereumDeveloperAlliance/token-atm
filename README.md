# Token ATM Smart Contract

A smart contract to issue tokens using a signed certificate. The automated teller machine (ATM) accepts certificates from token owners and can be redeemed by approved certificate holders.

## Instructions

- Deploy ATM Smart Contract to blockchain.
- Approve spending by ATM for designated token.
- Sign certificate for designated token.
- Send signed certificate to recipient.
- Redeem certificate to accept tokens.

## Functions

- function redeem(address \_from, address \_erc20,uint256 \_amount, uint256 \_nonce, bytes calldata \_signature) external {}
- function addDelegate(address \_issuer) external onlyOwner {}
- function removeDelegate(address \_issuer) external onlyOwner {}
- function \_verifySignature( bytes32 \_hash, bytes memory \_signature, address \_from) internal view returns (bool) {}
- function getCertificateHash(uint256 \_amount,address \_recipient,address \_holder,address \_erc20,uint256 \_nonce) public view returns (bytes32) {}
- function verifyCertificate( address \_from, address \_recipient, address \_erc20, uint256 \_amount, bytes memory \_signature, uint256 \_nonce) public vie returns (bool) {}

## Deploy

The smart contracts can be deployed using a number of different methods. To continue to interact with the deployed smart contracts we recommend using the OpenZeppelin CLI

Setup the project using the OpenZeppelin CLI to easily interact with deployed contracts directly from the CLI.

### Open Zeppelin

```.sh
$ oz init
$ oz deploy
```

### Truffle

```.sh
$ truffle compile
$ truffle deploy --network [NETWORK]
```

## Send Transactions

If the contracts are deployed using the OpenZeppelin CLI you can continue to interact with contracts using several CLI commands.

```
$ oz call
$ oz send-tx
```

## Contributors

| Name               | Website                      |
| ------------------ | ---------------------------- |
| **Kames Geraghty** | <https://github.com/kamescg> |
| **Joe Bernitt**    | <https://github.com/joeb000> |

## License

[MIT](LICENSE) © [Kames Geraghty](https://github.com/kamescg)
