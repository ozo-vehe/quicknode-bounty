// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Anime Card Smart Contract
/// @author John Obansa
/// @notice A smarty contract for minting anime cards

contract AnimeCard is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    constructor() ERC721("AnimeCard", "ACN") {}

    using Counters for Counters.Counter;
    Counters.Counter private anime_counter;

    struct Card {
        address payable owner;
        string char_name;
        uint256 token_id;
        bool removed;
    }

    mapping(uint256 => Card) internal cards;

/// @notice a function for minting uploaded anime cards using the address and uri of the NFT to be minted
/// @dev mints an anime card image as an NFT
/// @param uri, the url of the anime card image to be minted
/// @param to, the address which the NFT is to be minted to
    function safeMint(address to, string memory uri) onlyOwner internal {
        require(anime_counter.current() <= 10, "Sorry, you can only mint 10 Anime NFT cards");

        _safeMint(to, anime_counter.current());
        _setTokenURI(anime_counter.current(), uri);

        anime_counter.increment();
    }


/// @dev takes three parameters as arguments, saves them in the cards mapping with their length as a key
/// @param _char_name, the character name of the anime card uploaded
/// @param _image_uri, the image uri of the anime card uploaded
    function uploadCard (
        string memory _char_name,
        string memory _image_uri
    ) external {
        uint256 _length = totalSupply();
        uint256 _token_id = anime_counter.current();
        bool _removed = false;

        cards[_length] = Card (
            payable(msg.sender),
            _char_name,
            _token_id,
            _removed
        );
        
        safeMint(msg.sender, _image_uri);
    }


/// @notice a function to read the values of a stored anime card
/// @dev uses the token_id of an anime card which corresponds to the index in the cards mapping
/// @param _token_id, token_id of the anime card whose values is to read
/// @return anime card, with it's stored values
    function getCard (uint256 _token_id) external view returns (
        address payable,
        string memory,
        uint256,
        bool
    ) {
        return (
            cards[_token_id].owner,
            cards[_token_id].char_name,
            cards[_token_id].token_id,
            cards[_token_id].removed
        );
    }   
    
// The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
