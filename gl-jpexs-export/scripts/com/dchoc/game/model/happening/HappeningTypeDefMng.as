package com.dchoc.game.model.happening
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class HappeningTypeDefMng extends DCDefMng
   {
      
      public static const TYPE_WAVES_SKU:String = "waves";
      
      public static const TYPE_BIRTHDAY_SKU:String = "birthday";
      
      public static const TYPE_WINTER_SKU:String = "winter";
      
      public static const TYPE_SKUS:Vector.<String> = new <String>["waves","birthday","winter"];
      
      private static const RESOURCE_DEFS:Vector.<String> = new <String>["happeningTypeWaveDefinitions.xml","happeningTypeBirthdayDefinitions.xml","happeningTypeWinterDefinitions.xml"];
      
      private static const SIG_RESOURCE_DEFS:Vector.<String> = new <String>["happeningTypeWaveDefinitions.xml","happeningTypeBirthdayDefinitions.xml","happeningTypeWinterDefinitions.xml"];
       
      
      public function HappeningTypeDefMng(directoryPath:String = null)
      {
         super(RESOURCE_DEFS,TYPE_SKUS,directoryPath,SIG_RESOURCE_DEFS);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         var def:DCDef = null;
         switch(type)
         {
            case "waves":
               def = new HappeningTypeWaveDef();
               break;
            case "birthday":
               def = new HappeningTypeBirthdayDef();
               break;
            case "winter":
               def = new HappeningTypeWinterDef();
               break;
            default:
               def = new HappeningTypeDef();
         }
         return def;
      }
      
      public function createHappeningType(typeSku:String, sku:String) : HappeningType
      {
         var returnValue:HappeningType = null;
         var def:DCDef = null;
         var defs:Vector.<DCDef> = getDefsInGroup(typeSku);
         for each(def in defs)
         {
            if(def.mSku == sku)
            {
               break;
            }
         }
         if(def != null)
         {
            (returnValue = this.createHappeningTypeByType(typeSku)).setHappeningTypeDef(def as HappeningTypeDef);
         }
         return returnValue;
      }
      
      private function createHappeningTypeByType(typeSku:String) : HappeningType
      {
         var returnValue:HappeningType = null;
         switch(typeSku)
         {
            case "waves":
               returnValue = new HappeningTypeWave();
               break;
            case "birthday":
               returnValue = new HappeningTypeBirthday();
               break;
            case "winter":
               returnValue = new HappeningTypeWinter();
               break;
            default:
               returnValue = new HappeningType();
         }
         return returnValue;
      }
   }
}
