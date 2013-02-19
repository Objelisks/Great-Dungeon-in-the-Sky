package sky.combat
{
	import org.flixel.*;
	import sky.char.*;
	import sky.helper.*;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class Magic extends FlxSprite
	{		
		private var particles:FlxEmitter;
		private var lived:Number;
		public var life:Number;
		public var onCollideSprite:Function;
		public var onCollideTile:Function;
		public var onFinish:Function;
		public var parent:Character;
		
		public function Magic(Colors:Array, Parent:Character, Size:uint=3, Life:Number=3, offx:int=0, offy:int=0) : void
		{
			super(0, 0);
			parent = Parent;
			x = parent.x + parent.width*parent.facing + offx*(parent.facing*2-1);
			y = parent.y + parent.height/2 + offy;
			this.velocity.x += parent.velocity.x/2;
			this.velocity.y += parent.velocity.y/2;
			lived = 0;
			life = Life;
			width = height = 1;
			particles = new FlxEmitter(x, y, 0.01);
			particles.setXVelocity( -8*Size, 8*Size);
			particles.setYVelocity( -8*Size, 8*Size);
			particles.width = particles.height = Size;
			particles.drag = 60;
			var sprites:Array = new Array();
			var fade:BitmapData = new BitmapData(6, 1, false, 0xff000000);
			var a:uint = 0;
			var argb:Object = Helper.getARGB(uint(FlxG.getRandom(Colors)));
			for (a = 0; a < 6; a++)
			{
				fade.setPixel(a, 0, Helper.getHex(argb.a, argb.r / (a + 1), argb.g / (a + 1), argb.b / (a + 1)));
			}
			for (var i:uint = 0; i < 30; i++)
			{
				if (i > 0 && Colors.length > 1)
				{
					fade = new BitmapData(6, 1, false, 0xff000000);
					argb = Helper.getARGB(uint(FlxG.getRandom(Colors)));
					for (a = 0; a < 6; a++)
					{
						fade.setPixel(a, 0, Helper.getHex(argb.a, argb.r / (a + 1), argb.g / (a + 1), argb.b / (a + 1)));
					}
				}
				var sprite:FlxSprite = new FlxSprite();
				sprite.loadBitmap(fade, true, false, 1, 1);
				sprite.addAnimation("fade", [0, 1, 2, 3, 4, 5], 20, false);
				sprite.play("fade");
				FlxG.state.add(sprite);
				sprites.push(sprite);
			}
			particles.loadSprites(sprites);
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean { velocity.x = -velocity.x * 0.8; return true; }
		
		override public function hitFloor(Contact:FlxCore=null):Boolean { velocity.y = -velocity.y * 0.8; return true; }
		
		override public function hitCeiling(Contact:FlxCore = null):Boolean { velocity.y = -velocity.y * 0.8; return true; }
		
		override public function collide(Core:FlxCore):Boolean 
		{
			if (dead) return false;
			var hit:Boolean = Core.overlaps(this);
			if (hit)
			{
				if (onCollideSprite != null && Core is FlxSprite)
				{
					onCollideSprite.call(this, Core);
					return false;
				}
				if (onCollideTile != null && Core is FlxBlock)
				{
					onCollideTile.call(this, Core);
					return false;
				}
			}
			return hit;
		}
		
		override public function render():void 
		{
			particles.render();
			//super.render();
		}
		
		override public function kill():void 
		{
			super.kill();
			particles.kill();
			if (onFinish != null)
			{
				onFinish.call(this);
			}
		}
		
		public override function update():void
		{
			particles.width = this.width;
			particles.height = this.height;
			lived += FlxG.elapsed;
			if (lived > life && !dead)
			{
				this.kill();
			}
			else
			{
				particles.update();
				particles.x = x-particles.width/2;
				particles.y = y-particles.width/2;
				super.update();
			}
		}
	}
}