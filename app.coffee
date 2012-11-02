express = require 'express'
mongoose = require 'mongoose'
path = require 'path'
fs = require 'fs'
_ = require 'underscore'
_.str = require 'underscore.string'

config = require './config'
myUtil = require './util'

mongoose.connect config.mongourl


# register Models
models_path = path.join(__dirname, 'models')
model_files = fs.readdirSync(models_path)
myUtil.uniqFilenames(model_files).forEach (file) ->
  require(path.join(models_path, file))

News = mongoose.model 'News'
Status = mongoose.model 'Status'

app = express()

app.configure ->
  # settings
  app.set 'port', process.env.PORT or 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  # middlewares
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use app.router
  app.use require('stylus').middleware(__dirname + '/public')
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler()

# routes
#
app.get '/api', (req, res) ->
  Status.find {}, {from_where: 1}, (err, statuses) ->
    fetchers = statuses.map (status) ->
      fetcher = _.str.strLeft(status.from_where, '.')
    res.render 'api', {fetchers: fetchers}

app.get '/api/startfetch', (req, res) ->
  require('./mainFetcher').main()
  #res.send 'starting fetching...'


app.get '/api/:subdomain/:limit', (req, res) ->
  from_where = req.params.subdomain + '.scu.edu.cn'
  limit = parseInt(req.params.limit)
  News.find({from_where: from_where}).sort('-cmp_value').limit(limit).execFind (err, newses) ->
    res.json newses

app.listen app.get('port'), ->
  console.log "Express server is listening..."
