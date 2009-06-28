package org.mock4as.samples
{
	import org.mock4as.Mock;
	
	public class MockSomeInterface extends Mock implements ISomeInterface
	{
		public function MockSomeInterface()
		{
			super();
		}
		
		public function doSomething():void
		{
			record("doSomething");
		}
		
		public function doSomethingElse(someStringArg:String):void
		{
			record("doSomethingElse", someStringArg);
		}
		
		public function doSomethingWith2Args(firstArg:String, secondArg:XML):void
		{
			record("doSomethingWith2Args", firstArg, secondArg);
		}
		
		public function doSomethingAndReturnXML(inNodeName:String):XML
		{
			record("doSomethingAndReturnXML", inNodeName);
			return expectedReturnFor("doSomethingAndReturnXML") as XML;
		}
		
		public function anotherMethodWithNoArgs():void
		{
			record("anotherMethodWithNoArgs");
		}
		
		public function methodWithNoArgsWhichReturnsString():String
		{
			record("methodWithNoArgsWhichReturnsString");
			return expectedReturnFor() as String;
		}
		public function methodWithOneArgWhichReturnsString(firstArg:String):String
		{
			record("methodWithOneArgWhichReturnsString", firstArg );
			return expectedReturnFor() as String;	
		}
		
		public function methodWithOneArrayArg(array:Array):void
		{
			record("methodWithOneArrayArg",array);
		}
		
	}
}