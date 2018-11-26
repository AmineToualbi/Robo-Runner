package 
{
	/**
	 * ...
	 * @author Su
	 */
	
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
	
	public class Score extends Sprite
	{
		private var score_list:Image;
		public static const BACK_BUTTON_PRESSED:String = "BACK_BUTTON_PRESSED";
		private var back_button:Button;
		private var back_button_texture:Texture;
		private var scores:Array = new Array();
		public var no1_label:TextField;
		public static var score1:int;
		public var no2_label:TextField;
		public static var score2:int;
		public var no3_label:TextField;
		public static var score3:int;
		
		public static var total_credit:int;
		
		public function Score() 
		{
			var assets:AssetManager = Main.assets;
			score_list = new Image(assets.getTexture("highest_scores"));
			addChild(score_list);
			back_button_texture = assets.getTexture("backButton");
			back_button = new Button(back_button_texture);
			
			// Add an event listener for when the button is pressed
			back_button.addEventListener(Event.TRIGGERED, Back_Button_Pressed);
			
			back_button.x = 1000;
			back_button.y = 600;
			
			addChild(back_button);
			
			
			
			//text
			no1_label = new TextField(400, 50, "1. " + score1);
			no1_label.format.font = "Arial";
			no1_label.format.color = 0xffffff;
			no1_label.format.size = 40;
			no1_label.x = 450;
			no1_label.y = 200;
			addChild(no1_label);
			
			no2_label = new TextField(400, 50, "2. " + score2);
			no2_label.format.font = "Arial";
			no2_label.format.color = 0xffffff;
			no2_label.format.size = 40;
			no2_label.x = 450;
			no2_label.y = 300;
			addChild(no2_label);
			
			no3_label = new TextField(400, 50, "3. " + score3);
			no3_label.format.font = "Arial";
			no3_label.format.color = 0xffffff;
			no3_label.format.size = 40;
			no3_label.x = 450;
			no3_label.y = 400;
			addChild(no3_label);
		}
		// Dispatch a new event that bubbles up to the GAME class to notify we have pressed the play button
		private function Back_Button_Pressed():void
		{
			dispatchEventWith(BACK_BUTTON_PRESSED, true);
		}
	}

}