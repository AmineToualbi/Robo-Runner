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
	import starling.assets.AssetManager;
	import starling.textures.Texture;
	import starling.events.Event;
	import starling.display.Button;
	
	public class Map extends Sprite
	{
		private var placeholder_json:Object;
		private var placeholder_data:DragonBonesData;
		private var placeholder_atlas_data:TextureAtlasData;
		private var placeholder_atlas:TextureData;
		private var animation_name:String;
		private var hk_armature:StarlingArmatureDisplay;
		private var objects_armature:StarlingArmatureDisplay;
		public var bg_armature:StarlingArmatureDisplay;
			
		private const factory:StarlingFactory = new StarlingFactory();
		
		private const STAGE_WIDTH:int = 1024;
		private const STAGE_HEIGHT:int = 1024;
		
		public function Map()
		{
			placeholder_json = Main.assets.getObject("Runner_ske");
			var tex_obj:Object = Main.assets.getObject("Runner_tex");
			var tex:Texture = Main.assets.getTexture("Runner_tex");
			
			placeholder_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			placeholder_data = factory.parseDragonBonesData(placeholder_json);
			
			hk_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[0]);
			objects_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[1]);
			bg_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[2]);
			bg_armature.x = STAGE_WIDTH / 2;
			bg_armature.y = STAGE_HEIGHT / 2;
			bg_armature.rotation = 3 * Math.PI / 2;			//Rotate the map. 
			bg_armature.animation.gotoAndPlayByProgress("animtion0", 0, -1);	//Make the map scroll. 
			bg_armature.visible = true;
			
			
			addChild(bg_armature);
			var assets:AssetManager = Main.assets;
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