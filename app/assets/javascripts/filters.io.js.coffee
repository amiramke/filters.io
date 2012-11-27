$(document).ready ->
  Filters.init()
  filepicker.setKey('A8bPQLUeRg6RglPocYMdGz')

Filters = {

  init: ->
    $('.image').hide()
    Filters.createPreview()

    # Event bindings
    $('button#upload').on 'click', (event) ->
      filepicker.pick (FPFile) ->
        Filters.toggleUploadButton()
        Filters.renderPhoto(FPFile.url)
        Filters.sendPhotoUrl(FPFile.url)

    $('button#sunrise').on 'click', (event) ->
      Filters.camanCanvas.revert()
      Filters.camanCanvas.sunrise().render()
    $('button#jarques').on 'click', (event) ->
      Filters.camanCanvas.revert()
      Filters.camanCanvas.jarques().render()
    $('button#concentrate').on 'click', (event) ->
      Filters.camanCanvas.revert()
      Filters.camanCanvas.concentrate().render()



  sendPhotoUrl: (url) ->
    deferred = $.ajax({
      type: 'POST'
      url: 'http://localhost:3000/photos'
      dataType: 'json'
      data: { photo: {photo_url: url} }
      complete: (json, status) ->
        Filters.renderHTML(json.responseText)
      })

  renderHTML: (html_string) ->
    $('div#container').html(html_string)

  renderPhoto: (url) ->
    $('div#container').append('<img src="' + url + '">')

  toggleUploadButton: ->
    $('button#upload').toggle()

  createPreview: ->
    Filters.camanCanvas = Caman('.image')

}
