// Generated by CoffeeScript 1.7.1
(function() {
  var Blog, Schema, blogSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  blogSchema = new Schema({
    content: String,
    markdownText: String,
    contentBegin: String,
    tags: [
      {
        tag: String,
        id: Number
      }
    ],
    title: String,
    user: String,
    date: Date,
    time: {
      year: String,
      month: String,
      day: String,
      minute: String
    },
    imgs: [String],
    img: {
      original: String,
      px200: String,
      px600: String,
      px1366: String
    },
    isTop: {
      type: Boolean,
      "default": false
    },
    pv: {
      type: Number,
      "default": 0
    },
    editDate: [
      {
        date: Date,
        ip: String
      }
    ]
  });

  blogSchema.statics = {
    returnTopBlog: function(cb) {
      return this.find({
        isTop: true
      }).sort({
        isTop: -1,
        date: -1
      }).limit(5).exec(function(err, blogs) {
        if (err) {
          return cb(err, null);
        } else {
          return cb(null, blogs);
        }
      });
    },
    returnPerpageBlogIndex: function(perpage, cb) {
      var blogThis;
      blogThis = this;
      return this.count().exec(function(err, count) {
        if (err) {
          return cb(err, null, 0);
        } else {
          return blogThis.find({}).sort({
            date: -1
          }).limit(perpage).exec(function(err, blogs) {
            if (err) {
              return cb(err, null, 0);
            } else {
              return cb(null, blogs, count);
            }
          });
        }
      });
    },
    returnPerpageBlog: function(perpage, page, cb) {
      var blogThis;
      blogThis = this;
      return this.count().exec(function(err, count) {
        if (err) {
          return cb(err, null, 0);
        } else {
          return blogThis.find({}, null, {
            skip: (page - 1) * perpage,
            limit: perpage
          }).sort({
            date: -1
          }).select('title contentBegin time').exec(function(err, blogs) {
            if (err) {
              return cb(err, null, 0);
            } else {
              return cb(null, blogs, count);
            }
          });
        }
      });
    },
    returnBlogById: function(id, cb) {
      return this.findById(id).exec(function(err, blog) {
        if (err) {
          return cb(err, null);
        } else {
          return cb(null, blog);
        }
      });
    },
    updateBlogPv: function(id) {
      return this.update({
        _id: id
      }, {
        $inc: {
          "pv": 1
        }
      }).exec();
    },
    returnView: function(year, month, cb) {
      var condition;
      condition = null;
      return this.collection.group({
        "time.month": true
      }, condition, {
        count: 0,
        blogs: []
      }, function(doc, aggregator) {
        aggregator.count += 1;
        return aggregator.blogs.push(doc);
      }, null, null, null, function(err, results) {
        return cb(err, results);
      });
    }
  };

  Blog = mongoose.model('Blog', blogSchema);

  module.exports = Blog;

}).call(this);

//# sourceMappingURL=Blog.map
