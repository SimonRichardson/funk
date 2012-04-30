#library("funk:funk");

#import("dart:core");

#source("IFunkObject.dart");
#source("Type.dart");
#source("Product.dart");
#source("ProductIterator.dart");
#source("util/eq.dart");
#source("util/require.dart");
#source("util/requireRange.dart");
#source("util/verifiedType.dart");
#source("errors/ArgumentError.dart");
#source("errors/RangeError.dart");
#source("exceptions/IllegalByDefinitionException.dart");
#source("exceptions/NoSuchElementException.dart");
#source("exceptions/TypeException.dart");
#source("tuple/ITuple.dart");
#source("tuple/Tuple1.dart");
#source("tuple/Tuple2.dart");
#source("option/Option.dart");
#source("option/None.dart");
#source("option/Some.dart");
#source("option/when.dart");
#source("collections/ICollection.dart");
#source("collections/IList.dart");
#source("collections/toList.dart");
#source("collections/IteratorUtil.dart");
#source("collections/immutable/ListImpl.dart");
#source("collections/immutable/NilImpl.dart");
#source("ioc/errors/BindingException.dart");
#source("ioc/IProvider.dart");
#source("ioc/IScope.dart");
#source("ioc/Binding.dart");
#source("ioc/Module.dart");
#source("ioc/Injector.dart");
#source("ioc/inject.dart");
#source("ioc/injectIn.dart");
#source("types/ListType.dart");
#source("types/OptionType.dart");
#source("types/StringType.dart");

main(){
  final Injector injector = new Injector();
  final IModule module = injector.initialize(new CustomModule());
  final Mock mock = module.getInstance(new MockType());
  
  print(mock.text);
}

class CustomModule extends Module {
  
  CustomModule(){
  }
  
  void configure() {
    bind(new StringType()).toInstance("Test");
  }
}

class MockType extends Type<Mock> {
  MockType() {
  }
  
  Mock create([List args]) {
    return new Mock();
  }
  
  int hashCode() => 1323;
  
  bool equals(IFunkObject that) => this == that || hashCode() == that.hashCode();
}

class Mock {
  
  String _text;
  
  Mock(){
    _text = inject(new StringType());
  }
  
  String get text() => _text;
}