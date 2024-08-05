package com.dchoc.game.model.space
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class SolarSystemDefMng extends DCDefMng
   {
       
      
      public function SolarSystemDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new SolarSystemDef();
      }
      
      public function getAssetIdBySku(sku:String) : String
      {
         var starDef:SolarSystemDef = SolarSystemDef(getDefBySku(sku));
         if(starDef == null)
         {
            return "";
         }
         return starDef.getAssetId();
      }
   }
}
