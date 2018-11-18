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
		//private var left:Image;
		//private var right:Image;
		private var obstacle:Image; 
		
		public function Obstacle() 
		{
			// Get the asset manager from the MAIN class so images can be loaded
			var assets:AssetManager = Main.Assets;
			var stage:starling.display.Stage = Starling.current.stage;
			// Initialize the images
			obstacle = new Image(assets.getTexture("rBlock"));
			//right = new Image(assets.getTexture("bBlock"));
			
			obstacle.width = 100;
			obstacle.height = 100;
			
			// Initialize to a random position
			obstacle.x = Math.random() * (Starling.current.stage.stageWidth - obstacle.width);
			obstacle.y = -obstacle.height /2;

			
			//right.x = Starling.current.stage.stageWidth/2 + Math.random() * (Starling.current.stage.stageWidth/2-right.width); 
			
			//speed = 5;
			
			// Add the obstacles to the display
			addChild(obstacle);
			//addChild(right);
		}
		
	///	override function Move(input:String):void{
		//	obstacle.y += 5;
			//if (obstacle.y > 1024 + obstacle.height)
			//{
			//	obstacle.y =  - obstacle.height;
		//		obstacle.Regenerate();
		//	}
		//}
		
		override public function Move(input:String):void
		{
			obstacle.y += speed;
			if (obstacle.y > 1024 + 0.5 * 100)
			{
				//removeChild(obstacle);
				obstacle.y = -  obstacle.height /2;

				Regenerate();
			}
			xPos = obstacle.x-50; 
			yPos = obstacle.y-50; 
		}
			
		// Reset the obstacle to a randomized position
		public function Regenerate():void
		{
			obstacle.x = Math.random() * (Starling.current.stage.stageWidth - obstacle.width);
			obstacle.y = - obstacle.height;
			//addChild(obstacle);
			//right.x = Starling.current.stage.stageWidth/2 + Math.random() * (Starling.current.stage.stageWidth/2-right.width); 
		}
	}

}