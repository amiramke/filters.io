window.Filters = {

  init: (filepicker, api)->
    @api = api
    # Workaround for CamanJS store method that does not let us access the same id or class twice
    Filters.applyCount = 0

    # Event bindings
    $('#upload').on 'click', (event) ->
      filepicker.pick {container: 'modal'}, (FPFile) ->
        Filters.filename = FPFile.filename
        Filters.sendPhotoUrl(FPFile.url)

  # Saves the url of where the photo is stored in the database
  sendPhotoUrl: (url, api) ->
    api = api || @api;
    api.sendPhotoUrl(url).complete (text) ->
      Filters.renderHTML(text)
      Filters.createPreview()

  # Replace container contents with new html
  # Usually html contains the images in a partial from the rails backend
  renderHTML: (html_string) ->
    $('div#container').html(html_string)

  # Hide the two images & buttons from the partial
  # Create a CamanInstance from .image
  # Then render filter buttons and bind events to them
  createPreview: ->
    $('button').hide()
    $('.image').hide()
    $('.image-clone').hide()
    Filters.camanCanvas = Caman '.image', ->
      Filters.renderFilterButtons()
      Filters.createFilterBindings()

  # Append buttons to #filter-buttons div and select Original as active
  renderFilterButtons: ->
    $('button').show()
    Filters.toggleActiveFilter($('#original'))

  # Register click event listeners on filter buttons
  createFilterBindings: ->
    $('#original').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.cloneCanvas()
    $('#save-button').on 'click', (event) ->
      Filters.storeBase64()
    $('button.filter').on 'click', (event) ->
      Filters.applyFilter()

  # Disable all filter buttons while filter is being applied
  # Clone the canvas for future use
  # Render the specific filter related to click event
  applyFilter: =>
    Filters.disableButtons()
    Filters.toggleActiveFilter(event.target)
    Filters.cloneCanvas()
    Filters.renderFilter(event.target.id)

  # Fade in / fade out effect and set active class on clicked button
  toggleActiveFilter: (button) ->
    $('.active-filter').fadeTo( 1000, 1 )
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

  # Render filter according to name
  renderFilter: (filter_name) ->
    Filters.camanCanvas[filter_name]()
    Filters.lastFilterUsed = filter_name
    Filters.camanCanvas.render ->
      Filters.enableButtons()

  # Convert filtered canvas to Base64 and strip out metadata
  # Upload image to filepicker.io and trigger export modal
  storeBase64: ->
    raw_data = Filters.camanCanvas.toBase64()
    raw_data = raw_data.replace("data:image/png;base64,", "")
    filename = "#{Filters.lastFilterUsed}_#{Filters.filename}"

    # If not keeping track of users' filtered photos, should find a way to avoid re-uploading photo
    # to filepicker.io before allowing user to save the image
    filepicker.store raw_data, { filename: filename, base64decode: true, mimetype: 'image/png' }, (FPFile) ->
      filepicker.export(FPFile)

  disableButtons: ->
    $('button.filter').attr("disabled", "disabled")

  enableButtons: ->
    $('button.filter').removeAttr("disabled")

}
