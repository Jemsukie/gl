package com.dchoc.game.eview.popups.hangar
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EUnitItemTransferView extends EUnitItemView
   {
      
      protected static const AREA_BUTTONS:String = "area_btns";
      
      protected static const USE_AUTO_INCREMENT:Boolean = true;
      
      protected static const BTN_PLUS_NAME:String = "btn_plus";
      
      protected static const BTN_MINUS_NAME:String = "btn_minus";
      
      protected static const ADD_UNIT_INTERVAL:int = 200;
       
      
      protected var mLastUnitAddedTimeElapsed:int = 0;
      
      protected var mAutoIncrementedAmount:int = 0;
      
      protected var mIsAdding:Boolean = false;
      
      protected var mIsRemoving:Boolean = false;
      
      private var mCurrentAmount:int;
      
      public function EUnitItemTransferView()
      {
         super();
         mLayoutName = "BoxUnitsButtons";
         mBoxProp = "units_box";
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var interval:Number = NaN;
         super.logicUpdate(dt);
         if(this.getIsAdding() || this.getIsRemoving())
         {
            interval = Math.max(15,200 * (1 - this.mAutoIncrementedAmount * 0.08));
            this.mLastUnitAddedTimeElapsed += dt;
            if(this.mLastUnitAddedTimeElapsed >= interval)
            {
               if(this.getIsAdding())
               {
                  this.addUnit();
               }
               else
               {
                  this.removeUnit();
               }
               this.mLastUnitAddedTimeElapsed -= interval;
               this.mAutoIncrementedAmount++;
            }
         }
      }
      
      override protected function setupButtons() : void
      {
         var buttonPlus:EButton = null;
         var buttonMinus:EButton = null;
         var buttonsArea:ESpriteContainer = mViewFactory.getESpriteContainer();
         buttonsArea.setLayoutArea(mLayout.getArea("area_btns"),true);
         this.eAddChild(buttonsArea);
         this.setContent("area_btns",buttonsArea);
         buttonPlus = mViewFactory.getButtonImage("btn_plus",mSkinSku,null);
         buttonMinus = mViewFactory.getButtonImage("btn_minus",mSkinSku,null);
         if(true)
         {
            buttonPlus.eAddEventListener("mouseDown",this.onStartAddUnit);
            buttonPlus.eAddEventListener("mouseUp",this.onEndAddUnit);
            buttonPlus.eAddEventListener("rollOut",this.onEndAddUnit);
            buttonMinus.eAddEventListener("mouseDown",this.onStartRemoveUnit);
            buttonMinus.eAddEventListener("mouseUp",this.onEndRemoveUnit);
            buttonMinus.eAddEventListener("rollOut",this.onEndRemoveUnit);
         }
         else
         {
            buttonPlus.eAddEventListener("click",this.onStartAddUnit);
            buttonMinus.eAddEventListener("click",this.onStartRemoveUnit);
         }
         buttonsArea.eAddChild(buttonPlus);
         buttonsArea.setContent("btn_plus",buttonPlus);
         buttonsArea.eAddChild(buttonMinus);
         buttonsArea.setContent("btn_minus",buttonMinus);
         buttonPlus.getBackground().onSetTextureLoaded = this.onButtonLoaded;
         buttonMinus.getBackground().onSetTextureLoaded = this.onButtonLoaded;
      }
      
      public function setEnabledPlusButton(enable:Boolean) : void
      {
         var button:ESprite = null;
         if(getContent("area_btns"))
         {
            button = ESpriteContainer(getContent("area_btns")).getContent("btn_plus");
            if(button)
            {
               (button as EButton).setIsEnabled(enable);
            }
            if(!enable)
            {
               this.setIsAdding(false);
               this.mLastUnitAddedTimeElapsed = 0;
            }
         }
      }
      
      public function setEnabledMinusButton(enable:Boolean) : void
      {
         var button:ESprite = null;
         if(getContent("area_btns"))
         {
            button = ESpriteContainer(getContent("area_btns")).getContent("btn_minus");
            if(button)
            {
               (button as EButton).setIsEnabled(enable);
            }
            if(!enable)
            {
               this.setIsRemoving(false);
               this.mLastUnitAddedTimeElapsed = 0;
            }
         }
      }
      
      public function setCurrentAmount(value:int) : void
      {
         this.mCurrentAmount = value;
         setText(this.mCurrentAmount + "/" + mTotalAmount);
      }
      
      private function addUnit() : void
      {
         var params:Dictionary = new Dictionary();
         params["sku"] = mBaseItemSku;
         params["amount"] = Math.min(this.mCurrentAmount + 1,mTotalAmount);
         MessageCenter.getInstance().sendMessage("bunkerTransactionUnitsUpdate",params);
      }
      
      private function removeUnit() : void
      {
         var params:Dictionary = new Dictionary();
         params["sku"] = mBaseItemSku;
         params["amount"] = Math.max(0,this.mCurrentAmount - 1);
         MessageCenter.getInstance().sendMessage("bunkerTransactionUnitsUpdate",params);
      }
      
      private function onButtonLoaded(img:EImage) : void
      {
         var buttonPlus:ESprite = ESpriteContainer(getContent("area_btns")).getContent("btn_plus");
         var buttonMinus:ESprite = ESpriteContainer(getContent("area_btns")).getContent("btn_minus");
         var offsetX:int = ((buttonPlus.parent as ESpriteContainer).getLogicWidth() - buttonMinus.width - buttonPlus.width) / 3;
         buttonPlus.logicLeft = offsetX;
         buttonMinus.logicLeft = 2 * offsetX + buttonPlus.width;
      }
      
      private function onStartAddUnit(evt:EEvent) : void
      {
         this.setIsAdding(true);
         this.addUnit();
         this.mLastUnitAddedTimeElapsed = 0;
      }
      
      private function onEndAddUnit(evt:EEvent) : void
      {
         this.setIsAdding(false);
         this.mLastUnitAddedTimeElapsed = 0;
         this.mAutoIncrementedAmount = 0;
      }
      
      private function onStartRemoveUnit(evt:EEvent) : void
      {
         this.setIsRemoving(true);
         this.removeUnit();
         this.mLastUnitAddedTimeElapsed = 0;
      }
      
      private function onEndRemoveUnit(evt:EEvent) : void
      {
         this.setIsRemoving(false);
         this.mLastUnitAddedTimeElapsed = 0;
         this.mAutoIncrementedAmount = 0;
      }
      
      override protected function onMouseOver(evt:EEvent) : void
      {
         ETooltipMng.getInstance().createTooltipInfoFromShipDef(mItemDef,this);
      }
      
      private function setIsAdding(b:Boolean) : void
      {
         this.mIsAdding = b;
      }
      
      private function getIsAdding() : Boolean
      {
         return this.mIsAdding;
      }
      
      private function setIsRemoving(b:Boolean) : void
      {
         this.mIsRemoving = b;
      }
      
      private function getIsRemoving() : Boolean
      {
         return this.mIsRemoving;
      }
   }
}
