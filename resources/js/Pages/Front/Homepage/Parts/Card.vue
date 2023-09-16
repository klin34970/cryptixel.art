<template>
    <div class="col-xl-3 col-md-6 mb-xl-0">
        <div class="card card-blog card-plain">
            <div class="position-relative">
                <a :href="route('item', address)" class="d-block border-radius-xl">
                    <img :src="'assets/img/smart_contracts/' + address + '/banner.jpg'" alt="img-blur-shadow" class="img-fluid shadow border-radius-xl">
                </a>
            </div>
            <div v-if="pause" class="auction-timer">
                <img src="assets/img/icons/pause.png" width="30" alt="">
                <p>Paused</p>
            </div>
            <div v-else class="auction-timer">
                <img src="assets/img/icons/fire.png" width="30" alt="">
                <p>Live</p>
            </div>
            <a :href="route('item', address)" class="item-owner">
                <img alt="Image placeholder" :src="'assets/img/smart_contracts/' + address + '/logo.jpg'">
            </a>
            <div class="item-cont card-body px-1 pb-0">
                <div class="gradient-text mb-2 text-sm">{{ tokenIdCounter + smart_contract.airdrop.length }} / {{ totalTokens }}</div>
                <div class="progress" style="height: 20px;">
                    <div class="progress-bar" role="progressbar" :style="'width:' + progress() +  '%;'" :aria-valuenow="progress()" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <a :href="route('item', address)">
                    <h5 class="mt-3">
                        {{ smart_contract.name }}
                    </h5>
                </a>
                <div class="text-sm">
                    Currenct Price: <span class="gradient-text">{{ price }} {{ smart_contract.symbol }}</span>
                </div>
                <div class="text-sm">
                    Max per transaction: <span class="gradient-text">{{ maxTokensPerTransaction }}</span>
                </div>
                <div class="text-sm">
                    Prize : <span class="gradient-text">{{ smart_contract.prize.amount }} {{ smart_contract.symbol }}</span> for <span class="gradient-text">{{ smart_contract.prize.winner }} winners</span>.
                </div>
                <div class="text-sm">
                    My chance to win: <div class="gradient-text">{{ chanceToWin() }}% <span v-if="balance">({{ balance }} NFTs)</span></div>
                </div>
                <div class="mb-4 text-sm">
                    Airdrop: <div class="gradient-text">{{ smart_contract.airdrop.length }} / {{ totalTokens - totalTokensBuyable }}</div>
                </div>
                <a :href="route('item', address)"><div class="gradient-text mb-4 text-sm">I want to create my own cyclop</div></a>
                <div v-if="sameChainId && !pause" class="row align-items-center">
                    <div class="col-xl-6 col-md-6 mb-xl-0">
                        <a v-if="showBuy" @click.prevent="buy" class="btn btn-outline-primary btn-sm mb-0 w-100">Buy Now</a>
                        <div v-else class="btn btn-outline-primary btn-sm mb-0 w-100">{{ buyMessage }}</div>
                    </div>
                    <div class="col-xl-6 col-md-6 mb-xl-0">
                        <div class="amount">
                            <div class="d-flex align-items-center justify-content-between">
                                <button @click="decreaseAmount" class="gradient-text border-0"><i class="fa fa-minus"></i></button>
                                <div class="gradient-text">{{ amount }}</div>
                                <button @click="increaseAmount" class="gradient-text border-0"><i class="fa fa-plus"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-else-if="sameChainId && pause" class="d-flex align-items-center justify-content-between">
                    <div class="btn btn-outline-primary btn-sm mb-0">Paused</div>
                </div>
                <div v-else class="d-flex align-items-center justify-content-between">
                    <a @click.prevent="changeChainId" class="btn btn-outline-primary btn-sm mb-0">{{ smart_contract.network_name }}</a>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import { ethers } from "ethers";
    import contractJSON from '../../../../../assets/smart_contracts/cyclops.json'
    import {FormatTypes, Interface} from "@ethersproject/abi";
    export default {
        props: ['address', 'smart_contract'],
        data: function () {
            return {
                sameChainId: false,
                amount: 1,
                showBuy: true,
                buyMessage: null,

                smartContract: null,
                price: null,
                weiPrice: null,
                totalTokensBuyable: null,
                totalTokens: null,
                tokenIdCounter: null,
                maxTokensPerTransaction: null,
                pause: null,
                balance: 0,

                contractSigner: null,
                networkSigner: null,
                signer: null,
                account: null,
            }
        },
        mounted() {
            this.initSmartConstract()
            this.initClient()
        },
        methods:{
            initSmartConstract() {
                const iface = new Interface(contractJSON.abi)
                const provider = new ethers.providers.JsonRpcProvider(this.smart_contract.node);
                let smartContract = new ethers.Contract(this.address, iface.format(FormatTypes.full), provider)
                this.smartContract = smartContract

                this.getTokenPrice()
                this.getTotalTokensBuyable()
                this.getTotalTokens()
                this.getTokenIdCounter()
                this.getMaxTokensPerTransaction()
                this.getPause()
                this.balanceOf()

                let _this = this
                smartContract.on("Buy", (amount) => {
                    _this.getTokenIdCounter()
                    _this.balanceOf()
                    _this.showBuy = true
                    _this.amount = 1
                });
                smartContract.on("MaxTokensPerTransaction", (amount) => {
                    _this.getMaxTokensPerTransaction()
                })
                smartContract.on("TokenPrice", (amount) => {
                    _this.getTokenPrice()
                })
                smartContract.on("TotalTokens", (amount) => {
                    _this.getTotalTokens()
                })
                smartContract.on("TotalTokensBuyable", (amount) => {
                    _this.getTotalTokensBuyable()
                })
                smartContract.on("Pause", () => {
                    _this.getPause()
                })
                smartContract.on("Unpause", () => {
                    _this.getPause()
                })
            },
            async initClient() {
                const iface = new Interface(contractJSON.abi)
                const provider = new ethers.providers.Web3Provider(window.ethereum)
                const signer = provider.getSigner()
                const contract = new ethers.Contract(this.address, iface.format(FormatTypes.full), signer)
                this.contractSigner = contract.connect(signer)

                this.networkSigner = await provider.getNetwork()
                this.checkChainId()
            },
            /**
             * Client
             */ buy() {
                if (this.account && this.weiPrice && this.amount) {
                    this.showBuy = false
                    this.buyMessage = 'Confirm'
                    const totalPrice = this.weiPrice.mul(this.amount)

                    let _this = this
                    this.contractSigner.buy(this.amount, {value: totalPrice}).then((tx) => {
                        setTimeout(function () {
                            _this.buyMessage = _this.truncate(tx.hash, 4, 4, 11)
                        }, 500)
                    }).catch((error)=>{
                        if(error.code === 'INSUFFICIENT_FUNDS' || error.code === -32603){
                            _this.buyMessage = 'No Fund'
                        }else if(error.code === 4001){
                            _this.buyMessage = 'Rejected'
                        }
                        setTimeout(function () {
                            _this.showBuy = true
                        }, 2000)
                    })

                }
            },
            /**
             * Smart Contract
             */
            async getTokenPrice() {
                const weiPrice = await this.smartContract.getTokenPrice()
                this.price = ethers.utils.formatEther(weiPrice)
                this.weiPrice = weiPrice
            },
            async getTotalTokensBuyable() {
                this.totalTokensBuyable = await this.smartContract.getTotalTokensBuyable()
            },
            async getTotalTokens() {
                this.totalTokens = await this.smartContract.getTotalTokens()
            },
            async getTokenIdCounter(){
                this.tokenIdCounter = await this.smartContract.getTokenIdCounter()
                if(this.tokenIdCounter){
                    this.tokenIdCounter -= 1
                }
            },
            async getMaxTokensPerTransaction(){
                this.maxTokensPerTransaction = await this.smartContract.getMaxTokensPerTransaction()
            },
            async getPause(){
                this.pause = await this.smartContract.paused()
            },
            async balanceOf(){
                if (typeof window.ethereum !== 'undefined') {
                    let accounts = await ethereum.request({method: 'eth_requestAccounts'})
                    this.account = accounts[0]
                    this.balance = await this.smartContract.balanceOf(this.account)
                }
            },
            /**
             *
             */
            checkChainId(){
                if (typeof window.ethereum !== 'undefined') {
                    if(this.networkSigner.name === this.smart_contract.network){
                        this.sameChainId = true
                    }
                }
            },
            async changeChainId() {
                if (typeof window.ethereum !== 'undefined') {
                    let _this = this
                    try {
                        await window.ethereum.request({
                            method: 'wallet_switchEthereumChain',
                            params: [{chainId: _this.smart_contract.chainId}], // chainId must be in hexadecimal numbers
                        })
                    } catch (error) {
                        if (error.code === 4902) {
                            try {
                                let network_params = this.$page.props.networks[this.smart_contract.chainId].params
                                let params = [{
                                    chainId: network_params.chainId,
                                    chainName: network_params.chainName,
                                    nativeCurrency: {
                                        name: network_params.nativeCurrency.name,
                                        symbol: network_params.nativeCurrency.symbol,
                                        decimals: network_params.nativeCurrency.decimals
                                    },
                                    rpcUrls: Object.values(network_params.rpcUrls),
                                    blockExplorerUrls: Object.values(network_params.rpcUrls)
                                }]
                                await window.ethereum.request({
                                    method: 'wallet_addEthereumChain',
                                    params: params

                                })
                            } catch (addError) {
                            }
                        }
                    }
                }
            },
            increaseAmount(){
                if(this.amount < this.maxTokensPerTransaction){
                    this.amount += 1
                }
            },
            decreaseAmount(){
                if(this.amount != 1) {
                    this.amount -= 1
                }
            },
            progress(){
                if(this.tokenIdCounter && this.totalTokens) {
                    return this.tokenIdCounter / this.totalTokens * 100
                }
                return 0
            },
            chanceToWin(){
                if(this.balance && this.totalTokens) {
                    return parseFloat(this.balance / this.totalTokens * 100).toFixed(2)
                }
                return 0
            },
            truncate(text, startChars, endChars, maxLength) {
                if (text.length > maxLength) {
                    var start = text.substring(0, startChars)
                    var end = text.substring(text.length - endChars, text.length)
                    while ((start.length + end.length) < maxLength)
                    {
                        start = start + '.'
                    }
                    return start + end
                }
                return text
            }
        }
    }
</script>
