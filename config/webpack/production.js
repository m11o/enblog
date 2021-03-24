process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const MiniCssExtractPlugin = require('mini-css-extract-plugin')

const environment = require('./environment')

environment.plugins.insert(
  'MiniCssExtract',
  new MiniCssExtractPlugin({
    filename: 'css/[name].css',
    chunkFilename: 'css/[name].chunk.css'
  })
);
environment.config.merge({
  output: {
    filename: 'js/[name].js'
  }
});

module.exports = environment.toWebpackConfig()
