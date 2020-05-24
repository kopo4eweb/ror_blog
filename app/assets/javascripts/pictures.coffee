# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  Trix.config.attachments.preview.caption = { name: false, size: false }

  document.addEventListener 'trix-attachment-add', (event) ->
    attachment = event.attachment
    if attachment.file
      return sendFile(attachment)
    return

  document.addEventListener 'trix-attachment-remove', (event) ->
    attachment = event.attachment
    deleteFile attachment

  sendFile = (attachment) ->
    token = getToken()

    file = attachment.file
    form = new FormData
    form.append 'Content-Type', file.type
    form.append 'picture[image]', file
    xhr = new XMLHttpRequest
    xhr.open 'POST', '/pictures', true
    xhr.setRequestHeader("X-CSRF-Token", token);

    xhr.upload.onprogress = (event) ->
      progress = undefined
      progress = event.loaded / event.total * 100
      attachment.setUploadProgress progress

    xhr.onload = ->
      response = JSON.parse(@responseText)
      attachment.setAttributes
        url: response.url
        picture_id: response.picture_id
        href: response.url

    xhr.send form

  deleteFile = (n) ->
    token = getToken()
    $.ajax
      method: 'DELETE'
      url: '/pictures/' + n.attachment.attributes.values.picture_id
      headers: {"X-CSRF-Token": token}
      cache: false
      contentType: false
      processData: false

  getToken = () ->
    $('meta[name="csrf-token"]').attr('content')

  return