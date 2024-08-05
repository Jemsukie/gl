package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.messages.EPopupMessage;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.SolarSystem;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EPopupPlanetAction extends EPopupMessage implements INotifyReceiver
   {
       
      
      private const BUTTON_VISIT:String = "buttonVisit";
      
      private const BUTTON_ATTACK:String = "attack_button";
      
      private var mIsOccupied:Boolean;
      
      private var mPlanet:Planet;
      
      private var mUserInfo:UserInfo;
      
      private var mAccountIdAttached:String;
      
      private var mItsMe:Boolean;
      
      private var mIsFriendly:Boolean;
      
      private var mStar:SolarSystem;
      
      private var mAdded:Boolean = false;
      
      public function EPopupPlanetAction()
      {
         super();
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         MessageCenter.getInstance().unregisterObject(this);
      }
      
      public function setupContent(planet:Planet, star:SolarSystem, isOccupied:Boolean) : void
      {
         this.mIsOccupied = isOccupied;
         this.mPlanet = planet;
         this.mStar = star;
         if(this.mIsOccupied)
         {
            this.mUserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(this.mPlanet.getOwnerAccId(),0);
            this.mAccountIdAttached = this.mUserInfo.mAccountId;
            this.getContentOccupiedPlanet();
         }
         else
         {
            this.getContentEmptyPlanet();
         }
         setCloseButtonVisible(true);
         var closeButton:EButton;
         (closeButton = getCloseButton()).eAddEventListener("click",this.onCloseClicked);
      }
      
      private function getContentOccupiedPlanet() : void
      {
         var button:EButton = null;
         var buttonText:String = null;
         var title:String = null;
         var bodyText:String = null;
         var iconsArea:ELayoutArea = null;
         var revengeId:String = null;
         var hasDamageProtection:* = false;
         var hasOnlineProtection:* = false;
         var hasLevelTooLow:* = false;
         var hasToCompleteTutorial:* = false;
         var attackObject:Object = null;
         var boxes:Array = null;
         var shieldText:String = null;
         if(this.mUserInfo.mIsNPC.value)
         {
            if(this.mUserInfo.isFriendlyNPC())
            {
               buttonText = DCTextMng.getText(143);
               title = DCTextMng.getText(2733);
               bodyText = DCTextMng.getText(2734);
               this.mIsFriendly = true;
            }
            else
            {
               buttonText = DCTextMng.getText(144);
               if(this.mUserInfo.mAccountId == "npc_D")
               {
                  title = DCTextMng.replaceParameters(2737,[this.mUserInfo.getPlayerName()]);
                  bodyText = DCTextMng.getText(2738);
               }
               else
               {
                  title = DCTextMng.replaceParameters(2735,[this.mUserInfo.getPlayerName()]);
                  bodyText = DCTextMng.getText(2736);
               }
            }
         }
         else if(InstanceMng.getUserInfoMng().getProfileLogin().getAccountId() == this.mUserInfo.mAccountId)
         {
            buttonText = DCTextMng.getText(20);
            title = DCTextMng.replaceParameters(2739,[this.mUserInfo.getPlayerName(),this.mPlanet.getName()]);
            bodyText = DCTextMng.getText(2741);
            this.mItsMe = true;
         }
         else
         {
            this.mIsFriendly = this.mUserInfo.isNeighbor();
            buttonText = this.mIsFriendly ? DCTextMng.getText(143) : DCTextMng.getText(144);
            title = DCTextMng.replaceParameters(2739,[this.mUserInfo.getPlayerName(),this.mPlanet.getName()]);
            bodyText = DCTextMng.getText(2740);
         }
         button = mViewFactory.getButtonByTextWidth(buttonText,0,"btn_accept");
         addButton("buttonVisit",button);
         button.eAddEventListener("click",this.onVisit);
         var accIdProfileLogin:String = InstanceMng.getUserInfoMng().getProfileLogin().getAccountId();
         var tutoCompleted:Boolean;
         if(!(tutoCompleted = this.mUserInfo.mIsTutorialCompleted.value || accIdProfileLogin == this.mUserInfo.getAccountId()))
         {
            button.setIsEnabled(false);
         }
         var userProfile:Profile = this.mUserInfo.getParentProfile();
         if(!(this.mUserInfo.isFriendlyNPC() || userProfile != null && userProfile == InstanceMng.getUserInfoMng().getProfileLogin()) && mViewFactory.userCanBeAttackedPlanet(this.mUserInfo,this.mPlanet))
         {
            button = mViewFactory.getAttackButton(this.mUserInfo,null,null,this.mPlanet);
            addButton("attack_button",button);
            button.eAddEventListener("click",this.onAttack);
         }
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerTextIcons");
         var container:ESpriteContainer = new ESpriteContainer();
         var smallStructure:ELayoutAreaFactory;
         var smallStructureHeight:Number = (smallStructure = mViewFactory.getLayoutAreaFactory("IconTextS")).getContainerLayoutArea().height + 8;
         var textArea:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(layoutFactory.getTextArea("text_info"));
         var img:ESpriteContainer = mViewFactory.getProfileExtendedFromPlanet(this.mPlanet,true);
         container.eAddChild(img);
         container.setContent("profile",img);
         img.layoutApplyTransformations(layoutFactory.getArea("profile_extended"));
         DCDebug.traceCh("AttackLogic","[EPopPlanetAction] this.mUserInfo = " + this.mUserInfo + " | this.mPlanet = " + this.mPlanet + " | isAttackable = " + mViewFactory.userCanBeAttackedPlanet(this.mUserInfo,this.mPlanet));
         if(!mViewFactory.userCanBeAttackedPlanet(this.mUserInfo,this.mPlanet))
         {
            textArea.height -= smallStructureHeight;
            (iconsArea = ELayoutAreaFactory.createLayoutArea(textArea.width,smallStructureHeight)).y = textArea.y + textArea.height;
            revengeId = InstanceMng.getUserInfoMng().getRevengeAvailable(this.mUserInfo);
            attackObject = InstanceMng.getApplication().createIsAttackableObject(this.mUserInfo.mAccountId,this.mPlanet,revengeId != null);
            DCDebug.traceCh("AttackLogic","[EPopPlanetAction] attackObj locks = " + attackObject["lockType"]);
            if(attackObject["lockType"].length > 0)
            {
               hasDamageProtection = attackObject["lockType"].indexOf(UserDataMng.ACCOUNT_LOCKED_OWNER_HAS_DAMAGE_PROTECTION) > -1;
               hasLevelTooLow = attackObject["lockType"].indexOf(UserDataMng.ACCOUNT_LOCKED_YOUR_LEVEL_TOO_HIGH) > -1;
               hasOnlineProtection = attackObject["lockType"].indexOf(UserDataMng.ACCOUNT_LOCKED_BY_OWNER) > -1;
               hasToCompleteTutorial = attackObject["lockType"].indexOf(UserDataMng.ACCOUNT_LOCKED_TUTORIAL_NOT_FINISHED) > -1;
               bodyText = InstanceMng.getApplication().getLockUIMessage(attackObject);
            }
            boxes = [];
            if(hasDamageProtection || hasOnlineProtection)
            {
               if(hasDamageProtection)
               {
                  shieldText = DCTextMng.getText(693);
               }
               else
               {
                  shieldText = DCTextMng.getText(696);
               }
               img = mViewFactory.getContentIconWithTextHorizontal("IconTextXSLarge","shield1",shieldText,null,"text_body");
               container.eAddChild(img);
               container.setContent("iconShield",img);
               boxes.push(img);
            }
            if(hasLevelTooLow || hasToCompleteTutorial)
            {
               if(hasToCompleteTutorial)
               {
                  shieldText = DCTextMng.getText(697);
               }
               else
               {
                  shieldText = DCTextMng.getText(695);
               }
               img = mViewFactory.getContentIconWithTextHorizontal("IconTextXSLarge","icon_score_level",shieldText,null,"text_body");
               container.eAddChild(img);
               container.setContent("lowLevel",img);
               boxes.push(img);
            }
            mViewFactory.distributeSpritesInArea(iconsArea,boxes,1,1,boxes.length,1,true);
         }
         var field:ETextField;
         (field = mViewFactory.getETextField(null,textArea,"text_body")).setText(bodyText);
         container.eAddChild(field);
         container.setContent("textfield",field);
         setupPopup("looker",title,container);
      }
      
      private function getContentEmptyPlanet() : void
      {
         var buttonText:String = null;
         if(InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount() < 12)
         {
            buttonText = DCTextMng.getText(2744);
         }
         else
         {
            buttonText = DCTextMng.getText(3157);
         }
         var button:EButton = mViewFactory.getButtonByTextWidth(buttonText,0,"btn_common");
         addButton("colonizeButton",button);
         button.eAddEventListener("click",this.onColonize);
         if(Config.USE_NEWS_FEEDS)
         {
         }
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerTextIcons");
         var container:ESpriteContainer = new ESpriteContainer();
         var field:ETextField;
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_info"),"text_body")).setText(DCTextMng.getText(2743));
         container.eAddChild(field);
         container.setContent("textfield",field);
         var img:ESpriteContainer = mViewFactory.getEmptyPlanetView(this.mPlanet);
         container.eAddChild(img);
         container.setContent("profile",img);
         img.layoutApplyTransformations(layoutFactory.getArea("profile_extended"));
         setupPopup("looker",DCTextMng.getText(2742),container);
      }
      
      private function onCloseClicked(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      protected function onVisit(e:EEvent) : void
      {
         ETooltipMng.getInstance().flushTooltipsDictionary();
         var popupPlanetPanel:DCIPopup = InstanceMng.getPopupMng().getUnderPopup();
         InstanceMng.getPopupMng().closePopupDo(popupPlanetPanel);
         InstanceMng.getPopupMng().closePopupDo(this);
         if(this.checkIfBlackHoleIntroIsNeeded())
         {
            return;
         }
         var roleId:int = this.mItsMe ? 0 : (this.mIsFriendly ? 1 : 2);
         var starId:Number = this.mPlanet != null ? this.mPlanet.getParentStarId() : -1;
         var starName:String = String(this.mPlanet != null ? this.mPlanet.getParentStarName() : null);
         var starCoords:DCCoordinate = this.mPlanet != null ? this.mPlanet.getParentStarCoords() : null;
         if(this.mItsMe)
         {
            InstanceMng.getApplication().goToSetCurrentDestinationInfo(this.mPlanet.getPlanetId(),this.mUserInfo);
         }
         InstanceMng.getApplication().requestPlanet(this.mAccountIdAttached,this.mPlanet.getPlanetId(),roleId,this.mPlanet.getSku(),true,true,true,starId,starName,starCoords);
      }
      
      private function onAttack(e:EEvent) : void
      {
         ETooltipMng.getInstance().flushTooltipsDictionary();
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning() == true)
         {
            InstanceMng.getViewMngGame().removeAllHighlights();
         }
         var popupPlanetPanel:DCIPopup = InstanceMng.getPopupMng().getUnderPopup();
         if(popupPlanetPanel != null && popupPlanetPanel != this)
         {
            InstanceMng.getPopupMng().closePopupDo(popupPlanetPanel);
         }
         InstanceMng.getPopupMng().closePopupDo(this);
         if(this.checkIfBlackHoleIntroIsNeeded())
         {
            return;
         }
         InstanceMng.getMapViewGalaxy().onAttackRequest(this.mUserInfo.getAccountId(),this.mPlanet);
      }
      
      private function checkIfBlackHoleIntroIsNeeded() : Boolean
      {
         var accId:String = null;
         var uInfo:UserInfo = null;
         var isBlackHoleNPC:Boolean = false;
         var popupWasShown:Boolean = false;
         var o:Object = null;
         var returnValue:Boolean = false;
         var starId:Number = this.mPlanet != null ? this.mPlanet.getParentStarId() : -1;
         var starName:String = String(this.mPlanet != null ? this.mPlanet.getParentStarName() : null);
         var starCoords:DCCoordinate = this.mPlanet != null ? this.mPlanet.getParentStarCoords() : null;
         var revengeId:String = InstanceMng.getUserInfoMng().getRevengeAvailable(this.mUserInfo);
         var attackObject:Object;
         if((attackObject = InstanceMng.getApplication().createIsAttackableObject(this.mUserInfo.mAccountId,this.mPlanet,revengeId != null)).lockType.length == 0)
         {
            uInfo = (accId = this.mAccountIdAttached) != null ? InstanceMng.getUserInfoMng().getUserInfoObj(accId,0,3) : null;
            isBlackHoleNPC = uInfo != null ? uInfo.mAccountId == "npc_D" : false;
            popupWasShown = InstanceMng.getUserInfoMng().getProfileLogin().flagsGetBlackHoleIntroPopupWasShown();
            if(isBlackHoleNPC && popupWasShown == false)
            {
               (o = {}).accId = this.mAccountIdAttached;
               o.planetId = this.mPlanet.getPlanetId();
               o.role = 3;
               o.planetSku = this.mPlanet.getSku();
               o.starId = starId;
               o.starName = starName;
               o.starCoords = starCoords;
               InstanceMng.getMapViewGalaxy().guiOpenBlackHoleIntroPopup(o);
               InstanceMng.getUserInfoMng().getProfileLogin().flagsSetBlackHoleIntroPopup(1);
               return true;
            }
         }
         return returnValue;
      }
      
      private function onColonize(e:EEvent) : void
      {
         var planetSku:String = this.mPlanet.getSku();
         var starId:Number = this.mPlanet.getParentStarId();
         if(isNaN(starId))
         {
            starId = InstanceMng.getApplication().goToGetCurrentStarId();
            if(starId == -1)
            {
               starId = InstanceMng.getMapViewSolarSystem().getStarId();
            }
         }
         var popupPlanetPanel:DCIPopup;
         if((popupPlanetPanel = InstanceMng.getPopupMng().getUnderPopup()) != null && popupPlanetPanel != this)
         {
            InstanceMng.getPopupMng().closePopupDo(popupPlanetPanel);
         }
         var planetsAmount:int = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount();
         DCDebug.traceCh("SERVER","PopupPlanetEmpty::colonyAvailabilityWait, planetSku=" + planetSku + ", starId=" + starId);
         if(this.mStar != null)
         {
            InstanceMng.getApplication().colonyAvailabilityWait(planetSku,starId,this.mStar.getName(),this.mStar.getType());
         }
         else
         {
            InstanceMng.getApplication().colonyAvailabilityWait(planetSku,starId,null,0);
         }
         InstanceMng.getPopupMng().closePopup(this);
      }
      
      private function onInvite(e:EEvent) : void
      {
         InstanceMng.getPopupMng().closePopup(this);
         var data:Object = {
            "src":"vir_colonize",
            "detail":"FreePlanet Invite",
            "type":"app_non_users"
         };
         InstanceMng.getApplication().setToWindowedMode();
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_OPEN_INVITE_TAB,data);
      }
      
      public function getName() : String
      {
         return "EPopupPlanetActions";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["putTutorialCircle"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var name:String = null;
         var component:ESprite = null;
         var _loc5_:* = task;
         if("putTutorialCircle" === _loc5_)
         {
            name = String(params["elementName"]);
            component = getContent(name);
            if(component)
            {
               if(name == "buttonVisit")
               {
                  if(this.mUserInfo.getAccountId() == "npc_B" && !this.mAdded)
                  {
                     InstanceMng.getViewMngPlanet().addHighlightFromContainer(component);
                     this.mAdded = true;
                  }
               }
               else
               {
                  InstanceMng.getViewMngPlanet().addHighlightFromContainer(component);
               }
            }
         }
      }
   }
}
