package org.mock4as.samples.mockInComposition
{
	import org.mock4as.Mock;
	
	public class MockInComposition extends ClassWeWantToSubclass
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