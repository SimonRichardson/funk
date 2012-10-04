```haxe
"HELLO WORLD" == "dlrow olleh".toList().map(_.toUpperCase).reduceRight(_.plus_).get()
```

# Introduction
The Funk library supports functional development in Haxe. Some of its key features are:

* Utilities to avoid boilerplate code
  * Currying
  * Lazy evaluation
  * Closure wrapping
  * Continuations (Not to confuse with continuation-passing style)
* Immutable collections
* Option type
* Tuple type
* IoC Container (no reflections, no Metadata and immutable!)
* Signals