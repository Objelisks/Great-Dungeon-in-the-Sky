package sky.state
{
	import org.flixel.*;
	import org.flixel.data.FlxKong;
	import sky.helper.*;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class MenuState extends FlxState
	{
		private var text1:FlxText;
		private var text2:FlxText;
		private var buttonNew:FlxButton;
		private var buttonContinue:FlxButton;
		private var buttonCredits:FlxButton;
		private var buttonGfx:FlxButton;
		private var switching:Boolean;
		private var floatingIsland:FlxSprite;
		private var bgTiles:FlxTilemap;
		private var bgDarkener:FlxSprite;
		private var notifyKong:Boolean;
		private var kongLoaded:Boolean;
		
		private var gfxText:FlxText;
		
		public function MenuState():void
		{
			if (FlxG.userData.menumusic == null)
			{
				FlxG.userData.menumusic = FlxG.play(Assets.Music1, 1, true);
				FlxG.userData.menumusic.survive = true;
			}
			else
			{
				FlxG.userData.menumusic.play();
			}
			switching = false;
			
			floatingIsland = new FlxSprite( -100, 20, Assets.LevelOverworld);
			floatingIsland.velocity.x = 30;
			floatingIsland.scale = new Point(0.64, 0.64);
			
			bgDarkener = new FlxSprite();
			bgDarkener.createGraphic(FlxG.width, FlxG.height, 0x66000000);
			
			bgTiles = new FlxTilemap();
			var map:String = "";
			for (var ex:uint = 0; ex < FlxG.width/20*FlxG.height/20+FlxG.width/20; ex++)
			{
				map += String(Math.floor(Math.random() * 2 + 0.5));
				if ((ex % (FlxG.width/20)) == 0)
				{
					map += "\n";
				}
				else
				{
					map += ",";
				}
			}
			bgTiles.drawIndex = bgTiles.startingIndex = 0;
			bgTiles.loadMap(map, Assets.ImgClouds, 20);
			
			text1 = new FlxText( -180, FlxG.height / 3 - 10, 200, "Great Dungeon");
			text1.size = 16;
			text2 = new FlxText( -400, FlxG.height / 2 - 10, 200, "in the Sky");
			text2.size = 16;
			
			buttonNew = new FlxButton(FlxG.width - 90, FlxG.height -15, toNewGame);
			buttonNew.loadGraphic(Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xff0000aa), Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xff0000ff));
			var newText:FlxText = new FlxText( 7, -3, 80, "Reset progress");
			newText.size = 8;
			newText.antialiasing = false;
			buttonNew.loadText(newText);
			
			buttonGfx = new FlxButton(FlxG.width - 90, FlxG.height - 45, toggleGfx);
			buttonGfx.loadGraphic(Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xffaaaa00), Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xffffff00));
			gfxText = new FlxText( 7, -3, 90, "HD Graphics " + (FlxG.userData.gfx?"ON":"OFF"));
			gfxText.size = 8;
			gfxText.antialiasing = false;
			buttonGfx.loadText(gfxText);
			
			buttonContinue = new FlxButton(FlxG.width * 1 / 3 - 30, FlxG.height * 4 / 6, toContinue);
			buttonContinue.loadGraphic(Helper.Scale(Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xffaa0000), new Point(3,3)), Helper.Scale(Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xffff0000), new Point(3.5,3.5)));
			var conText:FlxText = new FlxText( -5, 30, 70, "Continue\n Press X");
			conText.antialiasing = false;
			buttonContinue.loadText(conText);
			
			buttonCredits = new FlxButton(FlxG.width * 2 / 3 - 30, FlxG.height * 4 / 6, toCredits);
			buttonCredits.loadGraphic(Helper.Scale(Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xff00aa00), new Point(3,3)), Helper.Scale(Helper.Color(new FlxSprite(0, 0, Assets.ImgButton), 0xff00ff00), new Point(3.5,3.5)));
			var credText:FlxText = new FlxText( -5, 30, 70, "Credits\nPress C");
			credText.antialiasing = false;
			buttonCredits.loadText(credText);
			
			FlxG.showCursor(Assets.ImgCursor);
			
			this.add(bgTiles);
			this.add(bgDarkener);
			this.add(text1);
			this.add(floatingIsland);
			this.add(text2);
			this.add(buttonNew);
			this.add(buttonContinue);
			this.add(buttonCredits);
			
			if(FlxG.FlxSave.data.gfxallowed)
				this.add(buttonGfx);
				
			//kongLoaded = true;
		}
		
		public override function update():void
		{
			if (!kongLoaded)
			{
				FlxG.kong = new FlxKong();
				this.addChild(FlxG.kong);
				FlxG.kong.init();
				kongLoaded = true;
			}
			if (!notifyKong && FlxG.kong != null && FlxG.kong.API != null)
			{
				this.add(new Notify(FlxG.kong.API.services.getUsername() + " is logged in to Kongregate"));
				
				//send stats here
				if (FlxG.FlxSave.data.gfxallowed)
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
				notifyKong = true;
			}
			if (text1.x < 80)
			{
				text1.x += 2;
			}
			
			if (text2.x < 150)
			{
				text2.x += 4;
			}
			
			if (floatingIsland.x > FlxG.width)
			{
				floatingIsland.x = -floatingIsland.width;
			}
			
			//if (FlxG.keys.justPressed("Z"))
			//{
			//	toNewGame();
			//}
			if (FlxG.keys.justPressed("X"))
			{
				toContinue();
			}
			if (FlxG.keys.F2 && FlxG.keys.CONTROL)
			{
				this.add(buttonGfx);
			}
			if (FlxG.keys.justPressed("C"))
			{
				toCredits();
			}
			
			super.update();
		}
		
		public function toNewGame():void
		{
			FlxG.play(Assets.SndOkay);
			FlxG.FlxSave.data.charUnlocks = null;
			FlxG.fade(0xff000000, 1,
			function():void
			{
				World.newGame();
				FlxG.flash(0xffffffff, 0.2, null, true);
				FlxG.switchState(OverworldState);
			}, false);
		}
		
		public function toContinue():void
		{
			FlxG.play(Assets.SndOkay);
			//for (var a:int = 0; a < 400; a++)
				//FlxG.FlxSave.data.charUnlocks[a] = 1;
			FlxG.fade(0xff000000, 1,
			function():void
			{
				World.loadGame();
				FlxG.flash(0xffffffff, 0.2, null, true);
				FlxG.switchState(OverworldState);
			}, false);
		}
		
		public function toCredits():void
		{
			FlxG.play(Assets.SndOkay);
			FlxG.fade(0xff000000, 1,
			function():void
			{
				FlxG.flash(0xffffffff, 0.2, null, true);
				FlxG.switchState(CreditsState);
			}, false);
		}
		
		public function toggleGfx():void
		{
			if (FlxG.userData.gfx)
			{
				FlxG.userData.gfx = !FlxG.userData.gfx;
			}
			else
			{
				FlxG.userData.gfx = true;
			}
			gfxText.text = "HD Graphics " + (FlxG.userData.gfx?"ON":"OFF");
		}
	}
}