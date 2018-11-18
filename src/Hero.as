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
		
		private const Stage_Width:int = 1024;
		private const Stage_Height:int = 1024;
		
		public function Hero() 
		{
			// The json file has to be exported with DATA VERSION 5.0!
			placeholder_json = Main.Assets.getObject("Runner_ske");
			
			var tex_obj:Object = Main.Assets.getObject("Runner_tex");
			var tex:Texture = Main.Assets.getTexture("Runner_tex");
			
			placeholder_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			placeholder_data = factory.parseDragonBonesData(placeholder_json);
			
			hk_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[0]);
			objects_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[1]);
			bg_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[2]);
			
			//hk_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[0]);
			hk_armature.x = 600;
			hk_armature.y = 600;
			xPos = hk_armature.x;  
			yPos = hk_armature.y;
			hk_armature.animation.gotoAndPlayByProgress("Idle_Shoot", 0, -1);
			hk_armature.visible = true;
			hk_armature.rotation = 3 * Math.PI / 2;
			
			speed = 15; 
			
			hk_armature.width = 200;
			hk_armature.height = 200;

			
			this.addChild(hk_armature);
			
			
			
			//var stage:starling.display.Stage = Starling.current.stage;
		}
		
		public function Update():void
		{
			
			
			
		}
		
		override public function Move(input:String):void {
			if (input == "s" && !(hk_armature.y + speed + 0.5 * hk_armature.height >= Stage_Height - hk_armature.height)) {
				hk_armature.y += speed; 
			}
			if (input == "a" && !(hk_armature.x - speed - 0.5 * hk_armature.width <= 0)) {
				hk_armature.x -= speed; 
			}
			if (input == "d" && !(hk_armature.x + speed + 0.5 * hk_armature.width > Stage_Width)) {
				hk_armature.x += speed; 
			}
			if (input == "w" && !(hk_armature.y - speed - 0.5 * hk_armature.height <= 0)) {
				hk_armature.y -= speed;
			}
			
			xPos = hk_armature.x;
			//yPos = hk_armature.y; 
		
		}
		
		
	}
	
}