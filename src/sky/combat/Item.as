package sky.combat
{
	import org.flixel.*;
	import sky.char.*;
	
	public class Item extends FlxSprite
	{		
		public var parent:Character;
		public var updateFunction:Function;
		
		public function Item(Graphic:Class, Parent:Character) : void
		{
			super(0, 0, Graphic);
			parent = Parent;
			x = parent.x;
			y = parent.y;
		}
		
		override public function collide(Core:FlxCore):Boolean 
		{
			return (Core is FlxBlock)?super.collide(Core):false;
		}
		
		public override function update():void
		{
			super.update();
			if (updateFunction != null)
			{
				updateFunction();
			}
		}
	}
}