package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.rule.AlliancesWarTypesDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   
   public class EAllianceWarPage extends ESpriteContainer
   {
      
      private static const TIMER_BOX:String = "timerBox";
       
      
      private var mUserAlliance:Alliance;
      
      private var mEnemyAlliance:Alliance;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mAdvisorArea:ELayoutArea;
      
      private var mIsInWar:Boolean;
      
      public function EAllianceWarPage()
      {
         super();
      }
      
      public function build() : void
      {
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.mUserAlliance = this.mAllianceController.getMyAlliance();
         this.mEnemyAlliance = this.mAllianceController.getEnemyAlliance();
         if(this.mUserAlliance.isInAWar())
         {
            this.buildAtWar();
            this.mIsInWar = true;
         }
         else
         {
            if(Config.useAlliancesSuggested() && AlliancesConstants.canRoleDeclareWar(this.mAllianceController.getMyUser().getRole()))
            {
               this.buildSuggestedAlliances();
            }
            else
            {
               this.buildNoWar();
            }
            this.mIsInWar = false;
         }
      }
      
      private function buildAtWar() : void
      {
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutBodyAllianceWar");
         var logo:Array = this.mUserAlliance.getLogo();
         var img:ESprite = this.mAllianceController.getAllianceFlag(logo[0],logo[1],logo[2],layoutFactory.getArea("you"));
         setContent("userFlag",img);
         eAddChild(img);
         logo = this.mEnemyAlliance.getLogo();
         img = this.mAllianceController.getAllianceFlag(logo[0],logo[1],logo[2],layoutFactory.getArea("enemy"));
         setContent("enemyFlag",img);
         eAddChild(img);
         var field:ETextField;
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_subheader")).setText(this.mUserAlliance.getName());
         eAddChild(field);
         setContent("userAllianceName",field);
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name_enemy"),"text_subheader")).setText(this.mEnemyAlliance.getName());
         eAddChild(field);
         setContent("enemyAllianceName",field);
         var text:String = DCTextMng.convertNumberToString(this.mUserAlliance.getCurrentWarScore(),1,8);
         img = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_user_warpoints",text,null,"text_body_2");
         setContent("allianceWarPoints",img);
         eAddChild(img);
         layoutFactory.getArea("icon_text").centerContent(img);
         text = DCTextMng.convertNumberToString(this.mEnemyAlliance.getCurrentWarScore(),1,8);
         img = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_user_warpoints",text,null,"text_body_2");
         setContent("enemyWarPoints",img);
         eAddChild(img);
         layoutFactory.getArea("icon_text_enemy").centerContent(img);
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_ko_player"),"text_subheader")).setText(DCTextMng.getText(3052));
         eAddChild(field);
         setContent("KO1",field);
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_ko_enemy"),"text_subheader")).setText(DCTextMng.getText(3052));
         eAddChild(field);
         setContent("KO2",field);
         var timerArea:ELayoutArea = layoutFactory.getArea("container_timer");
         img = viewFactory.getEImage("area_timer",null,false,timerArea);
         eAddChild(img);
         setContent("timerBkg",img);
         var container:ESpriteContainer = viewFactory.getContentIconWithTextHorizontal("IconTextXSLarge","icon_clock","00:00:00.",null,"text_subheader");
         eAddChild(container);
         setContent("timerBox",container);
         timerArea.centerContent(container);
         var OFFSET:int = 6;
         var fillbarArea:ELayoutArea = layoutFactory.getArea("bar_xxl");
         img = viewFactory.createFillBar(0,fillbarArea.width,fillbarArea.height,0,"color_fill_bkg");
         setContent("fillbarBkg",img);
         eAddChild(img);
         fillbarArea.centerContent(img);
         var KOBAR_VALUE_MAX:int = 100;
         var KOBAR_VALUE_MIN:int = -100;
         var fillbar:EFillBar = viewFactory.createFillBar(0,fillbarArea.width - OFFSET,fillbarArea.height - OFFSET,0,"color_ko_bar_enemy");
         eAddChild(fillbar);
         setContent("fillbarFillEnemy",fillbar);
         fillbarArea.centerContent(fillbar);
         fillbar = viewFactory.createFillBar(0,fillbarArea.width - OFFSET,fillbarArea.height - OFFSET,KOBAR_VALUE_MAX,"color_ko_bar");
         setContent("fillbarFill",fillbar);
         eAddChild(fillbar);
         fillbarArea.centerContent(fillbar);
         fillbar.setMinValue(KOBAR_VALUE_MIN);
         fillbar.setValue(this.mUserAlliance.getCurrentWarKnockoutPoints());
         this.mAllianceController.requestAllianceById(this.mEnemyAlliance.getId(),true,this.requestEnemyAllianceSuccess,null,true);
         var scrollArea:EScrollArea;
         (scrollArea = new EScrollArea()).build(layoutFactory.getArea("members"),this.mUserAlliance.getTotalMembers(),ESpriteContainer,this.loadMemberStripes);
         viewFactory.getEScrollBar(scrollArea);
         setContent("scrollAreaAlliance",scrollArea);
         eAddChild(scrollArea);
      }
      
      private function loadEnemyMemberStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EAllianceMemberEnemyAlliance = null;
         if(rebuild)
         {
            (stripe = new EAllianceMemberEnemyAlliance()).build();
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         (stripe = spriteReference.getChildAt(0) as EAllianceMemberEnemyAlliance).setInfo(this.mEnemyAlliance.getMemberByIndex(rowOffset,2));
      }
      
      private function loadMemberStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EAllianceWarMember = null;
         if(rebuild)
         {
            (stripe = new EAllianceWarMember()).build();
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         (stripe = spriteReference.getChildAt(0) as EAllianceWarMember).setInfo(this.mUserAlliance.getMemberByIndex(rowOffset,2));
      }
      
      private function buildNoWar() : void
      {
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("PopNotifications");
         var container:ESpriteContainer = new ESpriteContainer();
         eAddChild(container);
         setContent("containernowar",container);
         var area:ELayoutArea = layoutFactory.getArea("cbox_img");
         this.mAdvisorArea = area;
         var img:EImage = viewFactory.getEImage("alliance_council_angry",null,false);
         container.eAddChild(img);
         container.setContent("advisor",img);
         img.onSetTextureLoaded = this.centerAdvisor;
         var areaArrow:ELayoutArea = layoutFactory.getArea("arrow");
         img = viewFactory.getEImage("speech_arrow",null,false,areaArrow,"speech_color");
         container.setContent("arrow",img);
         container.eAddChild(img);
         var content:ESpriteContainer = viewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(2940),"text_body",null);
         setContent("message",content);
         var speechBox:ESprite = viewFactory.getSpeechBubble(layoutFactory.getArea("area_speech"),areaArrow,content,null,"speech_color");
         setContent("speechBox",speechBox);
         container.eAddChild(speechBox);
         container.eAddChild(content);
         area = (layoutFactory = viewFactory.getLayoutAreaFactory("LayoutBodyAllianceWar")).getContainerLayoutArea();
         container.logicLeft = area.x + (area.width - container.width) / 2;
         container.logicTop = area.y + (area.height - container.height) / 2;
      }
      
      private function buildSuggestedAlliances() : void
      {
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var count:int = 0;
         var box:ESpriteContainer = null;
         var boxes:Array = null;
         var i:int = 0;
         var defs:Vector.<DCDef> = InstanceMng.getAlliancesWarTypesDefMng().getDefs();
         if(defs != null)
         {
            layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutBodyAllianceWar");
            count = int(defs.length);
            boxes = [];
            for(i = 0; i < count; )
            {
               box = this.createSuggestionBox(defs[i] as AlliancesWarTypesDef);
               boxes.push(box);
               eAddChild(box);
               setContent("box" + i,box);
               i++;
            }
            viewFactory.distributeSpritesInArea(layoutFactory.getContainerLayoutArea(),boxes,1,1,count,1);
         }
      }
      
      private function createSuggestionBox(info:AlliancesWarTypesDef) : ESpriteContainer
      {
         var viewFactory:ViewFactory;
         var container:ESpriteContainer = (viewFactory = InstanceMng.getViewFactory()).getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("LayoutAllianceWarSuggested");
         var img:EImage = viewFactory.getEImage("generic_box",null,false,layoutFactory.getArea("box"));
         container.eAddChild(img);
         container.setContent("background",img);
         var field:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_subheader");
         container.eAddChild(field);
         container.setContent("title",field);
         field.setText(info.getNameToDisplay());
         img = viewFactory.getEImage(info.getAssetId(),null,true,layoutFactory.getArea("img"));
         container.eAddChild(img);
         container.setContent("img",img);
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_info"),"text_body_2")).setText(info.getDescToDisplay());
         container.eAddChild(field);
         container.setContent("description",field);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn");
         var button:EButton = viewFactory.getButtonByTextWidth(DCTextMng.getText(2852),buttonArea.width,"btn_can_attack");
         container.eAddChild(button);
         container.setContent("button",button);
         button.eAddEventListener("click",this.onDeclareWar);
         buttonArea.centerContent(button);
         container.name = info.mSku;
         return container;
      }
      
      private function centerAdvisor(img:EImage) : void
      {
         this.mAdvisorArea.centerContent(img);
      }
      
      private function printTimer() : void
      {
         var timer:ETextField = null;
         var time:String = null;
         var container:ESpriteContainer = getContentAsESpriteContainer("timerBox");
         if(container != null)
         {
            timer = container.getContentAsETextField("text");
            time = DCTextMng.convertTimeToStringColon(this.mUserAlliance.getCurrentWarTimeLeft());
            timer.autoSize(false);
            timer.setText(time);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mIsInWar)
         {
            this.printTimer();
            if(this.mUserAlliance.getCurrentWarTimeLeft() <= 0)
            {
               EPopupAlliances(this.mAllianceController.getPopupAlliance()).reloadPopup();
            }
         }
      }
      
      private function requestEnemyAllianceSuccess(ea:AlliancesAPIEvent) : void
      {
         this.mEnemyAlliance = ea.alliance;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutBodyAllianceWar");
         var scrollArea:EScrollArea = new EScrollArea();
         scrollArea.build(layoutFactory.getArea("enemy_members"),this.mEnemyAlliance.getTotalMembers(),ESpriteContainer,this.loadEnemyMemberStripes);
         viewFactory.getEScrollBar(scrollArea);
         setContent("scrollAreaEnemy",scrollArea);
         eAddChild(scrollArea);
      }
      
      private function onDeclareWar(e:EEvent) : void
      {
         var returnValue:Notification = null;
         if(this.mUserAlliance.getTotalMembers() < 5)
         {
            returnValue = new Notification("NotificationIncorrectAllianceName",AlliancesConstants.getErrorTitle(23),DCTextMng.getText(3719),"alliance_council_angry");
            InstanceMng.getNotificationsMng().guiOpenNotificationMessage(returnValue);
            return;
         }
         var container:ESpriteContainer = e.getTarget() as ESpriteContainer;
         var type:String = container.parent.name;
         this.mAllianceController.requestWarSuggested(type);
      }
   }
}
