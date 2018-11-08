package 
{
	import starling.assets.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.events.Event;
	import starling.display.Button;
	/**
	 * ...
	 * @author Amine Toualbi
	 */
	public class GameOver extends Sprite
	{
		private var gameOver_menu:Image;
		public static const EXIT_BUTTON_PRESSED:String = "EXIT_BUTTON_PRESSED";
		private var exit_button:Button;
		private var exit_button_texture:Texture;
		
		public function GameOver() 
		{
			
			var assets:AssetManager = Main.Assets;
			//ADD TEXTURE TO ASSETS!
			gameOver_menu = new Image(assets.getTexture("gameOver"));
			addChild(gameOver_menu);
			
			// Initialize the button texture
			//ADD TEXTURE TO ASSETS
			exit_button_texture = assets.getTexture("exitButton");
		    exit_button = new Button(exit_button_texture);
			
			// Add an event listener for when the button is pressed
			exit_button.addEventListener(Event.TRIGGERED, Exit_Button_Pressed);
			
			//DETERMINE WHERE TO PUT IT, PROBS IN MIDDLE.
			exit_button.x = 380;
			exit_button.y = 430;
			
			addChild(exit_button);
			
		}
		
		//Basically, it sends our PLAY_BUTTON_PRESSED back to Game class. 
		private function Exit_Button_Pressed():void
		{
			dispatchEventWith(EXIT_BUTTON_PRESSED, true);
		}
		
	}

}