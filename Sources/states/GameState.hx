package states;

import haxe.Timer;
import helpers.Loader;
import helpers.Hud;
import com.soundLib.SoundManager;
import gameObjects.ShooterEnemy;
import gameObjects.FlyingEnemy;
import gameObjects.WalkingEnemy;
import gameObjects.PowerUp;
import com.collision.platformer.ICollider;
import gameObjects.Enemy;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import gameObjects.Halfling;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import format.tmx.Data.TmxObject;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionEngine;
import com.gEngine.display.Layer;
import com.collision.platformer.Tilemap;
import com.loading.Resources;
import com.framework.utils.State;

class GameState extends State {
	var worldMap:Tilemap;
	var halfling:Halfling;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;
	var actualRoom:String; 
	var winZone:CollisionBox;
	var limits:CollisionGroup = new CollisionGroup();
	var enemiesCollision:CollisionGroup;
	var arrowsCollision:CollisionGroup;
	var powerUpsCollision:CollisionGroup;
	var hud: Hud;

	public function new(room:String, fromRoom:String = null) {
		super();		
		this.actualRoom = room;
	}

	override function load(resources:Resources) {
		Loader.loadGameAssets(resources, actualRoom);
	}

	override function init() {
		enemiesCollision = new CollisionGroup();
	 	arrowsCollision = new CollisionGroup();
	 	powerUpsCollision = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);		
		worldMap = new Tilemap("pantalla"+actualRoom+"_tmx", "tiles"+actualRoom);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer));
		}, parseMapObjects);	
		hud = new Hud(stage, this);		
		GlobalGameData.simulationLayer = simulationLayer;	
		GlobalGameData.heroWithSword = false;
		GlobalGameData.heroWithRing = false;	
		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 * 1, worldMap.heightInTiles * 32 * 1);
		SoundManager.playMusic("pantalla"+actualRoom,true);
		hud.update("         IF YOU DONT HAVE A SWORD\n\n\n\nJUMP ON THE ENEMIES TO KILL THEM");
		Timer.delay(hud.update.bind(""),4000);
		createTouchJoystick();	
	}	

	function createTouchJoystick() {
		touchJoystick = new VirtualGamepad();
		touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
		touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
		touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
		touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
		touchJoystick.addKeyButton(XboxJoystick.X, KeyCode.A);
		
		touchJoystick.notify(halfling.onAxisChange, halfling.onButtonChange);

		var gamepad = Input.i.getGamepad(0);
		gamepad.notify(halfling.onAxisChange, halfling.onButtonChange);
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		if(compareName(object, "startZone")){
			if(halfling!=null){
				halfling.die();
			}
			halfling = new Halfling(object.x, object.y, simulationLayer, this, enemiesCollision);
			addChild(halfling);			
		}else 
		if(compareName(object, "winZone")){
			winZone = new CollisionBox();
			winZone.x = object.x;
			winZone.y = object.y;
			winZone.width = object.width;
			winZone.height = object.height;
		}else 
		if(compareName(object, "limit")){
			var limit = new CollisionBox();
			limit.x = object.x;
			limit.y = object.y;
			limit.width = object.width;
			limit.height = object.height;
			limits.add(limit);
		}else 
		if(compareName(object, "wolfZone")){	
			var wolf = new WalkingEnemy(object.x, object.y, 64, 48 ,1, "wolf", simulationLayer, enemiesCollision, halfling.collision);
			addChild(wolf);
		}else 
		if(compareName(object, "goblinZone")){	
			var goblin = new WalkingEnemy(object.x-40, object.y-55, 80, 64 ,2, "goblin", simulationLayer, enemiesCollision, halfling.collision);
			addChild(goblin);			
		}else 
		if(compareName(object, "multipleGoblinZone")){	
			var goblinCount = 5;
			for(p in 0 ... goblinCount){
				var xPosition:Float = (object.x-40)+(object.width/goblinCount)*p;
				var goblin = new WalkingEnemy(xPosition, object.y-52, 80, 64 ,2, "goblin", simulationLayer, enemiesCollision, halfling.collision);
				addChild(goblin);			
			}			
		}else 
		if(compareName(object, "batZone")){	
			var bat = new FlyingEnemy(object.x, object.y, 32, 32 ,2, "bat", simulationLayer, enemiesCollision, halfling.collision);
			addChild(bat);			
		}else 	
		if(compareName(object, "rightArrowZone")){	
			var archer = new ShooterEnemy(object.x, object.y, 100, 100 ,1.5, "archer", simulationLayer, enemiesCollision, halfling.collision,arrowsCollision,1);
			addChild(archer);			
		}else	
		if(compareName(object, "leftArrowZone")){	
			var archer = new ShooterEnemy(object.x, object.y, 100, 100 ,1.5, "archer", simulationLayer, enemiesCollision, halfling.collision,arrowsCollision,-1);
			addChild(archer);			
		}else	
		if(compareName(object, "powerSword")){
			new PowerUp("sword", object.x, object.y, stage, powerUpsCollision);			
		}else 		
		if(compareName(object, "powerRing")){
			new PowerUp("one_ring", object.x, object.y, stage, powerUpsCollision);			
		}
	}

	inline function compareName(object:TmxObject, name:String){
		return object.name.toLowerCase() == name.toLowerCase();
	}

	override function update(dt:Float) {
		super.update(dt);

		stage.defaultCamera().setTarget(halfling.collision.x, halfling.collision.y);

		CollisionEngine.collide(halfling.collision,worldMap.collision);
		CollisionEngine.collide(halfling.collision,limits);
		CollisionEngine.overlap(halfling.collision, enemiesCollision, heroVsEnemy);
		CollisionEngine.overlap(halfling.collision, arrowsCollision, heroVsArrow);
		CollisionEngine.overlap(halfling.collision, powerUpsCollision, heroVsPowerUp);

		if(CollisionEngine.overlap(halfling.collision, winZone)){
			goToNextRoom();			
		}
		if(halfling.collision.y > 750){
			gameOver();
		}
	}

	public function gameOver(){
		changeState(new MenuState(true));
	}

	function goToNextRoom(){
		if(actualRoom=="1"){
			changeState(new GameState("2",actualRoom));
		}else
		if(actualRoom=="2"){
			changeState(new GameState("3",actualRoom));
		}else
		{
			changeState(new MenuState(false));
		}
	}

	function heroVsEnemy(enemyCollision: ICollider, heroCollision:ICollider){		
		var enemy:Enemy = cast enemyCollision.userData;
		var hero:Halfling = cast heroCollision.userData;
		var hCollision: CollisionBox = cast heroCollision;
		if(hCollision.velocityY != 0){		
			enemy.damage();		
			hCollision.velocityY = -1000;
		}else{
			if(!GlobalGameData.heroWithRing){
				if(!GlobalGameData.heroTakingDamage){
					hero.damage();
					hud.update("");
				}			
			}
		}	
	}

	function heroVsArrow(arrowCollision: ICollider, heroCollision:ICollider){
		var hero:Halfling = cast heroCollision.userData;
		if(!GlobalGameData.heroWithRing){
			if(!GlobalGameData.heroTakingDamage){
				hero.damage();
				hud.update("");
			}			
		}
	}

	function heroVsPowerUp(powerUpCollision: ICollider, heroCollision:ICollider){
		var powerUp:PowerUp = cast powerUpCollision.userData;
		var power = powerUp.take();
		var message = "";
		if(power=="one_ring"){
			message = "    YOU FOUND THE ONE RING\n\n\n\nENEMIES CANT HURT YOU NOW";
		}
		hud.update(message);
	}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}
