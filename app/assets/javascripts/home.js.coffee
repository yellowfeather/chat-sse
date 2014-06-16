# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  source = new EventSource("/events")
  source.addEventListener "message", (event) ->
    console.log event.data
    message = JSON.parse(event.data)
    $(".messages").append "<div class=sender>" + message.sender + "</div>" + "<div class=message>" + message.message + "</div>"

  source.addEventListener "open", (event) ->
    console.log event.data

  source.addEventListener "error", (event) ->
    console.log event.data

  $("form").submit (e) ->
    e.preventDefault()
    $.post "/messages",
      sender: $(".name").text()
      message: $("form .message").val()

    $("form .message").val ""

  $(".change-name").click ->
    name = prompt("Enter your name:")
    $(".name").text name
