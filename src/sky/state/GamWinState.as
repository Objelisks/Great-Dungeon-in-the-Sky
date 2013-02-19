package sky.state
{
	import org.flixel.*;
	
	public class GamWinState extends FlxState
	{
		private var text1:FlxText;
		private var text2:FlxText;
		private var switching:Boolean;

		public function GamWinState():void
		{
			FlxG.FlxSave.data.gfxallowed = true;
			FlxG.FlxSave.data.unlocks++;
			FlxG.FlxSave.flush();
			switching = false;
			
			text1 = new FlxText(0, FlxG.height * 1 / 6 - 10, FlxG.width,
			"Gratz man. You won the game. That is totally rad.\n" +
			"But for replayability's sake, you still have to \n" +
			"unlock all the characters to really win. Amirite? \n" +
			"For beating the game, you recieve one free unlock, \n" +
			"which can be used in the character selection screen\n" +
			"An additional graphics option has been added to the main menu");
			text1.alignment = "center";
			
			text2 = new FlxText(0, 5 * FlxG.height / 6 - 10, FlxG.width, "Press X or C to start a new game with your unlocked characters");
			text2.alignment = "center";
			
			this.add(text1);
			this.add(text2);
			
			if (FlxG.kong)
			{
				FlxG.kong.API.stats.submit("killedtheboss", 1);
				FlxG.kong.API.stats.submit("worldsfinished", 1);
			}
		}
		
		public override function update():void
		{
			if (!switching && (FlxG.keys.pressed("X") || FlxG.keys.pressed("C")))
			{
				switching = true;
				FlxG.fade(0xff000000, 1, function():void { FlxG.flash(0xffffffff, 0.2, null, true); FlxG.switchState(MenuState); }, true);
			}
			
			super.update();
		}
	}
}

/*
Assets used:
oryx + oddball: character sprites
oryx: character portraits
oryx: menu interface stuff
arachne: tilesets
effects: yokomeshi
particles: lolzapricot
hideous: cat
*/