const mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel applications. By default, we are compiling the CSS
 | file for the application as well as bundling up all the JS files.
 |
 */

/**
 * INERTIA
 */
mix
    .js('resources/js/app.js', 'public/assets/js/core.js')
    .vue()
    .webpackConfig(require('./webpack.config'));

/**
 * JS
 */
mix
    .combine([
        'resources/assets/js/core/popper.min.js',
        'resources/assets/js/core/bootstrap.min.js',
        'resources/assets/js/plugins/smooth-scrollbar.min.js',
    ], 'public/assets/js/vendors.js')
    .combine([
        'resources/assets/js/fontawesome.js',
    ], 'public/assets/js/fontawesome.js')
    .combine([
        'resources/assets/js/scripts.js',
    ], 'public/assets/js/app.js')

/**
 * CSS
 */
mix
    .combine([
        'resources/assets/css/nucleo-icons.css',
        'resources/assets/css/nucleo-svg.css',
        'resources/assets/css/nucleo-svg.css',
        'resources/assets/css/bootstrap.css',
    ], 'public/assets/css/vendors.css')
    .combine([
        'resources/assets/css/style.css'
    ], 'public/assets/css/app.css')
    .options({
        processCssUrls: false
    });

/**
 * FONTS
 */
mix
    .copy(
    'resources/assets/fonts',
    'public/assets/fonts'
    )
    .copy(
        'resources/assets/img',
        'public/assets/img'
    )

/**
 *
 */
if (mix.inProduction()) {
    mix.version();
}
