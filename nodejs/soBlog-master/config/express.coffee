express = require 'express'
path = require 'path'
expressValidator = require 'express-validator'
settings = require '../settings'
logger = require 'morgan'
compress = require 'compression'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
cookieParser = require 'cookie-parser'
session = require 'express-session'
mongoStore = require('connect-mongo')(session)
serve_static = require 'serve-static'
formidable = require 'formidable'


module.exports = (app)->
  #all environments
  app.set "port", process.env.PORT or 3000
  app.set('showStackError', true)
  app.set 'title', "coffeeDemo"
  app.set('views', settings.root + '/app/views')
  app.set "view engine", "jade"
  app.set('font', settings.root + '/public/font');
  app.set('images', settings.root + '/public/images');


  app.use logger('dev')
  app.use compress
    filter: (req, res)->
      return /json|text|javascript|css/.test(res.getHeader('Content-Type'))
    level: 9
  app.use bodyParser.urlencoded
    extended: true
  app.use expressValidator
      errorFormatter: (param, msg, value)->
        namespace = param.split('.')
        root = namespace.shift()
        formParam = root
        while(namespace.length)
          formParam += '[' + namespace.shift() + ']'
        param: formParam
        msg: msg
        value: value
  app.use methodOverride()
  app.use cookieParser settings.cookieParser
  app.use session
    secret: settings.cookieSecret
    cookie: 1000*60*60*24*365
    resave:false
    store: new mongoStore
      db: settings.db

  app.use serve_static(path.join(settings.root, "public"))

# development only
# app.use express.errorHandler()  if "development" is app.get("env")