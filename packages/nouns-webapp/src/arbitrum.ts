import { Chain } from '@usedapp/core'

export const Arbitrum: Chain = {
  chainId: 42161,
  chainName: 'Arbitrum',
  isTestChain: false,
  isLocalChain: false,
  multicallAddress: '0x842eC2c7D803033Edf55E478F461FC547Bc54EB2',
  getExplorerAddressLink: (address: string) => `https://arbiscan.io/address/${address}`,
  getExplorerTransactionLink: (transactionHash: string) => `https://arbiscan.io/tx/${transactionHash}`,
  // Optional parameters:
  //rpcUrl: 'https://arb1.arbitrum.io/rpc',
  blockExplorerUrl: 'https://arbiscan.io',
  nativeCurrency: {
    name: 'Ether',
    symbol: 'ETH',
    decimals: 18,
  }
}
