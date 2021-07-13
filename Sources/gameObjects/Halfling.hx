package gameObjects;

import js.html.Console;
import haxe.Timer;
import states.GlobalGameData;
import com.framework.utils.XboxJoystick;
import com.collision.platformer.Sides;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Halfling extends Entity{
    public var display:Sprite;
    public var collision:CollisionBox;
	public var attackCollision:CollisionBox;
	public var rightDirection:Bool = true;
    var maxSpeed = 200;

    public function new(x:Float,y:Float,layer:Layer) {
		super();
        display = new Sprite("halfling");
		display.smooth = false;
        layer.addChild(display);
		collision = new CollisionBox();
		
		collision.width = display.width();
		collision.height = display.height()*1.5;
		display.pivotX=display.width()*0.5;
		display.offsetY = -display.height()*0.5;
		
		display.scaleX = display.scaleY = 2;
		collision.x=x;
		collision.y=y;
		collision.userData = this;

		collision.accelerationY = 2000;
		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;
		collision.dragX = 0.9;
    }

    override function update(dt:Float) {
		super.update(dt);
		
		collision.update(dt);
	}

    override function render() {
		var s = Math.abs(collision.velocityX / collision.maxVelocityX);
		display.timeline.frameRate = (1 / 24) * s + (1 - s) * (1 / 10);
		if(!GlobalGameData.heroTakingDamage ){
			if(!GlobalGameData.heroAttacking){
				if (collision.isTouching(Sides.BOTTOM) && collision.velocityX == 0) {
					display.timeline.playAnimation("idle");
				} else if (collision.isTouching(Sides.BOTTOM) && collision.velocityX != 0) {
					display.timeline.playAnimation("run");
				} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY > 0) {
					display.timeline.playAnimation("fall");
				} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY < 0) {
					display.timeline.playAnimation("jump");
				}
			}			 
		}else{
			display.timeline.playAnimation("die");	
		}        
		display.x = collision.x;
		display.y = collision.y;		
	}

    public function onButtonChange(id:Int, value:Float) {
		if (id == XboxJoystick.LEFT_DPAD) {
			rightDirection = false;
			if (value == 1) {
				collision.accelerationX = -maxSpeed * 4;
				display.scaleX = -Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX < 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.RIGHT_DPAD) {
			rightDirection = true;
			if (value == 1) {
				collision.accelerationX = maxSpeed * 4;
				display.scaleX = Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX > 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.A) {
			if (value == 1) {				
                collision.velocityY = -1000;
			}
		}	
		if (id == XboxJoystick.X) {
			if (value == 1) {				
                attack();
			}
		}		
	}

    public function onAxisChange(id:Int, value:Float) {

	}

	public function attack():Void{
		if(GlobalGameData.heroWithSword){
			if(!GlobalGameData.heroAttacking){
				GlobalGameData.heroAttacking = true;
				display.timeline.playAnimation("attack", false);   
				attackCollision = new CollisionBox();
				if(!rightDirection){
					attackCollision.x = collision.x-collision.width;
				}else{
					attackCollision.x =collision.x;
				}		
				attackCollision.y = collision.y;	
				attackCollision.width = collision.width*2;
				attackCollision.height = collision.height;
				GlobalGameData.attacksCollisionGroup.add(attackCollision);
				Timer.delay(stopAttack, 300);
			}
		}
		
    }

	function stopAttack() {
		GlobalGameData.heroAttacking = false;
		attackCollision.removeFromParent();
	}

	public function damage():Void{
        GlobalGameData.heroTakingDamage = true;
		GlobalGameData.heroHealth--;
		Timer.delay(stopDamage, 500);
    }

	function stopDamage() {
		GlobalGameData.heroTakingDamage = false;
	}
}