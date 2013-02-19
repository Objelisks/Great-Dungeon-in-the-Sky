package sky.helper
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;

	public class Effect extends FlxSprite
	{		
		private var lived:Number;
		public var life:Number;
		
		public function Effect(X:uint, Y:uint, W:uint, H:uint, Graphic:Class, Life:uint=3, Scale:Number=1, Color:uint=0xffffffff, Loop:Boolean=false) : void
		{
			super(X, Y);
			lived = 0;
			life = Life;
			loadGraphic(Graphic, true, false, H, H);
			color = Color;
			scale.x = scale.y = Scale;
			var frames:Array = new Array();
			for (var i:uint = 0; i < W / H; i++)
			{
				frames.push(i);
			}
			addAnimation("anim", frames, 10, Loop);
			play("anim");
		}
		
		public override function update():void
		{
			lived += FlxG.elapsed;
			if ((lived > life) || finished)
			{
				this.kill();
			}
			else
			{
				super.update();
			}
		}
	}
}