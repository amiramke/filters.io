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
        Filters.sendPhotoUrl(FPFile.url)

  sendPhotoUrl: (url) ->
    $.ajax({
      type: 'POST'
      url: 'http://localhost:3000/photos'
      dataType: 'json'
      data: { photo: {photo_url: url} }
      complete: (json, status) ->
        Filters.renderHTML(json.responseText)
        Filters.createPreview()
        Filters.filterBindings()
      })

  renderHTML: (html_string) ->
    $('div#container').html(html_string)

  toggleUploadButton: ->
    $('button#upload').toggle()

  createPreview: ->
    $('.image').hide()
    Filters.camanCanvas = Caman('.image')

  storeBase64: ->
    raw_data = Filters.camanCanvas.toBase64()
    raw_data = raw_data.replace("data:image/png;base64,", "")
    filepicker.store(raw_data, { filename: 'filtered_image.jpg', base64decode: true, mimetype: 'image/jpg'}, (FPFile) ->
      filepicker.export(FPFile)
      )

  filterBindings: ->
    $('button#xxpro').on 'click', (event) ->
      debugger
      # Filters.camanCanvas.revert()
      # Filters.camanCanvas.xxpro().render()
    $('button#toasty').on 'click', (event) ->
      Filters.camanCanvas.revert()
      Filters.camanCanvas.toasty().render()
    $('button#memphis').on 'click', (event) ->
      Filters.camanCanvas.revert()
      Filters.camanCanvas.memphis().render()
    $('button#apply').on 'click', (event) ->
      Filters.storeBase64()

  registerFilters: ->
    Caman.Filter.register "xxpro", ->
      @newLayer ->
        @setBlendingMode("multiply")
        @opacity(50);
        @fillColor("#f5f2f2")

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
      @newLayer ->
        @setBlendingMode("multiply")
        @opacity(50)
        @fillColor('#f6daae')

      @curves('g', [0, 0], [98, 112], [174, 204], [238, 235])
      @curves('b', [0, 0], [64, 95], [193, 170], [255, 255])
      @contrast(8)
      @curves('r', [0, 0], [55, 71], [160, 184], [255, 255])
      @curves('g', [0, 0], [53, 74], [178, 182], [255, 255])

      @contrast

      this


}
