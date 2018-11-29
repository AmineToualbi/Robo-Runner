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
		public static const SCORE_BUTTON_PRESSED:String = "MENU_SCORE_BUTTON_PRESSED";
		private var play_button:Button;
		private var play_button_texture:Texture;
		private var help_button:Button;
		private var help_button_texture:Texture;
		private var score_button:Button;
		private var score_button_texture:Texture;
		public var credits_label:TextField; 
		
		public function Menu() 
		{
			// Get the asset manager from the MAIN class so images can be loaded
			var assets:AssetManager = Main.assets;
			menu_background = new Image(assets.getTexture("bk"));
			addChild(menu_background);
			
			// Initialize the button texture
			play_button_texture = assets.getTexture("startButton");
			play_button = new Button(play_button_texture);
			help_button_texture = assets.getTexture("helpButton");
			help_button = new Button(help_button_texture);
			score_button_texture = assets.getTexture("scoreButton");
			score_button = new Button(score_button_texture);
			
			credits_label = new TextField(200, 50, "Credits: " + Level.credits);
			credits_label.format.font = "Arial";
			credits_label.format.color = 0xffffff;
			credits_label.format.size = 30;
			
			// Add an event listener for when the button is pressed
			play_button.addEventListener(Event.TRIGGERED, Play_Button_Pressed);
			help_button.addEventListener(Event.TRIGGERED, Help_Button_Pressed);
			score_button.addEventListener(Event.TRIGGERED, Score_Button_Pressed);

			play_button.width = 300;
			help_button.width = 300;
			score_button.width = 275;
			
			play_button.x = 500;
			play_button.y = 500;
			help_button.x = 150;
			help_button.y = 500;
			score_button.x = 850;
			score_button.y = 497;
	
			credits_label.x = 525; 
			credits_label.y = 325; 
			
			addChild(play_button);
			addChild(help_button);
			addChild(score_button);
			
			addChild(credits_label);
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
		
		private function Score_Button_Pressed():void
		{
			dispatchEventWith(SCORE_BUTTON_PRESSED, true);
		}

		
		
	}

}