// SEE VIDEO 15

//SPDX-Liceense-Identifier: MIT
pragma solidity ^0.8.4;

// openzeppelin ERC721
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract NFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  // counters allow us to keep track of tokenIds
  // address of marketplace for NFT's to interact
  address contractAddress;

  // OBJ: give the nft market the ability to transact with tokens or change ownership
  // setApprovalForAll allows us to do that with contract address

  // constructir set up our address
  constructor(address marketplaceAddress) ERC721('KryptoBirdz', 'KBIRDZ') {
    contractAddress = marketplaceAddress;
  }

  function mintToken(string memory tokenURI) public returns(uint) {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    // passing in Id and url
    _mint(msg.sender, newItemId);

    //set token URI: id and url
    _setTokenURI(newItemId, tokenURI);

    // give the marketplace the approval to transact between users
    setApprovalForAll(contractAddress, true);

    //mint the token and set it for sale - return the id to do so
    return newItemId;
  }
}
