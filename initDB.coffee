config = require './config'
mongoose = require 'mongoose'
mongoose.connect config.mongourl

require './models/status'
require './models/news'

Status = mongoose.model 'Status'
News = mongoose.model 'News'



Status.remove({}, (err) ->
  for url in ['jwc.scu.edu.cn', 'www.scu.edu.cn']
    status = new Status({
      from_where: url
      latest_cmp: 0
    })

    console.log status
    status.save()
  
)

News.remove({}, (err) ->
  console.log "removed"
)



