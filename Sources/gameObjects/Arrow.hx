package gameObjects;

import com.gEngine.helper.RectangleDisplay;
import com.gEngine.display.Layer;
import com.gEngine.display.Stage;
import com.collision.platformer.CollisionGroup;
import kha.math.FastVector2;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Arrow extends Entity{
    
    public var display:RectangleDisplay;
    var collision:CollisionBox;
    var width:Int=24;
    var height:Int=5;
    var speed:Float=500;
    var time:Float=0;
    
    public function new(x:Float, y:Float, stage:Layer, dir:FastVector2, collisionGroup:CollisionGroup){
        super();
        display=new RectangleDisplay();
        display.setColor(101,67,33);
        display.scaleX=width;
        display.scaleY=height;
        stage.addChild(display);

        collision=new CollisionBox();
        collision.width=width;
        collision.height=height;
        collision.x=x-width;
        collision.y=y-height;
        collision.velocityX=dir.x*speed;
        collision.velocityY=dir.y*speed;
        collision.userData=this;
        collisionGroup.add(collision);
    }

    override function update(dt:Float) {
        time+=dt;
        super.update(dt);
        collision.update(dt);        
        if(time>2){
            die();
        }
    }

    override function render() {
        super.render();
        display.x=collision.x;
        display.y=collision.y;
    }

    override function destroy() {
        super.destroy();
        display.removeFromParent();
        collision.removeFromParent();
    }
}