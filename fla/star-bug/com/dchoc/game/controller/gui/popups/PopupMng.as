package com.dchoc.game.controller.gui.popups
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.view.dc.gui.popups.PopupIonStorm;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.dchoc.toolkit.view.gui.popups.DCIPopupSpeech;
   import com.dchoc.toolkit.view.gui.popups.DCPopupMng;
   import com.gskinner.motion.GTween;
   import esparragon.display.EAbstractSprite;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class PopupMng extends DCPopupMng
   {
      
      public static const BUTTON_OK:String = "ok_button";
      
      public static const BUTTON_CANCEL:String = "cancel_button";
      
      public static const BUTTON_SHARE:String = "share_button";
      
      public static const BUTTON_ADDGOLD:String = "add_gold_button";
      
      public static const BUTTON_CLOSE:String = "close_button";
      
      public static const BUTTON_INSTANT:String = "instant_button";
      
      public static const BUTTON_BUY_FB_CREDITS:String = "buy_fb_button";
      
      public static const BUTTON_BUY_FBC_BIG:String = "buy_fb_big_button";
      
      public static const BUTTON_SPEED_UP:String = "speed_button";
      
      public static const BUTTON_CANCEL_SPEED_UP:String = "cancel_speed_button";
      
      public static const POPUP_HAPPENING_SHOP:String = "PopupHappeningShop";
      
      public static const POPUP_HAPPENING_KIT:String = "PopupHappeningKit";
      
      public static const POPUP_NETWORK_BUSY:String = "PopupNetworkBusy";
      
      public static const POPUP_TRADE_IN_SOURCE_CRAFTING:String = "crafting";
      
      public static const POPUP_TRADE_IN_SOURCE_COLLECTION:String = "collection";
      
      public static const POPUP_TRADE_IN_SOURCE_PENDING:String = "pending";
      
      public static const POPUP_TRADE_IN_SOURCE_PURCHASE:String = "purchase";
       
      
      private var mEPopupFactory:EPopupFactory;
      
      private var mViewMng:DCViewMng;
      
      private var mEvent:Object;
      
      private var mWaitingPopups:Vector.<DCIPopup>;
      
      private var mStackedPopups:Vector.<DCIPopup>;
      
      private var mAllowPopups:Boolean;
      
      private var mTween:GTween;
      
      private var mPopupsOpened:Dictionary;
      
      public function PopupMng()
      {
         super();
         this.mStackedPopups = new Vector.<DCIPopup>(0);
         this.mWaitingPopups = new Vector.<DCIPopup>(0);
         this.mAllowPopups = true;
      }
      
      public function setAllowPopups(value:Boolean) : void
      {
         this.mAllowPopups = value;
      }
      
      override public function isBuilt() : Boolean
      {
         return true;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         super.loadDoStep(step);
         if(step == 0)
         {
            this.mEvent = {"cmd":""};
            this.mEPopupFactory = new EPopupFactory();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.closeAllPopups();
         super.unbuildDo();
      }
      
      override protected function unloadDo() : void
      {
         var popup:DCIPopup = null;
         super.unloadDo();
         this.mEvent = null;
         this.mEPopupFactory = null;
         this.mViewMng = null;
         if(this.mWaitingPopups != null)
         {
            while(this.mWaitingPopups.length > 0)
            {
               popup = this.mWaitingPopups.shift();
               popup.destroy();
            }
            this.mWaitingPopups = null;
         }
         if(this.mStackedPopups != null)
         {
            while(this.mStackedPopups.length > 0)
            {
               popup = this.mStackedPopups.shift();
               popup.destroy();
            }
            this.mStackedPopups = null;
         }
         this.mPopupsOpened = null;
      }
      
      override protected function beginDo() : void
      {
         this.mViewMng = InstanceMng.getViewMngGame();
      }
      
      override public function lock() : void
      {
         var popup:DCIPopup = null;
         if(mPopupBeingShown != null)
         {
            mPopupBeingShown.lockPopup();
         }
         for each(popup in this.mStackedPopups)
         {
            popup.lockPopup();
         }
      }
      
      override public function unlock(exception:Object = null) : void
      {
         var popup:DCIPopup = null;
         if(mPopupBeingShown != null)
         {
            mPopupBeingShown.unlockPopup();
         }
         for each(popup in this.mStackedPopups)
         {
            popup.unlockPopup();
         }
      }
      
      public function showPopups(targetClass:Class) : void
      {
         var popup:DCIPopup = null;
         for each(popup in mPopups)
         {
            if(popup is targetClass)
            {
               this.openPopup(popup,this.mViewMng);
            }
         }
      }
      
      public function closePopups(targetClass:Class) : void
      {
         var popup:DCIPopup = null;
         for each(popup in mPopups)
         {
            if(popup is targetClass)
            {
               this.closePopupDo(popup,this.mViewMng);
            }
         }
      }
      
      public function closePopupsNotIn(targetClass:Class) : void
      {
         var popup:DCIPopup = null;
         for each(popup in mPopups)
         {
            if(!(popup is targetClass))
            {
               this.closePopup(popup,this.mViewMng);
            }
         }
      }
      
      private function closeAllPopups() : void
      {
         var popup:DCIPopup = null;
         for each(popup in this.mStackedPopups)
         {
            this.closePopupDo(popup);
         }
      }
      
      private function closeStackedPopups() : void
      {
         var i:int = 0;
         var popup:DCIPopup = null;
         for(i = this.mStackedPopups.length - 1; i >= 0; )
         {
            popup = this.mStackedPopups[this.mStackedPopups.length - 1];
            if(this.isBubbleSpeechPopup(popup) == false)
            {
               this.closePopupDo(popup);
            }
            i--;
         }
         if(this.mStackedPopups.length == 0)
         {
            mPopupBeingShown = null;
         }
      }
      
      override public function openPopup(popupId:Object, viewMng:DCViewMng = null, showAnim:Boolean = true, showDarkBackground:Boolean = true, closeOpenedPopup:Boolean = true) : Boolean
      {
         var popup:DCIPopup = null;
         if(this.mAllowPopups)
         {
            if((popup = popupId is String ? mPopups[popupId] : DCIPopup(popupId)) != null && this.mWaitingPopups.indexOf(popup) < 0)
            {
               if(popup != null && !popup.isStackable())
               {
                  popup.setIsStackable(!closeOpenedPopup);
               }
               popup.setShowAnim(showAnim);
               popup.setShowDarkBackground(showDarkBackground);
               this.mWaitingPopups.push(popup);
               this.addPopupOpened(popup);
               return true;
            }
         }
         return false;
      }
      
      private function openPopupDo(popup:DCIPopup, viewMng:DCViewMng = null, showAnim:Boolean = true, showDarkBackground:Boolean = true) : void
      {
         var hasOpened:Boolean = false;
         if(mBackground == null)
         {
            mBackground = new Sprite();
            this.drawBackground(DCInstanceMng.getInstance().getApplication().stageGetWidth(),DCInstanceMng.getInstance().getApplication().stageGetHeight());
         }
         var notifyGUIController:* = !DCPopupMng.smIsPopupActive;
         this.mStackedPopups.push(popup);
         mPopupBeingShown = popup;
         if(this.mTween != null)
         {
            this.mTween.end();
         }
         if(showDarkBackground)
         {
            showDarkBackground = popup.getShowDarkBackground();
         }
         if(hasOpened = super.openPopup(popup,viewMng,showAnim,showDarkBackground))
         {
            if(InstanceMng.getGUIController().isBuilt() && this.isBubbleSpeechPopup(popup) == false)
            {
               InstanceMng.getGUIController().lockGUI(popup);
            }
            popup.setIsBeingShown(true);
            smIsPopupActive = !this.isBubbleSpeechPopup(popup);
            ETooltipMng.getInstance().removeCurrentTooltip();
            this.mTween = null;
            InstanceMng.getUIFacade().removeEnqueuedPopup(popup.getPopupType());
         }
      }
      
      override public function closePopup(popupId:Object, viewMng:DCViewMng = null, instant:Boolean = false) : Boolean
      {
         var i:int = 0;
         var p:DCIPopup = null;
         var popup:* = null;
         if(popupId is String)
         {
            if(this.mStackedPopups != null)
            {
               i = this.mStackedPopups.length - 1;
               while(i > -1 && popup == null)
               {
                  if((p = this.mStackedPopups[i]).getPopupType() == popupId)
                  {
                     popup = p;
                  }
                  i--;
               }
            }
            if(popup == null)
            {
               popup = mPopups[popupId];
            }
         }
         else
         {
            popup = DCIPopup(popupId);
         }
         if(popup != null)
         {
            if(instant)
            {
               this.closePopupDo(popup,viewMng);
            }
            else
            {
               popup.startCloseEffect();
            }
            return false;
         }
         return false;
      }
      
      public function closePopupDo(popupId:Object, viewMng:DCViewMng = null) : Boolean
      {
         var hasClosed:Boolean = false;
         var popupFactory:PopupFactory = null;
         var numPopupsMission:int = 0;
         var popupStacked:DCIPopup = null;
         var canUnlockGUI:Boolean = false;
         var application:Application = null;
         var popup:DCIPopup;
         if((popup = popupId is String ? mPopups[popupId] : DCIPopup(popupId)) == null)
         {
            return false;
         }
         hasClosed = super.closePopup(popupId,viewMng);
         if(hasClosed)
         {
            this.mTween = null;
            (popupFactory = this.mEPopupFactory).returnPopup(popup);
            this.removePopupOpened(popup);
         }
         if(hasClosed && this.mStackedPopups.length > 0)
         {
            this.mStackedPopups.splice(this.mStackedPopups.indexOf(popup),1);
            if(this.mStackedPopups.length > 0)
            {
               mPopupBeingShown = this.mStackedPopups[this.mStackedPopups.length - 1];
               mPopupBeingShown.unlockPopup();
            }
         }
         var viewMngrGame:ViewMngrGame = InstanceMng.getViewMngGame();
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning() == false && mNumOpenPopups > 0)
         {
            numPopupsMission = 0;
            for each(popupStacked in this.mStackedPopups)
            {
               if(popupStacked is DCIPopupSpeech)
               {
                  numPopupsMission++;
               }
            }
            if(numPopupsMission > 0)
            {
               viewMngrGame.removePopup(mBackground);
               if(!(mPopupBeingShown is DCIPopupSpeech))
               {
                  viewMngrGame.addPopup(mBackground,mNumOpenPopups - 1 - numPopupsMission);
               }
            }
         }
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning() == true && mNumOpenPopups > 0)
         {
            if(this.isBubbleSpeechPopup(mPopupBeingShown) == true)
            {
               viewMngrGame.removePopup(mBackground);
            }
         }
         if(hasClosed)
         {
            popup.setIsBeingShown(false);
            if(this.mStackedPopups.length == 0)
            {
               smIsPopupActive = false;
               if(InstanceMng.getMapView().getSpotlightDisplayObject() != null)
               {
                  InstanceMng.getMapView().removeSpotlight();
               }
               canUnlockGUI = InstanceMng.getGUIController().canUnlockGUI(InstanceMng.getMapView());
               application = InstanceMng.getApplication();
               if(canUnlockGUI && !this.isBubbleSpeechPopup(popup) && !application.fsmGetCurrentState().isALoadingState() && !application.lockUIIsLocked())
               {
                  InstanceMng.getGUIController().unlockGUI(InstanceMng.getMapView());
               }
            }
         }
         return hasClosed;
      }
      
      public function closeCurrentPopup(e:MouseEvent = null, instant:Boolean = false) : void
      {
         if(mPopupBeingShown != null)
         {
            this.closePopup(mPopupBeingShown,null,instant);
         }
      }
      
      public function currentPopupCallFunction(fnName:String, params:Object) : void
      {
         var popupObject:Object = null;
         if(mPopupBeingShown != null)
         {
            popupObject = mPopupBeingShown as Object;
            if(popupObject.hasOwnProperty(fnName))
            {
               if(params == null)
               {
                  popupObject[fnName]();
               }
               else
               {
                  popupObject[fnName](params);
               }
            }
         }
      }
      
      public function isPopupShownOrWaitingForBeingShown(key:String) : Boolean
      {
         var popup:DCIPopup = this.getPopupOpened(key);
         return popup != null && (mPopupBeingShown == popup || this.mWaitingPopups.indexOf(popup) > -1);
      }
      
      public function isAnyPopupBeingShownOrWaiting() : Boolean
      {
         return mPopupBeingShown != null || this.mWaitingPopups.length > 0;
      }
      
      override public function getPopupBeingShown() : DCIPopup
      {
         return mPopupBeingShown;
      }
      
      public function getUnderPopup() : DCIPopup
      {
         var popup:DCIPopup = this.getPopupBeingShown();
         if(this.mStackedPopups != null && popup != null && popup.isStackable() && this.mStackedPopups.length > 1)
         {
            if(this.mStackedPopups[this.mStackedPopups.length - 2] != null)
            {
               return this.mStackedPopups[this.mStackedPopups.length - 2];
            }
         }
         return popup;
      }
      
      public function getStackedPopupById(id:String) : DCIPopup
      {
         var length:int = 0;
         var i:int = 0;
         var popup:DCIPopup = null;
         var returnValue:* = null;
         if(this.mStackedPopups != null)
         {
            length = int(this.mStackedPopups.length);
            i = 0;
            while(i < length && returnValue == null)
            {
               popup = this.mStackedPopups[i];
               if(popup.getPopupType() == id)
               {
                  returnValue = popup;
               }
               i++;
            }
         }
         return returnValue;
      }
      
      private function isBubbleSpeechPopup(popup:DCIPopup) : Boolean
      {
         return popup is DCIPopupSpeech && (popup as DCIPopupSpeech).usesBubble();
      }
      
      public function enqueueBunkerPopup(e:Object) : DCIPopup
      {
         var popup:DCIPopup = null;
         var isWarpBunker:Boolean = Boolean(e.item.mDef.isAWarpBunker());
         var bunker:Bunker = InstanceMng.getBunkerController().getFromSid(e.item.mSid) as Bunker;
         var isVisiting:* = InstanceMng.getFlowStatePlanet().getCurrentRoleId() != 0;
         var popupId:String = "PopupBunker";
         var visitor:Boolean = false;
         if(isVisiting)
         {
            popupId = "PopupBunker";
            visitor = true;
         }
         else if(!isVisiting && isWarpBunker)
         {
            popupId = "PopupBunkerFriends";
         }
         else if(!isVisiting && !isWarpBunker)
         {
            popupId = "PopupBunker";
            visitor = false;
         }
         switch(popupId)
         {
            case "PopupBunker":
               popup = this.mEPopupFactory.getBunkerPopup(bunker,visitor);
               break;
            case "PopupBunkerFriends":
               popup = this.mEPopupFactory.getBunkerFriendsPopup(bunker);
               if(!isVisiting && isWarpBunker)
               {
                  e.item.highlightRemove();
                  e.item.mShouldHighLight = false;
               }
         }
         if(popup != null)
         {
            InstanceMng.getUIFacade().enqueuePopup(popup);
         }
         return popup;
      }
      
      public function openNetworkBusyPopup() : void
      {
         var popup:DCIPopup = null;
         popup = getPopup("PopupNetworkBusy");
         if(popup == null)
         {
            popup = new PopupIonStorm();
         }
         PopupIonStorm(popup).setupPopup();
         this.openPopup(popup);
      }
      
      public function closeNetworkBusyPopup() : void
      {
         this.closeCurrentPopup();
      }
      
      public function launchOverPopupText(onButton:EAbstractSprite, textTid:*, time:int = 1000, color:String = null, removeBase:Boolean = false, offsetX:Number = 0, offsetY:Number = 0) : void
      {
         var tf:ETextField;
         var spc:ESpriteContainer;
         var p:Point;
         var t:GTween;
         var layerSku:String;
         var viewMng:ViewMngrGame = null;
         if(onButton == null)
         {
            return;
         }
         tf = InstanceMng.getViewFactory().getETextField(null,null,"text_title");
         tf.setFontSize(16);
         tf.mouseChildren = false;
         tf.mouseEnabled = false;
         if(color)
         {
            tf.applySkinProp(null,color);
         }
         tf.setText(DCTextMng.getText(textTid));
         spc = InstanceMng.getViewFactory().getESpriteContainer();
         spc.eAddChild(tf);
         spc.setContent("text",tf);
         p = new Point(offsetX,offsetY);
         p = onButton.localToGlobal(p);
         p.y -= tf.getLogicHeight();
         t = TweenEffectsFactory.createTranslationFromPointToPoint(1,spc,p,new Point(p.x,p.y - 50),true,function(t:GTween):void
         {
            viewMng.removeChildFromLayer(t.target as ESprite,viewMng.getPopupLayerSku());
            (t.target as ESprite).destroy();
         });
         t.duration = 1;
         t.autoPlay = true;
         viewMng = ViewMngrGame(this.mViewMng);
         layerSku = viewMng.getPopupLayerSku();
         viewMng.addChildToLayer(spc,viewMng.getPopupLayerSku());
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(this.mWaitingPopups.length > 0)
         {
            if(!this.mWaitingPopups[0].isStackable())
            {
               this.closeStackedPopups();
            }
            if(this.mTween == null)
            {
               this.openPopupDo(this.mWaitingPopups.shift());
            }
         }
         if(mPopupBeingShown != null)
         {
            mPopupBeingShown.logicUpdate(dt);
         }
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         var popup:DCIPopup = null;
         super.onResize(stageWidth,stageHeight);
         for each(popup in this.mStackedPopups)
         {
            popup.resize();
         }
      }
      
      override protected function drawBackground(w:Number, h:Number) : void
      {
         if(mBackground != null)
         {
            mBackground.graphics.clear();
            mBackground.graphics.beginFill(0,0.5);
            mBackground.graphics.drawRect(0,0,w,h);
            mBackground.graphics.endFill();
         }
      }
      
      private function addPopupOpened(p:DCIPopup) : void
      {
         if(this.mPopupsOpened == null)
         {
            this.mPopupsOpened = new Dictionary(true);
         }
         this.mPopupsOpened[p.getPopupType()] = p;
      }
      
      private function removePopupOpened(p:DCIPopup) : void
      {
         var id:String = null;
         if(this.mPopupsOpened != null)
         {
            id = p.getPopupType();
            p = this.mPopupsOpened[id];
            if(p != null)
            {
               delete this.mPopupsOpened[id];
            }
         }
      }
      
      public function getPopupOpened(id:String) : DCIPopup
      {
         var returnValue:DCIPopup = null;
         if(this.mPopupsOpened != null)
         {
            returnValue = this.mPopupsOpened[id];
         }
         return returnValue;
      }
   }
}
