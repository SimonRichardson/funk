package;

import All;

import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;

class TestRunner {
	
	public function new(){
		var client = new RichPrintClient();
		
		var runner = new massive.munit.TestRunner(client); 
		runner.addResultClient(new HTTPClient(new JUnitReportClient()));
        runner.completionHandler = completionHandler;
        runner.run([TestSuite]);
	}
	
	public static function main() {
		trace("Hello From FDT haXe !");
		new TestRunner();
	}
	
	private function completionHandler(successful:Bool):Void
    {
        try
        {
            #if flash
                flash.external.ExternalInterface.call("testResult", successful);
            #elseif js
                js.Lib.eval("testResult(" + successful + ");");
            #elseif neko
                neko.Sys.exit(0);
            #end
        }
        // if run from outside browser can get error which we can ignore
        catch (e:Dynamic)
        {
        }
    }
}
