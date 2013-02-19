package sky.char
{
	import org.flixel.*;
	import sky.combat.*;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CharFactory
	{
		public static var charData:Array;
		
		public static function Initialize() : void
		{
			var assignAttack:Function = function(params:Array):Attack
			{
				switch(params[0])
				{
					case "magic":
						return Attacks.magic[params[1]];
						break;
					case "melee":
						return Attacks.melee[params[1]];
						break;
					case "ranged":
						return Attacks.ranged[params[1]];
						break;
					case "item":
						return Attacks.item[params[1]];
						break;
					default:
						return null;
						break;
				}
			}
			charData = new Array();
			var chartxt:String = new Assets.TxtCharData;
			var chars:Array = chartxt.split(":");
			chars.forEach(
			function(char:String, index:int, array:Array):void
			{
				var lines:Array = char.split("\n");
				var charId:int = int(lines[0]);
				charData[charId] = new Array();
				charData[charId]["range"] = new Array();
				charData[charId]["melee"] = new Array();
				charData[charId].maxhealth = 25;
				lines.slice(1, lines.length).forEach(
				function(line:String, index:int, array:Array):void
				{
					var prop:String = line.substring(0, line.indexOf("="));
					var data:String = line.substr(line.indexOf("=") + 1);
					switch(prop)
					{
						case "name":
							charData[charId].name = data;
							break;
						case "speed":
							charData[charId].movespeed = data;
							break;
						case "health":
							charData[charId].maxhealth = data;
							break;
						case "traits":
							data.split(",").forEach(function(trait:String, index:int, array:Array):void { charData[charId][trait] = true; } );
							break;
						case "attack1":
						case "attack2":
						case "attack3":
							var params:Array = data.split(" ");
							switch(params[0])
							{
								case "none":
									charData[charId][prop] = Attacks.none;
									break;
								case "magic":
									if (params[1].indexOf("summon") == -1)
									{
										charData[charId][prop] = Attacks.magic[params[1]];
										charData[charId]["range"].push(int(prop.charAt(prop.length - 1)));
									}
									else
									{
										charData[charId][prop] = Attacks.magic["summon"];
										charData[charId]["summonid"] = uint(params[1].substring(6))+1;
										//NOTE: Ai won't use summon attacks
									}
									break;
								case "melee":
									charData[charId][prop] = Attacks.melee[params[1]];
									charData[charId]["melee"].push(int(prop.charAt(prop.length - 1)));
									break;
								case "ranged":
									charData[charId][prop] = Attacks.ranged[params[1]];
									charData[charId]["range"].push(int(prop.charAt(prop.length - 1)));
									break;
								case "item":
									charData[charId][prop] = Attacks.item[params[1]];
									charData[charId]["range"].push(int(prop.charAt(prop.length - 1)));
									break;
								default:
									break;
							}
							break;
						default:
							break;
					}
				});
			});
		}
		
		public static function GetCharacter(character:Character, charId:uint) : void
		{
			var width:uint = 8;
			var height:uint = 8;
			if (Assets.twotile.indexOf(charId-1) != -1)
			{
				width = 16;
			}
			else if (Assets.fourtile.indexOf(charId-1) != -1)
			{
				width = 16;
				height = 16;
			}
			
			var img:BitmapData = FlxG.addBitmap(Assets.ImgCharacters, false);
			var sprite:BitmapData = FlxG.createBitmap(width, height, 0, false);
			sprite.copyPixels(img, new Rectangle(0 + ((charId - 1) % 16) * 8, 0 + Math.floor((charId - 1) / 16) * 8, width, height), new Point(0, 0));
			character.loadBitmap(sprite, true, true, width, height);
			
			if (width == 16)
			{
				character.offset.x = 1;
				character.width = 14;
				character.y -= 8;
			}
			
			character.charTraits = charData[charId];
			
			GiveDefaults(character);
		}
		
		public static function GiveDefaults(character:Character):void
		{
			character.attack1d = character.charTraits["attack1"]==null?Attacks.none:character.charTraits["attack1"];
			
			character.attack2d = character.charTraits["attack2"]==null?Attacks.none:character.charTraits["attack2"];
			
			character.attack3d = character.charTraits["attack3"]==null?Attacks.none:character.charTraits["attack3"];
			
			if(character.charTraits["movespeed"]==null)
				character.charTraits["movespeed"] = 1000;
			character.maxVelocity.x = 100 * (character.charTraits["movespeed"] / 1000);
			
			if(character.charTraits["maxhealth"]==null)
				character.charTraits["maxhealth"] = 25;
			character.maxHealth = character.health = character.charTraits["maxhealth"];
			
			if(character.charTraits["visibility"]==null)
				character.charTraits["visibility"] = 7;
			if(character.charTraits["invisible"]!=null)
				character.statuses |= 0x01000000;
		}
	}
}