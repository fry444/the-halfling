package paths;

import kha.math.FastVector2;

class Bezier implements Path{

    var start: FastVector2;
    var c1: FastVector2;
    var c2: FastVector2;
    var end: FastVector2;
    
    var temp = new FastVector2();

    public function new(start:FastVector2, c1:FastVector2,c2:FastVector2, end:FastVector2) {
        this.start=start;
        this.c1=c1;
        this.c2=c2;
        this.end=end;
    }

	public function getPos(s:Float):FastVector2 {
		var t1 = new FastVector2(LERP(start.x,c1.x,s), LERP(start.y,c1.y,s));
        var t2 = new FastVector2(LERP(c1.x,c2.x,s), LERP(c1.y,c2.y,s));
        var t3 = new FastVector2(LERP(c2.x,end.x,s), LERP(c2.y,end.y,s));

        var t4 = new FastVector2(LERP(t1.x,t2.x,s),LERP(t1.y,t2.y,s));
        var t5 = new FastVector2(LERP(t2.x,t3.x,s),LERP(t2.y,t3.y,s));

        var t6 = new FastVector2(LERP(t4.x,t5.x,s),LERP(t4.y,t5.y,s));
        
        temp.setFrom(t6);
        return temp;
	}

	public function getLength():Float {
		return (c1.sub(start).length + c2.sub(c1).length + end.sub(c2).length + end.sub(start).length)*0.5;
	}

    private inline function LERP(start:Float, end:Float, s:Float):Float{
        return start + (end-start) * s;
    }
}