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
				methodNamesString+=expectedMethods[i].toString()+" \n";
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
	
    
