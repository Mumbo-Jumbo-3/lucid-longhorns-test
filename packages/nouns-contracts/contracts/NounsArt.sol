// SPDX-License-Identifier: GPL-3.0

/// @title The Nouns art storage contract

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

import { INounsArt } from './interfaces/INounsArt.sol';
import { SSTORE2 } from './libs/SSTORE2.sol';
import { IInflator } from './interfaces/IInflator.sol';

contract NounsArt is INounsArt {
    /// @notice Current Nouns Descriptor address
    address public override descriptor;

    /// @notice Current inflator address
    IInflator public override inflator;

    /// @notice Noun Backgrounds (Hex Colors)
    string[] public override backgrounds;

    /// @notice Noun Color Palettes (Index => Hex Colors, stored as a contract using SSTORE2)
    mapping(uint8 => address) public palettesPointers;

    /// @notice Noun Hides Trait
    Trait public hidesTrait;

    /// @notice Noun Horns Trait
    Trait public hornsTrait;

    /// @notice Noun Heads Trait
    Trait public headsTrait;

    /// @notice Noun Outfits Trait
    Trait public outfitsTrait;

    /// @notice Noun Eyes Trait
    Trait public eyesTrait;

    /// @notice Noun Snouts Trait
    Trait public snoutsTrait;

    /**
     * @notice Require that the sender is the descriptor.
     */
    modifier onlyDescriptor() {
        if (msg.sender != descriptor) {
            revert SenderIsNotDescriptor();
        }
        _;
    }

    constructor(address _descriptor, IInflator _inflator) {
        descriptor = _descriptor;
        inflator = _inflator;
    }

    /**
     * @notice Set the descriptor.
     * @dev This function can only be called by the current descriptor.
     */
    function setDescriptor(address _descriptor) external override onlyDescriptor {
        address oldDescriptor = descriptor;
        descriptor = _descriptor;

        emit DescriptorUpdated(oldDescriptor, descriptor);
    }

    /**
     * @notice Set the inflator.
     * @dev This function can only be called by the descriptor.
     */
    function setInflator(IInflator _inflator) external override onlyDescriptor {
        address oldInflator = address(inflator);
        inflator = _inflator;

        emit InflatorUpdated(oldInflator, address(_inflator));
    }

    /**
     * @notice Get the Trait struct for hides.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getHidesTrait() external view override returns (Trait memory) {
        return hidesTrait;
    }

    /**
     * @notice Get the Trait struct for horns.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getHornsTrait() external view override returns (Trait memory) {
        return hornsTrait;
    }

    /**
     * @notice Get the Trait struct for heads.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getHeadsTrait() external view override returns (Trait memory) {
        return headsTrait;
    }

    /**
     * @notice Get the Trait struct for outfits.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getOutfitsTrait() external view override returns (Trait memory) {
        return outfitsTrait;
    }

    /**
     * @notice Get the Trait struct for eyes.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getEyesTrait() external view override returns (Trait memory) {
        return eyesTrait;
    }

    /**
     * @notice Get the Trait struct for snouts.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getSnoutsTrait() external view override returns (Trait memory) {
        return snoutsTrait;
    }

    /**
     * @notice Batch add Noun backgrounds.
     * @dev This function can only be called by the descriptor.
     */
    function addManyBackgrounds(string[] calldata _backgrounds) external override onlyDescriptor {
        for (uint256 i = 0; i < _backgrounds.length; i++) {
            _addBackground(_backgrounds[i]);
        }

        emit BackgroundsAdded(_backgrounds.length);
    }

    /**
     * @notice Add a Noun background.
     * @dev This function can only be called by the descriptor.
     */
    function addBackground(string calldata _background) external override onlyDescriptor {
        _addBackground(_background);

        emit BackgroundsAdded(1);
    }

    /**
     * @notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette.
     * @param paletteIndex the identifier of this palette
     * @param palette byte array of colors. every 3 bytes represent an RGB color. max length: 256 * 3 = 768
     * @dev This function can only be called by the descriptor.
     */
    function setPalette(uint8 paletteIndex, bytes calldata palette) external override onlyDescriptor {
        if (palette.length == 0) {
            revert EmptyPalette();
        }
        if (palette.length % 3 != 0 || palette.length > 768) {
            revert BadPaletteLength();
        }
        palettesPointers[paletteIndex] = SSTORE2.write(palette);

        emit PaletteSet(paletteIndex);
    }

    /**
     * @notice Add a batch of hide images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHides(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hidesTrait, encodedCompressed, decompressedLength, imageCount);

        emit HidesAdded(imageCount);
    }

    /**
     * @notice Add a batch of horns images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHorns(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hornsTrait, encodedCompressed, decompressedLength, imageCount);

        emit HornsAdded(imageCount);
    }

    /**
     * @notice Add a batch of head images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHeads(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(headsTrait, encodedCompressed, decompressedLength, imageCount);

        emit HeadsAdded(imageCount);
    }

    /**
     * @notice Add a batch of outfit images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addOutfits(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(outfitsTrait, encodedCompressed, decompressedLength, imageCount);

        emit OutfitsAdded(imageCount);
    }

    /**
     * @notice Add a batch of eyes images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addEyes(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(eyesTrait, encodedCompressed, decompressedLength, imageCount);

        emit EyesAdded(imageCount);
    }

    /**
     * @notice Add a batch of snouts images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addSnouts(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(snoutsTrait, encodedCompressed, decompressedLength, imageCount);

        emit SnoutsAdded(imageCount);
    }

    /**
     * @notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette. This function does not check for data length validity
     * (len <= 768, len % 3 == 0).
     * @param paletteIndex the identifier of this palette
     * @param pointer the address of the contract holding the palette bytes. every 3 bytes represent an RGB color.
     * max length: 256 * 3 = 768.
     * @dev This function can only be called by the descriptor.
     */
    function setPalettePointer(uint8 paletteIndex, address pointer) external override onlyDescriptor {
        palettesPointers[paletteIndex] = pointer;

        emit PaletteSet(paletteIndex);
    }

    /**
     * @notice Add a batch of hide images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHidesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hidesTrait, pointer, decompressedLength, imageCount);

        emit HidesAdded(imageCount);
    }

    /**
     * @notice Add a batch of horns images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches
     * @dev This function can only be called by the descriptor..
     */
    function addHornsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hornsTrait, pointer, decompressedLength, imageCount);

        emit HornsAdded(imageCount);
    }

    /**
     * @notice Add a batch of head images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches
     * @dev This function can only be called by the descriptor..
     */
    function addHeadsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(headsTrait, pointer, decompressedLength, imageCount);

        emit HeadsAdded(imageCount);
    }

    /**
     * @notice Add a batch of outfit images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addOutfitsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(outfitsTrait, pointer, decompressedLength, imageCount);

        emit OutfitsAdded(imageCount);
    }

    /**
     * @notice Add a batch of eyes images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches
     * @dev This function can only be called by the descriptor..
     */
    function addEyesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(eyesTrait, pointer, decompressedLength, imageCount);

        emit EyesAdded(imageCount);
    }

    /**
     * @notice Add a batch of snouts images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addSnoutsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(snoutsTrait, pointer, decompressedLength, imageCount);

        emit SnoutsAdded(imageCount);
    }

    /**
     * @notice Get the number of available Noun `backgrounds`.
     */
    function backgroundsCount() public view override returns (uint256) {
        return backgrounds.length;
    }

    /**
     * @notice Get a hide image bytes (RLE-encoded).
     */
    function hides(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(hidesTrait, index);
    }

    /**
     * @notice Get a horns image bytes (RLE-encoded).
     */
    function horns(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(hornsTrait, index);
    }

    /**
     * @notice Get a head image bytes (RLE-encoded).
     */
    function heads(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(headsTrait, index);
    }

    /**
     * @notice Get a outfit image bytes (RLE-encoded).
     */
    function outfits(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(outfitsTrait, index);
    }

    /**
     * @notice Get a eyes image bytes (RLE-encoded).
     */
    function eyes(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(eyesTrait, index);
    }

    /**
     * @notice Get a snout image bytes (RLE-encoded).
     */
    function snouts(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(snoutsTrait, index);
    }

    /**
     * @notice Get a color palette bytes.
     */
    function palettes(uint8 paletteIndex) public view override returns (bytes memory) {
        address pointer = palettesPointers[paletteIndex];
        if (pointer == address(0)) {
            revert PaletteNotFound();
        }
        return SSTORE2.read(palettesPointers[paletteIndex]);
    }

    function _addBackground(string calldata _background) internal {
        backgrounds.push(_background);
    }

    function addPage(
        Trait storage trait,
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) internal {
        if (encodedCompressed.length == 0) {
            revert EmptyBytes();
        }
        address pointer = SSTORE2.write(encodedCompressed);
        addPage(trait, pointer, decompressedLength, imageCount);
    }

    function addPage(
        Trait storage trait,
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) internal {
        if (decompressedLength == 0) {
            revert BadDecompressedLength();
        }
        if (imageCount == 0) {
            revert BadImageCount();
        }
        trait.storagePages.push(
            NounArtStoragePage({ pointer: pointer, decompressedLength: decompressedLength, imageCount: imageCount })
        );
        trait.storedImagesCount += imageCount;
    }

    function imageByIndex(INounsArt.Trait storage trait, uint256 index) internal view returns (bytes memory) {
        (INounsArt.NounArtStoragePage storage page, uint256 indexInPage) = getPage(trait.storagePages, index);
        bytes[] memory decompressedImages = decompressAndDecode(page);
        return decompressedImages[indexInPage];
    }

    /**
     * @dev Given an image index, this function finds the storage page the image is in, and the relative index
     * inside the page, so the image can be read from storage.
     * Example: if you have 2 pages with 100 images each, and you want to get image 150, this function would return
     * the 2nd page, and the 50th index.
     * @return INounsArt.NounArtStoragePage the page containing the image at index
     * @return uint256 the index of the image in the page
     */
    function getPage(INounsArt.NounArtStoragePage[] storage pages, uint256 index)
        internal
        view
        returns (INounsArt.NounArtStoragePage storage, uint256)
    {
        uint256 len = pages.length;
        uint256 pageFirstImageIndex = 0;
        for (uint256 i = 0; i < len; i++) {
            INounsArt.NounArtStoragePage storage page = pages[i];

            if (index < pageFirstImageIndex + page.imageCount) {
                return (page, index - pageFirstImageIndex);
            }

            pageFirstImageIndex += page.imageCount;
        }

        revert ImageNotFound();
    }

    function decompressAndDecode(INounsArt.NounArtStoragePage storage page) internal view returns (bytes[] memory) {
        bytes memory compressedData = SSTORE2.read(page.pointer);
        (, bytes memory decompressedData) = inflator.puff(compressedData, page.decompressedLength);
        return abi.decode(decompressedData, (bytes[]));
    }
}
