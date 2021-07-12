package states;

import com.gEngine.display.Layer;

class GlobalGameData {
    static public var simulationLayer:Layer;
    static public var heroTakingDamage: Bool = false;    
    static public var heroHealth: Int = 10;

    static public function destroy(){
        simulationLayer=null;        
    }
}