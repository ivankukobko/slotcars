
#= require slotcars/play/views/car_view
#= require vendor/raphael

describe 'slotcars.play.views.CarView (unit)', ->

  CarView = slotcars.play.views.CarView

  it 'should extend Ember.View', ->
    (expect CarView).toExtend Ember.View