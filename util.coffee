_ = require 'underscore'
_.str = require 'underscore.string'
urllib = require 'url'

exports.uniqFilenames = uniqFilenames = (filenames) ->
  filenames = filenames.map (filename) ->
    _.str.strLeftBack filename, '.'
  filenames = _.uniq filenames

exports.buildUrl = buildUrl = (url, path) ->
  if not _.str.startsWith path, '/'
    _.str.strLeftBack(url, '/') + '/' + path
  else
    parsed_url = urllib.parse(url)
    parsed_url.pathname = path
    urllib.format(parsed_url)




