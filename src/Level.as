
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
	import starling.utils.Align;

	
	public class Level extends Sprite
	{
		private var hero:Hero;
		private var obstacle_Arr:Array = new Array();
		private var enemy_Arr:Array = new Array();
		//private var flap_button:Button;
		//private var flap_button_texture:Texture;
		
		private var obstacle:Obstacle;
		private var map:Map;
		private var projectile:Projectile;
		private var enemy:Enemy;
		private var gameOver:GameOver;
		private const Stage_Width:int = 1024;
		private const Stage_Height:int = 1024;
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
		private var Otimer:Timer = new Timer(1500);
		private var Etimer:Timer = new Timer(2000);

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
			//gameOver = new GameOver();
			//projectile = new Projectile();
			
			
			// Set the obstacle's initial position
			//obstacle.y = 0; 

			//Add the objects to the display.
			addChild(map);
			addChild(hero);
			//addChild(enemy);
			//addChild(obstacle);
			
			Score = 0;
			HitNbr = 0;		//Testing purposes.
			CollisionNbr = 0;	//Testing purposes.
			
			//Score Label. 
			ScoreLabel = new TextField(200, 50, "Score: " + Score);
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
			
			//DETERMINE WHERE TO PUT IT, PROBS IN MIDDLE.
			left_button.x = 30;
			left_button.y = 600;
			right_button.x = left_button.x + 10 + right_button.width;
			right_button.y = 600;
			shoot_button.x = 990-shoot_button.width;
			shoot_button.y = 550;
			
			//try to put on the top
			addChild(left_button);
			addChild(right_button);
			addChild(shoot_button);
			
			// Add keyboard listeners
			// Keyboard Events aren't sent to sprites, 
			// so we have to grab the current stage 
			// and setup the callback to listen on the stage object
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			stage.addEventListener(KeyboardEvent.KEY_UP, On_Key_Up);
			stage.addEventListener(LEFT_BUTTON_PRESSED, Left_Button_Pressed_Handler);
			stage.addEventListener(RIGHT_BUTTON_PRESSED, Right_Button_Pressed_Handler);
			stage.addEventListener(SHOOT_BUTTON_PRESSED, Shoot_Button_Pressed_Handler);
			stage.addEventListener(Event.ENTER_FRAME, eFrame);	//Called every frame.
			Otimer.addEventListener(TimerEvent.TIMER, AddObstacle); //every 1500ms call addObstacle
			Otimer.start();
			Etimer.addEventListener(TimerEvent.TIMER, AddEnemy); //every 2000ms call addObstacle
			Etimer.start();
			
		}
		
		//This function is called every frame by Game.as. 
		public function UpdateUI():void
		{
			
			if(Over != true){
				Collision_Obstacle();
				hero.Move(userInput)
				MoveEnemies();
				
				MoveObstacles();
				
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
			for (var j:int = 0; j < obstacle_Arr.length; j++) 
				{
			//var leftObstacleX:int = obstacle.xPos - 0.5 * 100 + precisionFactorLeft; 
			//var rightObstacleX:int = obstacle.xPos + 0.5 * 100 + precisionFactorRight;  
			var leftObstacleX:int = obstacle_Arr[j].xPos - 0.5 * 100 + precisionFactorLeft; 
			var rightObstacleX:int = obstacle_Arr[j].xPos + 0.5 * 100 + precisionFactorRight;  
			
			
			//350 is a hard-coded value tested on Amine's screen to find when obstacle
			//actually leaves the game screen. 
			var precisionFactorBottom:int = 350;
			
			if (!(obstacle_Arr[j].yPos - 0.5 * 100 >= Stage_Height - precisionFactorBottom)) {	//If obstacle hasn't left screen.
				if (obstacle_Arr[j].yPos + 0.5 * 100 >= hero.yPos - 0.5 * 200 && obstacle_Arr[j].y - 0.5 * 100 <= hero.yPos + 0.5 * 200){
					
					if (rightObstacleX >= hero.xPos - 0.5 * 200 && rightObstacleX <= hero.xPos + 0.5 * 200) {
						ScoreLabel.text = "COL=" + CollisionNbr;
						CollisionNbr++;
						Over = true; 
						setTimeout(GameIsOver, 1000);
					}
					
					if (leftObstacleX >= hero.xPos - 0.5 * 200 && leftObstacleX <= hero.xPos + 0.5 * 200) {
						ScoreLabel.text = "COL=" + CollisionNbr;
						CollisionNbr++; 
						Over = true; 
						setTimeout(GameIsOver, 1000);
					}
					
				}
			}
				}
			
		}
			
		
		private function Check_Projectile_Hit():void {
			
			//Hard-coded tested value. 
			var precisionFactorProjectileX = 50;
			for (var i:int = 0; i < enemy_Arr.length; i++ )
			{
				if(projectile != null) { 
					if (projectile.yPos >= enemy_Arr[i].yPos - 0.5 * 200 && projectile.yPos <= enemy_Arr[i].yPos + 0.5 * 200) {
						if (projectile.xPos - precisionFactorProjectileX >= enemy_Arr[i].xPos - 0.5 * 200 &&
						projectile.xPos + precisionFactorProjectileX<= enemy_Arr[i].xPos + 0.5 * 200) {
							ScoreLabel.text = "Score: " + HitNbr;
							HitNbr++; 
							enemy_Arr[i].Regenerate();
							projectile.DeleteProjectile();
						}
					
					}
				}
			}
	
		}
		
		public function AddObstacle(e:TimerEvent):void
		{
			obstacle = new Obstacle();
			obstacle.Regenerate();
			obstacle_Arr.push(obstacle);
			addChild(obstacle);
		}
		
		public function MoveObstacles():void
		{
			for (var j:int = 0; j < obstacle_Arr.length; j++) 
				{
					obstacle_Arr[j].Move(userInput);
					if (obstacle_Arr[j].y > 1024 + 0.5 * obstacle_Arr[j].height) {
						obstacle_Arr.removeAt[j];
					}
					
				}
		}
		
		public function AddEnemy(e:TimerEvent):void
		{
			enemy = new Enemy();
			enemy.Regenerate();
			enemy_Arr.push(enemy);
			addChild(enemy);
		}
		
		public function MoveEnemies():void
		{
			if ( enemy_Arr.length != 0)
			{
				for (var i:int = 0; i < enemy_Arr.length; i++) 
					{
						enemy_Arr[i].Move(userInput);
						if (enemy_Arr[i].y > 1024 + 0.5 * enemy_Arr[i].height) {
							enemy_Arr.removeAt[i];
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
					break;
				case Keyboard.S:
					//SDown = true;
					break;
				case Keyboard.SPACE:
					SpaceDown = true;
					break;
			}
			
		}
		
		
		//Notify Game.as that the game is over. 
		private function GameIsOver():void 
		{
			Over = true;
			//addChild(gameOver);
			dispatchEventWith(GAME_OVER, true);	

		}
		
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
					break;
				case Keyboard.S:
					//SDown = false;
					break;
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
		
		
		private function eFrame(e:EnterFrameEvent):void		//Runs on every frame.
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



