<template>
    <app-layout :title="address">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-8 me-auto mt-lg-0">
                    <div class="col-12 mb-30 mt-s">
                        <div class="card">
                            <div class="card-body p-3">
                                <img class="w-100 border-radius-lg" :src="'/assets/img/smart_contracts/' + address + '/banner.jpg'" />
                            </div>
                        </div>
                    </div>
                    <div class="col-12 mb-30">
                        <div class="card">
                            <div class="card-body p-3">
                                <image-picker-component :smart_contract="smart_contract" :address="address" @parts="getParts" @boosts="getBoosts"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="col-12 mb-30 mt-s">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="d-flex flex-column h-100">
                                            <div class="mb-1 gradient-text text-center text-lg">{{ tokenIdCounter + smart_contract.airdrop.length }} of {{ totalTokens }} In Stock</div>
                                            <h4 class="font-weight-bolder mb-30">{{ smart_contract.name }}</h4>
                                            <div v-html="smart_contract.description"></div>
                                            <div class="text-bold mt-30">Currenct Price: <span class="gradient-text text-lg">{{ price }} {{ smart_contract.symbol }}</span></div>
                                            <div class="text-bold">Max per transaction: <span class="gradient-text text-lg">{{ maxTokensPerTransaction }}</span></div>
                                            <div class="text-bold mt-30">Prize: <span class="gradient-text text-lg">{{ smart_contract.prize.amount }} {{ smart_contract.symbol }}</span></div>
                                            <div class="text-bold mb-30">My chance to win: <div class="gradient-text">{{ chanceToWin() }}% <span v-if="balance">({{ balance }} NFTs)</span></div></div>
                                            <div class="text-bold mb-30">Airdrop: <span class="gradient-text text-lg">{{ smart_contract.airdrop.length }} / {{ totalTokens - totalTokensBuyable }}</span></div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <ul class="list-group">
                                                        <li class="list-group-item border-0 ps-0 text-sm"><strong class="text-dark">Item Size:</strong> 600 x 600</li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 mb-30">
                        <div class="card">
                            <div class="card-body p-3">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="card">
                                            <div class="card-body text-center p-3 w-100">
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
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </app-layout>
</template>
<script>
    import AppLayout from '@/Layouts/App'
    import {FormatTypes, Interface} from "@ethersproject/abi";
    import contractJSON from "../../../../assets/smart_contracts/cyclops.json";
    import {ethers} from "ethers";
    import ImagePickerComponent from "./Components/ImagePicker"
    export default {
        components:{
            AppLayout,
            ImagePickerComponent,
        },
        props:['address', 'smart_contract'],
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

                properties: []
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
                    this.contractSigner.buy(this.amount, this.transformPropertiesToTurple(this.properties), {value: totalPrice}).then((tx) => {
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
            getParts(parts){
                this.getPropertiesIndex(parts,'background')
                this.getPropertiesIndex(parts,'hair')
                this.getPropertiesIndex(parts,'face')
                this.getPropertiesIndex(parts,'body')
            },
            getBoosts(boosts){
                this.getPropertiesIndex(boosts,'health')
                this.getPropertiesIndex(boosts,'agility')
                this.getPropertiesIndex(boosts,'stamina')
                this.getPropertiesIndex(boosts,'vision')
            },
            getPropertiesIndex(property, name){
                this.properties[name] = property[name]?.index
            },
            transformPropertiesToTurple(properties){
                let data = [];
                for (const [name, index] of Object.entries(properties)) {
                    data.push({
                        name: name,
                        index: index
                    })
                }
                return data
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






