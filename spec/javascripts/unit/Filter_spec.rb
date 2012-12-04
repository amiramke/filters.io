describe("Filters", function(){

  describe("#init", function() {
    before("all", function() {
      spyOn(Filters, 'registerFilters');
    });

    it("registers filters", function() {
      Filters.init()

      expect(Filters.registerFilters).toHaveBeenCalled();
    })
  });

});