import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.TestRunner;

import suites.ActorsSuite;
import suites.CollectionsSuite;
import suites.IocSuite;
//import suites.NetSuite;
import suites.PromiseSuite;
import suites.ReactiveSuite;
import suites.SignalSuite;
import suites.TypesSuite;

#if js
import js.Lib;
import js.Dom;
#end


/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestMain
{

    #if neko
        private var reporting : Bool;
        private var reportFinished : Bool;
    #end

    static function main(){ new TestMain(); }

    public function new()
    {

        var suites = new Array<Class<massive.munit.TestSuite>>();

        suites.push(ActorsSuite);
        suites.push(CollectionsSuite);
        suites.push(IocSuite);
        //suites.push(NetSuite);
        suites.push(PromiseSuite);
        suites.push(ReactiveSuite);
        suites.push(SignalSuite);
        suites.push(TypesSuite);

        #if MCOVER
            var client = new mcover.coverage.munit.client.MCoverPrintClient();
        #else
            var client = new RichPrintClient();
        #end

        var runner:TestRunner = new TestRunner(client);

        #if ciserver
        runner.addResultClient(new HTTPClient(new JUnitReportClient()));
        #end

        runner.completionHandler = completionHandler;
        runner.run(suites);
    }

    /*
        updates the background color and closes the current browser
        for flash and html targets (useful for continous integration servers)
    */
    private function completionHandler(successful:Bool):Void
    {
        try
        {
            #if flash
                flash.external.ExternalInterface.call("testResult", successful);
            #elseif js
                js.Lib.eval("testResult(" + successful + ");");
            #elseif neko
                neko.Sys.exit(successful ? 0 : 1);
            #end
        }
        // if run from outside browser can get error which we can ignore
        catch (e:Dynamic)
        {
        }
    }
}
