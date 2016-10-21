expect = require('chai').expect
lib = require('../src/index.coffee')

describe 'with monkey-patching', ->
  before ->
    lib.bootstrap()

  it 'getter', ->
    class T
      @getter 'a'

    t = new T
    expect(t).to.respondTo('getA')
    expect(t).not.to.respondTo('setA')
    t.a = 1
    expect(t.getA()).to.equal(1)

  it 'setter', ->
    class T
      @setter 'a'

    t = new T
    expect(t).not.to.respondTo('getA')
    expect(t).to.respondTo('setA')
    t.setA(1)
    expect(t.a).to.equal(1)

  it 'accessor', ->
    class T
      @accessor 'a'

    t = new T
    expect(t).to.respondTo('getA')
    expect(t).to.respondTo('setA')
    t.setA(1)
    expect(t.getA()).to.equal(1)


describe 'without monkey-patching', ->
  it 'getter', ->
    class T
      constructor: ->
        lib.getter(@, 'a')
        lib.reader(@, 'b')

    t = new T
    expect(t).to.respondTo('getA')
    expect(t).to.respondTo('getB')
    expect(t).not.to.respondTo('setA')
    expect(t).not.to.respondTo('setB')
    t.a = 1
    expect(t.getA()).to.equal(1)

  it 'setter', ->
    class T
      constructor: ->
        lib.setter(@, 'a')
        lib.writer(@, 'b')

    t = new T
    expect(t).not.to.respondTo('getA')
    expect(t).not.to.respondTo('getB')
    expect(t).to.respondTo('setA')
    expect(t).to.respondTo('setB')
    t.setA(1)
    expect(t.a).to.equal(1)

  it 'accessor', ->
    class T
      constructor: ->
        lib.accessor(@, 'a')

    t = new T
    expect(t).to.respondTo('getA')
    expect(t).to.respondTo('setA')
    t.setA(1)
    expect(t.getA()).to.equal(1)
