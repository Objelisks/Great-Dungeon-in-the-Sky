package
{
	import flash.utils.Dictionary;
	import org.flixel.*;
	
	public class Assets
	{
		
		//interface
		[Embed(source = './data/interface/button.png')] public static var ImgButton:Class;
		[Embed(source = './data/interface/cursor.png')] public static var ImgCursor:Class;
		[Embed(source = './data/interface/notify.png')] public static var ImgNotify:Class;
		[Embed(source = './data/interface/pixelblood.png')] public static var ImgHealthParticle:Class;
		[Embed(source = './data/interface/healthicon.png')] public static var ImgHealth:Class;
		[Embed(source = './data/character/locked.png')] public static var ImgLocked:Class;
		[Embed(source = './data/character/highlight.png')] public static var ImgHighlight:Class;
		[Embed(source = './data/interface/lofi_interface_a.png')] public static var ImgInterface:Class;
		[Embed(source = './data/interface/ex.png')] public static var ImgEx:Class;
		[Embed(source = './data/interface/pixelslime.png')] public static var ImgDust:Class;
		
		//sound
		[Embed(source='data/snds/okay.mp3')]public static var SndOkay:Class;
		[Embed(source='data/snds/cdk_-_Look_to_la_Luna_.mp3')]public static var Music1:Class;
		[Embed(source='data/snds/gurdonark_-_Sawmill.mp3')]public static var Music2:Class;
		[Embed(source='data/snds/jaspertine_-_Oscillation.mp3')]public static var Music3:Class;
		[Embed(source='data/snds/zikweb_-_Not_too_quiet.mp3')]public static var Music4:Class;
		/*
		//sound
		[Embed(source = './data/snds/Assemblee 1 - GUIOkaySelection.mp3')] public static var SndOkay:Class;
		[Embed(source = "./data/snds/Craig Stern - The Sorcerer's Tower.mp3")] public static var MusicTower:Class;
		[Embed(source = './data/snds/Frog Story.mp3')] public static var MusicFrog:Class;
		[Embed(source = './data/snds/Matt Wolfe - Golden Zephyr [assemblee compo].mp3')] public static var MusicZephyr:Class;
		[Embed(source = './data/snds/Siminal.mp3')] public static var MusicSiminal:Class;
		*/
		//character
		[Embed(source = './data/character/lofi_char_a.png')] public static var ImgCharacters:Class;
		[Embed(source = './data/character/lofi_portrait_a.png')] public static var ImgPortraits:Class;
		[Embed(source = './data/character/chardata/chardata.txt', mimeType='application/octet-stream')] public static var TxtCharData:Class;
		
		//attacks
		[Embed(source = './data/character/attacks/slash.png')] public static var AttackSlash:Class;
		[Embed(source = './data/character/attacks/exp-s.png')] public static var AttackExplode:Class;
		[Embed(source = './data/character/attacks/attackicon.png')] public static var AttackIcons:Class;
		[Embed(source = './data/character/attacks/blood.png')] public static var AttackBlood:Class;
		[Embed(source = './data/character/attacks/arrow.png')] public static var AttackArrow:Class;
		[Embed(source = './data/character/attacks/bolt.png')] public static var AttackBolt:Class;
		[Embed(source = './data/character/attacks/knife.png')] public static var AttackKnife:Class;
		[Embed(source = './data/character/attacks/rope.png')] public static var AttackRope:Class;
		[Embed(source = './data/character/attacks/bread.png')] public static var AttackBread:Class;
		[Embed(source = './data/character/attacks/net.png')] public static var AttackNet:Class;
		[Embed(source = './data/character/attacks/bomb.png')] public static var AttackBomb:Class;
		[Embed(source = './data/character/attacks/present.png')] public static var AttackPresent:Class;
		
		//tiles
		[Embed(source = './data/scenery/tiles/autobluecast.png')] public static var ImgAutoBlue:Class;
		[Embed(source = './data/scenery/tiles/autogreen.png')] public static var ImgAutoGreen:Class;
		[Embed(source = './data/scenery/tiles/autobrown.png')] public static var ImgAutoBrown:Class;
		[Embed(source = './data/scenery/bluetilesformatted.png')] public static var ImgTilesBlue:Class;
		[Embed(source = './data/scenery/bugtilesbrown.png')] public static var ImgTilesBrown:Class;
		[Embed(source = './data/scenery/bugtilesgreen.png')] public static var ImgTilesGreen:Class;
		[Embed(source = './data/scenery/islandscrn.png')] public static var LevelOverworld:Class;
		[Embed(source = './data/interface/clouds.png')] public static var ImgClouds:Class;
		
		//levels
		[Embed(source = './data/levels/blank.txt', mimeType='application/octet-stream')] public static var LevelBlank:Class;
		[Embed(source = './data/levels/cave2.txt', mimeType = 'application/octet-stream')] public static var Level1:Class;
		[Embed(source = './data/levels/cave3.txt', mimeType = 'application/octet-stream')] public static var Level5:Class;
		[Embed(source = './data/levels/cave1.txt', mimeType = 'application/octet-stream')] public static var Level2:Class;
		[Embed(source = './data/levels/castle1.txt', mimeType = 'application/octet-stream')] public static var Level3:Class;
		[Embed(source = './data/levels/canawhat.txt', mimeType = 'application/octet-stream')] public static var Level4:Class;
		[Embed(source = './data/levels/town1.txt', mimeType = 'application/octet-stream')] public static var Level6:Class;
		[Embed(source = './data/levels/wall1.txt', mimeType = 'application/octet-stream')] public static var Level7:Class;
		[Embed(source = './data/levels/wall2.txt', mimeType = 'application/octet-stream')] public static var Level8:Class;
		[Embed(source = './data/levels/bvg.txt', mimeType = 'application/octet-stream')] public static var Level9:Class;
		[Embed(source = './data/levels/trees.txt', mimeType = 'application/octet-stream')] public static var Level10:Class;
		[Embed(source = './data/levels/boss1.txt', mimeType = 'application/octet-stream')] public static var LevelBoss1:Class;
		[Embed(source = './data/levels/boss2.txt', mimeType = 'application/octet-stream')] public static var LevelBoss2:Class;
		[Embed(source = './data/levels/boss3.txt', mimeType = 'application/octet-stream')] public static var LevelBoss3:Class;
		
		public static var levels:Array = [Level1, Level2, Level3, Level4, Level5, Level6, Level7, Level8, Level9, Level10];
		public static var arenas:Array = [LevelBoss1, LevelBoss2, LevelBoss3];
		
		public static var groups:Array = [ { name:"adventurer", members:[1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32] },
											{name:"town", members:[33,34,35,36,37] },
											{name:"monk", members:[38, 39, 40, 41, 42] },
											{name:"acolyte", members:[43, 44, 45, 46, 47, 48] },
											{name:"elf", members:[49, 50, 51, 52, 53] },
											{name:"high elf", members:[54, 55, 56, 57, 58] },
											{name:"drow", members:[59, 60, 61, 62, 63, 64] },
											{name:"dwarf", members:[65, 66, 67, 68, 69] },
											{name:"deep dwarf", members:[70, 71, 72, 73, 74, 75] },
											{name:"halfling", members:[76, 77, 78, 79, 80] },
											{name:"goblin", members:[81, 82, 83, 84] },
											{name:"orc", members:[85, 86, 87, 88] },
											{name:"clops", members:[89, 90, 91, 134, 135, 136, 137, 138] },
											{name:"gnome", members:[92, 93, 94, 95, 96] },
											{name:"undead", members:[97, 98, 99, 100, 101, 102, 103, 107, 108, 109, 110, 111, 112, 158, 159, 160] },
											{name:"demon", members:[105, 106, 116, 117, 118, 119, 120, 121, 145, 146, 152, 153, 154, 155] },
											{name:"etc", members:[104, 142, 175, 176, 189, 190, 191, 192, 212, 368] },
											{name:"wild", members:[113, 114, 115, 122, 157, 177, 178, 179, 185, 186, 187, 188, 197, 199, 200, 201, 202, 203, 208, 209, 215, 217, 220, 223, 224] },
											{name:"yeti", members:[123, 124, 125, 126, 127, 128] },
											{name:"troll", members:[129, 130, 131, 132, 133] },
											{name:"gremlin", members:[139, 140, 141, 143, 144] },
											{name:"crabman", members:[147, 148, 149] },
											{name:"brain", members:[150, 151, 180, 181, 182] },
											{name:"animal", members:[156, 183, 184, 193, 194, 195, 196, 198, 204, 205, 206, 207, 210, 211, 213, 214, 216, 218, 219, 221, 222, 239, 240] },
											{name:"elemental", members:[161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174] },
											{name:"birdman", members:[235, 236, 237, 238] },
											{name:"dragon", members:[230, 231, 232, 233, 234, 241, 243, 245, 247, 249] },
											{name:"boss", members:[251, 253, 255, 267, 269, 271, 289, 291, 293, 295, 297, 299, 301, 303, 321, 323, 325, 327, 329, 331, 333, 335, 381, 383] },
											{name:"greensquad", members:[353, 354, 355, 356, 357, 358, 359] },
											{name:"bluesquad", members:[360, 361, 362, 363, 364, 365, 366, 367] },
											{name:"alien", members:[369, 370, 371, 372, 373, 374] },
											{name:"bonus", members:[375, 376, 377, 378, 379, 380, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396] },
											{name:"bird", members:[206] },
											{name:"grown", members:[257, 259, 261, 263, 265] }
											]
		public static var twotile:Array = [240, 242, 244, 246, 248, 250, 252, 254];
		public static var fourtile:Array = [256, 258, 260, 262, 264, 266, 268, 270, 288, 290, 292, 294, 296 ,298, 300, 302, 320, 322, 324, 326, 328, 330, 332, 334, 380, 382];
		public static var underfour:Array = [272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 396, 397, 398, 399];
		public static var nexttwo:Array = [241, 243, 245, 247, 249, 251, 253, 255, 257, 259, 261, 263, 265, 267, 269, 271, 289, 291, 293, 295, 297, 299, 301, 303, 321, 323, 325, 327, 329, 331, 333, 335, 381, 383];
	}
}

/*
bug fixes:

(4:39:42 PM) Fletch: why is my character going right constantly?
(4:39:47 PM) Fletch: and can't jump
(4:39:48 PM) ME: He isn't
(4:39:55 PM) ME: You have a broken keyboard
(4:40:06 PM) ME: Any of these various reasons

for (var i:int = 1; i < 50; )
{
	i+=+i+i+++i;
	trace(i);
}
*/