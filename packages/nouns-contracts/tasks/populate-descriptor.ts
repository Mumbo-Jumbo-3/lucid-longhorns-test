import { task, types } from 'hardhat/config';
import ImageData from '../files/image-data-v2.json';
import { dataToDescriptorInput } from './utils';

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
  .setAction(async ({ nftDescriptor, nounsDescriptor }, { ethers, network }) => {
    const options = { gasLimit: network.name === 'hardhat' ? 30000000 : undefined };

    const descriptorFactory = await ethers.getContractFactory('NounsDescriptorV2', {
      libraries: {
        NFTDescriptorV2: nftDescriptor,
      },
    });
    const descriptorContract = descriptorFactory.attach(nounsDescriptor);

    const { bgcolors, palette, images } = ImageData;
    const { hides, horns, heads, outfits, eyes, snouts } = images;

    const hidesPage = dataToDescriptorInput(hides.map(({ data }) => data));
    const hornsPage = dataToDescriptorInput(horns.map(({ data }) => data));
    const headsPage = dataToDescriptorInput(heads.map(({ data }) => data));
    const outfitsPage = dataToDescriptorInput(outfits.map(({ data }) => data));
    const eyesPage = dataToDescriptorInput(eyes.map(({ data }) => data));
    const snoutsPage = dataToDescriptorInput(snouts.map(({ data }) => data));

    await descriptorContract.addManyBackgrounds(bgcolors);
    await descriptorContract.setPalette(0, `0x000000${palette.join('')}`);

    await descriptorContract.addHides(
      hidesPage.encodedCompressed,
      hidesPage.originalLength,
      hidesPage.itemCount,
      options,
    );
    await descriptorContract.addHorns(
      hornsPage.encodedCompressed,
      hornsPage.originalLength,
      hornsPage.itemCount,
      options,
    );
    await descriptorContract.addHeads(
      headsPage.encodedCompressed,
      headsPage.originalLength,
      headsPage.itemCount,
      options,
    );
    await descriptorContract.addOutfits(
      outfitsPage.encodedCompressed,
      outfitsPage.originalLength,
      outfitsPage.itemCount,
      options,
    );
    await descriptorContract.addEyes(
      eyesPage.encodedCompressed,
      eyesPage.originalLength,
      eyesPage.itemCount,
      options,
    );
    await descriptorContract.addSnouts(
      snoutsPage.encodedCompressed,
      snoutsPage.originalLength,
      snoutsPage.itemCount,
      options,
    );

    console.log('Descriptor populated with palettes and parts.');
  });
