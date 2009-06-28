package org.mock4as
{
	import org.hamcrest.Matcher;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;
	
	internal class MethodInvocation 
	{
	   public function MethodInvocation(methodName : String)
	   {
	         name = methodName;
	   }	
	   
		public var name:String;
		public var timesInvoked:int = 1;
		private var expectedArgs:Array = new Array();
		public var returnValue:Object;
		public var exception:Object;
		
		public var closure:Function = null;
		
		public function expectAnyArgs():void{
			expectedArgs = null;
		}
		public function get expectsAnyArgs():Boolean {
			return null == expectedArgs;
		}
		
		public function specifyArgs(arguments:Array):void {
			
			expectedArgs = mapSpecifiedArgumentsIntoMatchers( arguments );
		}
		
		private function mapSpecifiedArgumentsIntoMatchers(arguments:Array):Array {
			return arguments.map(
				function(argument:Object, dummy:int, a:Array):Object {
			  		if( argument is Matcher )
			  			return argument;
		  			else if( null == argument )
		  				return nullValue();
	  				else 
	  					return equalTo(argument);
				});
		}
		
		public function matchesRecordedMethod( recordedMethod:RecordedMethod ):Object
		{	
			if (name != recordedMethod.name)
				return { description: null, matched: false }
			
			if (this.expectsAnyArgs)
				return { description: null, matched: true }
	
			
			if (expectedArgs.length!=recordedMethod.args.length)
			{
				return{
					description: "Number of expected args does not equal number of actual args. Expected "+this+" but was "+recordedMethod,
					matched: false
				};
			}
			
			for (var i:uint=0; i<=recordedMethod.args.length-1; i++)
			{
				var arg:Object = recordedMethod.args[i];
				var argExpectation:Matcher = (Matcher)(expectedArgs[i]);
				
				if( !argExpectation.matches( arg ) )
				{
					return{
						description: "Expected "+this+" but was "+recordedMethod,
						matched: false
					}
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
			return name+"("+expectedArgs+")";
		}	
	}
}