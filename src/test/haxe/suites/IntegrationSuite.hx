package suites;

import massive.munit.TestSuite;

import suites.integration.ListTest;
import suites.integration.StreamTest;

class IntegrationSuite extends TestSuite
{

	public function new()
	{
		super();

		add(suites.integration.ListTest);
		add(suites.integration.StreamTest);
	}
}
