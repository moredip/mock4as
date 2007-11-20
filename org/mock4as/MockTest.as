package org.mock4as
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    
    import org.mock4as.samples.greeting.Greeting
    import org.mock4as.samples.greeting.ITranslator;
    	
    public class MockTest extends TestCase
	{
		var METHOD:String = "translate";
		var ARG1:String = "English";
		var ARG2:String = "Portuguese";
		var ARG3:String = "Hello";

        public function MockTest(methodName : String){
            super(methodName);
        }
            
		public function testWrongMethodName():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_METHOD:String = "WRONG_METHOD";
			mock.expects(WRONG_METHOD).withArgs(ARG1,ARG2,ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());
			var expectedErrorMessage:String = "Unexpected method call - translate(...)";
			assertEquals(expectedErrorMessage, mock.errorMessage());
		}  			

		public function testWrongFirstArg():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(WRONG_ARG, ARG2, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());
			var expectedErrorMessage:String = "Unexpected argument value. Expected translate(WRONG_ARG,Portuguese,Hello), but translate(English,Portuguese,Hello) was invoked instead.";
			assertEquals(expectedErrorMessage, mock.errorMessage());
		}  			

		public function testWrongSecondArg():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(ARG1, WRONG_ARG, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());
			var expectedErrorMessage:String = "Unexpected argument value. Expected translate(English,WRONG_ARG,Hello), but translate(English,Portuguese,Hello) was invoked instead.";
			assertEquals(expectedErrorMessage, mock.errorMessage());
		}  			
		public function testWrongThirdArg():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(ARG1,ARG2,WRONG_ARG).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());
			var expectedErrorMessage:String = "Unexpected argument value. Expected translate(English,Portuguese,WRONG_ARG), but translate(English,Portuguese,Hello) was invoked instead.";
			assertEquals(expectedErrorMessage, mock.errorMessage());
		}  			
		public function testWrongArgNumberLessArgs():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(ARG1,ARG2).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());
			var expectedErrorMessage:String = "Unexpected argument value. Expected translate(English,Portuguese), but translate(English,Portuguese,Hello) was invoked instead.";
			assertEquals(expectedErrorMessage, mock.errorMessage());
		}  			
		 
		public function testMethodInvocationMoreTimesThanExpected():void{
			var mock:MockTranslator = new MockTranslator();

			mock.expects(METHOD).times(0).withArgs(ARG1, ARG2, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());
			var expectedErrorMessage:String = "Unexpected method call. Expected translate(...) to be invoked 0 time(s), but it was invoked 1 time(s).";
			assertEquals(expectedErrorMessage, mock.errorMessage());
			
		} 
				 
		public function testMethodInvocationLessTimesThanExpected():void{
			var mock:MockTranslator = new MockTranslator();

			mock.expects(METHOD).times(2).withArgs(ARG1, ARG2, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			mock.verify();
			assertFalse(mock.success());
			var expectedErrorMessage:String = "Unexpected method call. Expected translate(...) to be invoked 2 time(s), but it was invoked 1 time(s).";
			assertEquals(expectedErrorMessage, mock.errorMessage());
			
		} 
		public function testSuccessMethodInvocation():void{
			var mock:MockTranslator = new MockTranslator();

			mock.expects(METHOD).withArgs(ARG1, ARG2, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			// First invocation
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertTrue(mock.success());
			var expectedMessage:String = "Ola Paulo";
			assertEquals(expectedMessage, greetingMessage);
		}  			

	}
	
}

class MethodInvocation {
	var argIndex:int=0;
	var timesInvoked:int=1;
	var args:Array = new Array();
	var returnValue:Object;
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