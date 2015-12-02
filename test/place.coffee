"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _register place for place in  ZENrequest.PLACES
  tasks.push _findPlacesAround()
  tasks.push _getDetails ZENrequest.PLACES[0]
  tasks

#  APIs ------------------------------------------------------------------------
_register = (place) -> ->
  message = "Should register a place: #{place.name}"
  Test "POST", "api/place", place, null, message, 200, (response) ->
    place.id = response.id

_findPlacesAround = -> ->
  paramenters =
    latitude  : 51.5430508
    longitude : -0.1219222
    radius    : 2000
  message = "Should return array of places around #{paramenters.latitude} and
            #{paramenters.longitude}"
  Test "GET", "api/places", paramenters, null, message, 200

_getDetails = (place) -> ->
  message = "Should return details of #{place.name}"
  Test "GET", "api/place/#{place.id}", null, null, message, 200
