package com.dchoc.toolkit.utils.math.geom
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import flash.geom.Vector3D;
   
   public class DCCoordinate
   {
      
      private static const DELIMITER:String = ",";
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function DCCoordinate(_x:Number = 0, _y:Number = 0, _z:Number = 0)
      {
         super();
         this.x = _x;
         this.y = _y;
         this.z = _z;
      }
      
      public static function fromString(coords:String, delimiter:String = ",") : DCCoordinate
      {
         var strCopy:String = null;
         var arr:Array = null;
         strCopy = coords.concat();
         var result:DCCoordinate = new DCCoordinate();
         try
         {
            if(coords.charAt(0) == "(")
            {
               coords = coords.substr(1);
            }
            if(coords.charAt(coords.length - 1) == ")")
            {
               coords = coords.substr(0,coords.length - 1);
            }
            arr = coords.split(delimiter);
            result.setX(parseFloat(arr[0]));
            result.setY(parseFloat(arr[1]));
            if(arr.length > 2)
            {
               result.setZ(parseFloat(arr[2]));
            }
         }
         catch(e:Error)
         {
            DCDebug.traceCh("ERROR","Unable to parse \"" + strCopy + "\" into a DCCoordinate");
         }
         return result;
      }
      
      public function getX() : Number
      {
         return this.x;
      }
      
      public function setX(value:Number) : void
      {
         this.x = value;
      }
      
      public function getY() : Number
      {
         return this.y;
      }
      
      public function setY(value:Number) : void
      {
         this.y = value;
      }
      
      public function getZ() : Number
      {
         return this.z;
      }
      
      public function setZ(value:Number) : void
      {
         this.z = value;
      }
      
      public function asVector3D() : Vector3D
      {
         return new Vector3D(this.x,this.y,this.z);
      }
      
      public function copy(c:DCCoordinate) : void
      {
         this.x = c.x;
         this.y = c.y;
         this.z = c.z;
      }
      
      public function toString(avoidPrintingZ:Boolean = false) : String
      {
         if(avoidPrintingZ)
         {
            return "(" + this.x + "," + this.y + ")";
         }
         return "(" + this.x + "," + this.y + "," + this.z + ")";
      }
      
      public function toStringWithNoParentheses(avoidPrintingZ:Boolean = false) : String
      {
         if(avoidPrintingZ)
         {
            return this.x + "," + this.y;
         }
         return this.x + "," + this.y + "," + this.z;
      }
      
      public function isContainedInCoords(coordMin:DCCoordinate, coordMax:DCCoordinate) : Boolean
      {
         var minOK:Boolean = coordMin.x <= this.x && this.x <= coordMax.x;
         var maxOK:Boolean = coordMin.y <= this.y && this.y <= coordMax.y;
         return minOK && maxOK;
      }
      
      public function equals(anotherCoord:DCCoordinate) : Boolean
      {
         return this.x == anotherCoord.x && this.y == anotherCoord.y && this.z == anotherCoord.z;
      }
   }
}
