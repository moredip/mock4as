package org.mock4as.samples.mockInComposition
{
	import org.mock4as.Mock;
	import org.mock4as.samples.ISomeInterface;
	
	public class MockInComposition extends ClassWeWantToSubclass implements ISomeInterface
	{
		private var mock:Mock;
		
		public function MockInComposition()
		{
			super();
			mock = new Mock();
		}
		
		override public function someMethod(inSomeStringArg:String):void
		{
			mock.record("someMethod", inSomeStringArg);
			super.someMethod(inSomeStringArg);
		}
		
		public function doSomething():void
		{
		    mock.record("doSomething");
		}
        public function anotherMethodWithNoArgs():void
        {
            mock.record("anotherMethodWithNoArgs");
        }
        public function doSomethingElse(someStringArg:String):void
        {
             mock.record("doSomethingElse", someStringArg);
        }
        
        public function doSomethingWith2Args(firstArg:String, secondArg:XML):void
        {
            mock.record("doSomethingWith2Args", firstArg, secondArg);
        }
        public function doSomethingAndReturnXML(inNodeName:String):XML
        {
            mock.record("doSomethingAndReturnXML", inNodeName);
            return mock.expectedReturnFor() as XML;
        }
		
		
		/*
		* If you want to use mock in composition, you will need to support the mock methods below
		*/
		public function expects(methodName:String):Mock
		{
			return mock.expects(methodName);
		}
		public function times(timesInvoked:int):Mock
		{
			return mock.times(timesInvoked);
		}
		public function verify():void
		{
			mock.verify();
		}
		public function success():Boolean
		{
			return mock.success();
		}
		public function errorMessage():String
		{
			return mock.errorMessage(); 
		}
		
	}
}