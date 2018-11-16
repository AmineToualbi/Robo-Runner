
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
			
			//Create the objects.
			map = new Map();
			hero = new Hero();
			obstacle = new Obstacle();
			enemy = new Enemy(); 
			//projectile = new Projectile();
			
			
			// Set the obstacle's initial position
			obstacle.y = 0; 

			//Add the objects to the display.
			addChild(map);
			addChild(hero);
			addChild(enemy);
			addChild(obstacle);
			
			Score = 0;
			HitNbr = 0;		//Testing purposes.
			CollisionNbr = 0;	//Testing purposes.
			
			//Score Label. 
			ScoreLabel = new TextField(200, 50, "Score: " + Score);
			ScoreLabel.format.font = "Arial";
			ScoreLabel.format.color = 0xffffff;
			ScoreLabel.format.size = 30;

			//Add Score label to the display.
			addChild(ScoreLabel);
			
			// Add keyboard listeners
			// Keyboard Events aren't sent to sprites, 
			// so we have to grab the current stage 
			// and setup the callback to listen on the stage object
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			stage.addEventListener(KeyboardEvent.KEY_UP, On_Key_Up);
			stage.addEventListener(Event.ENTER_FRAME, eFrame);	//Called every frame.
			
		}
		
		//This function is called every frame by Game.as. 
		public function UpdateUI():void
		{
			
			if(Over != true){
				Collision_Obstacle();
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
			
			//75 & 20 are hard-coded values tested on Amine's screen to find right 
			//precision for collision detection. 
			var precisionFactorLeft:int = 75;
			var precisionFactorRight:int = 20;
			var leftObstacleX:int = obstacle.xPos - 0.5 * 100 + precisionFactorLeft; 
			var rightObstacleX:int = obstacle.xPos + 0.5 * 100 + precisionFactorRight;  
			
			
			//350 is a hard-coded value tested on Amine's screen to find when obstacle
			//actually leaves the game screen. 
			var precisionFactorBottom:int = 350;
			
			if (!(obstacle.yPos - 0.5 * 100 >= Stage_Height - precisionFactorBottom)) {	//If obstacle hasn't left screen.
				if (obstacle.yPos + 0.5 * 100 >= hero.yPos - 0.5 * 200 && obstacle.y - 0.5 * 100 <= hero.yPos + 0.5 * 200){
					
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
			
		
		private function Check_Projectile_Hit():void {
			
			//Hard-coded tested value. 
			var precisionFactorProjectileX = 50;
			
			if(projectile != null) { 
				if (projectile.yPos >= enemy.yPos - 0.5 * 200 && projectile.yPos <= enemy.yPos + 0.5 * 200) {
					
					if (projectile.xPos - precisionFactorProjectileX >= enemy.xPos - 0.5 * 200 &&
					projectile.xPos + precisionFactorProjectileX<= enemy.xPos + 0.5 * 200) {
						ScoreLabel.text = "Score: " + HitNbr;
						HitNbr++; 
						enemy.Regenerate();
						projectile.DeleteProjectile();
					}
					
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
				//	WDown = true;
				//	break;
				case Keyboard.S:
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
					//WDown = false;
					//break;
				case Keyboard.S:
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
				if(SDown){
				//	userInput = "s";
				}
				if(WDown){
				//	userInput = "w";
				}
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



