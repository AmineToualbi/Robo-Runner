
/**
 * ...
 * @author Rich
 */

package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import flash.ui.Keyboard;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.assets.AssetManager;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.text.TextField;
	import starling.text.TextFormat;
	
	
	public class Level extends Sprite
	{
		private var hero:Hero;
		private var bullets:Array = new Array();
		//private var flap_button:Button;
		//private var flap_button_texture:Texture;
		
		private var obstacle:Obstacle;
		private var map:Map;
		private var projectile:Projectile;
		private var pre_projectile:Projectile;
		private const Stage_Width:int = 1024;
		private const Stage_Height:int = 1024;
		private var n:int = 0;
		private var start_background:Image;
		private var userInput:String; 
		
		public function Level() 
		{
			var stage:starling.display.Stage = Starling.current.stage;
			var assets:AssetManager = Main.Assets;
			start_background = new Image(assets.getTexture("start"));
			map = new Map();
			hero = new Hero();
			obstacle = new Obstacle();
			projectile = new Projectile();
			
			// Set the obstacle's initial position
			obstacle.y = 0; // screen width
			
			
			
			
			
			addChild(map);
			
			addChild(hero);
			
			addChild(projectile);
			
			addChild(obstacle);
			
			//display points
			var point:TextField = new TextField(100, 50, "Points: ");
			point.format.font = "Arial";
			point.format.color = 0xffffff;
			point.format.size = 30;
			addChild(point);
			
			// Add keyboard listeners
			// Keyboard Events aren't sent to sprites, 
			// so we have to grab the current stage 
			// and setup the callback to listen on the stage object
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			stage.addEventListener(KeyboardEvent.KEY_UP, On_Key_Up);
			
			
			// Add button listener
			// flap_button.addEventListener(Event.TRIGGERED, Flap_Wings_Button_Handler);
		}
		
		//This function is called every frame by Game.as. 
		public function UpdateUI():void
		{
			//hero.Update();
			Move_Obstacles();
			Move_Projectile();
			Collision_Obstacle();
		}
		
		private function Move_Obstacles():void
		{
			obstacle.y += 5;
			if (obstacle.y > 1024 + obstacle.height)
			{
				obstacle.y =  - obstacle.height;
				obstacle.Regenerate();
			}
		}
		
		private function Move_Projectile():void
		{
			for(var i:int = 0; i < bullets.length; i++) 
				{
					addChild(bullets[i]);
					bullets[i].y -= 3; 
				}
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
			
		}
		
		private function Collision_Obstacle():void
		{
			//consider them as rectangles
			var bounds1:Rectangle = hero.bounds;
			var bounds2:Rectangle = obstacle.bounds;
			if (bounds1.intersects(bounds2))
			{	//test
				trace("collisions!");
			}
				
			
		}
		
		private function On_Key_Down(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.A)
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
				var projectile = new Projectile(); 
				addChild(projectile);
				projectile.Move(hero.x, hero.y); 	//"x" as placeholder to have the same function with same parameter.
				userInput = "";
			}
			
			hero.Move(userInput);
		}
		
		private function On_Key_Up(event:KeyboardEvent):void
		{
			// reset now that we've released space
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
				
			}
		}
	}
	
	
}
