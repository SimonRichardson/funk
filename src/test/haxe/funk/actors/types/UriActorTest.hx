package funk.actors.types;

import funk.actors.types.ProxyActor;
import funk.actors.types.UriActor;
import funk.collections.immutable.List;
import funk.types.Either;
import funk.types.extensions.Promises;
import haxe.ds.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.actors.extensions.Actors;
using funk.actors.extensions.Messages;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class UriActorTest {

    @Test
    public function sending_a_value_to_proxy__should_get_a_uri() : Void {
        // FIXME (Simon) : Unit test the uri package first.
        //var actor = new UriActor();
        //actor.dispatch('javascript: void;').then(function(message) {
        //    trace(message);
        //});
    }
}
