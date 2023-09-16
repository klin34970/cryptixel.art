<?php

namespace App\Http\Controllers\Front;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;

class HomepageController extends Controller
{
    public function index(){
        //return Inertia::render('Front/Homepage/Index');
        $smart_contract = config('smart_contracts');
        $address = array_keys($smart_contract)[0];
        if(isset($smart_contract[$address])) {
            return Inertia::render('Front/Item/Index', [
                'address' => $address,
                'smart_contract' => $smart_contract[$address]
            ]);
        }
        abort(404);
    }
}
