package 
{

	import flash.filesystem.File;
	import starling.assets.AssetManager;
	import starling.display.Sprite;
	import flash.events.Event;
	
	public class Game extends Sprite
	{
		public static var Game_State:int = State.LOADING;
		private var assets:AssetManager;
		private var menu_screen:Menu;
		private var help_screen:Help;
		private var gameOver_screen:GameOver;
		private var level:Level;
		
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
			addChild(level);
			
			// Last, set the state to display the menu.
			Game_State = State.MENU_SCREEN;
			
			
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
					//addChild(help_screen);
					break;
					
				case State.IN_GAME:
					//level.visible = true;
					menu_screen.visible = false;
					level.UpdateUI();
					level.visible = true;
					removeChild(help_screen);		//removeChild bc help_screen won't be displayed after game starts.
					// Make sure first level is updated every frame
					level.UpdateUI();
					break;
					
				case State.GAME_OVER:
	
					break;
					
				default:
					break;
			}
			
		}
		
		// Change the game state when the play button is pressed
		private function Play_Button_Pressed_Handler():void
		{
			Game_State = State.IN_GAME;
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
			Game_State = State.GAME_OVER;
		}
		
	}

}
