http = require 'http'
urlParse = (require 'url').parse
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
_.str = require 'underscore.string'
mongoose = require 'mongoose'
async = require 'async'
bufferhelper = require 'bufferhelper'

myUtil = require './util'
config = require './config'


if not mongoose.connection.host?
  console.log "starting connect mongodb"
  mongoose.connect config.mongourl
  console.log "connect mongodb successful!"

require './models/news'
require './models/status'


News = mongoose.model 'News'
Status = mongoose.model 'Status'

exports.urlFetch = urlFetch = (url, cb) ->
  http.get urlParse(url), (res) ->
    buffer = new bufferhelper()

    res.on 'data', (chunk) ->
      buffer.concat chunk

    res.on 'end', ->
      html = buffer.toBuffer()
      cb html

  .on 'error', (e) ->
    console.log e

exports.getUrls = getUrls = (url, format, cb) ->
  urlFetch url, (html) ->
    html = html.toString()
    format_g = new RegExp(format, 'g')
    paths = html.match format_g
    cb paths

initHandler = (mapper, getTitle, getContent, status, urls) ->
  return (paths) -> # return our handler
    urls = _.map paths, mapper

    cmpValue = status.latest_cmp
    urls = _.filter urls, ([url, cv]) ->
      cv > cmpValue

    if not _.isEmpty urls
      console.log "filtered urls: #{urls.length}"
      console.log urls

      async.forEach(urls,
        (item, callback) ->
          [url, cv] = item
          urlFetch url, (html) ->
            title = getTitle(html)
            content = getContent(html)

            console.log "title: ", title, "&& url: ", url

            if title? and content?
              news = new News({
                original_url: url
                cmp_value: cv
                title: title
                content: content
                from_where: status.from_where
              })
              news.save()
            callback()
        , (err) ->
          max_cmp_value = _.max(urls.map ([url, cv]) -> (cv))
          status.latest_cmp = max_cmp_value
          status.save()
      )
    
    

exports.main = main = ->

  fetchers_dir = path.join(__dirname, 'fetchers')

  console.log 'Status.find()'
  Status.find({}, (err, statuses) ->
    if err
      console.log err
    for status in statuses
      fetcher = require path.join(fetchers_dir, status.from_where)
      {urls, newsUrlFormat, mapper, getTitle, getContent} = fetcher
      urlsHandler = initHandler(mapper, getTitle, getContent, status)
      for url in urls
        getUrls url, newsUrlFormat, urlsHandler
  )

if not module.parent?
  console.log "main function..."
  main()




