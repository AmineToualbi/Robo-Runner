
/**
 * ...
 * @author Rich
 */

package 
{

	import dragonBones.events.EventObject;
	import flash.display3D.textures.RectangleTexture;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	//import starling.utils.RectangleUtil;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import flash.ui.Keyboard;
	import starling.events.EnterFrameEvent;
	import starling.geom.Polygon;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.assets.AssetManager;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import starling.utils.Align;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import starling.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	//import flash.display.DisplayObject;
	
	
	public class Level extends Sprite
	{
		private var hero:Hero;
		private var bullets:Array = new Array();
		private var enemies:Array = new Array();
		//private var flap_button:Button;
		//private var flap_button_texture:Texture;
		
		private var obstacle:Obstacle;
		private var map:Map;
		private var projectile:Projectile;
		private var enemy:Enemy;
		private const Stage_Width:int = 1024;
		private const Stage_Height:int = 1024;
		private var n:int = 0;
		private var start_background:Image;
		private var userInput:String; 
		public static var Score:int = 0;
		private var ADown:Boolean = false;
		private var WDown:Boolean = false;
		private var SDown:Boolean = false;
		private var DDown:Boolean = false;
		private var SpaceDown:Boolean = false;
		private var canFire:Boolean = true;
		private var ScoreLabel:TextField;
		//private var newObstacle_Arr:Array = new Array();
		//private var newObstacle_Count:Array = new Array(); 
		//private var obstacle1:Obstacle;
		//private var obstacle2:Obstacle;
		//private var obs1Added:Boolean = false;
		//private var collision:Boolean = false;
		private var blockObstacle:Vector.<Obstacle> = new Vector.<Obstacle>();
		//private var enemyVector:Vector.<Enemy> = new Vector.<Enemy>();
		//private var projVector:Vector.<Projectile> = new Vector.<Projectile>();
		private var heroRec:Rectangle = new Rectangle(0, 0, 140, 140);
		private var enemyRec:Rectangle = new Rectangle(0, 0, 75, 75);
		private var projRec:Rectangle = new Rectangle(0, 0, 10, 10);
		
		public static const GAME_OVER:String = "GAME OVER";
		
		public static var Over: Boolean = false; 
		
		private var HitNbr:int; //Testing purposes.
		private var CollisionNbr:int; //Testing purposes.
		
		private var gameTimer:Timer; 
		
		private var obstacleCount:int = 0;
		private var killCount: int = 0;
		
		public static var credits:int = 55; 
		public static var start:Boolean = false;

		public static const LEFT_BUTTON_PRESSED:String = "LEFT_BUTTON_PRESSED";
		private var left_button:Button;
		private var left_button_texture:Texture;
		public static const RIGHT_BUTTON_PRESSED:String = "RIGHT_BUTTON_PRESSED";
		private var right_button:Button;
		private var right_button_texture:Texture;
		public static const SHOOT_BUTTON_PRESSED:String = "SHOOT_BUTTON_PRESSED";
		private var shoot_button:Button;
		private var shoot_button_texture:Texture;
		
		public function Level() 
		{
			var stage:starling.display.Stage = Starling.current.stage;
			var assets:AssetManager = Main.Assets;
			start_background = new Image(assets.getTexture("start"));
			
			//Create the objects.
			map = new Map();
			hero = new Hero();
			//obstacle = new Obstacle();
			//enemy = new Enemy(); 
			//projectile = new Projectile();
			
			gameTimer = new Timer(1000,0); 
			
			//stage.addEventListener(Event.ENTER_FRAME, Collision_Obstacle);
			// Set the obstacle's initial position
			//obstacle.y = 0; 
			
			//obstacle1 = new Obstacle(); 
			//obstacle2 = new Obstacle(); 

			//Add the objects to the display.
			addChild(map);
			addChild(hero);
			//addChild(enemy);
			//addChild(obstacle);
			
			HitNbr = 0;		//Testing purposes.
			CollisionNbr = 0;	//Testing purposes.
			
			//Score Label. 
			ScoreLabel = new TextField(300, 50, "Score: " + Score);
			ScoreLabel.format.font = "Arial";
			ScoreLabel.format.color = 0xffffff;
			ScoreLabel.format.size = 30;
			ScoreLabel.format.horizontalAlign = Align.LEFT;

			//Add Score label to the display.
			addChild(ScoreLabel);
			
			//buttons
			left_button_texture = assets.getTexture("left");
		    left_button = new Button(left_button_texture);
			right_button_texture = assets.getTexture("right");
		    right_button = new Button(right_button_texture);
			shoot_button_texture = assets.getTexture("shoot");
		    shoot_button = new Button(shoot_button_texture);
			
			// Add an event listener for when the button is pressed
			left_button.addEventListener(Event.TRIGGERED, Left_Button_Pressed);
			right_button.addEventListener(Event.TRIGGERED, Right_Button_Pressed);
			shoot_button.addEventListener(Event.TRIGGERED, Shoot_Button_Pressed);
			
			
			left_button.x = 1050;
			left_button.y = 500;
			right_button.x = 1060 + right_button.width;
			right_button.y = 500;
			shoot_button.x = 1050;
			shoot_button.y = 600;
			
			
			addChild(left_button);
			addChild(right_button);
			addChild(shoot_button);
			
			/*for (var i: int = 0; i < 3; i++) {
				newObstacle_Count[i] = false;
			}*/
			
			// Add keyboard listeners
			// Keyboard Events aren't sent to sprites, 
			// so we have to grab the current stage 
			// and setup the callback to listen on the stage object
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			stage.addEventListener(KeyboardEvent.KEY_UP, On_Key_Up);
			stage.addEventListener(Event.ENTER_FRAME, eFrame);	//Called every frame.
			stage.addEventListener(Event.ENTER_FRAME, startGame);
			stage.addEventListener(LEFT_BUTTON_PRESSED, Left_Button_Pressed_Handler);
			stage.addEventListener(RIGHT_BUTTON_PRESSED, Right_Button_Pressed_Handler);
			stage.addEventListener(SHOOT_BUTTON_PRESSED, Shoot_Button_Pressed_Handler);
			
			
		}
		
		public function startGame(e:EnterFrameEvent): void
		{
			if (start == true)
			{
				gameTimer.addEventListener(TimerEvent.TIMER, updateObstacleNumber);
				gameTimer.start();
			}
		}

		public function updateObstacleNumber(e:TimerEvent):void
		{
			if (gameTimer.currentCount % 3 == 0 && gameTimer.currentCount != 0 && Over == false)
			{
					
				
				var obstacleToAppear:Obstacle = new Obstacle();
				//newObstacle_Arr[obstacleCount] = obstacleToAppear;
				obstacleToAppear.y = - obstacleToAppear.height; 
	  
				addChild(obstacleToAppear);
				if(obstacleCount == 0){
					obstacleToAppear.speed = 10;
				}
				else if (obstacleCount == 1) {

					obstacleToAppear.speed = 6;
				}
				else if (obstacleCount == 2) {
					obstacleToAppear.speed = 7;
				}
				//We don't want more than 3 obstacles.
				//else
				//{
					//obstacleToAppear.speed = 6;
				//}

				blockObstacle.push(obstacleToAppear);
				//newObstacle_Count[obstacleCount] = true;
				obstacleCount += 1;
				//trace("NEW OBSTACLE ADDED");
			}
				
			if (gameTimer.currentCount % 2 == 0 && gameTimer.currentCount != 0 && Over == false)
			{
				var enemyAppears:Enemy = new Enemy();
				addChild(enemyAppears);
				enemies.push(enemyAppears);
			}
		}
		
		//This function is called every frame by Game.as. 
		public function UpdateUI():void
		{
			
			if (Over != true && start == true)
			{
				
				Score = gameTimer.currentCount + killCount;
				ScoreLabel.text = "Score:" + " " + Score;
				for (var i:int = 0; i < blockObstacle.length; i++)
				{
					if (blockObstacle[i] != null)
					{
						Collision_Obstacle(blockObstacle[i]);
					}
				}
				for (var l:int = 0; l < enemies.length; l++)
				{
					if (enemies[l] != null)
					{
						Collision_Enemy(enemies[l]);
					}
				}
				hero.Move(userInput)
				/*if(enemy != null) { 
					enemy.Move(userInput);
				}*/
				userInput = "";
				for (var j:int = 0; j < blockObstacle.length; j++)
				{
					blockObstacle[j].Move(userInput);
				}
				
				for (var k:int = 0; k < enemies.length; k++)
				{
					if (enemies[k].yPos > Stage_Height)
						{
							removeChild(enemies[k]);
							enemies[k] = null;
							enemies.removeAt(k);
						}
					
						enemies[k].Move(userInput);
						
						
				}
				
				//check projectile distance
				for (var projDist:int = 0; projDist < bullets.length; projDist++)
				{
					if (bullets[projDist] < 0)
					{
						removeChild(bullets[projDist]);
						bullets[projDist] = null;
						bullets.splice(projDist, 1);
					}
				}
				
				for (var m:int = 0; m < enemies.length; m++)
				{
				
					for (var n:int = 0; n < bullets.length; n++)
					{
						if (enemies[m] != null && bullets[n] != null)
						{
							Shoot_Enemy(enemies[m], m, bullets[n], n);
						}
					}
						
					
				}
				

			}
			
		}
			
		
		
		
		function Collision_Obstacle(obstacle:Obstacle):void
		{
			//var block:Rectangle = obstacle.bounds;
			heroRec.x = hero.xPos;
			heroRec.y = hero.yPos;
			heroRec.offset(-75, -75);
			
			
			
			if(heroRec.intersects(obstacle.bounds))
			{
				CollisionNbr++;
				Over = true;	 
				setTimeout(GameIsOver, 2000);
			}
				
		}
		
		function Collision_Enemy(enemy:Enemy):void
		{
			heroRec.x = hero.xPos;
			heroRec.y = hero.yPos;
			heroRec.offset( -70, -70);
			
			
			enemyRec.x = enemy.xPos;
			enemyRec.y = enemy.yPos;
			enemyRec.offset( -37, -37);
			
			if (heroRec.intersects(enemyRec))
			{
				Over = true;
				setTimeout(GameIsOver, 2000);
			}
		}
		
		function Shoot_Enemy(enemy:Enemy, num:int, proj:Projectile, pnum:int):void
		{
			enemyRec.x = enemy.xPos;
			enemyRec.y = enemy.yPos;
			enemyRec.offset( -37, -37);
			
			if (!projectile)
			{
				return;
			}
			
			/*if (proj.x < 0)
			{
				projVector.removeAt(pnum);
			}*/
			projRec.x = proj.xPos;
			projRec.y = proj.yPos;
			projRec.offset( -5, -5);
			
			
			
			
			
		if (bullets[pnum] != null && projRec.intersects(enemyRec))
			{
				removeChild(enemy);
				removeChild(proj);
				enemies.removeAt(num);
				bullets[pnum] = null;
				bullets.splice(pnum, 1);
				
				killCount += 3;
				
			}
			
			
		
		
		}
			//}
			/*
			//75 & 20 are hard-coded values tested on Amine's screen to find right 
			//precision for collision detection. 
			var precisionFactorLeft:int = 75;
			var precisionFactorRight:int = 20;
			var leftObstacleX:int = obstacle.xPos - 0.5 * 100 + precisionFactorLeft; 
			var rightObstacleX:int = obstacle.xPos + 0.5 * 100 + precisionFactorRight;  
		}
		}
			
			
			//350 is a hard-coded value tested on Amine's screen to find when obstacle
			//actually leaves the game screen. 
			var precisionFactorBottom:int = 350;
			
			if (!(obstacle.yPos - 0.5 * 100 >= Stage_Height - precisionFactorBottom)) {	//If obstacle hasn't left screen.
				if (obstacle.yPos + 0.5 * 100 >= hero.yPos - 0.5 * 200 && obstacle.y - 0.5 * 100 <= hero.yPos + 0.5 * 200){
					
					if (rightObstacleX >= hero.xPos - 0.5 * 200 && rightObstacleX <= hero.xPos + 0.5 * 200) {
					//	ScoreLabel.text = "COL=" + CollisionNbr;
						CollisionNbr++;
						Over = true;	 
						setTimeout(GameIsOver, 2000);
					}
					
					if (leftObstacleX >= hero.xPos - 0.5 * 200 && leftObstacleX <= hero.xPos + 0.5 * 200) {
					//	ScoreLabel.text = "COL=" + CollisionNbr;
						CollisionNbr++; 
						Over = true; 
						setTimeout(GameIsOver, 2000);
					}
					
				}
			}
			
			for (var i:int = 0; i < 3; i++) {
				if(newObstacle_Arr[i] != null) {
					leftObstacleX = newObstacle_Arr[i].xPos - 0.5 * 100 + precisionFactorLeft; 
					rightObstacleX  = newObstacle_Arr[i].xPos + 0.5 * 100 + precisionFactorRight; 
				
				if (!(newObstacle_Arr[i].yPos - 0.5 * 100 >= Stage_Height - precisionFactorBottom)) {	//If obstacle hasn't left screen.
					if (newObstacle_Arr[i].yPos + 0.5 * 100 >= hero.yPos && newObstacle_Arr[i].y - 0.5 * 100 <= hero.yPos + 0.5 * 200){	//For some 	reason, >= hero.yPos works here.
						
						if (rightObstacleX >= hero.xPos - 0.5 * 200 && rightObstacleX <= hero.xPos + 0.5 * 200) {
							ScoreLabel.text = "COL=" + CollisionNbr;
							CollisionNbr++;
							Over = true; 
							setTimeout(GameIsOver, 2000);
						}
						
						if (leftObstacleX >= hero.xPos - 0.5 * 200 && leftObstacleX <= hero.xPos + 0.5 * 200) {
							ScoreLabel.text = "COL=" + CollisionNbr;
							CollisionNbr++; 
							Over = true; 
							setTimeout(GameIsOver, 2000);
						}
						
					}
				}
			}
			}*/
			
		
			
		
		/*private function Check_Projectile_Hit():void {
			
			//Hard-coded tested value. 
			var precisionFactorProjectileX = 50;
			
			if(projectile != null) { 
 				if (projectile.yPos >= enemy.yPos - 0.5 * 200 && projectile.yPos <= enemy.yPos + 0.5 * 200) {
					
					if (projectile.xPos - precisionFactorProjectileX >= enemy.xPos - 0.5 * 200 &&
					projectile.xPos + precisionFactorProjectileX<= enemy.xPos + 0.5 * 200) {
						//ScoreLabel.text = "Score: " + HitNbr;
						HitNbr++; 
						enemy.Regenerate();
						projectile.DeleteProjectile();
						killCount += 3; 
					}
					
				}
			}
	
		}*/
		
		private function Left_Button_Pressed():void
		{
			dispatchEventWith(LEFT_BUTTON_PRESSED, true);
		}
		
		private function Right_Button_Pressed():void
		{
			dispatchEventWith(RIGHT_BUTTON_PRESSED, true);
		}
		
		private function Shoot_Button_Pressed():void
		{
			dispatchEventWith(SHOOT_BUTTON_PRESSED, true);
		}
		
		private function On_Key_Down(event:KeyboardEvent):void
		{
			
			switch(event.keyCode)
			{
				case Keyboard.A:
					ADown = true;
					break;
				case Keyboard.D:
					DDown = true;
					break;
				//case Keyboard.W:
				//	WDown = true;
				//	break;
				//case Keyboard.S:
					//SDown = true;
				//	break;
				case Keyboard.SPACE:
					SpaceDown = true;
					break;
			}
			
		}
		
		
		//Notify Game.as that the game is over. 
		private function GameIsOver() 
		{
			gameTimer.stop();
			gameTimer.reset(); 
			killCount = 0;
			dispatchEventWith(GAME_OVER, true);	

		}
		
		private function On_Key_Up(event:KeyboardEvent):void
		{
			
			switch(event.keyCode)
			{
				case Keyboard.A:
					ADown = false;
					break;
				case Keyboard.D:
					DDown = false;
					break;
				//case Keyboard.W:
					//WDown = false;
					//break;
				//case Keyboard.S:
					//SDown = false;
				//	break;
				case Keyboard.SPACE:
					SpaceDown = false;
					canFire = true;
					break;
			}

		}
		
		private function Left_Button_Pressed_Handler():void 
		{
			//ADown = true;
			userInput = "a";
		}
		
		private function Right_Button_Pressed_Handler():void 
		{
			//DDown = true;
			userInput = "d";
		}
		
		private function Shoot_Button_Pressed_Handler():void 
		{
			SpaceDown = true;
			canFire = true;
			
		}
		
		function eFrame(e:EnterFrameEvent):void		//Runs on every frame.
			{
				
				if (ADown)
				{
					userInput = "a";
				}
				//if(SDown){
				//	userInput = "s";
				//}
				//if(WDown){
				//	userInput = "w";
				//}
				if (DDown)
				{
					userInput = "d";
				}
				if (SpaceDown)
				{
					if (canFire)
					{
						projectile = new Projectile(); 
						bullets.push(projectile);
						addChild(projectile);
						projectile.MoveProjectile(hero.xPos, hero.yPos); 	//"x" as placeholder to have the same function with same parameter.
					}
					canFire = false;
				}
				//UpdateUI();
				
			}
	}
	
	
}



