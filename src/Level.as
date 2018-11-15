
/**
 * ...
 * @author Rich
 */

package 
{

	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import flash.ui.Keyboard;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
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
		private var Score:int;
		private var ADown:Boolean = false;
		private var WDown:Boolean = false;
		private var SDown:Boolean = false;
		private var DDown:Boolean = false;
		private var SpaceDown:Boolean = false;
		private var canFire:Boolean = true;
		private var ScoreLabel:TextField;
		
		public static const GAME_OVER:String = "GAME OVER";
		
		public static var Over: Boolean = false; 
		
		private var HitNbr:int; //Testing purposes.
		private var CollisionNbr:int; //Testing purposes.


		
		
		public function Level() 
		{
			var stage:starling.display.Stage = Starling.current.stage;
			var assets:AssetManager = Main.Assets;
			start_background = new Image(assets.getTexture("start"));
			map = new Map();
			hero = new Hero();
			obstacle = new Obstacle();
			//projectile = new Projectile();
			
			Score = 0; 
			
			// Set the obstacle's initial position
			obstacle.y = 0; // screen width
			
			// Initialize the button texture
			//flap_button_texture = MAIN.Assets.getTexture("flapWingsButton");
			//flap_button = new Button(flap_button_texture);
			
			// Place button in bottom center
			//flap_button.x = stage.stageWidth / 2 - flap_button.width / 2;
			//flap_button.y = stage.stageHeight - flap_button.height;
			
			// Add the obstacle and player to the display
			
			enemy = new Enemy(); 
			
			//addChild(flap_button);
			addChild(map);
			
			addChild(hero);
			
			addChild(enemy);
			
			//addChild(projectile);
			
			addChild(obstacle);
			Score = 1000000;
			
			ScoreLabel = new TextField(200, 50, "Score: " + Score);
			ScoreLabel.format.font = "Arial";
			ScoreLabel.format.color = 0xffffff;
			ScoreLabel.format.size = 30;

			addChild(ScoreLabel);
			
			// Add keyboard listeners
			// Keyboard Events aren't sent to sprites, 
			// so we have to grab the current stage 
			// and setup the callback to listen on the stage object
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			stage.addEventListener(KeyboardEvent.KEY_UP, On_Key_Up);
			stage.addEventListener(Event.ENTER_FRAME, eFrame);
			
			// Add button listener
			// flap_button.addEventListener(Event.TRIGGERED, Flap_Wings_Button_Handler);
			
			HitNbr = 0;
			CollisionNbr = 0;
		}
		
		//This function is called every frame by Game.as. 
		public function UpdateUI():void
		{
			if(Over != true){
			//hero.Update();
			//Move_Projectile();
			Collision_Obstacle();
			//Move_Enemy(); 
			hero.Move(userInput)
			if(enemy != null) { 
				enemy.Move(userInput);
			}
			obstacle.Move(userInput);
			userInput = "";
			Check_Projectile_Hit();
			}
		}
		
	
		
		private function Collision_Obstacle():void
		{
			//consider them as rectangles
			var bounds1:Rectangle = hero.bounds;
			var bounds2:Rectangle = obstacle.bounds;
			//if (bounds1.intersects(bounds2))
			//{	//test
			//	trace("collisions!");
			//	ScoreLabel.text = "Collision";
			//	setTimeout(GameIsOver, 3000);		//Wait for 3000 seconds before displaying screen. 
			//	Over = true;
				
				//dispatchEventWith(GAME_OVER, true);	
			//}
			
			var leftObstacleX:int = obstacle.xPos - 0.5 * obstacle.width; 
			var rightObstacleX:int = obstacle.xPos + 0.5 * obstacle.width;  
			
			if (obstacle.yPos >= hero.yPos - 0.5 * hero.height) {
				if (rightObstacleX >= hero.xPos - 0.5 * hero.width && rightObstacleX <= hero.xPos + 0.5 * hero.width) {
					ScoreLabel.text = CollisionNbr + ""; 
					CollisionNbr++;
				}
				if (leftObstacleX >= hero.xPos - 0.5 * hero.width && leftObstacleX <= hero.xPos + 0.5 * hero.width) {
					ScoreLabel.text = CollisionNbr + "";
					CollisionNbr++; 
				}
			}
			
			//if (rightObstacleX<= hero.xPos + 0.5 * hero.width && obstacle.xPos >= hero.xPos - 0.5 * hero.width) {
			//	if (obstacle.yPos <= hero.yPos + 0.5 * hero.height && obstacle.yPos >= hero.yPos - 0.5 * hero.height) {
			//		ScoreLabel.text = CollisionNbr + ""; 
			//		CollisionNbr++;
			//		//Over = true;
			//	}
			//}
			
		}
		
		private function Check_Projectile_Hit():void {
			
			if(projectile != null && enemy != null) { 
				var projectileBounds:Rectangle = projectile.bounds; 
				var enemyBounds:Rectangle = enemy.bounds;
			
				if (projectileBounds.intersects(enemyBounds)){
					//ScoreLabel.text = HitNbr + ""; 
					HitNbr++;
					enemy.Regenerate();
					projectile.DeleteProjectile();
				}
			}
			
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
				case Keyboard.W:
					WDown = true;
					break;
				case Keyboard.S:
					SDown = true;
					break;
				case Keyboard.SPACE:
					SpaceDown = true;
					
					/*projectile = new Projectile(); 
					addChild(projectile);
					projectile.Move(hero.xPos, hero.yPos); 	//"x" as placeholder to have the same function with same parameter.*/
					break;
				
			}
			
			/*if (event.keyCode == Keyboard.A)
			{
					userInput = "a";
			}
			if (event.keyCode == Keyboard.D)
			{
					userInput = "d";
			}
			if (event.keyCode == Keyboard.W)
			{
					userInput = "w";
			}
			if (event.keyCode == Keyboard.S)
			{
					userInput = "s";	
			}
			if (event.keyCode == Keyboard.SPACE)
			{
				projectile = new Projectile(); 
				addChild(projectile);
				projectile.Move(hero.xPos, hero.yPos); 	//"x" as placeholder to have the same function with same parameter.
				//userInput = "";
			}
			
			//hero.Move(userInput);*/
		}
		
		private function GameIsOver() 
		{
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
				case Keyboard.W:
					WDown = false;
					break;
				case Keyboard.S:
					SDown = false;
					break;
				case Keyboard.SPACE:
					SpaceDown = false;
					canFire = true;
					/*projectile = new Projectile(); 
					addChild(projectile);
					projectile.Move(hero.xPos, hero.yPos); 	//"x" as placeholder to have the same function with same parameter.*/
					break;
				
			}
			/*// reset now that we've released space
			if(event.keyCode == Keyboard.SPACE)
			{
			
			}
			if(event.keyCode == Keyboard.W)
			{
				
			}
			if(event.keyCode == Keyboard.S)
			{
				
			}
			if(event.keyCode == Keyboard.A)
			{
				
			}
			if(event.keyCode == Keyboard.D)
			{
				
			}*/
			
		}
		function eFrame(e:EnterFrameEvent):void
			{ //runs on every frame
				if(ADown){
					userInput = "a";
				}
				if(SDown){
					userInput = "s";
				}
				if(WDown){
					userInput = "w";
				}
				if(DDown){
					userInput = "d";
				}
				if (SpaceDown){
					if(canFire){
						projectile = new Projectile(); 
						addChild(projectile);
						projectile.Move(hero.xPos, hero.yPos); 	//"x" as placeholder to have the same function with same parameter.
					}
					canFire = false;
				}
				//UpdateUI();
			}
	}
	
	
}



//	private function Move_Enemy() {
	//		enemy.y += 5;
	//		if (enemy.y > 1024 + obstacle.height)
	//		{
	//			enemy.y =  - enemy.height;
	//			enemy.Regenerate();
	///		}
	//	}
		
		
		
	//	private function Move_Projectile():void
	//	{
			///(var i:int = 0; i < bullets.length; i++) 
			//	{
				//	addChild(bullets[i]);
				//	bullets[i].y -= 3; 
			//	}
			/*
			
			if(bullets.length != 0) 
			{ 
				for(var i:int = 0; i < bullets.length; i++) 
				{
					addChild(bullets[i]);
					bullets[i].y -= 3; 
					
					// Destroy offstage bullets 
          
					if(bullets[i].y < 0) 
					{ 
						removeChild(bullets[i]); 
						bullets[i] = null; 
						bullets.splice(i, 1); 
					} 
				} 
			}
			*/
			
		//}