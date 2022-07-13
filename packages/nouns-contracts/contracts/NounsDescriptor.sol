// SPDX-License-Identifier: GPL-3.0

/// @title The Nouns NFT descriptor

/*********************************
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░██░░░████░░██░░░████░░░ *
 * ░░██████░░░████████░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 *********************************/

pragma solidity ^0.8.6;

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { Strings } from '@openzeppelin/contracts/utils/Strings.sol';
import { INounsDescriptor } from './interfaces/INounsDescriptor.sol';
import { INounsSeeder } from './interfaces/INounsSeeder.sol';
import { NFTDescriptor } from './libs/NFTDescriptor.sol';
import { MultiPartRLEToSVG } from './libs/MultiPartRLEToSVG.sol';

contract NounsDescriptor is INounsDescriptor, Ownable {
    using Strings for uint256;

    // prettier-ignore
    // https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt
    bytes32 constant COPYRIGHT_CC0_1_0_UNIVERSAL_LICENSE = 0xa2010f343487d3f7618affe54f789f5487602331c0a8d03f49e9a7c547cf0499;

    // Whether or not new Noun parts can be added
    bool public override arePartsLocked;

    // Whether or not `tokenURI` should be returned as a data URI (Default: true)
    bool public override isDataURIEnabled = true;

    // Base URI
    string public override baseURI;

    // Noun Color Palettes (Index => Hex Colors)
    mapping(uint8 => string[]) public override palettes;

    // Noun Backgrounds (Hex Colors)
    string[] public override backgrounds;

    // Noun Hides (Custom RLE)
    bytes[] public override hides;

    // Noun Horns (Custom RLE)
    bytes[] public override horns;

    // Noun Heads (Custom RLE)
    bytes[] public override heads;

    // Noun Outfits (Custom RLE)
    bytes[] public override outfits;

    // Noun Eyes (Custom RLE)
    bytes[] public override eyes;

    // Noun Snouts (Custom RLE)
    bytes[] public override snouts;

    /**
     * @notice Require that the parts have not been locked.
     */
    modifier whenPartsNotLocked() {
        require(!arePartsLocked, 'Parts are locked');
        _;
    }

    /**
     * @notice Get the number of available Noun `backgrounds`.
     */
    function backgroundCount() external view override returns (uint256) {
        return backgrounds.length;
    }

    /**
     * @notice Get the number of available Noun `hides`.
     */
    function hideCount() external view override returns (uint256) {
        return hides.length;
    }

    /**
     * @notice Get the number of available Noun `horns`.
     */
    function hornsCount() external view override returns (uint256) {
        return horns.length;
    }

    /**
     * @notice Get the number of available Noun `heads`.
     */
    function headCount() external view override returns (uint256) {
        return heads.length;
    }

    /**
     * @notice Get the number of available Noun `outfits`.
     */
    function outfitCount() external view override returns (uint256) {
        return outfits.length;
    }

    /**
     * @notice Get the number of available Noun `eyes`.
     */
    function eyesCount() external view override returns (uint256) {
        return eyes.length;
    }

    /**
     * @notice Get the number of available Noun `snouts`.
     */
    function snoutCount() external view override returns (uint256) {
        return snouts.length;
    }

    /**
     * @notice Add colors to a color palette.
     * @dev This function can only be called by the owner.
     */
    function addManyColorsToPalette(uint8 paletteIndex, string[] calldata newColors) external override onlyOwner {
        require(palettes[paletteIndex].length + newColors.length <= 256, 'Palettes can only hold 256 colors');
        for (uint256 i = 0; i < newColors.length; i++) {
            _addColorToPalette(paletteIndex, newColors[i]);
        }
    }

    /**
     * @notice Batch add Noun backgrounds.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyBackgrounds(string[] calldata _backgrounds) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _backgrounds.length; i++) {
            _addBackground(_backgrounds[i]);
        }
    }

    /**
     * @notice Batch add Noun hides.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyHides(bytes[] calldata _hides) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _hides.length; i++) {
            _addHide(_hides[i]);
        }
    }

    /**
     * @notice Batch add Noun horns.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyHorns(bytes[] calldata _horns) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _horns.length; i++) {
            _addHorns(_horns[i]);
        }
    }

    /**
     * @notice Batch add Noun heads.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyHeads(bytes[] calldata _heads) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _heads.length; i++) {
            _addHead(_heads[i]);
        }
    }

    /**
     * @notice Batch add Noun outfits.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyOutfits(bytes[] calldata _outfits) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _outfits.length; i++) {
            _addOutfit(_outfits[i]);
        }
    }

    /**
     * @notice Batch add Noun eyes.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyEyes(bytes[] calldata _eyes) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _eyes.length; i++) {
            _addEyes(_eyes[i]);
        }
    }

    /**
     * @notice Batch add Noun snouts.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManySnouts(bytes[] calldata _snouts) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _snouts.length; i++) {
            _addSnout(_snouts[i]);
        }
    }

    /**
     * @notice Add a single color to a color palette.
     * @dev This function can only be called by the owner.
     */
    function addColorToPalette(uint8 _paletteIndex, string calldata _color) external override onlyOwner {
        require(palettes[_paletteIndex].length <= 255, 'Palettes can only hold 256 colors');
        _addColorToPalette(_paletteIndex, _color);
    }

    /**
     * @notice Add a Noun background.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackground(string calldata _background) external override onlyOwner whenPartsNotLocked {
        _addBackground(_background);
    }

    /**
     * @notice Add a Noun hide.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHide(bytes calldata _hide) external override onlyOwner whenPartsNotLocked {
        _addHide(_hide);
    }

    /**
     * @notice Add a Noun horns.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHorns(bytes calldata _horns) external override onlyOwner whenPartsNotLocked {
        _addHorns(_horns);
    }

    /**
     * @notice Add a Noun head.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHead(bytes calldata _head) external override onlyOwner whenPartsNotLocked {
        _addHead(_head);
    }

    /**
     * @notice Add a Noun outfit.
     * @dev This function can only be called by the owner when not locked.
     */
    function addOutfit(bytes calldata _outfit) external override onlyOwner whenPartsNotLocked {
        _addOutfit(_outfit);
    }

    /**
     * @notice Add a Noun eyes.
     * @dev This function can only be called by the owner when not locked.
     */
    function addEyes(bytes calldata _eyes) external override onlyOwner whenPartsNotLocked {
        _addEyes(_eyes);
    }

    /**
     * @notice Add Noun snout.
     * @dev This function can only be called by the owner when not locked.
     */
    function addSnout(bytes calldata _snout) external override onlyOwner whenPartsNotLocked {
        _addSnout(_snout);
    }

    /**
     * @notice Lock all Noun parts.
     * @dev This cannot be reversed and can only be called by the owner when not locked.
     */
    function lockParts() external override onlyOwner whenPartsNotLocked {
        arePartsLocked = true;

        emit PartsLocked();
    }

    /**
     * @notice Toggle a boolean value which determines if `tokenURI` returns a data URI
     * or an HTTP URL.
     * @dev This can only be called by the owner.
     */
    function toggleDataURIEnabled() external override onlyOwner {
        bool enabled = !isDataURIEnabled;

        isDataURIEnabled = enabled;
        emit DataURIToggled(enabled);
    }

    /**
     * @notice Set the base URI for all token IDs. It is automatically
     * added as a prefix to the value returned in {tokenURI}, or to the
     * token ID if {tokenURI} is empty.
     * @dev This can only be called by the owner.
     */
    function setBaseURI(string calldata _baseURI) external override onlyOwner {
        baseURI = _baseURI;

        emit BaseURIUpdated(_baseURI);
    }

    /**
     * @notice Given a token ID and seed, construct a token URI for an official Nouns DAO noun.
     * @dev The returned value may be a base64 encoded data URI or an API URL.
     */
    function tokenURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view override returns (string memory) {
        if (isDataURIEnabled) {
            return dataURI(tokenId, seed);
        }
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    /**
     * @notice Given a token ID and seed, construct a base64 encoded data URI for an official Nouns DAO noun.
     */
    function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed) public view override returns (string memory) {
        string memory nounId = tokenId.toString();
        string memory name = string(abi.encodePacked('Noun ', nounId));
        string memory description = string(abi.encodePacked('Noun ', nounId, ' is a member of the Nouns DAO'));

        return genericDataURI(name, description, seed);
    }

    /**
     * @notice Given a name, description, and seed, construct a base64 encoded data URI.
     */
    function genericDataURI(
        string memory name,
        string memory description,
        INounsSeeder.Seed memory seed
    ) public view override returns (string memory) {
        NFTDescriptor.TokenURIParams memory params = NFTDescriptor.TokenURIParams({
            name: name,
            description: description,
            parts: _getPartsForSeed(seed),
            background: backgrounds[seed.background]
        });
        return NFTDescriptor.constructTokenURI(params, palettes);
    }

    /**
     * @notice Given a seed, construct a base64 encoded SVG image.
     */
    function generateSVGImage(INounsSeeder.Seed memory seed) external view override returns (string memory) {
        MultiPartRLEToSVG.SVGParams memory params = MultiPartRLEToSVG.SVGParams({
            parts: _getPartsForSeed(seed),
            background: backgrounds[seed.background]
        });
        return NFTDescriptor.generateSVGImage(params, palettes);
    }

    /**
     * @notice Add a single color to a color palette.
     */
    function _addColorToPalette(uint8 _paletteIndex, string calldata _color) internal {
        palettes[_paletteIndex].push(_color);
    }

    /**
     * @notice Add a Noun background.
     */
    function _addBackground(string calldata _background) internal {
        backgrounds.push(_background);
    }

    /**
     * @notice Add a Noun hide.
     */
    function _addHide(bytes calldata _hide) internal {
        hides.push(_hide);
    }

    /**
     * @notice Add a Noun horns.
     */
    function _addHorns(bytes calldata _horns) internal {
        horns.push(_horns);
    }

    /**
     * @notice Add a Noun head.
     */
    function _addHead(bytes calldata _head) internal {
        heads.push(_head);
    }

    /**
     * @notice Add a Noun outfit.
     */
    function _addOutfit(bytes calldata _outfit) internal {
        outfits.push(_outfit);
    }

    /**
     * @notice Add a Noun head.
     */
    function _addEyes(bytes calldata _eyes) internal {
        eyes.push(_eyes);
    }

    /**
     * @notice Add Noun snout.
     */
    function _addSnout(bytes calldata _snout) internal {
        snouts.push(_snout);
    }

    /**
     * @notice Get all Noun parts for the passed `seed`.
     */
    function _getPartsForSeed(INounsSeeder.Seed memory seed) internal view returns (bytes[] memory) {
        bytes[] memory _parts = new bytes[](4);
        _parts[0] = hides[seed.hide];
        _parts[1] = horns[seed.horns];
        _parts[2] = heads[seed.head];
        _parts[3] = outfits[seed.outfit];
        _parts[4] = eyes[seed.eyes];
        _parts[5] = snouts[seed.snout];
        return _parts;
    }
}
