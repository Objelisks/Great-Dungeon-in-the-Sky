package 
{ 
	import flash.display.LoaderInfo;
	import org.flixel.data.FlxFactory; 
	
	public class Preloader extends FlxFactory { 
		
		public function Preloader():void 
		{
			
			className = "Main";
			//myURL = "rocketninjagames.com/skydungeon";
			super();
		}
	}
}