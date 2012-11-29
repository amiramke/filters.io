$(document).ready ->
  Filters.init()
  filepicker.setKey('A8bPQLUeRg6RglPocYMdGz')

Filters = {

  init: ->
    Filters.registerFilters()

    # Event bindings
    $('button#upload').on 'click', (event) ->
      filepicker.pick {container: 'modal'}, (FPFile) ->
        Filters.toggleUploadButton()
        Filters.renderPhoto(FPFile.url)
        Filters.createPreview()
        Filters.sendPhotoUrl(FPFile.url)

  sendPhotoUrl: (url) ->
    $.ajax({
      type: 'POST'
      url: 'http://localhost:3000/photos'
      dataType: 'json'
      data: { photo: {photo_url: url} }
      })


  renderPhoto: (photo_url) ->
    html_string = "<p><img class='image' data-camanheight='500' src='#{photo_url}'>"
    $('div#container').html(html_string)

  renderFilterButtons: ->
    html_string = "<p><tr><td><button id='xxpro'>xxpro</button></td><td><button id='toasty'>toasty</button></td><td><button id='memphis'>memphis</button></td><td><button id='apply'>Save</button></td></tr>"
    $('div#container').append(html_string)

  renderHTML: (html_string) ->
    $('div#container').append(html_string)

  toggleUploadButton: ->
    $('button#upload').toggle()

  createPreview: ->
    $('.image').hide()
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
    $('button#xxpro').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.camanCanvas.revert()
      Filters.camanCanvas.xxpro().render()
    $('button#toasty').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.camanCanvas.revert()
      Filters.camanCanvas.toasty().render()
    $('button#memphis').on 'click', (event) ->
      Filters.toggleActiveFilter(@)
      Filters.camanCanvas.revert()
      Filters.camanCanvas.memphis().render()
    $('button#apply').on 'click', (event) ->
      Filters.storeBase64()

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
