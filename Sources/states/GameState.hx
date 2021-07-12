package states;

import gameObjects.WalkingEnemy;
import gameObjects.PowerUp;
import com.loading.basicResources.ImageLoader;
import com.gEngine.display.Sprite;
import com.collision.platformer.Sides;
import com.collision.platformer.ICollider;
import paths.Linear;
import paths.Complex;
import gameObjects.Enemy;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import js.html.Console;
import gameObjects.Halfling;
import com.gEngine.display.extra.TileMapDisplay;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import format.tmx.Data.TmxObject;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionEngine;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;
import kha.math.FastVector2;

class GameState extends State {
	var worldMap:Tilemap;
	var halfling:Halfling;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;
	var mayonnaiseMap:TileMapDisplay;
	var actualRoom:String; 
	var winZone:CollisionBox;
	var enemiesCollision:CollisionGroup = new CollisionGroup();
	var powerUpsCollision:CollisionGroup = new CollisionGroup();

	public function new(room:String = "2", fromRoom:String = null) {
		super();		
		this.actualRoom = room;
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader("pantalla"+actualRoom+"_tmx"));
		var atlas = new JoinAtlas(2048, 2048);
		atlas.add(new TilesheetLoader("tiles"+actualRoom, 32, 32, 0));
		atlas.add(new SpriteSheetLoader("halfling", 50, 37, 0, [
			new Sequence("die", [64, 65, 66, 67, 68]),
			new Sequence("jump", [15, 16, 17, 18 ]),
			new Sequence("fall", [19, 20, 21, 22, 23]),
			new Sequence("run", [8, 9, 10, 11, 12, 13]),
			new Sequence("idle", [0, 1, 2, 3]),
			new Sequence("attack", [49, 50, 51, 52])
		]));
		atlas.add(new SpriteSheetLoader("wolf", 64, 48, 0, [
			new Sequence("idle", [1, 2, 3, 4, 5, 6]),
			new Sequence("run", [76, 77, 78, 79, 80, 81, 82, 83]),
			new Sequence("die", [99, 100, 101, 102, 103, 104])
		]));
		atlas.add(new SpriteSheetLoader("goblin", 80, 64, 0, [
			new Sequence("idle", [1, 2, 3, 4]),
			new Sequence("run", [33, 34, 35, 36, 37, 38, 39, 40, 41, 42]),
			new Sequence("die", [97, 98, 99, 100, 101, 102])
		]));
		resources.add(new ImageLoader("sword"));
		resources.add(atlas);
	}

	override function init() {
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		worldMap = new Tilemap("pantalla"+actualRoom+"_tmx", "tiles"+actualRoom);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer));
		}, parseMapObjects);
		GlobalGameData.simulationLayer = simulationLayer;
		GlobalGameData.attacksCollisionGroup = new CollisionGroup();
		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 * 1, worldMap.heightInTiles * 32 * 1);

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
			if(halfling==null){
				halfling = new Halfling(object.x, object.y, simulationLayer);
				addChild(halfling);
			}
		}else 
		if(compareName(object, "winZone")){
			winZone = new CollisionBox();
			winZone.x = object.x;
			winZone.y = object.y;
			winZone.width = object.width;
			winZone.height = object.height;
		}else 
		if(compareName(object, "wolfZone")){	
			var wolf = new WalkingEnemy(object.x, object.y, 64, 48 ,1, "wolf", simulationLayer, enemiesCollision);
			addChild(wolf);
		}else 
		if(compareName(object, "goblinZone")){	
			var goblin = new WalkingEnemy(object.x-40, object.y-55, 80, 64 ,2, "goblin", simulationLayer, enemiesCollision);
			addChild(goblin);			
		}else 		
		if(compareName(object, "powerSword")){
			new PowerUp("sword", object.x, object.y, stage, powerUpsCollision);			
		}
	}

	inline function compareName(object:TmxObject, name:String){
		return object.name.toLowerCase() == name.toLowerCase();
	}

	override function update(dt:Float) {
		super.update(dt);

		stage.defaultCamera().setTarget(halfling.collision.x, halfling.collision.y);

		CollisionEngine.collide(halfling.collision,worldMap.collision);

		if(CollisionEngine.overlap(halfling.collision, winZone)){
			changeState(new GameState(getNextRoom(),actualRoom));
		}

		CollisionEngine.overlap(halfling.collision, enemiesCollision, heroVsEnemy);
		CollisionEngine.overlap(halfling.collision, powerUpsCollision, heroVsPowerUp);
		CollisionEngine.overlap(GlobalGameData.attacksCollisionGroup, enemiesCollision, attackVsEnemy);
	}

	inline function getNextRoom(){
		if(actualRoom=="menu"){
			return "1";
		}else 
		if(actualRoom=="1"){
			return "2";
		}else
		if(actualRoom=="2"){
			return "3";
		}else
		{
			return "menu";
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
			if(!GlobalGameData.heroTakingDamage){
				hero.damage();
			}			
		}	
	}

	function attackVsEnemy(attackCollision: ICollider, enemyCollision:ICollider){
		var enemy:Enemy = cast enemyCollision.userData;
		enemy.damage();		
	}

	function heroVsPowerUp(powerUpCollision: ICollider, heroCollision:ICollider){
		var powerUp:PowerUp = cast powerUpCollision.userData;
		powerUp.take();
	}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}
