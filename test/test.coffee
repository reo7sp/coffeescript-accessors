expect = require('chai').expect
attr = require('../src/index.coffee')

describe 'with monkey-patching', ->
  before ->
    attr.bootstrap()

  describe 'getter', ->
    it 'creates getter', ->
      class T
        @getter 'a'

      t = new T
      expect(t).to.respondTo('getA')
      expect(t).not.to.respondTo('setA')
      t.a = 1
      expect(t.getA()).to.equal(1)

    it 'make getter name camel-cased', ->
      class T
        @getter '__foo_bar'

      t = new T
      expect(t).to.respondTo('getFooBar')
      t.__foo_bar = 1
      expect(t.getFooBar()).to.equal(1)

    it 'can create multiple getters at once', ->
      class T
        @getter 'a', 'b'

      t = new T
      expect(t).to.respondTo('getA')
      expect(t).to.respondTo('getB')
      expect(t).not.to.respondTo('setA')
      expect(t).not.to.respondTo('setB')
      t.a = 1
      t.b = 2
      expect(t.getA()).to.equal(1)
      expect(t.getB()).to.equal(2)

    it 'allows providing custom prefix', ->
      class T
        @getter ['is', 'a'], ['acquire', 'b']

      t = new T
      expect(t).to.respondTo('isA')
      expect(t).to.respondTo('acquireB')
      t.a = true
      t.b = 2
      expect(t.isA()).to.equal(true)
      expect(t.acquireB()).to.equal(2)

  describe 'setter', ->
    it 'creates setter', ->
      class T
        @setter 'a'

      t = new T
      expect(t).not.to.respondTo('getA')
      expect(t).to.respondTo('setA')
      t.setA(1)
      expect(t.a).to.equal(1)

    it 'make setter name camel-cased', ->
      class T
        @setter '__foo_bar'

      t = new T
      expect(t).to.respondTo('setFooBar')
      t.setFooBar(1)
      expect(t.__foo_bar).to.equal(1)

    it 'can create multiple setters at once', ->
      class T
        @setter 'a', 'b'

      t = new T
      expect(t).not.to.respondTo('getA')
      expect(t).not.to.respondTo('getB')
      expect(t).to.respondTo('setA')
      expect(t).to.respondTo('setB')
      t.setA(1)
      t.setB(2)
      expect(t.a).to.equal(1)
      expect(t.b).to.equal(2)

    it 'allows providing custom prefix', ->
      class T
        @setter ['modify', 'a']

      t = new T
      expect(t).to.respondTo('modifyA')
      t.modifyA(1)
      expect(t.a).to.equal(1)

  describe 'accessor', ->
    it 'creates getter and setter', ->
      class T
        @accessor 'a'

      t = new T
      expect(t).to.respondTo('getA')
      expect(t).to.respondTo('setA')
      t.setA(1)
      expect(t.getA()).to.equal(1)


describe 'without monkey-patching', ->
  describe 'getter/reader', ->
    it 'creates getter', ->
      class T
        attr.getter(@, 'a')
        attr.reader(@, 'b')

      t = new T
      expect(t).to.respondTo('getA')
      expect(t).to.respondTo('getB')
      expect(t).not.to.respondTo('setA')
      expect(t).not.to.respondTo('setB')
      t.a = 1
      t.b = 2
      expect(t.getA()).to.equal(1)
      expect(t.getB()).to.equal(2)

  describe 'setter/writer', ->
    it 'creates setter', ->
      class T
        attr.setter(@, 'a')
        attr.writer(@, 'b')

      t = new T
      expect(t).not.to.respondTo('getA')
      expect(t).not.to.respondTo('getB')
      expect(t).to.respondTo('setA')
      expect(t).to.respondTo('setB')
      t.setA(1)
      t.setB(2)
      expect(t.a).to.equal(1)
      expect(t.b).to.equal(2)

  describe 'accessor', ->
    it 'creates getter and setter', ->
      class T
        attr.accessor(@, 'a')

      t = new T
      expect(t).to.respondTo('getA')
      expect(t).to.respondTo('setA')
      t.setA(1)
      expect(t.getA()).to.equal(1)

  describe 'instanceGetter/instanceReader', ->
    it 'creates getter just for this object', ->
      class T

      t = new T
      attr.instanceGetter(t, 'a')
      expect(t).to.respondTo('getA')
      t.a = 1
      expect(t.getA()).to.equal(1)

      t1 = new T
      expect(t1).not.to.respondTo('getA')

  describe 'instanceSetter/instanceWriter', ->
    it 'creates setter just for this object', ->
      class T

      t = new T
      attr.instanceSetter(t, 'a')
      expect(t).to.respondTo('setA')
      t.setA(1)
      expect(t.a).to.equal(1)

      t1 = new T
      expect(t1).not.to.respondTo('setA')

  describe 'instanceAccessor', ->
    it 'creates getter and setter just for this object', ->
      class T

      t = new T
      attr.instanceAccessor(t, 'a')
      expect(t).to.respondTo('getA')
      expect(t).to.respondTo('setA')
      t.setA(1)
      expect(t.getA()).to.equal(1)

      t1 = new T
      expect(t1).not.to.respondTo('getA')
      expect(t1).not.to.respondTo('setA')
