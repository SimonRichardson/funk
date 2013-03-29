package funk.actors.routing;

class RoundRobinRouter {

    private var _nrOfInstances : Int;

    public function new(nrOfInstances : Int) {
        _nrOfInstances = nrOfInstances;
    }

    public function nrOfInstances() : Int return _nrOfInstances;
}
