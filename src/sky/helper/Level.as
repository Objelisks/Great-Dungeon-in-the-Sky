package sky.helper
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;

	public class Level extends FlxTilemap
	{	
		public var respawn:Point;
		public var enemyPlacement:Array;
		public var exit:Rectangle;
		
		public function Level():void
		{
			super();
			respawn = new Point(20, 80);
			enemyPlacement = new Array();
			exit = new Rectangle(80, 80, 16, 32);
		}
		
		override public function loadMap(MapData:String, TileGraphic:Class, TileSize:uint = 0):FlxTilemap 
		{
			var Map:String = MapData;
			var line:String = Map.substring(0, Map.indexOf("\n")-1);
			if (line == "levelstart")
			{
				Map = Map.substring(Map.indexOf("\n") + 1);
				line = Map.substring(0, Map.indexOf("\n")-1);
				Map = Map.substring(Map.indexOf("\n") + 1);
				var data:Array = line.split(" ");
				respawn.x = int(data[0]);
				respawn.y = int(data[1]);
				line = Map.substring(0, Map.indexOf("\n")-1);
				Map = Map.substring(Map.indexOf("\n") + 1);
				data = line.split(" ");
				exit.x = int(data[0]);
				exit.y = int(data[1]);
				exit.width = 16;
				exit.height = 32;
				line = Map.substring(0, Map.indexOf("\n")-1);
				Map = Map.substring(Map.indexOf("\n") + 1);
				while (line != "")
				{
					data = line.split(" ");
					enemyPlacement.push( { p:new Point(data[0], data[1]), t:data[2] } );
					line = Map.substring(0, Map.indexOf("\n")-1);
					Map = Map.substring(Map.indexOf("\n") + 1);
				}
			}
			return super.loadMap(Map, TileGraphic, TileSize);
		}
		
		override protected function autoTile(Index:uint):void 
		{
			var up:Boolean = false;
			if(_data[Index] > 16) up = true;
			super.autoTile(Index);
			if (up) { _data[Index] += 16; }
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function overlapsPoint(X:Number, Y:Number, PerPixel:Boolean = false):Boolean 
		{
			return getTile(Math.floor(X/16),Math.floor(Y/16)) >= this.collideIndex;
		}
		
		public function output():void
		{
			var file:String = FlxTilemap.arrayToCSV(_data, widthInTiles);
			trace(file);
		}
	}
}