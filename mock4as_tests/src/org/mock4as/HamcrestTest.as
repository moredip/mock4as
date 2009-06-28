package org.mock4as
{
	import flexunit.framework.TestCase;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.*;
	import org.hamcrest.core.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.containsString;
	import org.mock4as.samples.MockSomeInterface;

	public class HamcrestTest extends TestCase
	{
		private var mock:MockSomeInterface;
		
		public function HamcrestTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			mock = new MockSomeInterface();
		}
		
		public function testEqualToMatcherWithSingleArgumentShouldSucceed():void
		{
			mock.expects('doSomethingElse').withArgs( equalTo('expected string') );
			
			mock.doSomethingElse('expected string');
			
			assertMockSucceeded();
		}

		public function testEqualToMatcherWithSingleArgumentShouldFail():void
		{
			mock.expects('doSomethingElse').withArgs( equalTo('expected string') );
			
			mock.doSomethingElse('not the expected string');
			
			assertMockFailed();
		}		
		
		public function testAnythingMatcherWithSingleArgument():void
		{
			mock.expects('doSomethingElse').withArgs( anything() );
			
			mock.doSomethingElse('any string will pass');
			
			assertMockSucceeded();			
		}

		public function testAnythingMatcherAndEqualToMatcherShouldSucceedIfEqualToExpectationIsMet():void
		{
			mock.expects('doSomethingWith2Args').withArgs( equalTo('expected string'),anything() );
			
			mock.doSomethingWith2Args( 'expected string', <anything here="will">work</anything> );
			
			assertMockSucceeded();			
		}

		public function testAnythingMatcherAndEqualToMatcherShouldFailIfEqualToExpectationIsNotMet():void
		{
			mock.expects('doSomethingWith2Args').withArgs( equalTo('expected string'),anything() );
			
			mock.doSomethingWith2Args( 'not the expected string', <anything here="will">work</anything> );
			
			assertMockFailed();		
		}
		
		public function testAnyOfMatcherSucceedsIfOneSubmatcherMatches():void
		{
			mock.expects('doSomethingElse').withArgs( anyOf(equalTo('some allowed string'),equalTo('another allowed string')) );
			
			mock.doSomethingElse('another allowed string');
			
			assertMockSucceeded();		
		}

		public function testAnyOfMatcherFailsIfNeitherSubmatcherMatches():void
		{
			mock.expects('doSomethingElse').withArgs( anyOf(equalTo('some allowed string'),equalTo('another allowed string')) );
			
			mock.doSomethingElse('string which does not match either expected strings');
			
			assertMockFailed();
		}
		
		public function testAnyOfMatcherDescribesItselfNicelyUponFailure():void
		{
			mock.expects('doSomethingElse').withArgs( anyOf(equalTo('some allowed string'),equalTo('another allowed string')) );
			mock.doSomethingElse('unexpected string' );
			
			assertThat( mock.errorMessage(), containsString( 'doSomethingElse(("some allowed string" or "another allowed string"))' ) );
		}
		
		
		
		
		private function assertMockSucceeded():void
		{
			assertTrue(mock.errorMessage(), mock.success());	
		}

		private function assertMockFailed():void
		{
			assertFalse("mock reported success, expected failure", mock.success());
		}
	}
}