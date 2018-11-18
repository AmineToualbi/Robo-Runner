
/**
 * ...
 * @author Rich
 */

package 
{

	import dragonBones.events.EventObject;
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Rectangle;
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
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.events.Event;
	//import flash.display.DisplayObject;
	
	
	public class Level extends Sprite
	{
		private var hero:Hero;
		private var bullets:Array = new Array();
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
		private var blockObstacle:Vector.<Obstacle> = new Vector.<Obstacle>;
		private var enemyVector:Vector.<Enemy> = new Vector.<Enemy>;
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
			ScoreLabel = new TextField(200, 50, "Score: " + Score);
			ScoreLabel.format.font = "Arial";
			ScoreLabel.format.color = 0xffffff;
			ScoreLabel.format.size = 30;

			//Add Score label to the display.
			addChild(ScoreLabel);
			
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
			
			
			
		}
		
		public function startGame(e:EnterFrameEvent): void {
			if(start == true) {
				gameTimer.addEventListener(TimerEvent.TIMER, updateObstacleNumber);
				gameTimer.start();
			}
		}

		public function updateObstacleNumber(e:TimerEvent):void {
			if (gameTimer.currentCount % 3 == 0 && gameTimer.currentCount != 0 && Over == false) {
					
					
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
				
			if (gameTimer.currentCount % 3 == 0 && gameTimer.currentCount != 0 && Over == false)
			{
				var enemyAppears:Enemy = new Enemy();
				addChild(enemyAppears);
				enemyVector.push(enemyAppears);
			}
		}
		
		//This function is called every frame by Game.as. 
		public function UpdateUI():void
		{
			
			if (Over != true && start == true){
				
				Score = gameTimer.currentCount + killCount;
				ScoreLabel.text = Score + "";
				for (var i:int = 0; i < blockObstacle.length; i++)
				{
					Collision_Obstacle(blockObstacle[i]);
				}
				for (var l:int = 0; l < enemyVector.length; l++)
				{
					Collision_Enemy(enemyVector[l]);
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
				
				for (var k:int = 0; k < enemyVector.length; k++)
				{
					enemyVector[k].Move(userInput);
				}
				
				for (var m:int = 0; m < enemyVector.length; m++)
				{
					Shoot_Enemy(enemyVector[m], m);
				}
				
				//obstacle.Move(userInput);
				//userInput = "";
				//Check_Projectile_Hit();
				
				/*for (var i:int = 0; i < 3; i++) {
					//if (newObstacle_Count[obstacleCount] == true && newObstacle_Arr[i] != null) {
					if(newObstacle_Arr[i] != null) {	
					newObstacle_Arr[i].Move(userInput);
					}
					//}
				}*/

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
		
		function Shoot_Enemy(enemy:Enemy, num:int):void
		{
			enemyRec.x = enemy.xPos;
			enemyRec.y = enemy.yPos;
			enemyRec.offset( -37, -37);
			
			if (!projectile)
			{
				return;
			}
			
			projRec.x = projectile.xPos;
			projRec.y = projectile.yPos;
			projRec.offset( -5, -5);
			
			if (projRec.intersects(enemyRec))
			{
				projectile.DeleteProjectile();
				removeChild(enemy);
				enemyVector.removeAt(num);
				credits += 3;
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
		
		
		function eFrame(e:EnterFrameEvent):void		//Runs on every frame.
			{
				
				if(ADown){
					userInput = "a";
				}
				//if(SDown){
				//	userInput = "s";
				//}
				//if(WDown){
				//	userInput = "w";
				//}
				if(DDown){
					userInput = "d";
				}
				if (SpaceDown){
					if(canFire){
						projectile = new Projectile(); 
						addChild(projectile);
						projectile.MoveProjectile(hero.xPos, hero.yPos); 	//"x" as placeholder to have the same function with same parameter.
					}
					canFire = false;
				}
				//UpdateUI();
				
			}
	}
	
	
}



