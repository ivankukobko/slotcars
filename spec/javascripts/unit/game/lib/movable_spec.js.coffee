
#= require game/lib/movable

describe 'game.lib.Movable', ->

  Movable = game.lib.Movable

  describe 'move to a position', ->

    beforeEach ->
      @movable = Ember.Object.extend(Movable).create() # because a mixin has no 'create' method

    it 'should update its position', ->
      position = { x: 3, y: 2 }
      @movable.moveTo position

      (expect @movable.position).toEqual position

    it 'should update its rotation', ->
      @movable.position = { x: 0, y: 0 }
      @movable.moveTo x: 1, y: 0

      (expect @movable.rotation).toBeApproximatelyEqual 90
