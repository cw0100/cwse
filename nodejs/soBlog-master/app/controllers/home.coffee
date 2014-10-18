Cover = require '../models/Cover.js'
async = require 'async'
Blog = require '../models/Blog.js'
notp = require 'notp'
settings=require '../../settings.js'
t2 = require 'thirty-two'
marked=require 'marked'


marked.setOptions
  renderer: new marked.Renderer(),
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  smartypants: false

key = settings.googleAuthKey
b32 = t2.encode key
console.log "key for googleAuth app: " +b32.toString()
exports.index = (req, res)->
  Cover.readTopAndCount (err, cover, count)->
    total = 0
    hasCover = false
    topBlog = {}
    if(err)
      cover = new Cover(
        contentBegin: '崇尚自由，追求简约'
        img: {original: "/images/bg.jpg"})
    else
      hasCover: true
      total: count
      cover.content=marked cover.content

    Blog.returnTopBlog (err, blogs)->
      if err
        blogs = []
      res.render 'home/index',
        title: settings.titles.index
        user: req.session.user
        cover: cover
        topblogs: blogs
        hascover: hasCover
        total: count
        isLastPage: total == 1
    return

exports.about = (req, res)->
  Cover.readTopAndCount (err, cover, count)->
    total = 0
    hasCover = false
    topBlog = {}
    if(err)
      cover = new Cover(
        contentBegin: '崇尚自由，追求简约'
        img: {original: "/images/bg.jpg"})
    else
      hasCover: true
      total: count
      cover.content=marked cover.content

    res.render 'home/about',
        title: settings.titles.index
        user: req.session.user
        cover: cover
        total: count
    return

exports.manage = (req, res)->
  Blog.find({}).sort({date: -1}).exec (err, blogs)->
    if err
      blogs = []
    Cover.find({}).sort({date: -1}).exec (err, covers)->
      if err
        covers = []
      res.render 'home/manage',
        title: settings.titles.manage,
        blogs: blogs,
        covers: covers,
        user: req.session.user
exports.login = (req, res)->
  if req.body.email != settings.loginUserName or req.body.password != settings.loginPwd
    res.redirect('/login')
  else
    req.session.login = "googleauth"
    res.redirect("/google-auth")


exports.googleAuthView = (req, res)->
  console.log b32.toString()
  res.render 'home/googleAuth',
    title: settings.titles.login,
    user: req.session.user
exports.googleAuth = (req, res)->
  code = req.body.code.trim()
  if (notp.totp.verify code, key, {})
    req.session.user = "lingyong"
    res.redirect '/manage'
  else
    res.redirect '/google-auth'


exports.logout = (req, res)->
  req.session.user = null
  res.redirect('/')
exports.loginView = (req, res)->
  res.render 'home/login',
    titlt: settings.titles.login

exports.checkPwd = (req, res, next)->
  if !req.session.login
    res.redirect '/login'
  next()
exports.checkLogin = (req, res, next)->
  if !req.session.user
    res.redirect('/login')
  next()
exports.checkLogout = (req, res, next)->
  if req.session.user
    return res.redirect('/')
  next()
