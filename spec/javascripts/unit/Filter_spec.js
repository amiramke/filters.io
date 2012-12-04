describe("Filters", function() {

  describe("#init", function() {
    it("registers filters", function() {
      spyOn(Filters, 'registerFilters');
      Filters.init();

      expect(Filters.registerFilters).toHaveBeenCalled();
    });

    it("starts with an applyCount of 0", function() {
      Filters.init();

      expect(Filters.applyCount).toBe(0);
    });
  });

  describe("#sendPhotoUrl", function() {
    it("makes an ajax call to the correct url", function() {
      spyOn($, "ajax");
      Filters.sendPhotoUrl('http://image.com/img.png');
      expect($.ajax.mostRecentCall.args[0]["url"]).toBe('http://localhost:3000/photos');
    });

    it("executes the correct callbacks on complete", function() {
      spyOn($, 'ajax').andCallFake(function(options) {
        var json = {responseText: 'response'};
        options.complete(json);
      })

      Filters.sendPhotoUrl('http://image.com/img.png');
      expect(Filters.renderHTML()).toHaveBeenCalled();
      expect(Filters.createPreview()).toHaveBeenCalled();
    });
  });

});