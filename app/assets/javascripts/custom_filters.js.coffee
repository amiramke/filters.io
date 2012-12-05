$(document).ready ->
   CustomFilters.registerFilters()

CustomFilters = {

  registerFilters: ->
    Caman.Filter.register "xxpro", ->
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
      @curves('g', [0, 0], [98, 112], [174, 204], [238, 235])
      @curves('b', [0, 0], [64, 95], [193, 170], [255, 255])
      @contrast(8)
      @curves('r', [0, 0], [55, 71], [160, 184], [255, 255])
      @curves('g', [0, 0], [53, 74], [178, 182], [255, 255])

      @contrast(8)

      this

    Caman.Filter.register "colt", ->
      @brightness(8)
      @contrast(6)
      @saturation(-9)
      @curves('r', [11, 14], [98, 98], [174, 174], [255, 241])
      @curves('g', [0, 4], [98, 98], [174, 174], [250, 247])
      @curves('b', [0, 33], [44, 53], [114, 120], [252, 231])
      @saturation(-15)
      @brightness(-5)
      @contrast(5)
      @brightness(-5)
      @contrast(9)
      @curves('r', [0, 39], [98, 112], [174, 204], [255, 255])

      @brightness(-4)
      @contrast(3)

      this

    Caman.Filter.register "domo", ->
      @brightness(8)
      @contrast(15)
      @curves('r', [0, 0], [86, 50], [178, 180], [255, 255])
      @curves('g', [0, 0], [86, 50], [178, 180], [255, 255])
      @curves('b', [0, 0], [86, 50], [178, 180], [255, 255])
      @brightness(-5)

      this

    Caman.Filter.register "arkham", ->
      @saturation(-100)
      @contrast(5)
      @vibrance(-10)
      @brightness(-7)

      this

}
