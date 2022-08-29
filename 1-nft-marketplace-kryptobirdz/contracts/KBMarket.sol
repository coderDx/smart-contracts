// SEE VIDEO 16

//SPDX-Liceense-Identifier: MIT
pragma solidity ^0.8.4;

// openzeppelin ERC721
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

// security against transactions for multiple requests

import 'hardhat/console.sol';

contract KBMarket is ReentrancyGuard {
  using Counters for Counters.Counter;

  // number of items minting, number of transactions, tokens that have not been sold
  // keep track of tokens total number - tokenId
  // arrays need to know the length - help to keep track of arrays

  Counters.counter private _tokenIds;
  Counters.Counter private _tokensSold;

  // determine who is the owner of the contract
  // charge a listing fee so theowner makes a commission

  address payable owner;

  // deploying to matic
  uint256 listingPrice = 0.045 ether;

  constructor() {
    // set the owner
    owner = payable(mgs.sender);
  }

  struct MarketToken {
    uint itemId;
    address nftConntract;
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }

  // token return which marketToken - fetch
  mapping(uint256 => MarketToken) private idToMarketToken;

  // listen to events from front end applications
  event MarketTokenMinted(
    uint indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address payable seller,
    address payable owner,
    uint256 price,
    bool sold
  );

  // get listing price
  function getListingPrice() public view returns (uint256) {
    return listingPrice;
  }

  // two functions to interact with our contract
  // 1. create a market item to put it up for sale
  // 2. create a market sale for buying and selling between parties

  function mintMarketItem(
    address nftContract,
    uint tokenId,
    uint price
  )

  public payable nonReentrant {
    // nonReentrant is a modifier to prevent reentry attack
    require(price > 0, 'Price must be at least one wei');
    require(msg.value == listingPrice, 'Price must be equal to listing price');

    _tokenIds.increment();
    uint itemId = _tokenIds.current();

    // putting it up for sale
    idToMarketToken[itemId] = MarketToken(
      itemId,
      nftConntract,
      tokenId,
      payable(msg.sender),
      payable(address(0)),
      price,
      false
    );

    // NFT Transaction (Starting video 17)
  }

}