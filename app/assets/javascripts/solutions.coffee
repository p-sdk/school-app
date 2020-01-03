# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  description = $ '.solution-description'
  if description.length
    button = $ '<a id="show-desc" class="btn btn-default" href="#"><i class="fa fa-file-text"></i> Pokaż opis</a>'
    sidebar = $('#sidebar')
    sidebar.append(button)
    description.hide()
    button.on 'click', (e) ->
      button.toggleClass 'active'
      description.slideToggle()
      false
