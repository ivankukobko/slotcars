describe 'test drive', ->

  beforeEach ->
    @carMock = mockEmberClass Shared.Car
    @trackMock = mockEmberClass Shared.Track
    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager

    @TestDriveControllerMock = mockEmberClass Build.TestDriveController, set: sinon.spy()
    @TrackViewMock = mockEmberClass Shared.TrackView, gameController: {}
    @CarViewMock = mockEmberClass Play.CarView
    @TestDriveViewMock = mockEmberClass Build.TestDriveView, set: sinon.spy()

    @buildScreenViewMock =
      set: sinon.spy()

    @testDrive = Build.TestDrive.create
      stateManager: @buildScreenStateManagerMock
      buildScreenView: @buildScreenViewMock
      track: @trackMock

  afterEach ->
    @carMock.restore()
    @trackMock.restore()
    @buildScreenStateManagerMock.restore()
    @TestDriveControllerMock.restore()
    @TrackViewMock.restore()
    @CarViewMock.restore()
    @TestDriveViewMock.restore()

  it 'should extend Ember.Object', ->
    (expect Build.TestDrive).toExtend Ember.Object

  it 'should create a car', ->
    (expect @carMock.create).toHaveBeenCalled()

  it 'should create a game controller and provide necessary dependencies', ->
    (expect @TestDriveControllerMock.create).toHaveBeenCalledWithAnObjectLike
      stateManager: @buildScreenStateManagerMock
      track: @trackMock
      car: @carMock

  it 'should enable car controls on game controller', ->
    (expect @TestDriveControllerMock.set).toHaveBeenCalledWith 'carControlsEnabled', true

  it 'should create a car view and provide a car', ->
    (expect @CarViewMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock

  it 'should create a track view and provide dependencies', ->
    (expect @TrackViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @TestDriveControllerMock, track: @trackMock

  it 'should create a test drive view and provide the game controller', ->
    (expect @TestDriveViewMock.create).toHaveBeenCalledWithAnObjectLike testDriveController: @TestDriveControllerMock

  it 'should append car view to test drive view', ->
    (expect @TestDriveViewMock.set).toHaveBeenCalledWith 'carView', @CarViewMock

  it 'should append track view to play screen view', ->
    (expect @TestDriveViewMock.set).toHaveBeenCalledWith 'trackView', @TrackViewMock

  it 'should append car view to test drive view', ->
    (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @TestDriveViewMock

  describe 'starting the game', ->

    beforeEach ->
      @TestDriveControllerMock.start = sinon.spy()

    it 'should start the game controller', ->
      @testDrive.start()

      (expect @TestDriveControllerMock.start).toHaveBeenCalled()

  describe 'destroying the game', ->

    beforeEach ->
      @TestDriveControllerMock.destroy = sinon.spy()
      @carMock.destroy = sinon.spy()
      @CarViewMock.destroy = sinon.spy()
      @TrackViewMock.destroy = sinon.spy()
      @TestDriveViewMock.destroy = sinon.spy()

      @testDrive.destroy()

    it 'should unset the content view on build screen view', ->
      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', null

    it 'should tell the car view to destroy itself', ->
      (expect @CarViewMock.destroy).toHaveBeenCalled()

    it 'should tell the track view to destroy itself', ->
      (expect @TrackViewMock.destroy).toHaveBeenCalled()

    it 'should tell the test drive view to destroy itself', ->
      (expect @TestDriveViewMock.destroy).toHaveBeenCalled()

    it 'should tell the car to destroy itself', ->
      (expect @carMock.destroy).toHaveBeenCalled()

    it 'should call destroy on the game controller', ->
      (expect @TestDriveControllerMock.destroy).toHaveBeenCalled()