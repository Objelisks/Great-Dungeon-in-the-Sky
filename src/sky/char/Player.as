package sky.char
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.flixel.*;

	public class Player extends Character
	{
		public var controllable:Boolean;
		public var blinding:Boolean;
		
		public function Player(id:uint) : void
		{
			super(id);
			controllable = true;
			health += 50;
			maxHealth += 50;
			blinding = false;
		}
		
		public override function update():void
		{
			if ((statuses & 0x00010000) == 0x00010000)
			{
				FlxG.fade(0xdd111111, 0.7);
				blinding = true;
			}
			if(blinding == true && ((statuses & 0x00010000) != 0x00010000))
			{
				FlxG.fade(0x00ffffff, 0.7, null, true);
				blinding = false;
			}
			
			if (!controllable)
			{
				super.update();
				return;
			}
			
			if(FlxG.keys.LEFT)
            {
				moveLeft(100);
            }
            else if (FlxG.keys.RIGHT)
            {
				moveRight(100);
			}
			if (FlxG.keys.justPressed("UP"))
			{
				jump();
			}
			
			if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("Y"))
			{
				attack1();
			}
			if (FlxG.keys.justPressed("X"))
			{
				attack2();
			}
			if (FlxG.keys.justPressed("C"))
			{
				attack3();
			}
			
			super.update();
		}
	}
}