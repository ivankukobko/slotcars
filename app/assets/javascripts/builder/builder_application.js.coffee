
#= require helpers/namespace
#= require builder/controllers/builder_controller
#= require builder/views/builder_view
#= require builder/mediators/track_mediator

namespace 'builder'

builder.BuilderApplication = Ember.View.extend

  elementId: 'builder-application'

  didInsertElement: ->
    @paper = Raphael @$()[0], 1024, 768

    @trackMediator = builder.mediators.TrackMediator.create()

    @builderController = builder.controllers.BuilderController.create
      trackMediator: @trackMediator

    @builderView = builder.views.BuilderView.create
      trackMediator: @trackMediator
      builderController: @builderController
      paper: @paper

    @builderView.appendTo @$()