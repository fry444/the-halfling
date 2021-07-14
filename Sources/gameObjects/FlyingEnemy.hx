package gameObjects;

import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import paths.Complex;
import paths.Linear;
import kha.math.FastVector2;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import paths.PathWalker;

class FlyingEnemy extends Enemy{
    private var pathWalker: PathWalker;  
    var flying:Bool;
    var originalPosition: FastVector2;

    public function new(x:Float, y:Float, width:Float, height:Float,scale:Float, name:String, layer:Layer, collisionGroup:CollisionGroup, heroCollision: CollisionBox) {
        super(x,y,width, height, scale, layer,collisionGroup);        
        originalPosition = new FastVector2(x,y);  
        hero = heroCollision;
        sound = "bat";
		
        display = new Sprite(name);
        display.timeline.playAnimation("idle");
        display.smooth = false;
        layer.addChild(display);
        
        collision.width = display.width()*scale;
        
        collision.height = display.height()*scale;
		display.pivotX=display.width()*0.5;
		
		display.scaleX = display.scaleY = scale;

		collision.x=x+5;
		collision.y=y-20;

        collisionGroup.add(collision);
		collision.userData = this;

        dir=new FastVector2(0,1);
    }

    public function createPath(from:FastVector2, to: FastVector2) {
        var goPath = new Linear(from,to);
        var backPath = new Linear(to,from);
        var path = new Complex([goPath, backPath]);
        pathWalker = new PathWalker(path,4,PlayMode.Loop);
    }

    public function startFlying(x:Float, y:Float){
        createPath(originalPosition, new FastVector2(x, y));
        display.timeline.playAnimation("fly");        
        flying = true;
    }

    override public function update(dt:Float):Void {
        if (dying)
        {
            if (!display.timeline.playing) {
                die();
            }
        }else
        if(flying){
            pathWalker.update(dt);
            collision.x = pathWalker.x;
            collision.y = pathWalker.y;			
            dir.x = collision.x - collision.lastX;
            dir.y = collision.y - collision.lastY;
                
            collision.update(dt);

            if(pathWalker.finish()){
                die();
            }                
        }else{
            var distanceXToHero = Math.abs(hero.x - collision.x);
            var distanceYToHero = Math.abs(hero.y - collision.y);
            if(distanceXToHero<=200 && distanceYToHero<=200 ){ 
                startFlying(hero.x,hero.y);
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