package com.dchoc.game.eview.widgets.particles
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.friends.IFriendHelpBox;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.utils.EUtils;
   import esparragon.widgets.EButton;
   
   public class EFriendHelpBox extends ESpriteContainer implements IFriendHelpBox
   {
      
      private static const PICTURE:String = "img";
      
      private static const PICTURE_BKG:String = "profile_box";
      
      private static const TEXT:String = "text";
      
      private static const SPEECH_ARROW:String = "arrow";
      
      private static const SPEECH_BKG:String = "area";
      
      private static const BUTTON:String = "btn2";
      
      private static const BUTTON_ALL:String = "btn";
      
      private static const ON_OVER_BOX:String = "onOverBox";
      
      private static const STATE_IDLE:int = 0;
      
      private static const STATE_WAIT4INPUT:int = 1;
      
      private static const STATE_MOVING:int = 2;
      
      private static const STATE_CLICKING:int = 3;
      
      private static const STATE_FADEOUT:int = 4;
      
      private static const DEFAULT_TIME_WAIT:int = 1000;
      
      private static const ARRAY_INFO_SID:int = 0;
      
      private static const ARRAY_INFO_TIME:int = 1;
      
      private static const ARRAY_INFO_TEXT:int = 2;
      
      private static const ARRAY_INFO_LENGTH:int = 3;
       
      
      private var mState:int;
      
      private var mAccountId:String;
      
      private var mItemSid:String;
      
      private var mGoTo:DCCoordinate;
      
      private var mTimeLeft:int;
      
      private var mTooltipText:String;
      
      private var mOnOverBox:ESpriteContainer;
      
      private var mActionsStringVector:Vector.<String>;
      
      private var mUIIsEnabled:Boolean;
      
      public function EFriendHelpBox(accountId:String, user:UserInfo)
      {
         var bkg:EImage = null;
         var btn:EButton = null;
         var txt:ETextField = null;
         super();
         this.mAccountId = accountId;
         this.mGoTo = new DCCoordinate();
         this.mState = 1;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("BoxFriendHelp");
         bkg = viewFactory.getEImage("box_profile",null,false,layoutFactory.getArea("profile_box"),null);
         this.eAddChild(bkg);
         this.setContent("profile_box",bkg);
         (bkg = viewFactory.getEImageProfileFromURL(user.getThumbnailURL(),null,null)).setLayoutArea(layoutFactory.getArea("img"),true);
         this.eAddChild(bkg);
         this.setContent("img",bkg);
         this.mOnOverBox = viewFactory.getESpriteContainer();
         bkg = viewFactory.getEImage("tooltip_bkg",null,false,layoutFactory.getArea("area"));
         this.mOnOverBox.eAddChild(bkg);
         this.mOnOverBox.setContent("area",bkg);
         bkg = viewFactory.getEImage("tooltip_arrow",null,false,layoutFactory.getArea("arrow"));
         this.mOnOverBox.eAddChild(bkg);
         this.mOnOverBox.setContent("arrow",bkg);
         txt = viewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_body_3");
         txt.setText(DCTextMng.replaceParameters(235,[user.getPlayerFirstName()]));
         this.mOnOverBox.eAddChild(txt);
         this.mOnOverBox.setContent("text",txt);
         (btn = viewFactory.getButton("btn_accept",null,"S",DCTextMng.getText(0),null,layoutFactory.getArea("btn2"))).eAddEventListener("click",this.onAcceptHelpClick);
         this.mOnOverBox.eAddChild(btn);
         this.mOnOverBox.setContent("btn2",btn);
         (btn = viewFactory.getButton("btn_accept",null,"S",DCTextMng.getText(3471),null,layoutFactory.getArea("btn"))).eAddEventListener("click",this.onAcceptAll);
         this.mOnOverBox.eAddChild(btn);
         this.mOnOverBox.setContent("btn",btn);
         this.eAddChild(this.mOnOverBox);
         this.setContent("onOverBox",this.mOnOverBox);
         this.logicLeft = this.logicLeft;
         this.logicTop = this.logicTop;
         this.setPivotLogicXY(0.5,1);
         this.hideButtonsBox();
         this.uiSetIsEnabled(true);
      }
      
      public function setVisible(value:Boolean) : void
      {
         this.visible = value;
      }
      
      public function setItemSid(value:String) : void
      {
         this.mItemSid = value;
      }
      
      public function setX(x:Number) : void
      {
         this.logicLeft = x;
      }
      
      public function setY(y:Number) : void
      {
         this.logicTop = y;
      }
      
      public function uiSetIsEnabled(value:Boolean) : void
      {
         if(value)
         {
            this.addEventListeners();
         }
         else
         {
            this.removeEventListeners();
         }
         this.mUIIsEnabled = value;
      }
      
      private function addEventListeners() : void
      {
         if(!this.mUIIsEnabled)
         {
            this.eAddEventListener("rollOver",this.onRollOver);
            this.eAddEventListener("rollOut",this.onRollOut);
         }
      }
      
      private function removeEventListeners() : void
      {
         if(this.mUIIsEnabled)
         {
            this.eRemoveEventListener("rollOver",this.onRollOver);
            this.eRemoveEventListener("rollOut",this.onRollOut);
         }
      }
      
      public function hasEnded() : Boolean
      {
         return this.mState == 0;
      }
      
      public function hasStarted() : Boolean
      {
         return this.mState != 1;
      }
      
      public function addToDisplay() : void
      {
         InstanceMng.getViewMngGame().addParticle(this);
      }
      
      public function removeFromDisplay() : void
      {
         if(InstanceMng.getViewMngGame().contains(this) == true)
         {
            InstanceMng.getViewMngGame().removeParticle(this);
         }
      }
      
      private function hideButtonsBox() : void
      {
         this.mOnOverBox.visible = false;
      }
      
      private function showButtonsBox() : void
      {
         this.removeFromDisplay();
         this.addToDisplay();
         this.mOnOverBox.visible = true;
      }
      
      public function startMoving() : void
      {
         if(this.mActionsStringVector == null)
         {
            return;
         }
         this.performNextAction();
      }
      
      private function performNextAction() : void
      {
         var action:String = this.mActionsStringVector.shift();
         this.performAction(action);
      }
      
      private function performAction(action:String) : void
      {
         if(action == "" && this.mActionsStringVector.length == 0)
         {
            this.mTimeLeft = 1000;
            this.mState = 4;
            return;
         }
         var info:Array = action.split(":");
         if(info.length < 3)
         {
            this.performNextAction();
            return;
         }
         this.mItemSid = info[0];
         this.mTooltipText = info[2];
         var item:WorldItemObject = InstanceMng.getWorld().itemsGetItemBySid(this.mItemSid);
         if(item == null)
         {
            this.performNextAction();
         }
         else
         {
            this.mGoTo.x = item.mViewCenterWorldX;
            this.mGoTo.y = item.mViewCenterWorldY;
            this.mTimeLeft = 1000;
            this.mState = 2;
         }
      }
      
      private function getServerDataArr() : Array
      {
         var actionStr:String = null;
         var arr:Array = null;
         var returnArr:Array = [];
         for each(actionStr in this.mActionsStringVector)
         {
            if(actionStr != "")
            {
               arr = actionStr.split(":");
               returnArr.push({
                  "sid":parseInt(arr[0]),
                  "acceleratedTime":parseFloat(arr[1])
               });
            }
         }
         if(returnArr.length == 0)
         {
            returnArr = null;
         }
         return returnArr;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var wio:WorldItemObject = null;
         super.logicUpdate(dt);
         if(this.mState == 0)
         {
            return;
         }
         if(this.mState == 1)
         {
            wio = InstanceMng.getWorld().itemsGetItemBySid(this.mItemSid);
            if(wio != null && (wio.mViewCenterWorldX != this.logicLeft || wio.mViewCenterWorldY != this.logicTop))
            {
               this.setX(wio.mViewCenterWorldX);
               this.setY(wio.mViewCenterWorldY);
            }
            return;
         }
         this.mTimeLeft -= dt;
         var endOfState:Boolean = false;
         if(this.mTimeLeft < 0)
         {
            this.mTimeLeft = 0;
            endOfState = true;
         }
         if(this.mState == 2)
         {
            this.logicLeft = this.logicLeft * this.mTimeLeft * 0.001 + this.mGoTo.x * (1 - this.mTimeLeft * 0.001);
            this.logicTop = this.logicTop * this.mTimeLeft * 0.001 + this.mGoTo.y * (1 - this.mTimeLeft * 0.001);
            if(endOfState)
            {
               this.mState = 3;
               this.mTimeLeft = 1000 * 0.5;
            }
            return;
         }
         if(this.mState == 3)
         {
            if(endOfState)
            {
               InstanceMng.getVisitorMng().buildingsPerformFriendAction(this.mItemSid,this.mTooltipText);
               this.performNextAction();
            }
            return;
         }
         if(this.mState == 4)
         {
            this.alpha = this.mTimeLeft * 0.001;
            if(endOfState)
            {
               this.mState = 0;
            }
            return;
         }
      }
      
      private function onRollOver(e:EEvent) : void
      {
         InstanceMng.getMapView().uiDisable();
         this.showButtonsBox();
         InstanceMng.getVisitorMng().buildingsHighlightActionsBuildings(this.mAccountId,true);
      }
      
      private function onRollOut(e:EEvent) : void
      {
         InstanceMng.getMapView().uiEnable();
         this.hideButtonsBox();
         InstanceMng.getVisitorMng().buildingsHighlightActionsBuildings(this.mAccountId,false);
      }
      
      private function onAcceptHelpClick(e:EEvent = null) : void
      {
         this.onRollOut(e);
         this.uiSetIsEnabled(false);
         if(this.mAccountId == null)
         {
            this.onRejectHelpClick(e);
            return;
         }
         var actionsString:String = InstanceMng.getVisitorMng().buildingsApplyUserActions(this.mAccountId);
         var arr:Array = actionsString.split(";");
         this.mActionsStringVector = EUtils.array2VectorString(arr);
         var serverDataArr:Array = this.getServerDataArr();
         InstanceMng.getUserDataMng().updateMisc_visitHelpDone(this.mAccountId,true,serverDataArr);
         this.startMoving();
      }
      
      private function onRejectHelpClick(e:EEvent) : void
      {
         this.onRollOut(e);
         this.uiSetIsEnabled(false);
         this.mTimeLeft = 1000;
         this.mState = 4;
         if(this.mAccountId == null)
         {
            return;
         }
         InstanceMng.getUserDataMng().updateMisc_visitHelpDone(this.mAccountId,false);
      }
      
      public function onAcceptThis() : void
      {
         this.onAcceptHelpClick();
      }
      
      private function onAcceptAll(e:EEvent) : void
      {
         InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupConfirmAcceptHelp",DCTextMng.getText(3063),DCTextMng.getText(3698),"npc_A_normal",DCTextMng.getText(1),null,function():void
         {
            InstanceMng.getVisitorMng().buildingsApplyAllUserActions();
         },null);
      }
   }
}
