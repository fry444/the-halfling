package states;

import kha.Color;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.soundLib.SoundManager;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.helper.Screen;
import com.gEngine.display.Text;
import com.gEngine.display.StaticLayer;
import com.loading.basicResources.SoundLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.FontLoader;
import com.loading.Resources;
import com.framework.utils.State;

class MenuState extends State{

    var menuLayer:StaticLayer;
    var screenWidth=Screen.getWidth();
    var screenHeight=Screen.getHeight();
    var gameOver:Bool=false;

    public function new(gameOver:Bool) {
		super();
        this.gameOver = gameOver;		
	}

    override function load(resources:Resources) {
		var atlas = new JoinAtlas(2048, 2048);
        atlas.add(new ImageLoader("halfling_cover"));
        atlas.add(new ImageLoader("game_over"));
		atlas.add(new FontLoader("Kenney_Thick",18));
		resources.add(new SoundLoader("menu", false));
		resources.add(atlas);
	}

    override function init() {
        stage.set_color(Color.White);
		menuLayer=new StaticLayer();	
		stage.addChild(menuLayer);        
        //Imagen
        var image = new Sprite("halfling_cover");
        image.smooth=false;
        image.x=(screenWidth*0.5)-(image.width()*0.5);
        image.y=85;        
        menuLayer.addChild(image); 
        //Titulo
        var titleText = new Text("Kenney_Thick");
        titleText.text="THE HALFLING";
        titleText.scaleX = 2;
        titleText.scaleY = 2;
        titleText.x=(screenWidth*0.5)-(titleText.width());
        titleText.y=60;
        titleText.set_color(Color.Black);
        menuLayer.addChild(titleText);        
        //Texto 
        if(gameOver){ 
            var gameOverText = new Text("Kenney_Thick");
            gameOverText.text="GAME OVER";
            gameOverText.scaleX = 1.5;
            gameOverText.scaleY = 1.5;
            gameOverText.x=(screenWidth/2)-(gameOverText.width()*0.75);
            gameOverText.y=630;
            gameOverText.set_color(Color.Black);
            menuLayer.addChild(gameOverText);  
        }        
		var menuText = new Text("Kenney_Thick");
        menuText.text="PRESS SPACE TO START";
        menuText.x=(screenWidth*0.5)-(menuText.width()*0.5);
        menuText.y=670;
        menuText.set_color(Color.Black);
        menuLayer.addChild(menuText);  
        SoundManager.playMusic("menu",true);
	}

    override function update(dt:Float) {
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
            startGame();    
        }
        super.update(dt);
    }

    function startGame() {
        changeState(new GameState("1","menu"));
    }
    
}