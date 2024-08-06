package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.geom.Point;
   
   public class EPopupAlliances extends EGamePopup
   {
       
      
      private const BODY:String = "Body";
      
      private const BODY_CONTENT:String = "BodyContent";
      
      private const SEARCH_TIME_WAIT:int = 5000;
      
      private var mUserAlliance:Alliance;
      
      private var mActionsTooltip:EActionsTooltip;
      
      private var mActionsButtonActivated:ESprite;
      
      private var mCloseActions:Boolean;
      
      private var mReloadPopup:Boolean;
      
      private var mSearchTimer:int;
      
      public function EPopupAlliances()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.destroyActionsTooltip();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground();
         this.setupBody();
      }
      
      private function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXLNoTabsNoFooter");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(img);
         setBackground(img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_header");
         img.eAddChild(field);
         setTitle(field);
         field.setText(DCTextMng.getText(2899));
         var button:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         img.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",this.onClosePopup);
         var body:ESprite = mViewFactory.getESprite(mSkinSku,layoutFactory.getArea("body"));
         img.eAddChild(body);
         setContent("Body",body);
         button = mViewFactory.getButtonImage("btn_info",null,layoutFactory.getArea("btn_info"));
         img.eAddChild(button);
         setContent("infoButton",button);
         button.eAddEventListener("click",this.onHelpButton);
      }
      
      public function setupBody() : void
      {
         var content:ESpriteContainer = null;
         var body:ESprite = null;
         var bkg:ESprite = null;
         this.mUserAlliance = InstanceMng.getAlliancesController().getMyAlliance();
         if(this.mUserAlliance == null)
         {
            body = getContent("Body");
            content = new EContentJoinToAlliance(mViewFactory,mSkinSku);
            EContentJoinToAlliance(content).build();
            body.eAddChild(content);
         }
         else
         {
            bkg = getBackground();
            content = new EContentAllianceOwner();
            EContentAllianceOwner(content).build();
            bkg.eAddChild(content);
         }
         setContent("BodyContent",content);
      }
      
      public function openActionsTooltip(memberBox:EAllianceMemberMyAlliance, member:AlliancesUser) : void
      {
         var p:Point = null;
         this.destroyActionsTooltip();
         var button:ESprite = memberBox.getContent("actionButton");
         if(this.mActionsButtonActivated != button)
         {
            this.mActionsTooltip = new EActionsTooltip(memberBox,member);
            this.mActionsTooltip.build();
            eAddChild(this.mActionsTooltip);
            p = new Point(button.logicLeft,button.logicTop);
            p = button.parent.localToGlobal(p);
            p = globalToLocal(p);
            this.mActionsTooltip.logicTop = p.y - this.mActionsTooltip.getLogicHeight();
            this.mActionsTooltip.logicLeft = p.x + (button.width - this.mActionsTooltip.width) / 2;
            this.mActionsButtonActivated = button;
         }
         else
         {
            this.mActionsButtonActivated = null;
         }
      }
      
      public function destroyActionsTooltip() : void
      {
         if(this.mActionsTooltip != null)
         {
            this.mActionsTooltip.destroy();
            this.mActionsTooltip = null;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mCloseActions)
         {
            this.destroyActionsTooltip();
            this.mActionsButtonActivated = null;
            this.mCloseActions = false;
         }
         if(this.mReloadPopup)
         {
            this.setupBody();
            this.mReloadPopup = false;
         }
         if(this.mSearchTimer > 0)
         {
            this.mSearchTimer -= dt;
            if(this.mSearchTimer < 0)
            {
               this.mSearchTimer = 0;
            }
         }
      }
      
      public function closeActionsTooltip() : void
      {
         this.mCloseActions = true;
      }
      
      public function reloadPopup() : void
      {
         this.mCloseActions = true;
         this.mReloadPopup = true;
      }
      
      public function setTabPage(id:int) : void
      {
         var content:EContentAllianceOwner = null;
         if(this.mUserAlliance != null)
         {
            content = getContent("BodyContent") as EContentAllianceOwner;
            content.setPageIdForced(id);
         }
      }
      
      public function canDoSearch(newWord:String, oldWord:String) : Boolean
      {
         if(newWord == oldWord && this.mSearchTimer > 0)
         {
            return false;
         }
         this.mSearchTimer = 5000;
         return true;
      }
      
      private function onClosePopup(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onHelpButton(e:EEvent) : void
      {
         AlliancesControllerStar(InstanceMng.getAlliancesController()).guiOpenAlliancesHelpPopup();
      }
   }
}
