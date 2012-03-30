
#= require slotcars/slotcars_application
#= require slotcars/route_manager
#= require slotcars/factories/screen_factory

describe 'slotcars application screen management', ->

  SlotcarsApplication = slotcars.SlotcarsApplication
  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @RouteManagerCreateStub = mockEmberClass slotcars.RouteManager

  afterEach ->
    @RouteManagerCreateStub.restore()

  describe 'interaction with screens', ->

    beforeEach ->
      @screenMock = append: sinon.spy()
      @screenFactoryMock = getInstanceOf: sinon.stub().returns @screenMock

      (sinon.stub ScreenFactory, 'getInstance').returns @screenFactoryMock

      @slotcarsApplication = SlotcarsApplication.create()

    afterEach ->
      @slotcarsApplication.destroy()
      ScreenFactory.getInstance.restore()


    it 'should get the correct screen from factory and tell it to append', ->
      createParameters = {}
      @slotcarsApplication.showScreen 'ExampleScreen', createParameters

      (expect @screenFactoryMock.getInstanceOf).toHaveBeenCalledWith 'ExampleScreen', createParameters
      (expect @screenMock.append).toHaveBeenCalled()

    it 'should call the destroy method on the old screen when the screens get switched', ->
      @firstScreenMock = 
        append: sinon.spy(), 
        destroy: sinon.spy()
      
      (@screenFactoryMock.getInstanceOf.withArgs 'FirstScreen').returns @firstScreenMock

      @slotcarsApplication.showScreen 'FirstScreen'
      @slotcarsApplication.showScreen 'SecondScreen'

      (expect @firstScreenMock.destroy).toHaveBeenCalled()


  describe 'integration with the route manager', ->

    beforeEach ->
      @slotcarsApplication = SlotcarsApplication.create()

    afterEach ->
      @slotcarsApplication.destroy()

    it 'should create route manager and register itself as delegate', ->
      (expect @RouteManagerCreateStub.create).toHaveBeenCalledWithAnObjectLike
        delegate: @slotcarsApplication

    it 'should make the route manager a singleton that can be directly accessed', ->
      (expect slotcars.routeManager).toBe @RouteManagerCreateStub
