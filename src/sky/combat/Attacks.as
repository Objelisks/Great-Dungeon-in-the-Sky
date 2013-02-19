package sky.combat
{
	import flash.geom.Point;
	import mx.collections.errors.ItemPendingError;
	import org.flixel.*;
	import sky.char.*;
	import sky.helper.*;
	import sky.state.LevelState;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class Attacks
	{
		private static var attackIcons:BitmapData = FlxG.addBitmap(Assets.AttackIcons);
		
		public static var none:Attack = new Attack("None", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
		
		public static var melee:Object =
		{
			hatch:new Attack(
			"Hatch",
			Helper.GrabIconFromSheet(attackIcons, new Point(4, 10)),
			function(me:Character):void
			{
				var unlock:int = me.charId;
				if (me.charId >= 241)
					unlock = me.charId + 16;
				else if (me.charId >= 230)
				unlock = me.charId + (11 + (me.charId - 230));
				else
					unlock = me.charId + 5;
				CharFactory.GetCharacter(me, unlock);
				me.facing = !me.facing;
				me.facing = !me.facing;
				me.charId = unlock;
				if (me is Player)
				{
					FlxG.userData.charId = unlock;
				}
				Unlocker.unlock(me.charId - 1);
				var e:Effect = new Effect(me.x-me.origin.x, me.y-me.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xff000000, false);
				FlxG.state.add(e);
				me.attackCool += 10;
			}),
			
			slash:new Attack(
			"Slash",
			Helper.GrabIconFromSheet(attackIcons, new Point(0,10)),
			function(me:Character):void
			{
				var m:Melee = new Melee("slash", me, 10, 1);
				m.offy = -5;
				me.attacks.push(m);
				me.attackCool += 0.6;
			}),
			
			stab:new Attack(
			"Stab",
			Helper.GrabIconFromSheet(attackIcons, new Point(6,10)),
			function(me:Character):void
			{
				var m:Melee = new Melee("stab", me, 3);
				m.offy = -5;
				me.attacks.push(m);
				me.attackCool += 0.2;
			}),
			
			thrust:new Attack(
			"Thrust",
			Helper.GrabIconFromSheet(attackIcons, new Point(15, 2)),
			function(me:Character):void
			{
				var m1:Melee = new Melee("stab", me, 5);
				var m2:Melee = new Melee("stab", me, 5);
				m1.offy = -5;
				m2.offy = -5;
				m2.offx = 9;
				me.attacks.push(m1);
				me.attacks.push(m2);
				me.attackCool += 1;
			}),
			
			staff:new Attack(
			"Staff",
			Helper.GrabIconFromSheet(attackIcons, new Point(5, 11)),
			function(me:Character):void
			{
				var m:Melee = new Melee("spin", me, 8, 2);
				m.offy = -5;
				m.angularVelocity = 40;
				me.attacks.push(m);
				me.attackCool += 0.5;
			}),
			
			club:new Attack(
			"Club",
			Helper.GrabIconFromSheet(attackIcons, new Point(2, 11)),
			function(me:Character):void
			{
				var m1:Melee = new Melee("spin", me, 4);
				var m2:Melee = new Melee("spin", me, 4);
				m1.offy = -5;
				m2.offy = -4;
				m1.offx = m2.offx = -2;
				m1.angularVelocity = 20;
				m2.angularVelocity = 20;
				me.attacks.push(m1);
				me.attacks.push(m2);
				me.attackCool += 0.8;
			}),
			
			spin:new Attack(
			"Spin Attack",
			Helper.GrabIconFromSheet(attackIcons, new Point(4, 10)),
			function(me:Character):void
			{
				var m1:Melee = new Melee("stab", me, 3, 2);
				m1.offx = -5;
				m1.offy = -5;
				var m2:Melee = new Melee("stab", me, 3, 2);
				m2.offx = -20;
				m2.offy = -5;
				me.attacks.push(m1);
				me.attacks.push(m2);
				me.attackCool += 3;
			}),
			
			charge:new Attack(
			"Charge",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 3)),
			function(me:Character):void
			{
				me.maxVelocity.x = 150;
				me.drag.x = 0;
				Helper.After(1, function():void { me.maxVelocity.x = 100; me.drag.x = 300; } );
				me.velocity.x = 200*(me.facing*2-1);
				var m:Melee = new Melee("stab", me, 10);
				m.offy = -6;
				m.offx = -5;
				me.attacks.push(m);
				me.attackCool += 6;
			}),
			
			axe:new Attack(
			"Axe",
			Helper.GrabIconFromSheet(attackIcons, new Point(12, 10)),
			function(me:Character):void
			{
				var m:Melee = new Melee("spin", me, 10);
				m.offy = -5;
				m.angularVelocity = 10;
				me.attacks.push(m);
				me.attackCool += 0.5;
			}),
			
			openpalm:new Attack(
			"Open Palm",
			Helper.GrabIconFromSheet(attackIcons, new Point(6, 6)),
			function(me:Character):void
			{
				var m:Melee = new Melee("punch", me, 8);
				m.offy = -5;
				me.attacks.push(m);
				me.attackCool += 0.3;
			}),
			
			closedfist:new Attack(
			"Closed Fist",
			Helper.GrabIconFromSheet(attackIcons, new Point(7, 6)),
			function(me:Character):void
			{
				var m:Melee = new Melee("punch", me, 10);
				m.offx = 5;
				m.offy = -5;
				me.attacks.push(m);
				me.attackCool += 0.6;
			}),
			
			threehands:new Attack(
			"Three Hands Technique",
			Helper.GrabIconFromSheet(attackIcons, new Point(8, 6)),
			function(me:Character):void
			{
				var m:Melee = new Melee("punch", me, 15, 6);
				m.offx = 3;
				m.offy = -5;
				me.attacks.push(m);
				me.attackCool += 5;
			}),
			
			toss:new Attack(
			"Throw",
			Helper.GrabIconFromSheet(attackIcons, new Point(11, 4)),
			function(me:Character):void
			{
				var m1:Melee = new Melee("stab", me, 0);
				m1.offy = -5;
				me.attacks.push(m1);
				var m2:Magic = new Magic([0x00000000], me, 1, 0.25);
				var initVel:Number = m2.velocity.x += (me.facing * 2 - 1) * 100;
				m2.velocity.y = 0;
				m2.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(3);
						(sprite as Character).statuses |= 0x00001000;
						Helper.After(2, function():void {if (((sprite as Character).statuses & 0x00001000) == 0x00001000) (sprite as Character).statuses ^= 0x00001000; } );
						(sprite as Character).velocity.x = initVel * 10;
						Helper.After(3, function():void { (sprite as Character).drag.x = 300; } );
						(sprite as Character).drag.x = 0;
						(sprite as Character).velocity.y = -1000;
						this.kill();
					}
				}
				me.attacks.push(m2);
				me.attackCool += 3;
			}),
			
			splash:new Attack(
			"Splash",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 6)),
			function(me:Character):void
			{
				var m:Blood = new Blood(me.x, me.y, me, 0xff0000ff, 5);
				FlxG.state.add(m);
				me.attackCool += 0.2;
			}),
			
			stabpoison:new Attack(
			"Stab (Poison)",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 10)),
			function(me:Character):void
			{
				var m1:Melee = new Melee("stab", me, 4);
				m1.offy = -5;
				me.attacks.push(m1);
				var m2:Magic = new Magic([0x00000000], me, 1, 0.25);
				m2.velocity.x += (me.facing * 2 - 1) * 100;
				m2.velocity.y = 0;
				m2.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(1, "poison");
						this.kill();
					}
				}
				me.attacks.push(m2);
				me.attackCool += 3;
			}),
			
			bite:new Attack(
			"Bite",
			Helper.GrabIconFromSheet(attackIcons, new Point(2, 8)),
			function(me:Character):void
			{
				var m1:Melee = new Melee("punch", me, 3);
				m1.offx = -2;
				m1.offy = -7;
				me.attacks.push(m1);
				var m2:Melee = new Melee("punch", me, 3);
				m2.offx = -2;
				m2.offy = -4;
				me.attacks.push(m2);
				me.attackCool += 0.5;
			}),
			
			bitepoison:new Attack(
			"Bite (Poison)",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 7)),
			function(me:Character):void
			{
				var m1:Melee = new Melee("punch", me, 3);
				m1.offx = -2;
				m1.offy = -7;
				me.attacks.push(m1);
				var m2:Melee = new Melee("punch", me, 3);
				m2.offx = -2;
				m2.offy = -4;
				me.attacks.push(m2);
				var m3:Magic = new Magic([0x00000000], me, 1, 0.25);
				m3.velocity.x += (me.facing * 2 - 1) * 100;
				m3.velocity.y = 0;
				m3.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(1, "poison");
						this.kill();
					}
				}
				me.attacks.push(m3);
				me.attackCool += 3;
			}),
			
			punch:new Attack(
			"Punch",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 0)),
			function(me:Character):void
			{
				var m:Melee = new Melee("punch", me, 4);
				m.offx = -4;
				m.offy = -5;
				me.attacks.push(m);
				me.attackCool += 0.3;
			}),
			
			peck:new Attack(
			"Peck",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 0)),
			function(me:Character):void
			{
				var m:Melee = new Melee("punch", me, 1);
				m.offx = -4;
				m.offy = -5;
				me.attacks.push(m);
				me.attackCool += 0.1;
			}),
			
			kick:new Attack(
			"Kick",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 0)),
			function(me:Character):void
			{
				var m:Melee = new Melee("punch", me, 5);
				m.offx = -4;
				m.offy = -1;
				me.attacks.push(m);
				me.attackCool += 0.4;
			})
		}
		
		public static var magic:Object =
		{
			polymorph:new Attack(
			"Polymorph",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff800080], me, 3, 3, 2, 0);
				m.velocity.x += (me.facing * 2 - 1) * 70;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						var polypoly:Array = [196, 206, 211, 213, 216, 219];
						var char:Character = sprite as Character;
						var to:uint = FlxG.getRandom(polypoly) as uint;
						CharFactory.GetCharacter(char, to);
						char.facing = !char.facing;
						char.facing = !char.facing;
						char.charId = to;
						var e:Effect = new Effect(char.x-char.origin.x, char.y-char.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xffff7f00, false);
						FlxG.state.add(e);
						m.kill();
						if (char is Player)
						{
							if (FlxG.userData.morphed == null) FlxG.userData.morphed = 0;
							if (FlxG.kong) FlxG.kong.API.stats.submit("timesmorphed", ++FlxG.userData.morphed);
						}
					}
				}
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			control:new Attack(
			"Control",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 8)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffff0000, 0xff00ff00, 0xff0000ff], me, 3, 3);
				m.velocity.x += (me.facing * 2 - 1) * 40;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						var char:Character = sprite as Character;
						var temp:uint = char.charId;
						CharFactory.GetCharacter(char, me.charId);
						char.facing = !char.facing;
						char.facing = !char.facing;
						char.charId = me.charId;
						CharFactory.GetCharacter(me, temp);
						me.facing = !me.facing;
						me.facing = !me.facing;
						me.charId = temp;
						var e1:Effect = new Effect(me.x-me.origin.x, me.y-me.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xffff7f00, false);
						FlxG.state.add(e1);
						var e2:Effect = new Effect(char.x-char.origin.x, char.y-char.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xffff7f00, false);
						FlxG.state.add(e2);
						this.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 10;
			}),
			
			red:new Attack(
			"Redness",
			Helper.GrabIconFromSheet(attackIcons, new Point(13, 4)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffff0000], me, 3, 3, 2, 0);
				m.velocity.x += (me.facing * 2 - 1) * 70;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						var char:Character = sprite as Character;
						CharFactory.GetCharacter(char, 189);
						char.facing = !char.facing;
						char.facing = !char.facing;
						var e:Effect = new Effect(char.x-char.origin.x, char.y-char.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xffff0000, false);
						FlxG.state.add(e);
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			purple:new Attack(
			"Purpleness",
			Helper.GrabIconFromSheet(attackIcons, new Point(14, 4)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffff00ff], me, 3, 3, 2, 0);
				m.velocity.x += (me.facing * 2 - 1) * 70;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						var char:Character = sprite as Character;
						CharFactory.GetCharacter(char, 190);
						char.facing = !char.facing;
						char.facing = !char.facing;
						var e:Effect = new Effect(char.x-char.origin.x, char.y-char.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xffff00ff, false);
						FlxG.state.add(e);
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			green:new Attack(
			"Greenness",
			Helper.GrabIconFromSheet(attackIcons, new Point(12, 4)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff00ff00], me, 3, 3, 2, 0);
				m.velocity.x += (me.facing * 2 - 1) * 70;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						var char:Character = sprite as Character;
						CharFactory.GetCharacter(char, 191);
						char.facing = !char.facing;
						char.facing = !char.facing;
						var e:Effect = new Effect(char.x-char.origin.x, char.y-char.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xff00ff00, false);
						FlxG.state.add(e);
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			polymorphself:new Attack(
			"Transform Self",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 0)),
			function(me:Character):void
			{
				var to:uint = Math.floor(Math.random() * 223 + 1);
				CharFactory.GetCharacter(me, to);
				me.facing = !me.facing;
				me.facing = !me.facing;
				me.charId = to;
				var e:Effect = new Effect(me.x-me.origin.x, me.y-me.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xffff7f00, false);
				FlxG.state.add(e);
				me.attackCool += 3;
			}),
			
			polymorphbat:new Attack(
			"Change to Bat",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 0)),
			function(me:Character):void
			{
				CharFactory.GetCharacter(me, 207);
				me.facing = !me.facing;
				me.facing = !me.facing;
				me.charId = 207;
				var e:Effect = new Effect(me.x-me.origin.x, me.y-me.origin.y, 64, 16, Assets.AttackExplode, 2, 1, 0xff000000, false);
				FlxG.state.add(e);
				me.attackCool += 3;
			}),
			
			jump:new Attack(
			"Magic Jump",
			Helper.GrabIconFromSheet(attackIcons, new Point(7, 0)),
			function(me:Character):void
			{
				me.maxVelocity.y = 200;
				Helper.After(1, function():void { me.maxVelocity.y = 100; } );
				me.jump();
				var m:Magic = new Magic([0xff0000ff], me, 10, 1);
				m.velocity = new Point();
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			shield:new Attack(
			"Force Wall",
			Helper.GrabIconFromSheet(attackIcons, new Point(1, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff7777cc], me, 1, 5, 5, -4);
				m.velocity = new Point();
				m.height = 8;
				m.width = 2;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character || sprite is Projectile || sprite is Magic)
					{
						sprite.velocity.x = 0;
					}
				}
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			fireball:new Attack(
			"Fireball",
			Helper.GrabIconFromSheet(attackIcons, new Point(0, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffff0000,0xffff7f00,0xffffbf00], me, 3, 3);
				m.velocity.x += (me.facing * 2 - 1) * 150;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(10, "fire");
						for (var i:uint = 0; i < 5; i++)
						{
							var e:Effect = new Effect(m.x-8, m.y-8, 64, 16, Assets.AttackExplode, 2, 0.5, 0xffffbf00, true);
							e.velocity.x = Math.random() * 30-15;
							e.velocity.y = Math.random() * 30-15;
							FlxG.state.add(e);
						}
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 1;
			}),
			
			iceball:new Attack(
			"Iceball",
			Helper.GrabIconFromSheet(attackIcons, new Point(0, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff0000ff,0xff9999ff,0xff5599ff], me, 3, 3);
				m.velocity.x += (me.facing * 2 - 1) * 150;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(10, "ice");
						for (var i:uint = 0; i < 5; i++)
						{
							var e:Effect = new Effect(m.x-8, m.y-8, 64, 16, Assets.AttackExplode, 2, 0.5, 0xff9999ff, true);
							e.velocity.x = Math.random() * 30-15;
							e.velocity.y = Math.random() * 30-15;
							FlxG.state.add(e);
						}
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 1;
			}),
			
			shock:new Attack(
			"Shock",
			Helper.GrabIconFromSheet(attackIcons, new Point(0, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffffff00,0xff30aaaa], me, 3, 3);
				m.velocity.x += (me.facing * 2 - 1) * 150;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(10, "shock");
						var e:Effect = new Effect(m.x-8, m.y-8, 64, 16, Assets.AttackExplode, 2, 0.5, 0xffffff00, true);
						e.velocity.x = Math.random() * 30-15;
						e.velocity.y = Math.random() * 30-15;
						FlxG.state.add(e);
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 0.4;
			}),
			
			magicmissile:new Attack(
			"Magic Missile",
			Helper.GrabIconFromSheet(attackIcons, new Point(0, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffffffff], me, 1, 1.2);
				m.velocity.x += (me.facing * 2 - 1) * 250;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(2, "light");
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 0.1;
			}),
			
			slow:new Attack(
			"Slow",
			Helper.GrabIconFromSheet(attackIcons, new Point(4, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff3333ff], me, 2, 3);
				m.velocity.x += (me.facing * 2 - 1) * 150;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).maxVelocity.x = Math.max(0, (sprite as Character).maxVelocity.x - 80);
						Helper.After(5, function():void { (sprite as Character).maxVelocity.x += 80; } );
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 5;
			}),
			
			haste:new Attack(
			"Haste",
			Helper.GrabIconFromSheet(attackIcons, new Point(4, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffaa0000], me, 10, 0.2, -4, 4);
				m.onFinish = function():void
				{
					me.charTraits.moveSpeed += 50;
					me.maxVelocity.x += 50;
					Helper.After(1, function():void {me.maxVelocity.x = Math.max(0, me.maxVelocity.x - 50); me.charTraits.moveSpeed = Math.max(0, me.charTraits.moveSpeed - 50);} );
				}
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			entangle:new Attack(
			"Entangle",
			Helper.GrabIconFromSheet(attackIcons, new Point(4, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff00ff00,0xff33aa33,0xff90480a], me, 2, 3);
				m.velocity.x += (me.facing * 2 - 1) * 60;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).maxVelocity.x = Math.max(0, (sprite as Character).maxVelocity.x - 95);
						Helper.After(5, function():void { (sprite as Character).maxVelocity.x += 95; } );
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 5;
			}),
			
			summon:new Attack(
			"Summon Creature",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffffffff], me, 15, 0.2);
				m.velocity.x += (me.facing * 2 - 1) * 50;
				m.onFinish = function():void
				{
					if (me is Player)
					{
						var a:Ally = new Ally(me.charTraits.summonid-1);
						a.x = m.x;
						a.y = m.y;
						a.ai = Ayai.wanderAgro;
						(FlxG.state as LevelState).allies.push(a);
						FlxG.state.add(a);
					}
					else
					{
						var e:Enemy = new Enemy(me.charTraits.summonid-1);
						e.x = m.x;
						e.y = m.y;
						e.ai = Ayai.wanderAgro;
						(FlxG.state as LevelState).enemies.push(e);
						FlxG.state.add(e);
					}
				}
				me.attacks.push(m);
				me.attackCool += 5;
			}),
			
			heal:new Attack(
			"Cure Wounds",
			Helper.GrabIconFromSheet(attackIcons, new Point(2, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffff6666], me, 10, 0.2, -4, 4);
				m.onFinish = function():void
				{
					me.health = Math.min(me.maxHealth, me.health + 10);
				}
				me.attacks.push(m);
				me.attackCool += 2;
			}),
			
			invisibility:new Attack(
			"Invisibility",
			Helper.GrabIconFromSheet(attackIcons, new Point(7, 0)),
			function(me:Character):void
			{
				me.statuses |= 0x01000000;
				Helper.After(8, function():void {if ((me.statuses & 0x01000000) == 0x01000000) me.statuses ^= 0x01000000; } );
				me.attackCool += 10;
			}),
			
			confuse:new Attack(
			"Confusion",
			Helper.GrabIconFromSheet(attackIcons, new Point(6, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff005500,0xff339933,0xff55aa55], me, 2, 3);
				m.velocity.x += (me.facing * 2 - 1) * 100;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).statuses |= 0x10000000;
						Helper.After(4, function():void {if (((sprite as Character).statuses & 0x10000000) == 0x10000000) (sprite as Character).statuses ^= 0x10000000; } );
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 3;
			}),
			
			darkness:new Attack(
			"Darkness",
			Helper.GrabIconFromSheet(attackIcons, new Point(6, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff000000,0xff333333,0xff555555], me, 2, 3);
				m.velocity.x += (me.facing * 2 - 1) * 150;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).statuses |= 0x00010000;
						Helper.After(6, function():void {if (((sprite as Character).statuses & 0x00010000) == 0x00010000) (sprite as Character).statuses ^= 0x00010000; } );
						(sprite as Character).damage(5, "dark");
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 5;
			}),
			
			blindinglight:new Attack(
			"Blinding Light",
			Helper.GrabIconFromSheet(attackIcons, new Point(6, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffffffff,0xffffff00], me, 2, 3);
				m.velocity.x += (me.facing * 2 - 1) * 150;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).statuses |= 0x00010000;
						Helper.After(6, function():void {if (((sprite as Character).statuses & 0x00010000) == 0x00010000) (sprite as Character).statuses ^= 0x00010000; } );
						(sprite as Character).damage(5, "light");
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 5;
			}),
			
			explosion:new Attack(
			"Explosion",
			Helper.GrabIconFromSheet(attackIcons, new Point(0, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xffff7f00,0xffff6f00,0xffffff00], me, 10, 1, 10, 0);
				m.velocity.x += (me.facing * 2 - 1) * 20;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(1, "fire");
					}
				}
				me.attacks.push(m);
				me.attackCool += 6;
			}),
			
			paralyze:new Attack(
			"Paralyze",
			Helper.GrabIconFromSheet(attackIcons, new Point(6, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff00ff00,0xff003300], me, 6, 3);
				m.velocity.x += (me.facing * 2 - 1) * 150;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).statuses |= 0x00001000;
						Helper.After(4, function():void {if (((sprite as Character).statuses & 0x00001000) == 0x00001000) (sprite as Character).statuses ^= 0x00001000; } );
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 5;
			}),
			
			freeze:new Attack(
			"Freeze",
			Helper.GrabIconFromSheet(attackIcons, new Point(0, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff0000ff,0xff000055,0xffaaaaff], me, 6, 3);
				m.velocity.x += (me.facing * 2 - 1) * 80;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).statuses |= 0x00001000;
						Helper.After(4, function():void {if (((sprite as Character).statuses & 0x00001000) == 0x00001000){ (sprite as Character).statuses ^= 0x00001000; (sprite as Character).color = 0xffffff; }} );
						m.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 4;
			}),
			
			firebreath:new Attack(
			"Fire Breath",
			Helper.GrabIconFromSheet(attackIcons, new Point(8, 0)),
			function(me:Character):void
			{
				for (var i:uint = 0; i < 3; i++)
				{
					var m:Magic = new Magic([0xffff7f00,0xffff6f00,0xffffff00], me, 6, 3);
					m.velocity.x += (me.facing * 2 - 1) * 80;
					m.velocity.y += 20 - i * 20;
					m.onCollideSprite = function(sprite:FlxSprite):void
					{
						if (sprite is Character)
						{
							(sprite as Character).damage(9, "fire");
							for (var i:uint = 0; i < 5; i++)
							{
								var e:Effect = new Effect(m.x-8, m.y-8, 64, 16, Assets.AttackExplode, 2, 0.5, 0xffffbf00, true);
								e.velocity.x = Math.random() * 30-15;
								e.velocity.y = Math.random() * 30-15;
								FlxG.state.add(e);
							}
							this.kill();
						}
					}
					me.attacks.push(m);
				}
				me.attackCool += 3;
			}),
			
			gustbreath:new Attack(
			"Gust Breath",
			Helper.GrabIconFromSheet(attackIcons, new Point(8, 0)),
			function(me:Character):void
			{
				for (var i:uint = 0; i < 3; i++)
				{
					var m:Magic = new Magic([0xff0000ff,0xff000055,0xffaaaaff], me, 6, 3);
					m.velocity.x += (me.facing * 2 - 1) * 80;
					m.velocity.y += 20 - i * 20;
					m.onCollideSprite = function(sprite:FlxSprite):void
					{
						if (sprite is Character)
						{
							(sprite as Character).damage(7, "ice");
							sprite.x += 16*(this.facing*2-1);
							this.kill();
						}
					}
					me.attacks.push(m);
				}
				me.attackCool += 3;
			}),
			
			elecbreath:new Attack(
			"Lightning Breath",
			Helper.GrabIconFromSheet(attackIcons, new Point(8, 0)),
			function(me:Character):void
			{
				for (var i:uint = 0; i < 3; i++)
				{
					var m:Magic = new Magic([0xffffff00,0xff30aaaa], me, 6, 3);
					m.velocity.x += (me.facing * 2 - 1) * 130;
					m.velocity.y += 10 - i * 10;
					m.onCollideSprite = function(sprite:FlxSprite):void
					{
						if (sprite is Character)
						{
							(sprite as Character).damage(5, "shock");
							var e:Effect = new Effect(m.x-8, m.y-8, 64, 16, Assets.AttackExplode, 2, 0.5, 0xffffff00, true);
							e.velocity.x = Math.random() * 30-15;
							e.velocity.y = Math.random() * 30-15;
							FlxG.state.add(e);
							this.kill();
						}
					}
					me.attacks.push(m);
				}
				me.attackCool += 3;
			}),
			
			poisonbreath:new Attack(
			"Poison Breath",
			Helper.GrabIconFromSheet(attackIcons, new Point(8, 0)),
			function(me:Character):void
			{
				for (var i:uint = 0; i < 3; i++)
				{
					var m:Magic = new Magic([0xff00ff00,0xff33aa33], me, 6, 3);
					m.velocity.x += (me.facing * 2 - 1) * 80;
					m.velocity.y += 20 - i * 20;
					m.onCollideSprite = function(sprite:FlxSprite):void
					{
						if (sprite is Character)
						{
							(sprite as Character).damage(3, "poison");
							this.kill();
						}
					}
					me.attacks.push(m);
				}
				me.attackCool += 3;
			}),
			
			poison:new Attack(
			"Poison",
			Helper.GrabIconFromSheet(attackIcons, new Point(0, 0)),
			function(me:Character):void
			{
				var m:Magic = new Magic([0xff00ff00,0xff33aa33], me, 5, 3);
				m.velocity.x += (me.facing * 2 - 1) * 100;
				m.onCollideSprite = function(sprite:FlxSprite):void
				{
					if (sprite is Character)
					{
						(sprite as Character).damage(2, "poison");
						this.kill();
					}
				}
				me.attacks.push(m);
				me.attackCool += 2;
			}),
			
			pray:new Attack(
			"Pray",
			Helper.GrabIconFromSheet(attackIcons, new Point(8, 0)),
			function(me:Character):void
			{
				me.attackCool += 2;
			})
		}
		
		public static var ranged:Object =
		{
			bow:new Attack(
			"Bow",
			Helper.GrabIconFromSheet(attackIcons, new Point(10, 11)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("arrow", me, 150, 0, 2);
				p.velocity.x = (me.facing * 2 - 1) * 100;
				p.velocity.y = -80+Math.random()*20;
				me.attacks.push(p);
				me.attackCool += 0.1;
			}),
			
			longbow:new Attack(
			"Longbow",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 11)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("arrow", me, 150, 0, 2);
				p.velocity.x = (me.facing * 2 - 1) * 100;
				p.velocity.y = -100+Math.random()*5;
				me.attacks.push(p);
				me.attackCool += 0.2;
			}),
			
			threeshot:new Attack(
			"Triple Shot",
			Helper.GrabIconFromSheet(attackIcons, new Point(1, 12)),
			function(me:Character):void
			{
				for (var i:uint = 0; i < 3; i++)
				{
					var p:Projectile = new Projectile("arrow", me, 150, 0, 2);
					p.damage = 3;
					p.velocity.x = (me.facing * 2 - 1) * 100+i*10;
					p.velocity.y = -80+i*10+Math.random()*15;
					me.attacks.push(p);
				}
				me.attackCool += 0.4;
			}),
			
			trueshot:new Attack(
			"True Shot",
			Helper.GrabIconFromSheet(attackIcons, new Point(3, 12)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("arrow", me, 80, 0, 2);
				p.damage = 4;
				p.velocity.x = (me.facing * 2 - 1) * 200;
				p.velocity.y = -20+Math.random()*3;
				me.attacks.push(p);
				me.attackCool += 0.2;
			}),
			
			poisonarrow:new Attack(
			"Poison Arrow",
			Helper.GrabIconFromSheet(attackIcons, new Point(4, 12)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("arrow", me, 120, 0, 2);
				p.dmgtype = "poison";
				p.color = 0x55ff55;
				p.velocity.x = (me.facing * 2 - 1) * 150;
				p.velocity.y = -60+Math.random()*3;
				me.attacks.push(p);
				me.attackCool += 1;
			}),
			
			firearrow:new Attack(
			"Fire Arrow",
			Helper.GrabIconFromSheet(attackIcons, new Point(5, 12)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("arrow", me, 120, 0, 2);
				p.dmgtype = "fire";
				p.color = 0xff0000;
				p.velocity.x = (me.facing * 2 - 1) * 150;
				p.velocity.y = -60+Math.random()*3;
				me.attacks.push(p);
				me.attackCool += 1;
			}),
			
			icearrow:new Attack(
			"Ice Arrow",
			Helper.GrabIconFromSheet(attackIcons, new Point(6, 12)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("arrow", me, 120, 0, 2);
				p.dmgtype = "ice";
				p.color = 0x0000ff;
				p.velocity.x = (me.facing * 2 - 1) * 150;
				p.velocity.y = -60+Math.random()*3;
				me.attacks.push(p);
				me.attackCool += 1;
			}),
			
			pistol:new Attack(
			"Pistol",
			Helper.GrabIconFromSheet(attackIcons, new Point(1, 8)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("bullet", me, 20, 0, 2);
				p.dmgtype = "bullet";
				p.color = 0xaaaaaa;
				p.velocity.x = (me.facing * 2 - 1) * 600;
				me.attacks.push(p);
				me.attackCool += 2;
			}),
			
			rifle:new Attack(
			"Rifle",
			Helper.GrabIconFromSheet(attackIcons, new Point(1, 8)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("bullet", me, 20, 0, 2);
				p.dmgtype = "bullet";
				p.damage = 8;
				p.color = 0xaaaaaa;
				p.velocity.x = (me.facing * 2 - 1) * 600;
				me.attacks.push(p);
				me.attackCool += 0.5;
			}),
			
			machinegun:new Attack(
			"Machine Gun",
			Helper.GrabIconFromSheet(attackIcons, new Point(1, 8)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("bullet", me, 20, 0, 2);
				p.dmgtype = "bullet";
				p.damage = 2;
				p.color = 0xaaaaaa;
				p.velocity.x = (me.facing * 2 - 1) * 600;
				me.attacks.push(p);
				me.attackCool += 0.1;
			}),
			
			sniper:new Attack(
			"Sniper Rifle",
			Helper.GrabIconFromSheet(attackIcons, new Point(1, 8)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("bullet", me, 20, 0, 2);
				p.dmgtype = "bullet";
				p.damage = 20;
				p.color = 0xaaaaaa;
				p.velocity.x = (me.facing * 2 - 1) * 600;
				me.attacks.push(p);
				me.attackCool += 3;
			}),
			
			net:new Attack(
			"Net",
			Helper.GrabIconFromSheet(attackIcons, new Point(4, 8)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("net", me, 30, 0, -5);
				p.velocity.x = (me.facing * 2 - 1) * 80;
				p.velocity.y = -10 + Math.random() * 3;
				p.dmgtype = "net";
				me.attacks.push(p);
				me.attackCool += 0.1;
			}),
			
			bread:new Attack(
			"Bread",
			Helper.GrabIconFromSheet(attackIcons, new Point(10, 6)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("bread", me, 150, 0, 2);
				p.velocity.x = (me.facing * 2 - 1) * 80;
				p.velocity.y = -100 + Math.random() * 3;
				me.attacks.push(p);
				me.attackCool += 1;
			}),
			
			present:new Attack(
			"Present",
			Helper.GrabIconFromSheet(attackIcons, new Point(10, 6)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("present", me, 150, -2, -10);
				p.velocity.x = (me.facing * 2 - 1) * 130;
				p.velocity.y = -100 + Math.random() * 50;
				me.attacks.push(p);
				me.attackCool += 1;
			}),
			
			rock:new Attack(
			"Rock",
			Helper.GrabIconFromSheet(attackIcons, new Point(10, 6)),
			function(me:Character):void
			{
				var p:Projectile = new Projectile("bullet", me, 150, 0, 2);
				p.damage = 1;
				p.velocity.x = (me.facing * 2 - 1) * 100*Math.random() + (me.facing * 2 - 1) * 30;
				p.velocity.y = -60 * Math.random() - 20;
				me.attacks.push(p);
				me.attackCool += 0.1;
			})
		}
		
		public static var item:Object =
		{
			potion:new Attack(
			"Potion",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 13)),
			function(me:Character):void
			{
				var m:Item = new Item(null, me);
				var timeout:Number = 0;
				m.updateFunction = function():void
				{
					me.health = Math.min(me.maxHealth, me.health + 10*FlxG.elapsed);
					timeout += FlxG.elapsed;
					if (timeout > 6)
					{
						m.kill();
					}
				}
				me.attacks.push(m);
				if (me.attack1d.name == "Potion")
				{
					me.attack1d = new Attack("Potion (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
				else if (me.attack2d.name == "Potion")
				{
					me.attack2d = new Attack("Potion (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
				else if (me.attack3d.name == "Potion")
				{
					me.attack3d = new Attack("Potion (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
			}),
			
			rope:new Attack(
			"Rope",
			Helper.GrabIconFromSheet(attackIcons, new Point(8, 12)),
			function(me:Character):void
			{
				var m:Item = new Item(Assets.AttackRope, me);
				m.y -= m.height;
				m.updateFunction = function():void
				{
					if (me.overlaps(m) && FlxG.keys.pressed("UP"))
					{
						me.velocity.y -= 5;
					}
				}
				me.attacks.push(m);
				if (me.attack1d.name == "Rope")
				{
					me.attack1d = new Attack("Rope (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
				else if (me.attack2d.name == "Rope")
				{
					me.attack2d = new Attack("Rope (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
				else if (me.attack3d.name == "Rope")
				{
					me.attack3d = new Attack("Rope (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
			}),
			
			bomb:new Attack(
			"Bomb",
			Helper.GrabIconFromSheet(attackIcons, new Point(9, 6)),
			function(me:Character):void
			{
				var m:Item = new Item(Assets.AttackBomb, me);
				var timer:Number = 0;
				m.velocity.x = 50;
				m.velocity.y = -50;
				m.acceleration.y = 150;
				m.drag.x = 50;
				m.drag.y = 50;
				m.updateFunction = function():void
				{
					timer += FlxG.elapsed;
					if (timer > 3)
					{
						for (var i:uint = 0; i < 15; i++)
						{
							var m1:Magic = new Magic([0xffff7f00, 0xffff6f00, 0xffffff00], me, 6, 3);
							m1.x = m.x;
							m1.y = m.y;
							m1.velocity.x = Math.random() * 400 - 200;
							m1.velocity.y = Math.random() * 200;
							m1.onCollideSprite = function(sprite:FlxSprite):void
							{
								if (sprite is Character)
								{
									(sprite as Character).damage(9, "fire");
									for (var i:uint = 0; i < 15; i++)
									{
										var e:Effect = new Effect(m1.x-8, m1.y-8, 64, 16, Assets.AttackExplode, 2, 0.5, 0xffffbf00, true);
										e.velocity.x = Math.random() * 30 - 15;
										e.velocity.y = Math.random() * 30 - 15;
										FlxG.state.add(e);
									}
									this.kill();
								}
							}
							me.attacks.push(m1);
						}
						m.kill();
					}
				}
				me.attacks.push(m);
				if (me.attack1d.name == "Bomb")
				{
					me.attack1d = new Attack("Bomb (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
				else if (me.attack2d.name == "Bomb")
				{
					me.attack2d = new Attack("Bomb (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
				else if (me.attack3d.name == "Bomb")
				{
					me.attack3d = new Attack("Bomb (Used)", FlxG.addBitmap(Assets.ImgLocked), function(me:Character):void { } );
				}
			})
		}
	}
}