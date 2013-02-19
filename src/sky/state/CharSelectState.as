package sky.state
{
	import org.flixel.*;
	import sky.char.*;
	import sky.helper.*;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class CharSelectState extends FlxState
	{
		private var bgDarkener:FlxSprite;
		private var portraitSprite:FlxSprite;
		private var locked:BitmapData;
		private var highlight:BitmapData;
		private var characterSprites:FlxSprite;
		private var char2tile:FlxSprite;
		private var char4tile1:FlxSprite;
		private var char4tile2:FlxSprite;
		private var portraitSprites:FlxSprite;
		private var title:FlxText;
		private var currentSelection:uint;
		private var lockedText:FlxText;
		private var continueText:FlxText;
		private var charNameText:FlxText;
		private var charTraitText:FlxText;
		private var charAttackText:FlxText;
		private var charNames:Array;
		private var transition:Boolean;
		private var charBg:FlxSprite;
		private var unlocksAvail:FlxText;
		private var refresh:Boolean;
		private var unlockCount:FlxText;

		public function CharSelectState():void
		{
			refresh = false;
			transition = false;
			currentSelection = 0;
			characterSprites = new FlxSprite(FlxG.width * 3 / 5, FlxG.height * 1 / 3);
			characterSprites.loadGraphic(Assets.ImgCharacters, true, false, 8, 8);
			characterSprites.scale = new Point(4, 4);
			char2tile = new FlxSprite(characterSprites.x + 32, characterSprites.y);
			char2tile.loadGraphic(Assets.ImgCharacters, true, false, 8, 8);
			char2tile.scale = new Point(4, 4);
			char4tile1 = new FlxSprite(characterSprites.x, characterSprites.y + 32);
			char4tile1.loadGraphic(Assets.ImgCharacters, true, false, 8, 8);
			char4tile1.scale = new Point(4, 4);
			char4tile2 = new FlxSprite(characterSprites.x + 32, characterSprites.y + 32);
			char4tile2.loadGraphic(Assets.ImgCharacters, true, false, 8, 8);
			char4tile2.scale = new Point(4, 4);
			char2tile.visible = false;
			char4tile1.visible = false;
			char4tile2.visible = false;
			
			var portraits:BitmapData = FlxG.addBitmap(Assets.ImgPortraits);
			
			portraitSprites = new FlxSprite(8 + (currentSelection % 16) * 8 + 8, 8 + Math.floor(currentSelection / 16) * 8 + 8);
			var temp:BitmapData = new BitmapData(portraits.width, portraits.height, true, 0xff000000);
			temp.copyPixels(portraits, new Rectangle(0, 0, portraits.width, portraits.height), new Point());
			portraitSprites.loadBitmap(temp, true, false, 8, 8);
			
			portraitSprites.scale = new Point(2, 2);
			
			bgDarkener = new FlxSprite();
			bgDarkener.createGraphic(FlxG.width, FlxG.height, 0x44000000);
			locked = FlxG.addBitmap(Assets.ImgLocked);
			highlight = FlxG.addBitmap(Assets.ImgHighlight);
			lockedText = new FlxText(FlxG.width * 3 / 5, FlxG.height * 1 / 3, 100, "Locked");
			lockedText.size = 16;
			lockedText.visible = false;
			
			continueText = new FlxText(FlxG.width * 4 / 5 - 50, FlxG.height - 11, 100, "Press X to continue");
			
			unlocksAvail = new FlxText(5, FlxG.height - 22, 200, ((FlxG.FlxSave.data.unlocks as uint) > 0?"Press C to unlock a character":"") + "\nUnlocks available: " + String(FlxG.FlxSave.data.unlocks as uint));
			//unlocksAvail.visible = (FlxG.FlxSave.data.unlocks as uint) > 0;
			
			portraitSprite = new FlxSprite(16, 16, null);
			portraitSprite.loadBitmap(temp, false, false, portraits.width, portraits.height);
			
			if (FlxG.FlxSave.data.charUnlocks == null)
			{
				FlxG.FlxSave.data.charUnlocks = new Array();
				for (var a:int = 0; a < 32; a++)
					FlxG.FlxSave.data.charUnlocks[a] = 1;
			}
			
			for (var ic:uint = 0; ic < 400; ic++)
			{
				if (Assets.nexttwo.indexOf(ic) != -1 || Assets.underfour.indexOf(ic) != -1)
				{
					continue;
				}
				if (FlxG.FlxSave.data.charUnlocks[ic] == null)
				{
					portraitSprite.pixels.copyPixels(locked, new Rectangle(0, 0, 8, 8), new Point((ic % 16) * 8, Math.floor(ic / 16) * 8));
					if (Assets.twotile.indexOf(ic) != -1)
					{
						portraitSprite.pixels.copyPixels(locked, new Rectangle(0, 0, 8, 8), new Point(((ic+1) % 16) * 8, Math.floor((ic+1) / 16) * 8));
					}
					if (Assets.fourtile.indexOf(ic) != -1)
					{
						portraitSprite.pixels.copyPixels(locked, new Rectangle(0, 0, 8, 8), new Point(((ic+1) % 16) * 8, Math.floor((ic+1) / 16) * 8));
						portraitSprite.pixels.copyPixels(locked, new Rectangle(0, 0, 8, 8), new Point(((ic+16) % 16) * 8, Math.floor((ic+16) / 16) * 8));
						portraitSprite.pixels.copyPixels(locked, new Rectangle(0, 0, 8, 8), new Point(((ic+17) % 16) * 8, Math.floor((ic+17) / 16) * 8));
					}
				}
				else
				{
					if (FlxG.userData.justUnlocked && FlxG.userData.justUnlocked[ic])
					{
						portraitSprite.pixels.copyPixels(highlight, new Rectangle(0, 0, 8, 8), new Point((ic % 16) * 8, Math.floor(ic / 16) * 8), highlight, new Point(), true);
					}
				}
			}
			portraitSprite.pixels = portraitSprite.pixels;
			FlxG.userData.justUnlocked = new Array();
			
			title = new FlxText(FlxG.width * 2 / 5, 5, 200, "Character\n  Selection");
			title.color = 0xff000000 | (Math.random() * (0x00ffffff - 0x00666666) + 0x00666666);
			title.alignment = "center";
			title.size = 16;
			
			//charNames = ((String)(new Assets.TxtCharNames)).split("\n");
			
			charNameText = new FlxText(FlxG.width * 3 / 5, FlxG.height * 1 / 5, 200, CharFactory.charData[1].name);
			charTraitText = new FlxText(FlxG.width * 5 / 6 - 20, FlxG.height - 95, 200, "Traits:\n");
			charTraitText.text = "Health: " + CharFactory.charData[currentSelection + 1]["maxhealth"] + "\n\n" + "Traits:\n" +
											(CharFactory.charData[currentSelection + 1]["flying"]?"Flying\n":"") +
											(CharFactory.charData[currentSelection + 1]["nocombat"]?"No combat\n":"") +
											(CharFactory.charData[currentSelection + 1]["movespeed"] < 1000?"Slow\n":"") +
											(CharFactory.charData[currentSelection + 1]["movespeed"] > 1000?"Fast\n":"") +
											(CharFactory.charData[currentSelection + 1]["strongtofire"]?"Strong vs fire\n":"") +
											(CharFactory.charData[currentSelection + 1]["strongtoice"]?"Strong vs ice\n":"") +
											(CharFactory.charData[currentSelection + 1]["strongtoshock"]?"Strong vs shock\n":"") +
											(CharFactory.charData[currentSelection + 1]["strongtolight"]?"Strong vs light\n":"") +
											(CharFactory.charData[currentSelection + 1]["strongtodark"]?"Strong vs dark\n":"") +
											(CharFactory.charData[currentSelection + 1]["strongtopoison"]?"Strong vs poison\n":"") +
											(CharFactory.charData[currentSelection + 1]["weaktofire"]?"Weak vs fire\n":"") +
											(CharFactory.charData[currentSelection + 1]["weaktoice"]?"Weak vs ice\n":"") +
											(CharFactory.charData[currentSelection + 1]["weaktoshock"]?"Weak vs shock\n":"") +
											(CharFactory.charData[currentSelection + 1]["weaktolight"]?"Weak vs light\n":"") +
											(CharFactory.charData[currentSelection + 1]["weaktodark"]?"Weak vs dark\n":"") +
											(CharFactory.charData[currentSelection + 1]["weaktopoison"]?"Weak vs poison\n":"");
			charAttackText = new FlxText(FlxG.width * 3 / 6, FlxG.height - 95, 200, "Attacks:\n" + CharFactory.charData[1].attack1.name + "\n" + CharFactory.charData[1].attack2.name + "\n" + CharFactory.charData[1].attack3.name);
			charBg = new FlxSprite(155, 0);
			charBg.createGraphic(150, FlxG.height, 0xff000000 | Helper.darken(title.color,0.4));
			
			var count:uint = 0;
			FlxG.FlxSave.data.charUnlocks.forEach(function(item:uint, index:uint, array:Array):void { if (item == 1) count++; } );
			unlockCount = new FlxText(1, 1, 100, "Unlocked: " + count);
			
			add(portraitSprite);
			add(bgDarkener);
			add(charBg);
			add(title);
			add(portraitSprites);
			add(characterSprites);
			add(char2tile);
			add(char4tile1);
			add(char4tile2);
			add(lockedText);
			add(continueText);
			add(unlocksAvail);
			add(charNameText);
			add(charTraitText);
			add(charAttackText);
			add(unlockCount);
			
			if (FlxG.userData.charId)
			{
				currentSelection = FlxG.userData.charId-1;
				refresh = true;
			}
		}
		
		public override function update():void
		{
			if (!transition && FlxG.keys.justPressed("LEFT") && currentSelection > 0)
			{
				currentSelection--;
				refresh = true;
			}
			if (!transition && FlxG.keys.justPressed("RIGHT") && currentSelection < 399)
			{
				if (Assets.twotile.indexOf(currentSelection) != -1 && currentSelection < 398)
				{
					currentSelection += 2;
				}
				else if (Assets.fourtile.indexOf(currentSelection) != -1)
				{
					if (currentSelection < 382)
					{
						currentSelection += 18;
					}
					else if (currentSelection < 384)
					{
						currentSelection += 2;
					}
				}
				else
				{
					currentSelection++;
				}
				refresh = true;
			}
			if (!transition && FlxG.keys.justPressed("UP") && currentSelection > 15)
			{
				currentSelection -= 16;
				refresh = true;
			}
			if (!transition && FlxG.keys.justPressed("DOWN") && currentSelection < 384)
			{
				if (Assets.twotile.indexOf(currentSelection) != -1 || Assets.fourtile.indexOf(currentSelection) != -1 && currentSelection < 368)
				{
					currentSelection += 32;
				}
				else
				{
					currentSelection += 16;
				}
				refresh = true;
			}
			//TODO: Implement free unlock
			if (!transition && FlxG.keys.justPressed("X") && continueText.visible)
			{
				FlxG.play(Assets.SndOkay);
				transition = true;
				FlxG.userData.charId = currentSelection+1;
				FlxG.fade(0xff000000, 1, function():void { FlxG.flash(0xffffffff, 0.2, null, true); FlxG.switchState(LevelState); }, false);
			}
			if (!transition && FlxG.keys.justPressed("C") && !continueText.visible && (FlxG.FlxSave.data.unlocks as uint) > 0)
			{
				if (Unlocker.unlock(currentSelection))
				{
					FlxG.play(Assets.SndOkay);
					//FlxG.FlxSave.data.charUnlocks[currentSelection] = 1;
					FlxG.FlxSave.data.unlocks--;
					FlxG.flash(0xffffffff, 0.6, function():void { FlxG.switchState(CreditsState); FlxG.switchState(CharSelectState); }, true);
				}
			}
			
			/*if (!transition && FlxG.keys.justPressed("F9") && continueText.visible)
			{
				FlxG.play(Assets.SndOkay);
				transition = true;
				FlxG.userData.charId = currentSelection+1;
				FlxG.fade(0xff000000, 1, function():void { FlxG.flash(0xffffffff, 0.2, null, true); FlxG.switchState(LevelEditState); }, false);
			}*/
			
			if (refresh)
			{
				if (Assets.underfour.indexOf(currentSelection) != -1)
				{
					currentSelection -= 16;
				}
				if (Assets.nexttwo.indexOf(currentSelection) != -1)
				{
					currentSelection--;
				}
				portraitSprites.specificFrame(currentSelection);
				portraitSprites.x = 8 + (currentSelection % 16) * 8 + 8;
				portraitSprites.y = 8 + Math.floor(currentSelection / 16) * 8 + 8;
				charNameText.text = CharFactory.charData[currentSelection + 1].name;// + " " + (currentSelection + 1);
				charTraitText.text = "Health: " + CharFactory.charData[currentSelection + 1]["maxhealth"] + "\n\n" + "Traits:\n" +
									(CharFactory.charData[currentSelection + 1]["flying"]?"Flying\n":"") +
									(CharFactory.charData[currentSelection + 1]["nocombat"]?"No combat\n":"") +
									(CharFactory.charData[currentSelection + 1]["movespeed"] < 1000?"Slow\n":"") +
									(CharFactory.charData[currentSelection + 1]["movespeed"] > 1000?"Fast\n":"") +
									(CharFactory.charData[currentSelection + 1]["strongtofire"]?"Strong vs fire\n":"") +
									(CharFactory.charData[currentSelection + 1]["strongtoice"]?"Strong vs ice\n":"") +
									(CharFactory.charData[currentSelection + 1]["strongtoshock"]?"Strong vs shock\n":"") +
									(CharFactory.charData[currentSelection + 1]["strongtolight"]?"Strong vs light\n":"") +
									(CharFactory.charData[currentSelection + 1]["strongtodark"]?"Strong vs dark\n":"") +
									(CharFactory.charData[currentSelection + 1]["strongtopoison"]?"Strong vs poison\n":"") +
									(CharFactory.charData[currentSelection + 1]["weaktofire"]?"Weak vs fire\n":"") +
									(CharFactory.charData[currentSelection + 1]["weaktoice"]?"Weak vs ice\n":"") +
									(CharFactory.charData[currentSelection + 1]["weaktoshock"]?"Weak vs shock\n":"") +
									(CharFactory.charData[currentSelection + 1]["weaktolight"]?"Weak vs light\n":"") +
									(CharFactory.charData[currentSelection + 1]["weaktodark"]?"Weak vs dark\n":"") +
									(CharFactory.charData[currentSelection + 1]["weaktopoison"]?"Weak vs poison\n":"");
				charAttackText.text = "Attacks:\n" +
									(CharFactory.charData[currentSelection + 1].attack1 == null?"None":CharFactory.charData[currentSelection + 1].attack1.name) + "\n" +
									(CharFactory.charData[currentSelection + 1].attack2 == null?"None":CharFactory.charData[currentSelection + 1].attack2.name) + "\n" +
									(CharFactory.charData[currentSelection + 1].attack3 == null?"None":CharFactory.charData[currentSelection + 1].attack3.name);
				if (FlxG.FlxSave.data.charUnlocks[currentSelection] == null)
				{
					characterSprites.visible = false;
					char2tile.visible = false;
					char4tile1.visible = false;
					char4tile2.visible = false;
					lockedText.visible = true;
					continueText.visible = false;
					charNameText.visible = false;
					charAttackText.visible = false;
					charTraitText.visible = false;
				}
				else
				{
					lockedText.visible = false;
					characterSprites.visible = true;
					characterSprites.specificFrame(currentSelection);
					if (Assets.twotile.indexOf(currentSelection) != -1 || Assets.fourtile.indexOf(currentSelection) != -1)
					{
						char2tile.visible = true;
						char2tile.specificFrame(currentSelection + 1);
						if (Assets.fourtile.indexOf(currentSelection) != -1)
						{
							char4tile1.visible = true;
							char4tile1.specificFrame(currentSelection+16);
							char4tile2.visible = true;
							char4tile2.specificFrame(currentSelection + 17);
						}
						else
						{
							char4tile1.visible = false;
							char4tile2.visible = false;
						}
					}
					else
					{
						char2tile.visible = false;
						char4tile1.visible = false;
						char4tile2.visible = false;
					}
					continueText.visible = true;
					charNameText.visible = true;
					charAttackText.visible = true;
					charTraitText.visible = true;
				}
			}
			
			refresh = false;
			super.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
			portraitSprite = null;
		}
	}
}