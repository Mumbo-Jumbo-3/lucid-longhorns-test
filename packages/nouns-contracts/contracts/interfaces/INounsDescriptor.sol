// SPDX-License-Identifier: GPL-3.0

/// @title Interface for NounsDescriptor

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

import { INounsSeeder } from './INounsSeeder.sol';
import { INounsDescriptorMinimal } from './INounsDescriptorMinimal.sol';

interface INounsDescriptor {
    event PartsLocked();

    event DataURIToggled(bool enabled);

    event BaseURIUpdated(string baseURI);

    function arePartsLocked() external returns (bool);

    function isDataURIEnabled() external returns (bool);

    function baseURI() external returns (string memory);

    function palettes(uint8 paletteIndex, uint256 colorIndex) external view returns (string memory);

    function backgrounds(uint256 index) external view returns (string memory);

    function hides(uint256 index) external view returns (bytes memory);

    function horns(uint256 index) external view returns (bytes memory);

    function heads(uint256 index) external view returns (bytes memory);

    function outfits(uint256 index) external view returns (bytes memory);

    function eyes(uint256 index) external view returns (bytes memory);

    function snouts(uint256 index) external view returns (bytes memory);

    function backgroundCount() external view returns (uint256);

    function hideCount() external view returns (uint256);

    function hornsCount() external view returns (uint256);

    function headCount() external view returns (uint256);

    function outfitCount() external view returns (uint256);

    function eyesCount() external view returns (uint256);

    function snoutCount() external view returns (uint256);

    function addManyColorsToPalette(uint8 paletteIndex, string[] calldata newColors) external;

    function addManyBackgrounds(string[] calldata backgrounds) external;

    function addManyHides(bytes[] calldata hides) external;

    function addManyHorns(bytes[] calldata horns) external;

    function addManyHeads(bytes[] calldata heads) external;

    function addManyOutfits(bytes[] calldata outfits) external;

    function addManyEyes(bytes[] calldata eyes) external;

    function addManySnouts(bytes[] calldata snouts) external;

    function addColorToPalette(uint8 paletteIndex, string calldata color) external;

    function addBackground(string calldata background) external;

    function addHide(bytes calldata hide) external;

    function addHorns(bytes calldata horns) external;

    function addHead(bytes calldata head) external;

    function addOutfit(bytes calldata outfit) external;

    function addEyes(bytes calldata eyes) external;

    function addSnout(bytes calldata snout) external;

    function lockParts() external;

    function toggleDataURIEnabled() external;

    function setBaseURI(string calldata baseURI) external;

    function tokenURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view override returns (string memory);

    function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view override returns (string memory);

    function genericDataURI(
        string calldata name,
        string calldata description,
        INounsSeeder.Seed memory seed
    ) external view returns (string memory);

    function generateSVGImage(INounsSeeder.Seed memory seed) external view returns (string memory);
}
