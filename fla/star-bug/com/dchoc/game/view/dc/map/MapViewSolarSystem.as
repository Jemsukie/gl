package com.dchoc.game.view.dc.map
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.model.flow.FlowStateLoadingBarSolarSystem;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Quadratic;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   
   public class MapViewSolarSystem extends MapView
   {
      
      public static const MAX_PLANETS_AMOUNT:int = 12;
      
      private static const ON_PLANET_ASSET_USER:String = "userMask";
      
      private static const ON_PLANET_ASSET_PROTECTED:String = "userMask";
       
      
      private const ROLLOVER_TIME:int = 500;
      
      private const PLANET_OCCUPIED:String = "full";
      
      private const PLANET_EMPTY:String = "empty";
      
      private var mPlanets:Dictionary;
      
      private var mPlanetsGraphicsCatalog:Dictionary;
      
      private var mRollOverTimer:int;
      
      private var mFakeStarsCatalog:Dictionary;
      
      private var mFakeStarsTimerCatalog:Dictionary;
      
      private var mStarCoords:DCCoordinate;
      
      private var mStarType:int;
      
      private var mStarName:String;
      
      private var mStarId:Number;
      
      private var mNPCSkuToHighlight:String = "";
      
      private const FIREBIT_MISSION_SKU:String = "mission_021";
      
      protected var mBackgroundDO:Sprite;
      
      private var mBackgroundSprite:Sprite;
      
      protected var mBackgroundSku:String;
      
      private var mPlanetMinPositionY:int = 0;
      
      private var mPlanetMaxPositionY:int = 0;
      
      private var mPlanetAveragePositionY:int = 0;
      
      private var mPlanetDefaultScale:Number = 0.75;
      
      private var mAsteroidCatalog:Dictionary;
      
      private var mAsteroidDefaultPositionsCatalog:Dictionary;
      
      private var mAsteroidFuturePositionsCatalog:Dictionary;
      
      private const ASTEROIDS_AMOUNT:int = 9;
      
      public function MapViewSolarSystem()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 5;
      }
      
      override protected function unloadDo() : void
      {
         super.unloadDo();
         this.mBackgroundSku = null;
      }
      
      override protected function unbuildDo() : void
      {
         this.backgroundUnbuild();
         InstanceMng.getResourceMng().imagesReleaseGroup("space");
         this.unloadPlanets();
         this.setNPCSkuToHighlight("");
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         super.uiDisableDo(forceRemoveListeners);
         if(forceRemoveListeners)
         {
            this.lockPlanets(null);
         }
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var thisMsg:* = null;
         var e:Object = null;
         var userDataMng:UserDataMng = null;
         var planetsXML:XML = null;
         var coords:DCCoordinate = null;
         var coordArray:Array = null;
         var hud:TopHudFacade = null;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         switch(step)
         {
            case 0:
               this.mBackgroundSku = InstanceMng.getBackgroundController().getSpaceBgSkuByMapView("background_space_star_v2");
               if(!resourceMng.isResourceLoaded(this.mBackgroundSku))
               {
                  resourceMng.requestResource(this.mBackgroundSku);
               }
               buildAdvanceSyncStep();
            case 1:
               if(resourceMng.isResourceLoaded(this.mBackgroundSku))
               {
                  this.backgroundBuild();
                  buildAdvanceSyncStep();
               }
               break;
            case 2:
               if(mViewMng == null)
               {
                  thisMsg = "Error in MapView.buildDoSynStep: ";
                  if(mViewMng == null)
                  {
                     thisMsg += " A not null ViewMng must be assigned to MapView";
                  }
                  thisMsg += " before building it";
                  e = {
                     "cmd":"eventAbortApplication",
                     "msg":thisMsg
                  };
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getApplication(),e);
                  if(Config.DEBUG_ASSERTS)
                  {
                     DCDebug.trace(thisMsg,3);
                  }
               }
               else if(mViewMng.isBuilt())
               {
                  buildAdvanceSyncStep();
               }
               break;
            case 3:
               if(InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_STAR_PLANETS_WINDOW))
               {
                  planetsXML = (userDataMng = InstanceMng.getUserDataMng()).getFileXML(UserDataMng.KEY_STAR_PLANETS_WINDOW);
                  coords = new DCCoordinate();
                  coordArray = EUtils.xmlReadString(planetsXML,"sku").split(":");
                  coords.x = coordArray[0];
                  coords.y = coordArray[1];
                  this.loadPlanetsFromXML(planetsXML);
                  this.loadFakeStars();
                  InstanceMng.getUIFacade().navigationPanelSetSolarSystemData(this.mStarName,this.mStarCoords);
                  buildAdvanceSyncStep();
               }
               break;
            case 4:
               if(InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_BOOKMARKS))
               {
                  setUserBookmarks(InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_BOOKMARKS));
                  if((hud = InstanceMng.getTopHudFacade()) != null)
                  {
                     hud.refreshBookmarkButtonsVisibility();
                  }
                  buildAdvanceSyncStep();
                  break;
               }
         }
      }
      
      override protected function beginDo() : void
      {
         mViewMng.mapBackgroundAddToStage(this.mBackgroundDO);
         InstanceMng.getViewMng().setBackgroundColor(68115);
         this.performNPCCircleFX();
         this.performLoadingFX();
         this.performAsteroidFX();
         this.performSunStaticFX();
         this.emptyPlanetsFlotationFX();
      }
      
      override protected function endDo() : void
      {
         mViewMng.mapBackgroundRemoveFromStage(this.mBackgroundDO);
      }
      
      private function performNPCCircleFX() : void
      {
         if(this.getNPCSkuToHighlight() != "")
         {
            this.addHighlightToNPCPlanet(this.getNPCSkuToHighlight());
         }
      }
      
      private function addHighlightToNPCPlanet(sku:String) : void
      {
         var planetContainer:DisplayObjectContainer = null;
         var halfw:* = 0;
         var halfh:* = 0;
         var offsetX:int = 0;
         var offsetY:int = 0;
         var offsetW:int = 0;
         var offsetH:int = 0;
         if(sku != "")
         {
            if((planetContainer = this.getPlanetDisplayObject(sku,null,true)) != null)
            {
               halfw = planetContainer.width >> 1;
               halfh = planetContainer.height >> 1;
               offsetX = halfw;
               offsetY = halfh;
               offsetW = halfw;
               offsetH = halfh;
               InstanceMng.getViewMngPlanet().addHighlightFromContainer(planetContainer,true,offsetX,offsetY,offsetW,offsetH);
            }
         }
      }
      
      private function performLoadingFX() : void
      {
         var accountId:String = null;
         var planetId:String = null;
         var uInfo:UserInfo = null;
         var planetDoc:DisplayObject = null;
         var profile:Profile = null;
         var doc:DisplayObjectContainer = InstanceMng.getApplication().getDisplayObjectContainerByView();
         var oldViewMode:int = InstanceMng.getApplication().viewGetPreviousMode();
         var stageWidth:Number = InstanceMng.getApplication().stageGetWidth();
         var stageHeight:Number = InstanceMng.getApplication().stageGetHeight();
         var startScale:Number = 1;
         var targetScale:Number = 1;
         var startAlpha:Number = 0.25;
         var targetAlpha:Number = 1;
         var startPoint:Point = null;
         var targetPoint:Point = null;
         if(doc != null)
         {
            switch(oldViewMode)
            {
               case 0:
                  startScale = 2;
                  accountId = InstanceMng.getApplication().getLastRequestUserId();
                  planetId = InstanceMng.getApplication().goToGetCurrentPlanetId();
                  if(accountId == null)
                  {
                     accountId = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getAccountId();
                     planetId = profile.getCapitalPlanet().getPlanetId();
                  }
                  uInfo = InstanceMng.getUserInfoMng().getUserInfoObj(accountId,0);
                  planetDoc = null;
                  if(uInfo != null)
                  {
                     planetDoc = this.getPlanetDisplayObject(accountId,planetId,uInfo.mIsNPC.value);
                  }
                  if(planetDoc != null)
                  {
                     startPoint = new Point(planetDoc.x,planetDoc.y);
                     startPoint = planetDoc.parent.localToGlobal(startPoint);
                     targetPoint = new Point(0,0);
                  }
                  else
                  {
                     startPoint = new Point(stageWidth / 2,stageHeight / 2);
                  }
                  break;
               case 2:
                  startPoint = new Point(stageWidth / 2,stageHeight / 2);
                  startScale = 0.5;
            }
            TweenEffectsFactory.createTransition(doc,1,startPoint,targetPoint,startScale,targetScale,startAlpha,targetAlpha,Quadratic.easeOut,Quadratic.easeIn);
         }
      }
      
      public function setNPCSkuToHighlight(sku:String) : void
      {
         this.mNPCSkuToHighlight = sku;
      }
      
      private function getNPCSkuToHighlight() : String
      {
         return this.mNPCSkuToHighlight;
      }
      
      protected function backgroundBuild() : void
      {
         this.mBackgroundDO = new Sprite();
         this.mStarType = FlowStateLoadingBarSolarSystem.getStarType();
         var solarSystemToLoad:String = "Solar_system_" + DCUtils.transformValueToString(this.mStarType.toString(),2);
         this.mBackgroundSprite = new (InstanceMng.getResourceMng().getSWFClass("assets/flash/space_maps/backgrounds/solar_system_2_5.swf",solarSystemToLoad))() as Sprite;
         if(this.mBackgroundSprite != null)
         {
            this.mBackgroundDO.addChild(this.mBackgroundSprite);
         }
      }
      
      protected function backgroundUnbuild() : void
      {
         InstanceMng.getResourceMng().unloadResource("assets/flash/space_maps/backgrounds/solar_system_2_5.swf");
         this.mBackgroundDO = null;
         this.mBackgroundSprite = null;
         this.mPlanetsGraphicsCatalog = null;
         this.mFakeStarsCatalog = null;
         this.mFakeStarsTimerCatalog = null;
         this.mStarCoords = null;
         this.mStarId = -1;
         this.mStarName = null;
         this.mStarType = -1;
         this.mPlanetAveragePositionY = -1;
         this.mPlanetMaxPositionY = -1;
         this.mPlanetMinPositionY = -1;
         this.mAsteroidCatalog = null;
         this.mAsteroidDefaultPositionsCatalog = null;
         this.mAsteroidFuturePositionsCatalog = null;
         if(this.mBackgroundSku != null)
         {
            InstanceMng.getResourceMng().unloadResource(this.mBackgroundSku);
            this.mBackgroundSku = null;
         }
      }
      
      public function getBackGroundDO() : Sprite
      {
         return this.mBackgroundDO;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         super.logicUpdateDo(dt);
         this.logicUpdateFakeStars(dt);
         this.rotatePlanets(dt);
         this.performSunFX(dt);
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         this.mBackgroundDO.x = stageWidth / 2;
         this.mBackgroundDO.y = stageHeight / 2;
         InstanceMng.getViewMng().setBackgroundColor(68115);
      }
      
      private function setPlanetInfoFromXML(planet:Planet, solarSystemXML:XML, starId:Number, starName:String, starType:int) : Planet
      {
         if(planet == null)
         {
            planet = new Planet();
         }
         var attribute:String = "sku";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setSku(EUtils.xmlReadString(solarSystemXML,attribute));
         }
         attribute = "accountId";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setAccIdOwner(EUtils.xmlReadString(solarSystemXML,attribute));
         }
         attribute = "url";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setURL(EUtils.xmlReadString(solarSystemXML,attribute));
         }
         attribute = "HQLevel";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setHQLevel(EUtils.xmlReadInt(solarSystemXML,attribute));
         }
         attribute = "type";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setType(EUtils.xmlReadString(solarSystemXML,attribute));
         }
         attribute = "capital";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setIsCapital(EUtils.xmlReadBoolean(solarSystemXML,attribute));
         }
         attribute = "planetId";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setPlanetId(EUtils.xmlReadString(solarSystemXML,attribute));
         }
         attribute = "damageProtectionTimeLeft";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setDamageProtection(EUtils.xmlReadNumber(solarSystemXML,attribute));
         }
         attribute = "reserved";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setReserved(EUtils.xmlReadBoolean(solarSystemXML,attribute));
         }
         attribute = "notBuilt";
         if(EUtils.xmlIsAttribute(solarSystemXML,attribute))
         {
            planet.setNotBuilt(EUtils.xmlReadBoolean(solarSystemXML,attribute));
         }
         planet.setColonyIdx(parseInt(planet.getPlanetId()) - 1);
         planet.setName(planet.getStringId());
         planet.setParentStarId(starId);
         planet.setParentStarName(starName);
         planet.setParentStarType(starType);
         planet.setIsFree(false);
         return planet;
      }
      
      private function unloadPlanets() : void
      {
         this.mPlanets = null;
      }
      
      override public function loadPlanetsFromXML(info:XML) : void
      {
         var solarSystemXML:XML = null;
         var planet:Planet = null;
         var pos:String = null;
         var coordsArr:Array = null;
         this.mPlanets = new Dictionary();
         InstanceMng.getUserInfoMng().clearOtherPlayerInfo();
         for each(solarSystemXML in EUtils.xmlGetChildrenList(info,"Planet"))
         {
            InstanceMng.getUserInfoMng().addOtherPlayerInfo(solarSystemXML);
            planet = new Planet();
            planet = this.setPlanetInfoFromXML(planet,solarSystemXML,EUtils.xmlReadNumber(info,"starId"),EUtils.xmlReadString(info,"starName"),EUtils.xmlReadInt(info,"starType"));
            pos = planet.getPlanetPosId();
            pos = DCUtils.transformValueToString(pos,2);
            this.mPlanets[pos] = planet;
         }
         coordsArr = EUtils.xmlReadString(info,"sku").split(":");
         if(this.mStarCoords == null)
         {
            this.mStarCoords = new DCCoordinate();
         }
         this.mStarCoords.x = coordsArr[0];
         this.mStarCoords.y = coordsArr[1];
         this.mStarType = EUtils.xmlReadInt(info,"type");
         this.mStarName = EUtils.xmlReadString(info,"name");
         this.mStarId = EUtils.xmlReadNumber(info,"starId");
         if(this.mPlanetsGraphicsCatalog == null)
         {
            this.mPlanetsGraphicsCatalog = new Dictionary();
         }
         this.fillSolarSystem();
      }
      
      private function fillSolarSystem() : void
      {
         var planet:Planet = null;
         var ownerAccId:String = null;
         var uInfo:UserInfo = null;
         var posText:String = null;
         this.nonUserAssetsLoading();
         if(this.mPlanets == null)
         {
            return;
         }
         var count:int = 0;
         for each(planet in this.mPlanets)
         {
            if(count == 12)
            {
               return;
            }
            ownerAccId = planet.getOwnerAccId();
            uInfo = InstanceMng.getUserInfoMng().getUserInfoObj(ownerAccId,0);
            if(uInfo != null && uInfo.mIsNPC.value == false)
            {
               posText = DCUtils.transformValueToString(planet.getPlanetPosId(),2);
               this.userAssetLoading(posText);
               count++;
            }
         }
         this.emptyPlanetsLoading();
      }
      
      public function refreshSolarSystemView() : void
      {
         this.mPlanets = null;
         InstanceMng.getApplication().solarSystemInfoWait(this.mStarCoords,this.mStarId);
      }
      
      private function checkPlanetPositionInY(planet:DisplayObjectContainer) : void
      {
         if(planet.y < this.mPlanetMinPositionY)
         {
            this.mPlanetMinPositionY = planet.y;
         }
         if(planet.y > this.mPlanetMaxPositionY)
         {
            this.mPlanetMaxPositionY = planet.y;
         }
      }
      
      private function setPlanetsPositionBalancingAsDone() : void
      {
         var key:* = null;
         var doc:DisplayObjectContainer = null;
         var planetAsset:DisplayObjectContainer = null;
         var planet:Planet = null;
         this.mPlanetAveragePositionY = (this.mPlanetMinPositionY + this.mPlanetMaxPositionY) / 2;
         for(key in this.mPlanetsGraphicsCatalog)
         {
            doc = key as DisplayObjectContainer;
            planetAsset = doc.getChildByName("asset") as DisplayObjectContainer;
            planet = this.getPlanetByGraphic(doc);
            this.setScaleDependingOnYPosition(planetAsset,planet);
         }
      }
      
      public function getPlanet(accId:String, planetId:String) : Planet
      {
         var key:* = null;
         var doc:DisplayObjectContainer = null;
         var uInfo:UserInfo = null;
         var planet:Planet = null;
         for(key in this.mPlanetsGraphicsCatalog)
         {
            doc = key as DisplayObjectContainer;
            if((planet = this.getPlanetByGraphic(doc)) != null)
            {
               uInfo = InstanceMng.getUserInfoMng().getUserInfoObj(planet.getOwnerAccId(),0);
            }
            if(uInfo != null)
            {
               if(uInfo.getAccountId() == accId && planet != null && planetId == planet.getPlanetId())
               {
                  return planet;
               }
            }
         }
         return planet;
      }
      
      private function getPlanetByGraphic(planetIcon:DisplayObjectContainer) : Planet
      {
         var arr:Array = null;
         var uInfo:UserInfo = null;
         var pos:String = null;
         var planet:Planet = null;
         if(this.mPlanetsGraphicsCatalog != null)
         {
            arr = String(this.mPlanetsGraphicsCatalog[planetIcon]).split(":");
            uInfo = InstanceMng.getUserInfoMng().getUserInfoObj(arr[0],0);
            pos = String(uInfo != null && uInfo.mIsNPC.value ? arr[0] : arr[2]);
            if(this.mPlanets != null)
            {
               planet = this.mPlanets[pos];
            }
         }
         return planet;
      }
      
      private function setScaleDependingOnYPosition(planetAsset:DisplayObjectContainer, planet:Planet) : void
      {
         if(planet != null && planet.isNPC())
         {
            return;
         }
         planetAsset.scaleX = 1;
         planetAsset.scaleY = 1;
         planetAsset.scaleX *= this.mPlanetDefaultScale;
         planetAsset.scaleY *= this.mPlanetDefaultScale;
      }
      
      private function nonUserAssetsLoading() : void
      {
         var iconContainer:DisplayObjectContainer = null;
         var iconNPCPlanet:DisplayObjectContainer = null;
         var npcInstanceContainerA:DisplayObjectContainer = null;
         var npcInstanceContainerB:DisplayObjectContainer = null;
         var npcInstanceContainerC:DisplayObjectContainer = null;
         var npcInstanceContainerD:DisplayObjectContainer = null;
         var npcInstanceContainerE:DisplayObjectContainer = null;
         iconContainer = this.mBackgroundSprite.getChildByName("instance_sun") as DisplayObjectContainer;
         InstanceMng.getResourceMng().setSpaceResourceIcon(iconContainer,4,-1,this.mStarType);
         var showNPCs:Boolean = false;
         var capitalStarCoords:DCCoordinate;
         showNPCs = (capitalStarCoords = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getCapital().getParentStarCoords()).x == this.mStarCoords.x && capitalStarCoords.y == this.mStarCoords.y;
         npcInstanceContainerA = this.mBackgroundSprite.getChildByName("instance_npc_a") as DisplayObjectContainer;
         (npcInstanceContainerA as MovieClip).gotoAndStop("full");
         ((npcInstanceContainerB = this.mBackgroundSprite.getChildByName("instance_npc_b") as DisplayObjectContainer) as MovieClip).gotoAndStop("full");
         ((npcInstanceContainerC = this.mBackgroundSprite.getChildByName("instance_npc_c") as DisplayObjectContainer) as MovieClip).gotoAndStop("full");
         ((npcInstanceContainerD = this.mBackgroundSprite.getChildByName("instance_npc_d") as DisplayObjectContainer) as MovieClip).gotoAndStop("full");
         ((npcInstanceContainerE = this.mBackgroundSprite.getChildByName("instance_npc_e") as DisplayObjectContainer) as MovieClip).gotoAndStop("full");
         if(showNPCs || Config.OFFLINE_GAMEPLAY_MODE)
         {
            iconNPCPlanet = npcInstanceContainerA.getChildByName("asset") as DisplayObjectContainer;
            InstanceMng.getResourceMng().setSpaceResourceIcon(iconNPCPlanet,5);
            iconNPCPlanet = npcInstanceContainerB.getChildByName("asset") as DisplayObjectContainer;
            InstanceMng.getResourceMng().setSpaceResourceIcon(iconNPCPlanet,6);
            iconNPCPlanet = npcInstanceContainerC.getChildByName("asset") as DisplayObjectContainer;
            InstanceMng.getResourceMng().setSpaceResourceIcon(iconNPCPlanet,7);
            iconNPCPlanet = npcInstanceContainerD.getChildByName("asset") as DisplayObjectContainer;
            InstanceMng.getResourceMng().setSpaceResourceIcon(iconNPCPlanet,8);
            iconNPCPlanet = npcInstanceContainerE.getChildByName("asset") as DisplayObjectContainer;
            InstanceMng.getResourceMng().setSpaceResourceIcon(iconNPCPlanet,9);
            this.setupNPCPlanet("npc_A");
            this.setupNPCPlanet("npc_B");
            this.setupNPCPlanet("npc_C");
            this.setupNPCPlanet("npc_D");
            this.setupNPCPlanet("npc_E");
            npcInstanceContainerD.visible = true;
            npcInstanceContainerE.visible = InstanceMng.getMissionsMng().isMissionStarted("mission_098");
         }
         else
         {
            npcInstanceContainerA.visible = false;
            npcInstanceContainerB.visible = false;
            npcInstanceContainerC.visible = false;
            npcInstanceContainerD.visible = false;
            npcInstanceContainerE.visible = false;
         }
         this.checkPlanetPositionInY(npcInstanceContainerA);
         this.checkPlanetPositionInY(npcInstanceContainerB);
         this.checkPlanetPositionInY(npcInstanceContainerC);
         this.checkPlanetPositionInY(npcInstanceContainerD);
         this.checkPlanetPositionInY(npcInstanceContainerE);
      }
      
      private function setupNPCPlanet(npcName:String) : void
      {
         var npcPlanetContainer:DisplayObjectContainer = null;
         var planet:Planet = null;
         var instanceText:String = "instance_";
         var uInfoNPC:UserInfo;
         if((uInfoNPC = InstanceMng.getUserInfoMng().getUserInfoObj(npcName,0,3)) == null)
         {
            return;
         }
         (planet = new Planet()).setSku("");
         planet.setIsFree(false);
         planet.setAccIdOwner(npcName);
         planet.setHQLevel(uInfoNPC.getHQLevel());
         planet.setURL(uInfoNPC.getThumbnailURL());
         planet.setName(planet.getStringId());
         planet.setParentStarId(this.mStarId);
         planet.setParentStarName(this.mStarName);
         planet.setParentStarType(this.mStarType);
         this.mPlanets[npcName] = planet;
         instanceText = instanceText.concat(npcName.toLowerCase());
         npcPlanetContainer = this.mBackgroundSprite.getChildByName(instanceText) as DisplayObjectContainer;
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning() == false)
         {
            if(npcPlanetContainer.hasEventListener("click") == false)
            {
               npcPlanetContainer.addEventListener("click",this.onPlanetClick,false,0,true);
            }
            if(npcPlanetContainer.hasEventListener("rollOver") == false)
            {
               npcPlanetContainer.addEventListener("rollOver",this.planetRollOver,false,0,true);
            }
            if(npcPlanetContainer.hasEventListener("rollOut") == false)
            {
               npcPlanetContainer.addEventListener("rollOut",this.planetRollOut,false,0,true);
            }
         }
         this.setUserInfo(npcPlanetContainer,planet);
         this.mPlanetsGraphicsCatalog[npcPlanetContainer] = this.createKeyForStoringInGraphicsCatalog(npcName,null,null);
      }
      
      private function onPlanetClick(e:MouseEvent) : void
      {
         var o:Object = null;
         var eventType:String = null;
         var user:UserInfo = null;
         var planetIcon:DisplayObjectContainer = e.currentTarget as DisplayObjectContainer;
         var planet:Planet = this.getPlanetByGraphic(planetIcon);
         if(planet != null)
         {
            eventType = planet.isFree() ? "NOTIFY_STAR_SHOW_EMPTY_PLANET_POPUP" : "PopupPlanetOccupiedOptions";
            if(eventType == "PopupPlanetOccupiedOptions")
            {
               if((user = InstanceMng.getUserInfoMng().getUserInfoObj(planet.getOwnerAccId(),0)) != null && InstanceMng.getViewFactory().userCanBeAttackedPlanet(user,planet))
               {
                  InstanceMng.getMapViewGalaxy().onAttackRequest(user.getAccountId(),planet);
                  return;
               }
            }
            o = InstanceMng.getGUIController().createNotifyEvent("EventPopup",eventType);
            if(planet.isFree() == false)
            {
               o.accId = planet.getOwnerAccId();
            }
            o.doc = planetIcon;
            o.planet = planet;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
            return;
         }
      }
      
      private function planetRollOver(e:MouseEvent) : void
      {
         var planetAsset:DisplayObjectContainer = null;
         var photoAsset:DisplayObjectContainer = null;
         var planet:Planet = null;
         var planetIcon:DisplayObjectContainer;
         if((planetIcon = e.target as DisplayObjectContainer) != null)
         {
            planetAsset = planetIcon.getChildByName("asset") as DisplayObjectContainer;
            photoAsset = planetIcon.getChildByName("photo") as DisplayObjectContainer;
         }
         if(planetAsset != null)
         {
            planet = this.getPlanetByGraphic(planetIcon);
            if(planet != null)
            {
               planetAsset.filters = planet.getFilter();
            }
         }
      }
      
      private function planetRollOut(e:MouseEvent) : void
      {
         var planetAsset:DisplayObjectContainer = null;
         var photoAsset:DisplayObjectContainer = null;
         clearTimeout(this.mRollOverTimer);
         var planetIcon:DisplayObjectContainer;
         if((planetIcon = e.target as DisplayObjectContainer) != null)
         {
            planetAsset = planetIcon.getChildByName("asset") as DisplayObjectContainer;
            photoAsset = planetIcon.getChildByName("photo") as DisplayObjectContainer;
            if(planetAsset != null)
            {
               planetAsset.filters = null;
            }
         }
      }
      
      private function userAssetLoading(pos:String) : void
      {
         var userInstanceContainer:DisplayObjectContainer = null;
         var iconContainer:DisplayObjectContainer = null;
         var planet:Planet = null;
         var parentSolarSystemType:int = 0;
         var value:String = null;
         var instanceText:String = "player_";
         planet = Planet(this.mPlanets[pos]);
         instanceText = instanceText.concat(pos);
         userInstanceContainer = this.mBackgroundSprite.getChildByName(instanceText) as DisplayObjectContainer;
         if(userInstanceContainer != null)
         {
            if((iconContainer = userInstanceContainer.getChildByName("asset") as DisplayObjectContainer) != null && planet != null)
            {
               parentSolarSystemType = int(planet.isCapital() ? -1 : this.mStarType);
               InstanceMng.getResourceMng().setSpaceResourceIcon(iconContainer,0,planet.getHQLevel(),parentSolarSystemType);
            }
            this.checkPlanetPositionInY(userInstanceContainer);
            if(planet.isReserved() || planet.hasToBeGrayedOut())
            {
               userInstanceContainer.alpha = 0.5;
               if(userInstanceContainer.hasEventListener("click") == false)
               {
                  userInstanceContainer.removeEventListener("click",this.onPlanetClick);
               }
               if(userInstanceContainer.hasEventListener("rollOver") == false)
               {
                  userInstanceContainer.removeEventListener("rollOver",this.planetRollOver);
               }
               if(userInstanceContainer.hasEventListener("rollOut") == false)
               {
                  userInstanceContainer.removeEventListener("rollOut",this.planetRollOut);
               }
            }
            else if(InstanceMng.getFlowStatePlanet().isTutorialRunning() == false)
            {
               userInstanceContainer.alpha = 1;
               if(userInstanceContainer.hasEventListener("click") == false)
               {
                  userInstanceContainer.addEventListener("click",this.onPlanetClick,false,0,true);
               }
               if(userInstanceContainer.hasEventListener("rollOver") == false)
               {
                  userInstanceContainer.addEventListener("rollOver",this.planetRollOver,false,0,true);
               }
               if(userInstanceContainer.hasEventListener("rollOut") == false)
               {
                  userInstanceContainer.addEventListener("rollOut",this.planetRollOut,false,0,true);
               }
            }
            (userInstanceContainer as MovieClip).gotoAndStop("full");
            if(planet != null)
            {
               this.setUserInfo(userInstanceContainer,planet);
               this.checkIfPlanetIsFromUser(planet.getOwnerAccId(),userInstanceContainer);
               this.checkIfPlanetIsProtected(planet,userInstanceContainer);
               value = this.createKeyForStoringInGraphicsCatalog(planet.getOwnerAccId(),planet.getPlanetId(),pos);
               this.mPlanetsGraphicsCatalog[userInstanceContainer] = value;
            }
         }
      }
      
      private function onPlanetRemoveAsset(planetView:DisplayObjectContainer, nameAsset:String) : void
      {
         var asset:DisplayObject = null;
         var planetAsset:DisplayObjectContainer = planetView.getChildByName("asset") as DisplayObjectContainer;
         if(planetAsset != null)
         {
            if((asset = planetAsset.getChildByName(nameAsset)) != null)
            {
               planetAsset.removeChild(asset);
            }
         }
      }
      
      private function onPlanetRemoveAssets(planetView:DisplayObjectContainer) : void
      {
         this.onPlanetRemoveAsset(planetView,"userMask");
         this.onPlanetRemoveAsset(planetView,"userMask");
      }
      
      private function checkIfPlanetIsFromUser(ownerAccId:String, planetView:DisplayObjectContainer) : void
      {
         var planetAsset:DisplayObjectContainer = null;
         var uInfo:UserInfo = null;
         var userMask:DisplayObjectContainer;
         if((userMask = new (InstanceMng.getResourceMng().getSWFClass("assets/flash/space_maps/backgrounds/solar_system_2_5.swf","planet_player"))() as DisplayObjectContainer) != null)
         {
            userMask.name = "userMask";
            planetAsset = planetView.getChildByName("asset") as DisplayObjectContainer;
            uInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
            if(uInfo.getAccountId() == ownerAccId && planetAsset != null)
            {
               planetAsset.addChild(userMask);
            }
         }
      }
      
      private function checkIfPlanetIsProtected(planet:Planet, planetView:DisplayObjectContainer) : void
      {
         var planetAsset:DisplayObjectContainer = null;
         var protectedMask:DisplayObjectContainer;
         if((protectedMask = new (InstanceMng.getResourceMng().getSWFClass("assets/flash/space_maps/backgrounds/solar_system_2_5.swf","planet_protected"))() as DisplayObjectContainer) != null)
         {
            protectedMask.name = "userMask";
            planetAsset = planetView.getChildByName("asset") as DisplayObjectContainer;
            if(planet.getDamageProtection() > 0 && planetAsset != null)
            {
               planetAsset.addChild(protectedMask);
            }
         }
      }
      
      private function setUserInfo(planetInstance:DisplayObjectContainer, planet:Planet, changePhoto:Boolean = true) : void
      {
         var photo:DisplayObjectContainer = null;
         var playerName:TextField = null;
         var ownerName:String = null;
         var uInfo:UserInfo = null;
         var pic:Bitmap = null;
         if(planet != null && planetInstance != null)
         {
            if((uInfo = InstanceMng.getUserInfoMng().getUserInfoObj(planet.getOwnerAccId(),0)) != null)
            {
               ownerName = uInfo.getPlayerName();
               (playerName = planetInstance.getChildByName("text_info_01") as TextField).text = ownerName;
               playerName.visible = true;
               if(changePhoto)
               {
                  photo = planetInstance.getChildByName("photo") as DisplayObjectContainer;
                  if(uInfo.mIsNPC.value)
                  {
                     (pic = new Bitmap()).bitmapData = InstanceMng.getResourceMng().getNPCResource(planet.getURL());
                  }
                  else
                  {
                     pic = UserInfoMng.getUserPicByURL(planet.getURL());
                  }
                  if(pic != null)
                  {
                     photo.addChild(pic);
                  }
                  photo.visible = true;
               }
            }
            if(planet.isReserved() || planet.hasToBeGrayedOut())
            {
               playerName.visible = false;
               photo.visible = false;
            }
         }
      }
      
      private function emptyPlanetsLoading() : void
      {
         var i:int = 0;
         var indexText:String = null;
         if(this.mPlanets != null)
         {
            for(i = 1; i <= 12; )
            {
               indexText = DCUtils.transformValueToString(i.toString(),2);
               if(this.mPlanets[indexText] == null)
               {
                  this.emptyPlanetAssetLoading(indexText);
               }
               i++;
            }
         }
         this.setPlanetsPositionBalancingAsDone();
      }
      
      public function addPlanetBoughtByPlanet(planet:Planet, uInfo:UserInfo) : void
      {
         var planetSku:String = null;
         var skuArr:Array = null;
         var pos:String = null;
         if(planet != null && uInfo != null && this.mPlanets != null)
         {
            buyPlanetByUser(planet,uInfo,this.mStarId,this.mStarName,this.mStarType);
            planetSku = planet.getSku();
            if(planetSku != null)
            {
               skuArr = planetSku.split(":");
               pos = DCUtils.transformValueToString(skuArr[2],2);
            }
            this.mPlanets[pos] = planet;
            this.removePlanetAsset(pos);
            this.userAssetLoading(pos);
            this.setPlanetsPositionBalancingAsDone();
         }
      }
      
      public function removeOldColony(oldPlanetSku:String) : void
      {
         var skuArr:Array = oldPlanetSku.split(":");
         var pos:String = DCUtils.transformValueToString(skuArr[2],2);
         this.emptyPlanetAssetLoading(pos);
      }
      
      private function removePlanetAsset(pos:String) : void
      {
         var index:String = "player_" + pos;
         var doc:DisplayObjectContainer = this.mBackgroundSprite.getChildByName(index) as DisplayObjectContainer;
         if(doc != null)
         {
            this.mPlanetsGraphicsCatalog[doc] = null;
         }
      }
      
      private function emptyPlanetAssetLoading(pos:String) : void
      {
         var emptyInstanceContainer:DisplayObjectContainer = null;
         var iconContainer:DisplayObjectContainer = null;
         var planet:Planet = null;
         var instanceText:String = (instanceText = "player_").concat(pos);
         emptyInstanceContainer = this.mBackgroundSprite.getChildByName(instanceText) as DisplayObjectContainer;
         if(emptyInstanceContainer != null)
         {
            iconContainer = emptyInstanceContainer.getChildByName("asset") as DisplayObjectContainer;
            if(iconContainer != null)
            {
               InstanceMng.getResourceMng().setSpaceResourceIcon(iconContainer,1,int(pos));
               if(int(pos) % 2 == 0)
               {
                  iconContainer.scaleX = -1;
               }
            }
            (emptyInstanceContainer as MovieClip).gotoAndStop("empty");
            this.checkPlanetPositionInY(emptyInstanceContainer);
            this.onPlanetRemoveAssets(emptyInstanceContainer);
            if(InstanceMng.getFlowStatePlanet().isTutorialRunning() == false)
            {
               if(emptyInstanceContainer.hasEventListener("click") == false)
               {
                  emptyInstanceContainer.addEventListener("click",this.onPlanetClick,false,0,true);
               }
               if(emptyInstanceContainer.hasEventListener("rollOver") == false)
               {
                  emptyInstanceContainer.addEventListener("rollOver",this.planetRollOver,false,0,true);
               }
               if(emptyInstanceContainer.hasEventListener("rollOut") == false)
               {
                  emptyInstanceContainer.addEventListener("rollOut",this.planetRollOut,false,0,true);
               }
            }
            if(this.mPlanetsGraphicsCatalog != null)
            {
               this.mPlanetsGraphicsCatalog[emptyInstanceContainer] = this.createKeyForStoringInGraphicsCatalog(null,null,pos);
            }
            (planet = new Planet()).setSku(this.mStarCoords.x + ":" + this.mStarCoords.y + ":" + pos);
            planet.setIsFree(true);
            planet.setHQLevel(1);
            planet.setParentStarId(this.mStarId);
            planet.setParentStarName(this.mStarName);
            planet.setParentStarType(this.mStarType);
            pos = planet.getPlanetPosId();
            pos = DCUtils.transformValueToString(pos,2);
            if(this.mPlanets != null)
            {
               this.mPlanets[pos] = planet;
            }
         }
      }
      
      private function createKeyForStoringInGraphicsCatalog(accId:String, planetId:String, pos:String) : String
      {
         return accId + ":" + planetId + ":" + pos;
      }
      
      private function loadFakeStars() : void
      {
         var i:int = 0;
         var fakeStar:MovieClip = null;
         var posText:String = null;
         var countText:String = null;
         var time:Number = NaN;
         var pattern:String = "star_";
         var instanceName:String = "";
         if(this.mFakeStarsCatalog == null)
         {
            this.mFakeStarsCatalog = new Dictionary();
         }
         if(this.mFakeStarsTimerCatalog == null)
         {
            this.mFakeStarsTimerCatalog = new Dictionary();
         }
         i = 1;
         while(i <= 10)
         {
            countText = i.toString();
            posText = DCUtils.transformValueToString(countText,2);
            instanceName = pattern + posText;
            fakeStar = this.mBackgroundSprite.getChildByName(instanceName) as MovieClip;
            if(fakeStar != null && this.mFakeStarsCatalog != null)
            {
               this.mFakeStarsCatalog[i] = fakeStar;
               time = Math.random() * 5000 * i;
               this.mFakeStarsTimerCatalog[fakeStar] = time;
               fakeStar.gotoAndStop(1);
            }
            i++;
         }
      }
      
      private function logicUpdateFakeStars(dt:int) : void
      {
         var fakeStar:MovieClip = null;
         var count:int = 0;
         for each(fakeStar in this.mFakeStarsCatalog)
         {
            count++;
            if(this.mFakeStarsTimerCatalog[fakeStar] <= 0)
            {
               fakeStar.play();
               this.mFakeStarsTimerCatalog[fakeStar] = Math.random() * 5000 * count;
            }
            else
            {
               if(fakeStar.currentFrame == fakeStar.totalFrames)
               {
                  fakeStar.gotoAndStop(1);
               }
               this.mFakeStarsTimerCatalog[fakeStar] -= dt;
            }
         }
      }
      
      public function lockPlanets(exceptionId:String) : void
      {
         var key:* = null;
         var container:DisplayObjectContainer = null;
         var arr:Array = null;
         for(key in this.mPlanetsGraphicsCatalog)
         {
            container = key as DisplayObjectContainer;
            arr = String(this.mPlanetsGraphicsCatalog[key]).split(":");
            if(container != null)
            {
               if(arr[0] != exceptionId)
               {
                  container.removeEventListener("click",this.onPlanetClick);
                  container.removeEventListener("rollOver",this.planetRollOver);
                  container.removeEventListener("rollOut",this.planetRollOut);
               }
               else
               {
                  if(container.hasEventListener("click") == false)
                  {
                     container.addEventListener("click",this.onPlanetClick,false,0,true);
                  }
                  if(container.hasEventListener("rollOver") == false)
                  {
                     container.addEventListener("rollOver",this.planetRollOver,false,0,true);
                  }
                  if(container.hasEventListener("rollOut") == false)
                  {
                     container.addEventListener("rollOut",this.planetRollOut,false,0,true);
                  }
               }
            }
         }
      }
      
      public function getPlanetDisplayObject(ownerAccId:String, planetId:String, isNPC:Boolean = false) : DisplayObjectContainer
      {
         var key:* = null;
         var arr:Array = null;
         for(key in this.mPlanetsGraphicsCatalog)
         {
            if((arr = String(this.mPlanetsGraphicsCatalog[key]).split(":"))[0] == ownerAccId && arr[1] == planetId)
            {
               return key as DisplayObjectContainer;
            }
            if(isNPC == true && arr[0] == ownerAccId)
            {
               return key as DisplayObjectContainer;
            }
         }
         return null;
      }
      
      public function getStarName() : String
      {
         return this.mStarName;
      }
      
      public function getStarCoords() : DCCoordinate
      {
         return this.mStarCoords;
      }
      
      public function getStarType() : int
      {
         return this.mStarType;
      }
      
      public function getStarId() : Number
      {
         return this.mStarId;
      }
      
      private function rotatePlanets(dt:int) : void
      {
         var key:* = null;
         var doc:DisplayObjectContainer = null;
         var planetAsset:DisplayObjectContainer = null;
         var planet:Planet = null;
         var pos:int = 0;
         var multiplier:int = 0;
         var rotationValue:Number = NaN;
         for(key in this.mPlanetsGraphicsCatalog)
         {
            planetAsset = (doc = key as DisplayObjectContainer).getChildByName("asset") as DisplayObjectContainer;
            if((planet = this.getPlanetByGraphic(doc)) != null)
            {
               pos = int(planet.getPlanetPosId());
               multiplier = pos % 2 == 0 ? 1 : -1;
               if(planetAsset != null && !planet.isFree())
               {
                  rotationValue = dt / 500 * multiplier;
                  planetAsset.rotationZ += rotationValue;
               }
            }
         }
      }
      
      private function emptyPlanetsFlotationFX() : void
      {
         var key:* = null;
         var doc:DisplayObjectContainer = null;
         var multiplier:int = 0;
         var planet:Planet = null;
         var pos:Number = NaN;
         var futureCoord:DCCoordinate = null;
         var delay:Number = NaN;
         var tweenTranslation:GTween = null;
         for(key in this.mPlanetsGraphicsCatalog)
         {
            doc = key as DisplayObjectContainer;
            if((planet = this.getPlanetByGraphic(doc)) != null)
            {
               pos = int(planet.getPlanetPosId());
               multiplier = pos % 2 == 0 ? 1 : -1;
               (futureCoord = new DCCoordinate()).x = doc.x;
               futureCoord.y = doc.y + 15 * multiplier;
               if(planet.isFree())
               {
                  delay = DCMath.randomNumber(1,3);
                  (tweenTranslation = TweenEffectsFactory.createSimpleTranslation(doc,futureCoord,5,null)).delay = delay;
                  tweenTranslation.reflect = true;
                  tweenTranslation.repeatCount = 0;
               }
            }
         }
      }
      
      private function performSunFX(dt:int) : void
      {
         var sunIcon:DisplayObjectContainer = null;
         var rotationValue:Number = NaN;
         if(this.mBackgroundSprite != null)
         {
            sunIcon = this.mBackgroundSprite.getChildByName("instance_sun") as DisplayObjectContainer;
            rotationValue = dt / 500;
            if(sunIcon != null)
            {
               sunIcon.rotationZ += rotationValue;
            }
         }
      }
      
      private function performSunStaticFX() : void
      {
         var sunIcon:DisplayObjectContainer = null;
         var tweenDefaultState:GTween = null;
         var tween:GTween = null;
         if(this.mBackgroundSprite != null)
         {
            sunIcon = this.mBackgroundSprite.getChildByName("instance_sun") as DisplayObjectContainer;
            if(sunIcon != null)
            {
               this.setFilterDependingOnType(sunIcon);
            }
            tweenDefaultState = TweenEffectsFactory.createColorAdjustFX(sunIcon,5,tween,false,-50);
            tween = TweenEffectsFactory.createColorAdjustFX(sunIcon,5,tweenDefaultState,true,50);
            tweenDefaultState.nextTween = tween;
         }
      }
      
      private function setFilterDependingOnType(sun:DisplayObjectContainer) : void
      {
         switch(this.mStarType)
         {
            case 0:
               sun.filters = [GameConstants.FILTER_GLOW_RED_LOW];
               break;
            case 1:
               sun.filters = [GameConstants.FILTER_GLOW_BLUE_HIGH];
               break;
            case 2:
               sun.filters = [GameConstants.FILTER_GLOW_GREEN_HIGH];
               break;
            case 3:
               sun.filters = [GameConstants.FILTER_GLOW_WHITE_HIGH];
               break;
            case 4:
               sun.filters = [GameConstants.FILTER_GLOW_PURPLE_HIGH];
               break;
            case 5:
               sun.filters = [GameConstants.FILTER_GLOW_YELLOW_HIGH];
         }
      }
      
      public function performAsteroidFX() : void
      {
         var i:int = 0;
         var key:String = null;
         var asteroid:Sprite = null;
         var pattern:String = null;
         var defaultCoord:DCCoordinate = null;
         var futureCoord:DCCoordinate = null;
         var duration:Number = NaN;
         var tweenBackToDefaultPlace:GTween = null;
         var tweenTranslation:GTween = null;
         if(this.mAsteroidCatalog == null)
         {
            this.mAsteroidCatalog = new Dictionary();
            this.mAsteroidDefaultPositionsCatalog = new Dictionary();
            this.mAsteroidFuturePositionsCatalog = new Dictionary();
            for(i = 0; i <= 9; )
            {
               key = DCUtils.transformValueToString(String(i),3);
               pattern = "asteroids_" + key;
               asteroid = this.mBackgroundSprite.getChildByName(pattern) as Sprite;
               this.mAsteroidCatalog[key] = asteroid;
               defaultCoord = new DCCoordinate();
               futureCoord = new DCCoordinate();
               defaultCoord.x = asteroid.x;
               defaultCoord.y = asteroid.y;
               futureCoord.x = asteroid.x;
               futureCoord.y = asteroid.y + 15;
               this.mAsteroidDefaultPositionsCatalog[key] = defaultCoord;
               this.mAsteroidFuturePositionsCatalog[key] = futureCoord;
               duration = 3;
               tweenBackToDefaultPlace = TweenEffectsFactory.createSimpleTranslation(asteroid,defaultCoord,duration,tweenTranslation,false);
               tweenTranslation = TweenEffectsFactory.createSimpleTranslation(asteroid,futureCoord,duration,tweenBackToDefaultPlace,true);
               tweenBackToDefaultPlace.nextTween = tweenTranslation;
               i++;
            }
         }
      }
   }
}
