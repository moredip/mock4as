package org.mock4as.samples
{
	public interface ISomeInterface
	{
		function doSomething():void;
		function anotherMethodWithNoArgs():void;
		function doSomethingElse(someStringArg:String):void;
		function doSomethingWith2Args(firstArg:String, secondArg:XML):void;
		function doSomethingAndReturnXML(inNodeName:String):XML;
		function methodWithNoArgsWhichReturnsString():String;
		function methodWithOneArgWhichReturnsString(firstArg:String):String;
		function methodWithOneArrayArg(array:Array):void;
	}
}