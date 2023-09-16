// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/draft-ERC721VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract Cyclops is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, PausableUpgradeable, OwnableUpgradeable, ERC721BurnableUpgradeable, EIP712Upgradeable, ERC721VotesUpgradeable {

    /**
     * New tokens will be automatically assigned an incremental id.
     */
    using CountersUpgradeable for CountersUpgradeable.Counter;

    /**
     */
    using SafeMathUpgradeable for uint256;


    /**
     * VARIABLES
     */

    /**
     * New tokens will be automatically assigned an incremental id.
     */
    CountersUpgradeable.Counter private _tokenIdCounter;

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    string private _baseURIPrefix;

    /**
     * Open sea metadata URI
     */
    string private _metadataURI;

    /**
     * EIP-2981 royalties
     */
    bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;

    /**
     * Rarible royalties
     */
    bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;

    /**
     * Royalties
     */
    uint256 private _royaltyBps;
    address payable private _royaltyRecipient;

    /**
     * Max tokens per transaction
     */
    uint256 private _maxTokensPerTransaction;

    /**
     * Token price
     */
    uint256 private _tokenPrice;

    /**
     * Token price
     */
    uint256 private _totalTokens;
    uint256 private _totalTokensBuyable;

    struct Property{
        string name;
        uint256 index;
    }
    mapping(uint256 => Property[]) _properties;


    /**
     * EVENTS
     */
    event MaxTokensPerTransaction(uint256 amount);
    event TokenPrice(uint256 amount);
    event Buy(uint256 amount);
    event TotalTokens(uint256 amount);
    event TotalTokensBuyable(uint256 amount);
    event Pause();
    event Unpause();
    event Properties(Property[] properties);


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * Initialize
     */
    function initialize() initializer public {
        __ERC721_init("Cyclops", "CYP");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __Ownable_init();
        __ERC721Burnable_init();
        __EIP712_init("Cyclops", "1");
        __ERC721Votes_init();

        _tokenIdCounter.increment();

        setBaseURI("https://cryptixel.art/api/v1/collection/cyclops/");
        setContractURI("https://cryptixel.art/api/v1/collection/cyclops/contract.js");

        setRoyaltyBps(1000);
        setRoyaltyRecipient(payable(msg.sender));

        setMaxTokensPerTransaction(1);
        setTokenPrice(0.000175*10**18);

        setTotalTokens(50000);
        setTotalTokensBuyable(50000);

        pause();
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view override returns (string memory) {
        return _baseURIPrefix;
    }

    function setBaseURI(string memory baseURIPrefix) public onlyOwner {
        _baseURIPrefix = baseURIPrefix;
    }

    function contractURI() public view returns (string memory) {
        return _metadataURI;
    }

    function setContractURI(string memory metadataURI) public onlyOwner {
        _metadataURI = metadataURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable) returns (string memory) {
        return super.tokenURI(tokenId);
    }


    /**
    * @dev Contract module which allows children to implement an emergency stop
    * mechanism that can be triggered by an authorized account.
    */
    function pause() public onlyOwner {
        _pause();
        emit Pause();
    }

    function unpause() public onlyOwner {
        _unpause();
        emit Unpause();
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     */
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal whenNotPaused override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     */
    function _afterTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721Upgradeable, ERC721VotesUpgradeable) {
        super._afterTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     */
    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool) {
        return interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE || interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981 || super.supportsInterface(interfaceId);
    }

    /**
     * Rarible royalties
     */
    function getRoyalties(uint256) external view returns (address payable[] memory recipients, uint256[] memory bps) {
        if (_royaltyRecipient != address(0x0)) {
            recipients = new address payable[](1);
            recipients[0] = _royaltyRecipient;
            bps = new uint256[](1);
            bps[0] = _royaltyBps;
        }
        return (recipients, bps);
    }

    function getFeeRecipients(uint256) external view returns (address payable[] memory recipients) {
        if (_royaltyRecipient != address(0x0)) {
            recipients = new address payable[](1);
            recipients[0] = _royaltyRecipient;
        }
        return recipients;
    }

    function getFeeBps(uint256) external view returns (uint[] memory bps) {
        if (_royaltyRecipient != address(0x0)) {
            bps = new uint256[](1);
            bps[0] = _royaltyBps;
        }
        return bps;
    }

    /**
     * EIP-2981 royalties
     */
    function royaltyInfo(uint256, uint256 value) external view returns (address, uint256) {
        return (_royaltyRecipient, value * _royaltyBps / 10000);
    }

    function setRoyaltyBps(uint256 royaltyBps) public onlyOwner {
        _royaltyBps = royaltyBps;
    }

    function setRoyaltyRecipient(address payable royaltyRecipient) public onlyOwner {
        _royaltyRecipient = royaltyRecipient;
    }

    /**
     * Max tokens per transaction
     */
    function getMaxTokensPerTransaction() public view returns (uint256) {
        return _maxTokensPerTransaction;
    }

    function setMaxTokensPerTransaction(uint256 amount) public onlyOwner {
        _maxTokensPerTransaction = amount;
        emit MaxTokensPerTransaction(_maxTokensPerTransaction);
    }

    /**
     * Token price
     */
    function getTokenPrice() public view returns (uint256){
        return _tokenPrice;
    }

    function setTokenPrice(uint256 amount) public onlyOwner {
        _tokenPrice = amount;
        emit TokenPrice(_tokenPrice);
    }

    /**
     * Buy token
     */
    function buy(uint256 amount, Property[] memory properties) whenNotPaused public payable {
        require(amount > 0, "Cyclops: Token number must be higher than 0");
        require(amount <= _maxTokensPerTransaction, "Cyclops: Max tokens per transaction number exceeded");
        require(_tokenIdCounter.current().add(amount) <= _totalTokensBuyable + 1, "Cyclops: Tokens number to mint exceeds number of buyable tokens");
        require(_tokenPrice.mul(amount) <= msg.value, "Cyclops: Ether value sent is too low");

        for(uint256 i = 0; i < amount; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);

            uint length = properties.length;
            for (uint256 j = 0; j < length; j++) {
                _properties[tokenId].push(Property(properties[j].name, properties[j].index));
            }
            emit Properties(_properties[tokenId]);
        }
        emit Buy(amount);
    }

    /**
     * Direct mint
     */
    function directMint(address to, uint256 tokenId) public onlyOwner {
        require(tokenId > _totalTokensBuyable, "Cyclops: Tokens number to mint must exceed number of buyable tokens");
        _safeMint(to, tokenId);
    }

    /**
     * Total token
     */
    function getTotalTokens() public view returns (uint256){
        return _totalTokens;
    }

    function setTotalTokens(uint256 amount) public onlyOwner {
        require(amount >= _totalTokensBuyable, "Cyclops: Total tokens must be equal or higher than buyable tokens");
        _totalTokens = amount;
        emit TotalTokens(_totalTokens);
    }

    /**
     * Total token buyable
     */
    function getTotalTokensBuyable() public view returns (uint256){
        return _totalTokensBuyable;
    }

    function setTotalTokensBuyable(uint256 amount) public onlyOwner {
        require(amount <= _totalTokens, "Cyclops: Buyable tokens must be equal or less than total tokens");
        _totalTokensBuyable = amount;
        emit TotalTokensBuyable(_totalTokensBuyable);
    }

    /**
     * Current token ID
     */
    function getTokenIdCounter() public view returns (uint256){
        return _tokenIdCounter.current();
    }

    /**
     * Withdraw
     */
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    /**
     * Properties
     */
    function getProperties(uint256 index) public view returns (Property[] memory){
        return _properties[index];
    }

    function setProperties(uint256 index, Property[] memory properties) public onlyOwner {
        uint length = properties.length;
        delete _properties[index];
        for (uint i = 0; i < length; i++) {
            _properties[index].push(Property(properties[i].name, properties[i].index));
        }
        emit Properties(_properties[index]);
    }
}
