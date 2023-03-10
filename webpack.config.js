const path = require('path');
const webpack = require("webpack");
const packageJSON = require("./package.json");
let plugins = [
  new webpack.DefinePlugin({
    __VERSION__: JSON.stringify(packageJSON.version),
  }),
];

module.exports = () => {
  return {
    entry: ["./index.js"],
    output: {
      path: __dirname + "/dist",
      filename: "index.js",
      sourceMapFilename: "index.js.map",
      environment: {
        arrowFunction: false,
        bigIntLiteral: false,
        const: false,
        destructuring: false,
        dynamicImport: false,
        forOf: false,
        module: false
      }
    },
    devServer: {
      static: {
        directory: path.join(__dirname, 'dist'),
      },
      host: "0.0.0.0",
      port: 8079,
    },
    module: {
      rules: [
        { test: /\.js$/,
          exclude: /node_modules/,
        },
      ]
    }
  , plugins
  }
};