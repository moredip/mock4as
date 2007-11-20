package org.mock4as.samples.greeting
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
	import org.mock4as.Mock;

    public class GreetingTest extends TestCase
	{
		public function GreetingTest(methodName : String){
            super(methodName);
        }
            		
		public function testGreetingInAnyLanguage():void{
			// create the mock
			var mock:MockTranslator = new MockTranslator();
			// set expectations
			mock.expects("translate").withArgs("English","Portuguese","Hello").willReturn("Ola");
			// inject the mock			
			var myGreeting:Greeting = new Greeting(mock);
			// execute and assert on greetign and 
			assertEquals("Ola Paulo", myGreeting.sayHello("Portuguese", "Paulo"));
			// verify mock behavior
			assertTrue(mock.errorMessage(), mock.success());
		}  			
	}
}

// Inner Class
import org.mock4as.Mock;
import org.mock4as.samples.greeting.ITranslator;

class MockTranslator extends Mock implements ITranslator {
	public function translate(from:String, to:String, word:String):String
	{
		record("translate", from, to, word);
		return expectedReturnFor("translate") as String;
	}
}
    
