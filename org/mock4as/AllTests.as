package org.mock4as
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    
    import org.mock4as.samples.bank.BankSystemTest;
    import org.mock4as.samples.greeting.GreetingTest;
    import org.mock4as.samples.publisher.PublisherTest;
    
    public class AllTests extends TestCase
	{
	
        public function AllTests(methodName : String){
            super(methodName);
        }
            
		public static function suite():TestSuite{
	    	var myTS:TestSuite = new TestSuite();
    		myTS.addTest(new AllTests("testTheTruth"));
    		
			// test negative scenarios
    		myTS.addTest(new MockTest("testWrongMethodName"));
    		myTS.addTest(new MockTest("testWrongFirstArg"));
    		myTS.addTest(new MockTest("testWrongSecondArg"));
    		myTS.addTest(new MockTest("testWrongThirdArg"));
    		myTS.addTest(new MockTest("testWrongArgNumberLessArgs"));
    		myTS.addTest(new MockTest("testMethodInvocationMoreTimesThanExpected"));
    		myTS.addTest(new MockTest("testMethodInvocationLessTimesThanExpected"));
    		
    		myTS.addTest(new MockTest("testFailsIfMethodNeverCalled"));
  			myTS.addTest(new MockTest("testFailsIfMoreMethodsAreCalledThanExpected"));
    		// teest positive scenario
    		myTS.addTest(new MockTest("testSuccessMethodInvocation"));
    		

    		
    		// mock samples positive tests
    		myTS.addTest(new GreetingTest("testGreetingInAnyLanguage"));
    		myTS.addTest(new PublisherTest("testOneSubscriberReceivesAMessage"));
    		myTS.addTest(new BankSystemTest("testTheTruth"));
    		myTS.addTest(new BankSystemTest("testTransferSameCurrency"));
    		myTS.addTest(new BankSystemTest("testTransferDifferentCurrency"));
    		myTS.addTest(new BankSystemTest("testTransferInsufficientFunds"));
    		
    		// mock in composition
    		// If you don't want to subclass mock (mainly because you want to subclass another class)
    		// you can use mock in composition
    		// 
    		myTS.addTest(new MockTest("testSuccess_forAClassUsingMockInComposition_whereExpectedCallsEqualActualCalls_shouldReturnTrue"));
    		myTS.addTest(new MockTest("testSuccess_forAClassUsingMockInComposition_whereExpectedCallsDoNotEqualActualCalls_shouldReturnFalse"));

			myTS.addTest( new MockTest("testSuccess_whenMoreMethodsAreCalledThanExpected_shouldReturnFalse"));
			myTS.addTest( new MockTest("testSuccess_whenNoMethodsCalledButAtLeastOneExpected_shouldReturnFalse"));
			myTS.addTest( new MockTest("testSuccess_whenExpectedCallsEqualActualCalls_shouldReturnTrue"));
			myTS.addTest( new MockTest("testSuccess_whenExpectedCallsWithExpectedArgsEqualActualCallsWithActualArgs_shouldReturnTrue"));
			myTS.addTest( new MockTest("testSuccess_whenExpectedArgDoesNotEqualActualArg_shouldReturnFalse"));
			myTS.addTest( new MockTest("testSuccess_whenExpected2ndArgDoesNotEqualActual2ndArg_shouldReturnFalse"));
			myTS.addTest( new MockTest("testWillReturn_shouldReturnValueDefinedByTest"));
			myTS.addTest( new MockTest("testWillReturn_shouldReturnTheObjectForTheMethodWithTheExpectedArgs"));
			myTS.addTest( new MockTest("testWillThrow_shouldThrowErrorObjectDefinedByTest"));
			myTS.addTest( new MockTest("testSuccess_whenExpectedMethodIsCalledMultipleTimesWithAtLeastOneUnexpectedArg_shouldFail"));
			myTS.addTest( new MockTest("testSuccess_whenMethodCalledTwiceWithSameExpectedArg_shouldReturnTrue"));
			myTS.addTest( new MockTest("testSuccess_whenMethodNameCalledIsDifferentThanMethodNameExpected_shouldReturnFalse"));
			myTS.addTest( new MockTest("testSuccess_whenMethodNameCalledWithSameArgsButDifferentNameAsMethodExpected_shouldReturnFalse"));
			myTS.addTest( new MockTest("testSuccess_whenLessArgsArePassedThanExpected_shouldReturnFalse"));
    		myTS.addTest( new MockTest("testSuccess_whenErrorExpectedAndMethodsCalledAsExpected_shouldReturnTrue"));
	    	return myTS;
		}
        
		public function testTheTruth():void{
			assertTrue(true);
		} 
	}
}
	