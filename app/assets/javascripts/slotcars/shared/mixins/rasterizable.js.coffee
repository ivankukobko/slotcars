
Shared.Rasterizable = Ember.Mixin.create

  rasterized: DS.attr 'string'

  isRasterizing: false
  rasterizedPath: null

  rasterize: (finishCallback) ->
    @set 'isRasterizing', true
    @set 'rasterizedPath', null
    Ember.run.later (=>
      (@get '_raphaelPath').rasterize
        minimumLengthPerPoint: 3
        lengthLimitForAngleFactor: 20
        minimumAngle: 0.3
        lengthPerRasterizingPhase: 400
        onProgress: ($.proxy @_onRasterizationProgress, this)
        onFinished: =>
          @set 'isRasterizing', false
          finishCallback() if finishCallback?
    ), 50

  _onRasterizationProgress: (rasterizedLength) ->
    @set 'rasterizedPath', Raphael.getSubpath (@get 'raphaelPath'), 0, rasterizedLength