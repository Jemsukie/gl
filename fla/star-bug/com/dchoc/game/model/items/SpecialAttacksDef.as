package com.dchoc.game.model.items
{
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class SpecialAttacksDef extends DCDef
   {
      
      public static const GROUP_SHOW_IN_LEFT_BAR:String = "showInLeftBar";
      
      public static const GROUP_SHOW_IN_MERCENARIES_BAR:String = "showInMercenariesBar";
      
      public static const GROUP_SHOW_IN_TOP_BAR:String = "showInTopBar";
      
      public static const GROUP_SHOW_IN_UNITS_BAR:String = "showInUnitsBar";
      
      public static const TYPE_NONE:String = "";
      
      public static const TYPE_AREA:String = "area";
      
      public static const TYPE_NUKE:String = "nuke";
      
      public static const TYPE_MERCENARIES:String = "mercenaries";
      
      public static const TYPE_MORE_BATTLE_TIME:String = "battle_time";
       
      
      private var mType:SecureString;
      
      private var mCash:SecureNumber;
      
      private var mBulletTypes:Array = null;
      
      private var mIcon:SecureString;
      
      private var mCursorFrameTilesWidth:SecureInt;
      
      private var mCursorFrameTilesHeight:SecureInt;
      
      private var mItemSku:SecureString;
      
      private var mWave:SecureString;
      
      private var mAmount:SecureInt;
      
      private var mHasToDisableBattleEndButton:SecureBoolean;
      
      private var mShowItemCounter:SecureBoolean;
      
      private var mListOrder:SecureInt;
      
      private var mTargetCursor:SecureString;
      
      public function SpecialAttacksDef()
      {
         mType = new SecureString("SpecialAttacksDef.mType","");
         mCash = new SecureNumber("SpecialAttacksDef.mCash");
         mIcon = new SecureString("SpecialAttacksDef.mIcon","");
         mCursorFrameTilesWidth = new SecureInt("SpecialAttacksDef.mCursorFrameTilesWidth");
         mCursorFrameTilesHeight = new SecureInt("SpecialAttacksDef.mCursorFrameTilesHeight");
         mItemSku = new SecureString("SpecialAttacksDef.mItemSku","");
         mWave = new SecureString("SpecialAttacksDef.mWave","");
         mAmount = new SecureInt("SpecialAttacksDef.mAmount");
         mHasToDisableBattleEndButton = new SecureBoolean("SpecialAttacksDef.mHasToDisableBattleEndButton");
         mShowItemCounter = new SecureBoolean("SpecialAttacksDef.mHasToDisableBattleEndButton");
         mListOrder = new SecureInt("SpecialAttacksDef.mListOrder");
         mTargetCursor = new SecureString("SpecialAttacksDef.mTargetCursor","cursor_special_attack");
         super();
         this.mBulletTypes = [];
         this.mBulletTypes.push("sa_rocket");
      }
      
      override protected function getSigDo() : String
      {
         return "" + this.getType() + this.getCash() + this.getCursorMapFrameTilesWidth() + this.getCursorMapFrameTilesHeight() + this.getItemSku() + this.getWave() + this.getBulletTypes();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         this.mType.value = "";
         var attribute:String = "type";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mType.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "cash";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mCash.value = EUtils.xmlReadNumber(info,attribute);
         }
         attribute = "bulletType";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBulletTypes(EUtils.xmlReadString(info,attribute));
         }
         attribute = "icon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSpecialAttackIcon(EUtils.xmlReadString(info,attribute));
         }
         attribute = "cursorFrameTilesWidth";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCursorMapFrameTilesWidth(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "cursorFrameTilesHeight";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCursorMapFrameTilesHeight(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "itemSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setItemSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "wave";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWave(EUtils.xmlReadString(info,attribute));
         }
         attribute = "amount";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAmount(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "hasToDisableBattleEndButton";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHasToDisableBattleEndButton(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "showItemCounter";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShowItemCounter(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "listOrder";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setListOrder(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "targetCursor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTargetCursor(EUtils.xmlReadString(info,attribute));
         }
      }
      
      public function getItemSku() : String
      {
         return this.mItemSku.value;
      }
      
      private function setItemSku(value:String) : void
      {
         this.mItemSku.value = value;
      }
      
      public function getCursorMapFrameTilesWidth() : int
      {
         return this.mCursorFrameTilesWidth.value;
      }
      
      private function setCursorMapFrameTilesWidth(value:int) : void
      {
         this.mCursorFrameTilesWidth.value = value;
      }
      
      public function getCursorMapFrameTilesHeight() : int
      {
         return this.mCursorFrameTilesHeight.value;
      }
      
      private function setCursorMapFrameTilesHeight(value:int) : void
      {
         this.mCursorFrameTilesHeight.value = value;
      }
      
      public function getType() : String
      {
         return this.mType.value;
      }
      
      public function getCash() : Number
      {
         return this.mCash.value;
      }
      
      public function getBulletTypes() : Array
      {
         return this.mBulletTypes;
      }
      
      public function setBulletTypes(value:String) : void
      {
         this.mBulletTypes.length = 0;
         if(value != null)
         {
            this.mBulletTypes = value.split(",");
         }
      }
      
      private function setSpecialAttackIcon(value:String) : void
      {
         this.mIcon.value = value;
      }
      
      public function getSpecialAttackIcon() : String
      {
         return this.mIcon.value;
      }
      
      private function setWave(value:String) : void
      {
         this.mWave.value = value;
      }
      
      public function getWave() : String
      {
         return this.mWave.value;
      }
      
      private function setAmount(value:int) : void
      {
         this.mAmount.value = value;
      }
      
      public function getAmount() : int
      {
         return this.mAmount.value;
      }
      
      public function getHasToDisableBattleEndButton() : Boolean
      {
         return this.mHasToDisableBattleEndButton.value;
      }
      
      public function setHasToDisableBattleEndButton(value:Boolean) : void
      {
         this.mHasToDisableBattleEndButton.value = value;
      }
      
      public function getShowItemCounter() : Boolean
      {
         return this.mShowItemCounter.value;
      }
      
      private function setShowItemCounter(value:Boolean) : void
      {
         this.mShowItemCounter.value = value;
      }
      
      public function getListOrder() : int
      {
         return this.mListOrder.value;
      }
      
      private function setListOrder(value:int) : void
      {
         this.mListOrder.value = value;
      }
      
      public function getTargetCursor() : String
      {
         return this.mTargetCursor.value;
      }
      
      private function setTargetCursor(value:String) : void
      {
         this.mTargetCursor.value = value;
      }
   }
}
