package org.mock4as
{
	public class Mock  
	{
		public function Mock(){
		}  
		
		private var testFailed:Boolean = false;
		private var reason:String;
		private var expectedMethods:Array = new Array();
		// currentMethod is the method used while setting up the expectations
		// currentMethod changes every time we call expects(methodName)
		private var currentMethod:MethodInvocation;
		private var currentReturnValue:Object;
		private var currentException:Object;
		private var hasBeenVerified:Boolean = false;
		
		
		
		
		public function expects(methodName:String):Mock
		{
			currentMethod = new MethodInvocation(methodName)
			expectedMethods.push(currentMethod);
			return this;
		}

		public function times(timesInvoked:uint):Mock
		{
			// If we don't expect the method to be called,
			// remove it from the expected methods array
			if (timesInvoked==0) expectedMethods.pop();
			currentMethod.timesInvoked = timesInvoked;
			return this;
		}
		
		public function withArgs(...args):Mock
		{
			currentMethod.args = args;
			return this;
		}
		
		public function withArg(arg:Object):Mock
		{
			currentMethod.args[0] = arg;
			return this;
		}
		
		public function noArgs():Mock
		{
			return this;
		}

		public function willReturn(returnValue:Object):void
		{
			currentMethod.returnValue = returnValue;
		}
		
		public function willThrow(exception:Object):void
		{
			currentMethod.exception = exception;
		}
		
		public function noReturn():void
		{
		}

		public function record(methodName:String, ...args):void
		{
			var newMethodEvocation:MethodInvocation = new MethodInvocation(methodName);
			newMethodEvocation.args = args;
			var index:int = getMethodIndex(newMethodEvocation);
			if (index != -1)
			{
				newMethodEvocation = expectedMethods[index];
				currentReturnValue = newMethodEvocation.returnValue;
				removeMethodCallFromExpectedList(index);
				if (newMethodEvocation.exception!=null) throw (newMethodEvocation.exception);
			} else {
				reason = "Was not expecting "+newMethodEvocation.name+"("+newMethodEvocation.args+") to be called.";
				testFailed = true;
			}
		}

		public function expectedReturnFor(methodName:String="Depricated"):Object
		{
			return currentReturnValue;			
		}	
		
		
		private function removeMethodCallFromExpectedList(index:uint):void
		{
			if (expectedMethods[index].timesInvoked>1)
			{
				expectedMethods[index].timesInvoked--;
			} else {
				expectedMethods.splice(index, 1);
			}
		}
		
		private function getMethodIndex(methodToFind:MethodInvocation):int
		{
			for (var i:uint =0; i<=expectedMethods.length-1; i++)
			{
				if (methodsAreEqual(expectedMethods[i], methodToFind)) return i;
			}
			return -1;
		}
		

		// verify all method expectations for this mock
		public function verify():void
		{	
			// Don't verify more than once to minimize processing
			if (hasBeenVerified) return;
			hasBeenVerified = true;
			if (expectedMethods.length>0)
			{
				testFailed=true;
				reason = getExpectedMethodCallNames(); 
				return;
			}
		}
		
		private function getExpectedMethodCallNames():String
		{
			var methodNamesString:String = "The following methods were expected but not called: \n";
			
			for (var i:uint=0; i<=expectedMethods.length-1; i++)
			{
				methodNamesString+=expectedMethods[i].name+"("+expectedMethods[i].args+") \n";
			}
			return methodNamesString;
		}

		private function methodsAreEqual(expected:MethodInvocation, actual:MethodInvocation):Boolean
		{
			if (expected.name != actual.name) return false;
			if (expected.args.length!=actual.args.length)
			{
				reason = "Number of expected args does not equal number of actual args. Expected "+expected+" but was "+actual;
				return false;
			}
			for (var i:uint=0; i<=expected.args.length-1; i++)
			{
				if (expected.args[i] != actual.args[i]) 
				{
					reason = "Expected "+expected.name+"("+expected.args+") but was "+actual.name+"("+actual.args+")";
					return false;
				}
			}
			return true;
		}
		
		public function success():Boolean
		{
			verify();
			return !testFailed;
		}

		public function hasError():Boolean
		{
			return !testFailed;
		}
		public function errorMessage():String
		{
			verify();
			return reason;
		}
		
	}
}

class MethodInvocation 
{
   public function MethodInvocation(methodName : String)
   {
         name = methodName;
   }	
   
	public var name:String;
	public var timesInvoked:int = 1;
	public var args:Array = new Array();
	public var returnValue:Object;
	public var exception:Object;
	
	public function toString():String
	{
		return name+"("+args+")";
	}
	
}
    
