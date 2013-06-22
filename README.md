```haxe
"HELLO WORLD" == "dlrow olleh".toList().map(_.toUpperCase).reduceRight(_.plus_).get()
```

# Build status

Development [Neko build failure issue](https://github.com/SimonRichardson/funk/issues/44)
[![Build Status](https://travis-ci.org/SimonRichardson/funk.png?branch=feature/haxe3-refactor)](http://travis-ci.org/SimonRichardson/funk)

# Introduction
The Funk library supports functional development in Haxe. Some of its key features are:

* Utilities to avoid boilerplate code
  * Currying
  * Lazy evaluation
  * Closure wrapping
  * Continuations (Not to confuse with continuation-passing style)
* Actor model
  * Reactor support
  * ModelViewController support, via a Facade.
  * WebWorker support (initial working example)
  * Ask support, via Futures
* Immutable collections
* Reactive streams
* Futures (Promises)
* Option type
* Tuple type
* IoC Container (no reflections, no Metadata and immutable!)
* Signals
* Logging

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

## Setup
The Funk library is unit tested with [munit](https://github.com/massiveinteractive/MassiveUnit)
testing library for more information refer to the guide. Suffice it to say you'll need to install
munit via haxelib

* ``` haxelib install munit ```
* ``` haxelib install hamcrest ```

## Unit testing
Once that's in installed (installs other dependencies) you can then run the tests by calling the
following command from the root directory.

``` haxelib run munit test -nogen -js -as3 ```

Note: There is an issue building neko so the ci server is also down, once this has been rectified
then I'll post commands to get this also running.

## Coverage 
Alternatively you can also run full coverage as well, to help see what tests are covering what.

``` haxelib run munit test -nogen -coverage -js -as3 ```

Note: Actor coverage is really low and needs to be updated.
