_ = {}
_.upperFirst = require 'lodash.upperfirst'
_.camelCase = require 'lodash.camelcase'
_.isString = require 'lodash.isstring'
_.isArray = require 'lodash.isarray'

module.exports =
  bootstrap: ->
    accessors = @
    Function::getter = (fields...) -> accessors.getter.call(accessors, @prototype, fields...)
    Function::setter = (fields...) -> accessors.setter.call(accessors, @prototype, fields...)
    Function::accessor = (fields...) -> accessors.accessor.call(accessors, @prototype, fields...)

  getter: (obj, fields...) ->
    for field in fields
      if _.isString(field)
        @_createGetter(obj, field)
      else
        if _.isArray(field)
          [prefix, name] = field
        else
          {prefix, type, name} = field

        if not prefix?
          prefix =
            switch type
              when 'bool' then 'is'
              else 'get'

        @_createGetter(obj, field, prefix)
    return

  reader: (args...) ->
    @getter(args...)

  setter: (obj, fields...) ->
    for field in fields
      if _.isString(field)
        @_createSetter(obj, field)
      else
        if _.isArray(field)
          [prefix, name] = field
        else
          {name} = field

        @_createSetter(obj, name)
    return

  writer: (args...) ->
    @setter(args...)

  accessor: (obj, fields...) ->
    @reader(obj, fields...)
    @writer(obj, fields...)

  _createGetter: (obj, field, prefix = 'get') ->
    obj[@_getAccessorMethodName(field, prefix)] = -> @[field]

  _createSetter: (obj, field, prefix = 'set') ->
    obj[@_getAccessorMethodName(field, prefix)] = (newValue) -> @[field] = newValue

  _getAccessorMethodName: (field, prefix) ->
    "#{prefix}#{_.upperFirst(_.camelCase(field))}"
