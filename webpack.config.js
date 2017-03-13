var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var InlineManifestWebpackPlugin = require('inline-manifest-webpack-plugin');
var ScriptExtHtmlWebpackPlugin = require('script-ext-html-webpack-plugin');
var ChunkManifestPlugin = require("chunk-manifest-webpack-plugin");
var WebpackChunkHash = require("webpack-chunk-hash");

/*
Node environment variables to determine production or development config.
NODE_ENV is set via NPM Scripts 'build' and 'dev' (see package.json:scripts)
*/
const DEVELOPMENT = process.env.NODE_ENV === 'development';
const PRODUCTION = process.env.NODE_ENV === 'production';


/*
/
/
SHARED CONFIGURATION
/
/

Merged with Production or Development config (see below) using webpack-merge.

Embeds any sufficiently small images (<10KB) to avoid needless request overhead.

Dynamically generates index.html from index.template.ejs with all .css and .js
assets correctly linked automatically. No need to manually add assets to HTML.
Note: All future assets will be automatically included as well. No need for
configuration changes to incorporate future additions. Simply ensure all assets
are correctly placed in the 'src' directory.
(See HTMLWebpack plugin.)
*/

/*
In order for webpack-dev-server hot reloading to work properly, all assets must
be on the same level. These declarations simply handle putting index.html and
all images at the right directory level during Production/Development.
*/
const HTMLFilename = PRODUCTION ? '../index.html' : 'index.html';
const imageFilename = PRODUCTION ? 'images/[name].[ext]'
                                 : '[name].[ext]';

//Path to Elm src files. (For use with Elm loaders.)
const elmSource = path.join(__dirname, 'src/elm');

//The actual shared configuration object
const commonConfig = {
  module: {
    rules: [{
        test: /\.js$/,
        use: ['babel-loader'],
        exclude: '/node_modules'
      },
      {
        test: /\.(png|jpg|gif)$/,
        use: [`file-loader?name=${imageFilename}`],
        exclude: '/node_modules'
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({filename: HTMLFilename,
                           template: 'index.template.ejs'})
  ]
};

/*
/
/
/ PRODUCTION CONFIGURATION
/
/

Utilizes cheap-module-source-map for lightweight source-mapping. (Supports
much better error information with very low overhead.)

Content-based Chunkhashes used in file names for optimized browser caching.

Plugins:

Minified output via UglifyJSPlugin.

Extracts .scss/.css content into separate bundle for caching/load time
optimization. (see ExtractTextPlugin.)

Extracts vendor code into a separate vendor.js file for optimized browser
caching. (See 'entry' below, and CommonsChunkPlugin.)

Extracts the Webpack runtime out of main.js and inlines it into index.html
via usage of webpack manifest info. This ensures optimal browser caching for
main.js. (Webpack runtime is dynamically generated every time we build, so
bundling it with main.js would result in the Chunkhash of main.js changing
on -- every build -- even if none of our actual .js code had changed.
This would result in lots of unneccesary redownloading and recaching.)
(See InlineManifest, ChunkManifest, HashedModuleIDs, and CommonsChunk plugins.)

Start a Production build by using NPM Script 'build'. (See package.json)
(CLI command is 'npm run build'. Note: Will delete 'dist', ensuring clean slate.)
*/
if (PRODUCTION) {

  const extractSCSS = new ExtractTextPlugin("bundle.[hash].css");

  module.exports = merge.smart(commonConfig, {
    entry: {
      main: './src/index.js'
    },
    output: {
        path: path.join(__dirname, 'dist/assets'),
        publicPath: '/assets/',
        filename: '[name].[chunkhash].js'
    },
    devtool: 'cheap-module-source-map',
    module: {
      rules: [
        {
          test: /\.(scss|sass)$/,
          use: extractSCSS.extract({ fallbackLoader: 'style-loader',
            loader: 'css-loader!resolve-url-loader!sass-loader?sourceMap=true'})
        },
        {
          test: /\.elm$/,
          use: [`elm-webpack-loader?cwd=${elmSource}&verbose=true&warn=true`],
          exclude: ['/elm-stuff', '/node_modules']
        }
      ]
    },
    plugins: [
        new webpack.optimize.UglifyJsPlugin(),
        // new webpack.optimize.CommonsChunkPlugin({
        //         names: ['vendor', 'manifest'],
        //         minChunks: Infinity
        //     }),
        extractSCSS,
        // new InlineManifestWebpackPlugin({
        //   name: 'webpackManifest'
        // }),
        new ScriptExtHtmlWebpackPlugin({
          sync: [/\.js$/]
        }),
        // new ChunkManifestPlugin({
        //   filename: "chunk-manifest.json",
        //   manifestVariable: "webpackManifest"
        // }),
        // new WebpackChunkHash(),
        // new webpack.HashedModuleIdsPlugin()
    ]
  })
}

/*
/
/
DEVELOPMENT CONFIGURATION
/
/

Uses full sourcemaps for detailed error information.

Uses webpack-dev-server with hot module reloading enabled.
(See devServer below, and HotModuleReplacement plugin.)

Start a Development build by using NPM Script 'dev'. (See package.json)
(CLI command is 'npm run dev'. Will automatically open a browser window.)
*/
if (DEVELOPMENT) {
  module.exports = merge.smart(commonConfig, {
    devtool: 'source-map',
    output: {
        path: path.join(__dirname, 'dist/'),
        publicPath: '/',
        filename: '[name].js'
    },
    entry: [
        './src/index.js',
        'webpack/hot/only-dev-server',
        'webpack-dev-server/client?http://localhost:8080'
    ],
    devServer: {
      hot: true,
      publicPath: '/'
    },
    module: {
      rules: [
        {
          test: /\.(scss|sass)$/,
          exclude: '/node_modules',
          use: ['style-loader',
                {loader: 'css-loader',
                options: {importLoaders: 2}
              }, 'resolve-url-loader',
                'sass-loader']
        },
        {
          test: /\.elm$/,
          use: ['elm-hot-loader', `elm-webpack-loader?cwd=${elmSource}&verbose=true&warn=true`],
          exclude: ['/elm-stuff', '/node_modules']
        }
      ]
    },
    plugins: [new webpack.HotModuleReplacementPlugin()]
  })
}
