import { keccak256 as solidityKeccak256 } from '@ethersproject/solidity';
import { BigNumber, BigNumberish } from '@ethersproject/bignumber';
import { NounSeed, NounData } from './types';
import { images, bgcolors } from './image-data.json';

const { hides, horns, heads, outfits, eyes, snouts } = images;

/**
 * Get encoded part and background information using a Noun seed
 * @param seed The Noun seed
 */
export const getNounData = (seed: NounSeed): NounData => {
  return {
    parts: [
      hides[seed.hide],
      horns[seed.horns],
      heads[seed.head],
      outfits[seed.outfit],
      eyes[seed.eyes],
      snouts[seed.snout],
    ],
    background: bgcolors[seed.background],
  };
};

/**
 * Generate a random Noun seed
 * @param seed The Noun seed
 */
export const getRandomNounSeed = (): NounSeed => {
  return {
    background: Math.floor(Math.random() * bgcolors.length),
    hide: Math.floor(Math.random() * hides.length),
    horns: Math.floor(Math.random() * horns.length),
    head: Math.floor(Math.random() * heads.length),
    outfit: Math.floor(Math.random() * outfits.length),
    eyes: Math.floor(Math.random() * eyes.length),
    snout: Math.floor(Math.random() * snouts.length),
  };
};

/**
 * Emulate bitwise right shift and uint cast
 * @param value A Big Number
 * @param shiftAmount The amount to right shift
 * @param uintSize The uint bit size to cast to
 */
export const shiftRightAndCast = (
  value: BigNumberish,
  shiftAmount: number,
  uintSize: number,
): string => {
  const shifted = BigNumber.from(value).shr(shiftAmount).toHexString();
  return `0x${shifted.substring(shifted.length - uintSize / 4)}`;
};

/**
 * Emulates the NounsSeeder.sol methodology for pseudorandomly selecting a part
 * @param pseudorandomness Hex representation of a number
 * @param partCount The number of parts to pseudorandomly choose from
 * @param shiftAmount The amount to right shift
 * @param uintSize The size of the unsigned integer
 */
export const getPseudorandomPart = (
  pseudorandomness: string,
  partCount: number,
  shiftAmount: number,
  uintSize: number = 48,
): number => {
  const hex = shiftRightAndCast(pseudorandomness, shiftAmount, uintSize);
  return BigNumber.from(hex).mod(partCount).toNumber();
};

/**
 * Emulates the NounsSeeder.sol methodology for generating a Noun seed
 * @param nounId The Noun tokenId used to create pseudorandomness
 * @param blockHash The block hash use to create pseudorandomness
 */
export const getNounSeedFromBlockHash = (nounId: BigNumberish, blockHash: string): NounSeed => {
  const pseudorandomness = solidityKeccak256(['bytes32', 'uint256'], [blockHash, nounId]);
  return {
    background: getPseudorandomPart(pseudorandomness, bgcolors.length, 0),
    hide: getPseudorandomPart(pseudorandomness, hides.length, 48),
    horns: getPseudorandomPart(pseudorandomness, horns.length, 96),
    head: getPseudorandomPart(pseudorandomness, heads.length, 144),
    outfit: getPseudorandomPart(pseudorandomness, outfits.length, 192),
    eyes: getPseudorandomPart(pseudorandomness, eyes.length, 240),
    snout: getPseudorandomPart(pseudorandomness, snouts.length, 288),
  };
};
