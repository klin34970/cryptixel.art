<template>
    <!-- Navbar -->
    <nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" >
        <div class="container-fluid py-1 px-3">
            <nav aria-label="breadcrumb">
                <h6 class="font-weight-bolder mb-0">{{ title }}</h6>
            </nav>
            <div class="collapse navbar-collapse mt-sm-0 mt-2 me-md-0 me-sm-4" id="navbar">
                <div class="ms-md-auto pe-md-3 d-flex align-items-center">
                </div>
                <ul class="navbar-nav  justify-content-end">
                    <li class="nav-item d-flex align-items-center">
                        <div v-if="warning" class="nav-link text-body font-weight-bold px-0">
                            <span class="d-sm-inline d-none mr-10">{{ warning }}</span>
                        </div>
                        <a role="button" v-else-if="account" class="nav-link text-body font-weight-bold px-0">
                            <i class="fa fa-wallet me-sm-1"></i>
                            <span class="d-sm-inline d-none mr-10">{{ truncate(account, 4, 4, 11) }}</span>
                        </a>
                        <a role="button" v-else @click.prevent="enableEthereum" class="nav-link text-body font-weight-bold px-0">
                            <i class="fa fa-wallet me-sm-1"></i>
                            <span class="d-sm-inline d-none mr-10">Connect wallet</span>
                        </a>
                    </li>
                    <li class="nav-item d-xl-none px-3 d-flex align-items-center">
                        <a href="javascript:;" class="nav-link text-body p-0" id="iconNavbarSidenav">
                            <div class="sidenav-toggler-inner">
                                <i class="sidenav-toggler-line"></i>
                                <i class="sidenav-toggler-line"></i>
                                <i class="sidenav-toggler-line"></i>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</template>

<script>
    export default {
        props: ['title'],
        data: function () {
            return {
                account: null,
                warning: null
            }
        },
        mounted() {
            if (typeof window.ethereum !== 'undefined') {
                ethereum.on('accountsChanged', this.handleAccountsChanged)
                this.enableEthereum()
            }
        },
        methods:{
            async enableEthereum() {
                if (typeof window.ethereum !== 'undefined') {
                    let accounts = await ethereum.request({method: 'eth_requestAccounts'})
                    this.account = accounts[0]
                }else{
                    this.warning = 'MetaMask is not installed!'
                }
            },
            handleAccountsChanged(accounts){
                this.account = accounts[0]
                window.location.reload()
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
        },
    }
</script>
