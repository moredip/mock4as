package org.mock4as.samples.publisher
{
	public class Publisher
	{
    	private var subscriber:ISubscriber;

    	public function add(subscriber:ISubscriber) {
	        this.subscriber = subscriber;
	    }
 
	    public function publish(message:String) {
        	this.subscriber.receive(message);
    	}		
	}
}