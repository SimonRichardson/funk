```javascript
"HELLO WORLD" == toList("dlrow olleh").map(_.toUpperCase).reduceRight(_.plus_)
```

# Introduction
The Funk library supports functional development in ActionScript3. Some of its key features are:

* Utilities to avoid boilerplate code
  * Currying
  * Lazy evaluation
  * Closure wrapping
  * Continuations (Not to confuse with continuation-passing style)
* Immutable collections
* Option type
* Tuple type
* IoC Container (no reflections, no Metadata and immutable!)

Using Funk will result in a performance loss. But your code will be more conciese and contain less boilerplate. Use this library if you want elegant code in applications that are not performance critical. Funk enforces immutable state and the avoidance of null which will prevent you from common mistakes.

## Examples
### IoC with Funk

```javascript
var NetworkModule = (function(){
	var NetworkModuleImpl = function(){}
	NetworkModuleImpl.prototype = new funk.ioc.AbstractModule()
	NetworkModuleImpl.prototype.constructor = NetworkModuleImpl
	NetworkModuleImpl.prototype.name = "NetworkModule"
	NetworkModuleImpl.prototype.configure = function(){
		bind(String).toInstance("127.0.0.1")
	    bind(Number).toInstance(8080)
	    bind(RequestQueue).to(SomeRequestQueue).asSingleton()
	    bind(RequestDispatcher).toProvider(IRequestDispatcherProvider)
	    bind(RequestDispatcherProvider).to(SomeRequestDispatcherProvider)
	    bind(Headers).asSingleton()
	}
	return NetworkModuleImpl
})()

var SomeRequestDispatcherProvider = (function(){
	var SomeRequestDispatcherProviderImpl = function(){}
	SomeRequestDispatcherProviderImpl.prototype = new funk.ioc.Provider()
	SomeRequestDispatcherProviderImpl.prototype.constructor = SomeRequestDispatcherProviderImpl
	SomeRequestDispatcherProviderImpl.prototype.name = "SomeRequestDispatcherProvider"
	SomeRequestDispatcherProviderImpl.prototype.get = function(){
		return new RequestDispatcher
	}
	return SomeRequestDispatcherProviderImpl
})()

var RequestDispatcher = (function(){
	var RequestDispatcherImpl = function(){}
	RequestDispatcherImpl.prototype = new funk.ioc.Provider()
	RequestDispatcherImpl.prototype.constructor = RequestDispatcherImpl
	RequestDispatcherImpl.prototype.name = "RequestDispatcher"
	RequestDispatcherImpl.prototype._queue = inject(RequestQueue)
	RequestDispatcherImpl.prototype._headers = inject(Headers)
	RequestDispatcherImpl.prototype._host = inject(String)
	RequestDispatcherImpl.prototype._port = inject(Number)
	return RequestDispatcherImpl
})()

var Whatever = (function(){
	var WhateverImpl = function(){}
	WhateverImpl.prototype = {}
	WhateverImpl.prototype.constructor = RequestDispatcherImpl
	WhateverImpl.prototype.name = "Whatever"
	WhateverImpl.prototype._dispatcher = inject(RequestDispatcher)
	return WhateverImpl
})()

var network = Injector.initialize(new NetworkModule)
var whatever = network.getInstance(Whatever)
var thisWorksToo: Whatever = new Whatever()
```

## Continuations

```javascript
var file = ...
var deleteButton = new SimpleButton(...)

deleteButton.onClick(
  fork(
    Dialog.show(this, ["Do you want to delete your file?", Dialog.YES | Dialog.NO])
  ).andContinue(
   function(confirmed) {
      if(confirmed) {
        file.delete()
      }
    }
  )
)
```

## Currying

```javascript
var modulo = function(n, x) { return x % n }
var mod3 = curry(modulo, 3)
console.log(7 % 3, modulo(3, 7), mod3(7))

## Using the option type
var User = (function(){
	var UserImpl = function(){}
	UserImpl.prototype = {}
	UserImpl.prototype.constructor = UserImpl
	UserImpl.prototype.name = "Whatever"
	UserImpl.prototype.getName = function(){
		return ...
	}
	return UserImpl
})()

function getUser(name) {
  if(containsUserWithName(name)) {
    return some(users[name])
  } else {
    return none
  }
}

getUser("kermit").map(_.invoke('getName')).getOrElse(pass.string("Unknown User"))
```

See wiki for more info