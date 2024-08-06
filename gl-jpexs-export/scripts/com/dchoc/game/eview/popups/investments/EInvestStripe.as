package com.dchoc.game.eview.popups.investments
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.invests.Invest;
   import com.dchoc.game.model.invests.InvestMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.gskinner.motion.GTween;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EInvestStripe extends ESpriteContainer
   {
       
      
      private const TEXT_NAME:String = "textName";
      
      private const BACKGROUND:String = "background";
      
      private const PROFILE_PICTURE:String = "profilePicture";
      
      private var mViewFactory:ViewFactory;
      
      private var mInvest:Invest;
      
      private var mUserInfo:UserInfo;
      
      private var mButtonArea:ELayoutArea;
      
      private var mCloseArea:ELayoutArea;
      
      private var mXInit:Number;
      
      private var mPosInList:int;
      
      private var mParentTab:EInvestTrainees;
      
      public function EInvestStripe(parentTab:EInvestTrainees)
      {
         super();
         this.mViewFactory = InstanceMng.getViewFactory();
         this.mParentTab = parentTab;
      }
      
      public function setup(userInfo:UserInfo, invest:Invest) : void
      {
         var levelGoal:int = 0;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("StripeInvestments");
         this.mInvest = invest;
         this.mUserInfo = userInfo;
         this.mButtonArea = layoutFactory.getArea("btn");
         this.mCloseArea = layoutFactory.getArea("btn_close");
         var img:EImage = this.mViewFactory.getEImage("stripe",null,false,layoutFactory.getArea("stripe"));
         eAddChild(img);
         setContent("background",img);
         var dataStr:* = this.mUserInfo == null ? "UNKNOWN" : this.mUserInfo.getPlayerName();
         var field:ETextField = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_header");
         eAddChild(field);
         setContent("textName",field);
         field.setText(dataStr);
         dataStr = this.mUserInfo == null ? null : this.mUserInfo.getThumbnailURL();
         img = this.mViewFactory.getEImageProfileFromURL(dataStr,null,null);
         img.layoutApplyTransformations(layoutFactory.getArea("img_profile"));
         eAddChild(img);
         setContent("profilePicture",img);
         dataStr = this.mUserInfo == null ? "0" : this.mUserInfo.getLevel().toString();
         var content:ESpriteContainer;
         (content = this.mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_score_level",dataStr,null,"text_score")).layoutApplyTransformations(layoutFactory.getArea("icon_text"));
         setContent("userLevel",content);
         eAddChild(content);
         switch(this.mInvest.getState())
         {
            case 0:
               dataStr = DCTextMng.getText(3134);
               break;
            case 1:
               levelGoal = InstanceMng.getInvestsSettingsDefMng().getLevelGoal();
               dataStr = (dataStr = (dataStr = DCTextMng.replaceParameters(3124,[this.mInvest.getLevel() + "/" + levelGoal])) + "\n") + DCTextMng.replaceParameters(3123,[GameConstants.getTimeTextFromMs(this.mInvest.getGoalTimeLeft())]);
               break;
            case 2:
               dataStr = DCTextMng.getText(3125);
               break;
            case 3:
               dataStr = DCTextMng.getText(3122);
         }
         (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_body_2")).setText(dataStr);
         eAddChild(field);
         setContent("description",field);
         this.setupButtons();
      }
      
      private function setupButtons() : void
      {
         var buttonText:String = null;
         var buttonAction:Function = null;
         var resource:String = null;
         var button:EButton = null;
         var closeButton:Boolean = false;
         var isEnabled:* = true;
         switch(this.mInvest.getState())
         {
            case 0:
               buttonText = DCTextMng.getText(3116);
               resource = "btn_social";
               isEnabled = this.mInvest.getRemindTimeLeft() <= 0;
               buttonAction = this.onRemindClick;
               closeButton = true;
               break;
            case 1:
               buttonText = DCTextMng.getText(3115);
               resource = "btn_social";
               isEnabled = this.mInvest.getRemindTimeLeft() <= 0;
               buttonAction = this.onRemindClick;
               break;
            case 2:
               buttonText = DCTextMng.getText(3114);
               resource = "btn_accept";
               buttonAction = this.onClaimClick;
               break;
            case 3:
               closeButton = true;
         }
         button = getContentAsEButton("button");
         if(button != null)
         {
            button.destroy();
            button = null;
         }
         if(buttonText != null)
         {
            button = this.mViewFactory.getButtonByTextWidth(buttonText,this.mButtonArea.width,resource);
            button.layoutApplyTransformations(this.mButtonArea);
            eAddChild(button);
            setContent("button",button);
            button.setIsEnabled(isEnabled);
            button.eAddEventListener("click",buttonAction);
         }
         button = this.mViewFactory.getButtonClose(null,this.mCloseArea);
         eAddChild(button);
         setContent("closeButton",button);
         button.eAddEventListener("click",this.onCancelClick);
         button.visible = closeButton;
      }
      
      public function setPosInList(pos:int) : void
      {
         this.mPosInList = pos;
      }
      
      private function autoRemove(onCompleteFunction:Function) : void
      {
         this.mXInit = logicLeft;
         var XYCoord:DCCoordinate = MyUnit.smCoor;
         var factor:Number = this.mPosInList % 2 == 0 ? 1 : -1;
         XYCoord.x = logicLeft + getLogicWidth() * factor;
         XYCoord.y = logicTop;
         TweenEffectsFactory.createTranslation(this,XYCoord,0,0.2,null,true,onCompleteFunction);
      }
      
      private function onRemindClick(e:EEvent) : void
      {
         InstanceMng.getInvestMng().remindInvest(this.mInvest);
         var button:EButton = getContentAsEButton("button");
         if(button != null)
         {
            button.setIsEnabled(false);
         }
      }
      
      private function onClaimClick(e:EEvent) : void
      {
         this.autoRemove(this.doClaimReward);
      }
      
      private function onCancelClick(e:EEvent) : void
      {
         this.autoRemove(this.doCancel);
      }
      
      private function doClaimReward(g:GTween) : void
      {
         var investMng:InvestMng = InstanceMng.getInvestMng();
         investMng.applyResult(this.mInvest);
         investMng.guiOpenInvestRewardPopup(this.mInvest);
      }
      
      private function doCancel(g:GTween) : void
      {
         InstanceMng.getInvestMng().cancelInvest(this.mInvest);
      }
      
      private function rebuildInvests() : void
      {
         logicLeft = this.mXInit;
         this.mParentTab.getInvestsBoxes();
         alpha = 1;
      }
   }
}
