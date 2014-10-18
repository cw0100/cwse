Blog = require '../models/Blog'
mongoose = require 'mongoose'
ArticleSub = require '../help/ArticleSub'
path = require 'path'
join = path.join
settings = require '../../settings'
fs = require 'fs'
async = require 'async'
Cover = require '../models/Cover'
formidable = require 'formidable'
env=require('jsdom').env
qn=require 'qn'
marked=require 'marked'
sanitizeHtml=require 'sanitize-html'

marked.setOptions
  renderer: new marked.Renderer(),
  gfm: true,
  tables: true,
  breaks: true,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  smartypants: false

Perpage = settings.perPageBlogSize
html="<html><body></body></html>"
client=qn.create settings.QnClient

postPre = (req, res, cb)->
  req.assert('text', 'Content should not be empty！').notEmpty()
  req.assert('title', 'Title should not be empty！').notEmpty()
  errows = req.validationErrors()
  if errows
    res.json
      err: errows
      success: false
  else
    content = req.body.text
    title = req.body.title
    tags=[]
    tags.push({tag:req.body['tag'+i.toString()],id:i}) for i in [1..3]
    console.log tags
    imgs = []
#    converter = new showdown.converter
#      extensions: ['table']
#    blogHtml=converter.makeHtml(content)
    blogHtml=marked content
    #console.log blogHtml
    img = ''
    text=sanitizeHtml blogHtml,
      allowedTags:[ 'a','p','pre','ul','li','em','b','i']
      allowedAttributes:
        'a':['href']
    text = ArticleSub.subArtc(text, 200).toString() + ''
    contentBegin = text.replace /<img.*?>/ig, ""
    date = new Date()
    ip = req.ip
    env html,(err,window)->
      console.log err
      $=require('jquery')(window)
      $('body').append(blogHtml)
      $('img').each (index)->
        imgs.push $(this).attr("src")
        console.log imgs
        if index==0
          img=$(this).attr("src")
          cb content, title, tags, imgs, contentBegin, img, date, ip
      if $('img').length==0
        cb content, title, tags, imgs, contentBegin, img, date, ip



  return
exports.blogPerpage = (req, res)->
  Blog.returnPerpageBlogIndex(Perpage, (err, blogs, count)->
    if err
      blogs = []
    #console.log blogs[0].contentBegin.toString()
    res.render 'blog/bloglist',
      title: settings.titles.blog_bloglist,
      posts: blogs,
      OnlyOnePage: count <= Perpage,
      user: req.session.user
  )
exports.getBlogPerpage = (req, res)->
  page = parseInt(req.query.page)
  Blog.returnPerpageBlog(Perpage, page, (err, blogs, count)->
    if err
      res.json
        success: false
        info: 'fail to get！'
    else
      isLastPage = ((page - 1) * Perpage + blogs.length) == count;
      res.json
        total: count
        success: true
        blogs: blogs
        isLastPage: isLastPage
  )

exports.perBlog = (req, res)->
  id = req.params.id
  Blog.updateBlogPv(id)
  Blog.returnBlogById(id, (err, blog)->
    if err
      blog = {}
    #console.log blog.content
#    converter = new showdown.converter()
#    blog.content=converter.makeHtml(blog.content)
    blog.content=marked blog.content
    res.render 'blog/perBlog',
      title: blog.title + " · " +settings.titles.blog_perBlog
      blog: blog
      blogid: req.params.id
      user: req.session.user
  )

exports.postView = (req, res)->
  count = 1
  tags = []
  while count < 4
    tags.push({tag: '', id: count})
    count++
  res.render 'blog/post',
    title: settings.titles.blog_post,
    user: req.session.user
    blog: new Blog({tags: tags,content:''})
    action: "post"
exports.post = (req, res)->
  postPre(req, res, (content, title, tags, imgs, contentBegin, img, date, ip)->

    blog = new Blog(
      content: content,
      title: title,
      contentBegin: contentBegin,
      tags: tags,
      img:
        px600: img.replace 'px1366','px600'
        px200: img.replace 'px1366','px200'
        original: img.replace 'px1366',''
        px1366: img

      imgs: imgs,
      user: req.session.user,
      date: date,
      time:
        year: date.getFullYear(),
        month: date.getFullYear() + "-" + (date.getMonth() + 1),
        day: date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate(),
        minute: date.getHours() + ':' + date.getMinutes()


      ip: ip
    )
    blog.save((err)->
      if err?
        res.json
          success:false
          err:err
      else
        res.redirect 'blog'
    )
  )
exports.postImg = (req, res)->
  form = new formidable.IncomingForm()
  form.encoding='utf-8'
  form.uploadDir =path.join settings.root, 'upload_tmp'
  form.keepExtensions = true
  form.maxFieldsSize = 2 * 1024 * 1024
  form.keepAlive=true
  postFrom=""
  if req.path=='/post'
    postFrom='blog'
  else
    postFrom='cover'
  form.parse req,(err,fields, files)->
    if err
      res.json
        success:false
      return

    extName=''
    #console.log files
    switch files.upload.type
      when 'image/pjpeg' then extName='jpg'
      when 'image/jpeg' then extName='jpg'
      when 'image/png' then extName='png'
      when 'image/x-png' then extName='png'
    console.log extName
    if extName.length==0
      res.json
        success:false
      return
    date = new Date()
    img = files.upload
    name =img.name+" "+date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes()

    client.uploadFile files.upload.path,{key:name},(err,result)->
      if err
        res.json
          success:false
        return
      fs.unlink files.upload.path
      res.json
            success: true
            form:postFrom
            path:
              original: result.url
              px200: result.url+"-px200"
              px600: result.url+"-px600"
              px1366: result.url+"-px1366"

exports.editBlogView = (req, res)->
  id = mongoose.Types.ObjectId(req.params.id)
  Blog.findById id, null, (err, doc)->
    count = 1
    len = doc.tags.length
    while count < 4 - len
      doc.tags.push({tag: ''})
      count++


    res.render 'blog/post',
      title: settings.titles.blog_edit,
      blog: doc,
      user: req.session.user
      action: "editblog"

exports.editBlog = (req, res)->
  id = req.params.id
  postPre req, res, (content, title, tags, imgs, contentBegin, img, date, ip)->

    blog =
      content: content,
      title: title,
      contentBegin: contentBegin,
      tags: tags,
      img:
        px600: img.replace 'px1366','px600'
        px200: img.replace 'px1366','px200'
        original: img.replace 'px1366',''
        px1366: img

      imgs: imgs

    Blog.update {_id: id}, {$set: blog, $push: {"editDate": {date: date, ip: ip}}}, (err, num, row)->
      if err and num == 0
        res.json
          success: false
      else
        res.redirect '/blog'

exports.viewIndex = (req, res)->
  Blog.returnView null, null, (err, monthBlogs)->
    if err
      monthBlogs = []
    res.render "blog/view",
      title: settings.titles.blog_view
      MonthBlogs: monthBlogs
      user: req.session.user
exports.deleteBlog = (req, res)->
  id = req.query.id
  console.log id
  Blog.remove({_id: id}).exec (err)->
    if err
      res.json({success: false})
    else
      res.json({success: true})
exports.setTop = (req, res)->
  istop = false
  id = req.query.id
  if req.query.istop == 'true'
    istop = true
  Blog.update({_id: id}, {$set: {isTop: istop}}).exec (err)->
    if err
      res.json({success: false})
    else
      res.json({success: true})


























