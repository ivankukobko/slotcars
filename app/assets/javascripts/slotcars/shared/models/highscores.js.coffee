Shared.Highscores = Ember.Object.extend

  runs: null
  userId: null
  numberOfEntriesToDisplay: null

  displayedRuns: null

  init: ->
    @_super()

    @numberOfEntriesToDisplay or= 5
    @set 'userId', Shared.User.current.get 'id' if Shared.User.current?

    [startIndex, endIndex] = @_calculateIndices()
    @set 'displayedRuns', (@get 'runs')[startIndex..endIndex]

  getTimeForUserId: (userId) -> return run.time for run in @runs when run.user_id is userId

  _calculateIndices: ->
    runs = @get 'runs'
    userId = @get 'userId'
    numberOfRuns = runs.length
    indexOfLastRun = numberOfRuns - 1
    numberOfEntriesToDisplay = @get 'numberOfEntriesToDisplay'

    if userId? and numberOfRuns >= numberOfEntriesToDisplay
      runOfUser = runs.findProperty 'user_id', userId
      indexOfUserRun = runOfUser.rank - 1

      numberOfEntriesWithoutUser = numberOfEntriesToDisplay - 1
      numberOfEntriesBetterThanUser = Math.ceil numberOfEntriesWithoutUser / 2
      numberOfEntriesWorseThanUser = Math.floor numberOfEntriesWithoutUser / 2

      startIndex = indexOfUserRun - numberOfEntriesBetterThanUser
      endIndex = indexOfUserRun + numberOfEntriesWorseThanUser

      if startIndex < 0
        endIndex += -1 * startIndex
        startIndex = 0
      else if endIndex > indexOfLastRun
        startIndex -= endIndex - indexOfLastRun
        endIndex = indexOfLastRun
    else
      startIndex = 0
      endIndex = numberOfEntriesToDisplay - 1

    [startIndex, endIndex]
