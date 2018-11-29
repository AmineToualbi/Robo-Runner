package 
{
	/**
	 * ...
	 * @author Su
	 */
	import dragonBones.animation.AnimationState;
	import dragonBones.objects.AnimationConfig;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dragonBones.textures.TextureAtlasData;
	import dragonBones.textures.TextureData;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import flash.ui.Keyboard;
	import flash.events.Event;


	public class Projectile extends MovableObject
	{
		private var projectile_json:Object;
		private var projectile_data:DragonBonesData;
		private var projectile_atlas_data:TextureAtlasData;
		private var placeholder_atlas:TextureData;
		private var objects_armature:StarlingArmatureDisplay;
		
		private const factory:StarlingFactory = new StarlingFactory();
		
		private const STAGE_WIDTH:int = 1024;
		private const STAGE_HEIGHT:int = 1024;
		
		public function Projectile() 
		{
			
			// The json file has to be exported with DATA VERSION 5.0!
			projectile_json = Main.assets.getObject("Runner_ske");
			
			var tex_obj:Object = Main.assets.getObject("Runner_tex");
			var tex:Texture = Main.assets.getTexture("Runner_tex");
			projectile_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			projectile_data = factory.parseDragonBonesData(projectile_json);
			
			objects_armature = factory.buildArmatureDisplay(projectile_data.armatureNames[1]);
			objects_armature.x = 300;
			objects_armature.y = 300;
			objects_armature.visible = true;
			objects_armature.armature.getSlot("HK_Laser").displayController = "0";
			objects_armature.armature.getSlot("Cannon_Bullet_Glow").displayController = "1";
			objects_armature.armature.getSlot("Cannon").displayController = "2";
			objects_armature.armature.getSlot("Spike").displayController = "3";
			objects_armature.armature.getSlot("Block_Red").displayController = "4";
			objects_armature.armature.getSlot("Block").displayController = "5";
			objects_armature.armature.getSlot("Block_Glow").displayController = "6";
			objects_armature.armature.getSlot("Spike_Glow").displayController = "7";
			objects_armature.armature.getSlot("Cannon_Glow").displayController = "8";
			objects_armature.armature.getSlot("Cannon_Bullet").displayController = "9";
			objects_armature.animation.fadeIn( "Flash_Long", -1, -1, 0, "" + 9);
			
			addEventListener(Event.ENTER_FRAME, Move);
			
			speed = 40;
			
			x_pos = objects_armature.x; 
			y_pos = objects_armature.y; 

			addChild(objects_armature);
			
		}
		
		//Projectile has its own movement functions. 
		public function Move_Projectile(heroX:int, heroY:int):void
		{
			objects_armature.x = heroX;
			objects_armature.y = heroY; 
			x_pos = objects_armature.x; 
			y_pos = objects_armature.y;
			
			Move("a"); 		//a is a placehodler to comply with parameter of function. 
			
		}
		
		override public function Move(input:String):void {
			objects_armature.y -= speed;
			y_pos = objects_armature.y; 
			x_pos = objects_armature.x;
		}
		
		public function Delete_Projectile():void {
			removeChild(objects_armature);
		}
	}
}