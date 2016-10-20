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
