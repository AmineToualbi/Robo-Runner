/**
 * ...
 * @author Rich
 */

package 
{
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dragonBones.textures.TextureAtlasData;
	import dragonBones.textures.TextureData;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class Hero extends Sprite
	{
		private var hero_json:Object;
		private var hero_data:DragonBonesData;
		private var hero_atlas_data:TextureAtlasData;
		private var hero_atlas:TextureData;
		private var hero_display_armature:StarlingArmatureDisplay;
		
		private const factory:StarlingFactory = new StarlingFactory();
		
		public function Hero() 
		{
			// The json file has to be exported with DATA VERSION 5.0!
			hero_json = MAIN.Assets.getObject("Runner_ske");
			
			var tex_obj:Object = MAIN.Assets.getObject("Runner_tex");
			var tex:Texture = MAIN.Assets.getTexture("Runner_tex");
			
			hero_atlas_data = factory.parseTextureAtlasData(tex_obj,tex);
			
			hero_data = factory.parseDragonBonesData(hero_json);
			
			hero_armature = factory.buildArmatureDisplay(hero_data.armatureNames[0]);
			hero_armature.x = Stage_Width / 2;
			hero_armature.y = Stage_Height / 2 - hk_armature.height / 2;
			hero_armature.animation.gotoAndPlayByProgress("Idle", 0, -1);
			
			this.addChild(hero_armature);
			
			
			
			var stage:starling.display.Stage = Starling.current.stage;
		}
		
		
		
	}
	
}