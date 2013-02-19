package sky.state
{
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import org.flixel.*;
	import sky.char.*;
	import sky.helper.*;
	import sky.combat.Attacks;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class LevelState extends FlxState
	{
		public var player:Player;
		public var dummy:Enemy;
		public var playerHealth:FlxEmitter;
		public var playerHealthIcon:FlxSprite;
		public var level:Level;
		public var bg:FlxTilemap;
		public var bgDarkener:FlxSprite;
		public var attackBox:BitmapData;
		public var attackBoxPos:Array;
		public var attackBoxPaused:Array;
		public var exitEmit:FlxEmitter;
		public var enemies:Array;
		public var allies:Array;
		
		public var pauseMenu:FlxLayer;
		public var pauseText:FlxText;
		public var paused:Boolean;
		public var pauseDarkener:FlxSprite;
		public var pauseMenuText:FlxText;
		public var pauseBtnMenu:FlxButton;
		public var pauseBtnCharSel:FlxButton;
		public var pausimation:Number;
		public var transTime:Number;
		public var pauseAttackText:FlxText;
		
		public var zoom:Number;
		public var btnchselbox:Rectangle;
		public var btnmenubox:Rectangle;
		public var transition:Boolean;
		
		private var _fx:FlxSprite;
		private const _bloom:uint = 8;
		private const _blur:Number = 0.15;
		private var _helper:FlxSprite;
		
		public function LevelState():void
		{
			FlxG.userData.menumusic.fadeOut(2, true);
			switch(Math.floor(Math.random() * 3))
			{
				case 0:
					FlxG.playMusic(Assets.Music2, 0.5);
					break;
				case 1:
					FlxG.playMusic(Assets.Music3, 0.5);
					break;
				case 2:
					FlxG.playMusic(Assets.Music4, 0.5);
					break;
				default:
					break;
			}
			FlxG.music.fadeIn(3);
			zoom = 1;
			
			var map:Class = null;
			if (FlxG.userData.level > 1)
				map = FlxG.getRandom(Assets.arenas) as Class;
			else
				map = FlxG.getRandom(Assets.levels) as Class;
			
			level = new Level();
			level.auto = FlxTilemap.AUTO;
			level.loadMap(new map, Assets.ImgAutoBlue, 16);
			
			//level.collideIndex = 16;
			bg = new FlxTilemap().loadMap(new Assets.Level1, Assets.ImgTilesBlue, 16);
			for (var t:uint = 0; t < level.heightInTiles * level.widthInTiles; t++)
				bg.setTileByIndex(t, Math.random()*5+55);
			bgDarkener = new FlxSprite();
			bgDarkener.createGraphic(FlxG.width, FlxG.height, 0x88000000);
			bgDarkener.scrollFactor = new Point();
			
			attackBox = new BitmapData(10, 10, false, 0x000000);
			attackBox.fillRect(new Rectangle(0, 0, 10, 10), 0xff555555);
			attackBox.fillRect(new Rectangle(1, 1, 8, 8), 0xff000000);
			attackBoxPos = [new Point(15, FlxG.height - 20), new Point(30, FlxG.height - 20), new Point(45, FlxG.height - 20),
							new Point(16, FlxG.height - 19), new Point(31, FlxG.height - 19), new Point(46, FlxG.height - 19)];
			attackBoxPaused = [new Point(15, FlxG.height - 61), new Point(15, FlxG.height - 40), new Point(15, FlxG.height - 20),
							new Point(16, FlxG.height - 60), new Point(16, FlxG.height - 39), new Point(16, FlxG.height - 19)];
			
			enemies = new Array();
			allies = new Array();
			player = new Player(FlxG.userData.charId);
			
			player.x = level.respawn.x;
			player.y = level.respawn.y;
			
			FlxG.follow(player, 1.5);
            FlxG.followAdjust(0.5, 0.1);
            FlxG.followBounds(1, 1, level.width - 1, level.height - 1);
			FlxG.followZoom = 2;
			
			add(bg);
			add(bgDarkener);
			
			for each(var e:Object in level.enemyPlacement)
			{
				var id:uint = 0;
				if (FlxG.userData.level == 6)
					id = World.randomboss;
				else if (FlxG.userData.level > 1)
					id = 257 + (FlxG.userData.level-2) * 2;
				else
					id  = FlxG.getRandom(Assets.groups[e.t].members) as uint;
					
				var enemy:Enemy = new Enemy(id);
				enemy.x = e.p.x;
				enemy.y = e.p.y;
				if (FlxG.userData.level == 6)
					enemy.onDeath = winGam;
				else if (FlxG.userData.level > 1)
					enemy.onDeath = endLevel;
				enemies.push(enemy);
				add(enemy);
			}
			
			add(player);
			add(level);
			
			exitEmit = new FlxEmitter(level.exit.x, level.exit.y, 0.01);
			exitEmit.width = level.exit.width;
			exitEmit.height = level.exit.height;
			exitEmit.minVelocity.y = -20;
			exitEmit.createSprites(Assets.ImgDust, 50, false);
			add(exitEmit);
			
			playerHealthIcon = new FlxSprite(2, 5, null);
			playerHealthIcon.loadGraphic(Assets.ImgHealth, true, false, 5, 5);
			playerHealthIcon.scrollFactor = new Point();
			playerHealth = new FlxEmitter(5, 6,  0.005);
			playerHealth.width = 100;
			playerHealth.height = 4;
			playerHealth.maxVelocity.x = 5;
			playerHealth.scrollFactor = new Point();
			playerHealth.createSprites(Assets.ImgHealthParticle, 100, false);
			add(playerHealthIcon);
			add(playerHealth);
			
			pauseMenu = new FlxLayer();
			pauseMenu.scrollFactor = new Point();
			pauseText = new FlxText(FlxG.width - 50, 10, 100, "Paused");
			pauseText.color = 0xff990000;
			
			var upBtn1:FlxSprite = Helper.Scale(new FlxSprite(0, 0, Assets.ImgButton), new Point(2, 2));
			//upBtn1.color = 0xff0000aa;
			var upBtn2:FlxSprite = Helper.Scale( new FlxSprite(0, 0, Assets.ImgButton), new Point(2, 2));
			//upBtn2.color = 0xff0000ff;
			
			pauseBtnMenu = new FlxButton(FlxG.width * 1 / 8, FlxG.height * 2 / 6,
			function():void
			{
				FlxG.music.fadeOut(2);
				FlxG.userData.menumusic.play();
				FlxG.userData.menumusic.fadeIn(2);
				FlxG.fade(0xff000000, 1,
				function():void
				{
					FlxG.flash(0xffffffff, 0.2, null, true);
					FlxG.switchState(MenuState);
				}, false);
			});
			pauseBtnMenu.scrollFactor = new Point();
			pauseBtnMenu.loadGraphic(upBtn1);
			var mutxt:FlxText = new FlxText(20, 5, 200, "Return to Menu");
			mutxt.size = 8;
			pauseBtnMenu.loadText(mutxt);
			
			pauseBtnCharSel = new FlxButton(FlxG.width * 1 / 8, FlxG.height * 3 / 6,
			function():void
			{
				FlxG.music.fadeOut(2);
				FlxG.userData.menumusic.play();
				FlxG.userData.menumusic.fadeIn(2);
				FlxG.fade(0xff000000, 1,
				function():void
				{
					FlxG.flash(0xffffffff, 0.2, null, true);
					FlxG.switchState(CharSelectState);
				}, false);
			});
			pauseBtnCharSel.scrollFactor = new Point();
			pauseBtnCharSel.loadGraphic(upBtn2);
			var chsetxt:FlxText = new FlxText(20, 5, 200, "Return to Characters");
			chsetxt.size = 8;
			pauseBtnCharSel.loadText(chsetxt);
			
			pauseDarkener = new FlxSprite();
			pauseDarkener.createGraphic(FlxG.width, FlxG.height, 0x88000000);
			pauseAttackText = new FlxText(30, FlxG.height - 62, 200, player.attack1d.name + "\n\n" + player.attack2d.name + "\n\n" + player.attack3d.name);
			pauseAttackText.visible = false;
			pauseMenu.add(pauseDarkener, true);
			pauseMenu.add(pauseText, true);
			pauseMenu.add(pauseBtnMenu, true);
			pauseMenu.add(pauseBtnCharSel, true);
			pauseMenu.add(pauseAttackText, true);
			pauseMenu.visible = false;
			pausimation = 0;
			transTime = 0.5;
			add(pauseMenu);
			//setZoom(2);
			
			
			
			//post process
			
			_helper = new FlxSprite();
			_helper.createGraphic(FlxG.width, FlxG.height, 0xff000000, true);
			//_helper.alpha = _blur;
			
			//This is the sprite we're going to use to help with the light bloom effect
			//First, we're going to initialize it to be a fraction of the screens size
			_fx = new FlxSprite();
			_fx.createGraphic(FlxG.width/_bloom,FlxG.height/_bloom,0,true);
			_fx.origin.x = _fx.origin.y = 0;	//Zero the origin so scaling goes from top-left not center
			_fx.scale.x = _fx.scale.y = _bloom;	//Scale it up to be the same size as the screen again
			_fx.antialiasing = true;			//Set AA to true for maximum blurry
			_fx.color = 0xfffdfd;				//Tint it a little, cuz that looks cool
			_fx.blend = "screen";				//Finally, set blend mode to "screen" (important!)
			//Note that we do not add it to the game state!  It's just a helper, not a real sprite.
			//Then we scale the screen buffer down, so it draws a smaller version of itself
			// into our tiny FX buffer, which is then scaled up.  The net result of this operation
			// is a blurry image that we can render back over the screen buffer to create the bloom.
			screen.scale.x = screen.scale.y = 1/_bloom;
		}
		
		override public function postProcess():void
		{
			super.postProcess();
			
			if (FlxG.userData.gfx)
			{
				_helper.pixels.draw(screen.pixels, new Matrix(), new ColorTransform(0.96, .6, .36, _blur));
				_helper.pixels = _helper.pixels;
				
				screen.fill(0x000000);
				screen.draw(_helper);
				
				//First we draw the contents of the screen onto the tiny FX buffer:
				_fx.draw(screen);
				//Then we draw the scaled-up contents of the FX buffer back onto the screen:
				screen.draw(_fx);
			}
		}
		
		public override function render():void
		{
			super.render();
			if (!paused)
			{
				FlxG.buffer.fillRect(new Rectangle((zoom-1)*FlxG.width / 4 + 5, (zoom-1)*FlxG.height / 4+10, player.attackCool * 20, 3), 0xff0000ff);
			}
			for (var i:uint = 0; i < 3; i++)
			{
				FlxG.buffer.copyPixels(attackBox, new Rectangle(0, 0, 10, 10), pausterpolate(attackBoxPos[i], attackBoxPaused[i], pausimation, transTime));
			}
			FlxG.buffer.copyPixels(player.attack1d.img, new Rectangle(0, 0, 8, 8), pausterpolate(attackBoxPos[3], attackBoxPaused[3], pausimation, transTime), attackBox, new Point(-1,-1), true);
			FlxG.buffer.copyPixels(player.attack2d.img, new Rectangle(0, 0, 8, 8), pausterpolate(attackBoxPos[4], attackBoxPaused[4], pausimation, transTime), attackBox, new Point(-1,-1), true);
			FlxG.buffer.copyPixels(player.attack3d.img, new Rectangle(0, 0, 8, 8), pausterpolate(attackBoxPos[5], attackBoxPaused[5], pausimation, transTime), attackBox, new Point(-1,-1), true);
			if (pausimation == transTime)
			{
				if (!pauseAttackText.visible)
				{
					pauseAttackText.text = player.attack1d.name + "\n\n" + player.attack2d.name + "\n\n" + player.attack3d.name;
					pauseAttackText.visible = true;
				}
			}
			else if(pauseAttackText.visible)
			{
				pauseAttackText.visible = false;
			}
		}
		
		public override function update():void
		{
			if (paused && (pausimation < transTime))
			{
				pausimation += FlxG.elapsed;
				if (pausimation > transTime)
				{
					pausimation = transTime;
				}
			}
			if (!paused && (pausimation > 0))
			{
				pausimation -= FlxG.elapsed;
				if (pausimation < 0)
				{
					pausimation = 0;
				}
			}
			
			if (paused)
			{
				if (FlxG.keys.justPressed("ESC"))
				{
					paused = false;
					pauseMenu.visible = false;
					FlxG.hideCursor();
				}
				/*
				if (FlxG.mouse.justPressed())
				{
					trace(FlxG.mouse.x + " " + FlxG.mouse.y);
					trace(btnmenubox);
					
					if (btnmenubox.contains(FlxG.mouse.x, FlxG.mouse.y))
					{
						trace("click1");
						pauseBtnMenu.on();
					}
					
					if (btnchselbox.contains(FlxG.mouse.x, FlxG.mouse.y))
					{
						pauseBtnCharSel.on();
					}
				}*/
				
			}
			else if (!transition)
			{
				super.update();
				Helper.Update();
				
				//Collision
				for each(var enemy:Enemy in enemies)
				{
					if (!enemy.dead)
					{
						//collisiom
						FlxG.collideArrays(enemy.attacks, player.attacks);
						FlxG.collideArray(player.attacks, enemy);
						FlxG.collideArray(enemy.attacks, player);
						level.collide(enemy);
						level.collideArray(enemy.attacks);
						
						//ai
						if (enemy.ai != null)
						{
							enemy.ai.call(enemy, this);
						}
						
						//allies
						for each(var ally:Ally in allies)
						{
							if (!ally.dead)
							{
								//collisiom
								FlxG.collideArrays(enemy.attacks, ally.attacks);
								FlxG.collideArray(enemy.attacks, ally);
								FlxG.collideArray(ally.attacks,enemy);
								level.collide(ally);
								level.collideArray(ally.attacks);
								
								//ai
								if (ally.ai != null)
								{
									ally.ai.call(ally, this);
								}
							}
						}
					}
				}
				level.collide(player);
				level.collideArray(player.attacks);
				
				if (!transition && player.overlaps(exitEmit))
				{
					endLevel(true);
				}
				if (!transition && player.dead)
				{
					endLevel(false);
				}
				if (FlxG.userData.upgrade != null && FlxG.userData.upgrade == true)
				{
					Attacks.melee["hatch"].attack(player);
					FlxG.userData.upgrade = false;
				}
				
				//Haxxed in collision
				if (player.x > level.width-player.width-2)
				{
					player.x = level.width - player.width - 2;
					player.velocity.x = 0;
				}
				if (player.x < 4)
				{
					player.x = 4;
					player.velocity.x = 0;
				}
				if (player.y < 0)
				{
					player.y = 4;
					player.velocity.y = 0;
				}
				if (player.y > level.height)
				{
					player.reset(level.respawn.x,level.respawn.y);
				}
				
				playerHealth.width = player.health;
				if (player.health < 20)
				{
					playerHealthIcon.specificFrame(0);
				}
				else
				{
					playerHealthIcon.specificFrame(1);
				}
				if (FlxG.keys.justPressed("ESC"))
				{
					paused = true;
					pauseMenu.visible = true;
					FlxG.showCursor(Assets.ImgCursor);
				}
			}
		}
		
		public function winGam():void
		{
			transition = true;
			World.newGame();
			FlxG.fade(0xff000000, 1,
			function():void
			{
				FlxG.flash(0xffffffff, 0.2, null, true);
				FlxG.switchState(GamWinState);
			}, true);
		}
		
		public function endLevel(won:Boolean=false):void
		{
			FlxG.music.fadeOut(2);
			FlxG.userData.menumusic.play();
			FlxG.userData.menumusic.fadeIn(2);
			transition = true;
			if (won)
			{
				World.progress();
				if (player.health > 0) Unlocker.unlock(player.charId - 1);
			}
			FlxG.fade(0xff000000, 1,
			function():void
			{
				FlxG.flash(0xffffffff, 0.2, null, true);
				FlxG.switchState(OverworldState);
			}, true);
		}
		
		private function pausterpolate(p1:Point, p2:Point, time:Number, till:Number):Point
		{
			return new Point(p1.x * (till - time) / till + p2.x * time / till, p1.y * (till - time) / till + p2.y * time / till);
		}
	}
}