<template>
    <app-layout title="Home">
        <div class="container-fluid">
            <div class="col-12 py-4">
                <div class="card">

                    <div class="card-body">
                        <div class="row">
                            <card-part v-for="(smart_contract, address) in smart_contracts" :address="address" :smart_contract="smart_contract"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </app-layout>
</template>

<script>
    import AppLayout from '@/Layouts/App'
    import CardPart from './Parts/Card'
    export default {
        components:{
            AppLayout,
            CardPart
        },
        data: function () {
            return {
                smart_contracts: this.$page.props.smart_contracts,
                warning: null
            }
        },
    }
</script>




