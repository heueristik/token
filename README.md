# MWE

Reproduce the error by

1. Cloning the repo with
   ```bash
   git clone --recursive https://github.com/heueristik/token
   ```
2. Running the test at the bottom of `src/Token.sol` with

   ```bash
   forge clean && forge build && forge test
   ```

   which results in

   ```bash
   ➜  token git:(main) ✗ forge clean && forge build && forge test
   [⠊] Compiling...
   [⠒] Compiling 57 files with Solc 0.8.28
   [⠔] Solc 0.8.28 finished in 5.27s
   Compiler run successful!
   [⠊] Compiling...
   No files changed, compilation skipped

   Ran 1 test for src/Token.sol:TokenTest
   [FAIL: revert: Upgrade safety validation failed:
   ✘  src/Token.sol:Token

       src/Token.sol:29: Missing initializer calls for one or more parent contracts: `ERC20Upgradeable`
           Call the parent initializers in your initializer function
           https://zpl.in/upgrades/error-001

   FAILED] setUp() (gas: 0)
   Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 1.63s (0.00ns CPU time)

   Ran 1 test suite in 1.63s (1.63s CPU time): 0 tests passed, 1 failed, 0 skipped (1 total tests)

   Failing tests:
   Encountered 1 failing test in src/Token.sol:TokenTest
   [FAIL: revert: Upgrade safety validation failed:
   ✘  src/Token.sol:Token

       src/Token.sol:29: Missing initializer calls for one or more parent contracts: `ERC20Upgradeable`
           Call the parent initializers in your initializer function
           https://zpl.in/upgrades/error-001

   FAILED] setUp() (gas: 0)

   Encountered a total of 1 failing tests, 0 tests succeeded
   ```

## Update

Using

```sh
npm install @openzeppelin/upgrades-core@latest
```

[as recommended by @ericglau](npm install @openzeppelin/upgrades-core@latest) from OZ, it now works.
