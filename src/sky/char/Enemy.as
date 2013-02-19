package sky.char
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.flixel.*;
	import sky.helper.*;

	public class Enemy extends Character
	{
		public var ai:Function;
		public var target:Character;
		public var action:String;
		public var actiont:int;
		
		public function Enemy(id:uint) : void
		{
			super(id);
			health = charTraits["maxhealth"];
			if (charTraits["runs"])
			{
				ai = Ayai.wanderRun;
			}
			else
			{
				ai = Ayai.wanderAgro;
			}
		}
		
		override public function damage(Damage:Number, Type:String = "fgsfds"):void
		{
			super.damage(Damage, Type);
			if (health <= 0)
			{
				var unlock:uint = 0;
				if (Assets.groups[33].members.indexOf(charId) != -1)
					unlock = charId - (32+(charId-257)/2);
				else
					unlock = charId;
				
				Unlocker.unlock(unlock - 1);
				
				if (Assets.groups[26].members.indexOf(FlxG.userData.charId) != -1)
				{
					FlxG.userData.upgrade = true;
				}
				
				if (FlxG.kong) FlxG.kong.API.stats.submit("killed", 1);
			}
		}
	}
}