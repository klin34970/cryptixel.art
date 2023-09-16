<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <link rel="apple-touch-icon" sizes="180x180" href="/assets/img/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="/assets/img/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="/assets/img/favicon/favicon-16x16.png">
        <link rel="manifest" href="/assets/img/favicon/site.webmanifest">
        <link rel="mask-icon" href="/assets/img/favicon/safari-pinned-tab.svg" color="#5bbad5">
        <link rel="shortcut icon" href="/assets/img/favicon/favicon.ico">
        <meta name="msapplication-TileColor" content="#ffffff">
        <meta name="msapplication-config" content="/assets/img/favicon/browserconfig.xml">
        <meta name="theme-color" content="#ffffff">

        <meta name="twitter:card" content="summary" />
        <meta name="twitter:site" content="@cryptixelart" />
        <meta name="twitter:title" content="{{ config('app.name', 'Laravel') }}" />
        <meta name="twitter:description" content="The best place to pick up our limited edition NFT drops with new themes!" />
        <meta name="twitter:image" content="/assets/img/card.jpg" />

        <meta property="og:title" content="{{ config('app.name', 'Laravel') }}" />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://cryptixel.art/" />
        <meta property="og:image" content="/assets/img/card.jpg" />

        <title inertia>{{ config('app.name', 'Laravel') }}</title>

        <link rel="stylesheet" href="{{ URL::asset(mix('/assets/css/vendors.css')) }}">
        <link rel="stylesheet" href="{{ URL::asset(mix('/assets/css/app.css')) }}">

        @routes
        <script src="{{ mix('assets/js/core.js') }}" defer></script>
    </head>
    <body class="g-sidenav-show  bg-gray-100">
        @inertia

        <script src="{{ URL::asset(mix('assets/js/fontawesome.js')) }}" defer></script>
        <script src="{{ URL::asset(mix('assets/js/vendors.js')) }}" defer></script>
        <script src="{{ URL::asset(mix('assets/js/app.js')) }}" defer></script>
    </body>
</html>
