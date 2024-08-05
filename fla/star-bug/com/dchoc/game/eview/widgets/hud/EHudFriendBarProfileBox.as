package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.inventory.ERewardFriendItemView;
   import com.dchoc.game.eview.widgets.EDropDownSprite;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import com.gskinner.motion.GTween;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EHudFriendBarProfileBox extends ESpriteContainer
   {
      
      private static const TWEEN_DURATION:Number = 0.3;
      
      public static const BUTTON_ATTACK:String = "btn_attack";
      
      public static const BUTTON_VISIT:String = "btn_visit";
      
      public static const BUTTON_INVITE:String = "btn_invite";
      
      private static const PROFILE_AREA:String = "container_box";
      
      private static const BOX_BKG:String = "bkg";
      
      private static const COLONIES_DROP_DOWN:String = "colonies";
      
      private static const WISHLIST_DROP_DOWN:String = "wishlist";
       
      
      private var mUserInfoRef:UserInfo;
      
      private var mTween:GTween;
      
      private var mStartingMovePositionTop:int;
      
      private var mEndingMovePositionTop:int;
      
      private var mColoniesRoleId:int;
      
      private var mColoniesView:EDropDownSprite;
      
      private var mWishlistView:EDropDownSprite;
      
      private var mWishlistBoxes:Array;
      
      private var mLastColoniesShown:String;
      
      private var mLastWishlistShown:String;
      
      public function EHudFriendBarProfileBox()
      {
         var btn:EButton = null;
         super();
         var viewFactory:ViewFactory;
         var layoutAreaFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ProfileBasic");
         var s:EImage = viewFactory.getEImage("tooltip_bkg",null,false,layoutAreaFactory.getArea("container_box"));
         this.eAddChild(s);
         this.setContent("bkg",s);
         (btn = viewFactory.getButton("btn_hud_attack",null,"XS",DCTextMng.getText(145))).setLayoutArea(layoutAreaFactory.getArea("btn_attack"),true);
         btn.eAddEventListener("click",this.onAttackMe);
         this.eAddChild(btn);
         this.setContent("btn_attack",btn);
         (btn = viewFactory.getButton("btn_hud",null,"XS",DCTextMng.getText(143))).setLayoutArea(layoutAreaFactory.getArea("btn_visit"),true);
         btn.eAddEventListener("click",this.onVisitMe);
         this.eAddChild(btn);
         this.setContent("btn_visit",btn);
         var profileView:ESpriteContainer = viewFactory.getProfileInfoBasic(null);
         profileView.eAddEventListener("click",this.onClickMe);
         this.eAddChild(profileView);
         this.setContent("container_box",profileView);
         (btn = viewFactory.getButton("btn_social",null,"XS",DCTextMng.getText(2810))).setLayoutArea(layoutAreaFactory.getArea("btn_visit"),true);
         btn.eAddEventListener("click",this.onInviteMe);
         this.eAddChild(btn);
         this.setContent("btn_invite",btn);
         this.mLastColoniesShown = null;
         this.mLastWishlistShown = null;
         this.eAddEventListener("rollOver",this.onMouseOver);
         this.eAddEventListener("rollOut",this.onMouseOut);
         this.mStartingMovePositionTop = profileView.logicTop;
         this.mEndingMovePositionTop = profileView.logicTop - profileView.getLogicHeight() + getContent("btn_attack").logicTop;
      }
      
      private function createColoniesDropdown() : void
      {
         if(this.mColoniesView && this.mColoniesView.parent)
         {
            InstanceMng.getViewMng().removeChildFromLayer(this.mColoniesView,InstanceMng.getViewMngGame().getTooltipLayerSku());
            this.mColoniesView.destroy();
            this.mColoniesView = null;
         }
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var currentPlanet:Planet = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj().getCurrentPlanet();
         this.mColoniesView = viewFactory.getDropDownSprite(null,viewFactory.getColoniesForDropDown(this.onColonyClick,this.mUserInfoRef,currentPlanet),"LayoutHudEmptyDropDown","up");
         var lastX:Number = this.mColoniesView.logicLeft;
         viewFactory.arrangeToFitInMinimumScreen(this.mColoniesView);
         this.mColoniesView.getContent("arrow").logicX = this.mColoniesView.getContent("arrow").logicX + (lastX - this.mColoniesView.logicX);
         this.mColoniesView.close(false);
         this.mLastColoniesShown = this.getAccountId();
      }
      
      private function setColoniesDropdownPosition(button:EButton) : void
      {
         var btn:* = button;
         this.mColoniesView.logicX = btn.logicLeft + btn.getLogicWidth() / 2;
         this.mColoniesView.logicY = btn.logicTop + btn.getLogicHeight() / 2;
         this.eAddChild(this.mColoniesView);
         this.setContent("colonies",this.mColoniesView);
      }
      
      private function createWishlistDropdown() : void
      {
         var wishlistSku:String = null;
         var layoutArea:ELayoutArea = null;
         var itemObject:ItemObject = null;
         var box:ERewardFriendItemView = null;
         var profileView:ESpriteContainer = getContentAsESpriteContainer("container_box");
         if(this.mWishlistView && profileView.contains(this.mWishlistView))
         {
            profileView.eRemoveChild(this.mWishlistView);
            this.mWishlistView.destroy();
            this.mWishlistView = null;
         }
         var wishlistSkus:Array = this.mUserInfoRef.getWishlistSkus();
         this.mWishlistBoxes = [];
         var container:ESpriteContainer = InstanceMng.getViewFactory().getESpriteContainer();
         if(!wishlistSkus || wishlistSkus.length == 0)
         {
            return;
         }
         for each(wishlistSku in wishlistSkus)
         {
            itemObject = InstanceMng.getItemsMng().getItemObjectBySku(wishlistSku);
            (box = new ERewardFriendItemView(this.mUserInfoRef.getAccountId())).name = wishlistSku;
            box.build();
            box.fillData(itemObject);
            this.mWishlistBoxes.push(box);
            container.eAddChild(box);
            container.setContent(box.name,box);
         }
         layoutArea = InstanceMng.getViewFactory().createMinimumLayoutArea(this.mWishlistBoxes,0,1,8,0);
         InstanceMng.getViewFactory().distributeSpritesInArea(layoutArea,this.mWishlistBoxes);
         this.mWishlistView = InstanceMng.getViewFactory().getDropDownSprite(null,container,"LayoutHudEmptyDropDown","up");
         this.mWishlistView.setCloseTimeMs(0);
         this.mWishlistView.logicX += profileView.getLogicWidth() / 2;
         this.mWishlistView.logicY += 20;
         this.mWishlistView.close(false);
         profileView.eAddChild(this.mWishlistView);
         profileView.setContent("wishlist",this.mWishlistView);
         this.mLastWishlistShown = this.getAccountId();
      }
      
      public function setProfile(userInfo:UserInfo) : void
      {
         var btnAttack:EButton = null;
         var btnInvite:EButton = null;
         var inviteTextID:int = 0;
         this.mUserInfoRef = userInfo;
         if(this.mUserInfoRef)
         {
            EHudProfileBasicView(getContent("container_box")).setUserInfo(this.mUserInfoRef);
            btnAttack = getContentAsEButton("btn_attack");
            InstanceMng.getViewFactory().configureAttackButton(userInfo,btnAttack);
            (btnInvite = getContentAsEButton("btn_invite")).visible = !this.mUserInfoRef.isNeighbor() && !this.mUserInfoRef.getIsOwnerProfile();
            btnInvite.setIsEnabled(!this.mUserInfoRef.getIsInviteRequestSent());
            inviteTextID = 2745;
            if(this.mUserInfoRef.getIsInviteRequestSent())
            {
               inviteTextID = 80;
            }
            else if(InstanceMng.getUserInfoMng().getUserInfoObj(this.mUserInfoRef.getExtId(),1,1) != null)
            {
               inviteTextID = 79;
            }
            btnInvite.setText(DCTextMng.getText(inviteTextID));
         }
         if(!this.mUserInfoRef || this.mUserInfoRef.getIsOwnerProfile())
         {
            if(this.mTween)
            {
               this.mTween.end();
            }
            getContent("container_box").logicTop = this.mStartingMovePositionTop;
         }
      }
      
      public function getAccountId() : String
      {
         return this.mUserInfoRef.getAccountId();
      }
      
      public function disableVisit() : void
      {
         getContent("btn_visit").setIsEnabled(false);
      }
      
      public function enableVisit() : void
      {
         getContent("btn_visit").setIsEnabled(true);
      }
      
      private function onMouseOver(evt:EEvent) : void
      {
         var box:ERewardFriendItemView = null;
         if(this.mTween)
         {
            this.mTween.autoPlay = false;
            this.mTween.target = null;
         }
         if(this.mUserInfoRef && !this.mUserInfoRef.getIsOwnerProfile() && this.mUserInfoRef.isNeighbor())
         {
            this.mTween = new GTween(getContent("container_box"),0.3,{"logicTop":this.mEndingMovePositionTop});
            this.mTween.autoPlay = true;
            if(this.mLastWishlistShown != this.getAccountId())
            {
               this.createWishlistDropdown();
            }
            if(this.mWishlistView)
            {
               this.mWishlistView.open(false);
               for each(box in this.mWishlistBoxes)
               {
                  box.wishlistCheckItem();
               }
            }
         }
      }
      
      private function onMouseOut(evt:EEvent) : void
      {
         if(this.mTween)
         {
            this.mTween.autoPlay = false;
            this.mTween.target = null;
         }
         if(this.mColoniesView)
         {
            this.mColoniesView.close(false);
         }
         if(this.mWishlistView)
         {
            this.mWishlistView.close(false);
         }
         if(this.mUserInfoRef && !this.mUserInfoRef.getIsOwnerProfile() && this.mUserInfoRef.isNeighbor())
         {
            this.mTween = new GTween(getContent("container_box"),0.3,{"logicTop":this.mStartingMovePositionTop});
            this.mTween.autoPlay = true;
            if(this.mColoniesView)
            {
               this.mColoniesView.close();
            }
         }
      }
      
      private function onClickMe(evt:EEvent) : void
      {
         var params:Dictionary = null;
         if(this.mUserInfoRef)
         {
            if(this.mUserInfoRef.getIsOwnerProfile())
            {
               params = new Dictionary();
               params["accountId"] = this.getAccountId();
               MessageCenter.getInstance().sendMessage("friendBoxClicked",params);
            }
         }
      }
      
      private function onVisitMe(evt:EEvent) : void
      {
         var params:Dictionary = null;
         if(this.mUserInfoRef && !this.mUserInfoRef.getIsOwnerProfile())
         {
            if(this.mUserInfoRef.getPlanetsAmount() > 1)
            {
               if(this.mColoniesView && this.mColoniesView.isOpen() && this.mColoniesRoleId == 1)
               {
                  this.mColoniesView.close();
               }
               else
               {
                  if(this.getAccountId() != this.mLastColoniesShown)
                  {
                     this.createColoniesDropdown();
                  }
                  this.mColoniesView.close(false);
                  this.mColoniesRoleId = 1;
                  this.setColoniesDropdownPosition(getContentAsEButton("btn_visit"));
                  this.parent.setChildIndex(this,this.parent.numChildren - 1);
                  this.mColoniesView.open();
               }
            }
            else
            {
               params = new Dictionary();
               params["accountId"] = this.getAccountId();
               MessageCenter.getInstance().sendMessage("friendBoxClicked",params);
            }
         }
      }
      
      private function onColonyClick(evt:EEvent) : void
      {
         var planetId:String = String(evt.getTarget().name);
         var planet:Planet = this.mUserInfoRef.getPlanetById(planetId);
         if(planet)
         {
            InstanceMng.getApplication().goToSetCurrentDestinationInfo(planetId,this.mUserInfoRef);
            InstanceMng.getApplication().requestPlanet(this.getAccountId(),planetId,this.mColoniesRoleId,planet.getSku(),true,true,true,-1,null,null,false,0,planet);
         }
      }
      
      private function onInviteMe(evt:EEvent) : void
      {
         var data:Object = null;
         var task:String = null;
         var detail:String = null;
         if(this.mUserInfoRef)
         {
            if(InstanceMng.getUserInfoMng().getUserInfoObj(this.mUserInfoRef.getExtId(),1,1) != null)
            {
               detail = "FriendsBar Add";
               task = "addNeighbor";
            }
            else
            {
               detail = "FriendsBar Invite";
               task = "inviteIndividualFriend";
            }
            data = {
               "platform":InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlatform(),
               "platformId":this.mUserInfoRef.getExtId()
            };
            data.detail = detail;
            data.src = "vir_invitefriend";
            InstanceMng.getApplication().setToWindowedMode();
            InstanceMng.getUserDataMng().requestTask(task,data);
            this.mUserInfoRef.setInviteRequestSent();
            getContentAsEButton("btn_invite").setText(DCTextMng.getText(80));
            getContent("btn_invite").setIsEnabled(false);
         }
         else
         {
            InstanceMng.getApplication().setToWindowedMode();
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_OPEN_INVITE_TAB,{
               "src":"vir_invitefriend",
               "detail":"FriendsBar InviteFriends"
            });
            if(Config.USE_METRICS)
            {
               DCMetrics.sendMetric("Invite","Started","social Wall","idlePopup");
            }
         }
      }
      
      private function onAttackMe(evt:EEvent) : void
      {
         var params:Dictionary = null;
         if(this.mUserInfoRef && !this.mUserInfoRef.getIsOwnerProfile())
         {
            if(this.mUserInfoRef.getPlanetsAmount() > 1)
            {
               if(this.mColoniesView && this.mColoniesView.isOpen() && this.mColoniesRoleId == 3)
               {
                  this.mColoniesView.close();
               }
               else
               {
                  if(this.getAccountId() != this.mLastColoniesShown)
                  {
                     this.createColoniesDropdown();
                  }
                  this.mColoniesView.close(false);
                  this.mColoniesRoleId = 3;
                  this.setColoniesDropdownPosition(getContentAsEButton("btn_attack"));
                  this.parent.setChildIndex(this,this.parent.numChildren - 1);
                  this.mColoniesView.open();
               }
            }
            else
            {
               params = new Dictionary();
               params["accountId"] = this.getAccountId();
               MessageCenter.getInstance().sendMessage("friendBoxAttackClicked",params);
            }
         }
      }
   }
}
