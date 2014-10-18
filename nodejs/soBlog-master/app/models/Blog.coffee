mongoose=require 'mongoose'
Schema=mongoose.Schema


blogSchema=new Schema
    content:String
    markdownText:String
    contentBegin:String
    tags:[{tag:String,id:Number}]
    title:String
    user:String
    date:Date
    time:
      year:String,
      month:String,
      day: String,
      minute:String
    imgs:[String]
    img:{original:String,px200:String,px600:String,px1366:String}
    isTop:{type:Boolean,default:false}
    pv:{type:Number,default:0}
    editDate:[{date:Date,ip:String}]




blogSchema.statics=
   returnTopBlog:(cb)->
     @find({isTop:true}).sort({isTop:-1,date:-1}).limit(5).exec((err,blogs)->
          if err
            cb err,null
          else
            cb null,blogs
     )
   returnPerpageBlogIndex:(perpage,cb)->
      blogThis=@
      @count().exec((err,count)->
          if err
            cb err,null,0
          else
            blogThis.find({}).sort({date:-1}).limit(perpage).exec((err,blogs)->
              if err
                cb err,null,0
              else
                cb null,blogs,count
            )
      )
   returnPerpageBlog:(perpage,page,cb)->
     blogThis=@
     @count().exec((err,count)->
          if err
            cb err,null,0
          else
             blogThis.find({},null,{skip:(page-1)*perpage,limit:perpage}).sort({date:-1}).select('title contentBegin time').exec((err,blogs)->
                if err
                  cb err,null,0
                else
                  cb null,blogs,count
             )
     )

   returnBlogById:(id,cb)->
     @findById(id).exec((err,blog)->
          if err
            cb err,null
          else
            cb null,blog
     )

   updateBlogPv:(id)->
     @update({_id:id},{$inc:{"pv":1}}).exec()
   returnView:(year,month,cb)->
     condition=null
     @collection.group(
       {"time.month":true}
       condition
       {count:0,blogs:[]},
       (doc,aggregator)->
         aggregator.count+=1
         aggregator.blogs.push doc
       null,null,null,(err,results)->
          #console.log results
          cb err,results
     )

Blog=mongoose.model 'Blog',blogSchema
module.exports=Blog