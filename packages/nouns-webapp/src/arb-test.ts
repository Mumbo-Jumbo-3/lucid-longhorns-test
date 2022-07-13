import { Chain } from '@usedapp/core'

export const ArbTest: Chain = {
  chainId: 421611,
  chainName: 'ArbTest',
  isTestChain: true,
  isLocalChain: false,
  multicallAddress: '0xd27BEFd29F8Da4E187fDAEf663aEDF7742f9F47F',
  getExplorerAddressLink: (address: string) => `https://testnet.arbiscan.io/address/${address}`,
  getExplorerTransactionLink: (transactionHash: string) => `https://testnet.arbiscan.io/tx/${transactionHash}`,
  // Optional parameters:
  //rpcUrl: 'https://rinkeby.arbitrum.io/rpc',
  blockExplorerUrl: 'https://testnet.arbiscan.io',
  nativeCurrency: {
    name: 'Ether',
    symbol: 'ETH',
    decimals: 18,
  }
}
