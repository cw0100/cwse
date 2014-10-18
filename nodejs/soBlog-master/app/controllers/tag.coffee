async = require 'async'
Blog = require '../models/Blog'
mongoose = require 'mongoose'
ArticleSub = require '../help/ArticleSub'
settings=require '../../settings'

exports.getAllTags = (req, res)->
  tagsInfo = []
  async.waterfall [
      (cb)->
        Blog.distinct 'tags.tag', (err, tags)->
          cb err, tags
    ,
      (tags, cb)->
        async.forEachLimit tags, 1, getTagInfo, (err)->
          cb err, tagsInfo
    ]
  , (err, tagsInfo)->
    if err
      tagsInfo = []

    res.render 'tags/index',
      title:settings.titles.tags
      tags: tagsInfo
      user: req.session.user


  getTagInfo = (tag, cb)->
    Blog.count({"tags.tag": tag}, null).exec (err, count)->
      if err and count == 0
        count = "failed！"
      if tag == ''
        cb()
      else
        tagsInfo.push
          tag: tag
          count: count
        cb()



exports.eachTag = (req, res)->
  tag = req.params.tag
  Blog.find({"tags.tag": tag}, null).sort({date: -1}).exec (err, blogs)->
    if err
      blogs = []
    res.render 'tags/eachtag',
      title: tag + " · "+settings.titles.eachTag,
      blogs: blogs,
      tag: tag,
      count: blogs.length,
      user: req.session.user
