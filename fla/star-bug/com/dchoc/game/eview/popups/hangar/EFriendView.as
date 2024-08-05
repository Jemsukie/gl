package com.dchoc.game.eview.popups.hangar
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EFriendView extends ESpriteContainer
   {
      
      public static const USE_INVITE:int = 0;
      
      public static const USE_THANK:int = 1;
      
      public static const USE_TRAIN:int = 2;
      
      private static const BKG:String = "container_box";
      
      private static const THUMBNAIL:String = "img";
      
      private static const BUTTON:String = "btn_xs";
       
      
      private var mLayoutName:String;
      
      private var mUserInfo:UserInfo;
      
      private var mUse:int;
      
      private var mOnClickTask:String;
      
      private var mButtonText:String;
      
      public function EFriendView(_use:int)
      {
         super();
         this.mLayoutName = "BoxFriendButton";
         this.mUse = _use;
         if(this.mUse == 0)
         {
            this.mOnClickTask = "buttonPressedInviteFriend";
            this.mButtonText = DCTextMng.getText(2810);
         }
         else if(this.mUse == 2)
         {
            this.mOnClickTask = "buttonPressedTrainFriend";
            this.mButtonText = DCTextMng.getText(3111);
         }
      }
      
      public function build(userInfo:UserInfo) : void
      {
         var name:ETextField = null;
         var button:EButton = null;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var layoutFactory:ELayoutAreaFactory = null;
         var thumbnail:EImage = null;
         var playerName:String = null;
         var s:ESprite = null;
         if(this.mUse == 1)
         {
            layoutFactory = viewFactory.getLayoutAreaFactory("ProfileBasic");
            if(userInfo)
            {
               thumbnail = viewFactory.getEImageProfileFromURL(userInfo.getThumbnailURL(),null,null);
               playerName = userInfo.getPlayerFirstName();
            }
            else
            {
               thumbnail = viewFactory.getEImageProfileFromURL(null,null,null);
               playerName = "";
            }
            s = viewFactory.getEImage("box_profile",null,false,layoutFactory.getArea("container_box"),null);
            eAddChild(s);
            setContent("container_box",s);
            (s = thumbnail).setLayoutArea(layoutFactory.getArea("img"),true);
            eAddChild(s);
            setContent("img",s);
            s.logicY += 10;
            s = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_title_3");
            eAddChild(s);
            setContent("text_name",s);
            (name = getContentAsETextField("text_name")).setText(playerName);
            name.logicY += 10;
         }
         else
         {
            this.mUserInfo = userInfo;
            layoutFactory = viewFactory.getLayoutAreaFactory(this.mLayoutName);
            s = viewFactory.getEImage("box_profile",null,false,layoutFactory.getArea("container_box"));
            eAddChild(s);
            setContent("container_box",s);
            if(userInfo)
            {
               thumbnail = viewFactory.getEImageProfileFromURL(userInfo.getThumbnailURL(),null,null);
            }
            else
            {
               thumbnail = viewFactory.getEImageProfileFromURL(null,null,null);
            }
            thumbnail.setLayoutArea(layoutFactory.getArea("img"),true);
            eAddChild(thumbnail);
            setContent("img",thumbnail);
            button = viewFactory.getButton("btn_social",null,"XS",this.mButtonText);
            button.setLayoutArea(layoutFactory.getArea("btn_xs"),true);
            button.eAddEventListener("click",this.onButtonClick);
            eAddChild(button);
            setContent("btn_xs",button);
         }
      }
      
      private function onButtonClick(evt:EEvent) : void
      {
         var params:Dictionary = null;
         var data:Object = null;
         if(this.mUse == 1)
         {
            params = new Dictionary();
            params["accountID"] = !!this.mUserInfo ? this.mUserInfo.getAccountId() : null;
            params["extID"] = !!this.mUserInfo ? this.mUserInfo.getExtId() : null;
            MessageCenter.getInstance().sendMessage(this.mOnClickTask,params);
         }
         else if(this.mUse == 0)
         {
            data = {
               "platform":InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlatform(),
               "platformId":this.mUserInfo.getExtId()
            };
            data.detail = "idlePopup";
            data.src = "vir_invitefriend";
            InstanceMng.getApplication().setToWindowedMode();
            InstanceMng.getUserDataMng().requestTask("inviteIndividualFriend",data);
            this.mUserInfo.setInviteRequestSent();
            getContentAsEButton("btn_xs").setText(DCTextMng.getText(80));
            if(Config.USE_METRICS)
            {
               DCMetrics.sendMetric("Invite","Started","individual","idlePopup");
            }
         }
         else if(this.mUse == 2)
         {
            InstanceMng.getInvestMng().sendInvestRequestToFriend(this.mUserInfo);
         }
         this.setButtonEnabled(false);
      }
      
      public function setButtonEnabled(value:Boolean) : void
      {
         getContent("btn_xs").setIsEnabled(value);
      }
   }
}
