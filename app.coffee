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

    Client = new Schema
      name:
        type: String
        trim: true
      project: [Project]


    Client = mongoose.model 'Client', Client

    app.set 'view engine', 'ejs'
    app.set 'views', __dirname + '/views'
    app.use express.bodyParser()
    app.use express.static __dirname + '/public'



    k5app.listClient = (req,res) ->
      res.render 'list-client.ejs'

    k5app.getSingleClient = (req,res) ->
      Client.findOne {_id: req.params.id }, (error,data) ->
        res.json data

    k5app.addclient = (req,res) ->
      client_data =
        name: req.params.name

      client = new Client(client_data)
      client.save (error, data) ->
        if(error)
          res.json error
        else
          res.json data


    k5app.addClientProject = (req,res) ->
      client = new Client()# {{{
      Client.findOne {_id: req.params.id}, (error,client) ->
        if(error)
          res.json(error)
        else if(client == null)
          res.json('no such client')
        else
          client.project.push({ projectId: req.query.projectId })
          client.save (error, data) ->
            if(error)
              res.json error
            else
              res.json data
          # }}}

    app.get '/v1/clients/:id', k5app.getSingleClient


    app.listen(process.env.PORT || 3001)

