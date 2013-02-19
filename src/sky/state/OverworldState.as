package sky.state
{
	import flash.display.BitmapData;
	import org.flixel.*;
	import sky.helper.*;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class OverworldState extends FlxState
	{
		public var bg:FlxSprite;
		public var selector:Point;
		private var title:FlxText;
		private var continueText:FlxText;
		private var hintText:FlxText;
		private var transition:Boolean;
		
		public function OverworldState():void
		{
			transition = false;
			bg = new FlxSprite(32,0,Assets.LevelOverworld);
			add(bg);
			selector = World.lastlevel;
			title = new FlxText(0, 5, FlxG.width, "Level Selection");
			title.color = 0xff000000 + Math.random() * (0x00ffffff - 0x00666666) + 0x00666666;
			title.alignment = "center";
			title.size = 16;
			continueText = new FlxText(FlxG.width - 150, FlxG.height - 20, 150, "Press X to continue");
			continueText.color = title.color;
			continueText.alignment = "right";
			continueText.visible = World.visibility[selector.y][selector.x] == 1;
			hintText = new FlxText(5, FlxG.height - 30, 150, "Kill all four dragons to\naccess the boss' lair");
			hintText.color = title.color;
			add(title);
			add(continueText);
			add(hintText);
			
			if (FlxG.kong && FlxG.FlxSave.data.gfxallowed)
			{
				FlxG.kong.API.stats.submit("killedtheboss", 1);
			}
			if (FlxG.kong)
			{
				if (FlxG.FlxSave.data.charUnlocks)
				{
					var count:uint = 0;
					FlxG.FlxSave.data.charUnlocks.forEach(function(item:uint, index:uint, array:Array):void { if (item == 1) count++; } );
					FlxG.kong.API.stats.submit("unlocks", count);
					if (count == 316)
					{
						FlxG.kong.API.stats.submit("allunlocked", 1);
					}
				}
			}
		}
		
		public override function render():void
		{
			super.render();
			for (var y:uint = 0; y < World.levels.length; y++)
			{
				for (var x:uint = 0; x < World.levels[y].length; x++)
				{
					if (World.levels[y][x] > 0 && World.visibility[y][x] >= 1)
					{
						FlxG.buffer.fillRect(new Rectangle(x * 16 + 50, 52 + y * 11, 13, 8), new Point(x, y).equals(selector)?0xffff0000:0xffaaaaaa);
						FlxG.buffer.fillRect(new Rectangle(x * 16 + 51, 53 + y * 11, 11, 6), 0xff444444);
						switch(World.levels[y][x])
						{
							case 2:
								FlxG.buffer.copyPixels(Helper.GrabFromSheet(FlxG.addBitmap(Assets.ImgPortraits), new Rectangle(41, 113, 6, 6)), new Rectangle(0, 0, 6, 6), new Point(x * 16 + 53, 53 + y * 11));
								break;
							case 3:
								FlxG.buffer.copyPixels(Helper.GrabFromSheet(FlxG.addBitmap(Assets.ImgPortraits), new Rectangle(49, 113, 6, 6)), new Rectangle(0, 0, 6, 6), new Point(x * 16 + 53, 53 + y * 11));
								break;
							case 4:
								FlxG.buffer.copyPixels(Helper.GrabFromSheet(FlxG.addBitmap(Assets.ImgPortraits), new Rectangle(57, 113, 6, 6)), new Rectangle(0, 0, 6, 6), new Point(x * 16 + 53, 53 + y * 11));
								break;
							case 5:
								FlxG.buffer.copyPixels(Helper.GrabFromSheet(FlxG.addBitmap(Assets.ImgPortraits), new Rectangle(65, 113, 6, 6)), new Rectangle(0, 0, 6, 6), new Point(x * 16 + 53, 53 + y * 11));
								break;
							case 6:
								FlxG.buffer.copyPixels(Helper.GrabFromSheet(FlxG.addBitmap(Assets.ImgInterface), new Rectangle(9, 17, 6, 6)), new Rectangle(0, 0, 6, 6), new Point(x * 16 + 53, 53 + y * 11), Helper.GrabFromSheet(FlxG.addBitmap(Assets.ImgInterface), new Rectangle(9, 17, 6, 6)), new Point(), true);
								break;
							default:
								break;
						}
						if (World.visibility[y][x] == 2)
						{
							FlxG.buffer.copyPixels(FlxG.addBitmap(Assets.ImgEx), new Rectangle(0, 0, 8, 6), new Point(x * 16 + 53, 53 + y * 11), FlxG.addBitmap(Assets.ImgEx), new Point(), true);
						}
					}
				}
			}
		}
		
		public override function update():void
		{
			super.update();
			if (!transition && FlxG.keys.justPressed("LEFT"))
			{
				if (World.visibility[selector.y][selector.x - 1] >= 1)
				{
					selector.x -= 1;
				}
			}
			if (!transition && FlxG.keys.justPressed("RIGHT"))
			{
				if (World.visibility[selector.y][selector.x + 1] >= 1)
				{
					selector.x += 1;
				}
			}
			if (!transition && FlxG.keys.justPressed("UP"))
			{
				if (World.visibility[selector.y - 1] != null && World.visibility[selector.y - 1][selector.x] >= 1)
				{
					selector.y -= 1;
				}
			}
			if (!transition && FlxG.keys.justPressed("DOWN"))
			{
				if (World.visibility[selector.y + 1] != null && World.visibility[selector.y + 1][selector.x] >= 1)
				{
					selector.y += 1;
				}
			}
			if (!transition && FlxG.keys.justPressed("X") && World.visibility[selector.y][selector.x] == 1)
			{
				if (World.levels[selector.y][selector.x] == 6 && !(World.dragonskilled > 3))
				{
					hintText.flicker(0.5);
				}
				else
				{
					FlxG.play(Assets.SndOkay);
					transition = true;
					FlxG.userData.level = World.levels[selector.y][selector.x];
					World.lastlevel.x = selector.x;
					World.lastlevel.y = selector.y;
					FlxG.fade(0xff000000, 1, function():void { FlxG.flash(0xffffffff, 0.2, null, true); FlxG.switchState(CharSelectState); }, false);
				}
			}
			continueText.visible = World.visibility[selector.y][selector.x] == 1 && (World.levels[selector.y][selector.x] != 6 || (World.dragonskilled > 3));
		}
	}
}