# coffeescript-accessors
Fancy getter and setter generation in CoffeeScript

## Usage with monkey patching
```coffeescript
require('coffeescript-accessors').bootstrap()

class A
  num: 1
  @getter 'num'
  @setter 'num'

  someStr: 'test'
  @accessor 'someStr' # creates both getter and setter

  a: 1
  b: 2
  @getter 'a', 'b' # create getters for multiple fields at once

a = new A()
a.setSomeStr('it works')
a.getA()
```

## Usage without monkey patching
```coffeescript
attr = require('coffeescript-accessors')

class A
  num: 1
  someStr: 'test'

  attr.getter @, 'num'
  attr.setter @, 'num'
  attr.accessor @, 'someStr'
  attr.reader @, 'a', 'b' # remember ruby?

a = new A()
a.setSomeStr('it works')
a.getA()
```
