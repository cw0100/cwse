settings = require('../settings')
mongoose = require('mongoose')
mongoose.connect 'mongodb://' + settings.host + '/' + settings.db, {
  server:
    poolSize: 3
}


conn = mongoose.connection
conn.on 'connected', ()->
  console.log("connected")

exports.disconnect = ()->
  mongoose.disconnect (err)->
    console.log 'all connections closed'



