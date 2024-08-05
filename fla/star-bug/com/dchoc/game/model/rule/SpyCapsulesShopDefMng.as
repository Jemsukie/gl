package com.dchoc.game.model.rule
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class SpyCapsulesShopDefMng extends DCDefMng
   {
       
      
      private var mEntries:Vector.<Entry>;
      
      public function SpyCapsulesShopDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new SpyCapsulesShopDef();
      }
      
      override protected function sortCompareFunction(a:DCDef, b:DCDef) : Number
      {
         var aValue:Number = (a as SpyCapsulesShopDef).getPriceCash();
         var bValue:Number = (b as SpyCapsulesShopDef).getPriceCash();
         var returnValue:Number = 0;
         if(aValue > bValue)
         {
            returnValue = 1;
         }
         else if(aValue < bValue)
         {
            returnValue = -1;
         }
         return returnValue;
      }
      
      public function getEntries() : Vector.<Entry>
      {
         var defs:Vector.<DCDef> = null;
         var def:DCDef = null;
         if(this.mEntries == null)
         {
            defs = getDefs();
            this.mEntries = new Vector.<Entry>(0);
            for each(def in defs)
            {
               this.mEntries.push(SpyCapsulesShopDef(def).getEntry());
            }
         }
         return this.mEntries;
      }
   }
}
