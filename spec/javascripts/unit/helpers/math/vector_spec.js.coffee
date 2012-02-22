
#= require helpers/math/vector

describe 'helpers.math.Vector (unit)', ->

  Vector = helpers.math.Vector

  describe '#constructor', ->

    it 'should take object literal and set x and y', ->
      vector = new Vector x: 0, y: 1

      (expect vector.x).toBe 0
      (expect vector.y).toBe 1

  describe '#length', ->

    it 'should return length of vector', ->
      randomValue = Math.random(1) * 10
      vector = new Vector x: randomValue, y: 0

      (expect vector.length()).toBe randomValue

  describe '#dot', ->

    it 'should return the dot product of vectors', ->
      vector1 = new Vector x: 0, y: 1
      vector2 = new Vector x: 1, y: 0

      (expect vector1.dot vector2).toBe 0

  describe '#angleFrom', ->

    it 'should return the angle between vectors in radian', ->
      vector1 = new Vector x: 1, y: 0
      vector2 = new Vector x: 1, y: 1

      (expect (vector1.angleFrom vector2).toFixed 5).toBe (45 * Math.PI / 180).toFixed 5

    it 'should return angle for orthogonal vectorsr', ->
      vector1 = new Vector x: 0, y: 1
      vector2 = new Vector x: 1, y: 0

      (expect (vector1.angleFrom vector2).toFixed 5).toBe (90 * Math.PI / 180).toFixed 5


