
#= require helpers/namespace
#= require helpers/graphic/exhaust
#= require game/templates/car_template

namespace 'game.views'

game.views.CarView = Ember.View.extend

  templateName: 'game_templates_car_template'
  tagName: ''

  paper: null
  width: 27
  height: 39
  car: null
  exhaust: null
  puffInterval: 2
  puffStep: 0
  offset: null

  didInsertElement: ->
    #@exhaust = helpers.graphic.Exhaust.create(@paper)

    (jQuery @$()).css 'top', @offset.top
    (jQuery @$()).css 'left', @offset.left

  onPositionChange: (-> @update()).observes 'car.position'

  update: ->
    position = @car.position
    rotation = @car.rotation
    drawPosition =
      x: position.x - @width / 2
      y: position.y - @height / 4

    (jQuery '#car').css '-webkit-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
    (jQuery '#car').css '-moz-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
    
    #@puffStep = ++@puffStep % @puffInterval
    #@exhaust.puff(position.x + @width - 6, position.y + @height) unless @puffStep > 0

    #@exhaust.update()
