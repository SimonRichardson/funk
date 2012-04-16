function mapEven(value){
    var v = funk.option.toValue(value);
    var asInt = Math.floor(v);

    if(0 != (v - asInt)) {
        return false;
    }

    return (asInt & 1) == 0;
}