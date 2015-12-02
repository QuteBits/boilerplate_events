"use strict"

Place = require "../common/models/place"

module.exports = (server) ->
  ###
   * Get a location by ID
   * @method  GET
   * @param
  ###
  server.get "/api/place/:id", (request, response) ->
    if request.required ["id"]
      Place.search(
        _id: request.parameters.id,
        limit = 1
      ).then (error, result) ->
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
   * Update place
   * @method  PUT
   * @param
  ###
  server.put "/api/place/:id", (request, response) ->
    if request.required ["id"]
      parameters = {}
      attributes = ["name", "description", "address", "site", "latitude",
                    "longitude"]
      for key in attributes when request.parameters[key]?
        parameters[key] = request.parameters[key]
      filter = _id: request.parameters.id

      Place.updateAttributes(filter, parameters).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          response.json result.parse()
