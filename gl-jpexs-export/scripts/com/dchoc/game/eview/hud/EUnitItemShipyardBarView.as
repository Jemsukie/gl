package com.dchoc.game.eview.hud
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.hangar.EUnitItemView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltip;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EUnitItemShipyardBarView extends EUnitItemView
   {
      
      protected static const AREA_BUTTON:String = "btn";
      
      protected static const USE_AUTO_INCREMENT:Boolean = true;
      
      protected static const ADD_UNIT_INTERVAL:int = 200;
      
      private static const STATE_UNKNOWN:int = 0;
      
      private static const STATE_LOCKED:int = 1;
      
      private static const STATE_UNLOCKING:int = 2;
      
      private static const STATE_AVAILABLE:int = 3;
       
      
      protected var mLastUnitAddedTimeElapsed:int = 0;
      
      protected var mAutoIncrementedAmount:int = 0;
      
      protected var mIsAdding:Boolean = false;
      
      private var mState:int;
      
      private var mLastTooltipCreated:ETooltip;
      
      public function EUnitItemShipyardBarView()
      {
         super();
         mLayoutName = "BoxUnitsButtons";
         mBoxProp = "units_box";
         mCloseBtnProp = null;
      }
      
      override protected function setupButtons() : void
      {
         var btn:EButton = mViewFactory.getButtonByTextWidth("......",mLayout.getArea("btn").width,"btn_hud","icon_coin",null,null);
         btn.name = "btn";
         btn.setLayoutArea(mLayout.getArea("btn"),true);
         if(true)
         {
            btn.eAddEventListener("mouseDown",this.onStartAddUnit);
            btn.eAddEventListener("mouseUp",this.onEndAddUnit);
            btn.eAddEventListener("rollOut",this.onEndAddUnit);
         }
         else
         {
            btn.eAddEventListener("click",this.onButtonClicked);
         }
         btn.setDefaultRemoveTooltipOnMouseUp(false);
         setContent("btn",btn);
         eAddChild(btn);
         btn = mViewFactory.getButtonImage("btn_info",null,mLayout.getArea("icon"));
         btn.name = "icon";
         btn.eAddEventListener("click",this.onInfoClicked);
         setContent("icon",btn);
         eAddChild(btn);
         btn = mViewFactory.getButtonImage("btn_close",null,mLayout.getArea("btn_close"));
         btn.name = "btn_close";
         btn.eAddEventListener("click",this.onCloseClicked);
         setContent("btn_close",btn);
         eAddChild(btn);
      }
      
      override public function fillData(object:Array) : void
      {
         this.mState = 0;
         mItemDef = object[0];
         mBaseItemSku = mItemDef.getSku();
         mViewFactory.setTextureToImage(mItemDef.getIcon(),mSkinSku,getContent("img") as EImage);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var interval:Number = NaN;
         var tf:ETextField = null;
         super.logicUpdate(dt);
         if(!mItemDef)
         {
            return;
         }
         if(mItemDef.getConstructionCoins() == 0 && getContentAsEButton("btn").getIcon().getTexture() != "icon_mineral")
         {
            InstanceMng.getViewFactory().setTextureToImage("icon_mineral",mSkinSku,getContentAsEButton("btn").getIcon());
         }
         if(mItemDef.getConstructionMineral() == 0 && getContentAsEButton("btn").getIcon().getTexture() != "icon_coin")
         {
            InstanceMng.getViewFactory().setTextureToImage("icon_coin",mSkinSku,getContentAsEButton("btn").getIcon());
         }
         if(this.getIsAdding())
         {
            interval = Math.max(15,200 * (1 - this.mAutoIncrementedAmount * 0.05));
            this.mLastUnitAddedTimeElapsed += dt;
            if(this.mLastUnitAddedTimeElapsed >= interval)
            {
               this.addUnit();
               this.mLastUnitAddedTimeElapsed -= interval;
               this.mAutoIncrementedAmount++;
            }
         }
         var remainingUnlockTime:Number = this.getUnlockingTime();
         if(remainingUnlockTime > 0)
         {
            this.changeState(2);
            tf = getContentAsETextField("text");
            tf.setText(DCTextMng.convertTimeToStringColon(this.getUnlockingTime()));
         }
         else if(this.isLocked())
         {
            this.changeState(1);
         }
         else
         {
            this.changeState(3);
         }
      }
      
      private function changeState(state:int) : void
      {
         var tf:ETextField = null;
         if(this.mState == state)
         {
            return;
         }
         var btn:EButton = getContentAsEButton("btn");
         if(state == 1)
         {
            btn.setText(DCTextMng.getText(164));
            btn.getIcon().visible = false;
            getContent("text").visible = false;
            getContent("btn_close").visible = false;
         }
         else if(state == 2)
         {
            tf = getContentAsETextField("text");
            tf.visible = true;
            tf.setText(DCTextMng.convertTimeToStringColon(this.getUnlockingTime()));
            btn.setText(DCTextMng.getText(173));
            btn.getIcon().visible = false;
            getContent("text").visible = true;
            getContent("btn_close").visible = true;
         }
         else if(state == 3)
         {
            if(mItemDef.getConstructionCoins() > 0)
            {
               btn.setText(DCTextMng.getText(mItemDef.getConstructionCoins().toString()));
            }
            else
            {
               btn.setText(DCTextMng.getText(mItemDef.getConstructionMineral().toString()));
            }
            btn.getIcon().visible = true;
            getContent("text").visible = false;
            getContent("btn_close").visible = false;
         }
         this.mState = state;
      }
      
      override protected function onMouseOver(evt:EEvent) : void
      {
         var tooltipText:String = null;
         if(mItemDef)
         {
            tooltipText = mItemDef.getNameToDisplay() + "\n" + DCTextMng.getText(553) + ": " + mItemDef.getSize();
            this.mLastTooltipCreated = ETooltipMng.getInstance().showTooltip(ETooltipMng.getInstance().createTooltipInfoFromShipDefForBuilding(mItemDef,getContent("img"),null,false,false));
         }
      }
      
      override protected function onMouseOut(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeTooltip(this.mLastTooltipCreated);
      }
      
      private function onButtonClicked(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         switch(this.mState - 1)
         {
            case 0:
               params["sku"] = mItemDef.mSku;
               MessageCenter.getInstance().sendMessage("hudShipyardBarUnlockClicked",params);
               break;
            case 1:
               params["sku"] = mItemDef.mSku;
               MessageCenter.getInstance().sendMessage("hudShipyardBarSpeedupClicked",params);
               break;
            case 2:
               this.addUnit();
         }
      }
      
      private function onStartAddUnit(evt:EEvent) : void
      {
         if(this.mState == 3)
         {
            this.setIsAdding(true);
            this.addUnit();
            this.mLastUnitAddedTimeElapsed = 0;
         }
      }
      
      private function onEndAddUnit(evt:EEvent) : void
      {
         if(this.mState == 3 || this.getIsAdding())
         {
            this.setIsAdding(false);
            this.mLastUnitAddedTimeElapsed = 0;
            this.mAutoIncrementedAmount = 0;
         }
         else if(evt.getType() == "mouseUp")
         {
            this.onButtonClicked(evt);
         }
      }
      
      private function onInfoClicked(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["sku"] = mItemDef.mSku;
         MessageCenter.getInstance().sendMessage("hudShipyardBarInfoClicked",params);
      }
      
      private function onCloseClicked(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["sku"] = mItemDef.mSku;
         MessageCenter.getInstance().sendMessage("hudShipyardBarCloseClicked",params);
      }
      
      private function addUnit() : void
      {
         var params:Dictionary = new Dictionary();
         params["sku"] = mItemDef.mSku;
         MessageCenter.getInstance().sendMessage("hudShipyardBarButtonClicked",params);
      }
      
      private function getUnlockingTime() : Number
      {
         var gameUnit:GameUnit = null;
         var timeLeft:int = 0;
         if(mItemDef)
         {
            gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(mItemDef.mSku);
            if(gameUnit.mIsUnlocked)
            {
               return 0;
            }
            if(gameUnit.mDef.getStartLocked() || mItemDef.getLevel() > 0)
            {
               return int(gameUnit.mTimeLeft);
            }
         }
         return 0;
      }
      
      private function isLocked() : Boolean
      {
         var gameUnit:GameUnit = null;
         if(mItemDef)
         {
            gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(mItemDef.mSku);
            if(gameUnit.mIsUnlocked)
            {
               return false;
            }
            if(gameUnit.mDef.getStartLocked() || mItemDef.getLevel() > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function setIsAdding(b:Boolean) : void
      {
         this.mIsAdding = b;
      }
      
      private function getIsAdding() : Boolean
      {
         return this.mIsAdding;
      }
      
      override public function set mouseEnabled(enabled:Boolean) : void
      {
         super.mouseEnabled = enabled;
         super.mouseChildren = enabled;
      }
   }
}
