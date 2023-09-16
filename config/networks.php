<?php
return [
    '0x539' => [
        'params' => [
            'chainId' => '0x4',
            'chainName' => 'Réseau de test Rinkeby',
            'nativeCurrency' => [
                'name' => 'ETH',
                'symbol' =>'ETH',
                'decimals' => 18
            ],
            'rpcUrls' => ['http://127.0.0.1:7545'],
            'blockExplorerUrls' => ['https://rinkeby.etherscan.io']
        ]
    ],
    '0x4' => [
        'params' => [
            'chainId' => '0x4',
            'chainName' => 'Réseau de test Rinkeby',
            'nativeCurrency' => [
                'name' => 'ETH',
                'symbol' =>'ETH',
                'decimals' => 18
            ],
            'rpcUrls' => ['https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'],
            'blockExplorerUrls' => ['https://rinkeby.etherscan.io']
        ]
    ],
    '0x1' => [
        'params' => [
            'chainId' => '0x4',
            'chainName' => 'Réseau principal Ethereum',
            'nativeCurrency' => [
                'name' => 'ETH',
                'symbol' =>'ETH',
                'decimals' => 18
            ],
            'rpcUrls' => ['https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'],
            'blockExplorerUrls' => ['https://etherscan.io']
        ]
    ],
    '0x38' => [
        'params' => [
            'chainId' => '0x38',
            'chainName' => 'Binance Smart Chain',
            'nativeCurrency' => [
                'name' => 'BNB',
                'symbol' =>'BNB',
                'decimals' => 18
            ],
           'rpcUrls' => ['https://bsc-dataseed.binance.org/'],
            'blockExplorerUrls' => ['https://bscscan.com']
        ]
    ],
];
