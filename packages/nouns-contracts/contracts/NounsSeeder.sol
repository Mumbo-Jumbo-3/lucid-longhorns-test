// SPDX-License-Identifier: GPL-3.0

/// @title The NounsToken pseudo-random seed generator

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

import { INounsSeeder } from './interfaces/INounsSeeder.sol';
import { INounsDescriptor } from './interfaces/INounsDescriptor.sol';

contract NounsSeeder is INounsSeeder {
    /**
     * @notice Generate a pseudo-random Noun seed using the previous blockhash and noun ID.
     */
    // prettier-ignore
    function generateSeed(uint256 nounId, INounsDescriptor descriptor) external view override returns (Seed memory) {
        uint256 pseudorandomness = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), nounId))
        );

        uint256 backgroundCount = descriptor.backgroundCount();
        uint256 hideCount = descriptor.hideCount();
        uint256 hornsCount = descriptor.hornsCount();
        uint256 headCount = descriptor.headCount();
        uint256 outfitCount = descriptor.outfitCount();
        uint256 eyesCount = descriptor.eyesCount();
        uint256 snoutCount = descriptor.snoutCount();

        return Seed({
            background: uint48(
                uint48(pseudorandomness) % backgroundCount
            ),
            hide: uint48(
                uint48(pseudorandomness >> 48) % hideCount
            ),
            horns: uint48(
                uint48(pseudorandomness >> 96) % hornsCount
            ),
            head: uint48(
                uint48(pseudorandomness >> 144) % headCount
            ),
            outfit: uint48(
                uint48(pseudorandomness >> 192) % outfitCount
            ),
            eyes: uint48(
                uint48(pseudorandomness >> 240) % eyesCount
            ),
            snout: uint48(
                uint48(pseudorandomness >> 288) % snoutCount
            )
        });
    }
}
