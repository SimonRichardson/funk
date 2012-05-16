import massive.munit.TestSuite;

import funk.collections.TestNil;

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(TestNil);
	}
}
