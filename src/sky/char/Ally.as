package sky.char
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.flixel.*;

	public class Ally extends Character
	{
		public var ai:Function;
		public var target:Character;
		public var action:String;
		public var actiont:int;
		
		public function Ally(id:uint) : void
		{
			super(id);
		}
	}
}