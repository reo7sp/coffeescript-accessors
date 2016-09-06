_ = {}
_.upperFirst = require 'lodash.upperfirst'
_.camelCase = require 'lodash.camelcase'
_.isString = require 'lodash.isstring'
_.isArray = require 'lodash.isarray'

module.exports =
  bootstrap: ->
    accessors = @
    Function::getter = (fields...) -> accessors.getter(@prototype, fields...).bind(accessors)
    Function::setter = (fields...) -> accessors.setter(@prototype, fields...).bind(accessors)
    Function::accessor = (fields...) -> accessors.accessor(@prototype, fields...).bind(accessors)

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

  reader: @getter

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

  writer: @setter

  accessor: (obj, fields...) ->
    @reader(obj, fields...)
    @writer(obj, fields...)

  _createGetter: (obj, field, prefix = 'get') ->
    obj[@_getAccessorMethodName(field, prefix)] = -> obj[field]

  _createSetter: (obj, field, prefix = 'set') ->
    obj[@_getAccessorMethodName(field, prefix)] = (newValue) -> obj[field] = newValue

  _getAccessorMethodName: (field, prefix) ->
    "#{prefix}#{_.upperFirst(_.camelCase(field))}"
