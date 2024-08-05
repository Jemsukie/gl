package com.dchoc.game.model.items
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import flash.utils.Dictionary;
   
   public class SpecialAttacksDefMng extends DCDefMng
   {
      
      private static const RESOURCES_FILES:Vector.<String> = new <String>["specialAttacksDefinitions.xml"];
      
      private static const GROUP_SHOW_IN_LEFT_BAR:Vector.<String> = new <String>["showInLeftBar"];
      
      private static const GROUP_SHOW_IN_MERCENARIES_BAR:Vector.<String> = new <String>["showInMercenariesBar"];
      
      private static const GROUP_SHOW_IN_TOP_BAR:Vector.<String> = new <String>["showInTopBar"];
       
      
      private var mSkusFromBulletType:Dictionary;
      
      public function SpecialAttacksDefMng()
      {
         super(RESOURCES_FILES,null,null,RESOURCES_FILES);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new SpecialAttacksDef();
      }
      
      override protected function buildDefs() : void
      {
         var i:int = 0;
         var itemDefObj:SpecialAttacksDef = null;
         var bulletTypes:Array = null;
         var bulletType:String = null;
         super.buildDefs();
         var itemDefVector:Vector.<DCDef> = getDefs();
         this.mSkusFromBulletType = new Dictionary();
         for(i = itemDefVector.length - 1; i > -1; )
         {
            itemDefObj = SpecialAttacksDef(itemDefVector[i]);
            bulletTypes = itemDefObj.getBulletTypes();
            for each(bulletType in bulletTypes)
            {
               this.mSkusFromBulletType[bulletType] = itemDefObj.mSku;
            }
            i--;
         }
      }
      
      public function getDefFromItemDef(itemdef:ItemsDef) : SpecialAttacksDef
      {
         if(itemdef.getActionType() == "specialAttack")
         {
            return getDefBySku(itemdef.getActionParam()) as SpecialAttacksDef;
         }
         return null;
      }
      
      public function getSkuFromBulletType(bulletType:String) : String
      {
         return this.mSkusFromBulletType != null ? this.mSkusFromBulletType[bulletType] : null;
      }
      
      public function getDefsShowInLeftBar() : Vector.<DCDef>
      {
         return getDefs(GROUP_SHOW_IN_LEFT_BAR);
      }
      
      public function getDefsShowInMercenariesBar() : Vector.<DCDef>
      {
         return getDefs(GROUP_SHOW_IN_MERCENARIES_BAR);
      }
      
      public function getDefsShowInTopBar() : Vector.<DCDef>
      {
         return getDefs(GROUP_SHOW_IN_TOP_BAR);
      }
   }
}
