package helpers;

import com.loading.basicResources.DataLoader;
import com.loading.basicResources.ImageLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SoundLoader;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;

class Loader {
    public static function loadGameAssets(resources: Resources, actualRoom: String) {
        var atlas = new JoinAtlas(2048, 2048);
		atlas.add(new FontLoader("Kenney_Thick",18));
		resources.add(new SoundLoader("pantalla"+actualRoom, false));
		resources.add(new SoundLoader("arrow_sound"));
		resources.add(new SoundLoader("bat_near_sound"));
		resources.add(new SoundLoader("bat_death_sound"));
		resources.add(new SoundLoader("archer_death_sound"));
		resources.add(new SoundLoader("goblin_near_sound"));
		resources.add(new SoundLoader("goblin_death_sound"));
		resources.add(new SoundLoader("sword_sound"));
		resources.add(new SoundLoader("wolf_near_sound"));
		resources.add(new SoundLoader("wolf_death_sound"));
		resources.add(new SoundLoader("power_up_sound"));
		resources.add(new SoundLoader("halfling_damage_sound"));
		resources.add(new DataLoader("pantalla"+actualRoom+"_tmx"));		
		atlas.add(new TilesheetLoader("tiles"+actualRoom, 32, 32, 0));
		atlas.add(new SpriteSheetLoader("halfling", 50, 37, 0, [
			new Sequence("die", [64, 65, 66, 67, 68]),
			new Sequence("jump", [15, 16, 17, 18 ]),
			new Sequence("fall", [19, 20, 21, 22, 23]),
			new Sequence("run", [8, 9, 10, 11, 12, 13]),
			new Sequence("idle", [0, 1, 2, 3]),
			new Sequence("attack", [49, 50, 51, 52]),
			new Sequence("ring_jump", [92, 93, 94, 95 ]),
			new Sequence("ring_fall", [96, 97, 98, 99, 100]),
			new Sequence("ring_run", [85, 86 ,87, 88, 89, 90]),
			new Sequence("ring_idle", [77, 78, 79, 80]),
			new Sequence("ring_attack", [126, 127, 128, 129])
		]));
		atlas.add(new SpriteSheetLoader("wolf", 64, 48, 0, [
			new Sequence("idle", [1, 2, 3, 4, 5, 6]),
			new Sequence("run", [76, 77, 78, 79, 80, 81, 82, 83]),
			new Sequence("die", [99, 100, 101, 102, 103, 104])
		]));
		atlas.add(new SpriteSheetLoader("goblin", 80, 64, 0, [
			new Sequence("idle", [1, 2, 3, 4]),
			new Sequence("run", [33, 34, 35, 36, 37, 38, 39, 40, 41, 42]),
			new Sequence("die", [97, 98, 99, 100, 101, 102])
		]));
		atlas.add(new SpriteSheetLoader("bat", 32, 32, 0, [
			new Sequence("idle", [2, 3, 4, 5, 8, 9, 10, 11]),
			new Sequence("fly", [44, 45, 46, 47]),
			new Sequence("die", [72, 73, 74, 75, 76, 77, 78])
		]));
		atlas.add(new SpriteSheetLoader("archer", 100, 100, 0, [
			new Sequence("idle", [0, 1, 2, 3, 4, 5, 8, 9]),
			new Sequence("attack", [13, 14, 15]),
			new Sequence("die", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29])
		]));		
		resources.add(new ImageLoader("sword"));
		resources.add(new ImageLoader("one_ring"));
		resources.add(new ImageLoader("arrow"));
		resources.add(atlas);
    }
}