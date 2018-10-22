# Istanbul validator proposal issue

This decribes the issue with the istanbul proposal when starting out with just one validator (https://github.com/jpmorganchase/quorum/issues/523). This is a very simplified version of our setup to reproduce the issue.

## Configuration

This network describes 4 nodes where only the first node is a validator. We start out this way because we have experienced that if all 4 nodes would start as validators in the beginning, with a start delay, all 4 nodes would create incompatible blocks (that is a different issue though we will address with a different example).

### Versions used:

- Quorum Geth 2.1.1
- Constellation 0.3.2

### Genesis block

We use the istanbul-tools (we actually use them as dependency in Go) to create the genesis.json for istanbul, with the first node to be a validator:

```
{
	"config": {
		"chainId": 1226637884,
		"eip150Block": 2,
		"eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
		"eip155Block": 3,
		"eip158Block": 3,
		"byzantiumBlock": 1,
		"istanbul": {
			"epoch": 30000,
			"policy": 0
		},
		"isQuorum": true
	},
	"nonce": "0x0",
	"timestamp": "0x5bca15ce",
	"extraData": "0x0000000000000000000000000000000000000000000000000000000000000000f85ad594c8d65fa6ebeff9a7e9b25b08de65fd5c97f30a19b8410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0",
	"gasLimit": "0xe0000000",
	"difficulty": "0x1",
	"mixHash": "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365",
	"coinbase": "0x0000000000000000000000000000000000000000",
	"alloc": {
		"c8d65fa6ebeff9a7e9b25b08de65fd5c97f30a19": {
			"balance": "0xde0b6b3a7640000"
		}
	},
	"parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
}
```

### Startup commands

All Geth processes use the following startup command:
```
geth \
  --datadir /qdata/dd \
  --port 30303 \
  --mine --minerthreads 1 \
  --istanbul.requesttimeout 10000 -istanbul.blockperiod 1 \
  --emitcheckpoints \
  --rpc --rpcport 8545 --rpcaddr 0.0.0.0 --rpcapi eth,web3,db,net,txpool,personal,quorum,istanbul \
  --networkid 1226637884 \
  --permissioned \
  --nodiscover \
  --verbosity 3
```

### Static nodes / permissioned nodes

```
[
  "enode://b3638f001ca11a0e934ee8bed9fac8418eb5dbcda7ff8fe113ba5bbef2fdee4c761a661a1afb9a10a5a12cff7678ab65453745d90473c4e637383b5f9ee2abcf@172.16.239.100:30303?discport=0",
  "enode://6a4afb9f4fb6a9abeb64dc888353d255b798e4d7cd3ea33682297fe05b5846633588bd8220eba614c5a39f477da661fc86fc41d6844c819d200c49e429331aa8@172.16.239.101:30303?discport=0",
  "enode://aded5a7580bec4ba40eabcdc6c57ab30559bfeb22d1f9cb5352f4c3cc9e546177f7624ec05ceb91a46b8e45db3bd20e8d7b6fbab9a15eb3c3c487154f8f36483@172.16.239.102:30303?discport=0",
  "enode://753239c4afb468bda685c501b2590f9232c0b5a309de1d6885187dcf6b5aa64100adec85e6f5a2d9083b48ad8711f8279f8fba92e248153b774364cb87d49f25@172.16.239.103:30303?discport=0"
]

```

### Constellation

For this example, constellation is not configured and just runs besides Geth in order to make this demo work.

## Reproduction of the problem

Prequisites:
- Ubuntu Linux as host system (others might work, but not tested)
- docker and docker-compose

1. Clone this repo.
2. run ```docker-compose build && docker-compose up```
3. Notice in the logs that only node #0 creates blocks, the others are unauthorized
4. Attach to all 4 geth RPC endpoints using ```geth attach http://localhost:800[0-3]``` in 4 seperate terminals
5. In the first terminal, verify that only the first node is a validator: ```istanbul.getValidators()```
6. In the first terminal, propose another node (e.g. the second) to be a validator as well: ```istanbul.propose("0xade94c69b5fb7ce49e76a4de659c30bb971f82aa", true)```
7. Notice that ```istanbul.getValidators()``` now returns two validators. Also notice in the logs, that node #0 is suddenly unauthorized to create blocks - the blockchain stops. 
8. Try to propose a third validator, e.g. ```istanbul.propose("0xb2314c846bf80560a1e9d6521b29924bce9cace3", true)```. The validator list remains unchanged and the blockchain remains idle.
