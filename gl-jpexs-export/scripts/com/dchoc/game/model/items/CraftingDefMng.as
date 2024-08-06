package com.dchoc.game.model.items
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class CraftingDefMng extends DCDefMng
   {
       
      
      public function CraftingDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new CraftingDef();
      }
   }
}