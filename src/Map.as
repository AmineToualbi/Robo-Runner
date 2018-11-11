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
		private var bg_armature:StarlingArmatureDisplay;
			
		private const factory:StarlingFactory = new StarlingFactory();
		
		private const Stage_Width:int = 1024;
		private const Stage_Height:int = 1024;
		
		public static const UP_BUTTON_PRESSED:String = "UP_BUTTON_PRESSED";
		public static const DOWN_BUTTON_PRESSED:String = "DOWN_BUTTON_PRESSED";
		public static const LEFT_BUTTON_PRESSED:String = "LEFT_BUTTON_PRESSED";
		public static const RIGHT_BUTTON_PRESSED:String = "RIGHT_BUTTON_PRESSED";
		public static const SHOOT_BUTTON_PRESSED:String = "SHOOT_BUTTON_PRESSED";
		
		private var up_button:Button;
		private var up_button_texture:Texture;
		private var down_button:Button;
		private var down_button_texture:Texture;
		private var left_button:Button;
		private var left_button_texture:Texture;
		private var right_button:Button;
		private var right_button_texture:Texture;
		private var shoot_button:Button;
		private var shoot_button_texture:Texture;

		
		public function Map()
		{
			placeholder_json = Main.Assets.getObject("Runner_ske");
			//animation_name = "animtion0";
			var tex_obj:Object = Main.Assets.getObject("Runner_tex");
			var tex:Texture = Main.Assets.getTexture("Runner_tex");
			
			placeholder_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			placeholder_data = factory.parseDragonBonesData(placeholder_json);
			
			hk_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[0]);
			objects_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[1]);
			bg_armature = factory.buildArmatureDisplay(placeholder_data.armatureNames[2]);
			bg_armature.x = Stage_Width / 2;
			bg_armature.y = Stage_Height / 2;
			bg_armature.rotation = 3 * Math.PI / 2;
			bg_armature.animation.gotoAndPlayByProgress("animtion0", 0, -1);
			bg_armature.visible = true;
			
			
			addChild(bg_armature);
			//play_button
			var assets:AssetManager = Main.Assets;
			
			// Initialize the button texture
			up_button_texture = assets.getTexture("up");
			up_button = new Button(up_button_texture);
			down_button_texture = assets.getTexture("down");
			down_button = new Button(down_button_texture);
			left_button_texture = assets.getTexture("left");
			left_button = new Button(down_button_texture);
			right_button_texture = assets.getTexture("right");
			right_button = new Button(down_button_texture);
			shoot_button_texture = assets.getTexture("shoot");
			shoot_button = new Button(down_button_texture);
			
			// Add an event listener for when the button is pressed
			//up_button.addEventListener(Event.TRIGGERED, UP_Button_Pressed);
			//down_button.addEventListener(Event.TRIGGERED, DOWN_Button_Pressed);
			//left_button.addEventListener(Event.TRIGGERED, LEFT_Button_Pressed);
			//right_button.addEventListener(Event.TRIGGERED, RIGHT_Button_Pressed);
			//shoot_button.addEventListener(Event.TRIGGERED, SHOOT_Button_Pressed);
			
			
			// Center the button
			up_button.x = 1920 - up_button.width * 2;
			up_button.y = 1520
			down_button.x = 1920 - down_button.width * 2;
			down_button.y = 1520 + 25 + up_button.height;
			left_button.x = 1920 - left_button.width * 2;
			left_button.y = 1520 + 25 * 2 + down_button.height;
			right_button.x = 1920 - right_button.width * 2;
			right_button.y = 1520 + 25 * 3 + left_button.height;
			shoot_button.x = 1920 - shoot_button.width * 2;
			shoot_button.y = 1520 + 25 * 4 + right_button.height;
			
			
			
			addChild(up_button);
			addChild(down_button);
			addChild(left_button);
			addChild(right_button);
			addChild(shoot_button);
			
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