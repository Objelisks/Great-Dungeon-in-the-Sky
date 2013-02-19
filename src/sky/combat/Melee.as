package sky.combat
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import mx.accessibility.CheckBoxAccImpl;
	import org.flixel.*;
	import sky.char.*;

	public class Melee extends FlxSprite
	{		
		public var type:String;
		public var count:uint;
		public var times:uint;
		public var parent:FlxSprite;
		public var offx:Number;
		public var offy:Number;
		public var damage:uint;
		public var hitThings:Array;
		
		public function Melee(Type:String, Parent:FlxSprite, Damage:uint=0, Times:uint = 1) : void
		{
			super(Parent.x, Parent.y);
			count = 0;
			type = Type;
			times = Times;
			parent = Parent;
			offx = 0;
			offy = 0;
			hitThings = new Array();
			damage = Damage;
			switch(Type)
			{
				case "slash":
					loadGraphic(Assets.AttackSlash, true, true);
					addAnimation("slash", [0, 1, 2, 3, 4], 20, true);
					angle = Math.random()*5;
					addAnimationCallback(function(name:String, frame:uint, caf:uint):void { if (caf == 4) { count++; hitThings = new Array(); }} );
					play("slash");
					break;
				case "spin":
					loadGraphic(Assets.AttackSlash, true, false);
					addAnimation("spin", [0, 1, 2, 3, 4], 20, true);
					addAnimationCallback(function(name:String, frame:uint, caf:uint):void { if (caf == 4) { count++; hitThings = new Array(); }} );
					play("spin");
					break;
				case "stab":
					loadGraphic(Assets.AttackSlash, true, false);
					addAnimation("stab", [0, 1, 2, 3, 4], 20, true);
					angle = Math.random() * 10 - 140;
					addAnimationCallback(function(name:String, frame:uint, caf:uint):void { if (caf == 4) { count++; hitThings = new Array(); }} );
					play("stab");
					break;
				case "punch":
					loadGraphic(Assets.AttackSlash, true, false);
					addAnimation("punch", [0, 1, 1, 1, 1], 20, true);
					angle = -135;
					addAnimationCallback(function(name:String, frame:uint, caf:uint):void { if (this._curFrame == 4) { count++; hitThings = new Array(); offy += Math.floor(Math.random() * 8-5); offx += Math.floor(Math.random() * 8-4); }} );
					play("punch");
					break;
				default:
					break;
			}
			scale.x = scale.y = 0.8;
		}
		
		override public function collide(Core:FlxCore):Boolean 
		{
			if (dead) return false;
			var hit:Boolean = Core.overlaps(this);
			if (hit && count < times)
			{
				if (Core is Character && hitThings.indexOf(Core) == -1)
				{
					(Core as Character).damage(damage);
					hitThings.push(Core);
				}
			}
			return hit;
		}
		
		public override function update():void
		{
			if (count >= times)
			{
				this.kill();
			}
			else if (parent)
			{
				switch(type)
				{
					case "stab":
						angle = Math.random() * 10 + 40 + 180 * parent.facing;
						break;
					case "slash":
						angle = Math.random()*(parent.facing*2-1)*15+(parent.facing*2-1)*-20;
						break;
					case "spin":
						angle = _caf * angularVelocity + 150;
						break;
					case "punch":
						angle = 45 - parent.facing * 180;
					default:
						break;
				}
				this.facing = parent.facing;
				this.x = parent.x + parent.width*parent.facing + offx*(parent.facing*2-1) + width*(parent.facing-1);
				this.y = parent.y + offy;
			}
			super.update();
		}
	}
}