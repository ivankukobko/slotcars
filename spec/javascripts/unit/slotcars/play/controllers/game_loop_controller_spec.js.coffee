
#= require slotcars/play/controllers/game_loop_controller

describe 'slotcars.play.controllers.GameLoopController (unit)', ->

  GameLoopController = slotcars.play.controllers.GameLoopController

  beforeEach ->
    @requestFrameBackup = window.requestFrame
    @requestFrameStub = window.requestFrame = sinon.spy()

    @gameLoop = GameLoopController.create()

  afterEach ->
    window.requestFrame = @requestFrameBackup

  describe '#start', ->

    it 'should call renderCallback when first started', ->
      renderCallbackSpy = sinon.spy()
      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalled()

    it 'should use requestFrame for running the loop', ->
      @gameLoop.start ->

      (expect @requestFrameStub).toHaveBeenCalled()

    it 'should call renderCallback for each requested frame', ->
      renderCallbackSpy = sinon.spy()
      maxTestFrameCount = 3
      frameCount = 0

      requestFrameStub = window.requestFrame = (loopCallback) ->
        frameCount++

        if frameCount < maxTestFrameCount
          loopCallback()

      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalledThrice()