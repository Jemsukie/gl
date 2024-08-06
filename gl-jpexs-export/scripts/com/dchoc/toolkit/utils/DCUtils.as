package com.dchoc.toolkit.utils
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.map.DCMapViewDef;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.filters.BitmapFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DCUtils
   {
      
      public static var smColorTransformInit:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
      
      private static var smCoor:DCCoordinate = new DCCoordinate();
      
      public static const STROKE_WHITE:BitmapFilter = new DropShadowFilter(0,45,16777215,1,3,3,10,3);
      
      public static const STROKE_BLUE_LIGHT:BitmapFilter = new DropShadowFilter(0,45,113407,1,3,3,10,3);
      
      public static const STROKE_BROWN_LIGHT:BitmapFilter = new DropShadowFilter(0,45,8863245,1,3,3,10,3);
       
      
      public function DCUtils()
      {
         super();
      }
      
      public static function getChk(string:String) : Number
      {
         var i:int = 0;
         var h:int = 317;
         var len:int = string.length;
         for(i = 0; i < len; )
         {
            h = 23 * h + string.charCodeAt(i);
            i++;
         }
         return h;
      }
      
      public static function getClass(obj:Object) : Class
      {
         try
         {
            return Class(getDefinitionByName(getQualifiedClassName(obj)));
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public static function getVectorOfCustomClass(customClass:Class, length:uint = 0, fixed:Boolean = false) : *
      {
         var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
         var vectorStr:* = getQualifiedClassName(Vector) + ".<" + getQualifiedClassName(customClass) + ">";
         var vectorOfCustomClass:Class = applicationDomain.getDefinition(vectorStr) as Class;
         return new vectorOfCustomClass(length,fixed);
      }
      
      public static function vector2Array(v:*) : Array
      {
         var i:int = 0;
         var l:int = int(v.length);
         var arr:Array = [];
         for(i = 0; i < l; )
         {
            arr[i] = v[i];
            i++;
         }
         return arr;
      }
      
      public static function array2Vector(arr:Array, vClass:Class) : *
      {
         var i:int = 0;
         var l:int = int(arr.length);
         var v:Vector.<*> = getVectorOfCustomClass(vClass,l);
         for(i = 0; i < l; )
         {
            v[i] = arr[i];
            i++;
         }
         return v;
      }
      
      public static function array2VectorDCDef(arr:Array) : Vector.<DCDef>
      {
         var i:int = 0;
         var l:int = int(arr.length);
         var v:Vector.<DCDef> = new Vector.<DCDef>(l);
         for(i = 0; i < l; )
         {
            v[i] = arr[i];
            i++;
         }
         return v;
      }
      
      public static function booleanToString(value:Boolean) : String
      {
         return value ? "1" : "0";
      }
      
      public static function stringToBoolean(value:String) : Boolean
      {
         return value == "1" ? true : false;
      }
      
      public static function drawRect(g:Graphics, x:int = 0, y:int = 0, width:int = 6, height:int = 6, color:uint = 0, doClear:Boolean = false) : void
      {
         if(doClear)
         {
            g.clear();
         }
         g.lineStyle(1,color);
         g.drawRect(x,y,width,height);
      }
      
      public static function fillRect(g:Graphics, x:int = 0, y:int = 0, width:int = 6, height:int = 6, color:uint = 0, alpha:Number = 1, doClear:Boolean = false) : void
      {
         if(doClear)
         {
            g.clear();
         }
         g.beginFill(color,alpha);
         g.drawRect(x,y,width,height);
         g.endFill();
      }
      
      public static function drawCircle(g:Graphics, colour:uint = 0, radius:Number = 6, x:int = 0, y:int = 0, doClear:Boolean = false) : void
      {
         if(doClear)
         {
            g.clear();
         }
         g.lineStyle(1,colour);
         g.drawCircle(x,y,radius);
      }
      
      public static function fillCircle(g:Graphics, colour:uint = 0, radius:Number = 6, x:int = 0, y:int = 0, alpha:Number = 1, doClear:Boolean = false) : void
      {
         if(doClear)
         {
            g.clear();
         }
         g.beginFill(colour,alpha);
         g.drawCircle(x,y,radius);
         g.endFill();
      }
      
      public static function fillTriangle(g:Graphics, colour:uint = 0, size:Number = 6, scale:Number = 1, doClear:Boolean = false) : void
      {
         if(doClear)
         {
            g.clear();
         }
         var s:Number;
         var d:Number = (s = size * scale) * 0.75;
         g.beginFill(colour);
         g.moveTo(-s,-d);
         g.lineTo(s,0);
         g.lineTo(-s,d);
         g.lineTo(-s,-d);
         g.endFill();
      }
      
      public static function drawPoint(g:Graphics, color:uint = 16711935, x:int = 0, y:int = 0, off:int = 5, doClear:Boolean = false) : void
      {
         if(doClear)
         {
            g.clear();
         }
         g.lineStyle(2,color,0.75);
         g.beginFill(color);
         g.moveTo(x - off,y);
         g.lineTo(x + off,y);
         g.moveTo(x,y - off);
         g.lineTo(x,y + off);
         g.endFill();
      }
      
      public static function drawCross(g:Graphics, color:uint = 0, x:int = 0, y:int = 0, doClear:Boolean = false) : void
      {
         if(doClear)
         {
            g.clear();
         }
         g.lineStyle(3,color);
         g.beginFill(color);
         g.drawRect(x - 3,y,6,1);
         g.drawRect(x,y - 3,1,6);
         g.endFill();
      }
      
      public static function drawShape(g:Graphics, vertices:Vector.<Number>, color:uint = 0, doClear:Boolean = true, doLines:Boolean = true, rounded:Boolean = true, alpha:Number = 1, thickness:Number = 3) : void
      {
         var i:int = 0;
         var index:int = 0;
         var caps:String = null;
         if(doClear)
         {
            g.clear();
         }
         if(doLines)
         {
            caps = null;
            if(rounded)
            {
               caps = "round";
            }
            g.lineStyle(thickness,color,alpha,false,"normal",caps);
         }
         g.moveTo(vertices[0],vertices[1]);
         var numVertices:int = vertices.length / 2;
         for(i = 0; i < numVertices; )
         {
            index = (i + 1) % numVertices;
            g.lineTo(vertices[index * 2],vertices[index * 2 + 1]);
            i++;
         }
      }
      
      public static function drawEllipse(g:Graphics, radius:Number, color:uint, x:int = 0, y:int = 0) : void
      {
         g.beginFill(0);
         if(radius > 0)
         {
            drawArc(g,radius,0,360,24,x,y);
         }
         g.endFill();
      }
      
      public static function drawArc(g:Graphics, radius:Number, startAngle:Number, arcAngle:Number, steps:int, centerX:int = 0, centerY:int = 0) : void
      {
         var i:int = 0;
         var angle:Number = NaN;
         var cos:Number = NaN;
         var twoPI:Number = 0.017453292519943295;
         var angleStep:Number = arcAngle / steps;
         var xx:int = centerX + Math.cos(startAngle * twoPI) * radius;
         var yy:int = centerY + Math.sin(startAngle * twoPI) * radius;
         var mapViewDef:DCMapViewDef = InstanceMng.getMapControllerPlanet().mMapViewDef;
         for(i = 1; i <= steps; )
         {
            angle = startAngle + i * angleStep;
            cos = (cos = Math.cos(angle * twoPI)) * radius;
            xx = centerX + cos;
            yy = centerY + Math.sin(angle * twoPI) * radius;
            smCoor.x = xx;
            smCoor.y = 0;
            smCoor.z = yy;
            mapViewDef.mPerspective.mapToScreen(smCoor);
            DCUtils.drawCross(g,0,smCoor.x,smCoor.y);
            i++;
         }
      }
      
      public static function setInk(start:ColorTransform, color:uint, t:Number) : ColorTransform
      {
         var end:ColorTransform = new ColorTransform();
         var result:ColorTransform = new ColorTransform();
         end.color = color;
         result.redMultiplier = start.redMultiplier + (end.redMultiplier - start.redMultiplier) * t;
         result.greenMultiplier = start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier) * t;
         result.blueMultiplier = start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier) * t;
         result.alphaMultiplier = start.alphaMultiplier + (end.alphaMultiplier - start.alphaMultiplier) * t;
         result.redOffset = start.redOffset + (end.redOffset - start.redOffset) * t;
         result.greenOffset = start.greenOffset + (end.greenOffset - start.greenOffset) * t;
         result.blueOffset = start.blueOffset + (end.blueOffset - start.blueOffset) * t;
         result.alphaOffset = start.alphaOffset + (end.alphaOffset - start.alphaOffset) * t;
         return result;
      }
      
      public static function resetColorTransform(dObj:DisplayObject) : void
      {
         dObj.transform.colorTransform = smColorTransformInit;
      }
      
      public static function transformValueToString(value:String, desiredLength:int) : String
      {
         var returnValue:* = null;
         var i:int = 0;
         returnValue = value;
         if(value.length != desiredLength)
         {
            for(i = value.length; i < desiredLength; )
            {
               returnValue = "0" + returnValue;
               i++;
            }
         }
         return returnValue;
      }
      
      public static function isObjectEmpty(o:Object) : Boolean
      {
         if(o == null)
         {
            return true;
         }
         var _loc4_:int = 0;
         var _loc3_:* = o;
         for(var key in _loc3_)
         {
            return false;
         }
         return true;
      }
      
      public static function areObjectsEquivalent(o1:Object, o2:Object) : Boolean
      {
         var key:* = undefined;
         if(o1 == null && o2 == null)
         {
            return true;
         }
         if(isObjectEmpty(o1) != isObjectEmpty(o2))
         {
            return false;
         }
         for(key in o1)
         {
            if(!o2.hasOwnProperty(key) || o1[key] != o2[key])
            {
               return false;
            }
         }
         for(key in o2)
         {
            if(!o1.hasOwnProperty(key) || o1[key] != o2[key])
            {
               return false;
            }
         }
         return true;
      }
      
      public static function getEuclideanDistanceBetweenCoords(coord1:DCCoordinate, coord2:DCCoordinate) : int
      {
         var distX:int = Math.pow(coord1.x - coord2.x,2);
         var distY:int = Math.pow(coord1.y - coord2.y,2);
         return Math.sqrt(distX + distY);
      }
      
      public static function getDistanceBetweenCoords(coord1:DCCoordinate, coord2:DCCoordinate) : int
      {
         var p1:Point = new Point();
         var p2:Point = new Point();
         p1.x = coord1.x;
         p1.y = coord1.y;
         p2.x = coord2.x;
         p2.y = coord2.y;
         return Point.distance(p1,p2);
      }
      
      public static function locateContentWithCollisionBox(dspObj:DisplayObject, parent:DisplayObjectContainer, collBoxName:String, attachToParent:Boolean = true, removeCollBox:Boolean = true, fitSize:Boolean = false, sameIndex:Boolean = false) : void
      {
         var index:int = 0;
         var collBox:DisplayObject;
         if((collBox = parent.getChildByName(collBoxName)) != null)
         {
            index = parent.getChildIndex(collBox);
            dspObj.x = collBox.x;
            dspObj.y = collBox.y;
            if(fitSize)
            {
               dspObj.width = collBox.width;
               dspObj.height = collBox.height;
            }
            if(removeCollBox)
            {
               parent.removeChild(collBox);
            }
            if(attachToParent)
            {
               if(sameIndex)
               {
                  parent.addChildAt(dspObj,index);
               }
               else
               {
                  parent.addChild(dspObj);
               }
            }
         }
         else
         {
            DCDebug.trace("Collision box " + collBoxName + " doesn\'t exist for " + parent.name);
         }
      }
      
      public static function simpleStringEncrypt(input:String) : String
      {
         var i:int = 0;
         if(input == null)
         {
            return null;
         }
         var letter:* = 0;
         var lowBits:* = 0;
         var output:String = new String();
         for(i = 0; i < input.length; )
         {
            letter = input.charCodeAt(i);
            if(letter >= 32 && letter < 128)
            {
               lowBits = (letter ^ i + 3) & 31;
               letter = letter & 4294967264 | lowBits;
            }
            output += String.fromCharCode(letter);
            i++;
         }
         return output;
      }
      
      public static function simpleStringDecrypt(input:String) : String
      {
         var i:int = 0;
         if(input == null)
         {
            return null;
         }
         var letter:* = 0;
         var lowBits:* = 0;
         var output:String = new String();
         for(i = 0; i < input.length; )
         {
            letter = input.charCodeAt(i);
            if(letter >= 32 && letter < 128)
            {
               lowBits = (letter ^ i + 3) & 31;
               letter = letter & 4294967264 | lowBits;
            }
            output += String.fromCharCode(letter);
            i++;
         }
         return output;
      }
      
      public static function makeLatin1(input:String) : String
      {
         var i:int = 0;
         var letter:int = 0;
         var hex:String = null;
         var output:String = new String();
         for(i = 0; i < input.length; )
         {
            letter = input.charCodeAt(i);
            if(letter < 128)
            {
               output += String.fromCharCode(letter);
            }
            else
            {
               for(hex = letter.toString(16); hex.length < 4; )
               {
                  hex = "0" + hex;
               }
               output += "\\u" + hex;
            }
            i++;
         }
         return output;
      }
      
      public static function keyCodeToString(input:uint) : String
      {
         switch(input)
         {
            case 186:
               return ";";
            case 187:
               return "=";
            case 188:
               return ",";
            case 189:
               return "-";
            case 190:
               return ".";
            case 191:
               return "/";
            case 192:
               return ";";
            case 219:
               return "[";
            case 220:
               return "\\";
            case 221:
               return "]";
            case 222:
               return "\'";
            case 112:
               return "F1";
            case 113:
               return "F2";
            case 114:
               return "F3";
            case 115:
               return "F4";
            case 116:
               return "F5";
            case 117:
               return "F6";
            case 118:
               return "F7";
            case 119:
               return "F8";
            case 120:
               return "F9";
            case 121:
               return "F10";
            case 122:
               return "F11";
            case 123:
               return "F12";
            case 124:
               return "F13";
            case 125:
               return "F14";
            case 126:
               return "F15";
            case 96:
               return "#0";
            case 97:
               return "#1";
            case 98:
               return "#2";
            case 99:
               return "#3";
            case 100:
               return "#4";
            case 101:
               return "#5";
            case 102:
               return "#6";
            case 103:
               return "#7";
            case 104:
               return "#8";
            case 105:
               return "#9";
            case 106:
               return "#*";
            case 107:
               return "#+";
            case 108:
               return "#Enter";
            case 109:
               return "#-";
            case 110:
               return "#.";
            case 111:
               return "#/";
            default:
               return String.fromCharCode(input);
         }
      }
      
      public static function isStringANumber(str:String) : Boolean
      {
         var i:int = 0;
         var length:int = str.length;
         for(i = 0; i < length; )
         {
            if(isNaN(parseInt(str.charAt(i))))
            {
               return false;
            }
            i++;
         }
         return true;
      }
      
      public static function createPanel(collBox:DisplayObject, colorBackground:uint, colorBorder:int, angle:Number = 10, border:Number = 2.5) : Shape
      {
         var sh:Shape = new Shape();
         if(colorBorder > -1)
         {
            sh.graphics.lineStyle(border,colorBorder);
         }
         sh.graphics.beginFill(colorBackground);
         sh.graphics.drawRoundRectComplex(-collBox.width / 2,-collBox.height / 2,collBox.width,collBox.height,angle,angle,angle,angle);
         sh.graphics.endFill();
         sh.x = collBox.x;
         sh.y = collBox.y;
         return sh;
      }
      
      public static function drawPanel(panel:Shape, bg:int, borderColor:int, angle:Number = 10, borderSize:Number = 2.5) : void
      {
         var w:Number = panel.width;
         var h:Number = panel.height;
         panel.graphics.clear();
         if(borderColor > -1)
         {
            panel.graphics.lineStyle(borderSize,borderColor);
         }
         panel.graphics.beginFill(bg);
         panel.graphics.drawRoundRectComplex(-w / 2,-h / 2,w,h,angle,angle,angle,angle);
         panel.graphics.endFill();
      }
      
      public static function drawEnergyBar(currentEnergy:int, maxEnergy:int, g:Graphics, maxSect:int, sectorWidth:int, barHeight:int, colors:Array) : int
      {
         var totalBarWidth:Number = NaN;
         var currentBarWidth:Number = NaN;
         var color:uint = 0;
         var returnValue:* = currentEnergy;
         if(g != null)
         {
            totalBarWidth = maxSect * sectorWidth;
            if(currentEnergy < 0)
            {
               currentEnergy = 0;
            }
            if(currentEnergy > maxEnergy)
            {
               currentEnergy = maxEnergy;
            }
            g.clear();
            g.beginFill(4210752);
            g.drawRect(0,0,totalBarWidth,barHeight);
            g.endFill();
            currentBarWidth = currentEnergy * totalBarWidth / maxEnergy;
            color = getEnergyColor(currentEnergy,maxEnergy,colors);
            g.beginFill(color);
            g.drawRect(0,0,currentBarWidth,barHeight);
            g.endFill();
            g.lineStyle(1,0);
            g.drawRect(0,0,totalBarWidth,barHeight);
            returnValue = currentEnergy;
         }
         return returnValue;
      }
      
      public static function getEnergyColor(currentEnergy:int, maxEnergy:int, colors:Array) : uint
      {
         var color:int;
         var colorsLength:int;
         if((color = (colorsLength = int(colors.length)) * currentEnergy / maxEnergy) >= colorsLength)
         {
            color = colorsLength - 1;
         }
         return colors[color];
      }
      
      public static function getUIntColorFromRGB(red:int, green:int, blue:int) : uint
      {
         return red << 16 | green << 8 | blue;
      }
   }
}
