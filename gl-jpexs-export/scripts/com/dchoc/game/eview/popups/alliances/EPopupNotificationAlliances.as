package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.messages.ENotificationWithImage;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupNotificationAlliances extends ENotificationWithImage
   {
       
      
      private const OK_BUTTON:String = "okButton";
      
      private var mCurrentMusic:String;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mAdvisor:String;
      
      public function EPopupNotificationAlliances()
      {
         super();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
      }
      
      public function setupPopup(params:Object) : void
      {
         var title:String = null;
         var text:String = null;
         var img:String = null;
         var btn:String = null;
         var button:EButton = null;
         var action:Function = null;
         setupBackground("PopL","pop_l");
         var hasCloseButton:Boolean = false;
         setEvent(params);
         var enemyAllianceName:String = String(params["allianceName"]);
         if(params["alreadyAtWar"])
         {
            enemyAllianceName = this.mAllianceController.getEnemyAlliance().getName();
         }
         this.mCurrentMusic = null;
         var actionOnClose:Function = this.onCloseClick;
         switch(params["cmd"])
         {
            case "NOTIFY_ALLIANCES_WELCOME_POPUP":
               title = DCTextMng.getText(2953);
               text = String(params["body"]);
               btn = DCTextMng.getText(7);
               action = this.closeAndOpenAlliancePopupClick;
               this.mAdvisor = "alliance_council_happy";
               img = "cutscene_alliances_presentation";
               if(Config.USE_SOUNDS)
               {
                  this.mCurrentMusic = SoundManager.getInstance().getLastMusic();
                  SoundManager.getInstance().pauseAll();
                  SoundManager.getInstance().playSound("allianceintro.mp3",1,0,0,0);
               }
               break;
            case "NOTIFY_ALLIANCES_NOT_ENOUGH_LEVEL_POPUP":
               title = DCTextMng.getText(2953);
               btn = DCTextMng.getText(7);
               text = String(params["body"]);
               action = this.onCloseClick;
               this.mAdvisor = "alliance_council_happy";
               img = "cutscene_alliances_presentation";
               if(Config.USE_SOUNDS)
               {
                  this.mCurrentMusic = SoundManager.getInstance().getLastMusic();
                  SoundManager.getInstance().pauseAll();
                  SoundManager.getInstance().playSound("allianceintro.mp3",1,0,0,0);
               }
               break;
            case "NOTIFY_ALLIANCES_CURRENT_WAR_WIN":
               title = DCTextMng.getText(2998);
               text = params["endByKO"] == true ? DCTextMng.getText(3047) : DCTextMng.getText(2999);
               hasCloseButton = true;
               button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(7),0,"btn_social");
               button.eAddEventListener("click",this.closeAndOpenAlliancePopupClick);
               addButton("publish",button);
               this.mAdvisor = "alliance_council_happy";
               img = "cutscene_alliances_war_won";
               if(Config.USE_SOUNDS)
               {
                  this.mCurrentMusic = SoundManager.getInstance().getLastMusic();
                  SoundManager.getInstance().pauseAll();
                  SoundManager.getInstance().playSound("warwon.mp3",1,0,0,0);
               }
               break;
            case "NOTIFY_ALLIANCES_CURRENT_WAR_LOSE":
               title = DCTextMng.getText(2998);
               btn = DCTextMng.getText(0);
               text = params["endByKO"] == true ? DCTextMng.getText(3048) : DCTextMng.getText(3000);
               this.mAdvisor = "alliance_council_war";
               action = this.onCloseClick;
               img = "cutscene_alliances_war_lost";
               break;
            case "NOTIFY_ALLIANCES_DECLARE_WAR":
               this.mAdvisor = "alliance_council_war";
               img = "cutscene_alliances_war_declared";
               title = DCTextMng.getText(2995);
               text = DCTextMng.replaceParameters(2996,[enemyAllianceName]);
               btn = DCTextMng.getText(7);
               action = this.closeAndOpenAlliancePopupClick;
               hasCloseButton = true;
         }
         if(btn != null)
         {
            button = mViewFactory.getButtonByTextWidth(btn,0,"btn_accept");
            button.eAddEventListener("click",action);
            addButton("okButton",button);
         }
         setTitleText(title);
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(mImageArea);
         area.pivotX = 0.5;
         area.pivotY = 0.5;
         setupImage(img,area);
         this.setupNotification(text,this.mAdvisor);
         if(hasCloseButton)
         {
            button = getCloseButton();
            button.visible = true;
            button.eRemoveAllEventListeners("click");
            button.eAddEventListener("click",closeAndOpenAlliancePopupClick);
         }
      }
      
      private function setupNotification(text:String, advisor:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutNotificationAlliances");
         var container:ESpriteContainer = new ESpriteContainer();
         var body:ESprite = getContent("body");
         var img:EImage = mViewFactory.getEImage(advisor,null,true,layoutFactory.getArea("cbox_img"));
         container.setContent("image",img);
         container.eAddChild(img);
         var arrowArea:ELayoutArea = layoutFactory.getArea("arrow");
         img = mViewFactory.getEImage("speech_arrow",null,false,arrowArea,"speech_color");
         container.setContent("speechArrow",img);
         var content:ESpriteContainer = mViewFactory.getContentOneText("ContainerTextField",text,"text_body",null);
         container.setContent("speechText",content);
         var speechBox:ESprite = mViewFactory.getSpeechBubble(layoutFactory.getArea("area_speech"),arrowArea,content,null,"speech_color");
         container.setContent("speechBox",speechBox);
         container.eAddChild(img);
         container.eAddChild(speechBox);
         container.eAddChild(content);
         setContent("notification",container);
         body.eAddChild(container);
         container.layoutApplyTransformations(mBottomArea);
      }
      
      private function closeAndOpenAlliancePopupClick(e:EEvent) : void
      {
         this.onCloseClick(e);
         if(this.mAllianceController.isPopupAlliancesBeingShown())
         {
            EPopupAlliances(this.mAllianceController.getPopupAlliance()).reloadPopup();
         }
         else
         {
            this.mAllianceController.openPopupDependingOnSituation();
         }
      }
      
      private function onDeclareWarOk(e:EEvent) : void
      {
         var button:EButton = getContentAsEButton("okButton");
         button.setIsEnabled(false);
         this.setupNotification(DCTextMng.getText(3022),this.mAdvisor);
         InstanceMng.getAlliancesController().declareWar(getEvent()["allianceId"],this.callbackDeclareWar,this.callbackDeclareWar,true);
      }
      
      private function onPublishDeclaredWar(e:EEvent) : void
      {
         this.closeAndOpenAlliancePopupClick(e);
         var myAlli:Alliance = this.mAllianceController.getMyAlliance();
      }
      
      private function callbackDeclareWar(e:AlliancesAPIEvent) : void
      {
         var button:EButton = null;
         var popup:EPopupAlliances = null;
         var text:String = "";
         var success:*;
         if(success = e.type == "alliance_api_success")
         {
            if(e.alliance != null)
            {
               e.alliance.setPostWarShield(0);
            }
            popup = this.mAllianceController.getPopupAlliance() as EPopupAlliances;
            if(popup)
            {
               popup.setTabPage(1);
            }
            text = DCTextMng.replaceParameters(2996,[InstanceMng.getAlliancesController().getEnemyAlliance().getName()]);
            this.setupNotification(text,this.mAdvisor);
            removeButton("okButton");
            button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(7),0,"btn_social");
            addButton("publish",button);
            button.eAddEventListener("click",this.onPublishDeclaredWar);
            if(Config.USE_SOUNDS)
            {
               this.mCurrentMusic = SoundManager.getInstance().getLastMusic();
               SoundManager.getInstance().pauseAll();
               SoundManager.getInstance().playSound("alliancewarintro.mp3",1,0,0,0);
            }
         }
         else
         {
            text = e.getErrorMsg();
            this.setupNotification(text,this.mAdvisor);
            button = getContentAsEButton("okButton");
            button.setText(DCTextMng.getText(8));
            button.setIsEnabled(true);
            button.eRemoveAllEventListeners("click");
            button.eAddEventListener("click",this.onCloseClick);
         }
      }
      
      override protected function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
