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
		private var gameOver_menu:Image;
		public static const EXIT_BUTTON_PRESSED:String = "EXIT_BUTTON_PRESSED";
		private var exit_button:Button;
		private var exit_button_texture:Texture;
		public static const RESTART_BUTTON_PRESSED:String = "RESTART_BUTTON_PRESSED";
		private var restart_button:Button;
		private var restart_button_texture:Texture;
		private var CreditLabel:TextField;
		private var TotalCreditLabel:TextField;
		private var TotalCredit:int;
		
		public function GameOver() 
		{
			
			var assets:AssetManager = Main.Assets;
			//ADD TEXTURE TO ASSETS!
			gameOver_menu = new Image(assets.getTexture("gameOver"));
			addChild(gameOver_menu);
			
			
			//text
			CreditLabel = new TextField(400, 50, "Yon won : " + Level.Score + " credits");
			CreditLabel.format.font = "Arial";
			CreditLabel.format.color = 0xffffff;
			CreditLabel.format.size = 40;
			CreditLabel.x = 300;
			CreditLabel.y = 300;
			addChild(CreditLabel);
			
			TotalCredit = Level.Score + Level.credits;
			
			TotalCreditLabel = new TextField(400, 50, "Total Credit: " + TotalCredit);
			TotalCreditLabel.format.font = "Arial";
			TotalCreditLabel.format.color = 0xffffff;
			TotalCreditLabel.format.size = 40;
			TotalCreditLabel.format.horizontalAlign = Align.LEFT;
			addChild(TotalCreditLabel);
			
			// Initialize the button texture
			//ADD TEXTURE TO ASSETS
			exit_button_texture = assets.getTexture("exit");
		    exit_button = new Button(exit_button_texture);
			restart_button_texture = assets.getTexture("restart");
		    restart_button = new Button(restart_button_texture);
			
			// Add an event listener for when the button is pressed
			exit_button.addEventListener(Event.TRIGGERED, Exit_Button_Pressed);
			restart_button.addEventListener(Event.TRIGGERED, Restart_Button_Pressed);
			
			//DETERMINE WHERE TO PUT IT, PROBS IN MIDDLE.
			exit_button.x = 380;
			exit_button.y = 430;
			restart_button.x = 380;
			restart_button.y = 600;
			
			addChild(exit_button);
			addChild(restart_button);	
			
		}
		
		//Basically, it sends our PLAY_BUTTON_PRESSED back to Game class. 
		private function Exit_Button_Pressed():void
		{
			dispatchEventWith(EXIT_BUTTON_PRESSED, true);
		}
		
		private function Restart_Button_Pressed():void
		{
			dispatchEventWith(RESTART_BUTTON_PRESSED, true);
		}
		
		
		
	}

}