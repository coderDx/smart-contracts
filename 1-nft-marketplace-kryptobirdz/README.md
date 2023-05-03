# Basic Sample Hardhat Project
https://www.udemy.com/course/build-an-nft-marketplace-from-scratch-blockchain-dapp/learn/lecture/28868582#contentv

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

Dx Notes

Cold start dev server:
1. Delete contents of `/config.js`.
2. Start a node using `$ npx hardhat node`.
3. run a deployment using `$ npx hardhat run scripts/deploy.js --network localhost`.
4. Go into `/config.js` and add single quotes around hex keys.
4. Run dev server using `$ npm run dev`.

