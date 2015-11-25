"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _register place for place in  ZENrequest.PLACES
  tasks.push _findPlacesAround()
  tasks

#  APIs ------------------------------------------------------------------------
_register = (place) -> ->
  message = "Should register a place: #{place.name}"
  Test "POST", "api/place", place, null, message, 200

_findPlacesAround = -> ->
  paramenters =
    latitude  : 51.5430508
    longitude : -0.1219222
    radius    : 2000
  message = "Should return array of places around a geopoint"
  Test "GET", "api/places", paramenters, null, message, 200




