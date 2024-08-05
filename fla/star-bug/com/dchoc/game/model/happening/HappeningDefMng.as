package com.dchoc.game.model.happening
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class HappeningDefMng extends DCDefMng
   {
      
      public static const HALLOWEEN_SKU:String = "halloween";
      
      public static const DOOMSDAY_SKU:String = "doomsday";
      
      public static const DOOMSDAY_WINTER_SKU:String = "doomsday_winter";
      
      public static const BIRTHDAY_SKU:String = "birthday";
      
      public static const WINTER_SKU:String = "winter";
      
      public static const WINTER_ALT_SKU:String = "winter23";
       
      
      public function HappeningDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new HappeningDef();
      }
      
      public function getHappeningGraphic(happeningSku:String, iconName:String) : String
      {
         if(getDefBySku(happeningSku) == null)
         {
            DCDebug.traceCh("ASSERT","getHappeningGraphic : <" + happeningSku + "> sku not found");
            return "";
         }
         return "assets/flash/" + happeningSku + "/images/" + iconName + ".png";
      }
      
      public function getDefsByTypeSku(typeSku:String) : Vector.<HappeningDef>
      {
         var def:DCDef = null;
         var hDef:HappeningDef = null;
         var result:Vector.<HappeningDef> = new Vector.<HappeningDef>(0);
         for each(def in getDefs())
         {
            if((hDef = HappeningDef(def)).getTypeSku() == typeSku)
            {
               result.push(hDef);
            }
         }
         return result;
      }
   }
}
