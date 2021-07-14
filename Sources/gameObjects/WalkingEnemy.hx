package gameObjects;

import com.collision.platformer.CollisionBox;
import paths.Complex;
import kha.math.FastVector2;
import paths.Linear;
import paths.PathWalker;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;

class WalkingEnemy extends Enemy{

    private var pathWalker: PathWalker;    

    public function new(x:Float, y:Float, width:Float, height:Float,scale:Float, name:String, layer:Layer, 
        collisionGroup:CollisionGroup, heroCollision: CollisionBox) {
        super(x,y,width, height, scale, layer,collisionGroup);        
        var pathStart = new FastVector2(x,y);
		var pathEnd = new FastVector2(x+width,y);
		var rightPath = new Linear(pathStart,pathEnd);
		var leftPath = new Linear(pathEnd,pathStart);
		var path = new Complex([rightPath, leftPath]);
        sound = name;
        hero = heroCollision;
		
        display = new Sprite(name);
        display.timeline.playAnimation("run");
        display.smooth = false;
        layer.addChild(display);
        
        collision.width = display.width()*scale;        
        collision.height = display.height()*scale;
		display.pivotX=display.width()*0.5;		
		display.scaleX = display.scaleY = scale;

		collision.x=x;
		collision.y=y;

        if(name=="goblin"){
            collision.width = collision.width*0.5;
            display.scaleY = 2.5;
            display.offsetY = -32;
        }

        collision.userData = this;
        collisionGroup.add(collision);
		
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