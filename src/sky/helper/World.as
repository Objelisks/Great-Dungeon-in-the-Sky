package sky.helper
{
	import flash.geom.Point;
	import org.flixel.*;

	public class World
	{
		// 134 levels
		public static var template:Array = [
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,0,1,1,1,1,1,1,1,1,1,1,0,0],
		[0,0,1,1,1,1,1,1,1,1,1,1,0,0],
		[0,0,0,1,1,1,1,1,1,1,1,0,0,0],
		[0,0,0,1,1,1,1,1,1,1,1,0,0,0],
		[0,0,0,0,1,1,1,1,1,1,0,0,0,0],
		[0,0,0,0,1,1,1,1,1,1,0,0,0,0],
		[0,0,0,0,0,1,1,1,1,0,0,0,0,0],
		[0,0,0,0,0,0,1,1,0,0,0,0,0,0],
		[0,0,0,0,0,0,1,1,0,0,0,0,0,0]
		];
		
		public static var levels:Array = [
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,1,1,1,1,0],
		[0,0,1,1,1,1,1,1,1,1,1,1,0,0],
		[0,0,1,1,1,1,1,1,1,1,1,1,0,0],
		[0,0,0,1,1,1,1,1,1,1,1,0,0,0],
		[0,0,0,1,1,1,1,1,1,1,1,0,0,0],
		[0,0,0,0,1,1,1,1,1,1,0,0,0,0],
		[0,0,0,0,1,1,1,1,1,1,0,0,0,0],
		[0,0,0,0,0,1,1,1,1,0,0,0,0,0],
		[0,0,0,0,0,0,1,1,0,0,0,0,0,0],
		[0,0,0,0,0,0,1,1,0,0,0,0,0,0]
		];
		
		public static var visibility:Array = [
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		];

		
		public static var lastlevel:Point = new Point();
		public static var current:uint = 0;
		public static var randomboss:uint = FlxG.getRandom(Assets.groups[27].members) as uint;
		public static var dragonskilled:uint = 0;
		
		public static function progress():void
		{
			if (levels[lastlevel.y][lastlevel.x] > 1)
			{
				dragonskilled++;
				FlxG.FlxSave.data.dragonskilled = dragonskilled;
			}
			visibility[lastlevel.y][lastlevel.x] = 2;
			
			if(lastlevel.y-1 >= 0 && visibility[lastlevel.y - 1][lastlevel.x] == 0)
				visibility[lastlevel.y - 1][lastlevel.x] = template[lastlevel.y - 1][lastlevel.x];
				
			if(lastlevel.y+1 <= 14 && visibility[lastlevel.y + 1][lastlevel.x] == 0)
				visibility[lastlevel.y + 1][lastlevel.x] = template[lastlevel.y + 1][lastlevel.x];
				
			if(lastlevel.x-1 >= 0 && visibility[lastlevel.y][lastlevel.x - 1] == 0)
				visibility[lastlevel.y][lastlevel.x - 1] = template[lastlevel.y][lastlevel.x - 1];
				
			if(lastlevel.x+1 <= 13 && visibility[lastlevel.y][lastlevel.x + 1] == 0)
				visibility[lastlevel.y][lastlevel.x + 1] = template[lastlevel.y][lastlevel.x + 1];
				
			FlxG.FlxSave.data.visibility = visibility;
			FlxG.FlxSave.flush();
		}
		
		public static function newGame():void
		{
			randomboss = FlxG.getRandom(Assets.groups[27].members) as uint;
			dragonskilled = 0;
			levels = new Array();
			for (var y:uint = 0; y < template.length; y++)
			{
				levels[y] = new Array();
				for (var x:uint = 0; x < template[y].length; x++)
				{
					if (template[y][x] == 1)
					{
						levels[y][x] = 1;
					}
					else
					{
						levels[y][x] = 0;
					}
				}
			}
			var special:uint = 2;
			while (special < 7)
			{
				x = Math.floor(Math.random() * 10 + 3);
				y = Math.floor(Math.random() * 10 + 3);
				if (levels[y][x] == 1)
				{
					levels[y][x] = special++;
				}
			}
			for (var s:uint = 0; s < visibility.length; s++)
			{
				for (var t:uint = 0; t < visibility[s].length; t++)
				{
					visibility[s][t] = 0;
				}
			}
			visibility[1][0] = 1;
			visibility[2][0] = 1;
			lastlevel = new Point(0, 1);
			
			//TODO: save to save
			FlxG.FlxSave.data.levels = levels;
			FlxG.FlxSave.data.visibility = visibility;
			FlxG.FlxSave.data.lastlevelx = lastlevel.x;
			FlxG.FlxSave.data.lastlevely = lastlevel.y;
			FlxG.FlxSave.data.randomboss = randomboss;
			FlxG.FlxSave.data.dragonskilled = dragonskilled;
			FlxG.FlxSave.flush();
		}
		
		public static function loadGame():void
		{
			if (FlxG.FlxSave.data.levels != null)
			{
				levels = FlxG.FlxSave.data.levels;
				visibility = FlxG.FlxSave.data.visibility;
				lastlevel = new Point(FlxG.FlxSave.data.lastlevelx, FlxG.FlxSave.data.lastlevely);
				randomboss = FlxG.FlxSave.data.randomboss;
				dragonskilled = FlxG.FlxSave.data.dragonskilled;
			}
			else
			{
				FlxG.FlxSave.data.unlocks = 0;
				newGame();
			}
		}
	}
}