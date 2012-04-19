"use strict";

var funk = {};
var isCommonJS = "undefined" === typeof window && "undefined" === typeof exports;
if(isCommonJS) {
    exports.funk = funk;
}

funk.natives = {
    object: {
        proto: Object.prototype,
        toString: Object.prototype.toString,
        hasOwnProperty: Object.prototype.hasOwnProperty
    },
    array: {
        proto: Array.prototype,
        hasIsArray: "undefined" !== typeof Array.isArray,
        forEach: Array.prototype.forEach,
        hasForEach: "undefined" !== typeof Array.prototype.forEach,
        map: Array.prototype.map,
        hasMap: "undefined" !== typeof Array.prototype.map
    }
};
funk.debug = true;
funk.print = function(){
    if(funk.debug) {
        console.log(funk.toArray(arguments).join(", "));
    }
};
funk.toString = function(obj){
    return funk.natives.object.toString.call(obj);
};
funk.isArray = function(obj){
    return funk.natives.array.hasIsArray ? Array.isArray(obj) : funk.toString(obj) == '[object Array]';
};
funk.isObject = function(obj){
    return "object" === typeof obj;
};
funk.isArguments = function(obj){
    return !funk.isArray(obj) && funk.isObject(obj) ? "undefined" !== typeof obj.length : false;
};
funk.isInteger = function(obj){
    return "number" === typeof obj && obj % 1 == 0;
};
funk.isString = function(obj){
    return "string" === typeof obj;
};
funk.isFunction = function(obj){
    return "function" === typeof obj;
};
funk.toArray = function(obj){
    if(funk.isDefined(obj)) {
        if(funk.isArray(obj)) {
            return obj;
        } else if(funk.isArguments(obj)) {
            return funk.natives.array.proto.slice.call(obj);
        } else if(funk.isObject(obj)) {
            return funk.values(obj);
        } else {
            return [obj];
        }
    }
    return [];
};
funk.has = function(obj, key) {
    if(funk.isValid(obj) && funk.isValid(key)) {
        // Try the undefined check first, as it seems to be more
        // reliable that hasOwnProperty
        var exists = 'undefined' !== typeof obj[key];
        if(!exists) {
            return funk.natives.object.hasOwnProperty.call(obj, key);
        }
        return true;
    }
    return false;

};
funk.each = function(obj, iterator, context){
    if(funk.isDefined(obj)) {
        if(!funk.isDefined(iterator)) iterator = funk.indentity;
        if(funk.natives.array.hasForEach && obj.forEach == funk.natives.array.forEach) {
            obj.forEach(iterator, context);
        } else if(obj.length === +obj.length) {
            for(var i = 0, l = obj.length; i < l; i++) {
                if(i in obj) {
                    iterator.call(context, obj[i], i, obj);
                }
            }
        } else {
            for(var key in obj) {
                if(funk.has(obj, key)) {
                    iterator.call(context, obj[key], key, obj);
                }
            }
        }
    }
};
funk.isDefined = function(value) {
    return "undefined" !== typeof value;
};
funk.isValid = function(value) {
    return value !== null && "undefined" !== typeof value;
};
funk.indentity = function(value){
    return value;
};
funk.values = function(obj) {
    return funk.map(obj, funk.indentity);
};
funk.map = function(obj, iterator, context){
    var results = [];
    if(funk.isDefined(obj)){
        if(!funk.isDefined(iterator)) iterator = funk.indentity;
        if(funk.natives.array.hasMap && obj.map == funk.natives.array.map) return obj.map(iterator, context);
        funk.each(obj, function(value, index, list){
           results[results.length] = iterator.call(context, value, index, list);
        });
        if(obj.length === +obj.length) results.length = obj.length;
    }
    return results;
};