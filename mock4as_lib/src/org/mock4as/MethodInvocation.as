package org.mock4as
{
	internal class MethodInvocation 
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
}