const path = require('path');

module.exports = {
    resolve: {
        alias: {
            '@': path.resolve('resources/js'),
        },
        fallback:{
            http: require.resolve("http-browserify"),
            https: require.resolve("https-browserify"),
            crypto: require.resolve('crypto-browserify'),
            os: require.resolve("os-browserify/browser"),
            stream: require.resolve("stream-browserify"),
        }
    },
};
