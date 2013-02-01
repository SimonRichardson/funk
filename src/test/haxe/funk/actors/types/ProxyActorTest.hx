package funk.actors.types;

import funk.actors.types.ProxyActor;
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

class ProxyActorTest {

    @Test
    public function sending_a_value_to_proxy__should_recieve_agents_strings() : Void {
        var actor = new ProxyActor();

        var proxy0 : ProxyAgentActor<String> = actor.agent();
        proxy0.onMessage = function(message) {
            return Promises.dispatch(', Wor');
        };

        var proxy1 : ProxyAgentActor<String> = actor.agent();
        proxy1.onMessage = function(message) {
            return Promises.dispatch('ld!');
        };

        var expected = ', World!';
        var actual = '';

        actor.dispatch(expected).then(function(message : Message<List<String>>) {
            message.body().get().foreach(function(value) {
                actual = value + actual;
            });
        });

        actual.areEqual(expected);
    }

    @Test
    public function sending_a_value_to_proxy__should_recieve_agents_numbers() : Void {
        var actor = new ProxyActor();

        var proxy0 : ProxyAgentActor<String> = actor.agent();
        proxy0.onMessage = function(message) {
            return Promises.dispatch(2);
        };

        var proxy1 : ProxyAgentActor<String> = actor.agent();
        proxy1.onMessage = function(message) {
            return Promises.dispatch(1);
        };

        var expected = 3;
        var actual = 0;

        actor.dispatch('Ignore').then(function(message : Message<List<Int>>) {
            message.body().get().foreach(function(value) {
                actual = value + actual;
            });
        });

        actual.areEqual(expected);
    }
}
