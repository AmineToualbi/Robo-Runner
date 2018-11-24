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
	
	
	public class Enemy extends MovableObject
	{
		private var enemy_json:Object;
		private var enemy_data:DragonBonesData;
		private var enemy_atlas_data:TextureAtlasData;
		private var placeholder_atlas:TextureData;
		private var enemy_armature:StarlingArmatureDisplay;

		
		private const factory:StarlingFactory = new StarlingFactory();
		
		private const STAGE_WIDTH:int = 1024;
		private const STAGE_HEIGHT:int = 1024;
		
		public function Enemy() 
		{
			// The json file has to be exported with DATA VERSION 5.0!
			enemy_json = Main.assets.getObject("Runner_ske");
			
			var tex_obj:Object = Main.assets.getObject("Runner_tex");
			var tex:Texture = Main.assets.getTexture("Runner_tex");
			enemy_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			enemy_data = factory.parseDragonBonesData(enemy_json);
			
			enemy_armature = factory.buildArmatureDisplay(enemy_data.armatureNames[1]);
			enemy_armature.x = 0.1 * enemy_armature.width + Math.random() * (STAGE_WIDTH - 0.5 * enemy_armature.width);
			enemy_armature.y = - enemy_armature.height / 2;
			enemy_armature.visible = true;
			enemy_armature.armature.getSlot("HK_Laser").displayController = "0";
			enemy_armature.armature.getSlot("Cannon_Bullet_Glow").displayController = "1";
			enemy_armature.armature.getSlot("Cannon").displayController = "2";
			enemy_armature.armature.getSlot("Spike").displayController = "3";
			enemy_armature.armature.getSlot("Block_Red").displayController = "4";
			enemy_armature.armature.getSlot("Block").displayController = "5";
			enemy_armature.armature.getSlot("Block_Glow").displayController = "6";
			enemy_armature.armature.getSlot("Spike_Glow").displayController = "7";
			enemy_armature.armature.getSlot("Cannon_Glow").displayController = "8";
			enemy_armature.armature.getSlot("Cannon_Bullet").displayController = "9";
			
			enemy_armature.animation.fadeIn( "Flash_Long", -1, -1, 0, "" + 3);
			
			speed = 5; 
			
			enemy_armature.width = 200;
			enemy_armature.height = 200;

			addChild(enemy_armature);
			
		}
		
		override public function Move(input:String):void {
			enemy_armature.y += speed; 
			
			x_pos = enemy_armature.x;
			y_pos = enemy_armature.y;
		}
	}
}