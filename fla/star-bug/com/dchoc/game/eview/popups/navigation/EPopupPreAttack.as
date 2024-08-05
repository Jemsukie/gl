package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.PaginatorViewSimple;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.utils.Dictionary;
   
   public class EPopupPreAttack extends EGamePopup implements INotifyReceiver, EPaginatorController
   {
       
      
      private const BODY:String = "body";
      
      private const ACCEPT_BUTTON:String = "add_gold_button";
      
      private const SPY_BUTTON:String = "spy_button";
      
      private const CRAFTING_BUTTON:String = "crafting_button";
      
      private const TEXT_PLANET_NAME_PLAYER:String = "text_name_planet";
      
      private const TEXT_PLANET_NAME_ENEMY:String = "text_enemy_name_planet";
      
      private const TEXT_PLANET_COORDS_PLAYER:String = "text_coordenates";
      
      private const TEXT_PLANET_COORDS_ENEMY:String = "text_enemy_coordenates";
      
      private const TEXT_DISTANCE:String = "text_distance";
      
      private const TEXT_DISTANCE_VALUE:String = "text_distance_value";
      
      private const ARROW:String = "arrow";
      
      private const AREA_PRICE:String = "area_price";
      
      private const AREA_PROFILE_PLAYER:String = "area_profile";
      
      private const AREA_PROFILE_ENEMY:String = "area_enemy";
      
      private const TEXT_UNITS:String = "text_title_units";
      
      private const TEXT_NO_UNITS:String = "text_no_units";
      
      private const AREA_UNITS:String = "area_units";
      
      private const TEXT_WARNING:String = "text_title_warning";
      
      private const TEXT_WARNING_VALUE:String = "text_warning";
      
      private const AREA_WARNING:String = "container_warning";
      
      private const NUM_UNIT_ITEMS:int = 5;
      
      private const AREA_UNIT:String = "area_";
      
      private var mUserProfile:Profile;
      
      private var mUserPlanet:Planet;
      
      private var mTargetUser:UserInfo;
      
      private var mTargetPlanet:Planet;
      
      private var mCloseCallBack:Function;
      
      private var mAcceptCallBack:Function;
      
      private var mDistance:Number;
      
      private var mMineralCost:Number;
      
      private var mAttackableObject:Object;
      
      private var mUnitsPaginator:PaginatorViewSimple;
      
      private var mPageId:int;
      
      private var mAcceptButton:EButton;
      
      public function EPopupPreAttack()
      {
         super();
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         MessageCenter.getInstance().unregisterObject(this);
      }
      
      public function setupPopup(targetAccountId:String, targetPlanetId:String, targetPlanetSku:String, onAccept:Function, onClose:Function) : void
      {
         var planet:Planet = null;
         var hqlevel:int = 0;
         var coords:Array = null;
         var sku:String = null;
         var planetsList:* = undefined;
         this.mPageId = 0;
         this.mUserProfile = InstanceMng.getUserInfoMng().getProfileLogin();
         this.mUserPlanet = this.mUserProfile.getUserInfoObj().getPlanetById(this.mUserProfile.getCurrentPlanetId());
         this.mCloseCallBack = onClose;
         this.mAcceptCallBack = onAccept;
         this.mTargetUser = InstanceMng.getUserInfoMng().getUserInfoObj(targetAccountId,0);
         this.mTargetPlanet = new Planet();
         if(this.mTargetUser.mIsNPC.value)
         {
            this.mTargetPlanet.setSku(this.mUserPlanet.getSku());
            this.mTargetPlanet.setPlanetId("1");
            this.mTargetPlanet.setColonyIdx(0);
            this.mTargetPlanet.setIsCapital(true);
            this.mTargetPlanet.setHQLevel(this.mTargetUser.getHQLevel());
            if(this.mTargetPlanet.getHQLevel() < 1)
            {
               this.mTargetPlanet.setHQLevel(1);
            }
         }
         else
         {
            this.mTargetPlanet.setSku(targetPlanetSku);
            this.mTargetPlanet.setPlanetId(targetPlanetId);
            this.mTargetPlanet.setColonyIdx(parseInt(targetPlanetId) - 1);
            this.mTargetPlanet.setIsCapital(this.mTargetPlanet.getColonyIdx() == 0);
            if((planet = InstanceMng.getMapViewSolarSystem().getPlanet(targetAccountId,targetPlanetId)) != null)
            {
               hqlevel = this.mTargetUser.getHQLevelFromPlanetId(this.mTargetPlanet.getPlanetId());
               this.mTargetPlanet.setHQLevel(hqlevel == -1 ? planet.getHQLevel() : hqlevel);
            }
            else
            {
               this.mTargetPlanet.setHQLevel(this.mTargetUser.getHQLevelFromPlanetId(this.mTargetPlanet.getPlanetId()));
               if(this.mTargetPlanet.getHQLevel() == -1)
               {
                  sku = (coords = targetPlanetSku.split(":"))[0] + "," + coords[1];
                  planetsList = InstanceMng.getMapViewGalaxy().mSolarSystemPlanets[sku];
                  for each(var p in planetsList)
                  {
                     if(targetPlanetSku == p.getSku())
                     {
                        this.mTargetPlanet.setHQLevel(p.getHQLevel());
                        break;
                     }
                  }
               }
            }
         }
         this.mTargetPlanet.setName(this.mTargetPlanet.getStringId());
         this.mTargetPlanet.setAccIdOwner(this.mTargetUser.mAccountId);
         this.mTargetPlanet.setURL(this.mTargetUser.getThumbnailURL());
         this.setupBackground("PopL","pop_l");
         setTitleText(DCTextMng.getText(394));
         this.setupContent();
      }
      
      protected function setupBackground(layoutName:String, background:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(layoutName);
         var bkg:EImage = mViewFactory.getEImage(background,null,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         var body:ESprite = mViewFactory.getESprite(null,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("body",body);
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      private function setupContent() : void
      {
         var boxes:Array = null;
         var textProp:String = null;
         var unit:ESpriteContainer = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutPreAttack");
         var body:ESprite = getContent("body");
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_name_planet"),"text_title_3");
         body.eAddChild(field);
         setContent("text_name_planet",field);
         field.setText(DCTextMng.replaceParameters(2739,[this.mUserProfile.getPlayerName(),this.mUserPlanet.getName()]));
         field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_coordenates"),"text_title_3");
         body.eAddChild(field);
         setContent("text_coordenates",field);
         field.setText(this.mUserPlanet.getParentStartCoordsAsString());
         var container:ESpriteContainer = mViewFactory.getProfileExtendedFromPlanet(this.mUserPlanet,false);
         body.eAddChild(container);
         setContent("area_profile",container);
         container.layoutApplyTransformations(layoutFactory.getArea("area_profile"));
         field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_enemy_name_planet"),"text_title_3");
         body.eAddChild(field);
         setContent("text_enemy_name_planet",field);
         field.setText(DCTextMng.replaceParameters(2739,[this.mTargetUser.getPlayerName(),this.mTargetPlanet.getName()]));
         field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_enemy_coordenates"),"text_title_3");
         body.eAddChild(field);
         setContent("text_enemy_coordenates",field);
         field.setText(this.mTargetPlanet.getParentStartCoordsAsString());
         container = mViewFactory.getProfileExtendedFromPlanet(this.mTargetPlanet,false);
         body.eAddChild(container);
         setContent("area_enemy",container);
         container.layoutApplyTransformations(layoutFactory.getArea("area_enemy"));
         var img:EImage = mViewFactory.getEImage("icon_arrow",null,false,layoutFactory.getArea("arrow"));
         body.eAddChild(img);
         setContent("arrow",img);
         field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_distance"),"text_subheader");
         body.eAddChild(field);
         setContent("text_distance",field);
         field.setText(DCTextMng.getText(395));
         this.mDistance = Math.floor(InstanceMng.getMapViewGalaxy().getDistanceBetweenPlanets(this.mUserPlanet.getSku(),this.mTargetPlanet.getSku()));
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_distance_value"),"text_subheader")).setText(this.mDistance.toString());
         body.eAddChild(field);
         setContent("text_distance_value",field);
         var areaPrice:ELayoutArea = layoutFactory.getArea("area_price");
         img = mViewFactory.getEImage("area_timer",null,false,areaPrice);
         body.eAddChild(img);
         setContent("area_price",img);
         if(InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
         {
            getContent("text_coordenates").visible = false;
            getContent("text_enemy_coordenates").visible = false;
         }
         if(this.mTargetUser.mIsNPC.value)
         {
            this.mMineralCost = InstanceMng.getRuleMng().getAmountDependingOnCapacity(this.mTargetUser.getAttackCostPercentage(),false);
         }
         else
         {
            this.mMineralCost = InstanceMng.getRuleMng().getAttackDistanceMineralCostByDistance(this.mDistance);
         }
         var textMineral:String = this.mMineralCost == 0 ? DCTextMng.getText(397) : DCTextMng.convertNumberToString(this.mMineralCost,-1,-1);
         if(this.mMineralCost == 0 || this.mMineralCost <= this.mUserProfile.getMinerals())
         {
            textProp = "text_minerals";
         }
         else
         {
            textProp = "text_negative";
         }
         container = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalM","icon_minerals",textMineral,null,textProp);
         body.eAddChild(container);
         setContent("MineralValue",container);
         mViewFactory.distributeSpritesInArea(areaPrice,[container],1,1,-1,1,true);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title_units"),"text_title_3")).setText(DCTextMng.getText(125));
         body.eAddChild(field);
         setContent("text_title_units",field);
         img = mViewFactory.getEImage("generic_box",null,false,layoutFactory.getArea("area_units"),null);
         body.eAddChild(img);
         setContent("area_units",body);
         var paginatorUnits:ESpriteContainer = mViewFactory.getPaginatorAssetSimple(layoutFactory.getArea("area_units"),"BtnImgM",mSkinSku);
         this.mUnitsPaginator = new PaginatorViewSimple(paginatorUnits,1);
         var bunkerPaginatorComponent:EPaginatorComponent;
         (bunkerPaginatorComponent = new EPaginatorComponent()).init(this.mUnitsPaginator,this);
         this.mUnitsPaginator.setPaginatorComponent(bunkerPaginatorComponent);
         body.eAddChild(paginatorUnits);
         setContent("area_units_paginator",paginatorUnits);
         var i:int = 0;
         for(boxes = []; i < 5; )
         {
            unit = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalL","no_texture","x0",null,"text_title_3",true);
            mViewFactory.readjustContentIconWithTextVertical(unit);
            boxes.push(unit);
            body.eAddChild(unit);
            setContent("area_" + i,unit);
            i++;
         }
         mViewFactory.distributeSpritesInArea(layoutFactory.getArea("area_units"),boxes,1,1,-1,1,true);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_no_units"),"text_negative")).setText(" ");
         body.eAddChild(field);
         setContent("text_no_units",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title_warning"),"text_title_3")).setText(DCTextMng.getText(191));
         body.eAddChild(field);
         setContent("text_title_warning",field);
         img = mViewFactory.getEImage("generic_box",null,false,layoutFactory.getArea("container_warning"),null);
         body.eAddChild(img);
         setContent("container_warning",body);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_warning"),"text_body_3")).setVAlign("top");
         field.setHAlign("left");
         body.eAddChild(field);
         setContent("text_warning",field);
         this.setupUnits();
         this.setupWarnings();
         this.setupButtons();
      }
      
      public function setupUnits() : void
      {
         var item:ItemObject = null;
         var unitSku:String = null;
         var container:ESpriteContainer = null;
         var unitInfo:Array = null;
         var hangarUnitsInfo:Vector.<Array> = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getAllUnitsStored();
         var itemsMng:ItemsMng = InstanceMng.getItemsMng();
         this.mUnitsPaginator.setTotalPages(Math.ceil(hangarUnitsInfo.length / 5));
         var idx:int;
         var endIdx:int = (idx = this.mPageId * 5) + 5;
         while(idx < hangarUnitsInfo.length && idx < endIdx)
         {
            unitInfo = hangarUnitsInfo[idx];
            container = getContentAsESpriteContainer("area_" + idx % 5);
            if(hangarUnitsInfo[idx][4])
            {
               unitInfo[3] = unitInfo[3];
            }
            else
            {
               item = itemsMng.getItemObjectBySku(unitInfo[5]);
               unitInfo[3] = item == null ? 0 : item.quantity;
            }
            mViewFactory.setTextureToImage(unitInfo[2].getIcon(),null,container.getContentAsEImage("icon"));
            container.getContentAsETextField("text").setText("x" + unitInfo[3]);
            container.visible = true;
            idx++;
         }
         while(idx < endIdx)
         {
            getContent("area_" + idx % 5).visible = false;
            idx++;
         }
      }
      
      public function setupWarnings() : void
      {
         var id:int = 0;
         var revengeId:String = InstanceMng.getUserInfoMng().getRevengeAvailable(this.mTargetUser);
         this.mAttackableObject = InstanceMng.getApplication().createIsAttackableObject(this.mTargetUser.getAccountId(),this.mTargetPlanet,revengeId != null);
         var text:String = "";
         for each(id in this.mAttackableObject.lockType)
         {
            text += "· " + InstanceMng.getApplication().getLockUIMessage(this.mAttackableObject) + "\n\n";
         }
         if(InstanceMng.getItemsMng().hasCraftingPending())
         {
            text += "· " + DCTextMng.getText(284) + "\n\n";
         }
         if(InstanceMng.getUserInfoMng().getProfileLogin().getProtectionTimeLeft() > 0)
         {
            text += "· " + DCTextMng.getText(192) + "\n\n";
         }
         getContentAsETextField("text_warning").setText(text);
      }
      
      public function setupButtons() : void
      {
         var id:int = 0;
         var setupGetUnits:Boolean = false;
         var hasPendingCrafting:Boolean = false;
         for each(id in this.mAttackableObject.lockType)
         {
            if(id == UserDataMng.ACCOUNT_LOCKED_HANGARS_EMPTY)
            {
               setupGetUnits = true;
            }
         }
         if(InstanceMng.getRole().mId == 0)
         {
            this.mAcceptButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(144),0,"btn_accept");
            addButton("spy_button",this.mAcceptButton);
            this.mAcceptButton.eAddEventListener("click",this.onSpy);
         }
         if(setupGetUnits)
         {
            this.mAcceptButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(699),0,"btn_accept");
            addButton("add_gold_button",this.mAcceptButton);
            this.mAcceptButton.eAddEventListener("click",this.onGetUnitsClick);
            getContentAsETextField("text_no_units").setText(DCTextMng.getText(698));
         }
         else
         {
            if(InstanceMng.getItemsMng().hasCraftingPending())
            {
               this.mAcceptButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(618),0,"btn_accept");
               addButton("crafting_button",this.mAcceptButton);
               this.mAcceptButton.eAddEventListener("click",this.onCraftingClick);
            }
            this.mAcceptButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(145),0,"btn_hud_attack");
            addButton("add_gold_button",this.mAcceptButton);
            this.mAcceptButton.eAddEventListener("click",this.onAcceptClick);
         }
      }
      
      private function mapGetSku(element:Array, index:int, array:Array) : String
      {
         return element[0];
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         if(this.mCloseCallBack != null)
         {
            this.mCloseCallBack();
         }
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onAcceptClick(e:EEvent) : void
      {
         if(this.mAcceptCallBack != null)
         {
            this.mAcceptCallBack();
         }
      }
      
      private function onGetUnitsClick(e:EEvent) : void
      {
         var shipyards:Vector.<String> = null;
         var shipyard:String = null;
         if(InstanceMng.getFlowState().getCurrentRoleId() == 0 && InstanceMng.getApplication().viewGetMode() == 0)
         {
            shipyards = InstanceMng.getShipyardController().getAllShipyardIds();
            if(shipyards.length)
            {
               shipyard = shipyards[0];
               InstanceMng.getGUIControllerPlanet().openShipyard(shipyard);
            }
            else
            {
               InstanceMng.getGUIControllerPlanet().openShopBar("shipyard_button");
            }
         }
         else
         {
            InstanceMng.getApplication().goToHomePlanet();
         }
         this.onCloseClick(e);
      }
      
      private function onCraftingClick(e:EEvent) : void
      {
         this.onCloseClick(e);
         InstanceMng.getItemsMng().guiOpenInventoryPopup("crafting");
      }
      
      private function onSpy(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
         var roleId:int = 2;
         var starId:Number = this.mTargetPlanet != null ? this.mTargetPlanet.getParentStarId() : -1;
         var starName:String = String(this.mTargetPlanet != null ? this.mTargetPlanet.getParentStarName() : null);
         var starCoords:DCCoordinate = this.mTargetPlanet != null ? this.mTargetPlanet.getParentStarCoords() : null;
         InstanceMng.getApplication().requestPlanet(this.mTargetUser.getAccountId(),this.mTargetPlanet.getPlanetId(),roleId,this.mTargetPlanet.getSku(),true,true,true,starId,starName,starCoords);
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.mPageId = id;
         this.setupUnits();
      }
      
      public function getName() : String
      {
         return "EPopupPreAttack";
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
               InstanceMng.getViewMngPlanet().addHighlightFromContainer(component);
            }
         }
      }
   }
}
