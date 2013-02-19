package sky.helper
{
	import org.flixel.FlxG;
	import sky.char.CharFactory;
	/**
	 * ...
	 * @author Lord Tim
	 */
	public class Unlocker
	{
		
		public static function unlock(id:uint):Boolean
		{
			if (FlxG.FlxSave.data.charUnlocks[id] != 1)
			{
				var n:Notify = new Notify(CharFactory.charData[id+1].name + " unlocked!");
				FlxG.state.add(n);
				FlxG.FlxSave.data.charUnlocks[id] = 1;
				FlxG.FlxSave.flush();
				if (FlxG.userData.justUnlocked == null)
				{
					FlxG.userData.justUnlocked = new Array();
				}
				FlxG.userData.justUnlocked[id] = true;
				if (FlxG.FlxSave.data.charUnlocks)
				{
					var count:uint = 0;
					FlxG.FlxSave.data.charUnlocks.forEach(function(item:uint, index:uint, array:Array):void { if (item == 1) count++; } );
					if (FlxG.kong)
					{
						FlxG.kong.API.stats.submit("unlocks", count);
						if (count == 316)
						{
							FlxG.kong.API.stats.submit("allunlocked", 1);
						}
					}
				}
				return true;
			}
			else
			{
				return false;
			}
		}
		
	}

}