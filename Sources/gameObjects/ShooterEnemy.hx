package gameObjects;

import js.html.Console;
import haxe.Timer;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionBox;

class ShooterEnemy extends Enemy{
    var shooting: Bool;
    var hero: CollisionBox;
    var projectileCollison: CollisionGroup;
    var layer: Layer;
    var shootedArrow: Bool = false;

    public function new(
        x:Float, y:Float, width:Float, height:Float,scale:Float, name:String, gameLayer:Layer, 
        collisionGroup:CollisionGroup, heroCollision: CollisionBox, projectileCollisionGroup: CollisionGroup,
        direction: Int) {
            
        super(x,y,width, height, scale, layer,collisionGroup);        
        hero = heroCollision;
        projectileCollison=projectileCollisionGroup;
		layer = gameLayer;

        display = new Sprite(name);
        display.timeline.playAnimation("idle");
        display.smooth = false;
        layer.addChild(display);
        
        collision.width = display.width()*scale;
        
        collision.height = display.height()*scale;
		display.pivotX=display.width()*0.5;
		
		display.scaleX = display.scaleY = scale;
        display.offsetY = -28;

		collision.x=x;
		collision.y=y;

        collisionGroup.add(collision);
		collision.userData = this;

        dir=new FastVector2(direction,0);
    }

    override public function update(dt:Float):Void {
        if (dying)
        {
            if (!display.timeline.playing) {
                die();
            }
        }else
        if(shooting){
            var distanceXToHero = Math.abs(hero.x - collision.x);
            var distanceYToHero = Math.abs(hero.y - collision.y);            
            if(!shootedArrow){ 
                display.timeline.playAnimation("attack",false);   
                shoot(collision.x+45,collision.y+40, layer, dir,projectileCollison);
            }    
            if(distanceXToHero>200 && distanceYToHero>25 ){ 
                shooting = false;
                shootedArrow = false;
            }              
        }else{
            var distanceXToHero = Math.abs(hero.x - collision.x);
            var distanceYToHero = Math.abs(hero.y - collision.y);
            if(distanceXToHero<=300 && distanceYToHero<=50 ){ 
                shooting = true;
            }
        }
        super.update(dt);        
    }

    function shoot(x:Float, y:Float, layer: Layer, direction: FastVector2, projectileCollison: CollisionGroup) {
        var arrow:Arrow=new Arrow(x, y, layer, dir,projectileCollison);
        shootedArrow = true;
        addChild(arrow);
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