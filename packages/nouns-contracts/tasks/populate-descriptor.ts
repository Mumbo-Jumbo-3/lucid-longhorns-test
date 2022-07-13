import { task, types } from 'hardhat/config';
import ImageData from '../files/image-data.json';
import { chunkArray } from '../utils';

task('populate-descriptor', 'Populates the descriptor with color palettes and Noun parts')
  .addOptionalParam(
    'nftDescriptor',
    'The `NFTDescriptor` contract address',
    '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    types.string,
  )
  .addOptionalParam(
    'nounsDescriptor',
    'The `NounsDescriptor` contract address',
    '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512',
    types.string,
  )
  .setAction(async ({ nftDescriptor, nounsDescriptor }, { ethers }) => {
    const descriptorFactory = await ethers.getContractFactory('NounsDescriptor', {
      libraries: {
        NFTDescriptor: nftDescriptor,
      },
    });
    const descriptorContract = descriptorFactory.attach(nounsDescriptor);

    const { bgcolors, palette, images } = ImageData;
    const { hides, horns, heads, outfits, eyes, snouts } = images;

    // Chunk head and accessory population due to high gas usage
    await descriptorContract.addManyBackgrounds(bgcolors);
    await descriptorContract.addManyColorsToPalette(0, palette);
    await descriptorContract.addManyHides(hides.map(({ data }) => data));
    await descriptorContract.addManyHorns(horns.map(({ data }) => data));
    await descriptorContract.addManyHeads(heads.map(({ data }) => data));
    await descriptorContract.addManyOutfits(outfits.map(({ data }) => data));
    await descriptorContract.addManyEyes(eyes.map(({ data }) => data));
    await descriptorContract.addManySnouts(snouts.map(({ data }) => data));

    console.log('Descriptor populated with palettes and parts.');
  });
