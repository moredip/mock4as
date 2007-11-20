package org.mock4as
{
	public class Mock  
	{
		public function Mock(){
		}  
		
		// hash table of methodName -> MethodInvocation obj
		private var actualMethodInvocations:Object = new Object();
		private var methodInvoked:Array = new Array();
		// hash table of methodName -> MethodInvocation obj
		private var expectedMethodInvocations:Object = new Object();
		private var methodInProgress:String;
		
		private var testFailed:Boolean = false;
		private var reason:String;

		public function expects(methodName:String):Mock
		{
			this.methodInProgress = methodName;
			this.expectedMethodInvocations[methodName] = new MethodInvocation(methodName); 
			return this;
		}

		public function times(timesInvoked:int):Mock
		{
			expectedMethodInvocationFor(methodInProgress).timesInvoked = timesInvoked;
			return this;
		}
		
		private function expectedMethodInvocationFor(methodName:String):MethodInvocation
		{
			return this.expectedMethodInvocations[methodName];
		}

		private function actualMethodInvocationFor(methodName:String):MethodInvocation
		{
			return this.actualMethodInvocations[methodName];
		}
		
		public function noArgs():Mock
		{
			return this;
		}

		public function withArgs(...args):Mock
		{
			expectedMethodInvocationFor(methodInProgress).args = args; 			
			return this;
		}

		public function withArg(arg:Object):Mock
		{
			expectedMethodInvocationFor(methodInProgress).args[0] = arg; 			
			return this;
		}

		public function willReturn(returnValue:Object)
		{
			expectedMethodInvocationFor(methodInProgress).returnValue = returnValue; 			
		}
		
		public function willThrow(exception:Object)
		{
			expectedMethodInvocationFor(methodInProgress).exception = exception; 			
		}
		
		public function noReturn()
		{
		}

		private function returnValueFor(methodName:String):Object
		{
			if(expectedMethodInvocationFor(methodName)!=null){
				return expectedMethodInvocationFor(methodName).returnValue;
			}
			return "No Return Defined for " + methodName;
		}

		private function exceptionFor(methodName:String):Object
		{
			if(expectedMethodInvocationFor(methodName)!=null){
				return expectedMethodInvocationFor(methodName).exception;
			}
			return "No Exception for " + methodName;
		}

		private function verifyMethodIsExpected(methodName:String)
		{
			if (!this.methodIsExpected(methodName)){
				reason = "Unexpected method call - " + methodName + "(...)";
				testFailed = true;
			}
		}
		
		private function methodIsExpected(methodName:String):Boolean{
			return (this.expectedMethodInvocationFor(methodName)!=null);
		} 

		private function verifyTimesInvoked(methodName:String)
		{
			if (!this.testFailed){
				var expectedTimeInvoked:int = this.expectedMethodInvocationFor(methodName).timesInvoked;
				var actualTimeInvoked:int = this.actualMethodInvocationFor(methodName).timesInvoked;
				
				if (actualTimeInvoked != expectedTimeInvoked){
					reason = "Unexpected method call. Expected " + methodName + "(...) to be invoked " + expectedTimeInvoked + " time(s), but it was invoked " + actualTimeInvoked + " time(s)." ;
					testFailed = true;
				}			
			}
		}	
		
		protected function expectedReturnFor(methodName:String):Object{
			return this.returnValueFor(methodName);			
		}	

		protected function expectedExceptionFor(methodName:String):Object{
			return this.exceptionFor(methodName);			
		}	

		private function methodHasBeenInvoked(methodName:String):Boolean{
			return (this.actualMethodInvocationFor(methodName) != null);
		} 
		
		protected function record(methodName:String, ...args){
			this.methodInvoked.push(methodName);
			if (this.methodHasBeenInvoked(methodName)){
				this.actualMethodInvocationFor(methodName).timesInvoked++;
			}else{
				var methodInvoked:MethodInvocation = new MethodInvocation(methodName)
				methodInvoked.args = args;
				this.actualMethodInvocations[methodName] = methodInvoked;
			}
			
		}
		private function verifyArgList(methodName:String, args:Array){
			if (!this.testFailed){
				var argsReceived:String = args.toString();
				var methInv:MethodInvocation;
				methInv = this.expectedMethodInvocationFor(methodName);
				var argsExpected:String = methInv.args.toString();
			
				if (argsReceived != argsExpected){
					reason = "Unexpected argument value. Expected " + methodName + "("+argsExpected+"), but " + methodName + "("+argsReceived+") was invoked instead.";
					testFailed = true;
				}
				
			}

		}
		
		// verify all method expectations for this mock
		public function verify(){
			var methodInvokation:MethodInvocation;
			for (var i:int=0; i<this.methodInvoked.length; i++){
				methodInvokation = this.actualMethodInvocationFor(this.methodInvoked.valueOf(i));
				this.verifyMethodIsExpected(this.methodInvoked[i]);
				if (methodInvokation!= null){
					this.verifyTimesInvoked(methodInvokation.name);
					this.verifyArgList(methodInvokation.name, methodInvokation.args);
				}
			}
		}
		
		public function success():Boolean{
			this.verify();
			return !this.testFailed;
		}

		public function hasError():Boolean{
			return !this.testFailed;
		}
		public function errorMessage():String{
			return this.reason;
		}
		
	}
}

class MethodInvocation {
   function MethodInvocation(methodName : String){
         this.name = methodName;
   }	
	var name:String;
	var timesInvoked:int=1;
	var args:Array = new Array();
	var returnValue:Object;
	var exception:Object;
	
}
    
