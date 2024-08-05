package com.gskinner.motion.plugins
{
   import com.gskinner.motion.GTween;
   import flash.filters.BlurFilter;
   
   public class MotionBlurPlugin implements IGTweenPlugin
   {
      
      public static var enabled:Boolean = false;
      
      public static var strength:Number = 0.6;
      
      protected static var instance:MotionBlurPlugin;
       
      
      public function MotionBlurPlugin()
      {
         super();
      }
      
      public static function install() : void
      {
         if(instance)
         {
            return;
         }
         instance = new MotionBlurPlugin();
         GTween.installPlugin(instance,["x","y"]);
      }
      
      public function init(tween:GTween, name:String, value:Number) : Number
      {
         return value;
      }
      
      public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean) : Number
      {
         var blur:Number = NaN;
         if(!(enabled && tween.pluginData.MotionBlurEnabled == null || tween.pluginData.MotionBlurEnabled))
         {
            return value;
         }
         var data:Object;
         if((data = tween.pluginData.MotionBlurData) == null)
         {
            data = this.initTarget(tween);
         }
         var blurF:BlurFilter;
         var f:Array;
         if((blurF = (f = tween.target.filters)[data.index] as BlurFilter) == null)
         {
            return value;
         }
         if(end)
         {
            f.splice(data.index,1);
            delete tween.pluginData.MotionBlurData;
         }
         else
         {
            blur = Math.abs((tween.ratioOld - ratio) * rangeValue * strength);
            if(name == "x")
            {
               blurF.blurX = blur;
            }
            else
            {
               blurF.blurY = blur;
            }
         }
         tween.target.filters = f;
         return value;
      }
      
      protected function initTarget(tween:GTween) : Object
      {
         var f:Array = tween.target.filters;
         f.push(new BlurFilter(0,0,1));
         tween.target.filters = f;
         return tween.pluginData.MotionBlurData = {"index":f.length - 1};
      }
   }
}
