window.Filters = {

  init: (api)->
    Filters.api = api
    Filters.createUploadBinding()

  createUploadBinding: ->
    $('#upload').on 'click', (event) ->
      Filters.pickPhoto()
      
  pickPhoto: ->
    services = ['COMPUTER', 'URL', 'FACEBOOK', 'INSTAGRAM', 'DROPBOX', 'FLICKR', 'WEBCAM', 'IMAGE_SEARCH']
    filepicker.pick { container: 'modal', services: services}, (FPFile) ->
      Filters.filename = FPFile.filename
      Filters.sendPhotoUrl(FPFile.url)

  sendPhotoUrl: (url, api) ->
    api = api || @api
    api.sendPhotoUrl(url).complete (data) ->
      Filters.renderPartial(data.responseText)
      Filters.createPreview()

  renderPartial: (html_string) ->
    $('div#container').html(html_string)

  # Create a CamanInstance from .image
  # Then render filter buttons and bind events to them
  createPreview: ->
    Filters.toggleProcessingIndicator()
    $('button').hide()
    $('.image').hide()
    $('.image-clone').hide()
    Filters.camanCanvas = Caman '.image', ->
      $('#loading').remove()
      Filters.renderFilterButtons()
      Filters.createFilterBindings()

  renderFilterButtons: ->
    $('button').show()
    Filters.toggleActiveFilter($('#original'))

  createFilterBindings: ->
    $('#new-button').on 'click', (event) ->
      Filters.pickPhoto()
    $('#original').on 'click', (event) ->
      Filters.toggleActiveFilter(event.target)
      Filters.cloneCanvas()
    $('#save-button').on 'click', (event) ->
      Filters.disableButtons()
      Filters.toggleProcessingIndicator()
      Filters.storeBase64()
    $('button.filter').on 'click', (event) ->
      Filters.applyFilter(event)

  applyFilter: (event) ->
    Filters.disableButtons()
    Filters.toggleProcessingIndicator()
    Filters.toggleActiveFilter(event.target)
    Filters.cloneCanvas()
    Filters.renderFilter(event.target.id)

  toggleActiveFilter: (button) ->
    Filters.lastFilterUsed = $(button).attr("id")
    $('.active-filter').fadeTo( 1, 1 )
    $('.active-filter').toggleClass("active-filter")
    $(button).toggleClass("active-filter")
    $(button).fadeTo( 1000, .5 )

  # Clone .image-clone element
  # Add cloned element to DOM
  cloneCanvas: ->
    clone = $('.image-clone').clone()
    Filters.camanCanvas = Caman('.image-clone')
    $('canvas:last').remove()
    $('#filter-preview').prepend(clone)

  renderFilter: (filter_name) ->
    Filters.camanCanvas[filter_name]()
    Filters.camanCanvas.render ->
      Filters.enableButtons()
      Filters.toggleProcessingIndicator()

  # Convert filtered canvas to Base64 and strip out metadata
  # Upload image to filepicker.io and trigger export modal
  storeBase64: ->
    raw_data = Filters.camanCanvas.toBase64()
    raw_data = raw_data.replace("data:image/png;base64,", "")
    filename = "#{Filters.filename.replace(/\..+$/, "")}_#{Filters.lastFilterUsed}.png"

    # If not keeping track of users' filtered photos, should find a way to avoid re-uploading photo
    # to filepicker.io before allowing user to save the image
    filepicker.store raw_data, { filename: filename, base64decode: true, mimetype: 'image/png' }, (FPFile) ->
      filepicker.export(FPFile)
      Filters.toggleProcessingIndicator()
      Filters.enableButtons()

  disableButtons: ->
    $('button').attr("disabled", "disabled")

  enableButtons: ->
    $('button').removeAttr("disabled")

  toggleProcessingIndicator: ->
    $('#processing img').toggle()

}