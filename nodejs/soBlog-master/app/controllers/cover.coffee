Cover = require '../models/Cover'
mongoose = require 'mongoose'
ArticleSub = require '../help/ArticleSub'
settings=require '../../settings'
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
exports.index = (req, res)->
  Cover.find({}).sort(date: -1).exec (err, covers)->
    if err
      covers = []
    else

      res.render 'cover/cover',
        title: settings.titles.cover
        covers: covers
        user: req.session.user
exports.eachCover = (req, res)->

  id = req.params.id
  Cover.update({_id: id}, {$inc: {"pv": 1}}).exec()
  Cover.findById(id).exec (err, cover)->
    if err
      cover = {}
    cover.content=marked cover.content
    res.render 'cover/eachcover',
      title: cover.title + " · "+settings.titles.eachCover,
      cover: cover,
      user: req.session.user

exports.editCoverView = (req, res)->
  id = req.params.id
  Cover.findById(id).exec (err, cover)->
    res.render 'cover/postcover',
      title: settings.titles.editCover
      cover: cover
      user: req.session.user
exports.editCover = (req, res)->
  img = ''

  contentBegin=marked(req.body.quote)
  date = new Date()
  ip = req.ip
  img = req.body.img
  id = req.params.id
  quote =req.body.quote

  cover =
    content: req.body.text
    title: req.body.title
    contentBegin: contentBegin
    quote: quote
    img:
        px600: img+"-px600"
        px200: img+"-px200"
        original: img
        px1366: img+"-px1366"
  Cover.update({_id: id}, {$set: cover, $push: {"editdate": {date: date, ip: ip}}}).exec (err, cover)->
    if err
      res.send('update failed！')
    else
      res.redirect('/cover/' + id)
exports.postCoverView = (req, res)->
  res.render 'cover/postcover',
    title: settings.titles.postCover
    action:'post'
    user: req.session.user


exports.postCover = (req, res)->
  img = ''
  imgs = [];
  contentBegin=marked(req.body.quote)
  imgs.push(req.body.img)
  if imgs and imgs.length > 0
    img = imgs[0]
  date = new Date()
  ip = req.ip
  quote = req.body.quote
  cover = new Cover
    quote: quote
    content: req.body.text,
    title: req.body.title,
    contentBegin: contentBegin,

    imgs: imgs,

    img:
      px600: img+"-px600"
      px200: img+"-px200"
      original: img
      px1366: img+"-px1366"


    date: date,
    time:
      year: date.getFullYear(),
      month: date.getFullYear() + "-" + (date.getMonth() + 1),
      day: date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate(),
      minute: date.getHours() + ':' + date.getMinutes()

    ip: ip

  cover.save (err)->
    if err
      req.session.error = err;
      res.send(' Post failed！');
    else
      res.redirect('/cover/' + cover._id)
exports.deleteCover = (req, res)->
  id = req.query.id
  Cover.remove({_id: id}).exec (err)->
    if err
      res.json({success: false})
    else
      res.json({success: true})
exports.setTop = (req, res)->
  istop = false
  id = req.query.id
  if req.query.istop == 'true'
    istop = true
  Cover.update({_id: id}, {$set: {isTop: istop}}).exec (err)->
    if err
      res.json({success: false})
    else
      res.json({success: true})
      

















