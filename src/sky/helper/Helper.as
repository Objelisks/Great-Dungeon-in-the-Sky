package sky.helper
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.flixel.*;

	public class Helper
	{
		public static function lighten(color:uint, ratio:Number):uint
		{
			var argb:Object = getARGB(color);
			return getHex(argb.a + (255 - argb.a) * ratio, argb.r + (255 - argb.r) * ratio, argb.g + (255 - argb.g) * ratio, argb.b + (255 - argb.b) * ratio);
		}

		public static function darken(color:uint, ratio:Number):uint
		{
			var argb:Object = getARGB(color);
			return (getHex(argb.a, argb.r*ratio, argb.g*ratio, argb.b*ratio));
		}

		public static function getHex(a:uint, r:uint, g:uint, b:uint):uint
		{
			return a << 24 | r << 16 | g << 8 | b;
		}

		public static function getARGB(color:uint):Object
		{
			var a:uint = color >> 24 & 0xFF;
			var r:uint = color >> 16 & 0xFF;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			return {a:a, r:r, g:g, b:b};
		}

		public static function blend(color1:uint, color2:uint, ratio:Number):uint
		{
			var argb1:Object = getARGB(color1);
			var argb2:Object = getARGB(color2);
			for (var ele:* in argb1)
			{
				argb1[ele] = argb1[ele] + (argb2[ele] - argb1[ele]) * ratio;
				if (argb1[ele] > 255) argb1[ele] = 255;
				if (argb1[ele] < 0) argb1[ele] = 0;
			}
			return getHex(argb1.a, argb1.r, argb1.g, argb1.b);
		}
		
		public static function map(num:Number, a:Number, b:Number, x:Number, y:Number):Number
		{
			return num / (b - a) * (y - x);
		}
		
		public static function Scale(sprite:FlxSprite, scale:Point) : FlxSprite
		{
			sprite.width *= scale.x / sprite.scale.x;
			sprite.height *= scale.y / sprite.scale.y;
			sprite.offset.x -= sprite.width / 2 ;
			sprite.offset.y -= sprite.width / 2 ;
			sprite.scale = scale;
			return sprite;
		}
		
		public static function Color(sprite:FlxSprite, color:uint) : FlxSprite
		{
			sprite.color = color;
			return sprite;
		}
		
		public static function GrabFromSheet(sheet:BitmapData, rectangle:Rectangle) : BitmapData
		{
			var sprite:BitmapData = new BitmapData(8, 8, true, 0x00000000);
			sprite.copyPixels(sheet, rectangle, new Point(0, 0));
			return sprite;
		}
		
		public static function GrabIconFromSheet(sheet:BitmapData, loc:Point, Width:uint=8) : BitmapData
		{
			var sprite:BitmapData = new BitmapData(8, 8, true, 0x00000000);
			sprite.copyPixels(sheet, new Rectangle(loc.x*Width, loc.y*Width, Width, Width), new Point(0, 0));
			return sprite;
		}
		
		public static var updates:Array = new Array();
		
		public static function After(time:Number, func:Function) : void
		{
			FlxG.log("Helper added: " + time + " " + func);
			updates.push({tick:time,f:func});
		}
		
		public static function Update() : void
		{
			for(var index:String in updates)
			{
				var update:Object = updates[index];
				if (update != null)
				{
					update.tick -= FlxG.elapsed;
					FlxG.log("Helper left: " + update.tick);
					if (update.tick <= 0)
					{
						FlxG.log("Helper called");
						update.f();
						updates.splice(index, 1);
						update = null;
					}
				}
			}
		}
	}
}