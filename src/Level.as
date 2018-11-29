
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
	import flash.events.MouseEvent;
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

	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	
	
	public class Level extends Sprite
	{

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
		private var w_down:Boolean = false;
		private var s_down:Boolean = false;
		private var space_down:Boolean = false;
		private var can_fire:Boolean = true;
		private var score_label:TextField;
		
		//Create rectangles for hit boxes. 
		private var hero_rec:Rectangle = new Rectangle(0, 0, 140, 140);
		private var enemy_rec:Rectangle = new Rectangle(0, 0, 75, 75);
		private var proj_rec:Rectangle = new Rectangle(0, 0, 10, 10);
		
		//Create constants. 
		public static const GAME_OVER:String = "GAME OVER";
		private const STAGE_WIDTH:int = 1024;
		private const STAGE_HEIGHT:int = 1024;
	
		private var game_timer:Timer; 		//Timer for score. 
		private var shoot_timer:Timer; 		//Timer for shooting -> stop spam shooting. 
		
		private var obstacle_count:int = 0;		
		private var kill_count: int = 0;		//Int keeping track of how many kills were performed. 
		
		public static var credits:int = 0;
		
		//We do not want those variables static -> caused lagging problem + multiple sound being heard. 
		//When we created first Level: over = false. First level ends & game over: over = true. 
		//New level created: over = true. Because it is true, the first Level runs again because it isn't technically deleted. 
		public var start:Boolean = false;		//Flag keeping track of game start. 
		public var over: Boolean = false;		//Flag keeping track of the game running. 

		private var start_timer_over:Boolean = false; 	//Flag keeping track of the countdown timer. 
		private var start_timer:Timer;					//Countdown timer to start. 

		private var left_button:Button;
		private var left_button_texture:Texture;
		private var right_button:Button;
		private var right_button_texture:Texture;
		private var up_button:Button;
		private var up_button_texture:Texture;
		private var down_button:Button;
		private var down_button_texture:Texture;
		public static const SHOOT_BUTTON_PRESSED:String = "SHOOT_BUTTON_PRESSED";
		private var shoot_button:Button;
		private var shoot_button_texture:Texture;
		
		private var start_label:TextField; 
		
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
			start_timer = new Timer(1000, 3); 
			
			//Add the objects to the display.
			addChild(map);
			addChild(hero);
						
			//Score Label. 
			score_label = new TextField(300, 50, "Score: 0");
			score_label.format.font = "Arial";
			score_label.format.color = 0xffffff;
			score_label.format.size = 30;
			score_label.format.horizontalAlign = Align.LEFT;
			score_label.x = 1075; 
			
			//Countdown timer label. 
			start_label = new TextField(1075, 650, "3"); 
			start_label.format.font = "Arial"; 
			start_label.format.color = 0xffffff; 
			start_label.format.size = 40; 
			start_label.format.horizontalAlign = Align.CENTER; 

			//Add Score label to the display.
			addChild(score_label);
			addChild(start_label); 
			
			//Controls for the game - buttons. 
			up_button_texture = assets.getTexture("up");
			up_button = new Button(up_button_texture);
			down_button_texture = assets.getTexture("down");
			down_button = new Button(down_button_texture);
			left_button_texture = assets.getTexture("left");
		    left_button = new Button(left_button_texture);
			right_button_texture = assets.getTexture("right");
		    right_button = new Button(right_button_texture);
			shoot_button_texture = assets.getTexture("shoot");
		    shoot_button = new Button(shoot_button_texture);
			
			// Add an event listener for when the button is pressed
			shoot_button.addEventListener(Event.TRIGGERED, Shoot_Button_Pressed);
			
			//Set button locations.
			up_button.x = 1050 + up_button.width/2;
			up_button.y = 500;
			down_button.x = 1050 + down_button.width/2;
			down_button.y = 600;
			left_button.x = 1050;
			left_button.y = 550;
			right_button.x = 1060 + right_button.width;
			right_button.y = 550;
			shoot_button.x = 1050;
			shoot_button.y = 400;
			
			//Add buttons to the display
			addChild(up_button); 
			addChild(down_button);
			addChild(left_button);
			addChild(right_button);
			addChild(shoot_button);
						
			// Add keyboard listeners
			// Keyboard Events aren't sent to sprites, 
			// so we have to grab the current stage 
			// and setup the callback to listen on the stage object
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			stage.addEventListener(KeyboardEvent.KEY_UP, On_Key_Up);
			stage.addEventListener(Event.ENTER_FRAME, eFrame);	//Called every frame.
			stage.addEventListener(Event.ENTER_FRAME, Start_Game);
			stage.addEventListener(TouchEvent.TOUCH, Up_Button_Pressed_Handler);
			stage.addEventListener(TouchEvent.TOUCH, Down_Button_Pressed_Handler);
			stage.addEventListener(TouchEvent.TOUCH, Left_Button_Pressed_Handler);
			stage.addEventListener(TouchEvent.TOUCH, Right_Button_Pressed_Handler);
			stage.addEventListener(SHOOT_BUTTON_PRESSED, Shoot_Button_Pressed_Handler);
			
			start_timer.addEventListener(TimerEvent.TIMER_COMPLETE, Start_Timer_Over); //Countdown timer completed. 
			start_timer.addEventListener(TimerEvent.TIMER, Start_Timer_Running);	   //Countdown timer running. 
			
		}
		
		public function Start_Timer_Running(e:TimerEvent):void 
		{
			start_label.text = (3 - start_timer.currentCount) + "";
		}
		
		//Function called when start countdown is over. 
		public function Start_Timer_Over(e:TimerEvent): void
		{
			start_timer_over = true; 
			removeChild(start_label); 
		}
		
		//Function called to start the game when start flag is true. Also called every frame to update obstacle nbr. 
		public function Start_Game(e:Event): void
		{
				
			if (start == true && start_timer.running == false) {		//Start countdown before game starts. 
				start_timer.start(); 
			}
			if (start == true && start_timer_over == true)				//Start timers & start the game. 
			{
				game_timer.addEventListener(TimerEvent.TIMER, Update_Obstacle_Number);
				game_timer.start();
				shoot_timer.start(); 	
			}
			
		}

		//Function to create more obstacles & enemies as game goes. 
		public function Update_Obstacle_Number(e:TimerEvent):void
		{
			if (game_timer.currentCount % 3 == 0 && game_timer.currentCount != 0 && over == false)
			{
				
				var obstacle_to_appear:Obstacle = new Obstacle();
				obstacle_to_appear.y = - obstacle_to_appear.height; 
	  
				addChild(obstacle_to_appear);
				
				if(obstacle_count == 0){
					obstacle_to_appear.speed = 10 + 0.5 * game_timer.currentCount; //assume acceleration is 0.5.
				}
				else if (obstacle_count % 2 == 0) {

					obstacle_to_appear.speed = 6 + 0.5 * game_timer.currentCount;
				}
				else if (obstacle_count % 3 == 0) {
					obstacle_to_appear.speed = 7 + 0.5 * game_timer.currentCount;
				}
				
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
		
		//This function is called every frame by Game.as. Moves the objects in the screen.   
		public function UpdateUI():void
		{
			
			if (over != true && start == true)
			{
				
				score = game_timer.currentCount + kill_count;	//Update score based on nbr of kills. 
				score_label.text = "Score:" + " " + score;
				
				var obs_length:int = obstacles.length;
				
				for (var i:int = 0; i < obs_length; i++)	//Go through the obstacles & check there is no collision w/ hero. 
				{
					if (obstacles[i] != null)		
					{
						Collision_Obstacle(obstacles[i]);
					}
				}
				
				var enemy_length:int = enemies.length;
				for (var l:int = 0; l < enemy_length; l++)	//Go through the enemies & check there is no colision w/ hero. 
				{
					if (enemies[l] != null)
					{
						Collision_Enemy(enemies[l]);
					}
				}
				
				hero.Move(user_input);
				user_input = "";
				
				var obstacle_length:int = obstacles.length;
				for (var j:int = 0; j < obstacle_length; j++)	//Go through the obstacles & move them. 
				{
					obstacles[j].Move(user_input);		

				}
				
				
				var enem_length:int = enemies.length;
				for (var k:int = 0; k < enem_length; k++)		//Go through the enemies & move them. 
				{
					if (enemies[k] != null)
					{
						if (enemies[k].y_pos > STAGE_HEIGHT)	//If enemy is leaving screen, delete it. 
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
				
				
				var bullet_length:int = bullets.length;
				for (var proj_dist:int = 0; proj_dist < bullets.length; proj_dist++)	//Check if projectile is out of screen.
				{
					if (bullets[proj_dist] < 0)
					{
						removeChild(bullets[proj_dist]);
						bullets[proj_dist] = null;
						bullets.splice(proj_dist, 1);
					}
				}
				
				for (var n:int = 0; n < bullet_length; n++)		//Go through every projectile & check if it hit something.  
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
			
		
		//Function to check if there's a collision between the hero & an obstacle. 
		private function Collision_Obstacle(obstacle:Obstacle):void
		{
			
			hero_rec.x = hero.x_pos;
			hero_rec.y = hero.y_pos;
			hero_rec.offset(-75, -75);
		
			if(hero_rec.intersects(obstacle.bounds))		//If collision:
			{
				over = true;	 	//Set flag to over to stop the timer & the movements. 
				map.bg_armature.animation.gotoAndStopByProgress("animtion0", 0);	//Stop the scrolling map. 
				setTimeout(Game_Is_Over, 1000);		//Wait 1s before showing GameOver screen. 
			}
				
		}
		
		
		//Function to check if there's a collision between the hero & an enemy.
		private function Collision_Enemy(enemy:Enemy):void
		{
			hero_rec.x = hero.x_pos;
			hero_rec.y = hero.y_pos;
			hero_rec.offset( -70, -70);
			
			enemy_rec.x = enemy.x_pos;
			enemy_rec.y = enemy.y_pos;
			enemy_rec.offset( -37, -37);
			
			if (hero_rec.intersects(enemy_rec))			//If collision: 
			{
				over = true;		//Set flag to over to stop the timer & the movements. 
				map.bg_armature.animation.gotoAndStopByProgress("animtion0", 0);		//Stop the scrolling map. 
				setTimeout(Game_Is_Over, 1000);		//Wait 1s before showing GameOver screen. 
			}
		}
		
		
		//Function to check if there's a collision between a projectile & an enemy.
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
		
			if (bullets[pnum] != null && proj_rec.intersects(enemy_rec))	//If there's a collision: 
			{
				
				explosion_sound = assets.playSound("Explosion");		//Play explosion sound. 
				removeChild(enemy);										//Delete enemy. 
				removeChild(proj);										//Delete projectile. 
				enemies.removeAt(num);
				bullets[pnum] = null;
				bullets.splice(pnum, 1);								//Update array. 
				
				kill_count += 3;										//+3 points. 
			}
		}
		
		
		//Function to check if there's a collision between a projectile & an obstacle. 
		private function Check_Obstacle(obstacle:Obstacle, proj:Projectile, pnum:int):void
		{	
			proj_rec.x = proj.x_pos;
			proj_rec.y = proj.y_pos;
			proj_rec.offset( -5, -5);
			
			if (bullets[pnum] != null && proj_rec.intersects(obstacle.bounds))		//If collision:
			{
				removeChild(proj);					//Delete projectile & leave the obstacle. 
				bullets[pnum] = null;
				bullets.splice(pnum, 1);
			}
		}
		private function Shoot_Button_Pressed():void
		{
			dispatchEventWith(SHOOT_BUTTON_PRESSED, true);
		}
		
		//Keyboard functions -- testing.
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
				case Keyboard.W:
					w_down = true;
					break;
				case Keyboard.S:
					s_down = true;
					break;
			}
			
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
				case Keyboard.S:
					s_down = false;
					break;
				case Keyboard.W:
					w_down = false;
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
		
		
		private function Up_Button_Pressed_Handler(e:TouchEvent):void 
		{
			var touch3:Touch = e.getTouch(up_button);
			if (touch3)
			{
				if(touch3.phase == TouchPhase.BEGAN)//on finger down
				{
					w_down = true;  
				}
				else if(touch3.phase == TouchPhase.ENDED) //on finger up
				{
					w_down = false;
				}
			}
		}
		
		private function Down_Button_Pressed_Handler(event:TouchEvent):void 
		{
			var touch4:Touch = event.getTouch(down_button);
			if (touch4)
			{
				if(touch4.phase == TouchPhase.BEGAN)//on finger down
				{
					s_down = true;
				}
				else if(touch4.phase == TouchPhase.ENDED) //on finger up
				{
					s_down = false;
				}
			}
		}
		
		private function Left_Button_Pressed_Handler(e:TouchEvent):void 
		{
			var touch1:Touch = e.getTouch(left_button);
			if (touch1)
			{
				if(touch1.phase == TouchPhase.BEGAN)//on finger down
				{
					a_down = true;  
				}
				else if(touch1.phase == TouchPhase.ENDED) //on finger up
				{
					a_down = false;
				}
			}
		}
		
		private function Right_Button_Pressed_Handler(event:TouchEvent):void 
		{
			var touch2:Touch = event.getTouch(right_button);
			if (touch2)
			{
				if(touch2.phase == TouchPhase.BEGAN)//on finger down
				{
					d_down = true;
				}
				else if(touch2.phase == TouchPhase.ENDED) //on finger up
				{
					d_down = false;
				}
			}
		}
		
		private function Shoot_Button_Pressed_Handler():void 
		{
			if (over == false)
			{
				space_down = true;
				can_fire = true;
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
			if (w_down)
			{
				user_input = "w";
			}
			if (s_down)
			{
				user_input = "s";
			}
			if (space_down)
			{
				if (can_fire)
				{
					
					if (shoot_timer.currentCount >= 1 && over == false)   //If the hero didn't shoot within the last second, he can shoot. 

					{
						assets = Main.assets;
						projectile = new Projectile(); 
						bullets.push(projectile);
						addChild(projectile);
						shoot_sound = assets.playSound("Fixed Blaster Sound");
						
						projectile.Move_Projectile(hero.x_pos, hero.y_pos); 	//"x" as placeholder to have the same function with same parameter.
						shoot_timer.reset();
						shoot_timer.start();
					}
				}
				can_fire = false;
			}
		}
	}
}



