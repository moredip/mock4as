package org.mock4as
{
	public class Mock  
	{
		public function Mock(){
		}  
		
		private var testFailed:Boolean = false;
		private var reason:String;
		private var _isLiberal:Boolean = false;
		private var expectedMethods:Array = new Array();
		// currentMethod is the method used while setting up the expectations
		// currentMethod changes every time we call expects(methodName)
		private var currentMethod:MethodInvocation;
		private var currentReturnValue:Object;
		private var currentException:Object;
		private var hasBeenVerified:Boolean = false;
		
		
		public function isLiberal():Mock
		{
			_isLiberal = true;
			return this;
		}
		
		
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
		
		public function withAnyArgs():Mock
		{
			currentMethod.expectAnyArgs();
			return this;
		}
		
		public function noArgs():Mock
		{
			return this;
		}
		
		public function willExecute(closure:Function):void
		{
			currentMethod.closure = closure;
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
			var recordedMethod:RecordedMethod = new RecordedMethod(methodName,args);

			var index:int = lookupRecordedMethodInExpectedMethods(recordedMethod);
			if (index != -1)
			{
				var expectedMethod:MethodInvocation = expectedMethods[index];
				removeMethodCallFromExpectedList(index);
				currentReturnValue = expectedMethod.simulateMethod( args );
				return;
			} 
			
			if( _isLiberal ){
				currentReturnValue = null;
			} else {
				reason = "Was not expecting "+recordedMethod+" to be called.";
				testFailed = true;
			}
		}

		protected function expectedReturnFor(methodName:String="Depricated"):Object
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
		
		private function lookupRecordedMethodInExpectedMethods(recordedMethod:RecordedMethod):int
		{
			for (var i:uint =0; i<=expectedMethods.length-1; i++)
			{
				var matchOutcome:Object = (expectedMethods[i] as MethodInvocation).matchesRecordedMethod(recordedMethod);
				if( matchOutcome.matched )
				{
					reason = matchOutcome.description;
					return i;
				}
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
	import org.mock4as.Mock;
	

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
	
	public var closure:Function = null;
	
	public function expectAnyArgs():void{
		args = null;
	}
	public function get expectsAnyArgs():Boolean {
		return null == args;
	}
	
	public function matchesRecordedMethod( recordedMethod:RecordedMethod ):Object
	{	
		if (name != recordedMethod.name)
			return { description: null, matched: false }
		
		if (this.expectsAnyArgs)
			return { description: null, matched: true }

		
		if (args.length!=recordedMethod.args.length)
		{
			return{
				description: "Number of expected args does not equal number of actual args. Expected "+this+" but was "+recordedMethod,
				matched: false
			};
		}
		for (var i:uint=0; i<=recordedMethod.args.length-1; i++)
		{
			if (args[i] != recordedMethod.args[i]) 
			{
				return{
					description: "Expected "+this+" but was "+recordedMethod,
					matched: false
				};
			}
		}

		return { description: null, matched: true }
	}
	
	public function simulateMethod( args:Array ):Object {
		if( null != closure )
			return closure.apply(null,args);
		else if( null != exception )
			throw exception;
		else
			return returnValue;
	}
	
	public function toString():String
	{
		return name+"("+args+")";
	}	
}

class RecordedMethod
{
	public function RecordedMethod( methodName : String, methodArgs : Array )
	{
		name = methodName;
		args = methodArgs;
	}
	
	public function toString():String
	{
		return name+"("+args+")";
	}	
	
	public var name:String;
	public var args:Array;
}
    
