package suites;

import massive.munit.TestSuite;

import suites.integration.ListTest;

class IntegrationSuite extends TestSuite
{

	public function new()
	{
		super();

		add(suites.integration.ListTest);
	}
}
