<?php

namespace App\Http\Controllers\Api\v1\Collection;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Imagick;
use ImagickPixel;
use SWeb3\SWeb3;
use SWeb3\SWeb3_Contract;
use Symfony\Component\HttpFoundation\Response;
use Throwable;

class CyclopController extends Controller
{

    public function index($id){
        try {
            $abi = file_get_contents(resource_path('/assets/smart_contracts/cyclops.json'));
            $abi = json_encode(json_decode($abi)->abi);
            $smart_contract = config('smart_contracts');
            $address = array_keys($smart_contract)[0];

            $sweb3 = new SWeb3('https://goerli.infura.io/v3/b03301554f44408884eccce20b47e3c3');
            $contract = new SWeb3_Contract($sweb3, $address, $abi);
            $properties = $contract->call('getProperties', [$id]);

            $data = collect();
            $data->put('description', 'Fantastic creatures in Greek mythology. Cyclop: ' . $id);

            $attributes = collect();
            $smart_contract = config('smart_contracts');

            $layer = collect();
            foreach ($properties->array_1 as $property) {
                if(isset($smart_contract[$address]['parts'][$property->name])) {
                    $part = $smart_contract[$address]['parts'][$property->name][$property->index];
                    $layer->put($property->name, $part);
                    $attributes->push([
                        'trait_type' => $property->name,
                        'value'      => $part
                    ]);
                }else{
                    $attributes->push([
                        'display_type' => 'boost_number',
                        'trait_type' => $property->name,
                        'value'      => $property->index
                    ]);
                }
            }
            $data->put('attributes', $attributes);
            $data->put('external_url', URL::route('api.v1.collection.cyclops.generate', ['hash' => encrypt($layer->toArray())]));
            $data->put('image', URL::route('api.v1.collection.cyclops.generate', ['hash' => encrypt($layer->toArray())]));
            $data->put('name', 'Cyclop #' . $id);
            return response()->json($data, Response::HTTP_OK);
        }catch (Throwable $e){
            $data = collect();
            $data->put('description', 'Fantastic creatures in Greek mythology');
            return response()->json($data, Response::HTTP_OK);
        }
    }

    public function generate($hash){
        try{
            $properties = decrypt($hash);
            $smart_contract = config('smart_contracts');
            $address = array_keys($smart_contract)[0];
            $image = new Imagick();
            $image->newImage(600, 600, new ImagickPixel('none'));
            $image->setImageFormat('png');
            $properties = [
                'background' => $properties['background'],
                'body' => $properties['body'],
                'face' => $properties['face'],
                'hair' => $properties['hair'],
            ];
            foreach ($properties as $name => $value){
                $part = resource_path('/assets/img/smart_contracts/' . $address . '/parts/' . $name . '/' . $name . '-' . $value . '.png');
                $source = new Imagick($part);
                $source->setImageFormat('png');
                $image->compositeImage($source, Imagick::COMPOSITE_DEFAULT, 0, 0);
            }
            $response = response()->make($image->getImageBlob(), 200);
            $response->header("Content-Type", "image/png");
            return $response;
        }catch (Throwable $e){
            $image = new Imagick(resource_path('/assets/img/logo.png'));
            $image->resizeImage(600, 600, Imagick::FILTER_LANCZOS,1);
            $response = response()->make($image->getImageBlob(), 200);
            $response->header("Content-Type", "image/png");
            return $response;
        }

    }
}
