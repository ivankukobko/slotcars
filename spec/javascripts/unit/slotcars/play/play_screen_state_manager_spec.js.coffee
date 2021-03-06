describe 'play screen state manager', ->

  beforeEach ->
    @delegateMock =
      load: sinon.spy()
      initialize: sinon.spy()
      play: sinon.spy()

  it 'should extend Ember.StateManager', ->
    (expect Play.PlayScreenStateManager).toExtend Ember.StateManager

  it 'should go to Loading state by default', ->
    playScreenStateManager = Play.PlayScreenStateManager.create
      delegate: @delegateMock

    (expect playScreenStateManager.currentState.name).toEqual 'Loading'

  describe 'loading state', ->

    it 'should call load on its delegate', ->
      playScreenStateManager = Play.PlayScreenStateManager.create
        delegate: @delegateMock

      playScreenStateManager.send 'load'

      (expect @delegateMock.load).toHaveBeenCalled()

  describe 'initializing state', ->

    beforeEach ->
      @playScreenStateManager = Play.PlayScreenStateManager.create
        delegate: @delegateMock

    it 'should be switched to when receiving loaded event', ->
      @playScreenStateManager.send 'loaded'

      (expect @playScreenStateManager.currentState.name).toEqual 'Initializing'

    it 'should call initialize on its delegate', ->
      @playScreenStateManager.send 'loaded'

      (expect @delegateMock.initialize).toHaveBeenCalled()

  describe 'playing state', ->

    beforeEach ->
      @playScreenStateManager = Play.PlayScreenStateManager.create
        delegate: @delegateMock

      @playScreenStateManager.send 'loaded'

    it 'should be switched to when receiving initialized event', ->
      @playScreenStateManager.send 'initialized'

      (expect @playScreenStateManager.currentState.name).toEqual 'Playing'

    it 'should call play on its delegate', ->
      @playScreenStateManager.send 'initialized'

      (expect @delegateMock.play).toHaveBeenCalled()
