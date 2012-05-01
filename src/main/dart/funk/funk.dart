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
  // print(toList("dlrow olleh").reverse);
  
  final Injector injector = new Injector();
  final IModule module = injector.initialize(new CustomModule());
  final Mock mock0 = module.getInstance(new MockType());
  final Mock mock1 = module.getInstance(new MockType());
  
  print(mock0.text);
  print(mock0.numInstances);
  
  print(mock1.numInstances);
}

class CustomModule extends Module {
  
  CustomModule(){
  }
  
  void configure() {
    bind(new StringType()).toInstance("Test");
    bind(new SingletonInstanceType()).asSingleton();
  }
}

class MockType extends Type<Mock> {
  
  static int HASH_CODE;
  
  static MockType _instance;
  
  factory MockType() {
    if(_instance == null) {
      _instance = new MockType._internal();
    }
    return _instance;
  }
  
  MockType._internal() {
    HASH_CODE = ++Type.HASH_SEED;
  }
  
  Mock create([List args]) {
    return new Mock();
  }
  
  int hashCode() => HASH_CODE;
  
  bool equals(IFunkObject that) => this == that || hashCode() == that.hashCode();
}

class SingletonInstanceType extends Type<SingletonInstance> {
  
  static int HASH_CODE;
  
  static SingletonInstanceType _instance;
  
  factory SingletonInstanceType() {
    if(_instance == null) {
      _instance = new SingletonInstanceType._internal();
    }
    return _instance;
  }
  
  SingletonInstanceType._internal() {
    HASH_CODE = ++Type.HASH_SEED;
  }
  
  SingletonInstance create([List args]) {
    return new SingletonInstance();
  }
  
  int hashCode() => HASH_CODE;
  
  bool equals(IFunkObject that) => this == that || hashCode() == that.hashCode();
}

class Mock {
  
  SingletonInstance _instance;
  
  String _text;
  
  Mock(){
    _text = inject(new StringType());
    _instance = inject(new SingletonInstanceType());
  }
  
  String get text() => _text;
  
  int get numInstances() => SingletonInstance.numInstances;
}

class SingletonInstance {
  
  static int numInstances = 0;
  
  SingletonInstance() {
    numInstances++;
  }
}