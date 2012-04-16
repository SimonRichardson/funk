funk.collection = funk.collection || {};
funk.collection.immutable = funk.collection.immutable || {};
funk.collection.immutable.List = (function(){
    var makeString = function(list, separator){
        var total = this.size(),
            last = total - 1,
            buffer = "",
            p = list,
            i = 0;

        for(i=0; i<total; ++i){
            buffer += p.head();

            if(i < last){
                buffer += separator;
            }

            p = p.tail();
        }

        return buffer;
    };

    var ListImpl = function(head, tail){
        this._head = (head instanceof funk.option.Option) ? head : funk.option.some(head);
        this._tail = tail;
        this._length = 0;
        this._lengthKnown = false;
        this._newListCtor = funk.collection.immutable.List;
    };
    ListImpl.prototype = new funk.collection.List();
    ListImpl.prototype.constructor = ListImpl;
    ListImpl.prototype.size = function(){
        if(this._lengthKnown) {
            return this._length;
        }
        var p = this;
        var length = 0;
        while(p.nonEmpty()) {
            ++length;
            p = p.tail();
        }

        this._length = length;
        this._lengthKnown = true;
        return length;
    };
    ListImpl.prototype.hasDefinedSize = function(value){
        return true;
    };
    ListImpl.prototype.product$equals = ListImpl.prototype.equals;
    ListImpl.prototype.equals = function(value){
        if(value === funk.util.verifiedType(value, funk.collection.List)) {
            return this.product$equals(value);
        }
        return false;
    };
    ListImpl.prototype.productArity = function(){
        return this.size();
    };
    ListImpl.prototype.productElement = function(index){
        funk.util.requireRange(index, this.productArity());

        var p = this;
        while(p.nonEmpty()) {
            if(index == 0) {
                return p.head();
            }
            p = p.tail();
            index -= 1;
        }

        throw new funk.error.NoSuchElementError();
    };
    ListImpl.prototype.productPrefix = function(){
        return "List";
    };
    ListImpl.prototype.prepend = function(value){
        return new this._newListCtor(value, this);
    };
    ListImpl.prototype.prependAll = function(value){
        if(value === funk.util.verifiedType(value, funk.collection.List)) {
            var total = value.size();
            
            if(0 == total) {
                return this;
            }
            
            var buffer = [];
            var last = total - 1;
            
            var p = value,
                i = 0,
                j = 0;
            
            while(p.nonEmpty()) {
                buffer[i++] = new this._newListCtor(p.head(), null);
                p = p.tail();
            }

            buffer[last]._tail = this;

            for(i=0, j=1; i<last; ++i, ++j) {
                buffer[i]._tail = buffer[j];
            }

            return buffer[0];
        }  
    };
    ListImpl.prototype.get = function(index){
        return this.productElement(index);
    };
    ListImpl.prototype.contains = function(value){
        var p = this;
        while(p.nonEmpty()) {
            if(funk.util.eq(p.head(), value)){
                return true;
            }
            p = p.tail();
        }
        return false;
    };
    ListImpl.prototype.count = function(func){
        var n = 0;
        var p = this;
        while(p.nonEmpty()){
            if(func(p.head())){
                ++n;
            }
            p = p.tail();
        }
        return n;
    };
    ListImpl.prototype.nonEmpty = function(){
        return true;
    };
    ListImpl.prototype.drop = function(index){
        funk.util.require(index >= 0, "index must be positive.");

        var p = this;
        for(var i=0; i<index; ++i){
            if(p.isEmpty()) {
                return funk.collection.immutable.nil();
            }

            p = p.tail();
        }

        return p;
    };
    ListImpl.prototype.dropRight = function(index){
        funk.util.require(index >= 0, "index must be positive.");

        if(0 == index) {
            return this;
        }

        index = this.size() - index;
        if(index <= 0) {
            return funk.collection.immutable.nil();
        }

        var buffer = [];
        var last = index - 1;
        var p = this,
            i = 0,
            j = 0;
        for(i = 0; i<index; ++i){
            buffer[i] = new this._newListCtor(p.head(), null);
            p = p.tail();
        }

        buffer[last]._tail = funk.collection.immutable.nil();

        for(i=0, j=1; i<last; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.dropWhile = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(!func(p.head())) {
                return p;
            }
            p = p.tail();
        }
        return funk.collection.immutable.nil();
    };
    ListImpl.prototype.exists = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(func(p.head())){
                return true;
            }
            p = p.tail();
        }
        return false;
    };
    ListImpl.prototype.filter = function(func){
        var p = this,
            q = null,
            first = null,
            last = null,
            allFiltered = true;
        while(p.nonEmpty()){
            if(func(p.head())) {
                q = new this._newListCtor(p.head(), funk.collection.immutable.nil());

                if(null !== last){
                    last._tail = q;
                }

                if(null === first){
                    first = q;
                }

                last = q;
            } else {
                allFiltered = false;
            }

            p = p.tail();
        }

        if(allFiltered) {
            return this;
        }

        return (null === first) ? funk.collection.immutable.nil() : first;
    };
    ListImpl.prototype.filterNot = function(func){
        var p = this,
            q = null,
            first = null,
            last = null,
            allFiltered = true;
        while(p.nonEmpty()){
            if(!func(p.head())) {
                q = new this._newListCtor(p.head(), funk.collection.immutable.nil());

                if(null !== last){
                    last._tail = q;
                }

                if(null === first){
                    first = q;
                }

                last = q;
            } else {
                allFiltered = false;
            }

            p = p.tail();
        }

        if(allFiltered) {
            return this;
        }

        return (null === first) ? funk.collection.immutable.nil() : first;
    };
    ListImpl.prototype.find = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(func(p.head())){
                return p.head();
            }

            p = p.tail();
        }

        return funk.option.none();
    };
    ListImpl.prototype.flatMap = function(func){
        var index = this.size(),
            buffer = [],
            p = this,
            i = 0;
        while(p.nonEmpty()){
            buffer[i++] = funk.util.verifiedType(func(p.head()), funk.collection.List);
            p = p.tail();
        }

        var list = buffer[--index];
        while(--index > -1) {
            list = list.prependAll(buffer[index]);
        }
        return list;
    };
    ListImpl.prototype.foldLeft = function(x, func){
        var value = x,
            p = this;
        while(p.nonEmpty()){
            value = func(value, p.head());
            p = p.tail();
        }
        return value;
    };
    ListImpl.prototype.foldRight = function(x, func){
        var value = x,
            buffer = this.toArray(),
            index = buffer.length;
        while(--index > -1){
            value = func(value, buffer[index]);
        }
        return value;
    };
    ListImpl.prototype.forall = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(!func(p.head())){
                return false;
            }
            p = p.tail();
        }
        return true;
    };
    ListImpl.prototype.foreach = function(func){
        var p = this;
        while(p.nonEmpty()){
            func(p.head());
            p = p.tail();
        }
    };
    ListImpl.prototype.head = function(){
        return this._head;
    };
    ListImpl.prototype.indices = function(){
        var index = this.size(),
            p = funk.collection.immutable.nil();
        while(--index > -1){
            p = p.prepend(index);
        }
        return p;
    };
    ListImpl.prototype.init = function(){
        return this.dropRight(1);
    };
    ListImpl.prototype.isEmpty = function(){
        return false;
    };
    ListImpl.prototype.last = function(){
        var p = this,
            value = funk.option.none();
        while(p.nonEmpty()){
            value = p.head();
            p = p.tail();
        }
        return value;
    };
    ListImpl.prototype.map = function(func){
        var total = this.size(),
            buffer = [],
            last = total - 1;

        var p = this,
            i = 0,
            j = 0;

        for(i = 0; i < total; ++i) {
            buffer[i] = new this._newListCtor(func(p.head()), null);
            p = p.tail();
        }

        buffer[last]._tail = funk.collection.immutable.nil();

        for(i=0, j=1; i<last; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.partition = function(func){
        var left = [],
            right = [];

        var i = 0,
            j = 0,
            m = 0,
            o = 0;

        var p = this;
        
        while(p.nonEmpty()){
            var l = new this._newListCtor(p.head(), funk.collection.immutable.nil());
            if(func(p.head())){
                left[i++] = l;
            } else {
                right[j++] = l;
            }
            p = p.tail();
        }

        m = i - 1;
        o = j - 1;

        if(m > 0) {
            for(i=0, j=1; i<m; ++i, ++j) {
                left[i]._tail = left[j];
            }
        }

        if(o > 0) {
            for(i=0, j=1; i<o; ++i, ++j) {
                right[i]._tail = right[j];
            }
        }

        return funk.tuple.tuple2(m > 0 ? left[0] : funk.collection.immutable.nil(),
                                 o > 0 ? right[0] : funk.collection.immutable.nil());
    };
    ListImpl.prototype.reduceLeft = function(func){
        var value = this.head();
        var p = this._tail;
        while(p.nonEmpty()){
            value = func(value, p.head());
            p = p.tail();
        }
        // TODO (Simon) make sure it's an option
        return value;
    };
    ListImpl.prototype.reduceRight = function(func){
        var buffer = this.toArray(),
            value = buffer.pop(),
            index = buffer.length;
        while(--index > -1){
            value = func(value, buffer[index]);
        }
        // TODO (Simon) make sure it's an option
        return value;
    };
    ListImpl.prototype.reverse = function(){
        var result = funk.collection.immutable.nil(),
            p = this;
        while(p.nonEmpty()){
            result = result.prepend(p.head());
            p = p.tail();
        }
        return result;
    };
    ListImpl.prototype.tail = function(){
        return this._tail;
    };
    ListImpl.prototype.take = function(index){
        funk.util.require(index >= 0, "index must be positive.");

        if(index > this.size()) {
            return this;
        } else if(0 === index) {
            return funk.collection.immutable.nil();
        }

        var buffer = [],
            last = index - 1,
            p = this,
            i = 0,
            j = 0;

        for(i=0; i<index; ++i){
            buffer[i] = new this._newListCtor(p.head(), null);
            p = p.tail();
        }

        buffer[last]._tail = funk.collection.immutable.nil();

        for(i=0, j=1; i<last; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.takeRight = function(index){
        funk.util.require(index >= 0, "index must be positive.");

        if(index > this.size()){
            return this;
        } else if(0 == index){
            return funk.collection.immutable.nil();
        }

        index = this.size() - index;
        if(index <= 0){
            return this;
        }

        var p = this;
        for(var i=0; i<index; ++i){
            p = p.tail();
        }
        return p;
    };
    ListImpl.prototype.takeWhile = function(func){
        var buffer = [],
            p = this,
            i = 0,
            j = 0,
            n = 0;
        while(p.nonEmpty()){
            if(func(p)){
                buffer[n++] = new this._newListCtor(p.head(), null);
                p = p.tail();
            } else {
                break;
            }
        }

        var m = n - 1;
        if(m <= 0) {
            return funk.collection.immutable.nil();
        }

        for(i=0, j=1; i<m; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.toArray = function(){
        var total = this.size(),
            array = [],
            p = this,
            i = 0;
        for(i=0; i<total; i++){
            array[i] = p.head();
            p = p.tail();
        }
        return array;
    };
    ListImpl.prototype.zip = function(value){
        var total = Math.min(this.size(), value.size()),
            last = total - 1,
            buffer = [],
            i = 0,
            j = 0;

        var p = this,
            q = value;

        for(i=0; i<total; ++i){
            buffer[i] = new this._newListCtor(funk.tuple.tuple2(p.head(), q.head()), null);
            p = p.tail();
            q = q.tail();
        }

        buffer[last]._tail = funk.collection.immutable.nil();

        for(i=0, j=1; i<last; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.zipWithIndex = function(value){
        var total = this.size(),
            last = total - 1,
            buffer = [],
            i = 0,
            j = 0;

        var p = this;

        for(i=0; i<total; ++i){
            buffer[i] = new this._newListCtor(funk.tuple.tuple2(p.head(), i), null);
            p = p.tail();
        }

        buffer[last]._tail = funk.collection.immutable.nil();

        for(i=0, j=1; i<last; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.findIndexOf = function(func){
        var index = 0,
            p = this;
        while(p.nonEmpty()){
            if(func(p.head())){
                return index;
            }

            p = p.tail();
            index++;
        }

        return -1;
    };
    ListImpl.prototype.flatten = function(){
        return this.flatMap(function(x) {
            var item = funk.option.when(x, {
                none: function(){
                    return null;
                },
                some: function(value){
                    return value;
                }
            });
            return item === funk.util.verifiedType(item, funk.collection.List) ? item : funk.collection.toList(item);
        });
    };
    ListImpl.prototype.indexOf = function(value){
        var index = 0,
            p = this;
        while(p.nonEmpty()){
            if(funk.util.eq(p.head(), value)){
                return index;
            }
            p = p.tail();
            index++;
        }
        return -1;
    };
    ListImpl.prototype.iterator = function(){
        return new funk.collection.immutable.ListIterator(this);
    };
    ListImpl.prototype.append = function(value){
        var total = this.size(),
            buffer = [],
            p = this,
            i = 0,
            j = 0;

        while(p.nonEmpty()){
            buffer[i++] = new this._newListCtor(p.head(), null);
            p = p.tail();
        }

        buffer[total] = new this._newListCtor(value, funk.collection.immutable.nil());

        for(i=0, j=1; i<total; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.appendAll = function(value){
        funk.util.verifiedType(value, funk.collection.List);

        var total = this.size(),
            last = total - 1,
            buffer = [],
            p = this,
            i = 0,
            j = 0;

        while(p.nonEmpty()){
            buffer[i++] = new this._newListCtor(p.head(), null);
            p = p.tail();
        }

        buffer[last]._tail = value;

        for(i=0, j=1; i<total; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.prependIterator = function(iterator){
        funk.util.verifiedType(iterator, funk.collection.Iterator);
        return this.prependAll(iterator.toList());
    };
    ListImpl.prototype.appendIterator = function(iterator){
        funk.util.verifiedType(iterator, funk.collection.Iterator);
        return this.appendAll(iterator.toList());
    };
    ListImpl.prototype.prependIterable = function(iterable){
        funk.util.verifiedType(iterable, funk.collection.Iterable);
        return this.prependAll(iterable.iterator.toList());
    };
    ListImpl.prototype.appendIterable = function(iterable){
        funk.util.verifiedType(iterable, funk.collection.Iterable);
        return this.appendAll(iterable.iterator.toList());
    };
    ListImpl.prototype.name = "List";
    return ListImpl;
})();