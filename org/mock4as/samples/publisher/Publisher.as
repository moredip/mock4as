package org.mock4as.samples.publisher
{
	public class Publisher
	{
    	private var subscriber:ISubscriber;

    	public function add(subscriber:ISubscriber):void {
	        this.subscriber = subscriber;
	    }
 
	    public function publish(message:String):void {
        	this.subscriber.receive(message);
    	}		
	}
}