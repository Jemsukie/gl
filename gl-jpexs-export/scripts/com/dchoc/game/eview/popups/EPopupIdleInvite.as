package com.dchoc.game.eview.popups
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.hangar.EFriendView;
   import com.dchoc.game.eview.popups.messages.EPopupMessageIcons;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupIdleInvite extends EPopupMessageIcons
   {
      
      protected static const POPUP_IDLE_TYPE_IDLE:String = "PopupAfkTypeIdle";
      
      protected static const POPUP_IDLE_TYPE_TUTORIAL:String = "PopupAfkTypeTutorial";
      
      public static const NUM_FRIENDS:int = 4;
       
      
      private var mFriends:Vector.<UserInfo>;
      
      private var mFriendBox:Vector.<EFriendView>;
      
      private var mType:String;
      
      private var mIsIdle:Boolean;
      
      private var mHasToChangeToRefresh:Boolean;
      
      private var mOnClose:Function;
      
      public function EPopupIdleInvite(type:String)
      {
         super();
         this.mType = type;
         this.mIsIdle = type == "PopupAfkTypeIdle";
         this.mHasToChangeToRefresh = true;
      }
      
      public function build() : void
      {
         var icon:EImage = null;
         var button:EButton = null;
         var speechContent:ESpriteContainer = this.loadRandomFriends();
         setupPopup("orange_normal",DCTextMng.getText(3550),speechContent);
         var coinsImage:EImage = this.loadIcon("icon_coins");
         var mineralsImage:EImage = this.loadIcon("icon_minerals");
         var scoreImage:EImage = this.loadIcon("icon_score");
         var icons:Array = [coinsImage,mineralsImage,scoreImage];
         setupIcons(icons);
         setText(DCTextMng.getText(3551));
         for each(icon in icons)
         {
            icon.logicX = icon.logicX;
            icon.logicY = icon.logicY;
         }
         button = mViewFactory.getButton("btn_accept",mSkinSku,"M",DCTextMng.getText(3537));
         addButton("btn_accept",button);
         button.eAddEventListener("click",this.onButtonCenterClick);
         setCloseButtonVisible(true);
         getCloseButton().eAddEventListener("click",this.onClosePopup);
      }
      
      public function loadIcon(resourceID:String) : EImage
      {
         var image:EImage = mViewFactory.getEImage(resourceID,null,false);
         image.logicX = image.logicX;
         image.logicY = image.logicY;
         image.setPivotLogicXY(0.5,0.5);
         return image;
      }
      
      public function setOnCloseFunction(onClose:Function) : void
      {
         this.mOnClose = onClose;
      }
      
      private function callCloseFunction() : void
      {
         if(this.mOnClose != null)
         {
            this.mOnClose();
         }
      }
      
      private function onButtonCenterClick(e:EEvent) : void
      {
         var event:Object = {};
         if(this.mIsIdle)
         {
            if(!this.mHasToChangeToRefresh)
            {
               event.button = "EventCloseButtonPressed";
               this.onClosePopup(e);
               return;
            }
            getButton("btn_accept").setText(DCTextMng.getText(2903));
            this.mHasToChangeToRefresh = false;
         }
         else
         {
            this.closePopup();
         }
         this.openInviteTab();
      }
      
      private function loadRandomFriends() : ESpriteContainer
      {
         var friendsCount:int = 0;
         var i:int = 0;
         var box:EFriendView = null;
         var boxes:Array = null;
         var OFFSET:int = 20;
         var result:ESpriteContainer = mViewFactory.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerSpeechIcons");
         this.mFriends = InstanceMng.getUserInfoMng().getFriendsFromList(InstanceMng.getUserInfoMng().getNoPlayerFriendsList(),4);
         result.setLayoutArea(layoutFactory.getArea("area_icons"),true);
         if(this.mFriends != null)
         {
            if((friendsCount = int(this.mFriends.length)) > 0)
            {
               boxes = [];
               this.mFriendBox = new Vector.<EFriendView>(friendsCount,true);
               for(i = 0; i < friendsCount; )
               {
                  (box = new EFriendView(0)).build(this.mFriends[i]);
                  boxes.push(box);
                  result.eAddChild(box);
                  result.setContent("box" + i,box);
                  this.mFriendBox[i] = box;
                  i++;
               }
            }
            mViewFactory.distributeSpritesInArea(result.getLayoutArea(),boxes,1,1);
         }
         return result;
      }
      
      private function onClosePopup(e:EEvent) : void
      {
         this.closePopup();
      }
      
      private function closePopup() : void
      {
         this.callCloseFunction();
         InstanceMng.getPopupMng().closePopup(this);
      }
      
      private function openInviteTab() : void
      {
         InstanceMng.getApplication().setToWindowedMode();
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_OPEN_INVITE_TAB,{
            "src":"",
            "detail":""
         });
      }
   }
}
