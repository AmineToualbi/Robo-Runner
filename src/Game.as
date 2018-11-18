package 
{

	import flash.filesystem.File;
	import starling.assets.AssetManager;
	import starling.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.events.KeyboardEvent;
		import flash.ui.Keyboard;
	
	
	public class Game extends Sprite
	{
		public static var Game_State:int = State.LOADING;
		private var assets:AssetManager;
		private var menu_screen:Menu;
		private var help_screen:Help;
		private var level:Level;
		private var star:Starling;
		private var game:Game;
		private var gameOver_Screen:GameOver;
		
		public function Game() 
		{
			// Grab the asset manager from the MAIN class
			assets = Main.Assets;
			
			// Get the app directory location
			var appDir:File = File.applicationDirectory;
			
			// Enque the assets folder for loading
			assets.enqueue(appDir.resolvePath("Assets"));
			
			// Start loading the assets and setup the event handlers
			assets.loadQueue(On_Assets_Loaded, On_Assets_Load_Error, On_Assets_Load_Progress);
			//At every frame (= every time), run Update(). 
			addEventListener(Event.ENTER_FRAME, UpdateGameState);
			addEventListener(Menu.PLAY_BUTTON_PRESSED, Play_Button_Pressed_Handler);
			addEventListener(Menu.HELP_BUTTON_PRESSED, Help_Button_Pressed_Handler);
			addEventListener(Help.BACK_BUTTON_PRESSED, Back_Button_Pressed_Handler);
			addEventListener(GameOver.EXIT_BUTTON_PRESSED, Exit_Button_Pressed_Handler);
			addEventListener(GameOver.RESTART_BUTTON_PRESSED, Restart_Button_Pressed_Handler);
			addEventListener(Level.GAME_OVER, GameOver_Handler);
		}
		
		public function On_Assets_Load_Error(error:String):void 
		{
			trace("Error loading assets: ", error);
		}
		
		public function On_Assets_Load_Progress(ratio:Number):void
		{
			var percent:int = ratio * 100;
			trace("Loading Progress: ", percent + "%");
		}
		
		// Setup all screens here, now that they've been loaded
		public function On_Assets_Loaded():void
		{
			trace("Everything is loaded");
			
			//Create the menu objects & add child to the scene. 
			menu_screen = new Menu();
			help_screen = new Help();
			level = new Level();
			addChild(menu_screen);
			addChild(help_screen);
			//addChild(gameOver_screen);
			addChild(level);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			// Last, set the state to display the menu.
			Game_State = State.MENU_SCREEN;
			
			
		}
		
		public function restart():void
		{
			Level.Over = false;
			removeChild(level);
			removeChild(menu_screen);
			level = new Level();
			addChild(level);
			
			
		}
		
		public function UpdateGameState():void
		{
			switch(Game_State)
			{
				case State.LOADING:
					// waiting for assets to finish loading
					break;
					
				case State.MENU_SCREEN:
					level.visible = false;
					menu_screen.visible = true;
					addChild(menu_screen);
					break;
					
				case State.HELP_SCREEN:
					level.visible = false;
					help_screen.visible = true;
					menu_screen.visible = false;
					addChild(help_screen);
					break;
					
				case State.IN_GAME:
					//level = new Level();
					//level.visible = true;
					menu_screen.visible = false;
					//level.UpdateUI();
					level.visible = true;
					help_screen.visible = false;
					//removeChild(help_screen);		//removeChild bc help_screen won't be displayed after game starts.
					// Make sure first level is updated every frame
					level.UpdateUI();
					break;
					
				case State.GAME_OVER:
					level.visible = false; 
					removeChild(level);
					menu_screen.visible = false;
					help_screen.visible = false;
					//gameOver_screen.visible = true;
					gameOver_Screen = new GameOver();	//Create GameOver here bc we need to retrieve the Score at that time. 
					addChild(gameOver_Screen);
					gameOver_Screen.visible = true;
					//addChild(gameOver_screen);
					break;
					
				default:
					break;
			}
			
		}
		
		// Change the game state when the play button is pressed
		private function Play_Button_Pressed_Handler():void
		{
			if (Level.credits < 100) {
				var InsufficientLabel: TextField = new TextField(300, 50, "Insufficient Credits!");
				InsufficientLabel.format.font = "Arial";
				InsufficientLabel.format.color = 0xff0000;
				InsufficientLabel.format.size = 30;
				InsufficientLabel.x = 475;
				InsufficientLabel.y = 375;
				
				menu_screen.addChild(InsufficientLabel);
			}
			else {
				Level.credits -= 100;
				menu_screen.removeChild(InsufficientLabel);
				Game_State = State.IN_GAME;
				Level.start = true;
			}
		}
		
		private function Help_Button_Pressed_Handler():void
		{
			Game_State = State.HELP_SCREEN;
		}
		
		private function Back_Button_Pressed_Handler():void
		{
			Game_State = State.MENU_SCREEN;
		}
		
		private function Exit_Button_Pressed_Handler():void 
		{
			///Level.credits = GameOver.TotalCredit;
			//menu_screen.CreditsLabel.text = "Credits: " + Level.credits;
			//restart();
			Game_State = State.MENU_SCREEN;
			
			
		}
		
		private function Restart_Button_Pressed_Handler():void 
		{
			if (Level.credits < 100) {
				var InsufficientLabel: TextField = new TextField(300, 50, "Insufficient Credits!");
				InsufficientLabel.format.font = "Arial";
				InsufficientLabel.format.color = 0xff0000;
				InsufficientLabel.format.size = 30;
				InsufficientLabel.x = 350;
				InsufficientLabel.y = 375;
				
				gameOver_Screen.addChild(InsufficientLabel);
			}
			else {
				Level.credits -= 100;
				restart();
				Game_State = State.IN_GAME;
				
			}
			
		}
		
		private function GameOver_Handler():void 
		{
			Game_State = State.GAME_OVER; 
		}
		
				
		private function On_Key_Down(event:KeyboardEvent):void
		{
			
			switch(event.keyCode)
			{
				case Keyboard.ENTER:
					if(Game_State == State.MENU_SCREEN) {
						Level.credits += 100;
						("ENTER PRESSED");
						menu_screen.CreditsLabel.text = "Credits: " + Level.credits;
					}
					break;
			}
			
		}
		
	}

}
