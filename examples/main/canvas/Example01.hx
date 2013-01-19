package ;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.ListsUtil;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;
import CommonJS;
import UserAgentContext;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Tuples2;
using Example01.HtmlWildcards;

class Example01 {

    public function new() {
        // Create a list of 6 layers instances.
        var layers = ListsUtil.fill(6)(Pass.instanceOf(Layer));

        // Map the layers to their styles object and apply a
        // function on each of them.
        layers.map(_.context()).foreach(function(c) {
            c.fillStyle("#00ffff");
            c.fillRect(0, 0, 20, 20);
        });

        // Combine the Layers objects with their index, resulting
        // in a List.&lt;Tuple2.&lt;Layer, Int&gt;&gt;
        //
        // Apply a function on each tuple in order to position the
        // sprite based on its index in the list.
        layers.zipWithIndex().foreach(function(tuple) {
            var element : Layer = tuple._1();
            var index : Int = tuple._2();

            var pos = index * 21;

            element.x = pos;
            element.y = pos;
        });

        // Add all layers to the dom
        layers.foreach(_.addLayer(getCanvas()));
    }

    public function getCanvas() : HTMLCanvasElement {
        return CommonJS.getHtmlDocument().body.getElementsByTagName('canvas')[0];
    }

    public static function main() {
        new Example01();
    }
}

class Layer {

    private var _context : CanvasContext2D;

    public var x(get_x, set_x) : Float;

    public var y(get_y, set_y) : Float;

    private var _x : Float;

    private var _y : Float;

    public function new() {
        _context = new CanvasContext2D();
        _x = 0;
        _y = 0;
    }

    public function context() : CanvasContext2D {
        return _context;
    }

    private function get_x() : Float {
        return _x;
    }

    private function set_x(value : Float) : Float {
        _x = value;
        return _x;
    }

    private function get_y() : Float {
        return _y;
    }

    private function set_y(value : Float) : Float {
        _y = value;
        return _y;
    }
}

class CanvasContext2D {

    private var _commands : List<CanvasCommands>;

    public function new() {
        _commands = Nil;
    }

    public function commands() : List<CanvasCommands> {
        return _commands;
    }

    public function fillStyle(color : String) : Void {
        _commands = _commands.append(FillStyle(color));
    }

    public function fillRect(x : Float, y : Float, width : Float, height : Float) : Void {
        _commands = _commands.append(FillRect(x, y, width, height));
    }

    public function moveTo(x : Float, y : Float) : Void {
        _commands = _commands.append(MoveTo(x, y));
    }
}

enum CanvasCommands {
    FillStyle(color : String);
    FillRect(x : Float, y : Float, width : Float, height : Float);
    MoveTo(x : Float, y : Float);
}

class HtmlWildcards {

    public static function addLayer(    wildcard : Wildcard,
                                        parent : HTMLCanvasElement
                                        ) : Function1<Layer, Void> {
        var context = parent.getContext("2d");

        return function(layer : Layer) {

            context.save();
            context.translate(layer.x, layer.y);

            var commands = layer.context().commands();
            commands.foreach(function (command) {
                switch(command) {
                    case FillStyle(color):
                        context.fillStyle = color;
                    case FillRect(x, y, width, height):
                        context.fillRect(x, y, width, height);
                    case MoveTo(x, y):
                        context.moveTo(x, y);
                }
            });

            context.restore();
        };
    }

    public static function context(wildcard : Wildcard) : Function1<Layer, CanvasContext2D> {
        return function(layer : Layer) {
            return layer.context();
        };
    }

}
