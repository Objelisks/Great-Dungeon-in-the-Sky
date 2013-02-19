package sky.combat
{
	import org.flixel.*;
	import sky.char.*;
	import sky.helper.*;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class Projectile extends FlxSprite
	{		
		public var parent:Character;
		public var lived:Number;
		public var life:Number;
		public var stopped:Boolean;
		public var damage:uint;
		public var dmgtype:String;
		
		public function Projectile(Type:String, Parent:Character, Gravity:uint=150, offx:int=0, offy:int=0) : void
		{
			dmgtype = "fgsfds";
			var graphic:Class = null;
			switch(Type)
			{
				case "bolt":
					graphic = Assets.AttackBolt;
					damage = 5;
					break;
				case "knife":
					graphic = Assets.AttackKnife;
					damage = 10;
					break;
				case "bread":
					graphic = Assets.AttackBread;
					damage = 1;
					break;
				case "present":
					graphic = Assets.AttackPresent;
					damage = 1;
					dmgtype = "present";
					break;
				case "net":
					graphic = Assets.AttackNet;
					damage = 0;
					break;
				case "arrow":
				default:
					graphic = Assets.AttackArrow;
					damage = 5;
					break;
			}
			
			super(0, 0, graphic);
			if (Type == "bullet")
			{
				createGraphic(1, 1);
				damage = 10;
			}
			parent = Parent;
			lived = 0;
			life = 5;
			stopped = false;
			angle = Math.atan2(velocity.y, velocity.x) * 180 / (Math.PI);
			x = parent.x + parent.width*(parent.facing*2-1) + offx*(parent.facing*2-1);
			y = parent.y + offy;
			acceleration.y = Gravity;
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean { velocity = new Point(); acceleration = new Point(); lived = life-1; stopped = true; return true; }
		
		override public function hitFloor(Contact:FlxCore = null):Boolean { velocity = new Point(); acceleration = new Point(); lived = life-1; stopped = true; return true; }
		
		override public function hitCeiling(Contact:FlxCore = null):Boolean { velocity = new Point(); acceleration = new Point(); lived = life-1; stopped = true; return true; }
		
		override public function collide(Core:FlxCore):Boolean 
		{
			if (dead) return false;
			if (stopped)
				return false;
			var hit:Boolean = super.collide(Core);
			if (hit)
			{
				if (Core is Character)
				{
					(Core as Character).damage(damage, dmgtype);
					if (dmgtype == "net")
					{
						(Core as Character).velocity.x *= -1;
					}
				}
			}
			return hit;
		}
		
		public override function update():void
		{
			if (!stopped)
			{
				if (dmgtype == "present")
				{
					angle += 1;
				}
				else
				{
					angle = Math.atan2(velocity.y, velocity.x) * 180 / (Math.PI);
				}
			}
			lived += FlxG.elapsed;
			if (lived > life && !dead)
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