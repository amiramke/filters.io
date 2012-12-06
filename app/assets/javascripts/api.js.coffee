class window.API
  constructor: (host) ->
    @host = host
    @sendPhotoUrl = (url) ->
      $.ajax {
        type: 'POST'
        url: "#{host}/photos"
        dataType: 'json'
        data: { photo: { url: url } }
      }
    @newImage = ->
      $.ajax {
        type: 'GET'
        url: "#{host}/photos"
        dataType: 'json'
        data: {newImage: 'true'}
      }
