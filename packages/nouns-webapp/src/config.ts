import {
  ContractAddresses as NounsContractAddresses,
  getContractAddressesForChainOrThrow,
} from '@nouns/sdk';
import { ChainId } from '@usedapp/core';

interface ExternalContractAddresses {
  lidoToken: string | undefined;
}

export type ContractAddresses = NounsContractAddresses & ExternalContractAddresses;

interface AppConfig {
  jsonRpcUri: string;
  wsRpcUri: string;
  subgraphApiUri: string;
  enableHistory: boolean;
}

type SupportedChains = ChainId.Rinkeby | ChainId.Mainnet | 421611 | 42161 | 80001 | 137 | ChainId.Hardhat;

interface CacheBucket {
  name: string;
  version: string;
}

export const cache: Record<string, CacheBucket> = {
  seed: {
    name: 'seed',
    version: 'v1',
  },
  ens: {
    name: 'ens',
    version: 'v1',
  },
};

export const cacheKey = (bucket: CacheBucket, ...parts: (string | number)[]) => {
  return [bucket.name, bucket.version, ...parts].join('-').toLowerCase();
};

export const CHAIN_ID: SupportedChains = parseInt(process.env.REACT_APP_CHAIN_ID ?? '4');

export const ETHERSCAN_API_KEY = process.env.REACT_APP_ETHERSCAN_API_KEY ?? '';

const ALCHEMY_PROJECT_ID = process.env.REACT_APP_ALCHEMY_PROJECT_ID;

export const createNetworkHttpUrl = (network: string): string => {
  const custom = process.env[`REACT_APP_${network.toUpperCase()}_JSONRPC`];
  return custom || `https://${network}.g.alchemy.com/v2/${ALCHEMY_PROJECT_ID}`;
};

export const createNetworkWsUrl = (network: string): string => {
  const custom = process.env[`REACT_APP_${network.toUpperCase()}_WSRPC`];
  return custom || `wss://${network}.g.alchemy.com/v2/${ALCHEMY_PROJECT_ID}`;
};

const app: Record<SupportedChains, AppConfig> = {
  [ChainId.Rinkeby]: {
    jsonRpcUri: createNetworkHttpUrl('rinkeby'),
    wsRpcUri: createNetworkWsUrl('rinkeby'),
    subgraphApiUri: 'https://api.thegraph.com/subgraphs/name/nounsdao/nouns-subgraph-rinkeby-v4',
    enableHistory: process.env.REACT_APP_ENABLE_HISTORY === 'true',
  },
  [ChainId.Mainnet]: {
    jsonRpcUri: createNetworkHttpUrl('mainnet'),
    wsRpcUri: createNetworkWsUrl('mainnet'),
    subgraphApiUri: 'https://api.thegraph.com/subgraphs/name/nounsdao/nouns-subgraph',
    enableHistory: process.env.REACT_APP_ENABLE_HISTORY === 'true',
  },
  [ChainId.ArbitrumRinkeby]: {
    jsonRpcUri: createNetworkHttpUrl('arbTest'),
    wsRpcUri: createNetworkWsUrl('arbTest'),
    subgraphApiUri: 'https://api.thegraph.com/subgraphs/name/mumbo-jumbo-3/lucid-longhorns-t',
    enableHistory: process.env.REACT_APP_ENABLE_HISTORY === 'true',
  },
  [ChainId.Arbitrum]: {
    jsonRpcUri: createNetworkHttpUrl('arbitrum'),
    wsRpcUri: createNetworkWsUrl('arbitrum'),
    subgraphApiUri: 'https://api.thegraph.com/subgraphs/name/lucid-longhorns/lucid-longhorns-subgraph-arbitrum',
    enableHistory: process.env.REACT_APP_ENABLE_HISTORY === 'true',
  },
  [ChainId.PolygonMumbai]: {
    jsonRpcUri: createNetworkHttpUrl('polygon-mumbai'),
    wsRpcUri: createNetworkWsUrl('polygon-mumbai'),
    subgraphApiUri: 'https://api.thegraph.com/subgraphs/name/mumbo-jumbo-3/lucid-longhorns-t',
    enableHistory: process.env.REACT_APP_ENABLE_HISTORY === 'true',
  },
  [ChainId.Polygon]: {
    jsonRpcUri: createNetworkHttpUrl('polygon'),
    wsRpcUri: createNetworkWsUrl('polygon'),
    subgraphApiUri: 'https://api.thegraph.com/subgraphs/name/mumbo-jumbo-3/lucid-longhorns',
    enableHistory: process.env.REACT_APP_ENABLE_HISTORY === 'true',
  },
  [ChainId.Hardhat]: {
    jsonRpcUri: 'http://localhost:8545',
    wsRpcUri: 'ws://localhost:8545',
    subgraphApiUri: '',
    enableHistory: false,
  },
};

const externalAddresses: Record<SupportedChains, ExternalContractAddresses> = {
  [ChainId.Rinkeby]: {
    lidoToken: '0xF4242f9d78DB7218Ad72Ee3aE14469DBDE8731eD',
  },
  [ChainId.Mainnet]: {
    lidoToken: '0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84',
  },
  [ChainId.ArbitrumRinkeby]: {
    lidoToken: undefined,
  },
  [ChainId.Arbitrum]: {
    lidoToken: undefined,
  },
  [ChainId.PolygonMumbai]: {
    lidoToken: undefined,
  },
  [ChainId.Polygon]: {
    lidoToken: undefined,
  },
  [ChainId.Hardhat]: {
    lidoToken: undefined,
  },
};

const getAddresses = (): ContractAddresses => {
  let nounsAddresses = {} as NounsContractAddresses;
  try {
    nounsAddresses = getContractAddressesForChainOrThrow(CHAIN_ID);
  } catch {}
  return { ...nounsAddresses, ...externalAddresses[CHAIN_ID] };
};

const config = {
  app: app[CHAIN_ID],
  addresses: getAddresses(),
};

export default config;
