package sky.helper
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;

	public class Notify extends FlxSprite
	{		
		private var lived:Number;
		public var life:Number;
		public var text:FlxText;
		
		public function Notify(Text:String) : void
		{
			var wit:uint = Text.length * 5 + 16;
			super(FlxG.width-wit-5, 5);
			var note:BitmapData = FlxG.addBitmap(Assets.ImgNotify);
			var img:BitmapData = new BitmapData(wit, 16, true, 0x00000000);
			var d:uint = 13;
			var w:uint = 1;
			img.copyPixels(note, new Rectangle(0, 0, 16, 16), new Point(0, 0));
			while (d <= Text.length * 5 + 16)
			{
				img.copyPixels(img, new Rectangle(3, 0, 10*w, 16), new Point(d, 0));
				d += 10;
				w = 2^w;
			}
			img.copyPixels(note, new Rectangle(13, 0, 3, 16), new Point(img.width-3, 0));
			loadBitmap(img, false, false, wit, 16);
			text = new FlxText(x+1, y+1, wit-2, Text);
			text.alignment = "center";
			text.antialiasing = false;
			this.scrollFactor = new Point();
			text.scrollFactor = new Point();
			lived = 0;
			life = Text.length / 10 + 3;
		}
		
		override public function render():void 
		{
			super.render();
			text.render();
		}
		
		public override function update():void
		{
			lived += FlxG.elapsed;
			if (lived > life)
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