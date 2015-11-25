"use strict"

Place = require "../common/models/place"

module.exports = (server) ->
  ###
   * Register place
   * @method  POST
   * @param
  ###
  server.post "/api/place", (request, response) ->
    if request.required ["name"]
      Place.register(request.parameters).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          response.json result.parse()

  ###
   * Find places around
   * @method  GET
   * @param
  ###
  server.get "/api/places", (request, response) ->
    if request.required ["latitude", "longitude"]
      Place.findAround(request.parameters).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          response.json (place.parse() for place in result)
