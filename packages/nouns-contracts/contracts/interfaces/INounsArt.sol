// SPDX-License-Identifier: GPL-3.0

/// @title Interface for NounsArt

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

import { Inflate } from '../libs/Inflate.sol';
import { IInflator } from './IInflator.sol';

interface INounsArt {
    error SenderIsNotDescriptor();

    error EmptyPalette();

    error BadPaletteLength();

    error EmptyBytes();

    error BadDecompressedLength();

    error BadImageCount();

    error ImageNotFound();

    error PaletteNotFound();

    event DescriptorUpdated(address oldDescriptor, address newDescriptor);

    event InflatorUpdated(address oldInflator, address newInflator);

    event BackgroundsAdded(uint256 count);

    event PaletteSet(uint8 paletteIndex);

    event HidesAdded(uint16 count);

    event HornsAdded(uint16 count);

    event HeadsAdded(uint16 count);

    event OutfitsAdded(uint16 count);

    event EyesAdded(uint16 count);

    event SnoutsAdded(uint16 count);

    struct NounArtStoragePage {
        uint16 imageCount;
        uint80 decompressedLength;
        address pointer;
    }

    struct Trait {
        NounArtStoragePage[] storagePages;
        uint256 storedImagesCount;
    }

    function descriptor() external view returns (address);

    function inflator() external view returns (IInflator);

    function setDescriptor(address descriptor) external;

    function setInflator(IInflator inflator) external;

    function addManyBackgrounds(string[] calldata _backgrounds) external;

    function addBackground(string calldata _background) external;

    function palettes(uint8 paletteIndex) external view returns (bytes memory);

    function setPalette(uint8 paletteIndex, bytes calldata palette) external;

    function addHides(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHorns(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHeads(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addOutfits(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addEyes(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addSnouts(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function setPalettePointer(uint8 paletteIndex, address pointer) external;

    function addHidesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHornsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHeadsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addOutfitsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addEyesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addSnoutsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function backgroundsCount() external view returns (uint256);

    function backgrounds(uint256 index) external view returns (string memory);

    function hides(uint256 index) external view returns (bytes memory);

    function horns(uint256 index) external view returns (bytes memory);

    function heads(uint256 index) external view returns (bytes memory);

    function outfits(uint256 index) external view returns (bytes memory);

    function eyes(uint256 index) external view returns (bytes memory);

    function snouts(uint256 index) external view returns (bytes memory);

    function getHidesTrait() external view returns (Trait memory);

    function getHornsTrait() external view returns (Trait memory);

    function getHeadsTrait() external view returns (Trait memory);

    function getOutfitsTrait() external view returns (Trait memory);

    function getEyesTrait() external view returns (Trait memory);

    function getSnoutsTrait() external view returns (Trait memory);
}
