package gameObjects;

import js.html.Console;
import com.framework.utils.XboxJoystick;
import com.collision.platformer.Sides;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Halfling extends Entity{
    public var display:Sprite;
    public var collision:CollisionBox;

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
		//if (collision.isTouching(Sides.BOTTOM) && collision.velocityX * collision.accelerationX < 0) {
		//	display.timeline.playAnimation("slide");
		//} else 
        if (collision.isTouching(Sides.BOTTOM) && collision.velocityX == 0) {
			display.timeline.playAnimation("idle");
		} else if (collision.isTouching(Sides.BOTTOM) && collision.velocityX != 0) {
			display.timeline.playAnimation("run");
		} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY > 0) {
			display.timeline.playAnimation("fall");
		} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY < 0) {
			display.timeline.playAnimation("jump");
		}
		display.x = collision.x;
		display.y = collision.y;
		
	}

    public function onButtonChange(id:Int, value:Float) {
		if (id == XboxJoystick.LEFT_DPAD) {
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
		
	}

    public function onAxisChange(id:Int, value:Float) {

	}
}