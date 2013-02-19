package sky.char
{
	import org.flixel.*;
	import sky.state.LevelState;

	public class Ayai
	{
		public static var attack:Function = function(context:LevelState):void
		{
			if (this.target != null && !this.target.dead)
			{
				var visible:Boolean = true;
				if (canSee.call(this, context, this.target) == -1)
				{
					this.actiont--;
					visible = false;
				}
				else
				{
					this.actiont = 100;
				}
				if (this.actiont <= 0)
				{
					this.target = null;
					this.ai = wanderAgro;
					return;
				}
				var dirToTarget:uint = (((this.x - this.target.x) / -Math.abs(this.x - this.target.x))+1)/2;
				this.facing = dirToTarget;
				var disToTarget:uint = Math.abs(this.x - this.target.x);
				if (disToTarget <= 16 && this.charTraits["melee"].length > 0)
				{
					if (this.attackCool == 0 && visible)
					{
						switch(FlxG.getRandom(this.charTraits["melee"]))
						{
							case 1:
								this.attack1();
								break;
							case 2:
								this.attack2();
								break;
							case 3:
								this.attack3();
								break;
							default:
								break;
						}
						this.attackCool += 1;
					}
				}
				if (disToTarget > 16)
				{
					if (disToTarget < 64 && this.charTraits["range"].length > 0)
					{
						if (this.attackCool == 0)
						{
							switch(FlxG.getRandom(this.charTraits["range"]))
							{
								case 1:
									this.attack1();
									break;
								case 2:
									this.attack2();
									break;
								case 3:
									this.attack3();
									break;
								default:
									break;
							}
							this.attackCool += 1;
						}					
					}
					if((this.charTraits["melee"].length > 0 && disToTarget > 8) || disToTarget > 64)
					{
						if (dirToTarget == 0)
						{
							this.moveLeft(100);
							if (context.level.overlapsPoint(this.x - 5, this.y))
							{
								this.jump();
							}
						}
						else if(dirToTarget == 1)
						{
							this.moveRight(100);
							if (context.level.overlapsPoint(this.x + this.width + 5, this.y))
							{
								this.jump();
							}
						}
					}
				}
			}
			else
			{
				this.target = null;
				this.ai = wanderAgro;
			}
		}
		
		public static var runAway:Function = function(context:LevelState):void
		{
			if (this.target != null && !this.target.dead)
			{
				var visible:Boolean = true;
				if (canSee.call(this, context, this.target) == -1)
				{
					this.actiont--;
					visible = false;
				}
				else
				{
					this.actiont = 300;
				}
				if (this.actiont <= 0)
				{
					this.target = null;
					this.ai = wanderRun;
					return;
				}
				var dirToTarget:uint = (((this.x - this.target.x) / -Math.abs(this.x - this.target.x))+1)/2;
				var disToTarget:uint = Math.abs(this.x - this.target.x);
				if(disToTarget < 100)
				{
					if (dirToTarget == 1)
					{
						this.moveLeft(100);
						if (context.level.overlapsPoint(this.x - 5, this.y) || (this.charTraits["flying"] && Math.random()<0.1))
						{
							this.jump();
						}
					}
					else if(dirToTarget == 0)
					{
						this.moveRight(100);
						if (context.level.overlapsPoint(this.x + this.width + 5, this.y) || (this.charTraits["flying"] && Math.random()<0.1))
						{
							this.jump();
						}
					}
				}
			}
			else
			{
				this.target = null;
				this.ai = wanderRun;
			}
		}	
		
		public static var wanderAgro:Function = function(context:LevelState):void
		{
			var dist:int = -1;
			var closeDist:uint = 9000;
			var closest:Character = null;
			if (this is Enemy)
			{
				for each(var c:Character in context.allies)
				{
					dist = canSee.call(this, context, c);
					if (dist != -1 && dist < closeDist)
					{
						closest = c;
						closeDist = dist;
					}
				}
				dist = canSee.call(this, context, context.player);
				if (dist != -1 && dist < closeDist)
				{
					closest = context.player;
					closeDist = dist;
				}
			}
			else if (this is Ally)
			{
				for each(c in context.enemies)
				{
					dist = canSee.call(this, context, c);
					if (dist != -1 && dist < closeDist)
					{
						closest = c;
						closeDist = dist;
					}
				}
			}
			if (closest != null)
			{
				this.target = closest;
				this.ai = attack;
				this.actiont = 100;
			}
			wander.call(this, context);
		}
		
		public static var wanderRun:Function = function(context:LevelState):void
		{
			var dist:int = -1;
			var closeDist:uint = 9000;
			var closest:Character = null;
			if (this is Enemy)
			{
				for each(var c:Character in context.allies)
				{
					dist = canSee.call(this, context, c);
					if (dist != -1 && dist < closeDist)
					{
						closest = c;
						closeDist = dist;
					}
				}
				dist = canSee.call(this, context, context.player);
				if (dist != -1 && dist < closeDist)
				{
					closest = context.player;
					closeDist = dist;
				}
			}
			else if (this is Ally)
			{
				for each(c in context.enemies)
				{
					dist = canSee.call(this, context, c);
					if (dist != -1 && dist < closeDist)
					{
						closest = c;
						closeDist = dist;
					}
				}
			}
			if (closest != null)
			{
				this.target = closest;
				this.ai = runAway;
				this.actiont = 300;
			}
			wander.call(this, context);
		}
		
		public static var wander:Function = function(context:LevelState):void
		{
			if (this.action == null || this.actiont == 0)
			{
				this.actiont = Math.random() * 50 + 10;
				switch(Math.floor(Math.random() * 3))
				{
					case 0:
						this.action = "walkleft";
						break;
					case 1:
						this.action = "walkright";
						break;
					default:
						this.action = "stand";
						break;
				}
			}
			this.actiont--;
			switch(this.action)
			{
				case "walkleft":
					if (context.level.overlapsPoint(this.x - 5, this.y + this.height + 3))
						this.moveLeft(30);
					break;
				case "walkright":
					if (context.level.overlapsPoint(this.x + this.width + 5, this.y + this.height + 3))
						this.moveRight(30);
					break;
				case "stand":
				default:
					break;
			}
		}
		
		public static var canSee:Function = function(context:LevelState, char:Character):int
		{
			if ((char.statuses & 0x01000000) == 0x01000000) return -1; //invisible
			if ((this.statuses & 0x00010000) == 0x00010000) return -1; //blinded
			
			var thisX:int = Math.floor(this.x / 16);
			var thatX:int = Math.floor(char.x / 16);
			if (Math.floor(this.y / 16) == Math.floor(char.y / 16) && ((thisX - thatX) / -Math.abs(thisX - thatX) + 1) / 2 == this.facing)
			{
				for (var x:int = thisX; (x != thatX) && (x != thisX+(this.charTraits["visibility"]*(thisX - thatX) / Math.abs(thisX - thatX))); x -= (thisX - thatX) / Math.abs(thisX - thatX))
				{
					if (context.level.getTile(x, Math.floor(this.y / 16)) >= context.level.collideIndex)
					{
						return -1;
					}
				}
			}
			else
			{
				return -1;
			}
			
			return Math.abs(thisX-thatX);
		}
	}
}