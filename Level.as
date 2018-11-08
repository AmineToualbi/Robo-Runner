/**
 * ...
 * @author Rich
 */

package 
{
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import flash.ui.Keyboard;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	
	public class Level extends Sprite
	{
		private var hero:Hero;
		//private var flap_button:Button;
		//private var flap_button_texture:Texture;
		
		private var obstacle:Obstacle;
		private var map:Map;
		private const Stage_Width:int = 1024;
		private const Stage_Height:int = 1024;
		
		public function Level() 
		{
			var stage:starling.display.Stage = Starling.current.stage;
			
			map = new Map();
			hero = new Hero();
			obstacle = new Obstacle();
			
			// Set the obstacle's initial position
			obstacle.y = 0; // screen width
			
			// Initialize the button texture
			//flap_button_texture = MAIN.Assets.getTexture("flapWingsButton");
			//flap_button = new Button(flap_button_texture);
			
			// Place button in bottom center
			//flap_button.x = stage.stageWidth / 2 - flap_button.width / 2;
			//flap_button.y = stage.stageHeight - flap_button.height;
			
			// Add the obstacle and player to the display
			//addChild(obstacle);
			
			//addChild(flap_button);
			addChild(map);
			addChild(hero);
			addChild(obstacle);
			// Add keyboard listeners
			// Keyboard Events aren't sent to sprites, 
			// so we have to grab the current stage 
			// and setup the callback to listen on the stage object
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			stage.addEventListener(KeyboardEvent.KEY_UP, On_Key_Up);
			
			// Add button listener
			// flap_button.addEventListener(Event.TRIGGERED, Flap_Wings_Button_Handler);
		}
		public function Update():void
		{
			hero.Update();
			Move_Obstacles();
		}
		
		private function Move_Obstacles():void
		{
			obstacle.y += 5;
			if (obstacle.y > 1080+obstacle.height)
			{
				obstacle.y =  - obstacle.height;
				obstacle.Regenerate();
			}
		}
		
		private function On_Key_Down(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.A)
			{
				hero.x -= 5;
			}
			if (event.keyCode == Keyboard.D)
			{
				hero.x += 5;
			}
		}
		
		private function On_Key_Up(event:KeyboardEvent):void
		{
			// reset now that we've released space
			if(event.keyCode == Keyboard.D)
			{
				
			}
			if (event.keyCode == Keyboard.A)
			{
				
			}
		}
	}
	
}