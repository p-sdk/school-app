# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  description = $ '.solution-description'
  button = $ '<a id="show-desc" class="btn btn-sm btn-default" href="#">pokaż opis</a>'
  description.before(button)
  description.hide()
  button.on 'click', (e) ->
    e.preventDefault()
    button.fadeOut()
    description.slideDown()
