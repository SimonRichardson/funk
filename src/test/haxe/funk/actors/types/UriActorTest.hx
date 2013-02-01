package funk.actors.types;

import funk.actors.types.ProxyActor;
import funk.actors.types.UriActor;
import funk.collections.immutable.List;
import funk.types.Either;
import funk.types.extensions.Promises;
import funk.types.Option;
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
        //var actor = new UriActor();
        //actor.dispatch('javascript: void;').then(function(message) {
        //    trace(message);
        //});
    }
}
