package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class DamageProtectionDefMng extends DCDefMng
   {
       
      
      public function DamageProtectionDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new DamageProtectionDef();
      }
      
      override protected function sortCompareFunction(a:DCDef, b:DCDef) : Number
      {
         var aint:int = int(a.mSku);
         var bint:int = int(b.mSku);
         if(aint > bint)
         {
            return 1;
         }
         if(aint < bint)
         {
            return -1;
         }
         return 0;
      }
   }
}
