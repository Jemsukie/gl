package esparragon.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class EUtils
   {
      
      private static const POINT_ZERO:Point = new Point(0,0);
      
      public static const DEGREES_TO_RAD:Number = 0.017453292519943295;
      
      public static const RAD_TO_DEGREES:Number = 57.29577951308232;
       
      
      public function EUtils()
      {
         super();
      }
      
      public static function XMLListToXML(xmlList:XMLList) : XML
      {
         var listString:String = xmlList.toXMLString();
         return new XML(listString);
      }
      
      public static function xmlSetAttribute(xml:XML, key:String, value:Object) : void
      {
         xml["@" + key] = value;
      }
      
      public static function xmlGetAttributesAsXMLList(xml:XML) : XMLList
      {
         var xmlList:XMLList = new XMLList(xml);
         return xmlList.attributes();
      }
      
      public static function xmlGetChildrenList(xml:XML, key:String = "*") : XMLList
      {
         if(xml == null)
         {
            return null;
         }
         return xml.child(key);
      }
      
      public static function xmlGetChildrenListAsXML(xml:XML, key:String) : XML
      {
         if(xml == null)
         {
            return null;
         }
         return XMLListToXML(xml.child(key));
      }
      
      public static function xmlIsAttribute(xml:XML, key:String) : Boolean
      {
         return "@" + key in xml;
      }
      
      public static function stringToXML(str:String) : XML
      {
         return new XML(str);
      }
      
      public static function xmlReadBoolean(xml:XML, attribute:String) : Boolean
      {
         var value:String = null;
         var returnValue:* = false;
         var attributes:XMLList;
         if((attributes = xml.attribute(attribute)).length() > 0)
         {
            returnValue = (value = attributes[0]) == "1";
         }
         return returnValue;
      }
      
      public static function xmlReadInt(xml:XML, attribute:String) : int
      {
         var value:String = null;
         var returnValue:int = 0;
         var attributes:XMLList;
         if((attributes = xml.attribute(attribute)).length() > 0)
         {
            value = attributes[0];
            returnValue = parseInt(value);
         }
         return returnValue;
      }
      
      public static function xmlReadNumber(xml:XML, attribute:String) : Number
      {
         var value:String = null;
         var returnValue:Number = 0;
         var attributes:XMLList;
         if((attributes = xml.attribute(attribute)).length() > 0)
         {
            value = attributes[0];
            returnValue = parseFloat(value);
         }
         return returnValue;
      }
      
      public static function xmlReadString(xml:XML, attribute:String) : String
      {
         var returnValue:String = "";
         var attributes:XMLList;
         if((attributes = xml.attribute(attribute)).length() > 0)
         {
            returnValue = attributes[0];
         }
         return returnValue;
      }
      
      public static function array2VectorString(arr:Array, doTrim:Boolean = false) : Vector.<String>
      {
         var i:int = 0;
         var entry:String = null;
         var l:int = int(arr.length);
         var v:Vector.<String> = new Vector.<String>(l);
         for(i = 0; i < l; )
         {
            entry = String(arr[i]);
            if(doTrim)
            {
               entry = trim(entry);
            }
            v[i] = entry;
            i++;
         }
         return v;
      }
      
      public static function array2VectorInt(arr:Array, doTrim:Boolean = false) : Vector.<int>
      {
         var i:int = 0;
         var l:int = int(arr.length);
         var v:Vector.<int> = new Vector.<int>(l);
         for(i = 0; i < l; )
         {
            if(arr[i] is String)
            {
               v[i] = parseInt(arr[i]);
            }
            else
            {
               v[i] = arr[i];
            }
            i++;
         }
         return v;
      }
      
      public static function array2BidimensionalArray(arr:Array, rows:int, cols:int) : Array
      {
         var r:int = 0;
         var subArr:Array = null;
         var index:int = 0;
         var c:int = 0;
         var result:Array = [];
         var boxesCount:int = int(arr.length);
         for(r = 0; r < rows; )
         {
            subArr = [];
            for(c = 0; c < cols; )
            {
               if((index = r * cols + c) < boxesCount)
               {
                  subArr.push(arr[index]);
               }
               c++;
            }
            result.push(subArr);
            r++;
         }
         return result;
      }
      
      public static function trim(s:String) : String
      {
         return s.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm,"$2");
      }
      
      public static function cropBitmap(bitmap:Bitmap) : void
      {
         var bmp:BitmapData = null;
         var bounds:Rectangle = bitmap.bitmapData.getColorBoundsRect(4278190080,0,false);
         var x:int = Math.round(bounds.x);
         var y:int = Math.round(bounds.y);
         var w:int = Math.round(bounds.width);
         var h:int = Math.round(bounds.height);
         var matrix:Matrix = new Matrix();
         if(w == 0 || h == 0)
         {
            bounds = bitmap.getBounds(bitmap);
            matrix.translate(-bounds.x,-bounds.y);
            bmp = new BitmapData(bounds.width,bounds.height,true,16777215);
            bmp.draw(bitmap.bitmapData,matrix,null,null,new Rectangle(0,0,bounds.width,bounds.height));
            bounds = bmp.getColorBoundsRect(4278190080,0,false);
            x = Math.round(bounds.x);
            y = Math.round(bounds.y);
            w = Math.round(bounds.width);
            h = Math.round(bounds.height);
            bmp.dispose();
         }
         if(w > 0 && h > 0)
         {
            matrix.identity();
            matrix.translate(-x,-y);
            bmp = new BitmapData(w,h,true,16777215);
            bmp.draw(bitmap.bitmapData,matrix);
            bitmap.x += x;
            bitmap.y += y;
            bitmap.bitmapData = bmp;
            bitmap.smoothing = true;
         }
      }
      
      public static function cropBitmapData(bitmap:BitmapData) : BitmapData
      {
         var bmp:BitmapData = null;
         var bounds:Rectangle = bitmap.getColorBoundsRect(4278190080,0,false);
         var x:int = Math.round(bounds.x);
         var y:int = Math.round(bounds.y);
         var w:int = Math.round(bounds.width);
         var h:int = Math.round(bounds.height);
         var matrix:Matrix = new Matrix();
         if(w > 0 && h > 0)
         {
            matrix.identity();
            matrix.translate(-x,-y);
            bmp = new BitmapData(w,h,true,16777215);
            bmp.draw(bitmap,matrix);
         }
         return bmp;
      }
      
      public static function bitmapDataDraw(dest:BitmapData, source:BitmapData, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false) : void
      {
         var frame:BitmapData = null;
         if(clipRect == null)
         {
            dest.draw(source,matrix,colorTransform,blendMode,null,smoothing);
         }
         else
         {
            (frame = new BitmapData(clipRect.width,clipRect.height)).copyPixels(source,clipRect,POINT_ZERO,null,null,false);
            dest.draw(frame,matrix,colorTransform,blendMode,null,smoothing);
            frame.dispose();
         }
      }
      
      public static function cloneObject(origin:Object) : Object
      {
         var i:* = null;
         var returnValue:Object = {};
         for(i in origin)
         {
            returnValue[i] = origin[i];
         }
         return returnValue;
      }
      
      public static function rad2Degree(angleRadians:Number) : Number
      {
         return angleRadians * 57.29577951308232;
      }
      
      public static function degree2Rad(angleDegrees:Number) : Number
      {
         return angleDegrees * 0.017453292519943295;
      }
      
      public static function getNameInBrackets(name:String) : String
      {
         return "<" + name + ">";
      }
      
      public static function getDictionaryKeys(d:Dictionary) : Vector.<Object>
      {
         var j:* = null;
         var returnValue:Vector.<Object> = new Vector.<Object>(0);
         for(j in d)
         {
            returnValue.push(j);
         }
         return returnValue;
      }
   }
}
