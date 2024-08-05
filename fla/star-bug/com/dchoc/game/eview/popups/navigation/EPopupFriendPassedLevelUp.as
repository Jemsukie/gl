package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.messages.ENotificationWithImage;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.EMovieClip;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EPopupFriendPassedLevelUp extends ENotificationWithImage
   {
       
      
      private var mAnim:EMovieClip;
      
      private var mAnimLoaded:Boolean;
      
      private var mFriendBox:ESprite;
      
      private var mUserBox:ESprite;
      
      public function EPopupFriendPassedLevelUp()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var button:EButton = null;
         super.setup(popupId,viewFactory,skinId);
         setupBackground("PopL","pop_l");
         var body:ESprite = getContent("body");
         var img:EImage = mViewFactory.getEImage("generic_box",null,false,mBottomArea,"speech_color");
         body.eAddChild(img);
         setContent("textBkg",img);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerTextField");
         var tArea:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(layoutFactory.getTextArea("text_info"));
         var OFFSET:int = 8;
         tArea.x = mBottomArea.x + OFFSET / 2;
         tArea.y = mBottomArea.y + OFFSET / 2;
         tArea.width = mBottomArea.width - OFFSET;
         tArea.height = mBottomArea.height - OFFSET;
         var tf:ETextField = mViewFactory.getETextField(skinId,tArea,"text_body");
         body.eAddChild(tf);
         setContent("textfield",tf);
         var text:String = DCTextMng.replaceParameters(646,[InstanceMng.getUserInfoMng().getProfileLogin().getPlayerName()]);
         tf.setText(text);
         this.loadAnim();
         this.checkAnimLoaded();
         setTitleText(DCTextMng.getText(644));
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(0),0,"btn_accept");
         addButton("shareButton",button);
         button.eAddEventListener("click",notifyPopupMngClose);
      }
      
      public function loadAnim() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(mImageArea);
         area.pivotX = 0.5;
         area.pivotY = 0.5;
         setupImage("anim_lvlup_passfriend",area);
         this.mAnim = getContent("bigImage") as EMovieClip;
         this.mAnimLoaded = false;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ProfileBasic");
         var userInfo:UserInfo = getEvent()["friendsPassed"][0];
         this.mFriendBox = mViewFactory.getProfileInfoBasic(userInfo);
         this.mFriendBox.setLayoutArea(layoutFactory.getContainerLayoutArea());
         this.mFriendBox.setPivotLogicXY(0.5,0.5);
         userInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         this.mUserBox = mViewFactory.getProfileInfoBasic(userInfo);
         this.mUserBox.setLayoutArea(layoutFactory.getContainerLayoutArea());
         this.mUserBox.setPivotLogicXY(0.5,0.5);
      }
      
      private function checkAnimLoaded() : void
      {
         if(!this.mAnimLoaded && this.mAnim != null)
         {
            this.mAnimLoaded = this.mAnim.isTextureLoaded();
            if(this.mAnimLoaded)
            {
               this.mAnim.changeInstance("friend_box",this.mFriendBox);
            }
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         this.checkAnimLoaded();
         if(this.mAnim != null && this.mAnimLoaded)
         {
            this.mAnim.changeInstance("user_box",this.mUserBox);
            this.mAnim.changeInstance("friend_box",this.mFriendBox);
         }
      }
   }
}
