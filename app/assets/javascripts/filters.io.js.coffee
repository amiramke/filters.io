$(document).ready ->
  Filters.init()
  filepicker.setKey('A8bPQLUeRg6RglPocYMdGz')

Filters = {

  init: ->
    Filters.registerFilters()
    Filters.applyCount = 0

    # Event bindings
    $('#upload').on 'click', (event) ->
      filepicker.pick {container: 'modal'}, (FPFile) ->
        Filters.sendPhotoUrl(FPFile.url)

  sendPhotoUrl: (url) ->
    $.ajax({
      type: 'POST'
      url: 'http://localhost:3000/photos'
      dataType: 'json'
      data: { photo: {url: url} }
      complete: (json, response) ->
        Filters.renderHTML(json.responseText)
        Filters.createPreview()
      })

  renderFilterButtons: ->
    html_string = "<button id='original'>original</button><button class='filter-button' id='xxpro'>xxpro</button><button class='filter-button' id='toasty'>toasty</button><button class='filter-button' id='memphis'>memphis</button><button id='save-button'>Save</button>"
    $('#filter-buttons').append(html_string)

  renderHTML: (html_string) ->
    $('div#container').html(html_string)

  createPreview: ->
    $('.image').hide()
    $('.image-clone').hide()
    Filters.camanCanvas = Caman '.image', ->
      Filters.renderFilterButtons()
      Filters.createFilterBindings()

  storeBase64: ->
    raw_data = Filters.camanCanvas.toBase64()
    raw_data = raw_data.replace("data:image/png;base64,", "")
    filepicker.store(raw_data, { filename: 'image', base64decode: true, mimetype: 'image/png'}, (FPFile) ->
      filepicker.export(FPFile)
      )

  createFilterBindings: ->
    $('#original').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.cloneCanvas()
    $('button#xxpro').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.cloneCanvas()
      Filters.camanCanvas.xxpro().render()
    $('button#toasty').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.cloneCanvas()
      Filters.camanCanvas.toasty().render()
    $('button#memphis').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.cloneCanvas()
      Filters.camanCanvas.memphis().render()
    $('button#save-button').on 'click', (event) ->
      Filters.storeBase64()

  cloneCanvas: ->
    clone = $('.image-clone').clone()
    revert_id = "revert#{Filters.applyCount}"
    $('.image-clone').attr({ id: revert_id })
    revert_id = "##{revert_id}"
    Filters.camanCanvas = Caman(revert_id)
    $('canvas:last').remove()
    $('#filter-preview').prepend(clone)
    Filters.applyCount += 1

  toggleActiveFilter: (button) ->
    $('button.active-filter').toggleClass("active-filter")
    $(button).toggleClass("active-filter")

  registerFilters: ->
    Caman.Filter.register "xxpro", ->
      # @newLayer ->
      #   @setBlendingMode("multiply")
      #   @opacity(50);
      #   @fillColor("#f5f2f2")

      @curves('rgb', [0, 0], [79, 46], [152, 149], [255, 255])
      @contrast(6)
      @curves('b', [0, 45], [55, 73], [170, 145], [255, 255])

      @contrast(8)
      @exposure(-10)
      @vibrance(20)

      this

    Caman.Filter.register "toasty", ->
      @curves('r', [0, 71], [49, 104], [120, 172], [178, 227])
      @curves('g', [33, 27], [86, 99], [160, 165], [214, 222])
      @curves('b', [0, 0], [105, 100], [157, 148], [204, 195])
      @exposure(-20)

      this

    Caman.Filter.register "memphis", ->
      # @newLayer ->
      #   @setBlendingMode("softLight")
      #   @fillColor('#f6daae')
      #   @opacity(50)

      @curves('g', [0, 0], [98, 112], [174, 204], [238, 235])
      @curves('b', [0, 0], [64, 95], [193, 170], [255, 255])
      @contrast(8)
      @curves('r', [0, 0], [55, 71], [160, 184], [255, 255])
      @curves('g', [0, 0], [53, 74], [178, 182], [255, 255])

      @contrast(8)

      this

}
