package org.mock4as
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    
    import org.mock4as.samples.bank.BankSystemTest;
    import org.mock4as.samples.greeting.GreetingTest;
    import org.mock4as.samples.mockInComposition.test.MockInCompositionTest;
    import org.mock4as.samples.publisher.PublisherTest;
    
    public class AllTests extends TestCase
	{
	
        public function AllTests(methodName : String){
            super(methodName);
        }
        
        public static function suite():TestSuite
        {
            var testSuite:TestSuite = new TestSuite();
            testSuite.addTest(new AllTests("testTheTruth"));
            testSuite.addTest(new GreetingTest("testGreetingInAnyLanguage"));
            testSuite.addTest(new PublisherTest("testOneSubscriberReceivesAMessage"));
            testSuite.addTest(new BankSystemTest("testTheTruth"));
            testSuite.addTest(new BankSystemTest("testTransferSameCurrency"));
            testSuite.addTest(new BankSystemTest("testTransferDifferentCurrency"));
            testSuite.addTest(new BankSystemTest("testTransferInsufficientFunds"));
            testSuite.addTest(MockTest.suite());
            testSuite.addTest(MockInCompositionTest.suite());
            return testSuite;
        }
        
        public function testTheTruth():void{
            assertTrue(true);
        }
        
        
 
	}
}
	