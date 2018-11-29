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
			
			//At every frame (= every time), run Update_Game_State(). 
			//It will keep track of where in the game the player is & show the corresponding screen. 
			addEventListener(Event.ENTER_FRAME, Update_Game_State);
			
			//Listeners for buttons. 
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
			
			//Create the menu objects & add children to the scene. 
			menu_screen = new Menu();
			help_screen = new Help();
			score_screen = new Score();
			game_over_screen = new GameOver();
			
			addChild(menu_screen);
			//addChild(help_screen);
			//addChild(score_screen);

			//Listener to check for "ENTER" key to add 50 credits. 
			stage.addEventListener(KeyboardEvent.KEY_DOWN, On_Key_Down);
			
			//Last, set the state to display the menu.
			game_state = State.MENU_SCREEN;
		}
			
		//Function to restart the game if the user wishes to play again after a game over. 
		public function Restart():void
		{
			level.dispose();
			removeChild(level);				//Remove the old level screen to put back original content. 
			removeChild(menu_screen);
			level = new Level();
			Level.score = 0;
			//addChild(level);
			//Level.over = false;

		}
		
		//Called every frame, this function keeps track of where the user is in the program. 
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
					score_screen.visible = false;
					addChild(menu_screen);
					break;
					
				case State.HELP_SCREEN:
					help_screen.visible = true;
					menu_screen.visible = false;
					game_over_screen.visible = false;
					score_screen.visible = false;
					addChild(help_screen);
					break;
					
				case State.SCORE_SCREEN:
					help_screen.visible = false;
					menu_screen.visible = false;
					game_over_screen.visible = false;
					score_screen.visible = true;
					
					score_screen.no1_label.text = "1st\t " + Score.score1;
					score_screen.no2_label.text = "2nd\t " + Score.score2;
					score_screen.no3_label.text = "3rd\t " + Score.score3;
					
					addChild(score_screen);
					break;
					
				case State.IN_GAME:
					menu_screen.visible = false;
					help_screen.visible = false;
					game_over_screen.visible = false;
					score_screen.visible = false;
					// Make sure first level is updated every frame
					level.UpdateUI();
					break;
					
				case State.GAME_OVER:
					//removeChild(level);
					menu_screen.visible = false;
					help_screen.visible = false;
					score_screen.visible = false;
					Update_High_Score();
				
					
					// refresh credits in gameover
					GameOver.total_credit = Level.score + Level.credits;
					game_over_screen.total_credit_label.text = "Total Credits: " + GameOver.total_credit;	
					game_over_screen.credit_label.text = "Yon won : " + Level.score + " credits";
					addChild(game_over_screen);
					game_over_screen.visible = true;
					break;
					
				default:
					break;
			}
			
		}
		
		private function Update_High_Score(): void
		{
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
					
		}
		
		
		// Change the game state when the play button is pressed
		private function Play_Button_Pressed_Handler():void
		{
			if (Level.credits < 50)					//Display "Insufficient Credits". 
			{
				
				insufficient_label.format.font = "Arial";
				insufficient_label.format.color = 0xff0000;
				insufficient_label.format.size = 30;
				insufficient_label.x = 475;
				insufficient_label.y = 375;
				menu_screen.addChild(insufficient_label);
				
			}
			
			else									//Start game & take 50 credits. 
			{
				
				level = new Level();
				addChild(level);
				level.visible = true;
				Level.credits -= 50;
				
				game_state = State.IN_GAME;
				level.start = true;
				level.over = false;
				
				music_channel = assets.playSound("Intriguing Possibilities");	//Play background music. 

			}
		}
		
		//Functions to change the state of the game when the user presses a specific button. 
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
			music_channel.stop();			//Stop the music when the player dies.
		}
		
				
		//Function to add 50 credits if the user presses "ENTER". 
		private function On_Key_Down(event:KeyboardEvent):void
		{
	
			if (event.keyCode == Keyboard.ENTER)
			{
				if (game_state == State.MENU_SCREEN) 
					{
						Level.credits += 50;
						trace("ENTER PRESSED");
						menu_screen.credits_label.text = "Credits: " + Level.credits;
						menu_screen.removeChild(insufficient_label);
					}
			}
			
		}
		
	}
}
