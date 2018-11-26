package 
{
	import starling.assets.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.events.Event;
	import starling.display.Button;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	/**
	 * ...
	 * @author Amine Toualbi
	 */
	public class GameOver extends Sprite
	{
		private var game_over_menu:Image;
		public static const EXIT_BUTTON_PRESSED:String = "EXIT_BUTTON_PRESSED";
		private var exit_button:Button;
		private var exit_button_texture:Texture;
		public var credit_label:TextField;
		public var total_credit_label:TextField;
		public static var total_credit:int;
		
		public function GameOver() 
		{
			
			var assets:AssetManager = Main.assets;
			//ADD TEXTURE TO ASSETS!
			game_over_menu = new Image(assets.getTexture("gameOver_final"));
			addChild(game_over_menu);
			
			
			//text
			credit_label = new TextField(400, 50, "Yon won : " + Level.score + " credits");
			credit_label.format.font = "Arial";
			credit_label.format.color = 0xffffff;
			credit_label.format.size = 40;
			credit_label.x = 450;
			credit_label.y = 300;
			addChild(credit_label);
			
			total_credit = Level.score + Level.credits;
			
			total_credit_label = new TextField(400, 50, "Total Credit: " + total_credit);
			total_credit_label.format.font = "Arial";
			total_credit_label.format.color = 0xffffff;
			total_credit_label.format.size = 40;
			total_credit_label.format.horizontalAlign = Align.LEFT;
			addChild(total_credit_label);
			
			// Initialize the button texture
			//ADD TEXTURE TO ASSETS
			exit_button_texture = assets.getTexture("exit");
		    exit_button = new Button(exit_button_texture);
			
			// Add an event listener for when the button is pressed
			exit_button.addEventListener(Event.TRIGGERED, Exit_Button_Pressed);
			
			//DETERMINE WHERE TO PUT IT, PROBS IN MIDDLE.
			exit_button.x = 500;
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