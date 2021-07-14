package helpers;

import states.GameState;
import com.gEngine.display.Sprite;
import states.GlobalGameData;
import com.gEngine.display.Text;
import com.gEngine.display.Stage;
import com.gEngine.display.StaticLayer;

class Hud {
    var hudLayer:StaticLayer;
    var healthValue:Text; 
    var controlsText:Text; 
    var stage: Stage;
    var gameState: GameState;

    public function new(stage: Stage, gameState: GameState) {
        this.stage = stage;
        this.gameState = gameState;
        hudLayer=new StaticLayer();	
        stage.addChild(hudLayer);     
        var healthText = new Text("Kenney_Thick");
        healthText.x=50;
        healthText.y=50;
        healthText.text="HEALTH";
        hudLayer.addChild(healthText);  
		healthValue = new Text("Kenney_Thick");
        healthValue.x=180;
        healthValue.y=50;
        healthValue.text=""+GlobalGameData.heroHealth;
		hudLayer.addChild(healthValue);  
        showControls();
    }

    public function update(){
		healthValue.text=""+GlobalGameData.heroHealth;
		if(GlobalGameData.heroWithSword){
			var sword = new Sprite("sword");
        	sword.x = 1200;
        	sword.y = 40;
        	sword.smooth = false;
        	hudLayer.addChild(sword);
		}
		if(GlobalGameData.heroWithRing){
			var ring = new Sprite("one_ring");
        	ring.x = 1130;
        	ring.y = 50;
        	ring.smooth = false;
        	hudLayer.addChild(ring);
		}
		hudLayer.update(1);
		if(GlobalGameData.heroHealth<=0){
			gameState.gameOver();
		}
	}

    public function showControls(){
        controlsText = new Text("Kenney_Thick");
        controlsText.x=1070;
        controlsText.y=645;
        controlsText.text="
        PRESS SPACE TO JUMP
        \n\n
        PRESS A TO USE SWORD";
        controlsText.scaleX = 0.5;
        controlsText.scaleY = 0.5;
		hudLayer.addChild(controlsText);  
    }


}