describe("Filters", function() {
  describe("#init", function() {
  });

  describe("#sendPhotoUrl", function() {
    beforeEach(function() {
      var api = { sendPhotoUrl: function()  { return {  complete: function(callback) { callback("woo"); } } } }
      spyOn(Filters, 'renderHTML');
      spyOn(Filters, 'createPreview');
      Filters.sendPhotoUrl('http://image.com/img.png', api);
    });

    describe("When it completes successully", function() {
      it("Renders the html with the api response", function() {
        expect(Filters.renderPartial).toHaveBeenCalledWith("woo");
      });

      it("creates the preview", function() {
        expect(Filters.createPreview).toHaveBeenCalled();
      });
    });
  });
});
