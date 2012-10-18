    express = require 'express'
    app = express()
    app.set 'jsonp callback', true
    mongoose = require 'mongoose'
    request = require 'request'
    $ = require 'jquery'
    fs = require 'fs'

    mongoose.connect process.env.MONGOHQ_URL or 'mongodb://127.0.0.1/sampledb'

    Schema = mongoose.Schema
    ObjectId = Schema.ObjectID

    Recipe = new Schema
      title: String

    Recipe = mongoose.model 'Recipe', Recipe

    app.set 'view engine', 'ejs'
    app.set 'views', __dirname + '/views'
    app.use express.bodyParser()
    app.use express.static __dirname + '/public'

    appkit = []
    appkit.recipe = []

    appkit.twitter = (req,res) ->
      res.render 'index.ejs'

    appkit.sandbox = (req,res) ->
      res.render 'sandbox.ejs'

    appkit.recipe.read = (req,res) -># {{{
      Recipe.find {}, (error,data) ->
        res.json data# }}}
    appkit.recipe.create = (req,res) -># {{{
      recipeInfo =
        title: req.params.title
      recipe = new Recipe(recipeInfo)
      recipe.save (error, data) ->
        if(error)
          res.json error
        else
          res.json data# }}}
    appkit.recipe.delete = (req,res) -># {{{
      Recipe.find({_id:req.params.id}).remove()
      res.send 'done'# }}}

    #appkit.recipe.update = (req,res) ->
      #res.send 'update'


    app.get '/twitter', appkit.twitter

    app.get '/sandbox', appkit.sandbox

    app.get '/v1/*', (req,res,next) ->
      res.contentType('application/json')
      next()
    app.post '/v1/*', (req,res,next) ->
      res.contentType('application/json')
      next()
    app.put '/v1/*', (req,res,next) ->
      res.contentType('application/json')
      next()
    app.delete '/v1/*', (req,res,next) ->
      res.contentType('application/json')
      next()

    app.get '/v1/recipes', appkit.recipe.read
    app.post '/v1/recipe/:title', appkit.recipe.create
    #app.update '/v1/recipe/:id', appkit.recipe.update
    app.delete '/v1/recipe/:id', appkit.recipe.delete

    app.listen(process.env.PORT || 3001)
