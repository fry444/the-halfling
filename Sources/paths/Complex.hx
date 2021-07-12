package paths;

import kha.math.FastVector2;

class Complex implements Path{
    
    var paths:Array<Path>;
    var length:Float=0;

    public function new(paths:Array<Path>) {
        this.paths = paths;
        for(path in paths){
            length+=path.getLength();
        }
    }

	public function getPos(s:Float):FastVector2 {
        var targetLength = getLength()*s;
        var currentLength = 0.0;
		for(path in paths){
            if(path.getLength() + currentLength >= targetLength){
                return path.getPos((targetLength-currentLength)/path.getLength());
            }else{
                currentLength+=path.getLength();
            }
        }
        return null;
	}

	public function getLength():Float {
		
        return length;
	}
}