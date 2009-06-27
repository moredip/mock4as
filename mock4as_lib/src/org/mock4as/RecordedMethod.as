package org.mock4as
{
	
	internal class RecordedMethod
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

}