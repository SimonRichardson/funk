package funk.actors.routing;

import funk.actors.routing.Routing;

class RoundRobinRouter extends AccessRouter {

    public function new(nrOfInstances : Int) {
        super(nrOfInstances);
    }

    override private function access(offset : Int, size : Int) : Int return offset % size;

    override public function toString() return '[RoundRobinRouter (nrOfInstances=${_nrOfInstances})]';
}
