<?php

use App\Http\Controllers\Front\HomepageController;
use App\Http\Controllers\Front\FaqController;
use App\Http\Controllers\Front\ItemController;
use App\Http\Controllers\Front\RoadmapController;

Route::get('/', [HomepageController::class, 'index'])->name('homepage');
Route::get('item/{address}', [ItemController::class, 'index'])->name('item');
Route::get('faq', [FaqController::class, 'index'])->name('faq');
Route::get('roadmap', [RoadmapController::class, 'index'])->name('roadmap');
