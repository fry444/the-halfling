package gameObjects;

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

    public function new(x:Float, y:Float, w: Float, h: Float, s: Float, layer:Layer, collisionGroup:CollisionGroup) {
        super();        
        width = w*s;
        height = h*s;
        collision = new CollisionBox();
    }

    override function update(dt:Float) {
		super.update(dt);		
	}    

    public function damage():Void{
        display.timeline.playAnimation("die",false);
        collision.removeFromParent();
        dying = true;
    }
    
}