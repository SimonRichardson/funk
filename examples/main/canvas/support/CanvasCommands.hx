package support;

enum CanvasCommands {
    Clear(x : Float, y : Float, width : Float, height : Float);
    FillStyle(color : String);
    FillRect(x : Float, y : Float, width : Float, height : Float);
    MoveTo(x : Float, y : Float);
    Translate(x : Int, y : Int);
}
