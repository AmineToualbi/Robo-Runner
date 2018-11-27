
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

	
	
	public class Level extends Sprite
	{
				//private var assets:AssetManager;
		private var hero:Hero;
		private var bullets:Array = new Array();
		private var enemies:Array = new Array();
		private var obstacles:Array = new Array();

		private var map:Map;
		private var projectile:Projectile;
		private var enemy:Enemy;
		private var assets:AssetManager;
		private var shoot_sound:SoundChannel = new SoundChannel();
		private var explosion_sound:SoundChannel = new SoundChannel();
		
		private var start_background:Image;
		private var user_input:String; 
		public static var score:int = 0;
		private var a_down:Boolean = false;
		private var d_down:Boolean = false;
		private var space_down:Boolean = false;
		private var can_fire:Boolean = true;
		private var score_label:TextField;
		private var projectile_shot:Boolean = false; 
		

		
		
		//Create rectangles for hit boxes
		private var hero_rec:Rectangle = new Rectangle(0, 0, 140, 140);
		private var enemy_rec:Rectangle = new Rectangle(0, 0, 75, 75);
		private var proj_rec:Rectangle = new Rectangle(0, 0, 10, 10);
		
		//Create constants
		public static const GAME_OVER:String = "GAME OVER";
		private const STAGE_WIDTH:int = 1024;
		private const STAGE_HEIGHT:int = 1024;
		
		public static var over: Boolean = false; 
		
		private var hit_nbr:int; //Testing purposes.
		private var collision_nbr:int; //Testing purposes.
		
		private var game_timer:Timer; 
		private var shoot_timer:Timer; 
		private var previousShot:int; 
		private var currentShot:int; 
		
		private var obstacle_count:int = 0;
		private var kill_count: int = 0;
		
		public static var credits:int = 0; 
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
			var assets:AssetManager = Main.assets;

			start_background = new Image(assets.getTexture("start"));
			
			//Create the objects.
			map = new Map();
			hero = new Hero();
			
			game_timer = new Timer(1000, 0); 
			shoot_timer = new Timer(1000, 0); 
			
			//Add the objects to the display.
			addChild(map);
			addChild(hero);
			
			//var appDir:File = File.applicationDirectory;
			
			//Load sound asset
			//assets.enqueue(appDir.resolvePath("Assets"));
			//assets.enqueue(appDir.resolvePath("/bin/Assets/"));
			
			//Testing variables for how many hit and collisions
			//hit_nbr = 0;		//Testing purposes.
			//collision_nbr = 0;	//Testing purposes.
			
			//Score Label. 
			score_label = new TextField(300, 50, "Score: " + score);
			score_label.format.font = "Arial";
			score_label.format.color = 0xffffff;
			score_label.format.size = 30;
			score_label.format.horizontalAlign = Align.LEFT;

			//Add Score label to the display.
			addChild(score_label);
			
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
			
			//Set button locations
			left_button.x = 1050;
			left_button.y = 500;
			right_button.x = 1060 + right_button.width;
			right_button.y = 500;
			shoot_button.x = 1050;
			shoot_button.y = 600;
			
			//Add buttons to the display
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
			stage.addEventListener(Event.ENTER_FRAME, Start_Game);
			stage.addEventListener(LEFT_BUTTON_PRESSED, Left_Button_Pressed_Handler);
			stage.addEventListener(RIGHT_BUTTON_PRESSED, Right_Button_Pressed_Handler);
			stage.addEventListener(SHOOT_BUTTON_PRESSED, Shoot_Button_Pressed_Handler);
			
			
		}
		
		public function Start_Game(e:EnterFrameEvent): void
		{
			if (start == true)
			{
				game_timer.addEventListener(TimerEvent.TIMER, Update_Obstacle_Number);
				game_timer.start();
				shoot_timer.start(); 	
			}
			
		}

		public function Update_Obstacle_Number(e:TimerEvent):void

		{
			if (game_timer.currentCount % 3 == 0 && game_timer.currentCount != 0 && over == false)
			{
					
				
				var obstacle_to_appear:Obstacle = new Obstacle();
				//newObstacle_Arr[obstacle_count] = obstacle_to_appear;
				obstacle_to_appear.y = - obstacle_to_appear.height; 
	  
				addChild(obstacle_to_appear);
				if(obstacle_count == 0){
					obstacle_to_appear.speed = 10 + 0.5 * game_timer.currentCount; //assume acceleration is 0.5.
				}
				else if (obstacle_count == 1) {

					obstacle_to_appear.speed = 6 + 0.5 * game_timer.currentCount;
				}
				else if (obstacle_count == 2) {
					obstacle_to_appear.speed = 7 + 0.5 * game_timer.currentCount;
				}
				//We don't want more than 3 obstacles.
				
				obstacles.push(obstacle_to_appear);
				
				obstacle_count += 1;
			}
				
			if (game_timer.currentCount % 2 == 0 && game_timer.currentCount != 0 && over == false)
			{
				var enemy_appears:Enemy = new Enemy();
				enemy_appears.speed = 5 + 0.5 * game_timer.currentCount;
				addChild(enemy_appears);
				enemies.push(enemy_appears);

			}
		}
		
		//This function is called every frame by Game.as. 
		public function UpdateUI():void
		{
			
			if (over != true && start == true)
			{
				
				score = game_timer.currentCount + kill_count;
				score_label.text = "Score:" + " " + score;
				
				var obs_length:int = obstacles.length;
				for (var i:int = 0; i < obs_length; i++)
				{
					if (obstacles[i] != null)
					{
						Collision_Obstacle(obstacles[i]);
					}
				}
				
				var enemy_length:int = enemies.length;
				for (var l:int = 0; l < enemy_length; l++)
				{
					if (enemies[l] != null)
					{
						Collision_Enemy(enemies[l]);
					}
				}
				hero.Move(user_input)
				
				user_input = "";
				
				var obstacle_length:int = obstacles.length;
				for (var j:int = 0; j < obstacle_length; j++)
				{
					obstacles[j].Move(user_input);

				}
				
				
				var enem_length:int = enemies.length;
				for (var k:int = 0; k < enem_length; k++)
				{
					if (enemies[k] != null)
					{
						if (enemies[k].y_pos > STAGE_HEIGHT)
						{
							removeChild(enemies[k]);
							enemies[k] = null;
							enemies.splice(k, 1);
						}
						if (enemies.length == 0)
						{
							return;
							
						}
						enemies[k].Move(user_input);	
					}	
				}
				
				//check projectile distance
				var bullet_length:int = bullets.length;
				for (var proj_dist:int = 0; proj_dist < bullets.length; proj_dist++)
				{
					if (bullets[proj_dist] < 0)
					{
						removeChild(bullets[proj_dist]);
						bullets[proj_dist] = null;
						bullets.splice(proj_dist, 1);
					}
				}
				
				for (var n:int = 0; n < bullet_length; n++)
				{
					var enemies_length:int = enemies.length;
					for (var m:int = 0; m < enemies_length; m++)
					{
						if (enemies[m] != null && bullets[n] != null)
						{
							Shoot_Enemy(enemies[m], m, bullets[n], n);
						}
					}
					var obstacles_length:int = obstacles.length;
					for (var o:int = 0; o < obstacles_length; o++)
					{
						if (obstacles[o] != null && bullets[n] != null)
						{
							Check_Obstacle(obstacles[o], bullets[n], n);

						}

					}
					
				}

			}
		}
			
		
		
		
		private function Collision_Obstacle(obstacle:Obstacle):void
		{
			//var block:Rectangle = obstacle.bounds;
			hero_rec.x = hero.x_pos;
			hero_rec.y = hero.y_pos;
			hero_rec.offset(-75, -75);
			
			
			
			if(hero_rec.intersects(obstacle.bounds))
			{
				can_fire = false; 
				collision_nbr++;
				over = true;	 
				map.bg_armature.animation.gotoAndStopByProgress("animtion0", 0);
				setTimeout(Game_Is_Over, 1000);
				
			}
				
		}
		
		private function Collision_Enemy(enemy:Enemy):void
		{
			hero_rec.x = hero.x_pos;
			hero_rec.y = hero.y_pos;
			hero_rec.offset( -70, -70);
			
			
			enemy_rec.x = enemy.x_pos;
			enemy_rec.y = enemy.y_pos;
			enemy_rec.offset( -37, -37);
			
			if (hero_rec.intersects(enemy_rec))
			{
				can_fire = false; 
				over = true;
				map.bg_armature.animation.gotoAndStopByProgress("animtion0", 0);
				setTimeout(Game_Is_Over, 1000);
			}
		}
		
		private function Shoot_Enemy(enemy:Enemy, num:int, proj:Projectile, pnum:int):void
		{
			enemy_rec.x = enemy.x_pos;
			enemy_rec.y = enemy.y_pos;
			enemy_rec.offset( -37, -37);
			
			if (!projectile)
			{
				return;
			}
			
			proj_rec.x = proj.x_pos;
			proj_rec.y = proj.y_pos;
			proj_rec.offset( -5, -5);
		
			if (bullets[pnum] != null && proj_rec.intersects(enemy_rec))
			{
				assets = Main.assets;
				explosion_sound = assets.playSound("Explosion");
				removeChild(enemy);
				removeChild(proj);
				enemies.removeAt(num);
				bullets[pnum] = null;
				bullets.splice(pnum, 1);
				
				kill_count += 3;
				
			}
		}
		
		private function Check_Obstacle(obstacle:Obstacle, proj:Projectile, pnum:int):void
		{	
			proj_rec.x = proj.x_pos;
			proj_rec.y = proj.y_pos;
			proj_rec.offset( -5, -5);
			
			if (bullets[pnum] != null && proj_rec.intersects(obstacle.bounds))
			{
				removeChild(proj);
				bullets[pnum] = null;
				bullets.splice(pnum, 1);

			}
			
		}
		
		//Button functions
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
			//shoot_sound = assets.playSound("Fixed Blaster Sound");
		}
		
		//Keyboard functions -- testing
		private function On_Key_Down(event:KeyboardEvent):void
		{
			
			switch(event.keyCode)
			{
				case Keyboard.A:
					a_down = true;
					break;
				case Keyboard.D:
					d_down = true;
					break;
				case Keyboard.SPACE:
					space_down = true;
					break;
			}
			
		}
		
		
		//Notify Game.as that the game is over. 
		private function Game_Is_Over():void 
		{
			game_timer.stop();
			game_timer.reset(); 
			kill_count = 0;
			dispatchEventWith(GAME_OVER, true);	

		}
		
		private function On_Key_Up(event:KeyboardEvent):void
		{
			
			switch(event.keyCode)
			{
				case Keyboard.A:
					a_down = false;
					break;
				case Keyboard.D:
					d_down = false;
					break;
				case Keyboard.SPACE:
					space_down = false;
					can_fire = true;
					break;
			}

		}
		
		private function Left_Button_Pressed_Handler():void 
		{
			user_input = "a";
		}
		
		private function Right_Button_Pressed_Handler():void 
		{
			user_input = "d";
		}
		
		private function Shoot_Button_Pressed_Handler():void 
		{
			assets = Main.assets;
			//shoot_sound = assets.playSound("Fixed Blaster Sound",0,0);
			space_down = true;
			can_fire = true;
			
			if (projectile_shot == true) 
			{
				shoot_sound = assets.playSound("Fixed Blaster Sound", 0, 0); 
				projectile_shot = false; 
			}

			
		}
		
		//Enter frame event, will update continuously, smooths out movement.
		private function eFrame(e:EnterFrameEvent):void		
		{
			
			if (a_down)
			{
				user_input = "a";
			}
			if (d_down)
			{
				user_input = "d";
			}
			if (space_down)
			{
				if (can_fire)
				{
					
					if (shoot_timer.currentCount >= 1)
					{
						projectile = new Projectile(); 
						bullets.push(projectile);
						addChild(projectile);
						//shoot_sound = assets.playSound("Fixed Blaster Sound.mp3");
						projectile.Move_Projectile(hero.x_pos, hero.y_pos); 	//"x" as placeholder to have the same function with same parameter.
						shoot_timer.reset();
						shoot_timer.start();
						projectile_shot = true;
					}
				}
				
				can_fire = false;
			}
		}
	}
}



