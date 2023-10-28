# simpletokenmanage-cairo

EOA wallet has no state and code storage, and the smart contract wallet is different.

AA is a direction of the smart contract wallet, which works around abstract accounts. This SNRC can as a plug-in for wallets.

The smart contract wallet allows the user's own account to have state and code, bringing programmability to the wallet. We think there are more directions to expand. For example, token asset management, functional expansion of token transactions, etc.

The smart contract wallet is for asset management and asset approval. It supports the simpletoken SNRC-10, and SNRC-2(ERC-20) is backward compatible with SNRC-10, so it can be compatible with the management of all fungible tokens in the existing market.

The proposal aims to achieve the following goals:

Assets are allocated and managed by the wallet itself, such as approve and allowance, which are configured by the user’s contract wallet, rather than controlled by the token asset contract, to avoid some existing ERC-20 contract risks.
The user wallet itself supports transfer function, include approve and provides approve for single token assets and all token assets.
