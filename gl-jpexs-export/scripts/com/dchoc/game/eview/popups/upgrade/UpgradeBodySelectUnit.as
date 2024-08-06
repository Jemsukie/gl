package com.dchoc.game.eview.popups.upgrade
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.utils.EUtils;
   import esparragon.widgets.EFillBar;
   
   public class UpgradeBodySelectUnit extends UpgradeBody
   {
      
      private static const CONTAINER_BACKGROUND:String = "bkg";
      
      private static const CONTAINER_UNIT:String = "unit";
      
      private static const CONTAINER_LEVEL:String = "level";
       
      
      private var mUnitsArea:ELayoutArea;
      
      private var mGameUnits:Vector.<GameUnit>;
      
      private var mUpgradingUnit:GameUnit;
      
      private var mActivatingUnit:GameUnit;
      
      private var mIsUpgrading:Boolean;
      
      private var mIsActivating:Boolean;
      
      private var mUnitsContainers:Array;
      
      private var mBottomArea:ELayoutArea;
      
      public function UpgradeBodySelectUnit(popupUpgrade:EPopupUpgrade, skinSku:String, viewFactory:ViewFactory)
      {
         super(popupUpgrade,viewFactory,skinSku);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mUnitsArea = null;
         this.mUnitsContainers = null;
      }
      
      public function setup() : void
      {
         var i:int = 0;
         var container:ESpriteContainer = null;
         var field:ETextField = null;
         var unitsDefs:Vector.<DCDef> = null;
         var shipDef:ShipDef = null;
         var gameUnit:GameUnit = null;
         var img:EImage = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutLab");
         this.mUnitsArea = layoutFactory.getArea("container_units");
         this.getUpgradingUnit();
         if(this.mGameUnits == null)
         {
            this.mGameUnits = new Vector.<GameUnit>(0);
            unitsDefs = InstanceMng.getShipDefMng().getDefsSorted();
            for each(shipDef in unitsDefs)
            {
               gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(shipDef.mSku);
               this.mGameUnits.push(gameUnit);
            }
         }
         var unitsCount:int = int(this.mGameUnits.length);
         this.mUnitsContainers = [];
         for(i = 0; i < unitsCount; )
         {
            container = this.createUnitBox(this.mGameUnits[i]);
            this.mUnitsContainers.push(container);
            eAddChild(container);
            setContent("container" + i,container);
            i++;
         }
         mViewFactory.distributeSpritesInArea(this.mUnitsArea,this.mUnitsContainers,1,0,4,4);
         this.mBottomArea = layoutFactory.getArea("area_upgrade_units");
         if(this.getUpgradingUnit() == null && this.mActivatingUnit == null)
         {
            img = mViewFactory.getEImage("box_simple",mSkinSku,false,this.mBottomArea);
            eAddChild(img);
            setContent("bottomBkg",img);
            img.applySkinProp(mSkinSku,"color_blue_box");
            (field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title_info"),"text_subheader")).setText(DCTextMng.getText(205));
            eAddChild(field);
            setContent("title",field);
            (field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"),"text_subheader_1")).setText(DCTextMng.getText(1032));
            eAddChild(field);
            setContent("text",field);
         }
         else
         {
            this.setupUpgradingBox();
         }
      }
      
      private function createUnitBox(unit:GameUnit) : ESpriteContainer
      {
         var icon:ESprite = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("BoxUnits");
         var container:ESpriteContainer = mViewFactory.getESpriteContainer();
         var img:EImage = mViewFactory.getEImage("box_with_border",mSkinSku,false,layoutFactory.getArea("container_box"));
         container.eAddChild(img);
         container.setContent("bkg",img);
         img = mViewFactory.getEImage(unit.mDef.getIcon(),mSkinSku,true,layoutFactory.getArea("img"));
         container.eAddChild(img);
         container.setContent("unit",img);
         if(!unit.mIsUnlocked)
         {
            icon = mViewFactory.getEImage("icon_lock",mSkinSku,true,layoutFactory.getArea("icon"));
            if(this.mActivatingUnit != null)
            {
               if(this.mActivatingUnit == unit && this.getUpgradingUnit() == null)
               {
                  container.applySkinProp(mSkinSku,"unit_upgrading");
               }
               else
               {
                  container.applySkinProp(mSkinSku,"units_noupgrading");
               }
            }
         }
         else
         {
            icon = mViewFactory.getContentIconWithTextVertical("CenterIconTextXS","icon_upgrade_unit","" + (unit.mDef.getUpgradeId() + 1),mSkinSku,"text_title_3");
            if(this.getUpgradingUnit() != null && !unit.isUpgrading())
            {
               container.applySkinProp(mSkinSku,"units_noupgrading");
            }
            else if(unit.isUpgrading())
            {
               container.applySkinProp(mSkinSku,"unit_upgrading");
            }
         }
         if(icon != null)
         {
            container.eAddChild(icon);
            container.setContent("level",icon);
         }
         container.mouseChildren = false;
         container.buttonMode = true;
         container.eAddEventBehavior("rollOver",mViewFactory.getMouseBehavior("MouseOverGray"));
         container.eAddEventBehavior("rollOut",mViewFactory.getMouseBehavior("MouseOutResetColor"));
         container.eAddEventListener("click",this.onSelectUnit);
         return container;
      }
      
      override protected function setupUpgradingBox() : void
      {
         super.setupUpgradingBox();
         this.mBottomArea.centerContent(mUpgradingBox);
      }
      
      private function getUpgradingUnit() : GameUnit
      {
         this.mUpgradingUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradingUnit();
         this.mIsUpgrading = this.mUpgradingUnit != null;
         this.mActivatingUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUnlockingUnit();
         this.mIsActivating = this.mActivatingUnit != null;
         return this.mUpgradingUnit;
      }
      
      override protected function printTimer() : void
      {
         var unit:GameUnit = null;
         if(this.mUpgradingUnit != null)
         {
            unit = this.mUpgradingUnit;
         }
         else if(this.mActivatingUnit != null)
         {
            unit = this.mActivatingUnit;
         }
         if(unit == null || mUpgradingBox == null)
         {
            return;
         }
         var timerField:ETextField = mUpgradingBox.getContentAsETextField("timer");
         var textToPrint:String = DCTextMng.convertTimeToStringColon(unit.mTimeLeft,true);
         timerField.setText(textToPrint);
         var fillBar:EFillBar;
         (fillBar = mUpgradingBox.getContent("fillBar") as EFillBar).setValue(unit.getNextDef().getCostTime() - unit.mTimeLeft);
      }
      
      override protected function getPayButtonValue() : Number
      {
         var transaction:Transaction = null;
         var chips:Number = 0;
         if(this.mUpgradingUnit != null)
         {
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUpUpgradeUnit(this.mUpgradingUnit.mDef.mSku);
         }
         else if(this.mActivatingUnit != null)
         {
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUp(this.mActivatingUnit.mDef,mPopupUpgrade.getEvent());
         }
         if(transaction != null)
         {
            chips = Math.abs(transaction.getTransCash());
         }
         return chips;
      }
      
      override protected function getIcon() : String
      {
         if(this.mUpgradingUnit != null)
         {
            return this.mUpgradingUnit.getNextDef().getIcon();
         }
         if(this.mActivatingUnit != null)
         {
            return this.mActivatingUnit.mDef.getIcon();
         }
         return super.getIcon();
      }
      
      override protected function getCostTime() : Number
      {
         if(this.mUpgradingUnit != null)
         {
            return this.mUpgradingUnit.getNextDef().getCostTime();
         }
         if(this.mActivatingUnit != null)
         {
            return this.mActivatingUnit.mDef.getCostTime();
         }
         return super.getCostTime();
      }
      
      override protected function getUpgradingBoxTitle() : String
      {
         var text:String = null;
         if(this.mUpgradingUnit != null)
         {
            text = DCTextMng.replaceParameters(602,[this.mUpgradingUnit.mDef.getUpgradeId() + 2 + ""]);
         }
         else
         {
            text = DCTextMng.getText(164);
         }
         return text;
      }
      
      override protected function reload() : void
      {
         this.setup();
      }
      
      override protected function checkUpgradeOrActivateEnded() : Boolean
      {
         return this.mIsUpgrading && this.mUpgradingUnit != null && this.mUpgradingUnit.mTimeLeft == 0 || this.mIsActivating && this.mActivatingUnit != null && this.mActivatingUnit.mTimeLeft == 0;
      }
      
      override protected function getPayChipsValue() : Number
      {
         return this.getPayButtonValue();
      }
      
      override protected function onAccelerateUpgradeActivate(e:EEvent) : void
      {
         var transaction:Transaction = null;
         var event:Object = EUtils.cloneObject(mPopupUpgrade.getEvent());
         if(this.mUpgradingUnit != null)
         {
            event.itemDef = this.mUpgradingUnit.mDef;
            event.nextDef = this.mUpgradingUnit.getNextDef();
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUpUpgradeUnit(event.itemDef.mSku);
            event.unlocking = false;
         }
         else
         {
            if(this.mActivatingUnit == null)
            {
               return;
            }
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUp(this.mActivatingUnit.mDef,event);
            event.unlocking = true;
            event.itemDef = this.mActivatingUnit.mDef;
            event.nextDef = this.mActivatingUnit.mDef;
         }
         event.accelerate = true;
         event.transaction = transaction;
         event.popup = mPopupUpgrade;
         event.isInfo = false;
         event.button = "EventYesButtonPressed";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      override protected function onCancelUpgradeActivate(e:EEvent) : void
      {
         var gameUnit:GameUnit = this.mUpgradingUnit;
         if(gameUnit == null)
         {
            gameUnit = this.mActivatingUnit;
         }
         if(gameUnit == null)
         {
            return;
         }
         InstanceMng.getGameUnitMngController().getGameUnitMngOwner().cancelCurrentAction(gameUnit);
         mPopupUpgrade.notify({"cmd":"NotifyLoadUnitsSelection"});
      }
      
      private function onSelectUnit(e:EEvent) : void
      {
         var gameUnit:GameUnit = null;
         var boxSelected:ESprite = e.getTarget() as ESprite;
         var index:int = this.mUnitsContainers.indexOf(boxSelected);
         if(index > -1)
         {
            gameUnit = this.mGameUnits[index];
            mPopupUpgrade.notify({
               "cmd":"NotifyUnitSelected",
               "unit":gameUnit
            });
         }
      }
   }
}
