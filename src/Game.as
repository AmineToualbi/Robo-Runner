package 
{

	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLRequest;

	import starling.assets.AssetManager;
	import starling.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	//import flash.net.URLRequest;


	
	
	public class Game extends Sprite
	{
		public static var game_state:int = State.LOADING;
		private var assets:AssetManager;
		private var menu_screen:Menu;
		private var help_screen:Help;
		private var score_screen:Score;
		private var level:Level;
		private var star:Starling;
		private var game:Game;
		private var game_over_screen:GameOver;
		public var insufficient_label: TextField = new TextField(300, 50, "Insufficient Credits!");
		private var music:Sound = new Sound();
		private var music_channel:SoundChannel = new SoundChannel();
		

		
		public function Game() 
		{
			// Grab the asset manager from the MAIN class
			assets = Main.assets;
			
			// Get the app directory location
			var appDir:File = File.applicationDirectory;
			
			// Enque the assets folder for loading
			assets.enqueue(appDir.resolvePath("Assets"));
			assets.enqueue(appDir.resolvePath("/bin/Assets"));
			
			
			// Start loading the assets and setup the event handlers
			assets.loadQueue(On_Assets_Loaded, On_Assets_Load_Error, On_Assets_Load_Progress);
			//At every frame (= every time), run Update(). 
			addEventListener(Event.ENTER_FRAME, Update_Game_State);
			addEventListener(Menu.PLAY_BUTTON_PRESSED, Play_Button_Pressed_Handler);
			addEventListener(Menu.HELP_BUTTON_PRESSED, Help_Button_Pressed_Handler);
			addEventListener(Menu.SCORE_BUTTON_PRESSED, Score_Button_Pressed_Handler);
			addEventListener(Help.BACK_BUTTON_PRESSED, Back_Button_Pressed_Handler);
			addEventListener(Score.BACK_BUTTON_PRESSED, Back_Button_Pressed_Handler);
			addEventListener(GameOver.EXIT_BUTTON_PRESSED, Exit_Button_Pressed_Handler);
			addEventListener(Level.GAME_OVER, Game_Over_Handler);
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
			score_screen = new Score();
			game_over_screen = new GameOver();
			
			addChild(menu_screen);
			addChild(help_screen);
			addChild(score_screen);

			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			// Last, set the state to display the menu.
			game_state = State.MENU_SCREEN;
		}
		
		public function Restart():void
		{
			Level.over = false;
			removeChild(level);
			removeChild(menu_screen);
			level = new Level();
			addChild(level);

		}
		
		public function Update_Game_State():void
		{
			switch(game_state)
			{
				case State.LOADING:
					// waiting for assets to finish loading
					break;
					
				case State.MENU_SCREEN:
					menu_screen.visible = true;
					game_over_screen.visible = false;
					addChild(menu_screen);
					break;
					
				case State.HELP_SCREEN:
					help_screen.visible = true;
					menu_screen.visible = false;
					game_over_screen.visible = false;
					addChild(help_screen);
					break;
					
				case State.SCORE_SCREEN:
					help_screen.visible = false;
					menu_screen.visible = false;
					game_over_screen.visible = false;
					
					if (Level.score > Score.score1)
					{
						Score.score3 = Score.score2;
						Score.score2 = Score.score1;
						Score.score1 = Level.score;
					}
					else if (Level.score > Score.score2 && Level.score < Score.score1)
					{
						Score.score3 = Score.score2;
						Score.score2 = Level.score;
					}
					else if (Level.score > Score.score3 && Level.score < Score.score2)
					{
						Score.score3 = Level.score;
					}
					score_screen.no1_label.text = "1. " + Score.score1;
					score_screen.no2_label.text = "2. " + Score.score2;
					score_screen.no3_label.text = "3. " + Score.score3;
					
					addChild(score_screen);
					break;
					
				case State.IN_GAME:
					menu_screen.visible = false;
					help_screen.visible = false;
					game_over_screen.visible = false;
					
					
					// Make sure first level is updated every frame
					level.UpdateUI();
					break;
					
				case State.GAME_OVER:

					removeChild(level);
					menu_screen.visible = false;
					help_screen.visible = false;
					
					// refresh credits in gameover
					GameOver.total_credit = Level.score + Level.credits;
					game_over_screen.total_credit_label.text = "Total Credit: " + GameOver.total_credit;	
					game_over_screen.credit_label.text = "Yon won : " + Level.score + " credits";
					addChild(game_over_screen);
					game_over_screen.visible = true;
					break;
					
				default:
					break;
			}
			
		}
		
		// Change the game state when the play button is pressed
		private function Play_Button_Pressed_Handler():void
		{
			if (Level.credits < 50)
			{
				insufficient_label.format.font = "Arial";
				insufficient_label.format.color = 0xff0000;
				insufficient_label.format.size = 30;
				insufficient_label.x = 475;
				insufficient_label.y = 375;
				
				menu_screen.addChild(insufficient_label);
			}
			else
			{
				
				level = new Level();
				addChild(level);
				level.visible = true;
				Level.credits -= 50;
				
				game_state = State.IN_GAME;
				Level.start = true;
				music_channel = assets.playSound("Intriguing Possibilities");

			}
		}
		
		private function Help_Button_Pressed_Handler():void
		{
			game_state = State.HELP_SCREEN;
		}
		
		private function Score_Button_Pressed_Handler():void
		{
			game_state = State.SCORE_SCREEN;
		}
		
		private function Back_Button_Pressed_Handler():void
		{
			game_state = State.MENU_SCREEN;
		}
		
		private function Exit_Button_Pressed_Handler():void 
		{
			Level.credits = GameOver.total_credit;
			menu_screen.credits_label.text = "Credits: " + Level.credits;
			Restart();
			game_state = State.MENU_SCREEN;
		}
		
		private function Game_Over_Handler():void 
		{
			game_state = State.GAME_OVER;
			music_channel.stop();
		}
		
				
		private function On_Key_Down(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.ENTER:
					if (game_state == State.MENU_SCREEN) 
					{
						Level.credits += 50;
						trace("ENTER PRESSED");
						menu_screen.credits_label.text = "Credits: " + Level.credits;
						menu_screen.removeChild(insufficient_label);
					}
					break;
			}
		}
	}
}
