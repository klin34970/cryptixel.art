<?php

use App\Http\Controllers\Api\v1\Collection\CyclopController;

Route::group(['prefix' => 'v1/collection/cyclops', 'as' => 'api.v1.collection.cyclops.'], function(){
    Route::get('/nft/{hash}', [CyclopController::class, 'generate'])->name('generate');
    Route::get('{id}', [CyclopController::class, 'index'])->name('index');
});