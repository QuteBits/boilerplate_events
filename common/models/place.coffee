"use strict"

Hope    = require("zenserver").Hope
Schema  = require("zenserver").Mongoose.Schema
db      = require("zenserver").Mongo.connections.primary

Place = new Schema
  name        : type: String
  description : type: String
  address     : type: String
  site        : type: String
  position    : type: [Number], index: "2dsphere", default: [0,0]
  updated_at  : type: Date
  created_at  : type: Date, default: Date.now

# ------------------------------------------------------------------------------
Place.statics.register = (attributes) ->
  promise = new Hope.Promise()
  @findOne name: attributes.name, (error, value) ->
    if value?
      promise.done null, value
    else
      if attributes.latitude and attributes.longitude
        attributes.position = [attributes.longitude, attributes.latitude]
      place = db.model "Place", Place
      new place(attributes).save (error, value) -> promise.done error, value
  promise

Place.statics.findAround = (attributes) ->
  promise = new Hope.Promise()
  query =
    position:
      $nearSphere :
        $geometry :
          type        : "Point"
          coordinates : [attributes.longitude, attributes.latitude]
        $maxDistance : attributes.radius
  @find query, (error, values) -> promise.done error, values
  promise

# ------------------------------------------------------------------------------
Place.methods.parse = ->
  id          : @_id
  name        : @name
  description : @description
  address     : @address
  site        : @site
  latitude    : @position[1]
  longitude   : @position[0]
  updated_at  : @updated_at
  created_at  : @created_at

exports = module.exports = db.model "Place", Place
