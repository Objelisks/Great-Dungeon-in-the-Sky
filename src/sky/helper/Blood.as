package sky.helper
{
	import org.flixel.*;
	import sky.char.Character;
	import sky.helper.*;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Blood extends FlxSprite
	{		
		public static var strengths:Array =
		[
		[0,1,2,3,4],
		[13,14,15,16,17,18],
		[26,27,28,29,30,31,32],
		[39,40,41,42,43,44],
		[52,53,54,55,56,57,58,59,60,61],
		[64,65,66,67,68,69,70,71,72,73,74,75,76],
		[77,78,79,80,81,82,83,84,85,86,87,88]
		];
		public var parent:Character;
		
		public function Blood(X:uint, Y:uint, Parent:Character, Color:uint=0xffff0000, Strength:uint=1) : void
		{
			super(X, Y);
			loadGraphic(Assets.AttackBlood, true, false, 40, 40);
			color = Color;
			parent = Parent;
			scale.x = scale.y = 2 / 5;
			offset.x = offset.y = 16;
			angle = Math.random() * 360;
			addAnimation("spurt", strengths[Strength], 10, false);
			play("spurt", true);
		}
		
		public override function update():void
		{
			if (finished)
			{
				this.kill();
			}
			else
			{
				x += parent.x - parent.last.x;
				y += parent.y - parent.last.y;
				super.update();
			}
		}
	}
}