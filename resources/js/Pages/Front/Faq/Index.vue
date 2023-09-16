<template>
    <app-layout title="FAQ">

        <div class="container-fluid">
            <div class="row">
                <div class="col">

                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col">
                                    <div class="accordion accordion-flush" id="faq">
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="flush-head-purchase-nft">
                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse-purchase-nft" aria-expanded="false" aria-controls="flush-collapseOne">
                                                    When I purchased an NFT, where does it go after after?
                                                </button>
                                            </h2>
                                            <div id="flush-collapse-purchase-nft" class="accordion-collapse collapse" aria-labelledby="flush-head-purchase-nft" data-bs-parent="#faq">
                                                <div class="accordion-body">After the purchase, Your NFT will appear in the wallet address you used to purchase an NFT.</div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="flush-head-presale-nft">
                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse-presale-nft" aria-expanded="false" aria-controls="flush-collapseTwo">
                                                    How to get NFTs?
                                                </button>
                                            </h2>
                                            <div id="flush-collapse-presale-nft" class="accordion-collapse collapse" aria-labelledby="flush-head-presale-nft" data-bs-parent="#faq">
                                                <div class="accordion-body">Connect your wallet with Metamask. Mint your NFT by clicking on "BUY NOW" button.</div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="flush-head-can-do-nft">
                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse-can-do-nft" aria-expanded="false" aria-controls="flush-collapseThree">
                                                    What can I do with my NFTs?
                                                </button>
                                            </h2>
                                            <div id="flush-collapse-can-do-nft" class="accordion-collapse collapse" aria-labelledby="flush-head-can-do-nft" data-bs-parent="#faq">
                                                <div class="accordion-body">Whatever you want, it's yours! you can trade or resell them on platforms like OpenSea.</div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="flush-head-lottery-prize">
                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse-lottery-prize" aria-expanded="false" aria-controls="flush-collapseThree">
                                                    How to enter the lottery and win the big prize?
                                                </button>
                                            </h2>
                                            <div id="flush-collapse-lottery-prize" class="accordion-collapse collapse" aria-labelledby="flush-head-lottery-prize" data-bs-parent="#faq">
                                                <div class="accordion-body">You just need to buy a NFTs. The more NFTs you have, the more chance you have of winning.</div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="flush-head-giveaway">
                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse-giveaway" aria-expanded="false" aria-controls="flush-collapseThree">
                                                    How many NFTs are reserved for giveaways?
                                                </button>
                                            </h2>
                                            <div id="flush-collapse-giveaway" class="accordion-collapse collapse" aria-labelledby="flush-head-giveaway" data-bs-parent="#faq">
                                                <div class="accordion-body">It will depend on the collection. But there will be giveaways for each collection</div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="flush-head-trade-nft">
                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse-trade-nft" aria-expanded="false" aria-controls="flush-collapseThree">
                                                    How can I trade or resell my NFTs?
                                                </button>
                                            </h2>
                                            <div id="flush-collapse-trade-nft" class="accordion-collapse collapse" aria-labelledby="flush-head-trade-nft" data-bs-parent="#faq">
                                                <div class="accordion-body">It's ERC-721 standard so you can trade or resell them on platforms like OpenSea.</div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="flush-head-good-investment">
                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse-good-investment" aria-expanded="false" aria-controls="flush-collapseThree">
                                                    Is this a good investment?
                                                </button>
                                            </h2>
                                            <div id="flush-collapse-good-investment" class="accordion-collapse collapse" aria-labelledby="flush-head-good-investment" data-bs-parent="#faq">
                                                <div class="accordion-body">Yes! Firstly, buying an NFT guarantees you to be drawn for the lottery and to win big prizes. Then you can resell them for double the price see more on platforms like Opensea</div>
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
    export default {
        components:{
            AppLayout,
        },
    }
</script>
