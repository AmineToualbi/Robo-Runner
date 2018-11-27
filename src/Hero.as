/**
 * ...
 * @author Rich
 */

package 
{
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
	
	public class Hero extends MovableObject
	{
		private var placeholder_json:Object;
		private var placeholder_data:DragonBonesData;
		private var placeholder_atlas_data:TextureAtlasData;
		private var placeholder_atlas:TextureData;
		private var animation_name:String;
		private var hk_armature:StarlingArmatureDisplay;
		private var objects_armature:StarlingArmatureDisplay;
		private var bg_armature:StarlingArmatureDisplay;
			
		private const factory:StarlingFactory = new StarlingFactory();
		
		private const STAGE_WIDTH:int = 1024;
		private const STAGE_HEIGHT:int = 1024;
		
		public function Hero() 
		{
			// The json file has to be exported with DATA VERSION 5.0!
			placeholder_json = Main.assets.getObject("Runner_ske");
			
			var tex_obj:Object = Main.assets.getObject("Runner_tex");
			var tex:Texture = Main.assets.getTexture("Runner_tex");
			
			placeholder_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			placeholder_data = factory.parseDragonBonesData(placeholder_json);
			
			hk_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[0]);
			objects_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[1]);
			bg_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[2]);
			
			hk_armature.x = 600;
			hk_armature.y = 600;
			x_pos = hk_armature.x;  
			y_pos = hk_armature.y;
			
			hk_armature.animation.gotoAndPlayByProgress("Idle_Shoot", 0, -1);
			hk_armature.visible = true;

			speed = 15; 
			
			hk_armature.width = 200;
			hk_armature.height = 200;

			this.addChild(hk_armature);
		}
		
		public function Update():void
		{
			
		}
		
		override public function Move(input:String):void 
		{
			
			//Move left. 
			if (input == "a" && !(hk_armature.x - speed - 0.5 * hk_armature.width <= 0))
			{
				hk_armature.x -= speed; 
			}
			//Move right. 
			if (input == "d" && !(hk_armature.x + speed + 0.5 * hk_armature.width > STAGE_WIDTH))
			{
				hk_armature.x += speed; 
			}
			
			x_pos = hk_armature.x;
			
		}	
	}
}