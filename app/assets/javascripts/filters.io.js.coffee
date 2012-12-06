window.Filters = {

  init: (filepicker, api)->
    Filters.api = api
    Filters.applyCount = 0

    # Event bindings
    $('#upload').on 'click', (event) ->
      filepicker.pick {container: 'modal', services: ['COMPUTER', 'URL', 'FACEBOOK', 'INSTAGRAM', 'DROPBOX', 'FLICKR', 'WEBCAM', 'IMAGE_SEARCH']}, (FPFile) ->
        Filters.filename = FPFile.filename
        Filters.sendPhotoUrl(FPFile.url)

  sendPhotoUrl: (url, api) ->
    api = api || @api
    api.sendPhotoUrl(url).complete (response) ->
      Filters.renderHTML(response.responseText)
      Filters.createPreview()

  renderHTML: (html_string) ->
    $('div#container').html(html_string)

  # Create a CamanInstance from .image
  # Then render filter buttons and bind events to them
  createPreview: ->
    Filters.toggleProcessingIndicator()
    $('button').hide()
    $('.image').hide()
    $('.image-clone').hide()
    Filters.camanCanvas = Caman '.image', ->
      Filters.renderFilterButtons()
      Filters.createFilterBindings()

  renderFilterButtons: ->
    $('button').show()
    Filters.toggleActiveFilter($('#original'))

  createFilterBindings: ->
    $('#original').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
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
  # Use Filters.applyCount to work around Caman limitation with re-using class/id names
  # Add cloned element to DOM
  cloneCanvas: ->
    clone = $('.image-clone').clone()
    revert_id = "revert#{Filters.applyCount}"
    $('.image-clone').attr({ id: revert_id })
    revert_id = "##{revert_id}"
    Filters.camanCanvas = Caman(revert_id)



    $('canvas:last').remove()
    $('#filter-preview').prepend(clone)

    # Used to work around Caman limitation with re-using class/id names
    Filters.applyCount += 1

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
