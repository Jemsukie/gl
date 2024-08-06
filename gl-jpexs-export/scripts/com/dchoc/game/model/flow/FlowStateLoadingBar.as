package com.dchoc.game.model.flow
{
   import com.adobe.utils.DictionaryUtil;
   import com.dchoc.game.controller.gui.popups.PopupMng;
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.loading.LoadingMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.view.dc.mng.ViewMngSimple;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.flow.DCFlowState;
   import com.dchoc.toolkit.core.rule.DCRuleMng;
   import com.dchoc.toolkit.services.advertising.DCAdsManager;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.view.screens.DCScreenLoadingBar;
   import esparragon.display.ETextField;
   import esparragon.resources.EResourcesMng;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class FlowStateLoadingBar extends DCFlowState
   {
      
      private static const BATCH_PRE_LOGIN:int = 0;
      
      private static const BATCH_LOGIN:int = 1;
      
      private static const BATCH_WAIT_FOR_RULES_BUILT:int = 2;
      
      private static const BATCH_WAIT_FOR_USERDATA:int = 3;
      
      private static const BATCH_LOAD_COMPONENTS:int = 4;
      
      private static const BATCH_BUILD_COMPONENTS:int = 5;
      
      private static const BATCH_UNBUILD_COMPONENTS:int = 6;
      
      private static const BATCH_LOAD_SUCCESS:int = 7;
      
      private static const BATCH_LOAD_END:int = 8;
      
      private static const BATCH_WAITING:int = 9;
       
      
      private var mResourceMng:ResourceMng;
      
      private var mEResourcesMng:EResourcesMng;
      
      private var mScreen:DCScreenLoadingBar;
      
      protected var mFirstLoading:Boolean = true;
      
      protected var mFlowState:DCFlowState;
      
      private var mLoadingSku:String;
      
      private var mLastMsg:String;
      
      private var mLastMsgTimer:int;
      
      private const TIPS_SWITCHING_TIME:int = 5000;
      
      private const TIP_FADE_FX_TIME:int = 2000;
      
      private var mExcludeTipsIndices:Dictionary;
      
      private var mTipTimer:int = 0;
      
      private var mShowTips:Boolean = false;
      
      private var mExcludedFiles:Array;
      
      private var mBatchId:int;
      
      private var mBatchTimeStarted:Number;
      
      private var mBatchFirstTimeStarted:Number;
      
      public function FlowStateLoadingBar(flowState:DCFlowState, loadingSku:String)
      {
         super();
         this.mFlowState = flowState;
         this.mLoadingSku = loadingSku;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var loadingSku:String = null;
         if(step == 0)
         {
            this.mScreen.setViewMng(mViewMng);
            loadingSku = InstanceMng.getLoadingMng().getLoadingAssetId(this.mLoadingSku);
            this.mResourceMng = InstanceMng.getResourceMng();
            this.mEResourcesMng = InstanceMng.getEResourcesMng();
            if(!this.mEResourcesMng.isAssetLoaded(loadingSku,"legacy"))
            {
               this.mEResourcesMng.loadAsset(loadingSku,"legacy");
            }
            this.mScreen.setLoadingSku(this.mLoadingSku);
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mFlowState = null;
         this.mResourceMng = null;
         this.mEResourcesMng = null;
         this.mLastMsg = null;
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         this.mBatchTimeStarted = DCTimerUtil.currentTimeMillis();
         this.mBatchFirstTimeStarted = this.mBatchTimeStarted;
         DCAdsManager.getInstance().spilAdSetNeedsToRequestAd(false);
         if(this.mFirstLoading)
         {
            this.batchSetId(0);
         }
         else
         {
            this.batchSetId(6);
         }
         mViewMng.setBackgroundColor(68115);
      }
      
      private function tipsLogicUpdate(dt:int) : void
      {
         var tipTextField:ETextField = null;
         if(this.mShowTips)
         {
            if(this.mTipTimer < 0)
            {
               tipTextField = this.mScreen.getTipTextfield();
               if(tipTextField != null)
               {
                  tipTextField.alpha = 1;
               }
               this.mScreen.showTips(this.getTipIndex());
               this.mTipTimer = 5000;
               this.mShowTips = false;
            }
            else
            {
               this.mTipTimer -= dt;
               if(this.mTipTimer < 2000)
               {
                  tipTextField = this.mScreen.getTipTextfield();
                  if(tipTextField != null)
                  {
                     tipTextField.alpha -= dt / 2000;
                  }
               }
            }
         }
      }
      
      private function getTipIndex() : int
      {
         var returnValue:* = 0;
         var tipRetries:int = 0;
         var loadingMng:LoadingMng = InstanceMng.getLoadingMng();
         var loadingScreenSku:String = this.mLoadingSku;
         var tipsAmount:int = loadingMng.getTipsAmountForCurrentLoadingBar(this.mLoadingSku);
         var index:int = DCMath.randBetween(0,tipsAmount);
         if(this.mExcludeTipsIndices == null)
         {
            this.mExcludeTipsIndices = new Dictionary();
         }
         if(this.mExcludeTipsIndices[loadingScreenSku] == null)
         {
            returnValue = index;
            this.mExcludeTipsIndices[loadingScreenSku] = new Dictionary();
            this.mExcludeTipsIndices[loadingScreenSku][index] = 0;
         }
         else
         {
            if(this.mExcludeTipsIndices[loadingScreenSku][index] == null)
            {
               returnValue = index;
               this.mExcludeTipsIndices[loadingScreenSku][index] = 1;
               return returnValue;
            }
            tipRetries = int(DictionaryUtil.getKeys(this.mExcludeTipsIndices[loadingScreenSku]).length);
            if(tipRetries >= tipsAmount)
            {
               this.mExcludeTipsIndices[loadingScreenSku] = null;
            }
            returnValue = this.getTipIndex();
         }
         this.mExcludeTipsIndices[loadingScreenSku][index] += 1;
         return returnValue;
      }
      
      private function areAllFilesRequestedToServerLoaded() : Boolean
      {
         if(this.mExcludedFiles == null)
         {
            this.mExcludedFiles = [];
            this.mExcludedFiles.push(UserDataMng.KEY_WEEKLY_SCORE_LIST);
            if(Config.USE_LAZY_SERVER_RESPONSE)
            {
               this.mExcludedFiles.push(UserDataMng.KEY_FRIENDS_LIST);
               this.mExcludedFiles.push(UserDataMng.KEY_NEIGHBOR_LIST);
            }
         }
         return InstanceMng.getUserDataMng().allFilesLoadedExclude(this.mExcludedFiles,true);
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var componentsCurrentStep:int = 0;
         var componentsTotalSteps:int = 0;
         var barPercentPerComponents:int = 0;
         var barPercentPerResources:int = 0;
         var percent:int = 0;
         var msg:String = null;
         super.logicUpdateDo(dt);
         var popupMng:PopupMng;
         if((popupMng = InstanceMng.getPopupMng()) != null)
         {
            popupMng.logicUpdate(dt);
         }
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var allFilesLoaded:Boolean = this.areAllFilesRequestedToServerLoaded();
         switch(this.mBatchId)
         {
            case 0:
               if(userDataMng.isLogged())
               {
                  if(userDataMng.isUniverseLocked())
                  {
                     Application.externalNotification(2,null);
                     this.batchSetId(9);
                  }
                  else
                  {
                     this.batchSetId(1);
                  }
               }
               break;
            case 2:
               if(Config.DEBUG_MODE)
               {
                  DCDebug.traceCh("wait"," allFiles = " + allFilesLoaded + " customizer = " + InstanceMng.getCustomizerMng().isBuilt());
               }
               if(InstanceMng.getResourceMng().progressGetImmediateCompletePercent(true) == 100 && InstanceMng.getRuleMng().isBuilt())
               {
                  this.batchSetId(3);
               }
               else
               {
                  InstanceMng.getRuleMng().filesRequestBySteps();
                  if(Config.DEBUG_MODE)
                  {
                     DCDebug.traceCh("LOADING","wait for rules");
                  }
               }
               break;
            case 3:
               if(this.areAllFilesRequestedToServerLoaded() && InstanceMng.getCustomizerMng().isBuilt())
               {
                  this.batchSetId(4);
               }
               break;
            case 4:
               if(this.mFlowState.isLoaded())
               {
                  this.batchSetId(5);
               }
               break;
            case 5:
            default:
               break;
            case 1:
               if(userDataMng.isLoaded())
               {
                  this.batchSetWaitForRulesId();
               }
               else
               {
                  userDataMng.logicUpdate(100);
               }
               return;
            case 6:
               if(!InstanceMng.getUserDataMng().anyCommandPendingToSend())
               {
                  this.batchSetId(3);
               }
               return;
         }
         this.mFlowState.logicUpdate(dt);
         if(this.mBatchId == 7)
         {
            if(this.mFlowState.isBegun())
            {
               this.batchSetId(8);
            }
         }
         else
         {
            this.mShowTips = true;
            componentsCurrentStep = this.mFlowState.createGetCurrentStep();
            barPercentPerComponents = int((componentsTotalSteps = this.mFlowState.createGetTotalSteps()) > -1 ? int(DCMath.ruleOf3(componentsCurrentStep,componentsTotalSteps,50)) : 0);
            barPercentPerResources = DCMath.ruleOf3(this.mResourceMng.progressGetImmediateCompletePercent(),100,50);
            percent = barPercentPerComponents + barPercentPerResources;
            if(Config.DEBUG_LOADING)
            {
               msg = "batch= " + this.mBatchId + " percent = " + percent + " percentComponents = " + barPercentPerComponents + " percentPerResources = " + barPercentPerResources + " componentsCurrentStep = " + componentsCurrentStep + " componentsTotalSteps= " + componentsTotalSteps + " isLogged = " + InstanceMng.getUserDataMng().isLogged() + " isLoaded = " + InstanceMng.getUserDataMng().isLoaded() + " newUser = " + InstanceMng.getApplication().getWaitForIntro() + " screenDone = " + this.mScreen.getIsDone();
               if(msg == this.mLastMsg)
               {
                  this.mLastMsgTimer -= dt;
                  if(this.mLastMsgTimer <= 0)
                  {
                     this.mLastMsg = null;
                  }
               }
               if(msg != this.mLastMsg)
               {
                  DCDebug.traceCh("LOADING",msg);
                  this.mLastMsg = msg;
                  this.mLastMsgTimer = 10000;
               }
            }
            if((!InstanceMng.getUserDataMng().isLogged() || !InstanceMng.getUserDataMng().isLoaded()) && percent == 100)
            {
               percent--;
            }
            this.mScreen.percentSetTarget(percent);
            if(this.mScreen.getIsDone() && !InstanceMng.getApplication().getWaitForIntro())
            {
               this.batchSetId(7);
            }
         }
         this.tipsLogicUpdate(dt);
      }
      
      private function requestAssets() : void
      {
         InstanceMng.getRuleMng().requestResources();
         this.mFlowState.requestResources();
         this.mResourceMng.requestResource("battle_effects");
         this.mResourceMng.requestResource("missile_001");
         this.mResourceMng.requestResource("bomb");
         this.mResourceMng.requestResource("fireball");
         this.mResourceMng.requestResource("assets/flash/battle_effects/crater.png");
         this.mResourceMng.requestResource("assets/flash/_esparragon/gui/layouts/gui_old.swf");
         this.mResourceMng.requestResource("assets/flash/gui/spy_capsule.swf");
         this.mResourceMng.requestResource("assets/flash/gui/popups.swf");
         this.mResourceMng.requestResource("assets/flash/gui/popups_exported.swf");
         this.mResourceMng.requestResource("assets/flash/gui/container_happenings.swf");
         if(true)
         {
            this.mResourceMng.requestResource("assets/flash/halloween/popups.swf");
         }
         if(Config.useDoomsdayPopups())
         {
            this.mResourceMng.requestResource("assets/flash/doomsday/popups.swf");
         }
         this.mResourceMng.requestResource("assets/flash/world_items/common.swf");
         this.mResourceMng.requestResource("assets/flash/world_items/pngs_common/particle_coin.png");
         this.mResourceMng.requestResource("assets/flash/world_items/pngs_common/particle_resource.png");
         this.mResourceMng.requestResource("assets/flash/world_items/pngs_common/particle_experience.png");
         this.mResourceMng.requestResource("assets/flash/world_items/pngs_common/grille.png");
         for each(var asset in InstanceMng.getSkinsMng().getFoundationAssetsVector())
         {
            this.mResourceMng.requestResource(asset);
         }
         this.mResourceMng.requestResource("deaths");
         this.mResourceMng.requestResource("citizen_001");
         this.mResourceMng.requestResource("assets/flash/generic_loading.swf");
         this.mResourceMng.progressNotifyAllFilesRequested();
      }
      
      override public function isALoadingState() : Boolean
      {
         return true;
      }
      
      override protected function childrenCreate() : void
      {
         super.childrenCreate();
         this.mScreen = this.screenCreate();
         childrenAddChild(this.mScreen);
      }
      
      override protected function viewMngCreate() : void
      {
         mViewMng = new ViewMngSimple(1);
      }
      
      protected function screenCreate() : DCScreenLoadingBar
      {
         return new DCScreenLoadingBar(10,"Loading_Screen");
      }
      
      private function batchSetWaitForRulesId() : void
      {
         var batchId:int = 2;
         this.batchSetId(batchId);
      }
      
      private function batchSetId(id:int) : void
      {
         var prev:Number = NaN;
         var time:Number = NaN;
         var loadingTime:int = 0;
         var ruleMng:DCRuleMng = null;
         this.mBatchId = id;
         if(Config.DEBUG_CONSOLE)
         {
            prev = this.mBatchTimeStarted;
            this.mBatchTimeStarted = DCTimerUtil.currentTimeMillis();
            time = this.mBatchTimeStarted - prev;
            DCDebug.traceCh("TIME LOADING","batchSetId = " + id + " time = " + time);
         }
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         switch(this.mBatchId - 1)
         {
            case 0:
               userDataMng.loadFiles();
               break;
            case 1:
               break;
            case 2:
               if(this.mFirstLoading)
               {
                  this.requestAssets();
               }
               else
               {
                  this.batchWaitForUserData();
               }
               break;
            case 4:
               if(Config.DEBUG_CONSOLE)
               {
                  DCDebug.traceCh("LOADING","FlowStateLoadingBar.batchSetId() -> provideData begin...");
               }
               this.mFlowState.provideData();
               if(Config.DEBUG_CONSOLE)
               {
                  DCDebug.traceCh("LOADING","FlowStateLoadingBar.batchSetId() -> provideData end...");
               }
               break;
            case 5:
               this.mFlowState.unbuildMode(InstanceMng.getApplication().mFlowStateUnbuildMode);
               break;
            case 6:
               if(this.mFirstLoading)
               {
                  this.mFirstLoading = false;
                  ruleMng = InstanceMng.getRuleMng();
                  ruleMng.sigCalculateTotal();
                  DCDebug.traceCh("LOADING","CRC = " + ruleMng.sigGetTotal());
                  InstanceMng.getUserDataMng().updateMisc_firstLoadingSuccess(ruleMng.sigGetTotal());
                  if(InstanceMng.getApplication().isTutorialCompleted())
                  {
                     InstanceMng.getFlowStatePlanet().setNeedsToWaitForPendingTransactions(true);
                  }
                  ruleMng.sigUnload();
               }
               else if(this.getRoleId() == 0 && InstanceMng.getApplication().viewGetMode() == 0 && userDataMng.getNeedsToVerifyCreditsPurchase())
               {
                  userDataMng.queryVerifyCreditsPurchase(false);
               }
               this.mFlowState.setIsBeginAllowed(true);
               this.batchSetId(8);
               break;
            case 7:
               this.changeStateOnBatchLoadEnd();
               loadingTime = getTimer();
               this.mShowTips = false;
               this.mTipTimer = 0;
               DCAdsManager.getInstance().spilAdSetNeedsToRequestAd(true);
               DCDebug.traceCh("TIME LOADING","total = " + (this.mBatchTimeStarted - this.mBatchFirstTimeStarted) + "");
         }
      }
      
      private function getRoleId() : int
      {
         var role:Role = InstanceMng.getRole();
         return int(role != null ? InstanceMng.getRole().mId : -1);
      }
      
      protected function batchWaitForUserData() : void
      {
         FlowStatePlanet(this.mFlowState).visitAskUniverse();
      }
      
      protected function changeStateOnBatchLoadEnd() : void
      {
         InstanceMng.getApplication().fsmChangeState(3);
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         if(this.mScreen != null)
         {
            this.mScreen.onResize(stageWidth,stageHeight);
         }
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case 114:
               InstanceMng.getSkinsMng().cycleSkin();
               break;
            case 118:
               InstanceMng.getUserDataMng().getAdsManager().adsReady(true,"");
               break;
            case 68:
               DCComponent.smBuildSyncErrorShown = !DCComponent.smBuildSyncErrorShown;
               InstanceMng.getResourceMng().printResourcesNotLoadedYet();
         }
      }
   }
}
