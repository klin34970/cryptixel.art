<template>
    <aside-part />
    <main class="main-content mt-1 border-radius-lg">
        <header-part :title="title"/>
        <slot />
    </main>
</template>

<script>
    import AsidePart from './Parts/Aside'
    import HeaderPart from './Parts/Header'
    export default {
        components: {
            AsidePart,
            HeaderPart
        },
        props: ['title'],
        data: function () {
            return {
                account: null
            }
        },
        mounted() {
            if (typeof window.ethereum !== 'undefined') {
                ethereum.on('chainChanged', this.handleChainChanged);
            }
        },
        methods:{
            handleChainChanged(_chainId){
                window.location.reload();
            },
        }
    }
</script>
