package 
{
	import starling.assets.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.events.Event;
	import starling.display.Button;
	
	public class Help extends Sprite
	{
		private var help_menu:Image;
		public static const BACK_BUTTON_PRESSED:String = "MENU_BACK_BUTTON_PRESSED";
		private var back_button:Button;
		private var back_button_texture:Texture;
		
		public function Help() 
		{
			var assets:AssetManager = Main.Assets;
			help_menu = new Image(assets.getTexture("help_menu"));
			addChild(help_menu);
			
			// Initialize the button texture
			back_button_texture = assets.getTexture("backButton");
			back_button = new Button(back_button_texture);
			
			// Add an event listener for when the button is pressed
			back_button.addEventListener(Event.TRIGGERED, Back_Button_Pressed);
			
			back_button.x = 380;
			back_button.y = 430;
			
			addChild(back_button);
		}
		
		// Dispatch a new event that bubbles up to the GAME class to notify we have pressed the play button
		private function Back_Button_Pressed():void
		{
			dispatchEventWith(BACK_BUTTON_PRESSED, true);
		}
		
	}

}