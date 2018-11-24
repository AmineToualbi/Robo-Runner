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
	
	public class Obstacle extends MovableObject
	{
		private var obstacle:Image; 
		private const STAGE_WIDTH:int = 1024;
		private const STAGE_HEIGHT:int = 1024;
		
		public function Obstacle() 
		{
			// Get the asset manager from the MAIN class so images can be loaded
			var assets:AssetManager = Main.assets;
		
			// Initialize the images
			obstacle = new Image(assets.getTexture("rBlock"));
			
			obstacle.width = 100;
			obstacle.height = 100;
			
			// Initialize to a random position
			obstacle.x = Math.random() * (STAGE_WIDTH - obstacle.width);

			obstacle.y = -obstacle.height /2;

			// Add the obstacles to the display
			addChild(obstacle);
		}
		
		override public function Move(input:String):void
		{
			obstacle.y += speed;
			if (obstacle.y > 1024 + 0.5 * 100)
			{
				obstacle.y = -  obstacle.height /2;
	
				Regenerate();
			}
			x_pos = obstacle.x; 
			y_pos = obstacle.y; 
		}
			
		// Reset the obstacle to a randomized position
		public function Regenerate():void
		{
			obstacle.x = Math.random() * (STAGE_WIDTH - obstacle.width);
			obstacle.y = - obstacle.height;
			//addChild(obstacle);
			//right.x = Starling.current.stage.stageWidth/2 + Math.random() * (Starling.current.stage.stageWidth/2-right.width); 
		}
	}

}