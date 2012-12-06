describe("Filters", function() {
  describe("#init", function() {
    it("starts with an applyCount of 0", function() {
      filepicker = 'STRING'
      Filters.init(filepicker);
      expect(Filters.applyCount).toBe(0);
    });
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
        expect(Filters.renderHTML).toHaveBeenCalledWith("woo");
      });

      it("creates the preview", function() {
        expect(Filters.createPreview).toHaveBeenCalled();
      });
    });
  });
});
