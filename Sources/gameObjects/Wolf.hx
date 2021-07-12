package gameObjects;

import paths.Path;
import kha.math.FastVector2;
import paths.Linear;
import paths.PathWalker;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import js.html.Console;

class Wolf extends Enemy{

    private var pathWalker: PathWalker;

    public function new(x:Float, y:Float, layer:Layer, collisionGroup:CollisionGroup, path:Path) {
        super(x,y,layer,collisionGroup);
        display = new Sprite("wolf");
        display.timeline.playAnimation("run");
        display.smooth = false;
        layer.addChild(display);
        
        collision.width = display.width();
        collision.height = display.height();
		display.pivotX=display.width()*0.5;
		//display.offsetY = -display.height()+5;
		
		display.scaleX = display.scaleY = 1;

		collision.x=x;
		collision.y=y;

        collisionGroup.add(collision);
		collision.userData = this;

        dir=new FastVector2(0,1);

        pathWalker = new PathWalker(path,5,PlayMode.Loop);
    }

    override public function update(dt:Float):Void {
        if (dying)
        {
            if (!display.timeline.playing) {
                die();
            }
        }else{
            pathWalker.update(dt);
            collision.x = pathWalker.x;
            collision.y = pathWalker.y;			
            dir.x = collision.x - collision.lastX;
            dir.y = collision.y - collision.lastY;
                
            collision.update(dt);

            if(pathWalker.finish()){
                die();
            }
                
        }
        super.update(dt);        
    }
    
    override function destroy() {
        display.removeFromParent();
        collision.removeFromParent();
    }

    override function render() {
        var s = Math.abs(collision.velocityX / collision.maxVelocityX);
		display.timeline.frameRate = (1 / 24) * s + (1 - s) * (1 / 10);
        display.scaleX = -Math.abs(display.scaleX);
        if(dir.x > 0){
            display.scaleX = Math.abs(display.scaleX);
        }else{
            display.scaleX = -Math.abs(display.scaleX);
        }		
		display.x=collision.x;
		display.y=collision.y;
		super.render();		
		
	}
    
}