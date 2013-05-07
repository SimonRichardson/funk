# Collections

Collections are objects that acts as a data structure (ds) for storing and organizing data in a computer so that it can be used efficiently. Different kinds of data structures are suited to different kinds of applications, and some are highly specialized to specific tasks. For example, B-trees are particularly well-suited for implementation of databases, while compiler implementations usually use hash tables to look up identifiers.

## Collection

TODO

## Immutable

If an object is known to be immutable, it can be copied simply by making a copy of a reference to it instead of copying the entire object. Because a reference (typically only the size of a pointer) is usually much smaller than the object itself, this results in memory savings and a potential boost in execution speed. Immutable objects can be useful in multi-threaded applications. Multiple threads can act on data represented by immutable objects without concern of the data being changed by other threads. Immutable objects are therefore considered to be more thread-safe than mutable objects.

## List

A class for immutable linked lists representing ordered collections of elements of type.
This class comes with a implementing case classes ListType.Nil that implement the abstract members isEmpty, head
and tail. Extra methods via ListTypes also give you a lot of extensions which can be useful.

This class is optimal for last-in-first-out (LIFO), stack-like access patterns. If you need another access pattern, for example, random access or FIFO, consider using a collection more suited to this than List.

List has O(1) prepend and head/tail access. Most other operations are O(n) on the number of elements in the list. This includes the index-based lookup of elements, length, append and reverse. List implements structural sharing of the tail list. This means that many operations are either zero- or constant-memory cost. The functional list is characterized by persistence and structural sharing, thus offering considerable performance and space consumption benefits in some scenarios if used correctly.

## Map

TODO

# Example

## Immutable List

Simple example showing how to create an immutable list.

```
var a = Cons(1, Cons(2, Cons(3, Nil)));
a.foreach(function(v) trace(v)); // 1, 2, 3
```
