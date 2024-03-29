//SPDX-Liceense-Identifier: MIT

// SEE VIDEO 16-20

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

  Counters.Counter private _tokenIds;
  Counters.Counter private _tokensSold;

  // determine who is the owner of the contract
  // charge a listing fee so theowner makes a commission

  address payable owner;

  // deploying to matic
  uint256 listingPrice = 0.045 ether;

  constructor() {
    // set the owner
    owner = payable(msg.sender);
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
    address seller,
    address owner,
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

  function makeMarketItem(
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
      nftContract,
      tokenId,
      payable(msg.sender),
      payable(address(0)),
      price,
      false
    );

    // NFT Transaction (Starting video 17)
    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    emit MarketTokenMinted(
      itemId,
      nftContract,
      tokenId,
      msg.sender,
      address(0),
      price,
      false
    );
  }
  //function to condict transactions and market sales
  function createMarketSale(
    address nftContract,
    uint itemId)
    public payable nonReentrant {
      uint price = idToMarketToken[itemId].price;
      uint tokenId = idToMarketToken[itemId].tokenId;
      require(msg.value == price, 'Plese submit asking proce to continue');

      // transfer the amount to the seller
      idToMarketToken[itemId].seller.transfer(msg.value);

      // transfer token from contract address to the buyer
      IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
      idToMarketToken[itemId].owner = payable(msg.sender);
      idToMarketToken[itemId].sold = true;
      _tokensSold.increment();

      payable(owner).transfer(listingPrice);
    }

  // function to fetch market items
  function fetchMarketTokens() public view returns(MarketToken[] memory) {
    uint itemCount = _tokenIds.current();
    uint unsoldItemCount = _tokenIds.current() - _tokensSold.current();
    uint currentIndex = 0;

    // looping over number of items created. If number has not been sold populate the array
    MarketToken[] memory items = new MarketToken[](unsoldItemCount);

    for(uint i=0; i < itemCount; i++) {
      if(idToMarketToken[i+1].owner == address(0)) {
        uint currentId = i + 1;
        MarketToken storage currentItem  = idToMarketToken[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  // retunr nts that the user has purchased
  function fetchMyNFTs() public view returns (MarketToken[] memory) {
    uint totalItemCount = _tokenIds.current();
    // a second counter for each individual user
    uint itemCount = 0;
    uint currentIndex = 0;

    for(uint i=0; i<totalItemCount; i++) {
      if(idToMarketToken[i + 1].owner == msg.sender) {
        itemCount += 1;
      }
    }

    // second loop to loop through the amount you have purchased with itemCount
    // check to see if the owner address is equal to msg.sender
    MarketToken[] memory items = new MarketToken[](itemCount);

    for(uint i=0; i< totalItemCount; i++) {
      if(idToMarketToken[i + 1].owner == msg.sender) {
        uint currentId = idToMarketToken[i + 1].itemId;
        // current array
        MarketToken storage currentItem = idToMarketToken[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  // function for returning an array of minted nfts
  function fetchItemsCreated() public view returns(MarketToken[] memory) {
    // instead of .owner it will return .seller
    uint totalItemCount = _tokenIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for(uint i=0; i<totalItemCount; i++) {
      if(idToMarketToken[i + 1].seller == msg.sender) {
        itemCount += 1;
      }
    }

    // second loop to loop through the amount you have purchased with itemCount
    // check to see if the owner address is equal to msg.sender
    MarketToken[] memory items = new MarketToken[](itemCount);

    for(uint i=0; i< totalItemCount; i++) {
      if(idToMarketToken[i + 1].seller == msg.sender) {
        uint currentId = idToMarketToken[i + 1].itemId;
        MarketToken storage currentItem = idToMarketToken[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
}

