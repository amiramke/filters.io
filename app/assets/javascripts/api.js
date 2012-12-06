var API = function(host) {
  this.prototype.sendPhotoUrl = function(url) {
    return $.ajax({ type: 'POST'
    , url: host + '/photos'
    , dataType: 'json'
    , data: { photo: {url: url} } 
    });
  }
}
