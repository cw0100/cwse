soBlog
============

>A simple blog built by node.js , express4 and mongodb. Live demo just look at here : [lingyong.me](http://lingyong.me)



## Getting Started

Before you start in soBlog, you should install node.js and mongodb. 

After that you should pull the code to local. 

Do that : 

```
npm install
```
or

```
sudo npm install
```
And then, edit the settings.example.js to settings.js.

```
(function() {
  module.exports = {
    cookieParser: '',    
    cookieSecret: '',
    db: 'qorablog',        //mongodb db_name
    host: 'localhost',
    root: __dirname,      
    QnClient: {            //Using qiuniu to store images.
      accessKey: '',             
      secretKey: '',
      bucket: '',
      domain: ''
    },
    perPageBlogSize: 10,   //In bloglist view, how many blogs can be shown.
    googleAuthKey: '',    //When you login blog, there will have a googleAuth, this is the googleAuthKey.
    loginPwd: '',         //Passwd to login.
    loginUserName: '',    //UserName to login.
    titles: {
      blog_bloglist: "Blog · QORA BLOG · Innovative From The Core",
      blog_perBlog: "QORA BLOG · Innovative From The Core",
      blog_post: "POST BLOG · Innovative From The Core",
      blog_view: "View · QORA BLOG · Innovative From The Core",
      blog_edit: "Edit · QORA BLOG · Innovative From The Core",
      cover: "Cover · QORA BLOG · Innovative From The Core",
      eachCover: "QORA BLOG · Innovative From The Core",
      postCover: "Post Cover · QORA BLOG · Innovative From The Core",
      editCover: "Edit Cover · QORA BLOG · Innovative From The Core",
      index: "QORA BLOG · Innovative From The Core",
      about: "QORA · Innovative From The Core",
      manage: "manage · QORA BLOG · Innovative From The Core",
      login: "login · QORA BLOG · Innovative From The Core",
      tags: "Tag · QORA BLOG · Innovative From The Core",
      eachTag: "QORA BLOG · Innovative From The Core"
    }
  };

}).call(this);

```

## Remark


soBlog use qiniu to store images, so before you can use soBlog you should register a account in [qiniu.com](http://qiniu.com). 

You also need edit the googleAuthKey, for example:

```
googleAuthKey: 'This_is_a_demoe_authkey'
```
After you start the soBlog in `node app.js`,you will see things like that:

```
express-session deprecated undefined saveUninitialized option; provide saveUninitialized option config/express.js:67:13
key for googleAuth app: KRUGS427NFZV6YK7MRSW233FL5QXK5DINNSXS===
Express server listening on port 3000
connected
```
So you should copy the `key for googleAuth app` to your googleAuth app.

## Watch out

OK, soBlog just a demo, not a product, so, if you want to use it to build your blog, you must be careful. 

It built in express4, jade, mongoose, bootstrap, so it may do some help for a node.js beginner.

And also , you should make a `upload_tmp` dir. 

## Screenshot 

<img width="" height="" class="amd-center" src="http://lingyong-me.qiniudn.com/Screenshot_2014-09-13-11-45-41.png 2014-9-13 11:49-px1366" alt="screenshot" />


<img width="" height="" class="amd-center" src="http://lingyong-me.qiniudn.com/Screenshot_2014-09-13-11-46-20.png 2014-9-13 11:50-px1366" alt="screenshot" />
<img width="" height="" class="amd-center" src="http://lingyong-me.qiniudn.com/00BCC562-F8F4-44C8-99F9-30FD82657524.png 2014-9-13 11:51-px1366" alt="screenshot" />

## Host

About host, I use [DigitalOcean](https://www.digitalocean.com/?refcode=107abaf7339b), my blog [lingyong.me](http://lingyong.me) is hosted in [DigitalOcean](https://www.digitalocean.com/?refcode=107abaf7339b).



