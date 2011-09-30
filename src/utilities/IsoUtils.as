package utilities 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class IsoUtils 
	{
		public static const Y_CORRECT:Number = Math.cos( -Math.PI / 6) * Math.SQRT2;
		
		public static function isoToScreen(pos:Point3D):Point
		{
			var screenX:Number = pos.x - pos.z;
			var screenY:Number = pos.y * Y_CORRECT + (pos.x + pos.z) * .5;
			
			return new Point(screenX, screenY);
		}
		
		public static function screenToIso(point:Point):Point3D
		{
			var xpos:Number = point.y + point.x * .5;
			var ypos:Number = 0;
			var zpos:Number = point.y - point.x * .5;
			
			return new Point3D(xpos, ypos, zpos);
		}
	}
}