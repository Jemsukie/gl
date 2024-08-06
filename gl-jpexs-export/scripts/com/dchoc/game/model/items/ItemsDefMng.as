package com.dchoc.game.model.items
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class ItemsDefMng extends DCDefMng
   {
       
      
      public function ItemsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new ItemsDef();
      }
      
      override protected function buildDefs() : void
      {
         var i:int = 0;
         var itemDefObj:ItemsDef = null;
         var itemDefVector:Vector.<DCDef> = getDefs();
         for(i = itemDefVector.length - 1; i > 0; )
         {
            itemDefObj = ItemsDef(itemDefVector[i]);
            i--;
         }
      }
   }
}
