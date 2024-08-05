package com.dchoc.game.model.umbrella
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class UmbrellaSettingsDefMng extends DCDefMng
   {
       
      
      public var mSettingsDef:UmbrellaSettingsDef;
      
      public function UmbrellaSettingsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function unloadDo() : void
      {
         this.mSettingsDef = null;
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         this.mSettingsDef = UmbrellaSettingsDef(getDefBySku("1"));
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new UmbrellaSettingsDef();
      }
      
      public function getUmbrellaSettingsDef() : UmbrellaSettingsDef
      {
         return this.mSettingsDef;
      }
   }
}
