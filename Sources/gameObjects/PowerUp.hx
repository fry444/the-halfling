package gameObjects;

import states.GlobalGameData;
import com.gEngine.display.Stage;
import js.html.Console;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class PowerUp extends Entity{
    public var display:Sprite;
    public var collision:CollisionBox;
    var name: String;

    public function new(powerUpName: String, x:Float, y:Float, stage:Stage, collisionGroup:CollisionGroup) {
        super();        
        name = powerUpName;
        collision = new CollisionBox();

        display = new Sprite(name);
        display.x = x;
        display.y = y;
        display.smooth = false;
        stage.addChild(display);
        
        collision.width = display.width();
        collision.height = display.height();
		
		display.scaleX = display.scaleY = 1;

		collision.x=x;
		collision.y=y;

        collisionGroup.add(collision);
		collision.userData = this;
    }

    override function update(dt:Float) {
		super.update(dt);		
	}    

    public function take():Void{
        Console.log("Hero has "+name);
        if(name=="sword"){
            GlobalGameData.heroWithSword=true;
        }
        if(name=="one_ring"){
            GlobalGameData.heroWithRing=true;
        }
        collision.removeFromParent();    
        display.removeFromParent();    
    }
}