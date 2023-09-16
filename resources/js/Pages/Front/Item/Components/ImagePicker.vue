<template>
    <div class="row">
        <div class="col-lg-6 me-auto mb-4 mb-lg-0 mt-lg-0 d-flex align-items-center justify-content-center">
            <div class="position-relative" style="height:300px;width:300px">
                <div v-for="part in parts" class="position-absolute">
                    <img :src="part.items[part.index]?.url" class="w-100 border-radius-lg" :alt="part.items[part.index]?.name">
                </div>
            </div>
        </div>
        <div class="col-lg-6 d-flex flex-column justify-content-center">
            <div v-for="(part, name) in parts" class="row align-items-center mb-lg-1">
                <div class="col-xl-6 col-md-6 mb-xl-0">
                    <span class="btn btn-outline-primary btn-sm mb-0 w-100">{{ name }}</span>
                </div>
                <div class="col-xl-6 col-md-6 mb-xl-0">
                    <div class="amount">
                        <div class="d-flex align-items-center justify-content-between">
                            <button @click="previous(part)" class="gradient-text border-0"><i class="fa fa-minus"></i></button>
                            <div class="gradient-text">{{ part.items[part.index]?.name }}</div>
                            <button @click="next(part)" class="gradient-text border-0"><i class="fa fa-plus"></i></button>
                        </div>
                    </div>
                </div>
            </div>
            <div v-for="(boost, name) in boosts" class="row align-items-center mb-lg-1">
                <div class="col-xl-6 col-md-6 mb-xl-0">
                    <span class="btn btn-outline-primary btn-sm mb-0 w-100">{{ name }}</span>
                </div>
                <div class="col-xl-6 col-md-6 mb-xl-0">
                    <div class="amount">
                        <div class="d-flex align-items-center justify-content-between">
                            <button @click="previousBoost(boost, boost.min, boost.max)" class="gradient-text border-0"><i class="fa fa-minus"></i></button>
                            <div class="gradient-text">{{ boost.index }}</div>
                            <button @click="nextBoost(boost, boost.min, boost.max)" class="gradient-text border-0"><i class="fa fa-plus"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
 export default {
     props:['smart_contract', 'address'],
     data: function (){
         return{
             parts: {
                 background: {
                     sources: this.smart_contract.parts.background,
                     index:0,
                     items: []
                 },
                 body: {
                     sources: this.smart_contract.parts.body,
                     index:0,
                     items: []
                 },
                 face: {
                     sources: this.smart_contract.parts.face,
                     index:0,
                     items: []
                 },
                 hair: {
                     sources: this.smart_contract.parts.hair,
                     index:0,
                     items: []
                 }
             },
             boosts:{
                 health:{
                     min:0,
                     max:100,
                     index:0,
                 },
                 agility:{
                     min:0,
                     max:100,
                     index:0,
                 },
                 stamina:{
                     min:0,
                     max:100,
                     index:0,
                 },
                 vision:{
                     min:0,
                     max:100,
                     index:0,
                 }
             },
             url: route('homepage') + '/assets/img/smart_contracts/' + this.address + '/parts/',
         }
     },
     mounted(){
         for (const [name, properties] of Object.entries(this.parts)) {
             this.initItems(name, properties)
         }
         for (const [name, properties] of Object.entries(this.boosts)) {
             this.initBoosts(name, properties)
         }

     },
     methods:{
         initItems(name, properties){
             properties.sources.forEach(source => {
                 properties.items.push({
                     name: source.toUpperCase(),
                     url: this.url + name + '/' + name + '-' + source + '.png'
                 })
             })
             properties.index = this.getRandomInt(properties.sources.length)
             this.$emit('parts', this.parts)
         },
         initBoosts(name, properties){
             properties.index = this.getRandomInt(properties.max)
             this.$emit('boosts', this.boosts)
         },
         getRandomInt(max){
             return Math.floor(Math.random() * max);
         },
         previous(part){
             part.index -= 1
             if(part.index < 0){
                 part.index = part.sources.length - 1
             }
             this.$emit('parts', this.parts)
         },
         next(part){
             part.index += 1
             if(part.index > part.sources.length - 1){
                 part.index = 0
             }
             this.$emit('parts', this.parts)
         },
         previousBoost(boost, min, max){
             boost.index -= 1
             if(boost.index < min){
                 boost.index = max
             }
             this.$emit('boosts', this.boosts)
         },
         nextBoost(boost, min, max){
             boost.index += 1
             if(boost.index > max){
                 boost.index = min
             }
             this.$emit('boosts', this.boosts)
         }
     }
 }
</script>