# EVM Storage Layout Research (with foundry)
```
mkdir pwn
cd pwn
forge init --template https://github.com/dnsdudrla97/EVM-Storage-Layout-Pwn
git submodule update --init --recursive  ;; init submodule dependencies
npm install ## install development dependencies
forge build
```

## Dependent contract file structure
```
./src/test
├── ArrayStorage.t.sol
├── BaseTest.sol
├── DelegateCallStorage.t.sol
├── FallBack.t.sol
├── FallBackProxy.t.sol
├── SimpleStorageLayout.t.sol
├── StorageLayout.t.sol
├── Struct.t.sol
├── UpgradeProxy.t.sol
```

## Features

### foundry.toml
```
[default]
src = 'src'
out = 'out'
libs = ['lib']
#remappings = ['forge-std/=lib/forge-std/src/', 'openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/', 'ds-test/=lib/ds-test/src/']

fs_permissions = [{ access = "read", path = "./"}]      # <-- add your own fs permissions here
```

### Lib Install
```
forge install safe-global/safe-contracts@c36bcab --no-commit 
forge install github-rp@commit --no-commit
```

### Lib Remapping (remappings.txt)
```
ds-test/=lib/ds-test/src/
solmate/=lib/solmate/src/
forge-std/=lib/forge-std/src/
@openzeppelin/=lib/openzeppelin-contracts/
@uniswap/v2-periphery/=lib/v2-periphery/
@uniswap/v2-core/=lib/v2-core/
gnosis/=lib/safe-contracts/contracts/
                                        <-- add your own remappings here
```
```
forge remappings
```


### Testing Utilities (verbose level: -vvvv)
```
forge test --match-contract FallBackProxyTest -vvvv
forge test --match-contract <CONTRACT> <tx log options (-v)>
```

### Storage Layout 
```
forge inspect --pretty StorageLayout storage-layout
| Name  | Type                        | Slot | Offset | Bytes | Contract                                   |
|-------|-----------------------------|------|--------|-------|--------------------------------------------|
| flag  | uint256                     | 0    | 0      | 32    | src/test/StorageLayout.t.sol:StorageLayout |
| users | mapping(address => uint256) | 1    | 0      | 32    | src/test/StorageLayout.t.sol:StorageLayout |
| key   | bytes                       | 2    | 0      | 32    | src/test/StorageLayout.t.sol:StorageLayout |

forge inspect <options:pretty> <CONTRACT> storage-layout

```

### Debugging Utilities

```
forge test --debug "testExploit"
forge test --debug {test*}
```
### Default Configuration

Including `.gitignore`, `.vscode`, `remappings.txt`

