package org.mock4as.samples.mockInComposition.test
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    
    import org.mock4as.samples.mockInComposition.MockInComposition;

    public class MockInCompositionTest extends TestCase
    {
        public function MockInCompositionTest(methodName:String=null)
        {
            super(methodName);
        }
        
        public static function suite():TestSuite
        {
            var testSuite:TestSuite = new TestSuite();
            testSuite.addTest(new MockInCompositionTest("testSuccess_whereExpectedCallsEqualActualCalls_shouldReturnTrue"));
            testSuite.addTest(new MockInCompositionTest("testSuccess_whereExpectedCallsDoNotEqualActualCalls_shouldReturnFalse"));
            
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenMoreMethodsAreCalledThanExpected_shouldReturnFalse"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenNoMethodsCalledButAtLeastOneExpected_shouldReturnFalse"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenExpectedCallsEqualActualCalls_shouldReturnTrue"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenExpectedCallsWithExpectedArgsEqualActualCallsWithActualArgs_shouldReturnTrue"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenExpectedArgDoesNotEqualActualArg_shouldReturnFalse"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenExpected2ndArgDoesNotEqualActual2ndArg_shouldReturnFalse"));
            testSuite.addTest( new MockInCompositionTest("testWillReturn_shouldReturnValueDefinedByTest"));
            testSuite.addTest( new MockInCompositionTest("testWillReturn_shouldReturnTheObjectForTheMethodWithTheExpectedArgs"));
            testSuite.addTest( new MockInCompositionTest("testWillThrow_shouldThrowErrorObjectDefinedByTest"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenExpectedMethodIsCalledMultipleTimesWithAtLeastOneUnexpectedArg_shouldFail"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenMethodCalledTwiceWithSameExpectedArg_shouldReturnTrue"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenMethodNameCalledIsDifferentThanMethodNameExpected_shouldReturnFalse"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenMethodNameCalledWithSameArgsButDifferentNameAsMethodExpected_shouldReturnFalse"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenLessArgsArePassedThanExpected_shouldReturnFalse"));
            testSuite.addTest( new MockInCompositionTest("testSuccess_whenErrorExpectedAndMethodsCalledAsExpected_shouldReturnTrue"));
            return testSuite;
        }
        
        public function testSuccess_whereExpectedCallsEqualActualCalls_shouldReturnTrue():void
        {
            var classWithMockInComposition:MockInComposition = new MockInComposition();
            var someStringArg:String = "someStringArg";
            classWithMockInComposition.expects("someMethod").times(1).withArg(someStringArg);
            classWithMockInComposition.someMethod(someStringArg);
            classWithMockInComposition.verify();
            assertTrue(classWithMockInComposition.errorMessage(), classWithMockInComposition.success());
        }
        
        public function testSuccess_whereExpectedCallsDoNotEqualActualCalls_shouldReturnFalse():void
        {
            var classWithMockInComposition:MockInComposition = new MockInComposition();
            var someStringArg:String = "someStringArg";
            classWithMockInComposition.expects("someMethod").times(1).withArg(someStringArg);
            // In this case, we never call the method on the mock
            // but we are expecting someMethod to get called once with someStringArg
            // so success should return false
            classWithMockInComposition.verify();
            assertFalse(classWithMockInComposition.errorMessage(), classWithMockInComposition.success());
        }
        
        public function testSuccess_whenMoreMethodsAreCalledThanExpected_shouldReturnFalse():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            mockInComposition.expects("doSomething").times(1);
            mockInComposition.doSomething();
            mockInComposition.doSomethingElse("someString");
            assertFalse(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenNoMethodsCalledButAtLeastOneExpected_shouldReturnFalse():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            mockInComposition.expects("doSomething").times(1);
            assertFalse(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenExpectedCallsEqualActualCalls_shouldReturnTrue():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            mockInComposition.expects("doSomething").times(1);
            mockInComposition.doSomething();
            assertTrue(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenExpectedCallsWithExpectedArgsEqualActualCallsWithActualArgs_shouldReturnTrue():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var someStringArg:String = "someStringArg";
            mockInComposition.expects("doSomethingElse").times(1).withArg(someStringArg);
            mockInComposition.doSomethingElse(someStringArg);
            assertTrue(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenExpectedArgDoesNotEqualActualArg_shouldReturnFalse():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var someStringArg:String = "someStringArg";
            mockInComposition.expects("doSomethingElse").times(1).withArg("someOtherStringArg");
            mockInComposition.doSomethingElse(someStringArg);
            assertFalse(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenExpected2ndArgDoesNotEqualActual2ndArg_shouldReturnFalse():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var someStringArg:String = "someStringArg";
            var someUnexpectedStringArg:String = "someUnexpectedStringArg";
            var someXMLArg:XML = <TEST>test</TEST>;
            var someUnexpectedXMLArg:XML = <UNEXPECTED/>;
            mockInComposition.expects("doSomethingWith2Args").times(1).withArgs(someStringArg, someXMLArg);
            mockInComposition.doSomethingWith2Args(someUnexpectedStringArg, someUnexpectedXMLArg);
            assertFalse(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        
        public function testWillReturn_shouldReturnValueDefinedByTest():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var someNodeName:String = "someNodeName";
            var expectedXMLReturnValue:XML = <TEST>test</TEST>;
            mockInComposition.expects("doSomethingAndReturnXML").withArg(someNodeName).willReturn(expectedXMLReturnValue);
            var actualXMLReturned:XML = mockInComposition.doSomethingAndReturnXML(someNodeName);
            assertEquals("Expecting "+expectedXMLReturnValue+" but was: "+actualXMLReturned, expectedXMLReturnValue, actualXMLReturned);
        }
        
        public function testWillReturn_shouldReturnTheObjectForTheMethodWithTheExpectedArgs():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var firstNodeName:String = "firstNodeName";
            var secondNodeName:String = "secondNodeName";
            var expectedXMLForFirstNodeName:XML = <TEST>firstNodeName</TEST>;
            var expectedXMLForSecondNodeName:XML = <TEST>secondNodeName</TEST>
            mockInComposition.expects("doSomethingAndReturnXML").withArg(firstNodeName).willReturn(expectedXMLForFirstNodeName);
            mockInComposition.expects("doSomethingAndReturnXML").withArg(secondNodeName).willReturn(expectedXMLForSecondNodeName);
            var actualXMLReturnedForFirstNodeName:XML = mockInComposition.doSomethingAndReturnXML(firstNodeName);
            var actualXMLReturnedForSecondNodeName:XML = mockInComposition.doSomethingAndReturnXML(secondNodeName);
            assertEquals("", expectedXMLForFirstNodeName, actualXMLReturnedForFirstNodeName);
            assertEquals("", expectedXMLForSecondNodeName, actualXMLReturnedForSecondNodeName);
        }
        
        public function testWillThrow_shouldThrowErrorObjectDefinedByTest():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var someNodeName:String = "someNodeName";
            var expectedMessage:String = "Mock message thrown.";
            mockInComposition.expects("doSomething").willThrow(new Error(expectedMessage));
            try
            {
                mockInComposition.doSomething();
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
            var mockInComposition:MockInComposition = new MockInComposition();
            var firstArgValue:String = "firstArgValue";
            var secondArgValue:String = "secondArgValue";
            mockInComposition.expects("doSomethingElse").times(1).withArg(firstArgValue);
            mockInComposition.expects("doSomethingElse").times(1).withArg(secondArgValue);
            mockInComposition.doSomethingElse(firstArgValue);
            mockInComposition.doSomethingElse("someUnexpectedArg");
            assertFalse("mockInComposition.success() should fail because the second time we called the method we passed an unexpected arg", mockInComposition.success());
        }
        
        public function testSuccess_whenMethodCalledTwiceWithSameExpectedArg_shouldReturnTrue():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var firstArgValue:String = "firstArgValue";
            var secondArgValue:String = "secondArgValue";
            mockInComposition.expects("doSomethingElse").times(2).withArg(firstArgValue);
            mockInComposition.doSomethingElse(firstArgValue);
            mockInComposition.doSomethingElse(firstArgValue);
            assertTrue(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenMethodNameCalledIsDifferentThanMethodNameExpected_shouldReturnFalse():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            mockInComposition.expects("doSomething").times(1);
            mockInComposition.anotherMethodWithNoArgs();
            assertFalse(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenMethodNameCalledWithSameArgsButDifferentNameAsMethodExpected_shouldReturnFalse():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var someStringArg:String = "someStringArg";
            mockInComposition.expects("doSomethingElse").times(1).withArg(someStringArg);
            mockInComposition.doSomethingAndReturnXML("someStringArg");
            assertFalse(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenLessArgsArePassedThanExpected_shouldReturnFalse():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            var someStringArg:String = "someStringArg";
            mockInComposition.expects("doSomethingAndReturnXML").times(1);
            mockInComposition.doSomethingAndReturnXML("someStringArg");
            assertFalse(mockInComposition.errorMessage(), mockInComposition.success());
        }
        
        public function testSuccess_whenErrorExpectedAndMethodsCalledAsExpected_shouldReturnTrue():void
        {
            var mockInComposition:MockInComposition = new MockInComposition();
            mockInComposition.expects("doSomething").times(1).willThrow(new Error("customError"));
            try
            {
                mockInComposition.doSomething();
                fail("expecting error but none was thrown");
            } 
            catch (e:Error)
            {
                assertTrue(mockInComposition.errorMessage(), mockInComposition.success());
            }
        }
        
    }
}