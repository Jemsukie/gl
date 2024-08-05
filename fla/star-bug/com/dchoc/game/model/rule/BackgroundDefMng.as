package com.dchoc.game.model.rule
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class BackgroundDefMng extends DCDefMng
   {
      
      private static const MAIN_SOLAR_SYSTEM_TYPE:String = "-1";
       
      
      private var mMainBackgroundByDateDefs:Vector.<BackgroundDef>;
      
      private var mMainBackgroundDefDefault:BackgroundDef;
      
      public function BackgroundDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function unloadDo() : void
      {
         this.mMainBackgroundByDateDefs = null;
         this.mMainBackgroundDefDefault = null;
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new BackgroundDef();
      }
      
      override protected function buildDefs() : void
      {
         var def:BackgroundDef = null;
         var i:int = 0;
         super.buildDefs();
         this.mMainBackgroundByDateDefs = new Vector.<BackgroundDef>(0);
         var defs:Vector.<DCDef> = getDefs();
         var currentTime:Number = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         for(i = defs.length - 1; i > -1; )
         {
            def = defs[i] as BackgroundDef;
            if(def.getSolarSystemType() == "-1")
            {
               if(def.getSku() == "main")
               {
                  this.mMainBackgroundDefDefault = def;
               }
               else if(def.validDateHasAnyDate() && !def.validDateHasExpired(currentTime))
               {
                  this.mMainBackgroundByDateDefs.push(def);
               }
            }
            i--;
         }
      }
      
      private function getCurrentMainBackground() : BackgroundDef
      {
         var def:BackgroundDef = null;
         var i:int = 0;
         var returnValue:* = null;
         var currentTime:Number = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         i = this.mMainBackgroundByDateDefs.length - 1;
         while(i > -1 && returnValue == null)
         {
            def = this.mMainBackgroundByDateDefs[i];
            if(def.validDateIsValid(currentTime))
            {
               returnValue = def;
            }
            i--;
         }
         if(returnValue == null)
         {
            returnValue = this.mMainBackgroundDefDefault;
         }
         return returnValue;
      }
      
      public function getDefBySolarSystemType(solarSystemType:String) : BackgroundDef
      {
         var returnValue:BackgroundDef = null;
         var bgDef:BackgroundDef = null;
         if(solarSystemType == "-1")
         {
            returnValue = this.getCurrentMainBackground();
         }
         else
         {
            for each(bgDef in getDefs())
            {
               if(bgDef.getSolarSystemType() == solarSystemType)
               {
                  return bgDef;
               }
            }
         }
         return returnValue;
      }
   }
}
