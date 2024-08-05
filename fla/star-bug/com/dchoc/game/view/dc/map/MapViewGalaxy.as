package com.dchoc.game.view.dc.map
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.popups.navigation.ESolarSystemPanel;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.flow.FlowStateLoadingBarGalaxyView;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.SolarSystem;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.view.dc.space.SolarSystemView;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.view.display.DCStage;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Quadratic;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.utils.EUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class MapViewGalaxy extends MapView
   {
      
      private static const STATE_NONE:int = 0;
      
      private static const STATE_WAIT_FOR_XML:int = 1;
      
      private static const SERVER_REQUEST_TIME:int = 2000;
      
      private static const SCROLL_OFF_TO_BE_ENABLED:int = 6;
       
      
      private const BOOKMARK_ROWS:int = 4;
      
      private const BOOKMARK_COLS:int = 3;
      
      private const SPACE_STAR_VIEW_MULTIPLIER:int = 200;
      
      private var mSolarSystems:Dictionary;
      
      private var mStarViewCatalog:Dictionary;
      
      private var mCurrentRolloverStar:DisplayObjectContainer;
      
      public var mSolarSystemPlanets:Dictionary;
      
      private var mSolarSystemXML:XML;
      
      private var mStarGraphicsCatalog:Dictionary;
      
      private var mPlanetsGraphicsCatalog:Dictionary;
      
      private var mBookmarksContainer:DisplayObjectContainer;
      
      private var mEmptyPlanets:Vector.<Planet>;
      
      private var mEmptyPlanetClicked:Planet;
      
      private var mEmptyPlanetStar:SolarSystem;
      
      private var mForceToReloadPlanets:Boolean;
      
      private var mServerRequestState:int;
      
      private var mServerRequestTimer:Number = 2000;
      
      private var mServerRequestStartTimer:Boolean = false;
      
      protected var mStage:DCStage;
      
      private var mOldMouseX:int;
      
      private var mOldMouseY:int;
      
      private var mClippingEngineEnabled:Boolean = true;
      
      private var mLastMouseoveredStarId:Number;
      
      private var mEnteringFXOver:Boolean = false;
      
      private const MAX_AMOUNT_BG_TILES:int = 4;
      
      private var mBGTilesCatalog:Dictionary;
      
      protected var mBackgroundSku:String;
      
      protected var mCameraCoords:DCCoordinate;
      
      protected var mScene:Sprite;
      
      protected var mBackgroundDO:Sprite;
      
      private var mStarsLayer:Sprite;
      
      private var mBGTilesAmountAdded:int = 0;
      
      private var mOriginalRequestedCoord:DCCoordinate;
      
      private var mZoomCameraTweenA:GTween;
      
      private var mZoomCameraTweenB:GTween;
      
      private var PLANETS_PANEL_INFO_COLS:int = 4;
      
      private var PLANETS_PANEL_INFO_ROWS:int = 3;
      
      private var mPlanetsPanelContainer:DisplayObjectContainer;
      
      private var mSolarSystemPopup:ESolarSystemPanel;
      
      private var mTotalSolarSystemCount:Number = 0;
      
      private var mScrollIsBegun:Boolean;
      
      private var mScrollCheckStart:Boolean;
      
      private var mScrollMouseDownX:int;
      
      private var mScrollMouseDownY:int;
      
      private var mIsScrollAllowed:Boolean = true;
      
      private const OUT_OF_SCREEN_MAX:int = 400;
      
      private var mBGFirstTimeSetupDone:Boolean = false;
      
      private var mBGForceRefresh:Boolean = false;
      
      private var mNebula1Angle:Number = 2;
      
      private var mNebula2Angle:Number = 4;
      
      private var mNebula1AngleFactor:Number = 0.001;
      
      private var mNebula2AngleFactor:Number = -0.002;
      
      private var mTileEngineEnabled:Boolean = true;
      
      private var mParallaxEngineEnabled:Boolean = true;
      
      private var mMinCoordWindow:DCCoordinate;
      
      private var mMaxCoordWindow:DCCoordinate;
      
      private var mWaitingGalaxyWindowResponseFromServer:Boolean = false;
      
      private var mGuiAttackEvent:Object;
      
      public function MapViewGalaxy()
      {
         super();
      }
      
      public function getLastMouseoveredStarId() : Number
      {
         return this.mLastMouseoveredStarId;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 5;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         super.logicUpdateDo(dt);
         if(this.mServerRequestStartTimer == true)
         {
            if(this.mServerRequestState == 1 && this.mServerRequestTimer <= 0)
            {
               this.mServerRequestStartTimer = false;
               this.mServerRequestState = 0;
               this.mServerRequestTimer = 2000;
            }
            else
            {
               this.mServerRequestTimer -= dt;
            }
         }
         if(mUiEnabled && (this.mOldMouseX != this.mStage.getMouseX() || this.mOldMouseY != this.mStage.getMouseY()))
         {
            this.onMouseMoveCoors(this.mStage.getMouseX(),this.mStage.getMouseY());
         }
         this.checkBGTilePosition(dt);
         this.onRollOverLogicUpdate(dt);
      }
      
      override protected function loadDoStep(step:int) : void
      {
         super.loadDoStep(step);
         if(step == 0)
         {
            this.mStage = InstanceMng.getApplication().stageGetStage();
            this.mOldMouseX = this.mStage.getMouseX();
            this.mOldMouseY = this.mStage.getMouseY();
         }
      }
      
      override protected function unloadDo() : void
      {
         super.unloadDo();
         this.mBackgroundSku = null;
         this.mStage = null;
         this.guiUnload();
      }
      
      override protected function unbuildDo() : void
      {
         this.galaxyDataStructuresUnbuild();
         this.backgroundUnbuild();
         InstanceMng.getResourceMng().imagesReleaseGroup("space");
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var thisMsg:* = null;
         var e:Object = null;
         var userDataMng:UserDataMng = null;
         var galaxyXML:XML = null;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         switch(step)
         {
            case 0:
               this.mBackgroundSku = InstanceMng.getBackgroundController().getSpaceBgSkuByMapView("background_galaxy");
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
               if(InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_GALAXY_WINDOW))
               {
                  this.mOriginalRequestedCoord = FlowStateLoadingBarGalaxyView.getCoordinates(0);
                  galaxyXML = (userDataMng = InstanceMng.getUserDataMng()).getFileXML(UserDataMng.KEY_GALAXY_WINDOW);
                  this.loadSolarSystemsFromXML(galaxyXML);
                  buildAdvanceSyncStep();
               }
               break;
            case 4:
               if(InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_BOOKMARKS))
               {
                  setUserBookmarks(InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_BOOKMARKS));
                  buildAdvanceSyncStep();
                  break;
               }
         }
      }
      
      override protected function beginDo() : void
      {
         mViewMng.mapBackgroundAddToStage(this.mScene);
         InstanceMng.getViewMng().setBackgroundColor(395536);
         this.performEnteringFX();
      }
      
      override protected function endDo() : void
      {
         this.mLastMouseoveredStarId = -1;
         mViewMng.mapBackgroundRemoveFromStage(this.mScene);
         this.mEnteringFXOver = false;
      }
      
      private function unbuildBGTileset() : void
      {
         this.mBGTilesCatalog = null;
         this.mBGTilesAmountAdded = 0;
      }
      
      protected function backgroundUnbuild() : void
      {
         this.mScene = null;
         this.mBackgroundDO = null;
         this.mStarsLayer = null;
         this.mCameraCoords = null;
         this.mBGFirstTimeSetupDone = false;
         this.mBGForceRefresh = false;
         if(this.mBackgroundSku != null)
         {
            InstanceMng.getResourceMng().unloadResource(this.mBackgroundSku);
            this.mBackgroundSku = null;
         }
         this.unbuildBGTileset();
      }
      
      public function getBackGroundDO() : Sprite
      {
         return this.mBackgroundDO;
      }
      
      protected function backgroundBuild() : void
      {
         this.mScene = new Sprite();
         this.mBackgroundDO = new Sprite();
         this.mStarsLayer = new Sprite();
         this.mScene.addChild(this.mBackgroundDO);
         this.mScene.addChild(this.mStarsLayer);
         this.mCameraCoords = new DCCoordinate();
         this.mBGTilesCatalog = new Dictionary();
         this.createBGTiles();
      }
      
      private function createBGTiles() : void
      {
         var i:int = 0;
         for(i = 0; i < 4; )
         {
            this.addBackgroundTile();
            i++;
         }
      }
      
      private function addBackgroundTile() : Object
      {
         var resourceMng:ResourceMng = null;
         var bg:Sprite = null;
         var bgStars:Sprite = null;
         var obj:Object = null;
         var bgNebula1:Sprite = null;
         var bgNebula2:Sprite = null;
         if(this.mBackgroundDO == null)
         {
            return null;
         }
         bg = new ((resourceMng = InstanceMng.getResourceMng()).getSWFClass(this.mBackgroundSku,"background"))() as Sprite;
         bgStars = new (resourceMng.getSWFClass(this.mBackgroundSku,"stars"))() as Sprite;
         bg.x = 0;
         bg.y = 0;
         obj = {};
         obj.bg = bg;
         obj.stars = bgStars;
         this.mBackgroundDO.addChild(bg);
         this.mBackgroundDO.addChild(bgStars);
         if(InstanceMng.getApplication().getGameQuality() == 1 && false)
         {
            bgNebula1 = new (resourceMng.getSWFClass(this.mBackgroundSku,"layer_02"))() as Sprite;
            bgNebula2 = new (resourceMng.getSWFClass(this.mBackgroundSku,"layer_03"))() as Sprite;
            bgNebula1.blendMode = "add";
            bgNebula2.blendMode = "add";
            bgNebula1.alpha = 0.2;
            bgNebula2.alpha = 0.5;
            obj.nebula1 = bgNebula1;
            obj.nebula2 = bgNebula2;
            this.mBackgroundDO.addChild(bgNebula1);
            this.mBackgroundDO.addChild(bgNebula2);
         }
         this.mBGTilesCatalog[this.mBGTilesAmountAdded] = obj;
         this.mBGTilesAmountAdded++;
         return obj;
      }
      
      private function centerCameraInRequestedCoordinate(tween:GTween = null) : void
      {
         var coords:DCCoordinate = FlowStateLoadingBarGalaxyView.getCoordinates(0);
         this.centerCameraByStarCoords(coords);
      }
      
      private function zoomCameraOnStar(coords:DCCoordinate) : void
      {
         var p:Point = null;
         var solarSystemView:DisplayObjectContainer = this.getStarViewByCoords(coords);
         if(solarSystemView != null)
         {
            p = new Point(solarSystemView.x,solarSystemView.y);
            p = this.mScene.localToGlobal(p);
            if(this.mZoomCameraTweenA != null)
            {
               this.mZoomCameraTweenA.end();
            }
            if(this.mZoomCameraTweenB != null)
            {
               this.mZoomCameraTweenB.end();
            }
            this.mZoomCameraTweenA = TweenEffectsFactory.createBlurredZoom(0,this.mScene,1,0.65,0.35,p,true);
            this.mZoomCameraTweenB = TweenEffectsFactory.createBlurredZoom(0,this.mScene,1,1,0.35,p,false);
            this.mZoomCameraTweenA.nextTween = this.mZoomCameraTweenB;
         }
      }
      
      private function addSolarSystemViewEventListeners(starView:SolarSystemView) : void
      {
         starView.addEventListener("rollOver",this.onRollOver,false,0,true);
         starView.addEventListener("rollOut",this.onRollOut,false,0,true);
      }
      
      private function performEnteringFX() : void
      {
         var doc:DisplayObjectContainer = null;
         var coords:DCCoordinate = null;
         var solarSystemView:DisplayObjectContainer = null;
         var p:Point = null;
         if(InstanceMng.getApplication().isHighQualityEnabled())
         {
            doc = InstanceMng.getApplication().getDisplayObjectContainerByView();
            coords = FlowStateLoadingBarGalaxyView.getCoordinates(0);
            solarSystemView = this.getStarViewByCoords(coords);
            if(solarSystemView != null)
            {
               InstanceMng.getTopHudFacade().refreshGoToCoordsTextfields(coords);
               this.centerCameraByStarCoords(coords);
               p = new Point(solarSystemView.x,solarSystemView.y);
               p = this.mScene.localToGlobal(p);
               TweenEffectsFactory.createTransition(doc,1,p,p,2,1,0,1,Quadratic.easeOut,Quadratic.easeIn);
            }
            else
            {
               this.mEnteringFXOver = true;
               this.centerCameraInRequestedCoordinate();
            }
         }
         else
         {
            this.mEnteringFXOver = true;
            this.centerCameraInRequestedCoordinate();
         }
         this.mEnteringFXOver = true;
      }
      
      public function getEmptyPlanetClicked() : Planet
      {
         return this.mEmptyPlanetClicked;
      }
      
      public function setEmptyPlanetClicked(planet:Planet) : void
      {
         this.mEmptyPlanetClicked = planet;
      }
      
      private function onRollOut(e:MouseEvent) : void
      {
         if(this.mCurrentRolloverStar != null)
         {
            this.mCurrentRolloverStar.filters = null;
         }
         this.mCurrentRolloverStar = null;
      }
      
      private function resetCurrentRollOverStar() : void
      {
         if(this.mCurrentRolloverStar != null)
         {
            this.mCurrentRolloverStar.filters = null;
         }
         this.mCurrentRolloverStar = null;
      }
      
      private function onRollOver(e:MouseEvent) : void
      {
         if(this.mScrollIsBegun == false)
         {
            this.mCurrentRolloverStar = DisplayObjectContainer(e.target);
            this.mCurrentRolloverStar.filters = [GameConstants.FILTER_GLOW_BLUE_LOW];
         }
      }
      
      private function onRollOverLogicUpdate(dt:int) : void
      {
         var solarSystemAsset:DisplayObjectContainer = null;
         var rotationValue:Number = NaN;
         if(this.mCurrentRolloverStar != null)
         {
            solarSystemAsset = ESpriteContainer(this.mCurrentRolloverStar).getContent("icon_star") as DisplayObjectContainer;
            rotationValue = dt / 500;
            if(solarSystemAsset != null)
            {
               solarSystemAsset.rotation += rotationValue;
            }
         }
      }
      
      private function showStarInfo() : void
      {
         var star:SolarSystem = this.mStarGraphicsCatalog[this.mCurrentRolloverStar];
         if(star == null)
         {
            return;
         }
         var planetList:Vector.<Planet> = this.getPlanetListBySolarSystemCoords(star.getCoords());
         if(this.mForceToReloadPlanets)
         {
            if(planetList != null)
            {
               planetList = null;
               this.deletePlanetListBySolarSystemCoords(star.getCoords());
               this.mSolarSystems[star.getCoords().toStringWithNoParentheses(true)] = star;
            }
            this.mForceToReloadPlanets = false;
         }
         if(planetList == null)
         {
            if(this.mServerRequestState == 0)
            {
               InstanceMng.getApplication().solarSystemInfoWait(star.getCoords(),star.getId());
               this.mServerRequestState = 1;
               this.mServerRequestStartTimer = true;
               this.mServerRequestTimer = 2000;
            }
         }
         if(planetList != null)
         {
            this.mEmptyPlanets = this.getEmptyPlanetsFromPlanetsList(star,planetList);
         }
         this.mSolarSystemPopup = InstanceMng.getUIFacade().getPopupFactory().getSolarSystemPlanetsPopup(planetList,this.mEmptyPlanets,star,this.getStarIsBookmarked(star.getId())) as ESolarSystemPanel;
         InstanceMng.getUIFacade().enqueuePopup(this.mSolarSystemPopup);
      }
      
      public function loadSolarSystemsFromXML(galaxyStars:XML, serverResponseReceived:Boolean = false) : void
      {
         var solarSystemXML:XML = null;
         var sku:String = null;
         var coordX:String = null;
         var coordY:String = null;
         var solarSystem:SolarSystem = null;
         var arrCoords:Array = null;
         var coord:DCCoordinate = null;
         var isMinCoordLocalInside:Boolean = false;
         var isMaxCoordLocalInside:Boolean = false;
         if(this.mSolarSystems == null)
         {
            this.mSolarSystems = new Dictionary();
         }
         var localStarsCounter:int = 0;
         var addToGalaxy:Boolean = true;
         var maxCoordReceived:DCCoordinate = new DCCoordinate(0,0);
         var minCoordReceived:DCCoordinate = new DCCoordinate();
         var firstRound:Boolean = true;
         for each(solarSystemXML in EUtils.xmlGetChildrenList(galaxyStars,"SpaceStar"))
         {
            coord = new DCCoordinate();
            if((sku = EUtils.xmlReadString(solarSystemXML,"sku")) != null)
            {
               arrCoords = sku.split(":");
            }
            coordX = String(arrCoords[0] != null ? arrCoords[0] : "-1");
            coordY = String(arrCoords[1] != null ? arrCoords[1] : "-1");
            coord.x = Number(coordX);
            coord.y = Number(coordY);
            addToGalaxy = true;
            if(this.mMinCoordWindow != null && this.mMaxCoordWindow != null)
            {
               isMinCoordLocalInside = coord.isContainedInCoords(this.mMinCoordWindow,this.mMaxCoordWindow);
               isMaxCoordLocalInside = coord.isContainedInCoords(this.mMinCoordWindow,this.mMaxCoordWindow);
               addToGalaxy = isMinCoordLocalInside && isMaxCoordLocalInside;
            }
            if(addToGalaxy && this.mSolarSystems[coordX + "," + coordY] == null)
            {
               localStarsCounter++;
               this.mTotalSolarSystemCount++;
               (solarSystem = new SolarSystem()).setName(EUtils.xmlReadString(solarSystemXML,"name"));
               solarSystem.setCoordX(Number(coordX));
               solarSystem.setCoordY(Number(coordY));
               solarSystem.setType(EUtils.xmlReadInt(solarSystemXML,"type"));
               solarSystem.setId(EUtils.xmlReadNumber(solarSystemXML,"starId"));
               solarSystem.setFreePlanetsAmount(EUtils.xmlReadNumber(solarSystemXML,"planetsFree"));
               solarSystem.setOccupiedPlanetsAmount(EUtils.xmlReadNumber(solarSystemXML,"planetsOccupied"));
               this.mSolarSystems[coordX + "," + coordY] = solarSystem;
               if(firstRound)
               {
                  minCoordReceived.x = coord.x;
                  minCoordReceived.y = coord.y;
                  firstRound = false;
               }
               if(coord.x >= maxCoordReceived.x && coord.y >= maxCoordReceived.y)
               {
                  maxCoordReceived.x = coord.x;
                  maxCoordReceived.y = coord.y;
               }
               if(coord.x < minCoordReceived.x && coord.y < minCoordReceived.y)
               {
                  minCoordReceived.x = coord.x;
                  minCoordReceived.y = coord.y;
               }
            }
         }
         this.mMinCoordWindow = minCoordReceived;
         this.mMaxCoordWindow = maxCoordReceived;
         this.fillGalaxy();
         if(serverResponseReceived)
         {
            coord = this.getStarCoordsByScenePosition();
            this.removeSolarSystemsOutOfWindow(coord);
         }
      }
      
      public function setWaitingForServerResponse(value:Boolean) : void
      {
         this.mWaitingGalaxyWindowResponseFromServer = value;
      }
      
      public function getSolarSystemByCoords(coords:DCCoordinate) : SolarSystem
      {
         var returnValue:SolarSystem = null;
         if(this.mSolarSystems != null)
         {
            returnValue = this.mSolarSystems[coords.x + "," + coords.y];
         }
         return returnValue;
      }
      
      public function getSolarSystemById(starId:int) : SolarSystem
      {
         var solarSystem:SolarSystem = null;
         if(this.mSolarSystems != null)
         {
            for each(solarSystem in this.mSolarSystems)
            {
               if(solarSystem.getId() == starId)
               {
                  return solarSystem;
               }
            }
         }
         return null;
      }
      
      public function fillGalaxy() : void
      {
         var star:SolarSystem = null;
         var starView:SolarSystemView = null;
         var starDOC:DisplayObjectContainer = null;
         if(this.mSolarSystems == null)
         {
            return;
         }
         for each(star in this.mSolarSystems)
         {
            if(this.mStarViewCatalog == null)
            {
               this.mStarViewCatalog = new Dictionary();
            }
            if(star != null)
            {
               if(this.mStarViewCatalog[star.getCoordsForIndexing()] == null)
               {
                  this.createSolarSystemInstance(star);
               }
               else
               {
                  starDOC = this.mStarViewCatalog[star.getCoordsForIndexing()];
                  if(!this.mStarsLayer.contains(starDOC))
                  {
                     this.addSolarSystemInstance(null,starDOC,star.getCoords());
                  }
               }
            }
         }
         this.reorderSolarSystemsDepth();
      }
      
      public function reorderSolarSystemsDepth() : void
      {
         var star:DisplayObjectContainer = null;
         var solarSystemsZ:Array = [];
         var i:int = 0;
         if(this.mStarsLayer != null)
         {
            for each(star in this.mStarViewCatalog)
            {
               if(star != null)
               {
                  if(this.mStarsLayer.contains(star))
                  {
                     solarSystemsZ[i] = star;
                     this.mStarsLayer.removeChild(star);
                     i++;
                  }
               }
            }
            if(solarSystemsZ != null)
            {
               solarSystemsZ.sortOn("z",16 | 2);
               for(i = 0; i < solarSystemsZ.length; )
               {
                  this.mStarsLayer.addChild(solarSystemsZ[i]);
                  i++;
               }
            }
         }
      }
      
      private function addSolarSystemInstance(solarSystem:SolarSystemView, solarSystemDOC:DisplayObjectContainer = null, coords:DCCoordinate = null) : void
      {
         var coord:DCCoordinate = null;
         var doc:DisplayObjectContainer = null;
         var text:String = null;
         if(solarSystem == null && solarSystemDOC == null || this.mStarsLayer == null)
         {
            return;
         }
         if(solarSystemDOC != null)
         {
            this.mStarsLayer.addChild(solarSystemDOC);
         }
         else
         {
            this.mStarsLayer.addChild(solarSystem);
         }
         coord = coords != null ? coords : solarSystem.getSolarSystemCoords();
         doc = solarSystemDOC == null ? solarSystem : solarSystemDOC;
         text = "Coords: " + coord.toString(true);
         if(Config.useEsparragonGUI() && !InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
         {
            ETooltipMng.getInstance().createTooltipForStarDisplayObject(text,doc,true,false);
         }
         doc.addEventListener("mouseOver",this.onUpdateLastStarIdMouseOvered,false,0,true);
      }
      
      private function getCoordToDrawByPosition(c:DCCoordinate) : DCCoordinate
      {
         var x:int = 0;
         var y:int = 0;
         var coord:DCCoordinate = null;
         var randomOffsetXY:Number = NaN;
         if(c != null)
         {
            coord = new DCCoordinate();
            coord.x = c.x;
            coord.y = c.y;
            DCMath.initSimpleRand(coord.x * 189367 + coord.y * 894643);
            randomOffsetXY = 60 * DCMath.simpleRandomNumber() + 1;
            coord.x = coord.x * 200 + randomOffsetXY;
            coord.y = coord.y * 200 + randomOffsetXY;
         }
         return coord;
      }
      
      public function createSolarSystemInstance(info:SolarSystem) : SolarSystemView
      {
         var coord:DCCoordinate = this.getCoordToDrawByPosition(info.getCoords());
         var solarSystem:SolarSystemView;
         (solarSystem = new SolarSystemView()).setupView();
         solarSystem.logicLeft = coord.x;
         solarSystem.logicTop = coord.y;
         solarSystem.setInfo(info.getId(),info.getName(),info.getCoords(),info.getType(),info.getOccupiedPlanetsAmount());
         var iconContainer:DisplayObjectContainer = solarSystem.getContent("icon_star") as DisplayObjectContainer;
         var minValue:int = 1;
         var maxValue:int = 400;
         var depth:Number = DCMath.simpleRandBetween(minValue,maxValue);
         solarSystem.z = depth;
         var textContainer:ESprite;
         (textContainer = solarSystem.getContent("text_name")).scaleX = 1.2;
         textContainer.scaleY = 1.2;
         var textContainer2:ESprite;
         (textContainer2 = solarSystem.getContent("text_parameters")).scaleX = textContainer.scaleX;
         textContainer2.scaleY = textContainer.scaleY;
         var orientation:Number = DCMath.simpleRandBetween(0,360);
         iconContainer.rotation = orientation;
         this.addSolarSystemViewEventListeners(solarSystem);
         this.mStarViewCatalog[info.getCoords().toStringWithNoParentheses(true)] = solarSystem;
         this.addSolarSystemInstance(solarSystem);
         if(this.mStarGraphicsCatalog == null)
         {
            this.mStarGraphicsCatalog = new Dictionary();
         }
         this.mStarGraphicsCatalog[solarSystem] = info;
         return solarSystem;
      }
      
      public function getStarViewByCoords(coord:DCCoordinate) : DisplayObjectContainer
      {
         var returnValue:DisplayObjectContainer = null;
         if(this.mStarViewCatalog != null && coord != null)
         {
            returnValue = this.mStarViewCatalog[coord.toStringWithNoParentheses(true)];
         }
         return returnValue;
      }
      
      private function galaxyDataStructuresUnbuild() : void
      {
         this.removeSolarSystemsFromDisplayList();
         this.mSolarSystemXML = null;
         this.mSolarSystems = null;
         this.mSolarSystemPlanets = null;
         this.mStarGraphicsCatalog = null;
         this.mStarViewCatalog = null;
         mBookmarksList = null;
         this.mBookmarksContainer = null;
      }
      
      private function removeSolarSystemsFromDisplayList() : void
      {
         var solarSystem:SolarSystem = null;
         var doc:DisplayObjectContainer = null;
         for each(solarSystem in this.mSolarSystems)
         {
            this.removeSolarSystemFromStage(solarSystem);
         }
      }
      
      override public function loadPlanetsFromXML(info:XML) : void
      {
         var planetXML:XML = null;
         var planet:Planet = null;
         var starAttached:SolarSystem = null;
         var coordsArr:Array = EUtils.xmlReadString(info,"sku").split(":");
         var coords:DCCoordinate;
         (coords = new DCCoordinate()).x = coordsArr[0];
         coords.y = coordsArr[1];
         this.mSolarSystemXML = info;
         var planetsList:Vector.<Planet> = new Vector.<Planet>(0);
         if(this.mSolarSystemPlanets == null)
         {
            this.mSolarSystemPlanets = new Dictionary();
         }
         for each(planetXML in EUtils.xmlGetChildrenList(this.mSolarSystemXML,"Planet"))
         {
            InstanceMng.getUserInfoMng().addOtherPlayerInfo(planetXML);
            InstanceMng.getUserInfoMng().setPlanetInfoToPlayer(planetXML);
            (planet = new Planet()).setSku(EUtils.xmlReadString(planetXML,"sku"));
            planet.setAccIdOwner(EUtils.xmlReadString(planetXML,"accountId"));
            planet.setHQLevel(EUtils.xmlReadInt(planetXML,"HQLevel"));
            planet.setURL(EUtils.xmlReadString(planetXML,"url"));
            planet.setType(EUtils.xmlReadString(planetXML,"type"));
            planet.setIsCapital(EUtils.xmlReadBoolean(planetXML,"capital"));
            planet.setPlanetId(EUtils.xmlReadString(planetXML,"planetId"));
            planet.setDamageProtection(EUtils.xmlReadNumber(planetXML,"damageProtectionTimeLeft"));
            planet.setReserved(EUtils.xmlReadBoolean(planetXML,"reserved"));
            planet.setNotBuilt(EUtils.xmlReadBoolean(planetXML,"notBuilt"));
            planet.setColonyIdx(parseInt(planet.getPlanetId()) - 1);
            planet.setName(planet.getStringId());
            planet.setParentStarId(EUtils.xmlReadNumber(this.mSolarSystemXML,"starId"));
            planet.setParentStarName(EUtils.xmlReadString(this.mSolarSystemXML,"name"));
            planet.setParentStarType(EUtils.xmlReadInt(this.mSolarSystemXML,"type"));
            planetsList.push(planet);
         }
         this.mSolarSystemPlanets[coords.toStringWithNoParentheses(true)] = planetsList;
         if(this.mSolarSystemPopup != null && this.mSolarSystemPopup.isPopupBeingShown())
         {
            starAttached = this.mSolarSystemPopup.getStar();
            this.mEmptyPlanets = this.getEmptyPlanetsFromPlanetsList(starAttached,planetsList);
            this.mSolarSystemPopup.setupPopup(planetsList,this.mEmptyPlanets,this.getStarIsBookmarked(starAttached.getId()));
         }
         this.mSolarSystemXML = null;
      }
      
      private function getEmptyPlanetsFromPlanetsList(star:SolarSystem, occupiedPlanets:Vector.<Planet>) : Vector.<Planet>
      {
         var emptyPlanets:Vector.<Planet> = null;
         var emptyPlanetsCount:int = 0;
         var occupiedPlanetsCount:int = 0;
         var planetsToDiscount:int = 0;
         var planetsIndexes:Vector.<int> = null;
         var planetIndex:int = 0;
         var existIndex:Boolean = false;
         var planetSku:* = null;
         var planet:Planet = null;
         var p:int = 0;
         var i:int = 0;
         if(occupiedPlanets != null)
         {
            occupiedPlanetsCount = int(occupiedPlanets.length);
            planetsIndexes = new Vector.<int>(0);
            for(p = 1; p <= 12; )
            {
               existIndex = false;
               for(i = 0; i < occupiedPlanetsCount; )
               {
                  planetIndex = parseInt(occupiedPlanets[i].getSku().split(":")[2]);
                  if(planetIndex == p)
                  {
                     existIndex = true;
                     break;
                  }
                  i++;
               }
               if(!existIndex)
               {
                  planetsIndexes.push(p);
               }
               p++;
            }
            emptyPlanetsCount = int(planetsIndexes.length);
            emptyPlanets = new Vector.<Planet>(emptyPlanetsCount);
            planetSku = star.getCoordX() + ":" + star.getCoordY() + ":";
            for(p = 0; p < emptyPlanetsCount; )
            {
               (planet = new Planet()).setSku(planetSku + planetsIndexes[p]);
               planet.setAccIdOwner(null);
               planet.setHQLevel(0);
               planet.setURL(null);
               planet.setIsCapital(false);
               planet.setPlanetId("1");
               planet.setDamageProtection(0);
               planet.setReserved(false);
               planet.setNotBuilt(false);
               planet.setType(star.getType().toString());
               planet.setName("");
               planet.setParentStarId(star.getId());
               planet.setParentStarName(star.getName());
               planet.setParentStarType(star.getType());
               emptyPlanets[p] = planet;
               p++;
            }
         }
         return emptyPlanets;
      }
      
      public function getPlanetListBySolarSystemCoords(coords:DCCoordinate) : Vector.<Planet>
      {
         if(this.mSolarSystemPlanets == null)
         {
            return null;
         }
         return this.mSolarSystemPlanets[coords.toStringWithNoParentheses(true)];
      }
      
      private function deletePlanetListBySolarSystemCoords(coords:DCCoordinate) : void
      {
         if(this.mSolarSystemPlanets != null)
         {
            this.mSolarSystemPlanets[coords.toStringWithNoParentheses(true)] = null;
            delete this.mSolarSystemPlanets[coords.toStringWithNoParentheses(true)];
         }
      }
      
      public function getBookmarksList() : Vector.<Dictionary>
      {
         return mBookmarksList;
      }
      
      private function setBookmarkEvents(bookmark:SolarSystemView) : void
      {
         bookmark.addEventListener("click",function(evt:MouseEvent):void
         {
            onBookmarkClick(bookmark);
         },true);
         bookmark.addEventListener("rollOver",this.onBookmarkRollOver,false,0,true);
         bookmark.addEventListener("rollOut",this.onBookmarkRollOut,false,0,true);
      }
      
      private function onBookmarkClick(bookmark:SolarSystemView) : void
      {
         this.centerCameraByStarCoords(bookmark.getSolarSystemCoords(),true);
      }
      
      private function onBookmarkRollOver(e:MouseEvent) : void
      {
         var bookmark:DisplayObjectContainer = null;
         bookmark = DisplayObjectContainer(e.target);
         if(bookmark != null)
         {
            bookmark.filters = [GameConstants.FILTER_GLOW_GREEN_LOW];
         }
      }
      
      private function onBookmarkRollOut(e:MouseEvent) : void
      {
         var bookmark:DisplayObjectContainer = null;
         bookmark = DisplayObjectContainer(e.target);
         if(bookmark != null)
         {
            bookmark.filters = null;
         }
      }
      
      public function getStarIsBookmarked(starId:Number) : Boolean
      {
         var solarSystemObj:Dictionary = null;
         var i:int = 0;
         var returnValue:Boolean = false;
         if(mBookmarksList == null)
         {
            return false;
         }
         i = 0;
         while(i < mBookmarksList.length)
         {
            solarSystemObj = mBookmarksList[i];
            if(solarSystemObj["id"] == starId)
            {
               returnValue = true;
            }
            i++;
         }
         return returnValue;
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         this.scrollEnd();
         super.uiDisableDo();
      }
      
      public function uiMouseDownCoors(x:int, y:int) : void
      {
         this.mScrollCheckStart = this.mIsScrollAllowed;
         this.mScrollMouseDownX = x;
         this.mScrollMouseDownY = y;
      }
      
      public function uiMouseMoveCoors(x:int, y:int) : void
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var adx:Number = NaN;
         var ady:Number = NaN;
         if(this.mScrollCheckStart)
         {
            dx = x - this.mScrollMouseDownX;
            dy = y - this.mScrollMouseDownY;
            if(!this.mScrollIsBegun)
            {
               adx = Math.abs(dx);
               ady = Math.abs(dy);
               if(adx > 6 || ady > 6)
               {
                  this.scrollBegin();
               }
            }
         }
         if(this.mScrollIsBegun)
         {
            this.mScrollMouseDownX = x;
            this.mScrollMouseDownY = y;
            this.getSceneCoords();
            dx *= 2;
            dy *= 2;
            this.moveCameraSmooth(dx,dy);
         }
      }
      
      public function uiMouseUpCoors(x:int, y:int) : void
      {
         if(mUiEnabled)
         {
            if(this.mScrollIsBegun)
            {
               this.scrollEnd(true);
            }
            else
            {
               this.mScrollCheckStart = false;
               if(this.mCurrentRolloverStar != null)
               {
                  this.showStarInfo();
               }
            }
         }
      }
      
      private function scrollBegin() : void
      {
         this.mScrollIsBegun = true;
         InstanceMng.getGUIController().cursorSetId(4);
      }
      
      private function scrollEnd(checkIfStarsRequest:Boolean = false) : void
      {
         this.mScrollIsBegun = false;
         this.mScrollCheckStart = false;
         InstanceMng.getGUIController().cursorSetId(-1);
         if(this.mEnteringFXOver && checkIfStarsRequest)
         {
            this.checkIfStarsRequestIsNeeded(null,false);
         }
      }
      
      public function hasScrollBegun() : Boolean
      {
         return this.mScrollIsBegun;
      }
      
      override public function addMouseEvents() : void
      {
         if(this.mScene != null && this.mBackgroundDO != null)
         {
            this.mScene.addEventListener("mouseOver",this.onMouseOver,false,0,true);
         }
      }
      
      override public function removeMouseEvents() : void
      {
         if(this.mScene != null && this.mBackgroundDO != null)
         {
            this.mScene.removeEventListener("mouseOver",this.onMouseOver,false);
         }
      }
      
      override public function onMouseOver(e:MouseEvent) : void
      {
         uiEnable();
      }
      
      override public function onMouseOut(e:MouseEvent) : void
      {
         uiDisable();
      }
      
      override public function onMouseMoveCoors(x:int, y:int) : void
      {
         this.uiMouseMoveCoors(x,y);
      }
      
      override public function onMouseDown(e:MouseEvent) : void
      {
         if(!mUiEnabled)
         {
            return;
         }
         var x:int = this.mStage.getMouseX();
         var y:int = this.mStage.getMouseY();
         this.uiMouseDownCoors(x,y);
      }
      
      override public function onMouseUp(e:MouseEvent) : void
      {
         if(!mUiEnabled)
         {
            return;
         }
         var x:int = this.mStage.getMouseX();
         var y:int = this.mStage.getMouseY();
         this.uiMouseUpCoors(x,y);
      }
      
      public function getCameraCoords() : DCCoordinate
      {
         var returnValue:DCCoordinate = new DCCoordinate();
         returnValue.x = this.mScene.x;
         returnValue.y = this.mScene.y;
         return returnValue;
      }
      
      private function updateCameraPosition(x:int, y:int) : void
      {
         if(this.mCameraCoords != null)
         {
            this.mCameraCoords.x = x;
            this.mCameraCoords.y = y;
         }
      }
      
      public function moveCameraSmooth(posX:int, posY:int) : void
      {
         var x:int = this.mScene.x + posX;
         var y:int = this.mScene.y + posY;
         this.moveCameraToScreenCoords(x,y,false,false);
      }
      
      public function moveCameraToScreenCoords(posX:int, posY:int, lockUI:Boolean = false, requestServer:Boolean = true) : void
      {
         if(posX > 400)
         {
            posX = 400;
         }
         if(posY > 400)
         {
            posY = 400;
         }
         this.mScene.x = posX;
         this.mScene.y = posY;
         this.updateCameraPosition(posX,posY);
         if(this.mEnteringFXOver && requestServer)
         {
            this.checkIfStarsRequestIsNeeded(null,lockUI);
         }
         var coord:DCCoordinate = this.getStarCoordsByScenePosition();
         InstanceMng.getTopHudFacade().refreshGoToCoordsTextfields(coord);
      }
      
      public function setTileEngineEnabled(value:Boolean) : void
      {
         this.mTileEngineEnabled = value;
      }
      
      public function setParallaxEngineEnabled(value:Boolean) : void
      {
         this.mParallaxEngineEnabled = value;
      }
      
      public function setBGForceRefresh(value:Boolean) : void
      {
         this.mBGForceRefresh = value;
      }
      
      private function checkBGTilePosition(dt:int, parallaxFactor:Number = 0.55) : void
      {
         var bgObj:Object = null;
         var bg:Sprite = null;
         var stars:Sprite = null;
         var bgWidth:Number = NaN;
         var bgHeight:Number = NaN;
         var numTilesX:int = 0;
         var numTilesY:int = 0;
         var k:int = 0;
         var divX:int = 0;
         var divY:int = 0;
         var offsetX:int = 0;
         var offsetY:int = 0;
         var offsetStarsX:int = 0;
         var offsetStarsY:int = 0;
         var i:int = 0;
         var nebula1:Sprite = null;
         var nebula2:Sprite = null;
         var offsetNebulaX1:int = 0;
         var offsetNebulaY1:int = 0;
         var offsetNebulaX2:int = 0;
         var offsetNebulaY2:int = 0;
         var sum:int = 0;
         var nebula1Alpha:Number = NaN;
         var nebula2Alpha:Number = NaN;
         var j:int = 0;
         var userHighQuality:Boolean = InstanceMng.getApplication().isHighQualityEnabled();
         var refreshBG:Boolean = this.mBGFirstTimeSetupDone == false || this.mBGForceRefresh == true ? true : this.mScrollIsBegun;
         if(this.mBGTilesCatalog != null && this.mStage != null && this.mCameraCoords != null && this.mTileEngineEnabled && refreshBG)
         {
            this.mBGFirstTimeSetupDone = true;
            this.mBGForceRefresh = false;
            bg = (bgObj = this.mBGTilesCatalog[0]).bg as Sprite;
            stars = bgObj.stars as Sprite;
            bgWidth = bg.width;
            bgHeight = bg.height;
            numTilesX = this.mStage.getStageWidth() / bgWidth + 4;
            numTilesY = this.mStage.getStageHeight() / bgHeight + 4;
            k = 0;
            divX = this.mCameraCoords.x / bgWidth;
            divY = this.mCameraCoords.y / bgHeight;
            offsetX = this.mCameraCoords.x * parallaxFactor % bgWidth;
            offsetY = this.mCameraCoords.y * parallaxFactor % bgHeight;
            offsetStarsX = offsetX - (-bgWidth + this.mCameraCoords.x * parallaxFactor * 0.5) % bgWidth;
            offsetStarsY = offsetY - (-bgHeight + this.mCameraCoords.y * parallaxFactor * 0.5) % bgHeight;
            if(userHighQuality && this.mParallaxEngineEnabled)
            {
               nebula1 = bgObj.nebula1 as Sprite;
               nebula2 = bgObj.nebula2 as Sprite;
               offsetNebulaX1 = offsetX - (-bgWidth + this.mCameraCoords.x * parallaxFactor * 0.6) % bgWidth;
               offsetNebulaY1 = offsetY - (-bgHeight + this.mCameraCoords.y * parallaxFactor * 0.6) % bgHeight;
               offsetNebulaX2 = offsetX - (-bgWidth + this.mCameraCoords.x * parallaxFactor * 0.4) % bgWidth;
               offsetNebulaY2 = offsetY - (-bgHeight + this.mCameraCoords.y * parallaxFactor * 0.4) % bgHeight;
               offsetNebulaX1 += Math.cos(this.mNebula1Angle / 1000) * bgWidth * 0.5 * 0.5;
               offsetNebulaY1 += Math.sin(this.mNebula1Angle / 1000) * bgHeight * 0.5 * 0.5;
               offsetNebulaX2 += Math.cos(this.mNebula2Angle / 1000) * bgWidth * 0.7 * 0.5;
               offsetNebulaY2 += Math.sin(this.mNebula2Angle / 1000) * bgHeight * 0.7 * 0.5;
               sum = this.mCameraCoords.x + this.mCameraCoords.y;
               nebula1Alpha = 0.2 + Math.cos(sum / 3000) / 5;
               nebula2Alpha = 0.5 + Math.sin(sum / 7000) / 5;
            }
            i = 0;
            while(i < numTilesY)
            {
               for(j = 0; j < numTilesX; )
               {
                  bgObj = this.mBGTilesCatalog[k];
                  k++;
                  if(bgObj == null)
                  {
                     bgObj = this.addBackgroundTile();
                  }
                  bg = bgObj.bg as Sprite;
                  stars = bgObj.stars as Sprite;
                  bgWidth = bg.width;
                  bgHeight = bg.height;
                  bg.x = -divX * bgWidth - offsetX;
                  bg.y = -(divY * bgHeight) - offsetY;
                  bg.x += (j - 1) * bgWidth;
                  bg.y += (i - 1) * bgHeight;
                  stars.x = -divX * bgWidth - offsetStarsX;
                  stars.y = -(divY * bgHeight) - offsetStarsY;
                  stars.x += (j - 1) * bgWidth;
                  stars.y += (i - 1) * bgHeight;
                  nebula1 = bgObj.nebula1 as Sprite;
                  nebula2 = bgObj.nebula2 as Sprite;
                  if(userHighQuality && nebula1 != null && nebula2 != null && false)
                  {
                     nebula1.alpha = nebula1Alpha;
                     nebula2.alpha = nebula2Alpha;
                     nebula1.x = -divX * bgWidth - offsetNebulaX1;
                     nebula1.y = -(divY * bgHeight) - offsetNebulaY1;
                     nebula1.x += (j - 1) * bgWidth;
                     nebula1.y += (i - 1) * bgHeight;
                     nebula2.x = -divX * bgWidth - offsetNebulaX2;
                     nebula2.y = -(divY * bgHeight) - offsetNebulaY2;
                     nebula2.x += (j - 1) * bgWidth;
                     nebula2.y += (i - 1) * bgHeight;
                  }
                  j++;
               }
               i++;
            }
         }
      }
      
      public function centerCameraByStarCoords(coords:DCCoordinate, lockUI:Boolean = false) : void
      {
         var coord:DCCoordinate = this.getCoordToDrawByPosition(coords);
         var stageWidth:int = InstanceMng.getApplication().stageGetWidth();
         var stageHeight:int = InstanceMng.getApplication().stageGetHeight();
         var posX:int = coord != null ? int(coord.x - stageWidth / 2) : int(stageWidth / 2);
         var posY:int = coord != null ? int(coord.y - stageHeight / 2) : int(stageHeight / 2);
         InstanceMng.getMapViewGalaxy().setBGForceRefresh(true);
         this.moveCameraToScreenCoords(-posX,-posY,lockUI);
      }
      
      public function centerCameraInCapital() : void
      {
         var uInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         var coords:DCCoordinate = uInfo.getCapital().getParentStarCoords();
         this.centerCameraByStarCoords(coords);
      }
      
      private function checkIfStarsRequestIsNeeded(coordsRequested:DCCoordinate = null, lockUI:Boolean = false) : void
      {
         var oldMinCoord:DCCoordinate = null;
         var oldMaxCoord:DCCoordinate = null;
         var coord:DCCoordinate = null;
         var coordObj:Object = null;
         var minCoordLocal:DCCoordinate = null;
         var maxCoordLocal:DCCoordinate = null;
         var isMinCoordLocalInside:Boolean = false;
         var isMaxCoordLocalInside:Boolean = false;
         var dist:Number = NaN;
         var distMinCoord:Number = NaN;
         var distMaxCoord:Number = NaN;
         var forceRequestToServer:Boolean = false;
         if(this.mWaitingGalaxyWindowResponseFromServer == false)
         {
            coord = coordsRequested == null ? this.getStarCoordsByScenePosition() : coordsRequested;
            coordObj = InstanceMng.getApplication().calculateGalaxyWindowByCoord(coord);
            minCoordLocal = coordObj.coordMin;
            maxCoordLocal = coordObj.coordMax;
            if(this.mMinCoordWindow == null)
            {
               this.mMinCoordWindow = FlowStateLoadingBarGalaxyView.getCoordinates(1);
            }
            oldMinCoord = this.mMinCoordWindow;
            if(this.mMaxCoordWindow == null)
            {
               this.mMaxCoordWindow = FlowStateLoadingBarGalaxyView.getCoordinates(2);
            }
            oldMaxCoord = this.mMaxCoordWindow;
            isMinCoordLocalInside = minCoordLocal.isContainedInCoords(oldMinCoord,oldMaxCoord);
            isMaxCoordLocalInside = maxCoordLocal.isContainedInCoords(oldMinCoord,oldMaxCoord);
            dist = 0;
            distMinCoord = 0;
            distMaxCoord = 0;
            forceRequestToServer = false;
            if(isMinCoordLocalInside == false || isMaxCoordLocalInside == false)
            {
               if(isMinCoordLocalInside == false)
               {
                  distMinCoord = DCUtils.getDistanceBetweenCoords(minCoordLocal,oldMinCoord);
               }
               if(isMaxCoordLocalInside == false)
               {
                  distMaxCoord = DCUtils.getDistanceBetweenCoords(maxCoordLocal,oldMaxCoord);
               }
               dist = Math.max(distMinCoord,distMaxCoord);
               forceRequestToServer = (forceRequestToServer = minCoordLocal.x <= 20 || minCoordLocal.y <= 20) && isMinCoordLocalInside == false;
               if(dist > 20 / 2 || forceRequestToServer)
               {
                  this.mWaitingGalaxyWindowResponseFromServer = true;
                  InstanceMng.getApplication().galaxyInfoWait(minCoordLocal,maxCoordLocal,lockUI);
                  this.mMinCoordWindow = minCoordLocal;
                  this.mMaxCoordWindow = maxCoordLocal;
               }
            }
         }
      }
      
      private function removeSolarSystemsOutOfWindow(coordsRequested:DCCoordinate) : void
      {
         var coord:DCCoordinate = null;
         var coordObj:Object = null;
         var minCoordLocal:DCCoordinate = null;
         var maxCoordLocal:DCCoordinate = null;
         var solarSystem:SolarSystem = null;
         var doc:DisplayObjectContainer = null;
         var solarSystemCoords:DCCoordinate = null;
         if(this.mClippingEngineEnabled == true)
         {
            coord = coordsRequested == null ? this.getStarCoordsByScenePosition() : coordsRequested;
            coordObj = InstanceMng.getApplication().calculateGalaxyWindowByCoord(coord);
            minCoordLocal = coordObj.coordMin;
            maxCoordLocal = coordObj.coordMax;
            minCoordLocal = this.addOffsetToCoordinate(minCoordLocal,-10);
            maxCoordLocal = this.addOffsetToCoordinate(maxCoordLocal,10);
            for each(solarSystem in this.mSolarSystems)
            {
               if(!(solarSystemCoords = solarSystem.getCoords()).isContainedInCoords(minCoordLocal,maxCoordLocal))
               {
                  if((doc = this.getGraphicBySolarSystem(solarSystem)) != null)
                  {
                     if(this.mStarsLayer.contains(doc))
                     {
                        this.mTotalSolarSystemCount--;
                        this.mStarsLayer.removeChild(doc);
                        ETooltipMng.getInstance().destroyTooltipFromContainer(solarSystem.getCoordsForIndexing());
                        this.mStarViewCatalog[solarSystem.getCoordsForIndexing()] = null;
                        delete this.mStarViewCatalog[solarSystem.getCoordsForIndexing()];
                        this.mStarGraphicsCatalog[doc] = null;
                        delete this.mStarGraphicsCatalog[doc];
                        this.mSolarSystems[solarSystemCoords.x + "," + solarSystemCoords.y] = null;
                        delete this.mSolarSystems[solarSystem.getCoordsForIndexing()];
                     }
                  }
               }
            }
         }
      }
      
      private function addOffsetToCoordinate(coord:DCCoordinate, offset:int) : DCCoordinate
      {
         var returnValue:* = coord;
         returnValue.x = coord.x + offset;
         returnValue.y = coord.y + offset;
         return returnValue;
      }
      
      public function removeSolarSystemFromStage(obj:SolarSystem) : void
      {
         var doc:DisplayObjectContainer = null;
         var solarSystem:* = obj;
         if(this.mStarViewCatalog != null && solarSystem != null)
         {
            doc = this.getGraphicBySolarSystem(solarSystem);
            if(doc != null)
            {
               if(this.mSolarSystems[solarSystem.getCoordsForIndexing()] != null)
               {
                  this.mSolarSystems[solarSystem.getCoordsForIndexing()] = null;
                  delete this.mSolarSystems[solarSystem.getCoordsForIndexing()];
               }
               if(this.mStarViewCatalog[solarSystem.getCoordsForIndexing()] != null)
               {
                  ETooltipMng.getInstance().destroyTooltipFromContainer(solarSystem.getCoordsForIndexing());
                  this.mStarViewCatalog[solarSystem.getCoordsForIndexing()] = null;
                  delete this.mStarViewCatalog[solarSystem.getCoordsForIndexing()];
               }
               if(this.mStarGraphicsCatalog[doc] != null)
               {
                  this.mStarGraphicsCatalog[doc] = null;
                  delete this.mStarGraphicsCatalog[doc];
               }
               if(doc != null && this.mStarsLayer.contains(doc))
               {
                  this.mStarsLayer.removeChild(doc);
               }
               this.mTotalSolarSystemCount--;
            }
         }
      }
      
      public function getDistanceBetweenPlanets(planetSku1:String, planetSku2:String) : Number
      {
         var coordsArr:Array = null;
         var returnValue:Number = NaN;
         if(planetSku1 == "" || planetSku1 == null)
         {
            planetSku1 = "0:0:0";
         }
         if(planetSku2 == "" || planetSku2 == null)
         {
            planetSku2 = "0:0:0";
         }
         var coordsPlanet1:DCCoordinate = new DCCoordinate();
         var coordsPlanet2:DCCoordinate = new DCCoordinate();
         coordsArr = planetSku1.split(":");
         coordsPlanet1.x = coordsArr[0];
         coordsPlanet1.y = coordsArr[1];
         coordsArr = planetSku2.split(":");
         coordsPlanet2.x = coordsArr[0];
         coordsPlanet2.y = coordsArr[1];
         return DCUtils.getEuclideanDistanceBetweenCoords(coordsPlanet1,coordsPlanet2);
      }
      
      private function getStarCoordsByScenePosition() : DCCoordinate
      {
         var returnValue:DCCoordinate = new DCCoordinate();
         var stageWidth:int = this.mStage.getStageWidth();
         var stageHeight:int = this.mStage.getStageHeight();
         var centerWindowX:int = -this.mCameraCoords.x + stageWidth / 2;
         var centerWindowY:int = -this.mCameraCoords.y + stageHeight / 2;
         var coordX:int = centerWindowX / 200;
         var coordY:int = centerWindowY / 200;
         returnValue.x = coordX;
         returnValue.y = coordY;
         return returnValue;
      }
      
      public function getSceneCoords() : DCCoordinate
      {
         var coords:DCCoordinate = new DCCoordinate();
         coords.x = this.mScene.x;
         coords.y = this.mScene.y;
         return coords;
      }
      
      public function getScene() : DisplayObjectContainer
      {
         return this.mScene;
      }
      
      public function getBackground() : DisplayObjectContainer
      {
         return this.mBackgroundDO;
      }
      
      public function getStarsLayer() : DisplayObjectContainer
      {
         return this.mStarsLayer;
      }
      
      public function getGraphicBySolarSystem(solarSystem:SolarSystem) : DisplayObjectContainer
      {
         return this.mStarViewCatalog[solarSystem.getCoordsForIndexing()];
      }
      
      public function getSolarSystemByGraphic(doc:DisplayObjectContainer) : SolarSystem
      {
         var returnValue:SolarSystem = null;
         if(this.mStarGraphicsCatalog != null)
         {
            returnValue = this.mStarGraphicsCatalog[doc];
         }
         return returnValue;
      }
      
      private function onUpdateLastStarIdMouseOvered(e:MouseEvent) : void
      {
         var solarSystem:SolarSystem = null;
         var docSolarSystem:DisplayObjectContainer = e.currentTarget as DisplayObjectContainer;
         if(docSolarSystem != null && this.mStarGraphicsCatalog != null)
         {
            solarSystem = this.mStarGraphicsCatalog[docSolarSystem];
            if(solarSystem != null)
            {
               this.mLastMouseoveredStarId = solarSystem.getId();
            }
         }
      }
      
      public function setForceToReloadPlanets(value:Boolean) : void
      {
         this.mForceToReloadPlanets = value;
      }
      
      public function openPopupActionsOnPlanet(planet:Planet, star:SolarSystem, isOccupied:Boolean, doc:DisplayObjectContainer) : void
      {
         var popup:DCIPopup = null;
         (popup = InstanceMng.getUIFacade().getPopupFactory().getActionsOnPlanetPopup(planet,star,isOccupied)).setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function onAttackRequest(accId:String, planet:Planet) : void
      {
         var starId:Number = planet != null ? planet.getParentStarId() : -1;
         var starName:String = String(planet != null ? planet.getParentStarName() : null);
         var starCoords:DCCoordinate = planet != null ? planet.getParentStarCoords() : null;
         DCDebug.traceCh("AttackLogic","[MapVG] onAttackRequest accId = " + accId + " | planetId = " + planet.getPlanetId());
         InstanceMng.getApplication().attackRequest(accId,planet.getPlanetId(),0,false,true,planet.getSku(),starId,starName,starCoords,planet);
      }
      
      private function guiUnload() : void
      {
         this.mGuiAttackEvent = null;
      }
      
      public function guiOpenBlackHoleIntroPopup(o:Object) : void
      {
         this.mGuiAttackEvent = o;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getBlackHoleIntroPopup(this.guiBlackHoleIntroOnClose);
         popup.setIsStackable(true);
         uiFacade.enqueuePopup(popup);
      }
      
      private function guiBlackHoleIntroOnClose(e:EEvent = null) : void
      {
         InstanceMng.getUIFacade().closePopupById("PopupBlackHoleIntro");
         if(this.mGuiAttackEvent != null)
         {
            InstanceMng.getApplication().requestPlanet(this.mGuiAttackEvent.accId,this.mGuiAttackEvent.planetId,this.mGuiAttackEvent.role,this.mGuiAttackEvent.planetSku,true,true,true,this.mGuiAttackEvent.planetSku,this.mGuiAttackEvent.starName,this.mGuiAttackEvent.starCoords);
            this.mGuiAttackEvent = null;
         }
      }
   }
}
