mongoose = require 'mongoose'
Schema = mongoose.Schema

NewsSchema = new Schema({
  original_url: String
  cmp_value: Number
  title: String
  content: String
  from_where: {type: String, index: true}
  got_date: {type: Date, default: Date.now}
})

NewsSchema.index({cmp_value: -1, original_url: 1}, {unique: 1})

mongoose.model 'News', NewsSchema
