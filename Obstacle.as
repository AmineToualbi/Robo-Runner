package 
{
	/**
	 * ...
	 * @author Su
	 */
	
	import starling.assets.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.core.Starling;
	
	public class Obstacle extends Sprite
	{
		private var bottom:Image;
		private var top:Image;
		
		public function Obstacle() 
		{
			// Get the asset manager from the MAIN class so images can be loaded
			var assets:AssetManager = Main.Assets;
			var stage:starling.display.Stage = Starling.current.stage;
			// Initialize the images
			bottom = new Image(assets.getTexture("rBlock"));
			top = new Image(assets.getTexture("bBlock"));
			
			// Initialize to a random position
			top.y = Math.random()*(Starling.current.stage.stageHeight/2-top.height);
			bottom.y = Starling.current.stage.stageHeight / 2 + Math.random() * (Starling.current.stage.stageHeight - bottom.height); 
			
			// Add the obstacles to the display
			addChild(bottom);
			addChild(top);
		}
		// Reset the obstacle to a randomized position
		public function Regenerate():void
		{
			top.y = Math.random()*(Starling.current.stage.stageHeight/2-top.height);
			bottom.y = Starling.current.stage.stageHeight / 2 + Math.random() * (Starling.current.stage.stageHeight - bottom.height);
		}
	}

}