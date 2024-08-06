package com.dchoc.game.controller.world.item
{
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.controller.world.item.actionsUI.ActionUI;
   import com.dchoc.game.controller.world.item.actionsUI.CollectRentActionUI;
   import com.dchoc.game.controller.world.item.actionsUI.DemolishActionUI;
   import com.dchoc.game.controller.world.item.actionsUI.InteractShipyardActionUI;
   import com.dchoc.game.controller.world.item.actionsUI.PlaceItemActionUI;
   import com.dchoc.game.controller.world.item.actionsUI.WaitingForDroidActionUI;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.item.states.BuildingPlacedState;
   import com.dchoc.game.model.world.item.states.BuildingState;
   import com.dchoc.game.model.world.item.states.ItemOrientedState;
   import com.dchoc.game.model.world.item.states.LaboratoryState;
   import com.dchoc.game.model.world.item.states.RefineryState;
   import com.dchoc.game.model.world.item.states.RentCollectingState;
   import com.dchoc.game.model.world.item.states.RentReadyState;
   import com.dchoc.game.model.world.item.states.RentWaitingState;
   import com.dchoc.game.model.world.item.states.ShipyardState;
   import com.dchoc.game.model.world.item.states.WaitingForDroidState;
   import com.dchoc.game.model.world.item.states.WaitingForUIState;
   import com.dchoc.game.model.world.item.states.WorldItemObjectState;
   import com.dchoc.game.services.GameMetrics;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import esparragon.utils.EUtils;
   
   public class WorldItemObjectController extends DCComponent
   {
      
      private static const MODE_NONE:int = -1;
      
      private static const MODE_OWNER:int = 0;
      
      private static const MODE_VISITOR:int = 1;
      
      public static const CLIENT_STATES_BUILDING_PLACED_ID:int = 0;
      
      public static const CLIENT_STATES_LABOUR_WAITING_FOR_DROID_ID:int = 1;
      
      public static const CLIENT_STATES_BUILDING_ID:int = 2;
      
      public static const CLIENT_STATES_BUILDING_END_ID:int = 3;
      
      public static const CLIENT_STATES_RENT_WAITING_ID:int = 4;
      
      public static const CLIENT_STATES_RENT_READY_ID:int = 5;
      
      public static const CLIENT_STATES_RENT_COLLECTING_ID:int = 6;
      
      public static const CLIENT_STATES_DEMOLITION_START_ID:int = 7;
      
      public static const CLIENT_STATES_DEMOLITION_END_ID:int = 8;
      
      public static const CLIENT_STATES_EMPTY_ID:int = 9;
      
      public static const CLIENT_STATES_SHIPYARD_RUNNING_EMPTY_ID:int = 10;
      
      public static const CLIENT_STATES_SHIPYARD_RUNNING_WORKING_ID:int = 11;
      
      public static const CLIENT_STATES_SHIPYARD_PAUSED_ID:int = 12;
      
      public static const CLIENT_STATES_UPGRADEABLE_RUNNING_ID:int = 14;
      
      public static const CLIENT_STATES_DEFENSE_ID:int = 15;
      
      public static const CLIENT_STATES_SHIPYARD_LAUNCHING_SHIP_ID:int = 13;
      
      public static const CLIENT_STATES_UPGRADING_ID:int = 16;
      
      public static const CLIENT_STATES_REPAIRING_ID:int = 22;
      
      public static const CLIENT_STATES_BUILT_PASSIVE_ID:int = 17;
      
      public static const CLIENT_STATES_BROKEN_ID:int = 18;
      
      public static const CLIENT_STATES_HANGAR_RUNNING_ID:int = 19;
      
      public static const CLIENT_STATES_BUNKER_RUNNING_ID:int = 20;
      
      public static const CLIENT_STATES_LABS_RUNNING_ID:int = 21;
      
      public static const CLIENT_STATES_REFINERY_RUNNING_ID:int = 32;
      
      public static const CLIENT_STATES_OBSERVATORY_RUNNING_ID:int = 30;
      
      public static const CLIENT_STATES_EMBASSY_RUNNING_ID:int = 33;
      
      public static const CLIENT_STATES_FOR_TOOL_PLACE_ID:int = 23;
      
      public static const CLIENT_STATES_PASSIVE_GLOW_ID:int = 24;
      
      public static const CLIENT_STATES_EMPTY_ITEM_ORIENTED_ID:int = 25;
      
      public static const CLIENT_STATES_COUNT:int = 34;
      
      public static const CLIENT_STATES_HQ_RUNNING_ID:int = 26;
      
      public static const CLIENT_STATES_VISIT_FRIEND_ID:int = 27;
      
      public static const CLIENT_STATES_VISIT_FRIEND_HELPED_ID:int = 28;
      
      public static const CLIENT_STATES_JAIL_OPENING_ID:int = 29;
      
      public static const CLIENT_STATES_SILO_RUNNING_ID:int = 31;
      
      private static const LABOUR_NONE_ID:int = -1;
      
      private static const LABOUR_BUILD_ID:int = 0;
      
      private static const LABOUR_UPGRADE_ID:int = 1;
      
      private static const LABOUR_DEMOLISH_ID:int = 2;
      
      private static const MODE_BUILD_END:int = 0;
      
      private static const MODE_UPGRADE_END:int = 1;
      
      private static const MODE_UPGRADE_PREMIUM:int = 2;
      
      private static const MODE_UPGRADE_FROM_SOCIAL_ITEM:int = 3;
       
      
      private var mMode:int = -1;
      
      private var mActionsUICatalog:Vector.<ActionUI>;
      
      private var mStatesCatalog:Vector.<WorldItemObjectState>;
      
      private var mStatesActionUIBack:Array;
      
      public function WorldItemObjectController()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.actionsUILoad();
            this.statesLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.actionsUIUnload();
         this.statesUnload();
      }
      
      override protected function endDo() : void
      {
         this.mMode = -1;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         this.actionsUILogicUpdate(dt);
      }
      
      private function actionsUILoad() : void
      {
         this.mActionsUICatalog = new Vector.<ActionUI>(27);
         var guiController:GUIController = InstanceMng.getGUIControllerPlanet();
         var target:DCComponent = InstanceMng.getGUIControllerPlanet();
         var eventType:int = 1;
         this.mActionsUICatalog[0] = new ActionUI(0,21);
         this.mActionsUICatalog[1] = new PlaceItemActionUI(1,-1);
         this.mActionsUICatalog[4] = new ActionUI(4,1,target,guiController.createNotifyEvent(eventType,"NOTIFY_MODIFY_CURRENT_DROID_TASK",this),"TooltipWIOWaitingForDroid");
         this.mActionsUICatalog[5] = new ActionUI(5,1,target,guiController.createNotifyEvent(eventType,"NOTIFY_MODIFY_CURRENT_DROID_TASK",this),"TooltipWIOWaitingForDroid");
         this.mActionsUICatalog[7] = new DemolishActionUI(7,0,target,guiController.createNotifyEvent(eventType,"WIOEventDemolitionStart",this));
         this.mActionsUICatalog[9] = new ActionUI(9,8,target,guiController.createNotifyEvent(eventType,"WIOEventUpgradeStart",this),"TooltipWIOBuilt");
         this.mActionsUICatalog[3] = new ActionUI(3,1,target,guiController.createNotifyEvent(eventType,"NOTIFY_MODIFY_CURRENT_DROID_TASK",this),"TooltipWIOConstructing");
         this.mActionsUICatalog[2] = new ActionUI(2,1,target,guiController.createNotifyEvent(eventType,"NOTIFY_MODIFY_CURRENT_DROID_TASK",this),"TooltipWIOConstructing");
         this.mActionsUICatalog[11] = new CollectRentActionUI(11,target,guiController.createNotifyEvent(eventType,"WIORentWaitingEnd",this,null,"Instant"));
         this.mActionsUICatalog[25] = new ActionUI(25);
         this.mActionsUICatalog[12] = new InteractShipyardActionUI(12,target,guiController.createNotifyEvent(null,"NOTIFY_INTERACTSHIPYARD",this),"TooltipWIOBuilt");
         this.mActionsUICatalog[19] = new ActionUI(19,-1,null,null,"TooltipWIOBuilt");
         this.mActionsUICatalog[13] = new ActionUI(13,-1,null,null,"TooltipWIOBuilt");
         this.mActionsUICatalog[6] = new WaitingForDroidActionUI(6,1,target,guiController.createNotifyEvent(eventType,"NOTIFY_MODIFY_CURRENT_DROID_TASK",this),"TooltipWIOWaitingForDroid");
         this.mActionsUICatalog[14] = new ActionUI(14,11,guiController,guiController.createNotifyEvent(eventType,"NotifyHangarInfo",this),"TooltipWIOBuilt");
         this.mActionsUICatalog[15] = new ActionUI(15,12,guiController,guiController.createNotifyEvent(eventType,"NOTIFY_POPUP_OPEN_BUNKER",this),"TooltipWIOBuilt");
         var openLabEvent:Object = guiController.createNotifyEvent(eventType,"NOTIFY_POPUP_OPEN_LABS",guiController);
         this.mActionsUICatalog[16] = new ActionUI(16,13,guiController,openLabEvent,"TooltipWIOBuilt");
         this.mActionsUICatalog[17] = new ActionUI(17,20,guiController,guiController.createNotifyEvent(eventType,"NOTIFY_POPUP_OPEN_PVP_MAP",guiController),"TooltipWIOBuilt");
         var openRefineryEvent:Object = guiController.createNotifyEvent(eventType,"NOTIFY_POPUP_OPEN_REFINERY",guiController);
         this.mActionsUICatalog[23] = new ActionUI(23,1,guiController,openRefineryEvent,"TooltipWIOBuilt");
         this.mActionsUICatalog[24] = new ActionUI(24,12,guiController,guiController.createNotifyEvent(eventType,"NOTIFY_POPUP_OPEN_EMBASSY",guiController),"TooltipWIOBuilt");
         this.mActionsUICatalog[8] = new ActionUI(8,-1,target,null,"TooltipWIORepairing",true,true);
         this.mActionsUICatalog[21] = new ActionUI(21,17,InstanceMng.getGUIController(),InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_DROIDS_BUY",InstanceMng.getGUIController()),"TooltipWIOBuilt");
         this.mActionsUICatalog[18] = new ActionUI(18,14,target,guiController.createNotifyEvent(eventType,"WIOEventVisitFriendHelped",this),"TooltipWIOBuilt");
         this.mActionsUICatalog[22] = new CollectRentActionUI(22,target,null,true);
      }
      
      private function actionsUIUnload() : void
      {
         this.mActionsUICatalog = null;
      }
      
      public function actionsUIGetAction(id:int) : ActionUI
      {
         return this.mActionsUICatalog[id];
      }
      
      public function actionsUIGetPreferredAction(actionId1:int, actionId2:int) : ActionUI
      {
         var actionPreferredId:int = actionId1 < actionId2 ? actionId1 : actionId2;
         return this.mActionsUICatalog[actionPreferredId];
      }
      
      private function actionsUICheckId(actionId:int) : Boolean
      {
         return actionId > 0 && actionId < this.mActionsUICatalog.length;
      }
      
      private function actionsUILogicUpdate(dt:int) : void
      {
         var action:ActionUI = null;
         for each(action in this.mActionsUICatalog)
         {
            if(action != null)
            {
               action.logicUpdate(dt);
            }
         }
      }
      
      private function statesLoad() : void
      {
         this.mStatesCatalog = new Vector.<WorldItemObjectState>(34);
         this.mStatesCatalog[0] = new BuildingPlacedState(0);
         this.mStatesCatalog[2] = new BuildingState(2,"WIOEventBuildingEnd",2);
         this.mStatesCatalog[16] = new BuildingState(2,"WIOEventUpgradingEnd",3);
         this.mStatesCatalog[3] = new WaitingForUIState(3,"WIOEventBuildingEndEnd",0,25,1,10,0);
         this.mStatesCatalog[4] = new RentWaitingState(4);
         this.mStatesCatalog[5] = new RentReadyState(5);
         this.mStatesCatalog[6] = new RentCollectingState(6);
         this.mStatesCatalog[7] = new WaitingForUIState(7,"WIOEventDemolitionEnd",3000,25,-2,-1,-1,23);
         this.mStatesCatalog[8] = new WaitingForUIState(8,"WIOEventDemolitionEndEnd",0,25,-2,17,0);
         this.mStatesCatalog[9] = new WorldItemObjectState(9,null,0,25,1);
         this.mStatesCatalog[10] = new ShipyardState(10,null,0,12,1);
         this.mStatesCatalog[11] = new ShipyardState(11,null,0,12,1,18);
         this.mStatesCatalog[12] = new ShipyardState(12,null,0,12,1,20);
         this.mStatesCatalog[13] = new ShipyardState(13,"WIOEventShipyardLaunchShipEnd",1000,25,1);
         this.mStatesCatalog[14] = new WorldItemObjectState(14,null,0,9,1);
         this.mStatesCatalog[15] = new WorldItemObjectState(24,null,0,19,1);
         this.mStatesCatalog[17] = new WorldItemObjectState(17,null,0,9,1);
         this.mStatesCatalog[1] = new WaitingForDroidState(1);
         this.mStatesCatalog[18] = new WorldItemObjectState(18,null,0,25,1);
         this.mStatesCatalog[19] = new WorldItemObjectState(19,null,0,14,1);
         this.mStatesCatalog[20] = new WorldItemObjectState(20,null,0,15,1);
         this.mStatesCatalog[21] = new LaboratoryState(21,null,0,16,1);
         this.mStatesCatalog[32] = new RefineryState(32,null,0,23,1);
         this.mStatesCatalog[30] = new WorldItemObjectState(30,null,0,9,1);
         this.mStatesCatalog[33] = new WorldItemObjectState(33,null,0,24,1);
         this.mStatesCatalog[22] = new WorldItemObjectState(22,null,0,8,1);
         this.mStatesCatalog[23] = new WorldItemObjectState(23,null,0,25,1);
         this.mStatesCatalog[24] = new WorldItemObjectState(24,null,0,19,1);
         this.mStatesCatalog[25] = new ItemOrientedState(25,null,0,25);
         this.mStatesCatalog[26] = new WorldItemObjectState(26,null,0,21,1);
         this.mStatesCatalog[27] = new WorldItemObjectState(27,null,0,18,-2,28);
         this.mStatesCatalog[28] = new WaitingForUIState(28,"WIOEventVisitFriendHelpedEnd",0,-1,-2,29,0);
         this.mStatesCatalog[29] = new WaitingForUIState(29,null,0,-1,30,-1,0);
         this.mStatesCatalog[31] = new WorldItemObjectState(31,null,0,22,1);
         this.mStatesActionUIBack = [];
      }
      
      private function statesUnload() : void
      {
         var state:WorldItemObjectState = null;
         if(this.mStatesCatalog != null)
         {
            for each(state in this.mStatesCatalog)
            {
               state.unload();
            }
            this.mStatesCatalog = null;
            this.mStatesActionUIBack = null;
         }
      }
      
      private function statesSetDefaultConf(stateId:int) : void
      {
         var actionUIBack:ActionUI = this.mStatesActionUIBack[stateId];
         var state:WorldItemObjectState = this.mStatesCatalog[stateId];
         if(actionUIBack != null)
         {
            state.setCountdownEnabled(true);
            state.setActionUIId(actionUIBack.getActionId(null));
         }
      }
      
      private function statesSetTutorialConf(stateId:int) : void
      {
         var state:WorldItemObjectState = this.mStatesCatalog[stateId];
         if(this.mStatesActionUIBack[stateId] == null)
         {
            this.mStatesActionUIBack[stateId] = state.getActionUI();
         }
         switch(stateId - 2)
         {
            case 0:
               break;
            default:
               state.setActionUIId(25);
         }
         state.setCountdownEnabled(false);
      }
      
      public function statesSetDefaultBuilding() : void
      {
         this.statesSetDefaultConf(2);
      }
      
      public function statesSetTutorialBuilding() : void
      {
         this.statesSetTutorialConf(2);
      }
      
      public function getItemXmlForToolPlace(def:WorldItemDef) : XML
      {
         var stateId:int = 1;
         var modeId:int = -1;
         var tileRelativeX:int = 0;
         var tileRelativeY:int = 0;
         var itemStr:* = "<Item sku=\"" + def.getSku() + "\" state=\"" + stateId + "\" mode=\"" + modeId + "\" x=\"" + tileRelativeX + "\" y=\"" + tileRelativeY + "\"/>";
         return EUtils.stringToXML(itemStr);
      }
      
      public function getItemXmlAfterUsingToolPlace(def:WorldItemDef, tileX:int, tileY:int) : XML
      {
         var stateId:int = def.hasBuildingProcess() ? 0 : 1;
         var modeId:int = 0;
         var tileRelativeX:int = InstanceMng.getMapControllerPlanet().getTileToTileRelativeX(tileX);
         var tileRelativeY:int = InstanceMng.getMapControllerPlanet().getTileToTileRelativeY(tileY);
         var itemStr:* = "<Item sku=\"" + def.getSku() + "\" sid=\"" + InstanceMng.getWorld().itemsGetNextSid() + "\" reset=\"1\" state=\"" + stateId + "\" mode=\"" + modeId + "\"x=\"" + tileRelativeX + "\" y=\"" + tileRelativeY + "\" time=\"" + def.getConstructionTime() + "\"/>";
         return EUtils.stringToXML(itemStr);
      }
      
      private function getClientStateId(item:WorldItemObject, askForDroids:Boolean = false) : int
      {
         var typeId:int = 0;
         var roleId:int = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
         if(this.mMode == -1)
         {
            this.mMode = roleId == 0 || roleId == 5 ? 0 : 1;
         }
         var clientStateId:int = 9;
         if(this.mMode == 0)
         {
            if(item.getIsForToolPlace())
            {
               return 23;
            }
            switch(item.mServerStateId)
            {
               case 0:
                  if(item.mServerModeId == 1)
                  {
                     if(askForDroids)
                     {
                        item.mDroidLabourId = 0;
                        InstanceMng.getTrafficMng().droidsLockDroid(item,false);
                     }
                     clientStateId = 2;
                  }
                  else
                  {
                     clientStateId = 0;
                  }
                  break;
               case 1:
                  if(item.mServerModeId > -1)
                  {
                     switch(typeId = item.mDef.getTypeId())
                     {
                        case 0:
                        case 1:
                           clientStateId = 4;
                           break;
                        case 2:
                           clientStateId = 31;
                           break;
                        case 3:
                           clientStateId = 10;
                           if(InstanceMng.getShipyardController().getShipyard(item.mSid).isProductionPaused())
                           {
                              clientStateId = 12;
                           }
                           else if(InstanceMng.getShipyardController().getProducingElementSku(item.mSid) != null)
                           {
                              clientStateId = 11;
                           }
                           break;
                        case 4:
                        case 12:
                           clientStateId = 24;
                           break;
                        case 5:
                           if(item.mDef.isHeadQuarters())
                           {
                              clientStateId = 26;
                           }
                           break;
                        case 6:
                           clientStateId = 15;
                           break;
                        case 7:
                           clientStateId = 19;
                           break;
                        case 8:
                           clientStateId = 20;
                           break;
                        case 9:
                           if(item.mDef.isAnEmbassy())
                           {
                              clientStateId = 33;
                           }
                           else if(item.mDef.isAnObservatory())
                           {
                              clientStateId = 30;
                           }
                           else if(item.mDef.isALaboratory())
                           {
                              clientStateId = 21;
                           }
                           else
                           {
                              if(!item.mDef.isARefinery())
                              {
                                 throw "Invalid state!";
                              }
                              clientStateId = 32;
                           }
                           break;
                        default:
                           clientStateId = 9;
                     }
                  }
                  break;
               case 2:
                  if(askForDroids)
                  {
                     item.mDroidLabourId = 1;
                     InstanceMng.getTrafficMng().droidsLockDroid(item,false);
                  }
                  clientStateId = 16;
            }
            if(item.needsRepairs())
            {
               if(item.isRepairing())
               {
                  clientStateId = 22;
               }
               clientStateId = 18;
            }
         }
         else
         {
            if(item.isBroken())
            {
               return 18;
            }
            switch(item.mServerStateId)
            {
               case 0:
               case 2:
                  clientStateId = 25;
                  break;
               case 1:
                  if(item.mDef.getTypeId() != 6)
                  {
                     if(item.mDef.getTypeId() == 8 && item.mDef.isAWarpBunker() && roleId == 1)
                     {
                        clientStateId = 20;
                     }
                  }
            }
         }
         return clientStateId;
      }
      
      public function buildItem(item:WorldItemObject, resetState:Boolean = false, askForDroid:Boolean = true) : void
      {
         var clientStateId:int = this.getClientStateId(item,askForDroid);
         item.setState(this.mStatesCatalog[clientStateId],resetState);
      }
      
      public function setItemClientState(item:WorldItemObject, clientStateId:int, resetState:Boolean = false) : void
      {
         item.setState(this.mStatesCatalog[clientStateId],resetState);
      }
      
      public function itemIsActive(item:WorldItemObject) : Boolean
      {
         return this.serverStateIsActive(item.mServerStateId);
      }
      
      private function serverStateIsActive(state:int) : Boolean
      {
         return state == 1 || state == 2;
      }
      
      public function changeServerState(item:WorldItemObject, doRegister:Boolean, serverStateId:int, serverModeId:int) : void
      {
         var prevIsActive:Boolean = false;
         var isActive:Boolean = false;
         var wasReadyForBattle:Boolean = false;
         var isReadyForBattle:Boolean = false;
         if(item.mServerStateId == serverStateId && item.mServerModeId == serverModeId || item.getIsForToolPlace())
         {
            return;
         }
         InstanceMng.getWorld().itemsAmountSubtractItem(item);
         if(doRegister)
         {
            prevIsActive = this.serverStateIsActive(item.mServerStateId);
         }
         item.mServerStateId = serverStateId;
         item.mServerModeId = serverModeId;
         InstanceMng.getWorld().itemsAmountAddItem(item);
         if(doRegister)
         {
            isActive = this.serverStateIsActive(serverStateId);
            if(prevIsActive != isActive)
            {
               if(isActive)
               {
                  InstanceMng.getWorld().itemsRegisterItem(item);
               }
               else
               {
                  InstanceMng.getWorld().itemsUnregisterItem(item);
               }
            }
         }
         if(InstanceMng.getUnitScene().battleIsEnabled())
         {
            wasReadyForBattle = item.mUnit != null && !item.mUnit.mSecureIsAboutToExitScene.value;
            isReadyForBattle = this.wioIsReadyForBattle(item);
            if(!wasReadyForBattle && isReadyForBattle)
            {
               InstanceMng.getUnitScene().addItem(item);
            }
            else if(wasReadyForBattle && !isReadyForBattle)
            {
               InstanceMng.getUnitScene().removeItem(item,true);
            }
         }
      }
      
      private function wioIsReadyForBattle(item:WorldItemObject) : Boolean
      {
         var returnValue:Boolean = item.mDef.needsAnUnit() && item.mServerStateId != 0;
         if(returnValue && item.canBeBroken())
         {
            returnValue = item.getEnergyPercent() > 0 || InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 1 || InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 2;
         }
         return returnValue;
      }
      
      public function labourIsWaitingForDroid(item:WorldItemObject) : Boolean
      {
         return item.mState.mStateId == 1;
      }
      
      public function labourGetId(item:WorldItemObject) : int
      {
         return item.mDroidLabourId;
      }
      
      public function labourSetDone(item:WorldItemObject) : void
      {
         var stateId:int = 0;
         var typeId:int = this.labourGetId(item);
         switch(typeId)
         {
            case 0:
            case 1:
               stateId = typeId == 0 ? 2 : 16;
               item.setState(this.mStatesCatalog[stateId],true);
               break;
            case 2:
               this.notifyItem({
                  "cmd":"WIOEventDemolitionStart",
                  "source":"labourSetDone"
               },item);
         }
      }
      
      private function notifyItem(e:Object, item:WorldItemObject) : Boolean
      {
         var doTransaction:Boolean = false;
         var productType:String = null;
         var quantity:Number = NaN;
         var hasUnit:* = false;
         var stateId:int = 0;
         var transaction:Transaction = null;
         var clientDebugInfo:String = null;
         var clickOnBuildingOk:Boolean = false;
         var needsToSpawnDroid:* = false;
         var labourId:int = 0;
         var incomeCurrencyId:int = 0;
         var incomeAmountLeftToCollect:Number = NaN;
         var totalTime:Number = NaN;
         var rentingTime:Number = NaN;
         var firstTime:* = false;
         var notifyServer:Boolean = false;
         var hangar:Hangar = null;
         var waitTime:Boolean = false;
         var levelsToUpgrade:int = 0;
         var returnValue:Boolean = true;
         var cancel:Boolean = e.cancel != null ? Boolean(e.cancel) : false;
         var currentServerStateId:int = -1;
         if(item != null)
         {
            currentServerStateId = item.mServerStateId;
         }
         switch(e.cmd)
         {
            case "WIOEventBuildingPlaced":
               item.setState(this.mStatesCatalog[0],true);
               break;
            case "WIOEventDroidRequested":
               if(needsToSpawnDroid = !item.mDef.isAWall())
               {
                  InstanceMng.getTrafficMng().droidsLockDroid(item,needsToSpawnDroid);
                  item.setState(this.mStatesCatalog[1],true);
               }
               else
               {
                  e.cmd = "WIOEventWaitingForDroidEnd";
                  this.notifyItem(e,item);
               }
               break;
            case "WIOEventWaitingForDroidEnd":
               labourId = this.labourGetId(item);
               InstanceMng.getTargetMng().updateProgress("droidHasArrived",1);
               if(labourId != -1)
               {
                  this.labourSetDone(item);
               }
               break;
            case "WIOEventBuildingEnd":
               this.notifyBuildUpgradeEvent(item,0,false,true);
               break;
            case "WIOEventInstantBuild":
               this.notifyBuildUpgradeEvent(item,0,true,true);
               break;
            case "WIOEventUpgradingEnd":
               doTransaction = true;
               if(e.hasOwnProperty("doTransaction"))
               {
                  doTransaction = Boolean(e.doTransaction);
               }
               this.notifyBuildUpgradeEvent(item,1,false,doTransaction);
               break;
            case "WIOEventInstantUpgrade":
               if(item.mServerStateId == 2)
               {
                  this.notifyBuildUpgradeEvent(item,1,true,true);
               }
               break;
            case "WIOEventCancelUpgrade":
               this.changeServerState(item,true,1,0);
               if(item.mDef.isAShipyard())
               {
                  InstanceMng.getShipyardController().resumeShipyard(item.mSid);
               }
               this.buildItem(item,true);
               InstanceMng.getTrafficMng().droidsReturnDroidToHQ(item);
               item.mDroidLabourId = -1;
               InstanceMng.getUserDataMng().updateItem_cancelUpgrade(int(item.mSid),item.mDef.getIncomeTime(),item.getTransaction());
               item.setTransaction(null);
               break;
            case "WIOEventCancelBuild":
               InstanceMng.getUserDataMng().updateItem_cancelBuild(int(item.mSid),item.getTransaction());
               item.setTransaction(null);
               this.notifyItem({
                  "cmd":"WIOEventDemolitionEndEnd",
                  "cancel":true
               },item);
               break;
            case "WIOEventBuildingEndEnd":
               this.buildItem(item,true);
               if(InstanceMng.getToolsMng().getCurrentTool().isSelectionMade())
               {
                  item.viewLayersTypeRequiredSet(4,26);
               }
               break;
            case "NOTIFY_SHOP_BUY":
               transaction = e.transactionFB != null ? e.transactionFB : e.transaction;
               InstanceMng.getGUIControllerPlanet().shopBuy(e.itemDef.mSku,transaction);
               break;
            case "WIORentWaitingEnd":
               if(e.param == "Instant")
               {
                  if(item.mState.mStateId == 5 || item.mState.mStateId == 4)
                  {
                     if((transaction = InstanceMng.getRuleMng().getTransactionPack(e)).performAllTransactions())
                     {
                        item.setState(this.mStatesCatalog[6],true);
                        incomeCurrencyId = item.mDef.getIncomeCurrencyId();
                        incomeAmountLeftToCollect = 0;
                        if(transaction.mDifferenceMinerals.value > 0 && incomeCurrencyId == 2)
                        {
                           incomeAmountLeftToCollect = transaction.mDifferenceMinerals.value;
                        }
                        if(transaction.mDifferenceCoins.value > 0 && incomeCurrencyId == 1)
                        {
                           incomeAmountLeftToCollect = transaction.mDifferenceCoins.value;
                        }
                        item.setIncomeAmountLeftToCollect(incomeAmountLeftToCollect);
                        InstanceMng.getUnitScene().shipsSendShipCarry(item.mDef.getIncomeCurrencyId(),item,InstanceMng.getMapModel().mAstarStartItem);
                        InstanceMng.getTargetMng().updateProgress("collect",transaction.getTransCoins(),"coins");
                        InstanceMng.getTargetMng().updateProgress("collect",transaction.getTransMinerals(),"minerals");
                        if(Config.USE_METRICS)
                        {
                           productType = "Coins";
                           quantity = transaction.getTransCoins();
                           if(item.mDef.getIncomeCurrencyId() == 2)
                           {
                              productType = "Minerals";
                              quantity = transaction.getTransMinerals();
                           }
                           DCMetrics.sendMetric("Earn GC","Collecting Rents",productType,null,{
                              "p2":GameMetrics.getNumColonies(),
                              "p3":GameMetrics.getHQLevel()
                           },quantity);
                        }
                        if(item.mDef.getIncomeCurrencyId() == 1)
                        {
                           if(this.checkCollectingAmount(item.mDef,transaction.getTransCoins()))
                           {
                              InstanceMng.getItemsMng().getCollectionItemsParticleByAction(item.mDef.mSku,"collectCoins",item.mViewCenterWorldX,item.mViewCenterWorldY,item.mUpgradeId);
                           }
                        }
                        else if(item.mDef.getIncomeCurrencyId() == 2)
                        {
                           if(this.checkCollectingAmount(item.mDef,transaction.getTransMinerals()))
                           {
                              InstanceMng.getItemsMng().getCollectionItemsParticleByAction(item.mDef.mSku,"collectMinerals",item.mViewCenterWorldX,item.mViewCenterWorldY,item.mUpgradeId);
                           }
                        }
                        if(Config.USE_SOUNDS)
                        {
                           if(item.mDef.getIncomeCurrencyId() == 1)
                           {
                              SoundManager.getInstance().playSound("collect_coin.mp3");
                           }
                           else if(item.mDef.getIncomeCurrencyId() == 2)
                           {
                              SoundManager.getInstance().playSound("collect_mineral.mp3");
                           }
                        }
                        rentingTime = (totalTime = item.mDef.getIncomeTime()) - item.mTime.value;
                        if(transaction != null)
                        {
                           clientDebugInfo = "newState in collect rent sku = " + item.mDef.mSku + " currentServerStateId = " + currentServerStateId + " upgradeId = " + item.mDef.getUpgradeId() + " currentStateId = " + item.mState.mStateId + " toClientStateId = " + this.getClientStateId(item) + " rentingTime = " + rentingTime + " totalTime = " + totalTime + " incomeLeftToCollect = " + item.getIncomeAmountLeftToCollect() + " HISTORIC = " + item.getCommandStringForServer();
                           transaction.setClientDebugInfo(clientDebugInfo);
                        }
                        InstanceMng.getUserDataMng().updateItem_newState(int(item.mSid),currentServerStateId,item.mServerStateId,item.mServerModeId,totalTime,rentingTime,item.hasCollectionBonus(),item.getIncomeAmountLeftToCollect(),transaction);
                        if(item.hasCollectionBonus())
                        {
                           item.setHasCollectionBonus(false);
                        }
                     }
                  }
               }
               else
               {
                  item.setState(this.mStatesCatalog[5],true);
               }
               break;
            case "WIORentCollectingEnd":
               item.setState(this.mStatesCatalog[4],true);
               break;
            case "WIOEventDemolitionStart":
               if(item.decorationIsBeingRidden())
               {
                  InstanceMng.getTrafficMng().civilsForceDismount(item);
               }
               item.viewSetPowerUp(false);
               if((firstTime = item.mState.mStateId != 1) && item.mDef.requiresDroidToBeDemolished())
               {
                  item.mDroidLabourId = 2;
                  this.notifyItem({"cmd":"WIOEventDroidRequested"},item);
               }
               else
               {
                  stateId = item.mDef.hasDemolitionProgressBar() ? 7 : 8;
                  item.setState(this.mStatesCatalog[stateId],true);
               }
               if(firstTime)
               {
                  item.setTransaction(e.transaction);
               }
               break;
            case "WIOEventDemolitionEnd":
               (transaction = InstanceMng.getRuleMng().getTransactionDemolishEnd(item.mDef,null)).setWorldItemObject(item);
               transaction.performAllTransactions();
               InstanceMng.getUserDataMng().updateItem_destroy(int(item.mSid),transaction);
               item.setState(this.mStatesCatalog[8],true);
               InstanceMng.getItemsMng().getCollectionItemsParticleByAction(item.mDef.mSku,"recycle",item.mViewCenterWorldX,item.mViewCenterWorldY,item.mUpgradeId);
               this.endDemolitionItem(item);
               break;
            case "WIOEventDemolitionEndEnd":
               item.viewSetPowerUp(false);
               notifyServer = false;
               if(!cancel)
               {
                  if((transaction = item.getTransaction()) != null && transaction.getTransactionLog() == null)
                  {
                     transaction.setWorldItemObject(item);
                     transaction.performAllTransactions();
                     notifyServer = true;
                  }
                  InstanceMng.getTargetMng().updateProgress("recycle",1,item.mDef.mSku);
               }
               InstanceMng.getWorld().itemsUnplaceItem(item,notifyServer);
               if(!item.mDef.hasDemolitionProgressBar() || cancel)
               {
                  this.endDemolitionItem(item);
               }
               break;
            case "WIOEventShipyardBuildShipStart":
               item.setState(this.mStatesCatalog[11],true);
               break;
            case "WIOEventShipyardBuildNoShips":
               if(item.mState.mStateId == 11 || item.mState.mStateId == 12)
               {
                  item.setState(this.mStatesCatalog[10],true);
               }
               break;
            case "WIOEventShipyardLaunchShipStart":
               item.setState(this.mStatesCatalog[13],true);
               hangar = e.nearestAvailableHangar;
               if(!InstanceMng.getBuildingsBufferController().isBufferOpen() && hangar != null && hangar.getWIO() != null && hangar.getWIO().mUnit != null)
               {
                  if(e.travelFromShipyardToHangar == null || e.travelFromShipyardToHangar)
                  {
                     waitTime = e.waitTime != null && e.waitTime;
                     InstanceMng.getUnitScene().shipsSendShipWarToHangar(e.shipSku,item,hangar.getWIO(),hangar.latestShipParkedInside(),waitTime);
                  }
                  else
                  {
                     InstanceMng.getUnitScene().shipsPlaceShipWarOnHangar(e.shipSku,hangar.getWIO());
                  }
               }
               break;
            case "WIOEventShipyardLaunchShipEnd":
               stateId = InstanceMng.getShipyardController().isShipyardEmpty(item.mSid) ? 10 : 11;
               item.setState(this.mStatesCatalog[stateId],true);
               break;
            case "WIOEventShipyardLaunchShipPause":
               item.setState(this.mStatesCatalog[12],true);
               break;
            case "WIOEventUpgradePremium":
               levelsToUpgrade = 1;
               if(e.levelsToUpgrade != null)
               {
                  levelsToUpgrade = int(e.levelsToUpgrade);
               }
               this.notifyBuildUpgradeEvent(item,2,false,true,levelsToUpgrade);
               break;
            case "WIOEventUpgradeStart":
               if(item.isAllowedToStartUpgrading())
               {
                  item.calculateIncomeToRestore();
                  this.changeServerState(item,true,2,0);
                  if(e.transaction != null)
                  {
                     clientDebugInfo = "newState in upgrade start sku = " + item.mDef.mSku + " currentServerStateId = " + currentServerStateId + " upgradeId = " + item.mDef.getUpgradeId() + " currentClientStateId = " + item.mState.mStateId + " toClientStateId = " + this.getClientStateId(item) + " time = " + InstanceMng.getRuleMng().getConstructionTime(item) + " HISTORIC = " + item.getCommandStringForServer();
                     e.transaction.setClientDebugInfo(clientDebugInfo);
                  }
                  item.mDroidLabourId = 1;
                  if(e.items)
                  {
                     e.item = item;
                  }
                  this.notify({
                     "item":e.item,
                     "doTransaction":true,
                     "cmd":(e.item.mDef.isAWall() || e.item.mDef.isAMine() ? "WIOEventUpgradingEnd" : "WIOEventDroidRequested")
                  });
                  if(!(e.item.mDef.isAWall() || e.item.mDef.isAMine()))
                  {
                     InstanceMng.getUserDataMng().updateItem_newState(int(item.mSid),currentServerStateId,item.mServerStateId,item.mServerModeId,InstanceMng.getRuleMng().getConstructionTime(item),0,false,item.getIncomeToRestore(),e.transaction);
                     if(item.mDef.isAShipyard())
                     {
                        InstanceMng.getShipyardController().pauseShipyard(item.mSid);
                     }
                  }
               }
               break;
            case "WIOEventBreak":
               break;
            case "WIOEventRepairStart":
               item.setState(this.mStatesCatalog[22]);
               if(!item.mHasStartedRepairing)
               {
                  item.mHasStartedRepairing = true;
               }
               break;
            case "WIOEventRepairEnd":
               this.instantRepairItem(item,e);
               break;
            case "WIOEventVisitFriend":
               hasUnit = item.mUnit != null;
               if(!item.mDef.isAWall() && hasUnit)
               {
                  if(item.mUnit.getEnergyPercent() >= 100)
                  {
                     item.setState(this.mStatesCatalog[27]);
                  }
               }
               else if(!item.mDef.isAWall() && !item.isBroken())
               {
                  item.setState(this.mStatesCatalog[27]);
               }
               break;
            case "WIOEventVisitFriendHelped":
               if(clickOnBuildingOk = InstanceMng.getVisitorMng().onClickBuilding(item))
               {
                  item.setState(this.mStatesCatalog[28]);
               }
               break;
            case "WIOEventVisitFriendHelpedEnd":
               this.buildItem(item);
               break;
            case "WioEventFriendHelped":
               item.viewAnimStoppingStatePlay(5,10);
               break;
            default:
               returnValue = false;
         }
         if(item != null && e != null)
         {
            item.addHistoryEvent(e.cmd);
         }
         return returnValue;
      }
      
      public function notifyItems(e:Object, items:Vector.<WorldItemObject>) : Boolean
      {
         var newUpgradeId:int = 0;
         var nextDef:WorldItemDef = null;
         var currentServerStateId:int = 0;
         var cmd:String = null;
         var itemObj:Object = null;
         var itemsToServer:Array = [];
         var transaction:Transaction = e.transaction;
         var item:WorldItemObject = e.item;
         var levelsToUpgrade:int = 1;
         switch(e.cmd)
         {
            case "WIOEventUpgradePremium":
               if(e.levelsToUpgrade != null)
               {
                  levelsToUpgrade = int(e.levelsToUpgrade);
               }
            case "WIOEventUpgradeStart":
               item.calculateIncomeToRestore();
               newUpgradeId = item.mDef.getUpgradeId() + 1;
               if(e.cmd == "WIOEventUpgradePremium")
               {
                  nextDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(item.mDef.mSku,newUpgradeId) as WorldItemDef;
                  transaction = InstanceMng.getRuleMng().getTransactionPremiumUpgradeRange(item.mDef,nextDef,item,true,items.length);
               }
               for each(item in items)
               {
                  if(item.isAllowedToStartUpgrading())
                  {
                     currentServerStateId = item.mServerStateId;
                     item.calculateIncomeToRestore();
                     this.changeServerState(item,true,2,0);
                     item.mDroidLabourId = 1;
                     if(e.items)
                     {
                        e.item = item;
                     }
                     if(e.cmd == "WIOEventUpgradePremium")
                     {
                        this.notifyBuildUpgradeEvent(item,2,false,false,levelsToUpgrade);
                     }
                     else
                     {
                        cmd = e.item.mDef.isAWall() || e.item.mDef.isAMine() ? "WIOEventUpgradingEnd" : "WIOEventDroidRequested";
                        this.notify({
                           "item":e.item,
                           "doTransaction":false,
                           "cmd":cmd
                        });
                     }
                     (itemObj = {})["sid"] = int(item.mSid);
                     itemObj["oldState"] = 2;
                     itemObj["newState"] = 1;
                     itemObj["time"] = InstanceMng.getRuleMng().getConstructionTime(item);
                     itemObj["timePassed"] = 0;
                     itemObj["incomeToRestore"] = item.getIncomeToRestore();
                     itemObj["hasBonus"] = false;
                     itemObj["upgradeId"] = item.mDef.getLevel() + levelsToUpgrade;
                     itemsToServer.push(itemObj);
                     if(item.mDef.isAShipyard())
                     {
                        InstanceMng.getShipyardController().pauseShipyard(item.mSid);
                     }
                  }
               }
               InstanceMng.getUserDataMng().updateItem_newStates(itemsToServer,transaction);
         }
         return true;
      }
      
      public function endDemolitionItem(item:WorldItemObject) : void
      {
         item.resume();
         InstanceMng.getTrafficMng().notify({
            "cmd":"unitEventITemDestroyed",
            "item":item
         });
      }
      
      private function instantRepairItem(item:WorldItemObject, e:Object) : void
      {
         var clientDebugInfo:String = null;
         item.repair();
         this.buildItem(item,false,false);
         var transaction:Transaction;
         if((transaction = item.getTransaction()) != null)
         {
            clientDebugInfo = "sku = " + item.mDef.mSku + " clientStateId = " + item.mState.mStateId + " serverStateId = " + item.mServerStateId + " mRepairTime = " + item.getRepairTime() + " mTime = " + item.mTime.value + " transTime = " + transaction.getTransTime();
            transaction.setClientDebugInfo(clientDebugInfo);
         }
         var isRepairAll:Boolean = e != null && e.repairAll != null;
         item.setTransaction(null);
      }
      
      public function pauseItems(items:Vector.<WorldItemObject>) : void
      {
         var item:WorldItemObject = null;
         if(items != null)
         {
            for each(item in items)
            {
               if(item != null)
               {
                  item.pause();
               }
            }
         }
      }
      
      public function resumeItems(items:Vector.<WorldItemObject>) : void
      {
         var item:WorldItemObject = null;
         if(items != null)
         {
            for each(item in items)
            {
               if(item != null)
               {
                  item.resume();
               }
            }
         }
      }
      
      private function notifyBuildUpgradeEvent(item:WorldItemObject, mode:int, instant:Boolean, doTransaction:Boolean, levelsToUpgrade:int = 1) : void
      {
         var i:int = 0;
         if(item.isBeingMoved() || InstanceMng.getBuildingsBufferController().isBufferOpen())
         {
            return;
         }
         var itemSku:String = null;
         var nextDef:WorldItemDef = null;
         var profileLogin:Profile = null;
         var uInfo:UserInfo = null;
         var currentPlanetId:String = null;
         var planet:Planet = null;
         var clientDebugInfo:String = null;
         var currentServerStateId:int = item.mServerStateId;
         var ruleMng:RuleMng = InstanceMng.getRuleMng();
         var newUpgradeId:int = item.mDef.getUpgradeId() + levelsToUpgrade;
         var transaction:Transaction = null;
         if(mode == 0)
         {
            if(instant)
            {
               itemSku = item.mDef.mSku;
               if(InstanceMng.getFlowStatePlanet().isTutorialRunning())
               {
                  itemSku = "tuto_defenses";
               }
               InstanceMng.getTargetMng().updateProgress("instantBuild",1,itemSku);
            }
            InstanceMng.getTargetMng().updateProgress("build",1,item.mDef.mSku);
            this.changeServerState(item,true,1,0);
            if(item.mDef.mTypeId == 6 && item.mUnit != null)
            {
               item.mUnit.setNeedsToSenseEnvironment(true);
            }
         }
         else
         {
            if(mode == 2 || mode == 3)
            {
               item.calculateIncomeToRestore();
               if(mode == 2)
               {
                  nextDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(item.mDef.mSku,newUpgradeId) as WorldItemDef;
                  transaction = InstanceMng.getRuleMng().getTransactionPremiumUpgradeRange(item.mDef,nextDef,item,true);
               }
            }
            InstanceMng.getWorld().itemsUpgradeItem(item,newUpgradeId);
            if(item.mDef.isHeadQuarters())
            {
               if((profileLogin = InstanceMng.getUserInfoMng().getProfileLogin()) != null)
               {
                  if((uInfo = profileLogin.getUserInfoObj()) != null)
                  {
                     currentPlanetId = profileLogin.getCurrentPlanetId();
                     if((planet = uInfo.getPlanetById(currentPlanetId)) != null)
                     {
                        planet.setHQLevel(item.mUpgradeId + 1);
                     }
                  }
               }
            }
         }
         var time:Number = item.mDef.isAResources() ? ruleMng.wioGetIncomeTimeLeft(item) : 0;
         if(mode != 2 && mode != 3)
         {
            if(instant)
            {
               transaction = item.getTransaction();
            }
            else
            {
               (transaction = ruleMng.getTransactionEndBuild(item)).performAllTransactions();
               if(item.mDef.isAWall() || item.mDef.isAMine())
               {
                  transaction.setTransCoins(item.getNextDef().getConstructionCoins() * -1);
                  transaction.setTransMinerals(item.getNextDef().getConstructionMineral() * -1);
                  for(i = 0; i < item.getNextDef().getNumUpgradeItemsNeeded(); )
                  {
                     transaction.addTransItem(item.getNextDef().getUpgradeItemsNeededSku(i),item.getNextDef().getUpgradeItemsNeededAmount(i) * -1);
                     i++;
                  }
               }
            }
         }
         if(transaction != null)
         {
            clientDebugInfo = "newState in build/upgrade  build = " + build + " instant = " + instant + " sku = " + item.mDef.mSku + " currentServerStateId = " + currentServerStateId + " upgrade id = " + item.mDef.getUpgradeId() + " client state Id = " + this.getClientStateId(item) + " serverStateId = " + item.mServerStateId + " time = " + time + " rulesTime = " + ruleMng.wioGetIncomeTimeLeft(item);
            transaction.setClientDebugInfo(clientDebugInfo);
         }
         if(mode != 3 && doTransaction)
         {
            if(mode == 2)
            {
               InstanceMng.getUserDataMng().updateItem_upgradePremium(int(item.mSid),newUpgradeId,time,item.getIncomeToRestore(),transaction);
            }
            else
            {
               InstanceMng.getUserDataMng().updateItem_newState(int(item.mSid),currentServerStateId,item.mServerStateId,item.mServerModeId,time,0,false,item.getIncomeToRestore(),transaction);
            }
         }
         item.setTransaction(null);
         if(mode != 0)
         {
            item.viewLayersTypeCurrentSet(1,-1);
         }
         if(!item.isRepairing())
         {
            item.setState(this.mStatesCatalog[3],true);
         }
         if(mode != 2 && mode != 3)
         {
            InstanceMng.getTrafficMng().droidsReturnDroidToHQ(item);
            item.mDroidLabourId = -1;
         }
         InstanceMng.getUIFacade().reloadCurrentBottomBar();
         if(Config.useBets() && item.mDef.isHeadQuarters())
         {
            InstanceMng.getBetMng().checkIfCanShowBetIcon();
         }
      }
      
      public function wioUpgradeFromSocialItem(item:WorldItemObject) : void
      {
         this.notifyBuildUpgradeEvent(item,3,true,true,1);
      }
      
      private function checkCollectingAmount(itemDef:WorldItemDef, amount:int) : Boolean
      {
         return amount > itemDef.getIncomeCapacity() * InstanceMng.getSettingsDefMng().mSettingsDef.getCollectablesThreshold() / 100;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var items:Vector.<WorldItemObject> = null;
         var item:WorldItemObject = null;
         var t:Transaction = null;
         var returnValue:Boolean = true;
         if(e.hasOwnProperty("items"))
         {
            items = e["items"];
            item = e["item"];
            (t = e.transaction).setWorldItemObject(item);
            t.setTransXp(item.getNextDef().getConstructionXp() * items.length);
            t.setTransScore(item.getNextDef().getScoreBuilt() * items.length);
            e.transaction = t;
            returnValue = notifyItems(e,items);
         }
         else if(!e.hasOwnProperty("items"))
         {
            item = e["item"];
            returnValue = this.notifyItem(e,item);
         }
         return returnValue;
      }
      
      public function collectAllCollectableItems(type:int = -1) : void
      {
         var item:WorldItemObject = null;
         var o:Object = null;
         var collectableItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetItemsCanGenerateResources();
         for each(item in collectableItems)
         {
            if(type == -1 || item.mDef.getTypeId() == type)
            {
               if(item.getIncomeAmount() > 0)
               {
                  (o = {}).cmd = "WIORentWaitingEnd";
                  o.item = item;
                  o.param = "Instant";
                  o.phase = "";
                  o.sendResponseTo = InstanceMng.getWorldItemObjectController();
                  o.tileIndex = -1;
                  o.tileIndex = 1;
                  InstanceMng.getWorldItemObjectController().notify(o);
               }
            }
         }
      }
      
      public function getAmountOfCollectableResources(type:int = -1) : Number
      {
         var item:WorldItemObject = null;
         var o:Object = null;
         var returnValue:Number = 0;
         var collectableItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetItemsCanGenerateResources();
         for each(item in collectableItems)
         {
            if(type == -1 || item.mDef.getTypeId() == type)
            {
               returnValue += item.getIncomeAmount();
            }
         }
         return returnValue;
      }
      
      public function getProductionAmountPerHour(type:int = -1) : Number
      {
         var item:WorldItemObject = null;
         var o:Object = null;
         var returnValue:Number = 0;
         var collectableItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetItemsCanGenerateResources();
         for each(item in collectableItems)
         {
            if(type == -1 || item.mDef.getTypeId() == type)
            {
               returnValue += item.mDef.getIncomePerMinute();
            }
         }
         return returnValue * 60;
      }
   }
}
