package gameObjects;

import haxe.Timer;
import com.soundLib.SoundManager;
import kha.math.FastVector2;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import com.framework.utils.Entity;

class Enemy extends Entity{
    private var width:Float;
    private var height:Float;
    public var display:Sprite;
    public var collision:CollisionBox;
    var dying:Bool;
	var dir:FastVector2;
    var hero: CollisionBox;
    var sound: String;
    var playingProximitySound: Bool = false;

    public function new(x:Float, y:Float, w: Float, h: Float, s: Float, layer:Layer, collisionGroup:CollisionGroup) {
        super();        
        width = w*s;
        height = h*s;
        collision = new CollisionBox();
    }

    override function update(dt:Float) {
        if(hero!=null){
            var distanceXToHero = Math.abs(hero.x - collision.x);
            var distanceYToHero = Math.abs(hero.y - collision.y);
            if(!playingProximitySound){
                if(distanceXToHero<=200 && distanceYToHero<=200 ){ 
                    playProximitySound();
                }
            }  
        }
		super.update(dt);		
	}    

    public function damage():Void{
        playDeathSound();
        display.timeline.playAnimation("die",false);
        collision.removeFromParent();
        dying = true;
    }

    public function playProximitySound(){        
        if(sound!="archer"){            
            playingProximitySound=true;
            SoundManager.playFx(sound+"_near_sound",false);
            Timer.delay(stopProximitySound,2000);                
        }              
    }

    function stopProximitySound() {
        playingProximitySound = false;  
    }

    public function playDeathSound(){
        SoundManager.playFx(sound+"_death_sound",false);
    }
    
}