_ = {}
_.upperFirst = require 'lodash.upperfirst'
_.camelCase = require 'lodash.camelcase'
_.isString = require 'lodash.isstring'
_.isArray = require 'lodash.isarray'

module.exports =
  bootstrap: ->
    accessors = @
    Function::getter = -> accessors.getter.call(accessors, @, arguments...)
    Function::setter = -> accessors.setter.call(accessors, @, arguments...)
    Function::accessor = -> accessors.accessor.call(accessors, @, arguments...)

  getter: (obj, fields...) ->
    @instanceGetter(obj.prototype, fields...)

  instanceGetter: (obj, fields...) ->
    for field in fields
      if _.isString(field)
        @_createGetter(obj, field)
      else
        if _.isArray(field)
          [prefix, name] = field
        else
          {prefix, type, name} = field

        prefix ?=
          switch type
            when 'bool' then 'is'
            else 'get'

        @_createGetter(obj, name, prefix)
    return

  reader: ->
    @getter(arguments...)

  instanceReader: ->
    @instanceGetter(arguments...)

  setter: (obj, fields...) ->
    @instanceSetter(obj.prototype, fields...)

  instanceSetter: (obj, fields...) ->
    for field in fields
      if _.isString(field)
        @_createSetter(obj, field)
      else
        if _.isArray(field)
          [prefix, name] = field
        else
          {name} = field

        prefix ?= 'set'

        @_createSetter(obj, name, prefix)
    return

  writer: ->
    @setter(arguments...)

  instanceWriter: ->
    @instanceSetter(arguments...)

  accessor: (obj, fields...) ->
    @reader(obj, fields...)
    @writer(obj, fields...)

  instanceAccessor: (obj, fields...) ->
    @instanceReader(obj, fields...)
    @instanceWriter(obj, fields...)

  _createGetter: (obj, field, prefix = 'get') ->
    obj[@_getAccessorMethodName(field, prefix)] = -> @[field]

  _createSetter: (obj, field, prefix = 'set') ->
    obj[@_getAccessorMethodName(field, prefix)] = (newValue) -> @[field] = newValue

  _getAccessorMethodName: (field, prefix) ->
    "#{prefix}#{_.upperFirst(_.camelCase(field))}"
