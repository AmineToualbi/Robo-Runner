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
	
	public class Map extends Sprite
	{
		private var map_json:Object;
		private var map_data:DragonBonesData;
		private var map_atlas_data:TextureAtlasData;
		private var map_atlas:TextureData;
		private var animation_name:String;
		private var hk_armature:StarlingArmatureDisplay;
		private var objects_armature:StarlingArmatureDisplay;
		private var bg_armature:StarlingArmatureDisplay;
			
		private const factory:StarlingFactory = new StarlingFactory();
		
		private const Stage_Width:int = 1920;
		private const Stage_Height:int = 1080;
		
		public function Map()
		{
			map_json = Main.Assets.getObject("Runner_ske");
			animation_name = "animtion0";
			var tex_obj:Object = Main.Assets.getObject("Runner_tex");
			var tex:Texture = Main.Assets.getTexture("Runner_tex");
			
			map_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			map_data = factory.parseDragonBonesData(map_json);
			
			hk_armature = factory.buildArmatureDisplay(map_data.armatureNames[0]);
			objects_armature = factory.buildArmatureDisplay(map_data.armatureNames[1]);
			bg_armature = factory.buildArmatureDisplay(map_data.armatureNames[2]);
			bg_armature.x = Stage_Width / 2;
			bg_armature.y = Stage_Height / 2;
			bg_armature.animation.gotoAndPlayByProgress("animtion0", 0, -1);
			bg_armature.visible = true;
			
			
			addChild(bg_armature);
			
			//Update_Armature_Display();
			//Update_Animation_Display();
			//Update_Object_Display();
			
		}
		
		private function Update_Animation_Display():void
		{
			animation_name = "mapanim"; // typo, I know
			bg_armature.animation.gotoAndPlayByProgress(animation_name , 0, -1);
		}
		private function Update_Armature_Display():void
		{
			bg_armature.visible = true;
		}
		private function Update_Object_Display():void
		{
			// Starts the animation specified by animation_name, using the display controller specified by objects_index
			objects_armature.animation.fadeIn( animation_name, -1, -1, 0, "" + 2);
		}
		
	}
	
}