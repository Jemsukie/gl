package com.dchoc.game.controller.gameunit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.upgrade.EPopupUpgrade;
   import com.dchoc.game.model.gameunit.GameUnitMng;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class GameUnitMngController extends DCComponent
   {
      
      private static const PROFILES_OWNER:uint = 0;
      
      private static const PROFILES_NON_OWNER:uint = 1;
      
      private static const PROFILES_COUNT:uint = 2;
       
      
      private var mGameUnitMngs:Vector.<GameUnitMng>;
      
      private var mCurrentProfile:uint;
      
      public function GameUnitMngController()
      {
         super();
         this.mCurrentProfile = 0;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var i:int = 0;
         this.mGameUnitMngs = new Vector.<GameUnitMng>(2,true);
         for(i = 0; i < 2; )
         {
            this.mGameUnitMngs[i] = new GameUnitMng();
            this.mGameUnitMngs[i].load();
            i++;
         }
      }
      
      override protected function unloadDo() : void
      {
         var i:int = 0;
         for(i = 0; i < 2; )
         {
            this.mGameUnitMngs[i].unload();
            i++;
         }
         this.mGameUnitMngs = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && mPersistenceData != null && InstanceMng.getWorld().isBuilt() && InstanceMng.getShipDefMng().isBuilt())
         {
            if(this.mGameUnitMngs[this.mCurrentProfile].isBuilt() == false)
            {
               this.mGameUnitMngs[this.mCurrentProfile].build();
            }
            if(this.mGameUnitMngs[this.mCurrentProfile].isBuilt())
            {
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.unbuildMode(InstanceMng.getApplication().mFlowStateUnbuildMode);
         this.mGameUnitMngs[1].unbuild();
      }
      
      override public function unbuildMode(mode:int) : void
      {
         if(mode == 1)
         {
            this.mGameUnitMngs[0].unbuild();
         }
      }
      
      override public function persistenceSetData(value:XML) : void
      {
         super.persistenceSetData(value);
         if(this.mGameUnitMngs[0].isBuilt() == false)
         {
            this.mGameUnitMngs[0].persistenceSetData(value);
         }
         this.mGameUnitMngs[1].persistenceSetData(value);
      }
      
      override public function persistenceGetData() : XML
      {
         return this.mGameUnitMngs[this.mCurrentProfile].persistenceGetData();
      }
      
      public function getGameUnitMng() : GameUnitMng
      {
         return this.mGameUnitMngs[this.mCurrentProfile];
      }
      
      public function getGameUnitMngOwner() : GameUnitMng
      {
         return this.mGameUnitMngs[0];
      }
      
      public function changeProfileDependingOnRole(newRoleId:int) : void
      {
         switch(newRoleId - 1)
         {
            case 0:
            case 1:
            case 2:
               this.mCurrentProfile = 1;
               break;
            default:
               this.mCurrentProfile = 0;
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         this.mGameUnitMngs[0].logicUpdate(dt);
      }
      
      public function guiOpenUnitUpgradedPopup(unitDef:ShipDef, hasUnlocked:Boolean) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getUnitUpgradedPopup(unitDef,hasUnlocked);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenLaboratoryPopup(e:Object) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getUpdateUnitPopup(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         if(e.popup != null && e.unit != null)
         {
            EPopupUpgrade(e.popup).notify({
               "cmd":"NotifyUnitSelected",
               "unit":e.unit
            });
            EPopupUpgrade(e.popup).logicUpdate(0);
         }
         return popup;
      }
   }
}
