package sky.char
{
	import org.flixel.*;
	import sky.combat.*;
	import sky.helper.*;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class Character extends FlxSprite
	{
		public var charId:uint;
		public var charTraits:Array;
		public var attack1d:Attack;
		public var attack2d:Attack;
		public var attack3d:Attack;
		public var attacks:Array;
		private var cleanUp:uint;
		public var attackCool:Number;
		public var statuses:uint;
		public var dmgDisplay:FlxText;
		public var onDeath:Function;
		public var maxHealth:Number;
		/*
		0xabcdefgh
		a=confused
		b=invisibled
		c=poisoned
		d=blinded
		e=paralyzed
		*/
		
		public function Character(id:uint) : void
		{
			super(0, 0, null);
			
			charTraits = new Array();
			charId = id;
			acceleration.y = 300;
			maxVelocity.x = 100;
			maxVelocity.y = 100;
			drag.x = 300;
			drag.y = 300;
			attacks = new Array();
			cleanUp = 0;
			health = 100;
			maxHealth = 100;
			
			attackCool = 0;
			
			statuses = 0;
			
			CharFactory.GetCharacter(this, id);
		}
		
		override public function getScreenXY(P:Point):void
		{
			super.getScreenXY(P);
			P.y -= velocity.x != 0 && velocity.y == 0 ? getTimer()*(maxVelocity.x)/(10*Math.abs(velocity.x)) % 2 : 0;
		}
		
		override public function render():void
		{
			if ((statuses & 0x01000000) == 0x01000000) {} //invisible
			else
			{
				super.render();
			}
			attacks.forEach(function(item:FlxCore, index:uint, array:Array):void
			{
				if(!item.dead)
					item.render();
			});
		}
		
		override public function update():void
		{
			if(attackCool > 0)
				attackCool = Math.max(0, attackCool - FlxG.elapsed);
			
			attacks.forEach(function(item:FlxCore, index:uint, array:Array):void
			{
				if(!item.dead)
				item.update();
			});
			cleanUp++;
			if (cleanUp > 100)
			{
				cleanUp = 0;
				attacks.filter(function(item:FlxCore, index:uint, array:Array):Boolean { return !item.dead; } );
			}
			
			statusUpdate();
			
			super.update();
		}
		
		override public function kill():void
		{
			if (onDeath != null)
				onDeath();
			super.kill();
		}
		
		public function damage(Damage:Number, Type:String="fgsfds"):void
		{
			var dmg:uint = Damage * (charTraits["strongto" + Type] == null?(charTraits["weakto" + Type] == null?1:1.5):0.5);
			if (dmg > 0)
			{
				var blood:Blood = new Blood(x, y, this, charTraits["blood"] == null?0xffff0000:charTraits["blood"], Math.floor(Math.random()*7));
				FlxG.state.add(blood);
				var dmgDisplay:FlxText = new FlxText(x+Math.random()*width-width/2, y-5-5*Math.random(), 100, "" + dmg);
				dmgDisplay.size = 5;
				dmgDisplay.color = 0xff0000;
				dmgDisplay.velocity.y = -20;
				Helper.After(0.7, function():void { dmgDisplay.kill(); } );
				FlxG.state.add(dmgDisplay);
				this.hurt(dmg);
			}
			switch(Type)
			{
				case "poison":
					if (charTraits["strongtopoison"] == null)
					{
						var me:Character = this;
						me.statuses |= 0x00100000;
						Helper.After(6, function():void { if ((me.statuses & 0x00100000) == 0x00100000) me.statuses ^= 0x00100000; });
					}
					break;
				default:
					break;
			}
		}
		
		public function collideAttacks(Core:FlxCore):void
		{
			attacks.forEach(function(item:FlxCore, index:uint, array:Array):void
			{
				if(!item.dead)
					Core.collide(item);
			});
		}
		
		public function moveLeft(speed:Number):void
		{
			if ((statuses & 0x00001000) == 0x00001000) return;
			speed = -Math.abs(speed);
			facing = LEFT;
            velocity.x -= charTraits["movespeed"] * FlxG.elapsed;
			velocity.x = Math.max(speed/100*charTraits["movespeed"]/10, velocity.x);
		}
		
		public function moveRight(speed:Number):void
		{
			if ((statuses & 0x00001000) == 0x00001000) return;
			speed = Math.abs(speed);
            facing = RIGHT;
            velocity.x += charTraits["movespeed"] * FlxG.elapsed;
			velocity.x = Math.min(speed/100*charTraits["movespeed"]/10, velocity.x);
		}
		
		public function jump():void
		{
			if ((statuses & 0x00001000) == 0x00001000) return;
			if (charTraits["flying"] || velocity.y == 0)
			{
				velocity.y -= 20 * charTraits["movespeed"] * FlxG.elapsed;
			}
		}
		
		public function attack1():void
		{
			if ((statuses & 0x00001000) == 0x00001000) return;
			if (attackCool == 0)
			{
				attack1d.attack(this);
			}
		}
		
		public function attack2():void
		{
			if ((statuses & 0x00001000) == 0x00001000) return;
			if (attackCool == 0)
			{
				attack2d.attack(this);
			}
		}
		public function attack3():void
		{
			if ((statuses & 0x00001000) == 0x00001000) return;
			if (attackCool == 0)
			{
				attack3d.attack(this);
			}
		}
		
		public function statusUpdate():void
		{
			if ((statuses & 0x10000000) == 0x10000000) // confused
			{
				var c:uint = Math.random() * 6;
				switch(c)
				{
					case 0:
						moveLeft(100);
						break;
					case 1:
						moveRight(100);
						break;
					case 2:
						jump();
						break;
					default:
						break;
				}
			}
			if ((statuses & 0x01000000) == 0x01000000) // invisible
			{
				
			}
			if ((statuses & 0x00100000) == 0x00100000) // poisoned
			{
				if (getTimer()%60==1)
				{
					damage(1+(charTraits["weaktopoison"]?1:0));
				}
			}
			if ((statuses & 0x00010000) == 0x00010000) // blinded
			{
				
			}
			if ((statuses & 0x00001000) == 0x00001000) // paralyzed
			{
				
			}
		}
	}
}