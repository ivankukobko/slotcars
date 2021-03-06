describe 'Build.DrawView', ->

  it 'should extend TrackView', ->
    (expect Build.DrawView).toExtend Shared.TrackView

  beforeEach ->
    @raphaelBackup = window.Raphael

    @raphaelElementAttrSpy = sinon.spy()
    @raphaelElementStub = attr: @raphaelElementAttrSpy, transform: ->

    @paperStub =
      path: sinon.stub().returns @raphaelElementStub
      rect: sinon.stub().returns @raphaelElementStub
      clear: sinon.spy()

    @raphaelStub = window.Raphael = sinon.stub().returns @paperStub

  afterEach ->
    window.Raphael = @raphaelBackup


  describe 'raphaelPath bindings on track', ->

    it 'should not throw exceptions when track is not yet available', ->
      Build.DrawView.create()

      (expect -> Ember.run.end()).not.toThrow()

  describe 'inserting in DOM', ->

    beforeEach ->
      @originalTestPath = 'M0,0L3,4Z'
      @track = mockEmberClass Shared.Track,
        get: sinon.stub().withArgs('raphaelPath').returns @originalTestPath
      @drawController = Build.DrawController.create
        track: @track

      @drawView = Build.DrawView.create drawController: @drawController, track: @track
      Ember.run => @drawView.appendTo jQuery '<div>'

    afterEach -> @track.restore()

    it 'should create raphael paper', ->
      (expect @raphaelStub).toHaveBeenCalledWith @drawView.$()[0], (SCREEN_WIDTH + 2 * @drawView.paperOffset), (SCREEN_HEIGHT + 2 * @drawView.paperOffset)

    it 'should draw the track', ->
      (expect @paperStub.path).toHaveBeenCalledWith @originalTestPath

  describe 'updating track', ->

    beforeEach ->
      @originalTestPath = 'M0,0L3,4Z'
      @track = mockEmberClass Shared.Track,
        get: sinon.stub().withArgs('raphaelPath').returns @originalTestPath
      @drawController = Build.DrawController.create
        track: @track

      @drawView = Build.DrawView.create drawController: @drawController, track: @track
      Ember.run => @drawView.appendTo jQuery '<div>'

    afterEach -> @track.restore()

    it 'should tell raphael to build an open track while in drawing mode', ->
      modifiedPathWithoutZ = 'M0,0L3,4'

      @drawView.updateTrack @originalTestPath

      # 'updateTrack' calls '_super' with the modified path string - no idea how to test that '_super' was called
      (expect @raphaelElementAttrSpy).toHaveBeenCalledWith 'path', modifiedPathWithoutZ


  describe 'event handling in draw view when appended to DOM', ->

    beforeEach ->
      @track = Shared.Track.createRecord()
      @drawControllerMock = mockEmberClass Build.DrawController
      @drawView = Build.DrawView.create drawController: @drawControllerMock, track: @track

      # append it into DOM to test real jQuery events
      Ember.run => @drawView.appendTo jQuery '<div>'

    afterEach -> @drawControllerMock.restore()

    describe 'mouse move events', ->

      beforeEach ->
        @drawControllerMock.onTouchMouseMove = sinon.spy()

      it 'should not bind mouse move before mouse down happened', ->
        (jQuery @drawView.$()).trigger 'touchMouseMove'

        (expect @drawControllerMock.onTouchMouseMove).not.toHaveBeenCalled()


      it 'should bind mouse move on mouse down', ->
        @drawView.$().trigger 'touchMouseDown'
        @drawView.$().trigger 'touchMouseMove'

        (expect @drawControllerMock.onTouchMouseMove).toHaveBeenCalled()

      it 'should notifiy draw controller of move events', ->
        @drawView.$().trigger 'touchMouseDown'

        # manually create touch mouse move event
        testPosition = x: 3, y: 4
        touchMouseMoveEvent = jQuery.Event 'touchMouseMove', pageX: testPosition.x, pageY: testPosition.y

        @drawView.$().trigger touchMouseMoveEvent

        (expect @drawControllerMock.onTouchMouseMove).toHaveBeenCalledWithAnObjectLike testPosition


    describe 'mouse up events', ->

      beforeEach ->
        @drawControllerMock.onTouchMouseUp = sinon.spy()

      it 'should setup mouse up listeners and tell controller about events', ->
        (jQuery @drawView.$()).trigger 'touchMouseUp'

        (expect @drawControllerMock.onTouchMouseUp).toHaveBeenCalled()

      it 'should unbind the mouse up event when removed', ->
        @drawView.willDestroyElement()
        (jQuery @drawView.$()).trigger 'touchMouseUp'

        (expect @drawControllerMock.onTouchMouseUp).not.toHaveBeenCalled()

      it 'should unbind the mouse move event', ->
        @drawControllerMock.onTouchMouseMove = sinon.spy()

        (jQuery @drawView.$()).trigger 'touchMouseDown'
        (jQuery @drawView.$()).trigger 'touchMouseUp'

        (jQuery @drawView.$()).trigger 'touchMouseMove'

        (expect @drawControllerMock.onTouchMouseMove).not.toHaveBeenCalled()
