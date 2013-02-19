package sky.state
{
	import org.flixel.*;
	
	public class CreditsState extends FlxState
	{
		private var text1:FlxText;
		private var text2:FlxText;
		private var switching:Boolean;

		public function CreditsState():void
		{
			switching = false;
			
			text1 = new FlxText(0, FlxG.height * 1 / 6 - 10, FlxG.width,
			"Lord Tim: Awesomeness and also code\n" +
			"oryx + oddball: character sprites\n" +
			"oryx: menu interface stuff\n" +
			"pgil: tilesets" +
			"arachne: tilesets\n" +
			//"craig stern: music\n" +
			"cdk, gurdonark, jaspertine, zikweb: music");
			text1.alignment = "center";
			
			text2 = new FlxText(0, 5 * FlxG.height / 6 - 10, FlxG.width, "Press X or C to go back");
			text2.alignment = "center";
			
			this.add(text1);
			this.add(text2);
		}
		
		public override function update():void
		{
			if (!switching && FlxG.keys.pressed("X") || FlxG.keys.pressed("C"))
			{
				FlxG.play(Assets.SndOkay);
				switching = true;
				FlxG.fade(0xff000000, 1, function():void { FlxG.flash(0xffffffff, 0.2, null, true); FlxG.switchState(MenuState); }, false);
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