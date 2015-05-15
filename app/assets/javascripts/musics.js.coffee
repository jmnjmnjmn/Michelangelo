# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# Rails creates this event, when the link_to(remote: true)
# successfully executes
$(document).on 'ajax:success', 'a.like-vote', (status,data,xhr)->
  # the `data` parameter is the decoded JSON object
  $(".like-count[data-id=#{data.id}]").text data.count
  return