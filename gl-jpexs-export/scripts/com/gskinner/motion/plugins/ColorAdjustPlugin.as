package com.gskinner.motion.plugins
{
   import com.gskinner.geom.ColorMatrix;
   import com.gskinner.motion.GTween;
   import flash.filters.ColorMatrixFilter;
   
   public class ColorAdjustPlugin implements IGTweenPlugin
   {
      
      public static var enabled:Boolean = true;
      
      protected static var instance:ColorAdjustPlugin;
      
      protected static var tweenProperties:Array = ["brightness","contrast","hue","saturation"];
       
      
      public function ColorAdjustPlugin()
      {
         super();
      }
      
      public static function install() : void
      {
         if(instance)
         {
            return;
         }
         instance = new ColorAdjustPlugin();
         GTween.installPlugin(instance,tweenProperties);
      }
      
      public function init(tween:GTween, name:String, value:Number) : Number
      {
         var f:Array = null;
         var i:uint = 0;
         var cmF:ColorMatrixFilter = null;
         var o:Object = null;
         if(!(tween.pluginData.ColorAdjustEnabled == null && enabled || tween.pluginData.ColorAdjustEnabled))
         {
            return value;
         }
         if(tween.pluginData.ColorAdjustData == null)
         {
            f = tween.target.filters;
            for(i = 0; i < f.length; )
            {
               if(f[i] is ColorMatrixFilter)
               {
                  cmF = f[i];
                  (o = {
                     "index":i,
                     "ratio":NaN
                  }).initMatrix = cmF.matrix;
                  o.matrix = this.getMatrix(tween);
                  tween.pluginData.ColorAdjustData = o;
               }
               i++;
            }
         }
         return tween.getValue(name) - 1;
      }
      
      public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean) : Number
      {
         var i:* = 0;
         if(!(tween.pluginData.ColorAdjustEnabled == null && enabled || tween.pluginData.ColorAdjustEnabled))
         {
            return value;
         }
         var data:Object;
         if((data = tween.pluginData.ColorAdjustData) == null)
         {
            data = this.initTarget(tween);
         }
         if(ratio == data.ratio)
         {
            return value;
         }
         data.ratio = ratio;
         ratio = value - initValue;
         var cmF:ColorMatrixFilter;
         var f:Array;
         if((cmF = (f = tween.target.filters)[data.index] as ColorMatrixFilter) == null)
         {
            return value;
         }
         var initMatrix:* = data.initMatrix;
         var targMatrix:Array = data.matrix;
         if(rangeValue < 0)
         {
            initMatrix = targMatrix;
            targMatrix = data.initMatrix;
            ratio *= -1;
         }
         var matrix:Array;
         var l:uint = (matrix = cmF.matrix).length;
         for(i = 0; i < l; )
         {
            matrix[i] = initMatrix[i] + (targMatrix[i] - initMatrix[i]) * ratio;
            i++;
         }
         cmF.matrix = matrix;
         tween.target.filters = f;
         if(end)
         {
            delete tween.pluginData.ColorAdjustData;
         }
         return NaN;
      }
      
      protected function getMatrix(tween:GTween) : ColorMatrix
      {
         var brightness:Number = this.fixValue(tween.getValue("brightness"));
         var contrast:Number = this.fixValue(tween.getValue("contrast"));
         var saturation:Number = this.fixValue(tween.getValue("saturation"));
         var hue:Number = this.fixValue(tween.getValue("hue"));
         var mtx:ColorMatrix = new ColorMatrix();
         mtx.adjustColor(brightness,contrast,saturation,hue);
         return mtx;
      }
      
      protected function initTarget(tween:GTween) : Object
      {
         var f:Array = tween.target.filters;
         var mtx:ColorMatrix = new ColorMatrix();
         f.push(new ColorMatrixFilter(mtx.toArray()));
         tween.target.filters = f;
         var o:Object;
         (o = {
            "index":f.length - 1,
            "ratio":NaN
         }).initMatrix = mtx;
         o.matrix = this.getMatrix(tween);
         return tween.pluginData.ColorAdjustData = o;
      }
      
      protected function fixValue(value:Number) : Number
      {
         return isNaN(value) ? 0 : value;
      }
   }
}
