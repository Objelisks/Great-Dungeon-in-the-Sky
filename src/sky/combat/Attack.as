package sky.combat
{
	import flash.display.BitmapData;
	import org.flixel.*;
	
	public class Attack
	{
		public var name:String;
		public var img:BitmapData;
		public var attack:Function;
		
		public function Attack(Name:String, Img:BitmapData, Func:Function)
		{
			name = Name;
			img = Img;
			attack = Func;
		}
	}
}