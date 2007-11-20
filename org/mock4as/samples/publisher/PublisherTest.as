package org.mock4as.samples.publisher
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
	import org.mock4as.Mock;

    public class PublisherTest extends TestCase
	{
		public function PublisherTest(methodName : String){
            super(methodName);
        }
            		
		public function testOneSubscriberReceivesAMessage():void{
			// create the mock
			var mockSubscriber:MockSubscriber = new MockSubscriber();
			const MSG:String = "MESSAGE";
			// set expectations
			mockSubscriber.expects("receive").times(1).withArg(MSG).noReturn();
			// inject the mock			
			var myPublisher:Publisher = new Publisher();
			myPublisher.add(mockSubscriber);
			// execute 
			myPublisher.publish(MSG);
			// verify mock behavior
			mockSubscriber.verify();
			// show mock expectation error message if any
			assertNull(mockSubscriber.errorMessage());
		}  			
	}
}

// Inner Class
import org.mock4as.Mock;
import org.mock4as.samples.publisher.ISubscriber;

class MockSubscriber extends Mock implements ISubscriber {
	public function receive(message:String)
	{
		record("receive", message);
	}
}
    
