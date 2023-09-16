<?php

namespace App\Http\Controllers\Front;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ItemController extends Controller
{
    public function index($address){
        $smart_contract = config('smart_contracts');
        if(isset($smart_contract[$address])) {
            return Inertia::render('Front/Item/Index', [
                'address' => $address,
                'smart_contract' => $smart_contract[$address]
            ]);
        }
        abort(404);
    }
}
