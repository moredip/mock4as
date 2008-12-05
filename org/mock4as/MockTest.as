package org.mock4as
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    
    import org.mock4as.samples.MockSomeInterface;
    import org.mock4as.samples.greeting.Greeting;
    import org.mock4as.samples.greeting.ITranslator;
    	
    public class MockTest extends TestCase
	{
		private var METHOD:String = "translate";
		private var ARG1:String = "English";
		private var ARG2:String = "Portuguese";
		private var ARG3:String = "Hello";

        public function MockTest(methodName : String){
            super(methodName);
        }
        
            public static function suite():TestSuite
            {
            var testSuite:TestSuite = new TestSuite();
            
            // test negative scenarios
            testSuite.addTest(new MockTest("testWrongMethodName"));
            testSuite.addTest(new MockTest("testWrongFirstArg"));
            testSuite.addTest(new MockTest("testWrongSecondArg"));
            testSuite.addTest(new MockTest("testWrongThirdArg"));
            testSuite.addTest(new MockTest("testWrongArgNumberLessArgs"));
            testSuite.addTest(new MockTest("testMethodInvocationMoreTimesThanExpected"));
            testSuite.addTest(new MockTest("testMethodInvocationLessTimesThanExpected"));
            
            testSuite.addTest(new MockTest("testFailsIfMethodNeverCalled"));
            testSuite.addTest(new MockTest("testFailsIfMoreMethodsAreCalledThanExpected"));
            // teest positive scenario
            testSuite.addTest(new MockTest("testSuccessMethodInvocation"));
            // mock in composition
            // If you don't want to subclass mock (mainly because you want to subclass another class)
            // you can use mock in composition
            // 
            testSuite.addTest( new MockTest("testSuccess_whenMoreMethodsAreCalledThanExpected_shouldReturnFalse"));
            testSuite.addTest( new MockTest("testSuccess_whenNoMethodsCalledButAtLeastOneExpected_shouldReturnFalse"));
            testSuite.addTest( new MockTest("testSuccess_whenExpectedCallsEqualActualCalls_shouldReturnTrue"));
            testSuite.addTest( new MockTest("testSuccess_whenExpectedCallsWithExpectedArgsEqualActualCallsWithActualArgs_shouldReturnTrue"));
            testSuite.addTest( new MockTest("testSuccess_whenExpectedArgDoesNotEqualActualArg_shouldReturnFalse"));
            testSuite.addTest( new MockTest("testSuccess_whenExpected2ndArgDoesNotEqualActual2ndArg_shouldReturnFalse"));
            testSuite.addTest( new MockTest("testWillReturn_shouldReturnValueDefinedByTest"));
            testSuite.addTest( new MockTest("testWillReturn_shouldReturnTheObjectForTheMethodWithTheExpectedArgs"));
            testSuite.addTest( new MockTest("testWillThrow_shouldThrowErrorObjectDefinedByTest"));
            testSuite.addTest( new MockTest("testSuccess_whenExpectedMethodIsCalledMultipleTimesWithAtLeastOneUnexpectedArg_shouldFail"));
            testSuite.addTest( new MockTest("testSuccess_whenMethodCalledTwiceWithSameExpectedArg_shouldReturnTrue"));
            testSuite.addTest( new MockTest("testSuccess_whenMethodNameCalledIsDifferentThanMethodNameExpected_shouldReturnFalse"));
            testSuite.addTest( new MockTest("testSuccess_whenMethodNameCalledWithSameArgsButDifferentNameAsMethodExpected_shouldReturnFalse"));
            testSuite.addTest( new MockTest("testSuccess_whenLessArgsArePassedThanExpected_shouldReturnFalse"));
            testSuite.addTest( new MockTest("testSuccess_whenErrorExpectedAndMethodsCalledAsExpected_shouldReturnTrue"));
            return testSuite;
        }
        
            
        public function testFailsIfMethodNeverCalled():void
         {
           var mock:MockTranslator = new MockTranslator();
           mock.expects("someMethodThatDoesNotExist");
           assertFalse(mock.success());
       }
       
       	//Unexpected method call - translate(...)
		public function testWrongMethodName():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_METHOD:String = "WRONG_METHOD";
			mock.expects(WRONG_METHOD).withArgs(ARG1,ARG2,ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());

		}  			

		//Unexpected argument value. Expected translate(WRONG_ARG,Portuguese,Hello), but translate(English,Portuguese,Hello) was invoked instead.
		public function testWrongFirstArg():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(WRONG_ARG, ARG2, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());

		}
		  			
		//Unexpected argument value. Expected translate(English,WRONG_ARG,Hello), but translate(English,Portuguese,Hello) was invoked instead.
		public function testWrongSecondArg():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(ARG1, WRONG_ARG, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());

		}
		
		//Unexpected argument value. Expected translate(English,Portuguese,WRONG_ARG), but translate(English,Portuguese,Hello) was invoked instead.
		public function testWrongThirdArg():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(ARG1,ARG2,WRONG_ARG).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());

		}  
		
		//Unexpected argument value. Expected translate(English,Portuguese), but translate(English,Portuguese,Hello) was invoked instead.		
		public function testWrongArgNumberLessArgs():void{
			var mock:MockTranslator = new MockTranslator();
			var WRONG_ARG:String = "WRONG_ARG";

			mock.expects(METHOD).withArgs(ARG1,ARG2).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 

			assertFalse(mock.success());

		}  			
		
		//Unexpected method call. Expected translate(...) to be invoked 0 time(s), but it was invoked 1 time(s).";
		public function testMethodInvocationMoreTimesThanExpected():void{
			var mock:MockTranslator = new MockTranslator();

			mock.expects(METHOD).times(0).withArgs(ARG1, ARG2, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			
			assertFalse(mock.success());

			
		} 
		
		//Unexpected method call. Expected translate(...) to be invoked 2 time(s), but it was invoked 1 time(s).		 
		public function testMethodInvocationLessTimesThanExpected():void{
			var mock:MockTranslator = new MockTranslator();

			mock.expects(METHOD).times(2).withArgs(ARG1, ARG2, ARG3).willReturn("Ola");
			var myGreeting:Greeting = new Greeting(mock);
			
			var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo"); 
			mock.verify();
			assertFalse(mock.success());

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
		
		public function testFailsIfMoreMethodsAreCalledThanExpected():void
        {
               var mock:MockTranslator = new MockTranslator();
               mock.expects(METHOD).withArgs(ARG1, ARG2, ARG3).willReturn("Ola");
               var myGreeting:Greeting = new Greeting(mock);
               // First invocation
               var greetingMessage:String = myGreeting.sayHello("Portuguese", "Paulo");
               assertTrue(mock.success());
               var expectedMessage:String = "Ola Paulo";
              assertEquals(expectedMessage, greetingMessage);
               myGreeting.doSomethingElse();
               mock.verify();
               assertFalse(mock.success());
        }

        
        
        
        public function testSuccess_whenMoreMethodsAreCalledThanExpected_shouldReturnFalse():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			mockClass.expects("doSomething").times(1);
			mockClass.doSomething();
			mockClass.doSomethingElse("someString");
			mockClass.verify();
			assertFalse(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenNoMethodsCalledButAtLeastOneExpected_shouldReturnFalse():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			mockClass.expects("doSomething").times(1);
			mockClass.verify();
			assertFalse(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenExpectedCallsEqualActualCalls_shouldReturnTrue():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			mockClass.expects("doSomething").times(1);
			mockClass.doSomething();
			mockClass.verify();
			assertTrue(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenExpectedCallsWithExpectedArgsEqualActualCallsWithActualArgs_shouldReturnTrue():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var someStringArg:String = "someStringArg";
			mockClass.expects("doSomethingElse").times(1).withArg(someStringArg);
			mockClass.doSomethingElse(someStringArg);
			mockClass.verify();
			assertTrue(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenExpectedArgDoesNotEqualActualArg_shouldReturnFalse():void
		{
			//
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var someStringArg:String = "someStringArg";
			mockClass.expects("doSomethingElse").times(1).withArg("someOtherStringArg");
			mockClass.doSomethingElse(someStringArg);
			mockClass.verify();
			//
			assertFalse(mockClass.errorMessage(), mockClass.success());
			//
		}
		
		public function testSuccess_whenExpected2ndArgDoesNotEqualActual2ndArg_shouldReturnFalse():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var someStringArg:String = "someStringArg";
			var someUnexpectedStringArg:String = "someUnexpectedStringArg";
			var someXMLArg:XML = <TEST>test</TEST>;
			var someUnexpectedXMLArg:XML = <UNEXPECTED/>;
			mockClass.expects("doSomethingWith2Args").times(1).withArgs(someStringArg, someXMLArg);
			mockClass.doSomethingWith2Args(someUnexpectedStringArg, someUnexpectedXMLArg);
			mockClass.verify();
			assertFalse(mockClass.errorMessage(), mockClass.success());
		}
		
		
		public function testWillReturn_shouldReturnValueDefinedByTest():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var someNodeName:String = "someNodeName";
			var expectedXMLReturnValue:XML = <TEST>test</TEST>;
			mockClass.expects("doSomethingAndReturnXML").withArg(someNodeName).willReturn(expectedXMLReturnValue);
			var actualXMLReturned:XML = mockClass.doSomethingAndReturnXML(someNodeName);
			assertEquals("Expecting "+expectedXMLReturnValue+" but was: "+actualXMLReturned, expectedXMLReturnValue, actualXMLReturned);
		}
		
		public function testWillReturn_shouldReturnTheObjectForTheMethodWithTheExpectedArgs():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var firstNodeName:String = "firstNodeName";
			var secondNodeName:String = "secondNodeName";
			var expectedXMLForFirstNodeName:XML = <TEST>firstNodeName</TEST>;
			var expectedXMLForSecondNodeName:XML = <TEST>secondNodeName</TEST>
			mockClass.expects("doSomethingAndReturnXML").withArg(firstNodeName).willReturn(expectedXMLForFirstNodeName);
			mockClass.expects("doSomethingAndReturnXML").withArg(secondNodeName).willReturn(expectedXMLForSecondNodeName);
			var actualXMLReturnedForFirstNodeName:XML = mockClass.doSomethingAndReturnXML(firstNodeName);
			var actualXMLReturnedForSecondNodeName:XML = mockClass.doSomethingAndReturnXML(secondNodeName);
			assertEquals("", expectedXMLForFirstNodeName, actualXMLReturnedForFirstNodeName);
			assertEquals("", expectedXMLForSecondNodeName, actualXMLReturnedForSecondNodeName);
		}
		
		public function testWillThrow_shouldThrowErrorObjectDefinedByTest():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var someNodeName:String = "someNodeName";
			var expectedMessage:String = "Mock message thrown.";
			mockClass.expects("doSomething").willThrow(new Error(expectedMessage));
			try
			{
				mockClass.doSomething();
			}
			catch (e:Error)
			{
				assertEquals("Expecting "+expectedMessage+" but was: "+e.message, expectedMessage, e.message);
				return;
			}
			fail("Expecting error to be thrown but none was thrown.");
		}

		public function testSuccess_whenExpectedMethodIsCalledMultipleTimesWithAtLeastOneUnexpectedArg_shouldFail():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var firstArgValue:String = "firstArgValue";
			var secondArgValue:String = "secondArgValue";
			mockClass.expects("doSomethingElse").times(1).withArg(firstArgValue);
			mockClass.expects("doSomethingElse").times(1).withArg(secondArgValue);
			mockClass.doSomethingElse(firstArgValue);
			mockClass.doSomethingElse("someUnexpectedArg");
			assertFalse("mockClass.success() should fail because the second time we called the method we passed an unexpected arg", mockClass.success());
		}
		
		public function testSuccess_whenMethodCalledTwiceWithSameExpectedArg_shouldReturnTrue():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var firstArgValue:String = "firstArgValue";
			var secondArgValue:String = "secondArgValue";
			mockClass.expects("doSomethingElse").times(2).withArg(firstArgValue);
			mockClass.doSomethingElse(firstArgValue);
			mockClass.doSomethingElse(firstArgValue);
			mockClass.verify();
			assertTrue(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenMethodNameCalledIsDifferentThanMethodNameExpected_shouldReturnFalse():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			mockClass.expects("doSomething").times(1);
			mockClass.anotherMethodWithNoArgs();
			mockClass.verify();
			assertFalse(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenMethodNameCalledWithSameArgsButDifferentNameAsMethodExpected_shouldReturnFalse():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var someStringArg:String = "someStringArg";
			mockClass.expects("doSomethingElse").times(1).withArg(someStringArg);
			mockClass.doSomethingAndReturnXML("someStringArg");
			mockClass.verify();
			assertFalse(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenLessArgsArePassedThanExpected_shouldReturnFalse():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			var someStringArg:String = "someStringArg";
			mockClass.expects("doSomethingAndReturnXML").times(1);
			mockClass.doSomethingAndReturnXML("someStringArg");
			mockClass.verify();
			assertFalse(mockClass.errorMessage(), mockClass.success());
		}
		
		public function testSuccess_whenErrorExpectedAndMethodsCalledAsExpected_shouldReturnTrue():void
		{
			var mockClass:MockSomeInterface = new MockSomeInterface();
			mockClass.expects("doSomething").times(1).willThrow(new Error("customError"));
			try
			{
				mockClass.doSomething();
				fail("expecting error but none was thrown");
			} 
			catch (e:Error)
			{
				assertTrue(mockClass.errorMessage(), mockClass.success());
			}
		}
	}
	
}

class MethodInvocation {
	internal var argIndex:int=0;
	internal var timesInvoked:int=1;
	internal var args:Array = new Array();
	internal var returnValue:Object;
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
	public function doSomethingElse():void
	{
		record("doSomethingElse");
	}
}