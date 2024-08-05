package com.dchoc.game.model.friends
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.controller.gui.popups.PopupFactory;
   import com.dchoc.game.controller.tools.ToolSpy;
   import com.dchoc.game.controller.world.item.WorldItemObjectController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.eview.widgets.particles.EFriendHelpBox;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class VisitorMng extends DCComponent
   {
      
      private static const STATE_NONE:int = -1;
      
      private static const STATE_IDLE:int = 0;
      
      private static const STATE_OWNER:int = 1;
      
      private static const STATE_VISITING:int = 2;
      
      private static const STATE_SPYING:int = 3;
      
      private static const NUM_DEFAULT_ACTIONS:int = 5;
      
      private static const ACTIONS_NUM_ACTIONS_LEFT:int = 0;
      
      private static const ACTIONS_LIST_ACTIONS_PERFORMED:int = 1;
      
      private static const ACTIONS_LIST_TO_AVOID:int = 2;
      
      public static const ACTIONS_LIST_ACTIONS_PERFORMED_BUILDING_SID:int = 0;
      
      public static const ACTIONS_SPEED_REPAIR:String = "repair";
      
      public static const ACTIONS_EXTRA_RESOURCES:String = "resources";
       
      
      private var smUserInfoMng:UserInfoMng;
      
      private var mState:SecureInt;
      
      private var mActionsList:Dictionary;
      
      private var mUserAccountId:SecureString;
      
      private var mAmountActionsLeft:SecureInt;
      
      private var mFriendHelpBoxes:Vector.<IFriendHelpBox>;
      
      private var mFirstTimeSpying:SecureBoolean;
      
      private var mStarBatteryGiven:Boolean;
      
      public function VisitorMng()
      {
         mState = new SecureInt("VisitorMng.mState");
         mUserAccountId = new SecureString("VisitorMng.mUserAccountId");
         mFirstTimeSpying = new SecureBoolean("VisitorMng.mFirstTimeSpying");
         mAmountActionsLeft = new SecureInt("VisitorMng.mAmountActionsLeft",0);
         super();
         this.mState.value = -1;
      }
      
      public function getAmountActionsLeft() : int
      {
         return this.mAmountActionsLeft.value;
      }
      
      public function getAmountActionsDone() : int
      {
         return 5 - this.mAmountActionsLeft.value;
      }
      
      public function getSpyCapsulesDroppedAmount() : int
      {
         var tool:ToolSpy = ToolSpy(InstanceMng.getToolsMng().getTool(10));
         return tool != null ? tool.capsulesGetDroppedAmount() : 0;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var advanceStep:Boolean = false;
         var roleId:int = 0;
         var userNPC:UserInfo = null;
         if(step == 0 && InstanceMng.getUserInfoMng().isBuilt() && InstanceMng.getWorld().isBuilt())
         {
            if(this.smUserInfoMng == null)
            {
               this.smUserInfoMng = InstanceMng.getUserInfoMng();
            }
            advanceStep = true;
            roleId = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
            if(roleId == 1)
            {
               this.mUserAccountId.value = InstanceMng.getUserInfoMng().getUserToVisitAccountId();
               if(this.mUserAccountId.value == null)
               {
                  advanceStep = false;
               }
            }
            if(advanceStep)
            {
               if(this.mState.value == -1)
               {
                  if(roleId == 1)
                  {
                     if((userNPC = this.smUserInfoMng.getUserInfoObj(this.mUserAccountId.value,0,3)) != null && userNPC.mIsNeighbor.value == false)
                     {
                        this.mState.value = 3;
                        this.mFirstTimeSpying.value = true;
                     }
                     else
                     {
                        this.mState.value = 2;
                     }
                  }
                  else if(roleId == 2)
                  {
                     this.mState.value = 3;
                     this.mFirstTimeSpying.value = true;
                  }
                  else if(roleId == 0)
                  {
                     this.mState.value = 1;
                  }
                  else
                  {
                     this.mState.value = 0;
                  }
                  if(this.mState.value == 2)
                  {
                     this.buildVisitingGUI();
                     this.mStarBatteryGiven = false;
                  }
               }
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         var friendHelpBox:IFriendHelpBox = null;
         this.mState.value = -1;
         this.mUserAccountId.value = null;
         this.mActionsList = null;
         if(this.mFriendHelpBoxes != null)
         {
            for each(friendHelpBox in this.mFriendHelpBoxes)
            {
               friendHelpBox.removeFromDisplay();
            }
            this.mFriendHelpBoxes.length = 0;
            this.mFriendHelpBoxes = null;
         }
      }
      
      public function uiSetIsEnabled(value:Boolean) : void
      {
         var box:IFriendHelpBox = null;
         if(this.mFriendHelpBoxes != null)
         {
            for each(box in this.mFriendHelpBoxes)
            {
               box.uiSetIsEnabled(value);
            }
         }
      }
      
      public function setUserVisiting(accountId:String) : void
      {
         var isNeighbor:* = this.smUserInfoMng.getUserInfoObj(accountId,0,2) != null;
         var isNPC:* = this.smUserInfoMng.getUserInfoObj(accountId,0,3) != null;
         if(isNeighbor == false && isNPC == false)
         {
            this.mState.value = 0;
         }
         else
         {
            this.mUserAccountId.value = accountId;
         }
      }
      
      private function buildVisitingGUI(helpActions:int = 0) : void
      {
         var guiHud:TopHudFacade = InstanceMng.getTopHudFacade();
         if(this.mState.value == 0)
         {
            guiHud.setVisitingHUD(false);
            return;
         }
         guiHud.setVisitingHUD(this.mActionsList != null);
         this.mAmountActionsLeft.value = helpActions;
         guiHud.visitingSetHelpActionsAmount(this.mAmountActionsLeft.value);
         this.cursorUpdateAmountActions(this.mAmountActionsLeft.value);
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var missionTarget:DCTarget = null;
         var friendHelpBox:IFriendHelpBox = null;
         var i:int = 0;
         var timeLeft:int = 0;
         if(this.mState.value == 0 || this.mState.value == -1)
         {
            return;
         }
         if(this.mState.value == 2 && this.mActionsList == null)
         {
            this.mActionsList = this.getActionsDoneToFriend();
            if(this.mActionsList != null)
            {
               this.mAmountActionsLeft.value = parseInt(this.mActionsList[this.mUserAccountId.value][0]);
               this.buildingsVisitingSetupActions(true);
               this.buildVisitingGUI(this.mAmountActionsLeft.value);
               if(InstanceMng.getUserInfoMng().getProfileLogin().getDailyBonusTimeLeft() <= 0)
               {
                  this.popupOpenWelcomePopup();
                  InstanceMng.getUserInfoMng().getProfileLogin().setDailyBonusTimeLeft(64800000);
               }
            }
            if(this.mUserAccountId.value != null && this.mUserAccountId.value == "npc_A")
            {
               missionTarget = InstanceMng.getTargetMng().getTargetById("mission_12");
               if(missionTarget != null)
               {
                  missionTarget.addProgress(1,1);
               }
            }
            return;
         }
         if(this.mState.value == 1)
         {
            if(this.mActionsList == null)
            {
               this.mActionsList = this.getActionsDoneByFriends();
               if(this.mActionsList != null)
               {
                  this.friendsBoxesLoad();
               }
            }
            else
            {
               for(i = this.mFriendHelpBoxes.length - 1; i >= 0; )
               {
                  friendHelpBox = this.mFriendHelpBoxes[i];
                  friendHelpBox.logicUpdate(dt);
                  if(friendHelpBox.hasEnded())
                  {
                     friendHelpBox.removeFromDisplay();
                     this.mFriendHelpBoxes.splice(i,1);
                  }
                  i--;
               }
               if(this.mFriendHelpBoxes.length == 0)
               {
                  this.mState.value = 0;
               }
            }
         }
         if(this.mState.value == 3 && this.mFirstTimeSpying.value && InstanceMng.getUserInfoMng().getProfileLogin().getSpyCapsulesForFreeTimeLeft() <= 0 && InstanceMng.getItemsMng().getSpyCapsules() < InstanceMng.getItemsMng().getSpyCapsulesMaxAmount())
         {
            InstanceMng.getUserInfoMng().getProfileLogin().setSpyCapsulesForFreeTimeLeft(DCTimerUtil.minToMs(InstanceMng.getSettingsDefMng().getSpyCapsulesForFreeTime()));
            this.guiOpenSpyCapsulesDailyRewardPopup();
         }
         else if(InstanceMng.getUserInfoMng().getProfileLogin().getSpyCapsulesForFreeTimeLeft() > 0)
         {
            this.mFirstTimeSpying.value = false;
            timeLeft = InstanceMng.getUserInfoMng().getProfileLogin().getSpyCapsulesForFreeTimeLeft();
            InstanceMng.getUserInfoMng().getProfileLogin().setSpyCapsulesForFreeTimeLeft(timeLeft - dt);
         }
      }
      
      private function getActionsDoneByFriends() : Dictionary
      {
         var accountId:String = null;
         var subxml:XML = null;
         var subsubxml:XML = null;
         var xml:XML = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_ACTIONS_PERFORMED_BY_FRIENDS_LIST);
         if(xml == null)
         {
            return null;
         }
         var dic:Dictionary = new Dictionary();
         for each(subxml in EUtils.xmlGetChildrenList(xml,"neighborVisit"))
         {
            accountId = EUtils.xmlReadString(subxml,"accountId");
            if(dic[accountId] == null)
            {
               dic[accountId] = [];
            }
            dic[accountId][0] = EUtils.xmlReadString(subxml,"actionsLeft");
            dic[accountId][1] = [];
            for each(subsubxml in EUtils.xmlGetChildrenList(subxml,"neighborAction"))
            {
               dic[accountId][1].push([EUtils.xmlReadString(subsubxml,"sid")]);
            }
         }
         return dic;
      }
      
      private function getActionsDoneToFriend() : Dictionary
      {
         var arr:Array = null;
         var subxml:XML = null;
         var xml:XML = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_ACTIONS_PERFORMED_BY_FRIENDS_LIST);
         if(xml == null)
         {
            return null;
         }
         var dic:Dictionary = new Dictionary();
         var meId:String = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().mAccountId;
         for each(subxml in EUtils.xmlGetChildrenList(xml,"neighborVisit"))
         {
            if(EUtils.xmlReadString(subxml,"accountId") == meId)
            {
               arr = [];
               arr[0] = EUtils.xmlReadString(subxml,"actionsLeft");
               arr[1] = [];
               for each(xml in subxml.neighborAction)
               {
                  arr[1].push([EUtils.xmlReadString(xml,"sid")]);
               }
               arr[2] = [];
               for each(xml in subxml.neighborActionDone)
               {
                  arr[2].push([EUtils.xmlReadString(xml,"sid")]);
               }
               dic[this.mUserAccountId.value] = arr;
               return dic;
            }
         }
         arr = [];
         arr[0] = 5;
         arr[1] = [];
         arr[2] = [];
         dic[this.mUserAccountId.value] = arr;
         return dic;
      }
      
      private function popupOpenWelcomePopup() : void
      {
         var coinsPercentage:Number = InstanceMng.getSettingsDefMng().getHelpDailyVisitCoins();
         var coins:Number = Math.floor(InstanceMng.getRuleMng().getAmountDependingOnCapacity(coinsPercentage,true));
         InstanceMng.getUserInfoMng().getProfileLogin().addCoins(coins);
         InstanceMng.getUserDataMng().updateVisitHelp_dailyBonusDone(coins);
         var entry:Entry = EntryFactory.createCoinsSingleEntry(coins);
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getWelcomeVisitingPopup(entry);
         uiFacade.enqueuePopup(popup);
      }
      
      private function popupOpenComeBackPopup() : void
      {
         var minerals:int = InstanceMng.getSettingsDefMng().mSettingsDef.getHelpMaxActionsReward();
         InstanceMng.getUserInfoMng().getProfileLogin().addMinerals(minerals);
         InstanceMng.getUserDataMng().updateVisitHelp_allActionsDone(minerals);
         var entry:Entry = EntryFactory.createMineralsSingleEntry(minerals);
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getAllHelpsDoneWhenVisitingPopup(entry,this.closeComeBackPopup,DCTextMng.getText(5));
         uiFacade.enqueuePopup(popup);
      }
      
      private function closeComeBackPopup(event:Object = null) : void
      {
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj();
         var popup:DCIPopup = InstanceMng.getPopupMng().getPopupBeingShown();
         InstanceMng.getPopupMng().closeCurrentPopup(null);
      }
      
      private function buildingsVisitingSetupActions(applyActions:Boolean) : void
      {
         var worldItemObjectController:WorldItemObjectController = null;
         var world:World = null;
         var action:Array = null;
         var exclude:Array = null;
         var sid:String = null;
         var item:WorldItemObject = null;
         this.buildingsSetNotify("WIOEventVisitFriend");
         if(applyActions)
         {
            worldItemObjectController = InstanceMng.getWorldItemObjectController();
            world = InstanceMng.getWorld();
            for each(action in this.mActionsList[this.mUserAccountId.value][1])
            {
               sid = String(action[0]);
               item = world.itemsGetItemBySid(sid);
               if(item != null)
               {
                  worldItemObjectController.notify({
                     "cmd":"WIOEventVisitFriendHelpedEnd",
                     "item":item
                  });
               }
            }
            for each(exclude in this.mActionsList[this.mUserAccountId.value][2])
            {
               sid = String(exclude[0]);
               item = world.itemsGetItemBySid(sid);
               if(item != null)
               {
                  worldItemObjectController.notify({
                     "cmd":"WIOEventVisitFriendHelpedEnd",
                     "item":item
                  });
               }
            }
         }
      }
      
      private function buildingsSetNotify(wioEventCmd:String, items:Vector.<WorldItemObject> = null) : void
      {
         var wio:WorldItemObject = null;
         if(items == null)
         {
            items = InstanceMng.getWorld().itemsGetAllItems();
         }
         for each(wio in items)
         {
            if(wio != null && this.buildingsFilterForClickable(wio))
            {
               InstanceMng.getWorldItemObjectController().notify({
                  "cmd":wioEventCmd,
                  "item":wio
               });
            }
         }
      }
      
      public function buildingsFilterForClickable(item:WorldItemObject) : Boolean
      {
         var typeId:int = 0;
         var shipyard:Shipyard = null;
         if(item == null)
         {
            return false;
         }
         var serverStateId:int = item.mServerStateId;
         if(serverStateId == 2 || serverStateId == 0)
         {
            return true;
         }
         if(serverStateId == 1)
         {
            if(item.needsRepairs())
            {
               return true;
            }
            if((typeId = item.mDef.mTypeId) == 0 || typeId == 1)
            {
               return true;
            }
            if(typeId == 3)
            {
               shipyard = InstanceMng.getShipyardController().getShipyard(item.mSid);
               if(shipyard != null && shipyard.isProducing())
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function buildingsApplyUserActions(accountId:String) : String
      {
         var action:Array = null;
         var sid:String = null;
         var item:WorldItemObject = null;
         var isValid:Boolean = false;
         if((this.mActionsList != null && this.mActionsList[accountId] != null) == false)
         {
            return null;
         }
         var actionString:String = "";
         var actions:Array = this.mActionsList[accountId][1];
         for each(action in actions)
         {
            sid = String(action[0]);
            item = InstanceMng.getWorld().itemsGetItemBySid(sid);
            if(isValid = this.buildingsFilterForClickable(item))
            {
               actionString += this.buildingsApplyAction(item);
            }
         }
         return actionString;
      }
      
      private function buildingsApplyAction(item:WorldItemObject) : String
      {
         var particleText:String = null;
         var shipyard:Shipyard = null;
         if(item == null)
         {
            return "";
         }
         var accTime:Number = 0;
         if(item.needsRepairs())
         {
            item.setRepairBonusTime();
            accTime = item.getRepairTimeBonus();
            particleText = item.getRepairTimeBonusText();
         }
         else
         {
            switch(item.mServerStateId)
            {
               case 0:
               case 2:
                  accTime = item.getTimeBonus();
                  item.setTimeBonus();
                  particleText = item.getTimeBonusText();
                  break;
               case 1:
                  if(item.mDef.isARentResource())
                  {
                     item.setHasCollectionBonus(true);
                     accTime = item.getCollectionBonusAmount();
                     particleText = item.getCollectionBonusText();
                  }
                  else if(item.mDef.isAShipyard())
                  {
                     shipyard = InstanceMng.getShipyardController().getShipyard(item.mSid);
                     if(shipyard != null)
                     {
                        shipyard.accelerateProductionByFriend();
                        accTime = shipyard.getAccelerationTime();
                        particleText = shipyard.getAccelerateProductionByFriendText();
                     }
                  }
            }
         }
         return item.mSid + ":" + accTime + ":" + particleText + ";";
      }
      
      public function buildingsPerformFriendAction(sid:String, particleText:String) : void
      {
         var v:Vector.<WorldItemObject> = new Vector.<WorldItemObject>(1,true);
         v[0] = InstanceMng.getWorld().itemsGetItemBySid(sid);
         this.buildingsSetNotify("WioEventFriendHelped",v);
         ParticleMng.launchParticleTextFromItem(particleText,v[0]);
      }
      
      public function buildingsHighlightActionsBuildings(accountId:String, turnOn:Boolean) : void
      {
         var wio:WorldItemObject = null;
         if(this.mActionsList == null)
         {
            return;
         }
         if(this.mActionsList[accountId] == null)
         {
            return;
         }
         var actions:Array;
         var buildings:Array = (actions = this.mActionsList[accountId][1]).map(this.getWIOFromSid);
         for each(wio in buildings)
         {
            if(wio != null)
            {
               wio.viewSetSelected(turnOn,0,false);
            }
         }
      }
      
      private function buildingsGetTransactionForClicking() : Transaction
      {
         return null;
      }
      
      public function buildingsApplyAllUserActions() : void
      {
         for each(var box in this.mFriendHelpBoxes)
         {
            while(!box.hasStarted())
            {
               box.onAcceptThis();
            }
         }
      }
      
      private function getWIOFromSid(element:*, index:int, array:Array) : WorldItemObject
      {
         return InstanceMng.getWorld().itemsGetItemBySid(element[0]);
      }
      
      private function cursorUpdateAmountActions(helpActions:int) : void
      {
         InstanceMng.getUIFacade().getCursorFacade().setTextInCursor(14,"" + helpActions);
      }
      
      private function friendsBoxesLoad() : void
      {
         var accountId:* = null;
         if(this.mActionsList == null)
         {
            return;
         }
         if(this.mFriendHelpBoxes == null)
         {
            this.mFriendHelpBoxes = new Vector.<IFriendHelpBox>(0);
         }
         this.mFriendHelpBoxes.length = 0;
         for(accountId in this.mActionsList)
         {
            this.friendsBoxLoad(accountId);
         }
      }
      
      private function friendsBoxLoad(accountId:String) : void
      {
         var action:Array = null;
         var wio:WorldItemObject = null;
         var sid:String = null;
         var friendHelpBox:IFriendHelpBox = null;
         var actions:Array;
         if((actions = this.mActionsList[accountId][1]).length == 0)
         {
            return;
         }
         var idx:int = 0;
         for each(action in actions)
         {
            if((sid = String(action[0])) != null && sid != "")
            {
               if((wio = InstanceMng.getWorld().itemsGetItemBySid(sid)) != null)
               {
                  break;
               }
            }
            idx++;
         }
         if(wio == null)
         {
            return;
         }
         actions = actions.slice(idx,actions.length);
         var user:UserInfo;
         if((user = InstanceMng.getUserInfoMng().getUserInfoObj(accountId,0,2)) != null)
         {
            if(Config.useEsparragonTooltips())
            {
               friendHelpBox = new EFriendHelpBox(accountId,user);
               friendHelpBox.setX(wio.mViewCenterWorldX);
               friendHelpBox.setY(wio.mViewCenterWorldY);
               friendHelpBox.setItemSid(wio.mSid);
            }
            friendHelpBox.addToDisplay();
            this.mFriendHelpBoxes.push(friendHelpBox);
         }
      }
      
      public function friendsBoxesHide() : void
      {
         var box:IFriendHelpBox = null;
         for each(box in this.mFriendHelpBoxes)
         {
            box.setVisible(false);
         }
      }
      
      public function friendsBoxesShow() : void
      {
         var box:IFriendHelpBox = null;
         for each(box in this.mFriendHelpBoxes)
         {
            box.setVisible(true);
         }
      }
      
      public function onClickBuilding(item:WorldItemObject) : Boolean
      {
         var missionTarget:DCTarget = null;
         var particleText:String = null;
         if(this.mAmountActionsLeft.value <= 0)
         {
            return false;
         }
         var actionType:String = "";
         switch(item.mServerStateId - 1)
         {
            case 0:
               actionType = item.needsRepairs() ? "repair" : "resources";
         }
         var dateTime:Number = new Date().getTime();
         InstanceMng.getUserDataMng().updateVisitHelp_accelerateItem(parseInt(item.mSid),this.buildingsGetTransactionForClicking());
         this.onActionPerformed();
         InstanceMng.getItemsMng().getCollectionItemsParticleByAction(item.mDef.mSku,"help",item.mViewCenterWorldX,item.mViewCenterWorldY,item.mUpgradeId);
         switch(item.mServerStateId)
         {
            case 0:
            case 2:
               particleText = item.getTimeBonusText();
               break;
            case 1:
               if(item.needsRepairs())
               {
                  particleText = item.getRepairTimeBonusText();
               }
               else if(item.mDef.isARentResource())
               {
                  particleText = DCTextMng.getText(243);
               }
         }
         ParticleMng.launchParticleTextFromItem(particleText,item);
         InstanceMng.getTargetMng().updateProgress("helpFriend",1);
         if(this.mUserAccountId.value != null && this.mUserAccountId.value == "npc_A")
         {
            if((missionTarget = InstanceMng.getTargetMng().getTargetById("mission_12")) != null)
            {
               missionTarget.addProgress(1,1);
            }
         }
         return true;
      }
      
      public function onActionPerformed() : void
      {
         var profile:Profile = null;
         this.buildVisitingGUI(this.mAmountActionsLeft.value - 1);
         if(this.mAmountActionsLeft.value == 0)
         {
            this.popupOpenComeBackPopup();
            profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         }
      }
      
      public function setStarBatteryGiven() : void
      {
         this.mStarBatteryGiven = true;
      }
      
      public function getStarBatteryGiven() : Boolean
      {
         return this.mStarBatteryGiven;
      }
      
      public function giveSpyCapsulesDailyReward() : void
      {
         var entryCapsulesForFree:Entry = InstanceMng.getRuleMng().giveSpyCapsulesForFree();
         var transaction:Transaction = entryCapsulesForFree.toTransaction();
         if(transaction.performAllTransactions() == true)
         {
            InstanceMng.getUserDataMng().updateMisc_spyCapsuleForFree(transaction);
         }
      }
      
      private function guiOpenSpyCapsulesDailyRewardPopup() : DCIPopup
      {
         var entryCapsulesForFree:Entry = InstanceMng.getRuleMng().giveSpyCapsulesForFree();
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popupFactory:PopupFactory;
         var popup:DCIPopup = (popupFactory = uiFacade.getPopupFactory()).getSpyCapsulesDailyRewardPopup(entryCapsulesForFree);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
   }
}
