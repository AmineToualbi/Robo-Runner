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
		private var left:Image;
		private var right:Image;
		
		public function Obstacle() 
		{
			// Get the asset manager from the MAIN class so images can be loaded
			var assets:AssetManager = Main.Assets;
			var stage:starling.display.Stage = Starling.current.stage;
			// Initialize the images
			left = new Image(assets.getTexture("rBlock"));
			right = new Image(assets.getTexture("bBlock"));
			
			// Initialize to a random position
			left.x = Math.random() * (Starling.current.stage.stageWidth/2-left.width);
			right.x = Starling.current.stage.stageWidth/2 + Math.random() * (Starling.current.stage.stageWidth/2-right.width); 
			
			// Add the obstacles to the display
			addChild(left);
			addChild(right);
		}
		// Reset the obstacle to a randomized position
		public function Regenerate():void
		{
			left.x = Math.random() * (Starling.current.stage.stageWidth/2-left.width);
			right.x = Starling.current.stage.stageWidth/2 + Math.random() * (Starling.current.stage.stageWidth/2-right.width); 
		}
	}

}