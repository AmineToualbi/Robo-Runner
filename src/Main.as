package
{
	//import flash.events.Event;
	//import flash.text.TextField;
	import flash.display.Sprite;
	import starling.assets.AssetManager;
	import starling.core.Starling;
	import flash.filesystem.File;
	
	//black area on left of map
	[SWF(backgroundColor = "0x000000")]
	public class Main extends Sprite 
	{
		public static var Assets:AssetManager;
		private var starling:Starling;
		private var menu_screen:Menu;
		
		public function Main() 
		{
			starling = new Starling(Game, stage);
			Assets = new AssetManager();
			starling.start();
			
		}
			/*
			var greeting:TextField = new TextField();
			greeting.text = "Hello World";
			greeting.x = 100;
			greeting.y = 100;
			greeting.textColor = 0xff0000;
			addChild(greeting);
			*/
		
		/*
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			Assets = new AssetManager();
			
			
			
			var greeting:TextField = new TextField();
			greeting.text = "Hello World";
			greeting.x = 100;
			greeting.y = 100;
			greeting.textColor = 0xff0000;
			addChild(greeting);
		
		}
		*/
	}
	
}