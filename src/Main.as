package
{
	import org.flixel.*;
	import org.flixel.data.FlxKong;
	import sky.state.*;
	import sky.char.*;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
		
	/**
	 * ...
	 * @author Lord Tim
	 */
	public class Main extends FlxGame
	{
		public function Main():void
		{
			super(320, 240, MenuState, 2);
			this.setLogoFX(0xff880000);
			//this.help("Attack", "Magicks", "Nothing", "Move");
			CharFactory.Initialize();
			FlxG.randomize(new Date().getTime());
		}
	}
}

//TODO: Give attacks to all characters
//TODO: Give traits to all characters
//TODO: Redo main screen
//TODO: melee damage
//TODO: item attacks (limited ammo)
//TODO: add character stats to select screen
//TODO: create new levels
//TODO: level selection?
//TODO: enemy placement in levels
//TODO: make pause menu look better
//TODO: preloader
//TODO: make magic not kickback
//TODO: attack icons
//TODO: unlocking characters
//TODO: bosses
//TODO: enemy ai
//TODO: endgame
//TODO: begingame