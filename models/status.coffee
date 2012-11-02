mongoose = require 'mongoose'
Schema = mongoose.Schema

StatusSchema = new Schema({
  from_where: {type: String, unique: true}
  latest_cmp: Number
})

mongoose.model 'Status', StatusSchema
