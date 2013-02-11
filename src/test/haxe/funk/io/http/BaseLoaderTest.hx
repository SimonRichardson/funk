package funk.io.http;

class BaseLoaderTest {

    public var TIMEOUT : Int = 4000;

    public var baseUri : String;

    public var baseType : String;

    public function setup() {
        baseUri = Std.format("http://localhost:1234/echo.n?type=${baseType}&");
    }
}
