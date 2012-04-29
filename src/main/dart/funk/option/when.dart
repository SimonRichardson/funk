when(Option option, cases){
  if(verifiedType(option, new OptionType())) {
    if(option is None) {
      if(cases["none"] != null) {
        return cases["none"]();
      } else {
        if(cases["any"] != null) {
          return cases["any"]();
        } else {
          throw new NoSuchElementException([]);
        }
      }
    } else if(option is Some) {
      if(cases["some"] != null) {
        return cases["some"](option.get);
      } else {
        if(cases["any"] != null) {
          return cases["any"](option.get);
        } else {
          throw new NoSuchElementException([]);
        }
      }
    }
  }
}
