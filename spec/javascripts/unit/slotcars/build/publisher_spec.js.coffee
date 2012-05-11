describe 'Build.Publisher', ->

  beforeEach ->
    @trackMock = Ember.Object.create
      save: sinon.spy()

    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager, send: sinon.spy()
    @buildScreenViewMock = mockEmberClass Build.BuildScreenView, set: sinon.spy()
    @PublicationViewMock = mockEmberClass Build.PublicationView
    @AuthorizerViewMock = mockEmberClass Build.AuthorizerView

  afterEach ->
    @buildScreenStateManagerMock.restore()
    @buildScreenViewMock.restore()
    @PublicationViewMock.restore()
    @AuthorizerViewMock.restore()

  it 'should extend Ember.Object', ->
    (expect Build.Publisher).toExtend Ember.Object

  describe 'no current user present', ->
    
    beforeEach ->
      @publisher = Build.Publisher.create
        stateManager: @buildScreenStateManagerMock
        buildScreenView: @buildScreenViewMock
        track: @trackMock

    it 'should create a authorizer view', ->
      (expect @AuthorizerViewMock.create).toHaveBeenCalledWithAnObjectLike
        stateManager: @buildScreenStateManagerMock
        delegate: @publisher

    it 'should append the authorizer view to the build screen view', ->
      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @AuthorizerViewMock

  describe 'current user present', ->

    beforeEach ->
      Shared.User.current = {}

      @publisher = Build.Publisher.create
        stateManager: @buildScreenStateManagerMock
        buildScreenView: @buildScreenViewMock
        track: @trackMock

    it 'should create a publication view', ->
      (expect @PublicationViewMock.create).toHaveBeenCalledWithAnObjectLike
        stateManager: @buildScreenStateManagerMock
        track: @trackMock

    it 'should append the publication view to the build screen view', ->
      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @PublicationViewMock

    describe 'publishing', ->

      beforeEach ->
        Shared.routeManager = mockEmberClass Shared.RouteManager, set: sinon.spy()

      afterEach ->
        Shared.routeManager.restore()

      it 'should save the track', ->
        @publisher.publish()

        (expect @trackMock.save).toHaveBeenCalled()

      it 'should provide a callback to switch to game mode after track was saved', ->
        @trackId = 30
        @trackMock.set 'id', @trackId

        @publisher.publish()

        publicationCallback = @trackMock.save.args[0][0]
        publicationCallback() # gets normally called by track.save

        (expect Shared.routeManager.set).toHaveBeenCalledWith 'location', "play/#{@trackId}"
