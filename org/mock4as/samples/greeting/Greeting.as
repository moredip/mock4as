package org.mock4as.samples.greeting
{
	public class Greeting
	{
		private var translator:ITranslator;
		public function Greeting(translator:ITranslator){
			this.translator = translator;
		}  
		
		public function sayHello(language:String, name:String):String{
			return translator.translate("English", language, "Hello") + " " + name;
		}
	}
}