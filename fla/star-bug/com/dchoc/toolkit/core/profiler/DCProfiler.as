package com.dchoc.toolkit.core.profiler
{
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.Event;
   import net.jpauclair.FlashPreloadProfiler;
   
   public class DCProfiler
   {
      
      public static var ENABLE_PROFILING:Boolean = Config.ENABLE_PROFILING;
      
      private static var smProfiler:FlashPreloadProfiler;
      
      private static var smStage:Stage;
      
      private static var profileStack:Array = [];
       
      
      public function DCProfiler()
      {
         super();
      }
      
      public static function startProfiling(swf:Stage, context:InteractiveObject) : void
      {
         if(ENABLE_PROFILING)
         {
            smStage = swf;
            smProfiler = new FlashPreloadProfiler();
            swf.addChild(smProfiler);
            swf.addEventListener("enterFrame",updateProfiling);
            SWFProfiler.init(swf,context);
         }
      }
      
      public static function updateProfiling(e:Event) : void
      {
         if(ENABLE_PROFILING)
         {
            smStage.setChildIndex(smProfiler,smStage.numChildren - 1);
         }
      }
      
      public static function getVisible() : Boolean
      {
         if(ENABLE_PROFILING)
         {
            return smProfiler.visible;
         }
         return false;
      }
      
      public static function setVisible(value:Boolean) : void
      {
         if(ENABLE_PROFILING)
         {
            smProfiler.visible = value;
         }
      }
      
      public static function beginProfile(label:String = null) : Object
      {
         var sample:* = {};
         sample["time"] = DCTimerUtil.currentTimeMillis();
         sample["label"] = label;
         profileStack.push(sample);
         return sample;
      }
      
      public static function getLabel(param1:Object) : String
      {
         if(param1 == null)
         {
            return profileStack.length == 0 ? null : profileStack[profileStack.length - 1]["label"];
         }
         if(param1 is String)
         {
            return param1 as String;
         }
         return param1["label"];
      }
      
      public static function endProfileReport(label:Object = null) : String
      {
         return "Profile: " + getLabel(label) + " " + endProfile(label);
      }
      
      public static function endProfile(param1:Object = null) : uint
      {
         var i:int = 0;
         var endTime:Number = DCTimerUtil.currentTimeMillis();
         if(param1 == null)
         {
            param1 = profileStack.pop();
         }
         else if(param1 is String)
         {
            i = int(profileStack.length);
            while(i >= 0)
            {
               i--;
               if(profileStack[i]["label"] == param1)
               {
                  param1 = profileStack[i];
                  profileStack.slice(i);
                  break;
               }
            }
         }
         else
         {
            i = int(profileStack.length);
            while(i >= 0)
            {
               i--;
               if(profileStack[i] == param1)
               {
                  profileStack.slice(i);
                  break;
               }
            }
         }
         return endTime - param1["time"];
      }
   }
}
