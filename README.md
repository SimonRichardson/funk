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
* Actor model
* Immutable collections
* Reactive streams
* Option type
* Tuple type
* IoC Container (no reflections, no Metadata and immutable!)
* Signals

# Building
The Funk library doesn't not necessarily build anything as it's a library. So the idea is to import 
those into your project, which you can do in the following ways.

## Haxelib - Stable Release

* Make sure haxelib is setup (run ```haxelib setup```)
* ``` haxelib install funk ```
* Inside your .hxml file you use for compiling your haxe project add the following line ``` -lib funk ```

## Haxelib - Beta Release (aka Git release)

* Make sure haxelib is setup (run ```haxelib setup```)
* ``` haxelib git funk https://github.com/SimonRichardson/funk.git funk ```
* Inside your .hxml file you use for compiling your haxe project add the following line ``` -lib funk ```

## Commando styleé (unsupported)

* Download the branch zip file from github
* Extract the zip file and dump it into your haxe path.

More information about building can be found here [using_haxelib](http://haxe.org/doc/haxelib/using_haxelib)

# Testing
The Funk library is unit tested with [munit](https://github.com/massiveinteractive/MassiveUnit) 
testing library for more information refer to the guide. Suffice it to say you'll need to install 
munit via haxelib

* ``` haxelib install munit ```
* ``` haxelib install hamcrest ```

Once that's in installed (installs other dependencies) you can then run the tests by calling the 
following command from the root directory. 

``` haxelib run munit test -nogen -js -as3 ```

Note: There is an issue building neko so the ci server is also down, once this has been rectified 
then I'll post commands to get this also running.