package 
{
	import starling.assets.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.events.Event;
	import starling.display.Button;
	import starling.events.KeyboardEvent;
		import flash.ui.Keyboard;

	
	public class Menu extends Sprite
	{
		private var menu_background:Image;
		public static const PLAY_BUTTON_PRESSED:String = "MENU_PLAY_BUTTON_PRESSED";
		public static const HELP_BUTTON_PRESSED:String = "MENU_HELP_BUTTON_PRESSED";
		private var play_button:Button;
		private var play_button_texture:Texture;
		private var help_button:Button;
		private var help_button_texture:Texture;
		public var CreditsLabel:TextField; 
		
		public function Menu() 
		{
			// Get the asset manager from the MAIN class so images can be loaded
			var assets:AssetManager = Main.Assets;
			menu_background = new Image(assets.getTexture("bk"));
			addChild(menu_background);
			
			// Initialize the button texture
			play_button_texture = assets.getTexture("startButton");
			play_button = new Button(play_button_texture);
			help_button_texture = assets.getTexture("helpButton");
			help_button = new Button(help_button_texture);
			
			CreditsLabel = new TextField(200, 50, "Credits: " + Level.credits);
			CreditsLabel.format.font = "Arial";
			CreditsLabel.format.color = 0xffffff;
			CreditsLabel.format.size = 30;
			
			// Add an event listener for when the button is pressed
			play_button.addEventListener(Event.TRIGGERED, Play_Button_Pressed);
			help_button.addEventListener(Event.TRIGGERED, Help_Button_Pressed);

			
			play_button.width = 300;
			help_button.width = 300;
			
			// Center the button
			play_button.x = 150;
			play_button.y = 500;
			help_button.x = 550;
			help_button.y = 500;
			
			CreditsLabel.x = 400; 
			CreditsLabel.y = 300; 
			
			addChild(play_button);
			addChild(help_button);
			
			addChild(CreditsLabel);
		}
		
		// Dispatch a new event that bubbles up to the GAME class to notify we have pressed the play button
		private function Play_Button_Pressed():void
		{
			dispatchEventWith(PLAY_BUTTON_PRESSED, true);
		}
		
		private function Help_Button_Pressed():void
		{
			dispatchEventWith(HELP_BUTTON_PRESSED, true);
		}

		
		
	}

}