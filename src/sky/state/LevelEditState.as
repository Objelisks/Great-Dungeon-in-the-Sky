package sky.state
{
	import flash.utils.Endian;
	import org.flixel.*;
	import sky.char.*;
	import sky.helper.*;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class LevelEditState extends LevelState
	{
		public var cursor:FlxSprite;
		public var playerPlacement:FlxSprite;
		public var exitPlacement:Point;
		public var enemyPlacement:Array;
		public var curEType:uint;
		public var curETypeText:FlxText;
		public var fakeExitEmit:FlxEmitter;
		
		public function LevelEditState():void
		{
			super();
			//setZoom(1);
			level = new Level();
			level.auto = FlxTilemap.AUTO;
			level.loadMap(new Assets.LevelBlank, Assets.ImgAutoBlue, 16)
			level.setTile(1, 10, 2);
			
			bg = new FlxTilemap().loadMap(new Assets.LevelBlank, Assets.ImgTilesBlue, 16);
			for (var t:uint = 0; t < level.heightInTiles * level.widthInTiles; t++)
				bg.setTileByIndex(t, Math.random()*5+55);
			bgDarkener = new FlxSprite();
			bgDarkener.createGraphic(FlxG.width, FlxG.height, 0x88000000);
			bgDarkener.scrollFactor = new Point();
			
			cursor = new FlxSprite(50, 50, Assets.ImgCursor);
			
			enemies = new Array();
			enemyPlacement = new Array();
			
			curEType = 0;
			curETypeText = new FlxText(5, 5, 100, Assets.groups[curEType].name);
			curETypeText.scrollFactor = new Point();
			
			player = new Player(FlxG.userData.charId);
			player.controllable = false;
			
			playerPlacement = new FlxSprite(20, 80, Assets.ImgButton);
			player.x = 20;
			player.y = 80;
			
			exitPlacement = new Point(60, 50);
			
			FlxG.follow(cursor, 2.5);
            FlxG.followAdjust(0.5, 0.5);
			FlxG.followBounds(1, 1, level.width - 1, level.height - 17);
			
			add(bg);
			add(bgDarkener);
			add(player);
			
			exitEmit =  new FlxEmitter(-300, -300, 0.01);;
			fakeExitEmit = new FlxEmitter(exitPlacement.x, exitPlacement.y, 0.01);
			fakeExitEmit.width = 16;
			fakeExitEmit.height = 32;
			fakeExitEmit.minVelocity.y = -20;
			fakeExitEmit.createSprites(Assets.ImgDust, 50, false);
			add(fakeExitEmit);	
			
			add(level);
			add(playerPlacement);
			add(curETypeText);
			add(cursor);
			
			pauseMenu = new FlxLayer();
			pauseMenu.scrollFactor = new Point();
			pauseText = new FlxText(50, 50, 200, "X to place rock\n" +
												 "S to place castle\n" + 
												 "C to remove tile\n" +
												 "T to toggle player control\n" +
												 "R to reset player\n" + 
												 "Q/W to change enemy type\n" + 
												 "Z to export map (to debug console :<)\n" + 
												 "1 to place player\n" + 
												 "2 to place enemy\n" +
												 "3 to remove last enemy placed\n" +
												 "4 to place exit\n" +
												 "backspace to reset\n" + 
												 "f9 to return to menu");
			pauseText.color = 0xff990000;
			pauseDarkener = new FlxSprite();
			pauseDarkener.createGraphic(FlxG.width, FlxG.height, 0x88000000);
			pauseMenu.add(pauseDarkener, true);
			pauseMenu.add(pauseText, true);
			pauseMenu.add(pauseAttackText, true);
			pauseMenu.visible = false;
			add(pauseMenu);
		}
		
		override public function postProcess():void 
		{
			//super.postProcess();
		}
		
		public override function update():void
		{
			super.update();
			if (paused)
			{
			}
			else
			{
				if (!player.controllable)
				{
					if(FlxG.keys.LEFT)
					{
						cursor.x -= 2;
					}
					if (FlxG.keys.RIGHT)
					{
						cursor.x += 2;
					}
					if (FlxG.keys.UP)
					{
						cursor.y -= 2;
					}
					if (FlxG.keys.DOWN)
					{
						cursor.y += 2;
					}
				}
				
				if (!player.controllable && FlxG.keys.pressed("X"))
				{
					if (cursor.x > 0 && cursor.x < level.width && cursor.y > 0 && cursor.y < level.height)
					{
						if (level.getTile(cursor.x / 16, cursor.y / 16) == 0)
						{
							level.setTile(cursor.x / 16, cursor.y / 16, 1);
						}
					}
				}
				if (!player.controllable && FlxG.keys.pressed("S"))
				{
					if (cursor.x > 0 && cursor.x < level.width && cursor.y > 0 && cursor.y < level.height)
					{
						if (level.getTile(cursor.x / 16, cursor.y / 16) == 0)
						{
							level.setTile(cursor.x / 16, cursor.y / 16, 17);
						}
					}
				}
				if (!player.controllable && FlxG.keys.pressed("C"))
				{
					if (cursor.x > 0 && cursor.x < level.width && cursor.y > 0 && cursor.y < level.height)
					{
						if (level.getTile(cursor.x / 16, cursor.y / 16) > 0)
						{
							level.setTile(cursor.x / 16, cursor.y / 16, 0);
						}
					}
				}
				if (!player.controllable && FlxG.keys.justPressed("Z"))
				{
					trace("levelstart");
					trace(playerPlacement.x + " " + playerPlacement.y);
					trace(exitPlacement.x + " " + exitPlacement.y);
					for each(var fgsf:Object in enemyPlacement)
					{
						trace(fgsf.p.x + " " + fgsf.p.y + " " + fgsf.t);
					}
					trace("");
					level.output();
				}
				if (FlxG.keys.justPressed("T"))
				{
					player.controllable = !player.controllable;
					FlxG.follow(player.controllable?player:cursor, 2.5);
					player.reset(playerPlacement.x, playerPlacement.y);
					for each(var x:Enemy in enemies)
					{
						x.kill();
					}
					enemies = new Array();
					if (player.controllable)
					{
						for each(var p:Object in enemyPlacement)
						{
							var e:Enemy = new Enemy(FlxG.getRandom(Assets.groups[p.t].members) as uint);
							e.x = p.p.x;
							e.y = p.p.y;
							e.ai = Ayai.wander;
							add(e);
							enemies.push(e);
						}
					}
				}
				if (FlxG.keys.justPressed("R"))
				{
					player.reset(playerPlacement.x, playerPlacement.y);
				}
				if (FlxG.keys.justPressed("F9"))
				{
					FlxG.fade(0xff000000, 1, function():void { FlxG.flash(0xffffffff, 0.2, null, true); FlxG.switchState(MenuState); }, false);
				}
				if (FlxG.keys.justPressed("DELETE"))
				{
					FlxG.fade(0xff000000, 1, function():void { FlxG.flash(0xffffffff, 0.2, null, true); FlxG.switchState(LevelEditState); }, false);
				}
				if (FlxG.keys.justPressed("ONE"))
				{
					level.respawn.x = playerPlacement.x = cursor.x;
					level.respawn.y = playerPlacement.y = cursor.y;
				}				
				if (FlxG.keys.justPressed("TWO"))
				{
					enemyPlacement.push( { p:new Point(cursor.x, cursor.y), t:curEType, i:Helper.Color(new FlxSprite(cursor.x, cursor.y, Assets.ImgButton), 0xffaa0000) } );
					add(enemyPlacement[enemyPlacement.length - 1].i);
				}
				if (FlxG.keys.justPressed("THREE"))
				{
					if (enemyPlacement.length > 0)
					{
						enemyPlacement.pop().i.kill();
					}
				}
				if (FlxG.keys.justPressed("FOUR"))
				{
					exitPlacement.x = cursor.x;
					exitPlacement.y = cursor.y;
					fakeExitEmit.x = exitPlacement.x;
					fakeExitEmit.y = exitPlacement.y;
				}
				if (FlxG.keys.justPressed("Q"))
				{
					if (curEType == 0)
					{
						curEType = Assets.groups.length - 1;
					}
					else
					{
						curEType--;
					}
					curETypeText.text = Assets.groups[curEType].name;
				}
				if (FlxG.keys.justPressed("W"))
				{
					if (curEType == Assets.groups.length - 1)
					{
						curEType = 0;
					}
					else
					{
						curEType++;
					}
					curETypeText.text = Assets.groups[curEType].name;
				}
			}
		}
	}
}