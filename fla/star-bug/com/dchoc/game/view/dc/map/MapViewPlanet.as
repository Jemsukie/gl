package com.dchoc.game.view.dc.map
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.map.MapController;
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.happening.HappeningMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.rule.BackgroundDef;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.unit.FireWorksMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.map.intro.IntroFsm;
   import com.dchoc.game.view.dc.map.intro.IntroFsmBirthday;
   import com.dchoc.game.view.dc.map.intro.IntroFsmDoomsDay;
   import com.dchoc.game.view.dc.map.intro.IntroFsmHalloween;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.game.view.facade.CursorFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.core.view.display.DCStage;
   import com.dchoc.toolkit.core.view.display.DCTileSet;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.astar.DCPath;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.map.DCMapViewDef;
   import com.dchoc.toolkit.view.map.perspective.DCMapPerspective;
   import com.gskinner.geom.ColorMatrix;
   import com.gskinner.motion.GTween;
   import esparragon.display.EImage;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class MapViewPlanet extends MapView
   {
      
      private static const WAR_CIRCLE_FRAME_OK:int = 1;
      
      private static const WAR_CIRCLE_FRAME_KO:int = 2;
      
      private static const SPY_AREA_DEBUG_ENABLED:Boolean = false;
      
      private static const INVESTS_BUILDING_SETUP_NONE:int = 0;
      
      private static const INVESTS_BUILDING_SETUP_STILL:int = 1;
      
      private static const INVESTS_BUILDING_SETUP_ANIM:int = 2;
      
      private static const INVESTS_BUILDING_SETUP_STATE_NONE:int = 0;
      
      private static const INVESTS_BUILDING_SETUP_STATE_INIT:int = 1;
      
      private static const INVESTS_BUILDING_SETUP_STATE_WAITING_FOR_ASSET:int = 2;
      
      private static const INVESTS_BUILDING_SETUP_STATE_READY:int = 3;
      
      private static const INVESTS_BUILDING_SETUP_STATE_ERROR:int = 4;
      
      private static const MOUSE_EVENTS_COUNCIL:int = 0;
      
      private static const MOUSE_EVENTS_INVESTS:int = 1;
      
      private static const MOUSE_EVENTS_COUNT:int = 2;
      
      public static const GRID_WHITE_ID:int = 0;
      
      public static const GRID_COUNT:int = 1;
      
      public static const GRID_GREEN_ID:int = 0;
      
      public static const GRID_RED_ID:int = 0;
      
      public static const INTRO_TYPE_HAPPENING:int = 0;
      
      private static const BORDER_RESOLUTION_SETTINGS:Vector.<int> = new <int>[0,1,11,19,25,37];
       
      
      protected var mMapControllerPlanet:MapControllerPlanet;
      
      public var mViewMngPlanet:ViewMngPlanet;
      
      protected var mStage:DCStage;
      
      public var mDOCross:Sprite;
      
      protected var mDOBox:Shape;
      
      protected var mCoor:DCCoordinate;
      
      protected var mDOCircle:DisplayObjectContainer;
      
      private var mTileViewWidth:int;
      
      private var mTileViewHeight:int;
      
      protected var mBackgroundSku:String;
      
      private var mBGAllianceAnimName:String;
      
      private var mOldMouseX:int;
      
      private var mOldMouseY:int;
      
      private var mLastClickLabel:String = "clickOnMap";
      
      private var mSpyAreaDO:DisplayObjectContainer;
      
      private var mSpyAreaDebugDO:Sprite;
      
      private var mSpyAreaIsVisible:Boolean = false;
      
      private var mMapCursorDO:DCTileSet;
      
      private var mMapCursorIsEnabled:Boolean;
      
      private const BACKGROUND_USE_ASSET:Boolean = true;
      
      private const DEFAULT_BG_WIDTH:int = 2743;
      
      private const DEFAULT_BG_HEIGHT:int = 2122;
      
      protected var mBackgroundDO:Sprite;
      
      protected var mBGAllianceFlagsDOC:Sprite;
      
      protected var mBGInvestsFlagsDOC:Sprite;
      
      private var mBackgroundAnimsEnabled:Boolean = false;
      
      private var mBackgroundBitmap:DCBitmapMovieClip;
      
      private var mBackgroundWidth:int;
      
      private var mBackgroundHeight:int;
      
      private var mBackgroundDeployAreas:Sprite;
      
      private var mBackgroundAnimsChild:Vector.<DisplayObject>;
      
      private var mBGAllianceAnim:DisplayObjectContainer;
      
      private var mBGInvestsAnim:Sprite;
      
      private var mBGInvestEImage:EImage;
      
      private var mBGInvestsBubbleSpeech:Sprite;
      
      private var mBGAnimsTimers:Dictionary;
      
      private var mInvestsSetupState:int;
      
      private var mInvestsBuildingSetupRequiredId:int;
      
      private var mBGInvestsAnimName:String;
      
      private var mShowInvestBubbleSpeech:Boolean = true;
      
      private var mDefaultBubbleSpeechPos:DCCoordinate;
      
      private var mInvestsBuildingPosition:DCCoordinate;
      
      private var mIsInvestAnimRunning:Boolean = false;
      
      private const INVESTS_TOOLTIP_TIME:int = 150;
      
      private var mInvestsTooltipTimer:Number = 150;
      
      private var mShowInvestsTooltip:Boolean = false;
      
      private var mInvestsTooltipShown:Boolean = false;
      
      private const ALLIANCES_COUNCIL_TIME:int = 150;
      
      private var mShowAllianceCouncilFX:Boolean = true;
      
      private var mCursorId:int;
      
      private var mAlliancesCouncilTooltipTimer:Number = 150;
      
      private var mShowAllianceCouncilTooltip:Boolean = false;
      
      private var mAllianceCouncilTooltipShown:Boolean = false;
      
      private var mMouseDownAndScroll:Boolean = false;
      
      private var mMouseEventsEnabled:Vector.<Boolean>;
      
      private var mMouseEventsAdded:Vector.<Boolean>;
      
      private var mClickOnAnimsIsEnabled:Boolean;
      
      private var mTilesetDO:DCTileSet;
      
      private var mTilesetIsInStage:Boolean;
      
      private var mTilesetIsVisible:Boolean;
      
      private var mTilesetOffX:int;
      
      private var mTilesetOffY:int;
      
      private var mGridDOs:Vector.<DCDisplayObject>;
      
      private var mGridCurrentId:int = -1;
      
      private var mCorners:Vector.<Number>;
      
      private var mBorderShape:Shape;
      
      private var mBorderShapes:Vector.<DCDisplayObjectSWF>;
      
      private var mItemBorder:Shape;
      
      private var mDCItemBorder:DCDisplayObject;
      
      private var mItemsDrawn:Vector.<WorldItemObject>;
      
      private const TILES_OFFSET:int = 10;
      
      private var mDebugPaths:Dictionary;
      
      private var mDebugShape:Shape;
      
      private var mScrollIsBegun:Boolean;
      
      private var mHappeningsMapViews:Dictionary;
      
      private var mIntroFsm:IntroFsm;
      
      private var mIntroEvent:Object;
      
      private var mIntroListener:DCComponent;
      
      private var mBorderResolutionIndex:int = 0;
      
      public function MapViewPlanet()
      {
         this.mCorners = new Vector.<Number>(8,true);
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 7;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mouseEventsLoad();
            this.mCoor = new DCCoordinate();
            if(Config.DEBUG_MODE)
            {
               this.mDOCross = new Sprite();
               this.mDOBox = new Shape();
               this.debugLoad();
            }
            this.mStage = InstanceMng.getApplication().stageGetStage();
            this.mOldMouseX = this.mStage.getMouseX();
            this.mOldMouseY = this.mStage.getMouseY();
         }
      }
      
      private function createCross(g:Graphics, color:uint = 0, x:int = 0, y:int = 0) : void
      {
         g.beginFill(color);
         g.drawRect(x - 3,y,6,1);
         g.drawRect(x,y - 3,1,6);
         g.endFill();
      }
      
      override protected function unloadDo() : void
      {
         this.mouseEventsUnload();
         if(Config.DEBUG_MODE)
         {
            this.mDOCross = null;
            this.mDOBox = null;
            this.debugUnload();
         }
         this.mDOCircle = null;
         this.gridUnload();
         this.mCoor = null;
         this.mViewMngPlanet = null;
         this.mStage = null;
         this.backgroundUnload();
         this.spyAreaUnload();
         this.happeningsUnload();
      }
      
      private function backgroundUnload() : void
      {
         if(this.mBackgroundSku != null)
         {
            InstanceMng.getResourceMng().unloadResource(this.mBackgroundSku);
            this.mBackgroundSku = null;
         }
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var profileLoaded:Profile = null;
         var profileLogin:Profile = null;
         var previousBackgroundSku:String = null;
         var thisMsg:* = null;
         var e:Object = null;
         var mapViewDef:DCMapViewDef = null;
         var perspective:DCMapPerspective = null;
         var mapViewWidth:int = 0;
         var mapViewHeight:int = 0;
         var mapX:int = 0;
         var mapY:int = 0;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         switch(step)
         {
            case 0:
               if(false)
               {
                  buildAdvanceSyncStep();
               }
               else if((profileLoaded = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()).isBuilt())
               {
                  previousBackgroundSku = this.mBackgroundSku;
                  this.mBackgroundSku = InstanceMng.getBackgroundController().getBackgroundAssetForCurrentSituation();
                  if(this.mBackgroundSku != null)
                  {
                     if(previousBackgroundSku != null && previousBackgroundSku != this.mBackgroundSku)
                     {
                        resourceMng.unloadResource(previousBackgroundSku);
                     }
                     if(!resourceMng.isResourceLoaded(this.mBackgroundSku))
                     {
                        resourceMng.requestBackground(this.mBackgroundSku);
                     }
                     buildAdvanceSyncStep();
                  }
               }
               break;
            case 1:
               if(resourceMng.isResourceLoaded(this.mBackgroundSku))
               {
                  this.backgroundBuild();
                  buildAdvanceSyncStep();
               }
               break;
            case 2:
               if(resourceMng.isResourceLoaded("assets/flash/world_items/common.swf"))
               {
                  this.mDOCircle = new (resourceMng.getSWFClass("assets/flash/world_items/common.swf","drop_point"))();
                  this.mDOCircle.scaleX = 1.5;
                  this.mDOCircle.scaleY = 1.5;
                  MovieClip(this.mDOCircle).gotoAndStop(1);
                  buildAdvanceSyncStep();
               }
               break;
            case 3:
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
            case 4:
               if(this.mMapControllerPlanet != null && this.mMapControllerPlanet.isBuilt())
               {
                  mapViewDef = this.mMapControllerPlanet.mMapViewDef;
                  this.mTileViewWidth = mapViewDef.mTileViewWidth;
                  this.mTileViewHeight = mapViewDef.mTileViewHeight;
                  perspective = mapViewDef.mPerspective;
                  mapViewWidth = this.mMapControllerPlanet.mTilesCols * this.mTileViewWidth;
                  mapViewHeight = this.mMapControllerPlanet.mTilesRows * this.mTileViewHeight;
                  this.mViewMngPlanet.worldSetMapSize(mapViewWidth,mapViewHeight);
                  this.mViewMngPlanet.worldSetSize(this.mBackgroundWidth,this.mBackgroundHeight);
                  this.mTilesetOffX = 0;
                  this.mTilesetOffY = 0;
                  mapX = (this.mBackgroundWidth >> 1) + this.mMapControllerPlanet.getMapOffX();
                  mapY = (this.mBackgroundHeight - mapViewHeight >> 1) + this.mMapControllerPlanet.getMapOffY();
                  this.mViewMngPlanet.worldSetMapXY(mapX,mapY);
                  buildAdvanceSyncStep();
               }
               break;
            case 5:
               if(this.mMapControllerPlanet.mMapViewDef.needsToWaitForResource())
               {
                  this.mTilesetDO = this.mViewMngPlanet.mapCreate(this.mMapControllerPlanet.mMapViewDef,this.mMapControllerPlanet.mTilesCols,this.mMapControllerPlanet.mTilesRows);
                  if(this.mTilesetDO != null)
                  {
                     this.mMapCursorDO = this.mViewMngPlanet.mapCursorCreate(this.mMapControllerPlanet.mMapViewDef);
                     buildAdvanceSyncStep();
                  }
               }
               else
               {
                  buildAdvanceSyncStep();
               }
               break;
            case 6:
               profileLoaded = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
               profileLogin = InstanceMng.getUserInfoMng().getProfileLogin();
               if(profileLoaded.isBuilt() && profileLogin.isBuilt() && InstanceMng.getUIFacade().getNavigationBarFacadeIsBuilt())
               {
                  this.updateFriendsBarPathInfo();
                  this.backgroundAnimsSetEnabled(profileLogin.getAnimatedBackground());
                  buildAdvanceSyncStep();
                  break;
               }
         }
      }
      
      override protected function unbuildDo() : void
      {
         if(this.mTilesetDO != null)
         {
            this.mTilesetDO = null;
         }
         if(this.mMapCursorDO != null)
         {
            this.mMapCursorDO = null;
         }
         this.backgroundUnbuild();
         this.undrawWarCircle();
      }
      
      override protected function beginDo() : void
      {
         this.mouseEventsSetEnabledAnimsOnMap(true,true);
         if(Config.DEBUG_MODE)
         {
            mViewMng.addDebug(this.mDOCross);
            mViewMng.addDebug(this.mDOBox);
         }
         this.mViewMngPlanet.mapBackgroundAddToStage(this.mBackgroundDO);
         this.tilesetBegin();
         this.addMouseEvents();
         this.happeningsBegin();
         if(Config.useInvests())
         {
            this.investsBuildingSetupId(1);
         }
      }
      
      override protected function endDo() : void
      {
         this.mouseEventsSetEnabledAnimsOnMap(false,true);
         this.gridEnd();
         this.mViewMngPlanet.mapBackgroundRemoveFromStage(this.mBackgroundDO);
         this.tilesetEnd();
         this.mapCursorDisable();
         this.spyAreaSetIsVisible(false);
         this.removeMouseEvents();
         if(Config.DEBUG_MODE)
         {
            mViewMng.removeDebug(this.mDOCross);
            mViewMng.removeDebug(this.mDOBox);
         }
         InstanceMng.getMapControllerPlanet().autoScrollReset();
         this.happeningsEnd();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(mUiEnabled && (this.mOldMouseX != this.mStage.getMouseX() || this.mOldMouseY != this.mStage.getMouseY()))
         {
            this.onMouseMoveCoors(this.mStage.getMouseX(),this.mStage.getMouseY());
         }
         if(this.mBackgroundAnimsEnabled)
         {
            this.backgroundAnimsUpdate(dt);
         }
         this.alliancesCouncilLogicUpdate(dt);
         if(Config.useInvests())
         {
            this.investsLogicUpdate(dt);
         }
         if(this.mSpyAreaIsVisible && this.mSpyAreaDO == null)
         {
            if(InstanceMng.getResourceMng().isResourceLoaded("assets/flash/gui/spy_capsule.swf"))
            {
               this.spyAreaAddToView();
            }
         }
         this.introLogicUpdate(dt);
         if(Config.useHappenings())
         {
            this.happeningsLogicUpdate(dt);
         }
      }
      
      override public function unlock(exception:Object = null) : void
      {
         super.unlock(exception);
         if(exception == this)
         {
            exception = null;
         }
         this.mMapControllerPlanet.toolExceptionSet(exception);
      }
      
      override public function setViewMng(value:ViewMngrGame) : void
      {
         super.setViewMng(value);
         this.mViewMngPlanet = ViewMngPlanet(value);
      }
      
      public function getTileViewWidth() : int
      {
         return this.mTileViewWidth;
      }
      
      public function getTileViewHeight() : int
      {
         return this.mTileViewHeight;
      }
      
      override public function addMouseEvents() : void
      {
         if(this.mBackgroundDO != null)
         {
            this.mBackgroundDO.addEventListener("mouseOver",this.onMouseOver,false,0,true);
         }
      }
      
      override public function removeMouseEvents() : void
      {
         if(this.mBackgroundDO != null)
         {
            this.mBackgroundDO.removeEventListener("mouseOver",this.onMouseOver,false);
         }
      }
      
      override protected function uiEnableDo(forceAddListeners:Boolean = false) : void
      {
         var o:Object = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_CHANGEFOCUS");
         o.parentIdx = mParentRef;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
         this.mMapControllerPlanet.uiEnable(forceAddListeners);
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         this.mMapControllerPlanet.uiDisable(true,forceRemoveListeners);
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
         this.mCoor.x = x;
         this.mCoor.y = y;
         this.mViewMngPlanet.screenToTileXY(this.mCoor);
         this.mMapControllerPlanet.uiMouseMoveCoors(x,y,this.mCoor.x,this.mCoor.y);
      }
      
      override public function onMouseDown(e:MouseEvent) : void
      {
         if(!mUiEnabled)
         {
            return;
         }
         var x:int = this.mStage.getMouseX();
         var y:int = this.mStage.getMouseY();
         this.mCoor.x = x;
         this.mCoor.y = y;
         this.mViewMngPlanet.screenToTileXY(this.mCoor);
         this.mMapControllerPlanet.uiMouseDownCoors(x,y,this.mCoor.x,this.mCoor.y);
         this.removeFunctionalityToAlliancesCouncil();
         this.removeInvestsFunctionality();
      }
      
      override public function onMouseUp(e:MouseEvent) : void
      {
         if(!mUiEnabled)
         {
            return;
         }
         var x:int = this.mStage.getMouseX();
         var y:int = this.mStage.getMouseY();
         this.mCoor.x = x;
         this.mCoor.y = y;
         this.mViewMngPlanet.screenToTileXY(this.mCoor);
         this.mMapControllerPlanet.uiMouseUpCoors(x,y,this.mCoor.x,this.mCoor.y);
         this.addFunctionalityToAlliancesCouncil();
         this.addInvestsFunctionality();
         InstanceMng.getApplication().lastClickSetLabel(this.mLastClickLabel);
         this.mLastClickLabel = "clickOnMap";
      }
      
      override public function onZoomSet(value:Number) : void
      {
         this.mViewMngPlanet.worldOnZoomSet(value);
      }
      
      override public function onZoomMove(off:Number) : void
      {
         this.mViewMngPlanet.worldOnZoomMove(off);
      }
      
      override public function onAnimatedBackgroundToggled(value:Boolean) : void
      {
         this.backgroundAnimsSetEnabled(value);
      }
      
      override public function setMapController(value:MapController) : void
      {
         super.setMapController(value);
         this.mMapControllerPlanet = MapControllerPlanet(value);
      }
      
      public function flush(map:Vector.<int> = null, indices:Vector.<int> = null) : void
      {
         if(this.mTilesetDO != null)
         {
            this.mTilesetDO.flush(map,indices);
         }
      }
      
      public function lastClickSetLabel(value:String) : void
      {
         this.mLastClickLabel = value;
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         var coor:DCCoordinate = null;
         var viewMng:ViewMngPlanet = null;
         this.mViewMngPlanet.worldCameraSetSize(stageWidth,stageHeight,true);
         redrawSpotlight();
      }
      
      public function drawPoint(x:int, y:int, off:int = 5, color:uint = 10027008, logicCoors:Boolean = false, doClear:Boolean = false) : void
      {
         if(logicCoors)
         {
            this.mCoor.x = x;
            this.mCoor.y = y;
            this.mCoor.z = 0;
            this.mViewMngPlanet.logicPosToViewPos(this.mCoor);
            x = this.mCoor.x;
            y = this.mCoor.y;
         }
         DCUtils.drawPoint(this.mDOBox.graphics,color,x,y,off,doClear);
      }
      
      public function drawLine(xSrc:int, ySrc:int, xDest:int, yDest:int, color:uint, logicCoors:Boolean = false, doClear:Boolean = false) : void
      {
         if(logicCoors)
         {
            this.mCoor.x = xSrc;
            this.mCoor.y = ySrc;
            this.mCoor.z = 0;
            this.mViewMngPlanet.logicPosToViewPos(this.mCoor);
            xSrc = this.mCoor.x;
            ySrc = this.mCoor.y;
            this.mCoor.x = xDest;
            this.mCoor.y = yDest;
            this.mCoor.z = 0;
            this.mViewMngPlanet.logicPosToViewPos(this.mCoor);
            xDest = this.mCoor.x;
            yDest = this.mCoor.y;
         }
         var g:Graphics = this.mDOBox.graphics;
         if(doClear)
         {
            g.clear();
         }
         g.lineStyle(2,10027008,0.75);
         g.beginFill(color);
         g.moveTo(xSrc,ySrc);
         g.lineTo(xDest,yDest);
         g.endFill();
      }
      
      public function drawCross(x:int, y:int) : void
      {
         if(Config.DEBUG_MODE)
         {
            this.mDOCross.x = x;
            this.mDOCross.y = y;
         }
      }
      
      public function drawBox(x:int, y:int, width:int, height:int) : void
      {
         if(Config.DEBUG_MODE)
         {
            DCUtils.fillRect(this.mDOBox.graphics,x,y,width,height,16711935);
         }
      }
      
      public function isWarCircleOk() : Boolean
      {
         return MovieClip(this.mDOCircle).currentFrame == 1;
      }
      
      public function setDrawWarCircle(isOk:Boolean) : void
      {
         var frame:int = isOk ? 1 : 2;
         MovieClip(this.mDOCircle).gotoAndStop(frame);
      }
      
      public function updateWarCircle(x:int, y:int) : void
      {
         this.mDOCircle.x = x;
         this.mDOCircle.y = y;
      }
      
      public function drawWarCircle() : void
      {
         if(!this.mViewMngPlanet.contains(this.mDOCircle))
         {
            this.mViewMngPlanet.cursorToolDropAddToStage(this.mDOCircle);
         }
      }
      
      public function undrawWarCircle() : void
      {
         if(this.mViewMngPlanet.contains(this.mDOCircle))
         {
            this.mViewMngPlanet.cursorToolDropRemoveFromStage(this.mDOCircle);
         }
      }
      
      private function spyAreaUnload() : void
      {
         this.spyAreaSetIsVisible(false);
         this.mSpyAreaDO = null;
         if(Config.DEBUG_MODE)
         {
            this.mSpyAreaDebugDO = null;
         }
      }
      
      private function spyAreaDraw() : void
      {
         var groundSelector:* = undefined;
         var spyType:int = 0;
         var thisClass:Class = InstanceMng.getResourceMng().getSWFClass("assets/flash/gui/spy_capsule.swf","ground_selector_ingame");
         if(thisClass != null)
         {
            this.mSpyAreaDO = new MovieClip();
            groundSelector = new thisClass();
            this.mSpyAreaDO.addChildAt(groundSelector,0);
            spyType = InstanceMng.getToolsMng().getCurrentSpyType();
            SpyCapsule.addCapsuleToAnim(this.mSpyAreaDO,spyType,[spyType == 1 ? GameConstants.FILTER_SPY_CAPSULE_ADVANCED_NOT_SELECTED : GameConstants.FILTER_SPY_CAPSULE_NOT_SELECTED]);
            this.spyCursorCheckFilters();
         }
         if(false)
         {
            this.mSpyAreaDebugDO = new Sprite();
            DCUtils.drawEllipse(this.mSpyAreaDebugDO.graphics,286,16776960,0,0);
         }
      }
      
      public function spyCursorCheckFilters() : void
      {
         var filter:ColorMatrix = null;
         if(this.mSpyAreaDO == null)
         {
            return;
         }
         var groundSelector:MovieClip = this.mSpyAreaDO.getChildAt(0) as MovieClip;
         if(groundSelector == null)
         {
            return;
         }
         if(InstanceMng.getToolsMng().getCurrentSpyType() == 1)
         {
            filter = new ColorMatrix();
            filter.adjustColor(0,0,0,-115);
            groundSelector.scaleX = 2;
            groundSelector.scaleY = 2;
            groundSelector.filters = [new ColorMatrixFilter(filter.toArray())];
         }
         else
         {
            groundSelector.scaleX = 1;
            groundSelector.scaleY = 1;
            groundSelector.filters = [];
         }
      }
      
      public function spyAreaGetIsVisible() : Boolean
      {
         return this.mSpyAreaIsVisible;
      }
      
      private function spyAreaAddToView() : void
      {
         if(this.mSpyAreaDO == null)
         {
            this.spyAreaDraw();
         }
         if(this.mSpyAreaDO != null && !this.mViewMngPlanet.contains(this.mSpyAreaDO))
         {
            this.mViewMngPlanet.cursorToolDropAddToStage(this.mSpyAreaDO);
         }
         if(false && !this.mViewMngPlanet.contains(this.mSpyAreaDebugDO))
         {
            this.mViewMngPlanet.cursorToolDropAddToStage(this.mSpyAreaDebugDO);
         }
      }
      
      public function spyAreaSetIsVisible(value:Boolean) : void
      {
         this.mSpyAreaIsVisible = value;
         if(value)
         {
            this.spyAreaAddToView();
         }
         else if(this.mSpyAreaDO != null)
         {
            if(this.mViewMngPlanet.contains(this.mSpyAreaDO))
            {
               this.mViewMngPlanet.cursorToolDropRemoveFromStage(this.mSpyAreaDO);
            }
            if(false && this.mViewMngPlanet.contains(this.mSpyAreaDebugDO))
            {
               this.mViewMngPlanet.cursorToolDropRemoveFromStage(this.mSpyAreaDebugDO);
            }
            this.mSpyAreaDO = null;
         }
      }
      
      public function spyAreaMove(viewX:int, viewY:int) : void
      {
         if(!this.spyAreaGetIsVisible())
         {
            this.spyAreaSetIsVisible(true);
         }
         if(this.mSpyAreaDO != null)
         {
            this.mSpyAreaDO.x = viewX;
            this.mSpyAreaDO.y = viewY;
            if(false)
            {
               this.mSpyAreaDebugDO.x = viewX;
               this.mSpyAreaDebugDO.y = viewY;
               this.drawCross(viewX,viewY);
            }
         }
      }
      
      public function mapCursorEnable(tilesWidth:int, tilesHeight:int) : void
      {
         if(!this.mMapCursorIsEnabled && this.mMapCursorDO != null)
         {
            this.mMapCursorIsEnabled = true;
            this.mapCursorSetSize(tilesWidth,tilesHeight);
            this.mViewMngPlanet.mapCursorAddToStage(this.mMapCursorDO);
         }
      }
      
      public function mapCursorSetSize(tilesWidth:int, tilesHeight:int) : void
      {
         if(this.mMapCursorDO != null)
         {
            this.mMapCursorDO.setMapSize(tilesWidth,tilesHeight);
         }
      }
      
      public function mapCursorDisable() : void
      {
         if(this.mMapCursorIsEnabled && this.mMapCursorDO != null)
         {
            this.mMapCursorIsEnabled = false;
            this.mViewMngPlanet.mapCursorRemoveFromStage(this.mMapCursorDO);
         }
      }
      
      public function mapCursorSetTiles(map:Vector.<int>, tileX:int, tileY:int) : void
      {
         if(this.mMapCursorDO != null)
         {
            if(this.mMapCursorIsEnabled)
            {
               this.mMapCursorDO.flush(map);
            }
            this.mCoor.x = tileX;
            this.mCoor.y = tileY;
            this.mViewMngPlanet.tileXYToWorldViewPos(this.mCoor);
            this.mMapCursorDO.x = this.mCoor.x;
            this.mMapCursorDO.y = this.mCoor.y;
         }
      }
      
      private function backgroundBuild() : void
      {
         var highQualityOn:Boolean = false;
         var deployClass:Class = null;
         var g:Graphics = null;
         this.mBackgroundDO = new Sprite();
         if(true)
         {
            this.mBackgroundBitmap = InstanceMng.getResourceMng().getDCDisplayObject(this.mBackgroundSku,"background") as DCBitmapMovieClip;
            if(this.mBackgroundBitmap != null && Config.DEBUG_MODE)
            {
               deployClass = InstanceMng.getResourceMng().getSWFClass(this.mBackgroundSku,"deploy");
               if(deployClass != null)
               {
                  this.mBackgroundDeployAreas = new deployClass() as Sprite;
               }
               if(this.mBackgroundDeployAreas != null)
               {
                  this.mBackgroundDeployAreas.visible = false;
               }
            }
            this.mBackgroundDO.addChild(this.mBackgroundBitmap.getDisplayObject());
            this.mBackgroundDO.scrollRect = new Rectangle(0,0,this.mBackgroundDO.width,this.mBackgroundDO.height);
            this.mBackgroundWidth = this.mBackgroundDO.width;
            this.mBackgroundHeight = this.mBackgroundDO.height;
         }
         else
         {
            g = Sprite(this.mBackgroundDO).graphics;
            g.beginFill(16776960);
            this.mBackgroundWidth = 2743;
            this.mBackgroundHeight = 2122;
            g.drawRect(0,0,this.mBackgroundWidth,this.mBackgroundHeight);
            g.beginFill(4095);
            g.drawRect(20,20,this.mBackgroundWidth - 40,this.mBackgroundHeight - 40);
            g.beginFill(65535);
            g.drawRect((this.mBackgroundWidth >> 1) - 20,(this.mBackgroundHeight >> 1) - 20,40,40);
            this.createCross(g,16711680,this.mBackgroundWidth >> 1,this.mBackgroundHeight >> 1);
            g.endFill();
         }
         if(this.mBackgroundDO != null && this.mBackgroundDeployAreas != null)
         {
            this.mBackgroundDeployAreas.x += this.mBackgroundDO.width / 2;
            this.mBackgroundDeployAreas.y += this.mBackgroundDO.height / 2;
            this.mBackgroundDO.addChild(this.mBackgroundDeployAreas);
         }
      }
      
      public function toggleDeployAreasVisibility() : void
      {
         var visible:Boolean = false;
         if(this.mBackgroundDeployAreas != null)
         {
            visible = this.mBackgroundDeployAreas.visible;
            this.mBackgroundDeployAreas.visible = !visible;
         }
      }
      
      protected function backgroundUnbuild() : void
      {
         this.mBackgroundDO = null;
         this.mBackgroundBitmap = null;
         this.mBGAnimsTimers = null;
         this.mBackgroundAnimsChild = null;
         this.mBackgroundDeployAreas = null;
         this.mBGAllianceAnim = null;
         this.mBGAllianceFlagsDOC = null;
         this.investsUnbuild();
         if(this.mBGInvestEImage != null)
         {
            this.mBGInvestEImage.destroy();
            this.mBGInvestEImage = null;
         }
      }
      
      private function investsUnbuild() : void
      {
         this.mBGInvestsAnim = null;
         this.mBGInvestsBubbleSpeech = null;
         this.mBGInvestsFlagsDOC = null;
         this.mInvestsBuildingPosition = null;
         this.investsBuildingSetupSetState(0);
      }
      
      public function investsBuildingPlayConstructionAnim() : void
      {
         this.investsBuildingSetupId(2);
      }
      
      private function investsBuildingSetupId(buildingId:int) : void
      {
         this.mInvestsBuildingSetupRequiredId = buildingId;
         this.investsBuildingSetupSetState(1);
      }
      
      private function investsBuildingSetupSetState(state:int) : void
      {
         var nextState:int = 0;
         var currProfileLoaded:Profile = null;
         var uInfo:UserInfo = null;
         var currPlanetId:String = null;
         var planet:Planet = null;
         var isCapital:Boolean = false;
         var backgroundDefForCurrentSituation:BackgroundDef = null;
         var investsAnimLayerClass:Class = null;
         this.mInvestsSetupState = state;
         switch(this.mInvestsSetupState)
         {
            case 0:
               this.mInvestsBuildingSetupRequiredId = 0;
               break;
            case 1:
               nextState = 3;
               currProfileLoaded = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
               if(currProfileLoaded != null)
               {
                  uInfo = currProfileLoaded.getUserInfoObj();
                  if(uInfo != null && !uInfo.mIsNPC.value)
                  {
                     currPlanetId = InstanceMng.getApplication().goToGetCurrentPlanetId();
                     if((planet = currProfileLoaded.getUserInfoObj().getPlanetById(currPlanetId)) != null)
                     {
                        if(isCapital = planet.isCapital())
                        {
                           if((backgroundDefForCurrentSituation = InstanceMng.getBackgroundController().getBackgroundDefForCurrentSituation()) != null)
                           {
                              investsAnimLayerClass = InstanceMng.getResourceMng().getSWFClass(this.mBackgroundSku,"invest_flags");
                              if(this.mBGInvestsFlagsDOC == null && investsAnimLayerClass != null)
                              {
                                 this.mBGInvestsFlagsDOC = new investsAnimLayerClass();
                              }
                              if(this.mBGInvestsFlagsDOC != null)
                              {
                                 nextState = 2;
                              }
                              else
                              {
                                 nextState = 4;
                              }
                           }
                        }
                     }
                  }
               }
               this.investsBuildingSetupSetState(nextState);
               break;
            case 2:
               this.mBGInvestsAnimName = InstanceMng.getBackgroundController().getInvestsAnimPath(this.investsBuildingSetupIsAnim());
               InstanceMng.getEResourcesMng().loadAsset(this.mBGInvestsAnimName,"legacy",-1,this.investsBuildingSetupOnSuccess,this.investsBuildingSetupOnError);
               break;
            case 3:
               this.setInvestBuildingAnim();
               this.setInvestsBubbleSpeechAnim();
               break;
            case 4:
               this.mBGInvestsAnim = null;
               if(this.investsBuildingSetupIsAnim())
               {
                  this.onInvestAnimEnd();
                  break;
               }
         }
      }
      
      private function investsBuildingSetupOnSuccess(assetId:String, groupId:String) : void
      {
         this.investsBuildingSetupSetState(3);
      }
      
      private function investsBuildingSetupOnError(assetId:String, groupId:String) : void
      {
         this.investsBuildingSetupSetState(4);
      }
      
      private function investsBuildingSetupIsAnim() : Boolean
      {
         return this.mInvestsBuildingSetupRequiredId == 2;
      }
      
      public function setInvestsBubbleSpeechVisibility(value:Boolean) : void
      {
         if(this.mBGInvestsBubbleSpeech)
         {
            this.mBGInvestsBubbleSpeech.visible = value;
         }
      }
      
      private function setupInvestsAnimation() : void
      {
         var uInfo:UserInfo = null;
         var currPlanetId:String = null;
         var planet:Planet = null;
         var isCapital:Boolean = false;
         var backgroundDefForCurrentSituation:BackgroundDef = null;
         var investsAnimLayerClass:Class = null;
         var currProfileLoaded:Profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         if(currProfileLoaded != null)
         {
            uInfo = currProfileLoaded.getUserInfoObj();
            if(uInfo != null && !uInfo.mIsNPC.value)
            {
               currPlanetId = InstanceMng.getApplication().goToGetCurrentPlanetId();
               if((planet = currProfileLoaded.getUserInfoObj().getPlanetById(currPlanetId)) != null)
               {
                  isCapital = planet.isCapital();
                  if(isCapital)
                  {
                     if((backgroundDefForCurrentSituation = InstanceMng.getBackgroundController().getBackgroundDefForCurrentSituation()) != null)
                     {
                        investsAnimLayerClass = InstanceMng.getResourceMng().getSWFClass(this.mBackgroundSku,"invest_flags");
                        if(this.mBGInvestsFlagsDOC == null && investsAnimLayerClass != null)
                        {
                           this.mBGInvestsFlagsDOC = new investsAnimLayerClass();
                        }
                        if(this.mBGInvestsFlagsDOC != null)
                        {
                           this.setInvestBuildingAnim();
                           this.setInvestsBubbleSpeechAnim();
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function investsGetBuildingCollBox() : DisplayObjectContainer
      {
         var returnValue:DisplayObjectContainer = null;
         var investsAnimName:String = "invest_building";
         if(this.mBGInvestsFlagsDOC != null)
         {
            returnValue = this.mBGInvestsFlagsDOC.getChildByName(investsAnimName) as DisplayObjectContainer;
         }
         return returnValue;
      }
      
      private function setInvestBuildingAnim() : void
      {
         var investsAnimsCollBox:DisplayObjectContainer = null;
         var className:Class = null;
         var isAnim:Boolean = this.investsBuildingSetupIsAnim();
         this.mBGInvestsAnimName = InstanceMng.getBackgroundController().getInvestsAnimPath(isAnim);
         if(this.mBGInvestsFlagsDOC != null && this.mBGInvestsAnimName != null)
         {
            investsAnimsCollBox = this.investsGetBuildingCollBox();
            if(investsAnimsCollBox != null && this.mBackgroundDO != null)
            {
               if(isAnim)
               {
                  className = InstanceMng.getEResourcesMng().getAssetSWF(this.mBGInvestsAnimName,"legacy","invest_animation");
                  if(className != null)
                  {
                     this.mBGInvestsAnim = new className() as MovieClip;
                     MovieClip(this.mBGInvestsAnim).addFrameScript(MovieClip(this.mBGInvestsAnim).totalFrames - 1,this.onInvestAnimEnd);
                  }
               }
               else
               {
                  this.mBGInvestsAnim = new Sprite();
                  if(this.mBGInvestEImage == null)
                  {
                     this.mBGInvestEImage = InstanceMng.getViewFactory().getEImage(this.mBGInvestsAnimName,"legacy",false);
                  }
                  else
                  {
                     InstanceMng.getViewFactory().setTextureToImage(this.mBGInvestsAnimName,"legacy",this.mBGInvestEImage);
                  }
                  this.mBGInvestsAnim.addChild(this.mBGInvestEImage);
                  this.mBGInvestEImage.onSetTextureLoaded = this.investsBuildingCalculatePosition;
               }
               if(this.mBGInvestsAnim != null)
               {
                  this.mBackgroundDO.addChild(this.mBGInvestsAnim);
                  this.investsBuildingCalculatePosition();
               }
            }
         }
         else
         {
            this.mBGInvestsAnim = null;
            if(isAnim)
            {
               this.onInvestAnimEnd();
            }
         }
      }
      
      private function investsBuildingCalculatePosition(img:EImage = null) : void
      {
         var posCenter:DCCoordinate = this.investsBuildingGetPosition();
         if(posCenter != null)
         {
            this.mBGInvestsAnim.x = posCenter.x;
            this.mBGInvestsAnim.y = posCenter.y;
            if(!this.investsBuildingSetupIsAnim())
            {
               this.mBGInvestsAnim.x -= this.mBGInvestsAnim.width / 2;
               this.mBGInvestsAnim.y -= this.mBGInvestsAnim.height / 2;
            }
         }
      }
      
      public function investsBuildingGetPosition() : DCCoordinate
      {
         var investsAnimsCollBox:DisplayObjectContainer = null;
         if(this.mInvestsBuildingPosition == null)
         {
            investsAnimsCollBox = this.investsGetBuildingCollBox();
            if(investsAnimsCollBox != null)
            {
               this.mInvestsBuildingPosition = new DCCoordinate(investsAnimsCollBox.x + this.mBackgroundDO.width / 2,investsAnimsCollBox.y + this.mBackgroundDO.height / 2);
            }
         }
         return this.mInvestsBuildingPosition;
      }
      
      public function getIsInvestAnimRunning() : Boolean
      {
         return this.mIsInvestAnimRunning;
      }
      
      public function setInvestBuildingAnimationRunning(value:Boolean) : void
      {
         this.mIsInvestAnimRunning = value;
         if(value)
         {
            this.removeInvestsFunctionality();
         }
         else
         {
            this.addInvestsFunctionality();
         }
      }
      
      private function onInvestAnimEnd() : void
      {
         if(this.mBGInvestsAnim != null)
         {
            MovieClip(this.mBGInvestsAnim).stop();
         }
         this.setInvestBuildingAnimationRunning(false);
         this.investsBuildingSetupId(1);
         this.setInvestsBubbleSpeechAnim();
         this.addInvestsFunctionality();
         FireWorksMng.getInstance().init(5000);
         this.introEnd();
      }
      
      private function setInvestsBubbleSpeechAnim() : void
      {
         var investsBubbleSpeechCollBox:DisplayObjectContainer = null;
         var bubbleSpeechAsset:String = null;
         var profileInvestsWelcomeFlagId:int = 0;
         var investsBubbleSpeechName:String = "icon_invest";
         if(this.mBGInvestsFlagsDOC != null)
         {
            investsBubbleSpeechCollBox = this.mBGInvestsFlagsDOC.getChildByName(investsBubbleSpeechName) as DisplayObjectContainer;
            if(investsBubbleSpeechCollBox != null && this.mBackgroundDO != null)
            {
               if(this.mBGInvestsBubbleSpeech == null)
               {
                  this.mBGInvestsBubbleSpeech = new Sprite();
               }
               this.mBackgroundDO.addChild(this.mBGInvestsBubbleSpeech);
               bubbleSpeechAsset = InstanceMng.getBackgroundController().geInvestsBubbleSpeechPath();
               this.mBGInvestsBubbleSpeech.x = investsBubbleSpeechCollBox.x + this.mBackgroundDO.width / 2;
               this.mBGInvestsBubbleSpeech.y = investsBubbleSpeechCollBox.y + this.mBackgroundDO.height / 2;
               InstanceMng.getResourceMng().addImageResourceToLoad(this.mBGInvestsBubbleSpeech,bubbleSpeechAsset);
               if(this.mDefaultBubbleSpeechPos == null)
               {
                  this.mDefaultBubbleSpeechPos = new DCCoordinate(this.mBGInvestsBubbleSpeech.x,this.mBGInvestsBubbleSpeech.y);
               }
               this.applyTweenToInvestBubbleSpeech();
               profileInvestsWelcomeFlagId = InstanceMng.getUserInfoMng().getProfileLogin().flagsGetInvestmentsWelcomeId();
               this.setInvestsBubbleSpeechVisibility(!this.mIsInvestAnimRunning && InstanceMng.getInvestMng().hasToShowBubbleSpeech());
            }
         }
      }
      
      private function applyTweenToInvestBubbleSpeech() : void
      {
         var futureCoord:DCCoordinate = new DCCoordinate();
         futureCoord.x = this.mBGInvestsBubbleSpeech.x;
         futureCoord.y = this.mDefaultBubbleSpeechPos.y + 15;
         var tween:GTween = TweenEffectsFactory.createJump(this.mBGInvestsBubbleSpeech,1,futureCoord,this.mDefaultBubbleSpeechPos);
      }
      
      private function addInvestsFunctionality() : void
      {
         if(InstanceMng.getFlowState().getCurrentRoleId() == 0 && this.mouseEventsCanAdd(1))
         {
            if(this.mBGInvestsAnim != null && this.mBGInvestsBubbleSpeech != null)
            {
               this.mBGInvestsAnim.addEventListener("click",this.onClickInvests);
               this.mBGInvestsAnim.addEventListener("mouseOver",this.onMouseOverInvests);
               this.mBGInvestsAnim.addEventListener("mouseOut",this.onMouseOutInvests);
               this.mBGInvestsAnim.addEventListener("mouseDown",this.onMouseDownInvests);
               this.mBGInvestsBubbleSpeech.addEventListener("click",this.onClickInvests);
               this.mBGInvestsBubbleSpeech.addEventListener("mouseOver",this.onMouseOverInvests);
               this.mBGInvestsBubbleSpeech.addEventListener("mouseOut",this.onMouseOutInvests);
               this.mBGInvestsBubbleSpeech.addEventListener("mouseDown",this.onMouseDownInvests);
               this.mouseEventsSetAdded(1,true);
            }
         }
      }
      
      private function removeInvestsFunctionality() : void
      {
         if(this.mouseEventsGetAdded(1))
         {
            if(this.mBGInvestsAnim != null)
            {
               this.mBGInvestsAnim.removeEventListener("click",this.onClickInvests);
               this.mBGInvestsAnim.removeEventListener("mouseOver",this.onMouseOverInvests);
               this.mBGInvestsAnim.removeEventListener("mouseOut",this.onMouseOutInvests);
               this.mBGInvestsAnim.removeEventListener("mouseDown",this.onMouseDownInvests);
            }
            if(this.mBGInvestsBubbleSpeech != null)
            {
               this.mBGInvestsBubbleSpeech.removeEventListener("click",this.onClickInvests);
               this.mBGInvestsBubbleSpeech.removeEventListener("mouseOver",this.onMouseOverInvests);
               this.mBGInvestsBubbleSpeech.removeEventListener("mouseOut",this.onMouseOutInvests);
               this.mBGInvestsBubbleSpeech.removeEventListener("mouseDown",this.onMouseDownInvests);
            }
            this.mouseEventsSetAdded(1,false);
         }
      }
      
      private function onClickInvests(e:MouseEvent) : void
      {
         var roleId:int = InstanceMng.getRole().mId;
         if(this.mBGInvestsAnim != null && roleId != 3)
         {
            if(this.mMouseDownAndScroll == false)
            {
               InstanceMng.getInvestMng().openInvestsPopupDependingOnSituation();
            }
         }
      }
      
      private function onMouseOverInvests(e:MouseEvent) : void
      {
         if(this.mBGInvestsAnim != null)
         {
            this.mBGInvestsAnim.filters = [GameConstants.FILTER_DROPSHADOW_YELLOW];
            this.mBGInvestsBubbleSpeech.filters = [GameConstants.FILTER_DROPSHADOW_YELLOW];
            this.mShowInvestsTooltip = true;
         }
      }
      
      private function onMouseOutInvests(e:MouseEvent) : void
      {
         if(this.mBGInvestsAnim != null)
         {
            this.mBGInvestsAnim.filters = null;
            this.mBGInvestsBubbleSpeech.filters = null;
            this.hideInvestsTooltip();
            this.mShowInvestsTooltip = false;
            this.mInvestsTooltipTimer = 150;
         }
      }
      
      private function onMouseDownInvests(e:MouseEvent) : void
      {
         if(this.mBGInvestsAnim != null)
         {
            this.mBGInvestsAnim.filters = null;
            this.mBGInvestsBubbleSpeech.filters = null;
            this.mMouseDownAndScroll = false;
            this.hideInvestsTooltip();
            this.mShowInvestsTooltip = false;
            this.mInvestsTooltipTimer = 150;
         }
      }
      
      private function showInvestsTooltip() : void
      {
         if(this.getInvestsDOC() != null)
         {
            ETooltipMng.getInstance().createTooltipForSpecialMapObject(DCTextMng.getText(3106),this.getInvestsDOC());
         }
      }
      
      private function hideInvestsTooltip() : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
         this.mInvestsTooltipShown = false;
      }
      
      public function getInvestsDOC() : DisplayObjectContainer
      {
         if(this.mBGInvestsAnim == null)
         {
            this.setupInvestsAnimation();
         }
         return this.mBGInvestsAnim;
      }
      
      private function investsLogicUpdate(dt:int) : void
      {
         if(this.mShowInvestsTooltip)
         {
            if(this.mInvestsTooltipTimer <= 0)
            {
               this.showInvestsTooltip();
               this.mInvestsTooltipShown = true;
               this.mShowInvestsTooltip = false;
               this.mInvestsTooltipTimer = 150;
            }
            else
            {
               this.mInvestsTooltipTimer -= dt;
            }
         }
      }
      
      private function setupAllianceAnimation() : void
      {
         var allianceAnimName:String = null;
         var allianceAnimClass:Class = null;
         var allianceAnimsCollisionBox:DisplayObjectContainer = null;
         var className:Class = null;
         var backgroundDefForCurrentSituation:BackgroundDef = InstanceMng.getBackgroundController().getBackgroundDefForCurrentSituation();
         if(backgroundDefForCurrentSituation != null)
         {
            allianceAnimName = backgroundDefForCurrentSituation.getAllianceAnimation();
            allianceAnimClass = InstanceMng.getResourceMng().getSWFClass(this.mBackgroundSku,"alliance_flags");
            if(this.mBGAllianceFlagsDOC == null && allianceAnimClass != null)
            {
               this.mBGAllianceFlagsDOC = new allianceAnimClass();
            }
            if(this.mBGAllianceAnimName == null)
            {
               this.mBGAllianceAnimName = InstanceMng.getBackgroundController().getAllianceAnimationAssetForCurrentSituation();
            }
            if(this.mBGAllianceFlagsDOC != null && this.mBGAllianceAnimName != null)
            {
               if((allianceAnimsCollisionBox = this.mBGAllianceFlagsDOC.getChildByName(allianceAnimName) as DisplayObjectContainer) != null && this.mBackgroundDO != null)
               {
                  if((className = InstanceMng.getResourceMng().getSWFClass(this.mBGAllianceAnimName,allianceAnimName)) != null)
                  {
                     this.mBGAllianceAnim = new className() as MovieClip;
                     if(this.mBGAllianceAnim != null)
                     {
                        this.mBGAllianceAnim.x = allianceAnimsCollisionBox.x + this.mBackgroundDO.width / 2;
                        this.mBGAllianceAnim.y = allianceAnimsCollisionBox.y + this.mBackgroundDO.height / 2;
                        allianceAnimsCollisionBox.visible = false;
                        this.mBackgroundDO.addChild(this.mBGAllianceAnim);
                        this.setAllianceFlagsAnimationVisibility(false);
                     }
                     if(this.mShowAllianceCouncilFX)
                     {
                        this.addFunctionalityToAlliancesCouncil();
                     }
                  }
               }
            }
         }
      }
      
      public function getAllianceAnimDOC() : DisplayObjectContainer
      {
         if(this.mBGAllianceAnim == null)
         {
            this.setupAllianceAnimation();
         }
         return this.mBGAllianceAnim;
      }
      
      private function alliancesCouncilLogicUpdate(dt:int) : void
      {
         if(this.mShowAllianceCouncilTooltip)
         {
            if(this.mAlliancesCouncilTooltipTimer <= 0)
            {
               this.showAllianceCouncilTooltip();
               this.mAllianceCouncilTooltipShown = true;
               this.mShowAllianceCouncilTooltip = false;
               this.mAlliancesCouncilTooltipTimer = 150;
            }
            else
            {
               this.mAlliancesCouncilTooltipTimer -= dt;
            }
         }
      }
      
      private function addFunctionalityToAlliancesCouncil() : void
      {
         if(this.mBGAllianceAnim != null && this.mouseEventsCanAdd(0))
         {
            this.mBGAllianceAnim.addEventListener("click",this.onClickAlliancesCouncil);
            this.mBGAllianceAnim.addEventListener("mouseOver",this.onMouseOverAlliancesCouncil);
            this.mBGAllianceAnim.addEventListener("mouseOut",this.onMouseOutAlliancesCouncil);
            this.mBGAllianceAnim.addEventListener("mouseDown",this.onMouseDownAlliancesCouncil);
            this.mouseEventsSetAdded(0,true);
         }
      }
      
      private function removeFunctionalityToAlliancesCouncil() : void
      {
         if(this.mBGAllianceAnim != null && this.mouseEventsGetAdded(0))
         {
            this.mBGAllianceAnim.removeEventListener("click",this.onClickAlliancesCouncil);
            this.mBGAllianceAnim.removeEventListener("mouseOver",this.onMouseOverAlliancesCouncil);
            this.mBGAllianceAnim.removeEventListener("mouseOut",this.onMouseOutAlliancesCouncil);
            this.mBGAllianceAnim.removeEventListener("mouseDown",this.onMouseDownAlliancesCouncil);
            this.mouseEventsSetAdded(0,false);
         }
      }
      
      private function onClickAlliancesCouncil(e:MouseEvent) : void
      {
         var allianceLoaded:Alliance = null;
         var roleId:int = InstanceMng.getRole().mId;
         if(this.mBGAllianceAnim != null && roleId != 3)
         {
            if(this.mMouseDownAndScroll == false)
            {
               allianceLoaded = InstanceMng.getAlliancesController().getWorldAlliance();
               if(allianceLoaded != null)
               {
                  AlliancesControllerStar(InstanceMng.getAlliancesController()).guiOpenPopupAllianceMembers(allianceLoaded,null);
               }
            }
         }
      }
      
      private function onMouseOverAlliancesCouncil(e:MouseEvent) : void
      {
         var cursor:CursorFacade = null;
         if(this.mBGAllianceAnim != null)
         {
            this.mBGAllianceAnim.filters = [GameConstants.FILTER_DROPSHADOW_YELLOW];
            cursor = InstanceMng.getUIFacade().getCursorFacade();
            if(cursor.getCursorId() != 11)
            {
               this.mCursorId = cursor.getCursorId();
            }
            cursor.setCursorId(11);
            this.mShowAllianceCouncilTooltip = true;
         }
      }
      
      private function onMouseOutAlliancesCouncil(e:MouseEvent) : void
      {
         if(this.mBGAllianceAnim != null)
         {
            this.mBGAllianceAnim.filters = null;
            this.hideAllianceCouncilTooltipAndCursor();
            this.mShowAllianceCouncilTooltip = false;
            this.mAlliancesCouncilTooltipTimer = 150;
         }
      }
      
      private function onMouseDownAlliancesCouncil(e:MouseEvent) : void
      {
         if(this.mBGAllianceAnim != null)
         {
            this.mMouseDownAndScroll = false;
            this.mBGAllianceAnim.filters = null;
            this.hideAllianceCouncilTooltip();
            this.mShowAllianceCouncilTooltip = false;
            this.mAlliancesCouncilTooltipTimer = 150;
         }
      }
      
      private function showAllianceCouncilTooltip() : void
      {
         var alliance:Alliance = InstanceMng.getAlliancesController().getWorldAlliance();
         if(alliance != null && this.mAllianceCouncilTooltipShown == false)
         {
            ETooltipMng.getInstance().createTooltipForSpecialMapObject(alliance.getName(),this.getAllianceAnimDOC());
         }
      }
      
      private function hideAllianceCouncilTooltip() : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
         this.mAllianceCouncilTooltipShown = false;
      }
      
      private function hideAllianceCouncilTooltipAndCursor() : void
      {
         this.hideAllianceCouncilTooltip();
         InstanceMng.getUIFacade().getCursorFacade().setCursorId(this.mCursorId);
      }
      
      public function setAllianceFlagsAnimationVisibility(value:Boolean) : void
      {
         if(this.mBGAllianceAnim != null)
         {
            this.mBGAllianceAnim.visible = value;
         }
      }
      
      public function backgroundAnimsSetEnabled(value:Boolean) : void
      {
         var backgroundAnimsDO:Sprite = null;
         var child:DisplayObject = null;
         var i:int = 0;
         if(this.mBackgroundAnimsEnabled != value)
         {
            this.mBackgroundAnimsEnabled = value;
         }
         var backgroundClass:Class;
         if((backgroundClass = InstanceMng.getResourceMng().getSWFClass(this.mBackgroundSku,"anim")) == null)
         {
            this.mBackgroundAnimsEnabled = false;
         }
         if(this.mBackgroundAnimsEnabled)
         {
            if(this.mBackgroundAnimsChild == null)
            {
               this.mBackgroundAnimsChild = new Vector.<DisplayObject>(0);
               backgroundAnimsDO = new backgroundClass();
               for(i = 0; i < backgroundAnimsDO.numChildren; )
               {
                  if((child = backgroundAnimsDO.getChildAt(i)) is MovieClip)
                  {
                     MovieClip(child).stop();
                  }
                  child.x += this.mBackgroundDO.width / 2;
                  child.y += this.mBackgroundDO.height / 2;
                  backgroundAnimsDO.removeChild(child);
                  this.mBackgroundAnimsChild.push(child);
               }
               backgroundAnimsDO = null;
            }
         }
         else if(this.mBackgroundAnimsChild != null)
         {
            for each(child in this.mBackgroundAnimsChild)
            {
               if(this.mBackgroundDO.contains(child))
               {
                  if(child is MovieClip)
                  {
                     MovieClip(child).gotoAndStop(1);
                  }
                  this.mBackgroundDO.removeChild(child);
               }
            }
         }
      }
      
      public function getBackgroundAnimsEnabled() : Boolean
      {
         return this.mBackgroundAnimsEnabled;
      }
      
      private function fillAnimationsTimers() : void
      {
         var animsVector:Vector.<Object> = null;
         var obj:Object = null;
         var timeMs:Number = NaN;
         var bgDef:BackgroundDef = InstanceMng.getBackgroundController().getBackgroundDefForCurrentSituation();
         if(bgDef != null)
         {
            animsVector = bgDef.getAnimations();
         }
         if(animsVector != null)
         {
            if(this.mBGAnimsTimers == null)
            {
               this.mBGAnimsTimers = new Dictionary();
            }
            for each(obj in animsVector)
            {
               if(obj != null)
               {
                  timeMs = DCTimerUtil.minToMs(obj.time);
                  this.mBGAnimsTimers[obj.name] = timeMs;
               }
            }
         }
      }
      
      private function backgroundAnimsUpdate(dt:int) : void
      {
         var mc:DisplayObject = null;
         var index:int = 0;
         var maxWidth:int = 0;
         var maxHeight:int = 0;
         var pos:Point = null;
         var stageWidth:Number = NaN;
         var stageHeight:Number = NaN;
         var isSpecialAnim:* = false;
         var specialAnimTimer:Number = NaN;
         var horizontalPositionCorrect:Boolean = false;
         var verticalPositionCorrect:Boolean = false;
         var moviec:MovieClip = null;
         if(this.mBackgroundAnimsEnabled)
         {
            index = 1;
            pos = new Point();
            stageWidth = InstanceMng.getApplication().stageGetWidth();
            stageHeight = InstanceMng.getApplication().stageGetHeight();
            isSpecialAnim = false;
            specialAnimTimer = 0;
            for each(mc in this.mBackgroundAnimsChild)
            {
               pos.x = mc.x;
               pos.y = mc.y;
               isSpecialAnim = false;
               maxWidth = mc.width;
               maxHeight = mc.height;
               horizontalPositionCorrect = (pos = this.mBackgroundDO.localToGlobal(pos)).x + maxWidth > 0 && pos.x < stageWidth;
               verticalPositionCorrect = pos.y + maxHeight > 0 && pos.y < stageHeight;
               if(this.mBGAnimsTimers == null)
               {
                  this.fillAnimationsTimers();
               }
               if(this.mBGAnimsTimers != null)
               {
                  specialAnimTimer = (isSpecialAnim = this.mBGAnimsTimers[mc.name] != null) ? Number(this.mBGAnimsTimers[mc.name]) : 0;
               }
               if(horizontalPositionCorrect && verticalPositionCorrect)
               {
                  if(!this.mBackgroundDO.contains(mc))
                  {
                     if(isSpecialAnim)
                     {
                        if(specialAnimTimer <= 0)
                        {
                           this.mBackgroundDO.addChild(mc);
                           if(mc is MovieClip)
                           {
                              (mc as MovieClip).play();
                           }
                        }
                     }
                     else
                     {
                        if(index > this.mBackgroundDO.numChildren)
                        {
                           this.mBackgroundDO.addChild(mc);
                        }
                        else
                        {
                           this.mBackgroundDO.addChildAt(mc,index);
                        }
                        if(mc is MovieClip)
                        {
                           MovieClip(mc).play();
                        }
                     }
                  }
               }
               else if(this.mBackgroundDO.contains(mc))
               {
                  this.mBackgroundDO.removeChild(mc);
                  if(isSpecialAnim)
                  {
                     this.resetSpecialAnimation(MovieClip(mc));
                  }
               }
               if(isSpecialAnim)
               {
                  moviec = mc as MovieClip;
                  if(moviec.currentFrame == moviec.totalFrames)
                  {
                     if(this.mBackgroundDO.contains(moviec))
                     {
                        this.mBackgroundDO.removeChild(moviec);
                     }
                     this.resetSpecialAnimation(moviec);
                  }
               }
               index++;
               if(isSpecialAnim && specialAnimTimer > 0)
               {
                  this.mBGAnimsTimers[mc.name] -= dt;
               }
            }
         }
      }
      
      private function resetSpecialAnimation(mc:MovieClip) : void
      {
         mc.gotoAndStop(1);
         var bgDef:BackgroundDef = InstanceMng.getBackgroundController().getBackgroundDefForCurrentSituation();
         if(this.mBGAnimsTimers != null)
         {
            this.mBGAnimsTimers[mc.name] = DCTimerUtil.minToMs(bgDef.getAnimationTimeByName(mc.name));
         }
      }
      
      private function mouseEventsLoad() : void
      {
         if(this.mMouseEventsEnabled == null)
         {
            this.mMouseEventsEnabled = new Vector.<Boolean>(2);
            this.mMouseEventsAdded = new Vector.<Boolean>(2);
         }
      }
      
      private function mouseEventsUnload() : void
      {
         this.mMouseEventsEnabled = null;
         this.mMouseEventsAdded = null;
      }
      
      private function mouseEventsSetEnabled(key:int, value:Boolean) : void
      {
         if(this.mMouseEventsEnabled != null)
         {
            this.mMouseEventsEnabled[key] = value;
         }
      }
      
      private function mouseEventsGetEnabled(key:int) : Boolean
      {
         return this.mMouseEventsEnabled == null ? false : this.mMouseEventsEnabled[key];
      }
      
      private function mouseEventsSetAdded(key:int, value:Boolean) : void
      {
         if(this.mMouseEventsAdded != null)
         {
            this.mMouseEventsAdded[key] = value;
         }
      }
      
      private function mouseEventsGetAdded(key:int) : Boolean
      {
         return this.mMouseEventsAdded == null ? false : this.mMouseEventsAdded[key];
      }
      
      public function mouseEventsSetEnabledAnimsOnMap(value:Boolean, forced:Boolean) : void
      {
         this.mouseEventsSetEnabled(1,value);
         this.mouseEventsSetEnabled(0,value);
         if(forced)
         {
            if(value)
            {
               this.addInvestsFunctionality();
               this.addFunctionalityToAlliancesCouncil();
            }
            else
            {
               this.removeInvestsFunctionality();
               this.removeFunctionalityToAlliancesCouncil();
            }
         }
      }
      
      private function mouseEventsCanAdd(key:int) : Boolean
      {
         return this.mouseEventsGetEnabled(key) && !this.mouseEventsGetAdded(key);
      }
      
      private function tilesetBegin() : void
      {
         if(this.mTilesetDO != null)
         {
            this.mTilesetIsVisible = true;
            this.tilesetAddToStage();
            this.tilesetSetGridVisible(false);
         }
      }
      
      private function tilesetEnd() : void
      {
         if(this.mTilesetDO != null)
         {
            this.mTilesetIsVisible = false;
            this.tilesetRemoveFromStage();
         }
      }
      
      public function tilesetSetGridVisible(value:Boolean) : void
      {
         if(value != this.mTilesetIsVisible)
         {
            this.tilesetToggleVisibility();
         }
      }
      
      public function tilesetToggleVisibility() : void
      {
         if(this.mTilesetDO != null)
         {
            this.mTilesetIsVisible = !this.mTilesetIsVisible;
            if(this.mTilesetIsVisible)
            {
               this.mTilesetDO.setTileIdVisibleStart(-1);
            }
            else
            {
               this.mTilesetDO.setTileIdVisibleStart(3);
            }
            this.mTilesetDO.redraw();
         }
      }
      
      private function tilesetAddToStage() : void
      {
         if(!this.mTilesetIsInStage)
         {
            this.mViewMngPlanet.mapAddToStage(this.mTilesetDO);
            this.mTilesetIsInStage = true;
         }
      }
      
      private function tilesetRemoveFromStage() : void
      {
         if(this.mTilesetIsInStage)
         {
            this.mViewMngPlanet.mapRemoveFromStage(this.mTilesetDO);
            this.mTilesetIsInStage = false;
         }
      }
      
      public function tilesetMoveXY(offX:int, offY:int) : void
      {
         if(this.mTilesetDO != null)
         {
            this.mTilesetOffX += offX;
            this.mTilesetOffY += offY;
            this.mTilesetDO.x = this.mViewMngPlanet.worldGetMapX() + this.mTilesetOffX;
            this.mTilesetDO.y = this.mViewMngPlanet.worldGetMapY() + this.mTilesetOffY;
         }
      }
      
      private function gridLoad() : void
      {
         this.mGridDOs = new Vector.<DCDisplayObject>(1);
         this.mGridDOs[0] = InstanceMng.getPoolMng().animGet("assets/flash/world_items/pngs_common/grille.png",null);
         this.mGridDOs[0].alpha = 0.95;
      }
      
      private function gridUnload() : void
      {
         this.mGridDOs = null;
      }
      
      public function gridBegin() : void
      {
         this.mGridCurrentId = -1;
      }
      
      public function gridEnd() : void
      {
         if(this.mGridCurrentId > -1 && this.mGridDOs != null)
         {
            this.mViewMngPlanet.mapGridRemoveFromStage(this.mGridDOs[this.mGridCurrentId]);
            this.mGridCurrentId = -1;
         }
      }
      
      public function gridSet(id:int) : void
      {
         if(id != this.mGridCurrentId)
         {
            if(this.mGridDOs == null)
            {
               this.gridLoad();
            }
            if(this.mGridCurrentId > -1)
            {
               this.mViewMngPlanet.mapGridRemoveFromStage(this.mGridDOs[this.mGridCurrentId]);
            }
            this.mViewMngPlanet.mapGridAddToStage(this.mGridDOs[id]);
            this.mGridCurrentId = id;
         }
      }
      
      public function gridSetXY(x:int, y:int) : void
      {
         var offsetX:Number = NaN;
         var offsetY:Number = NaN;
         if(this.mGridCurrentId > -1)
         {
            offsetX = Math.floor(this.mGridDOs[this.mGridCurrentId].width / 2);
            offsetY = Math.floor(this.mGridDOs[this.mGridCurrentId].height / 2);
            DCDisplayObject(this.mGridDOs[this.mGridCurrentId]).setXY(x - offsetX,y - offsetY);
         }
      }
      
      public function drawPerspectiveRectTiles(g:Graphics, tileX:Number, tileY:Number, tilesWidth:Number, tilesHeight:Number, color:uint = 0, doClear:Boolean = true, doLines:Boolean = true) : void
      {
         this.mViewMngPlanet.tileAreaToWorldViewPos(tileX,tileY,tilesWidth,tilesHeight,this.mCorners);
         DCUtils.drawShape(g,this.mCorners,color,doClear,doLines);
      }
      
      public function drawMapBorder() : void
      {
         var shapeCoords:* = undefined;
         var i:int = 0;
         var sideLength:int = 0;
         var sectors:int = 0;
         var forceSquares:* = false;
         var tilesPerSquare:int = 0;
         var MAX_THICKNESS:int = 5;
         var MIN_THICKNESS:int = 2;
         var resolution:int = BORDER_RESOLUTION_SETTINGS[this.mBorderResolutionIndex];
         this.mBorderShapes = new Vector.<DCDisplayObjectSWF>(0);
         var mapRows:int = int(this.mMapControllerPlanet.mTilesRows);
         var mapCols:int = int(this.mMapControllerPlanet.mTilesCols);
         this.mViewMngPlanet.tileAreaToWorldViewPos(0,0,mapCols,mapRows,this.mCorners);
         this.drawMapBorderShape(this.mCorners,MAX_THICKNESS);
         if(resolution > 0)
         {
            sectors = resolution + 1;
            forceSquares = resolution != 1;
            tilesPerSquare = Math.min(mapRows / sectors,mapCols / sectors);
            for(i = 1; i < mapRows / tilesPerSquare; )
            {
               sideLength = forceSquares ? i * tilesPerSquare : i * mapRows / sectors;
               shapeCoords = new Vector.<Number>(0);
               this.mViewMngPlanet.tileAreaToWorldViewPos(0,sideLength,mapCols,0,shapeCoords);
               this.drawMapBorderShape(shapeCoords,Math.max(MIN_THICKNESS,MAX_THICKNESS - resolution / 12));
               i++;
            }
            for(i = 1; i < mapCols / tilesPerSquare; )
            {
               sideLength = forceSquares ? i * tilesPerSquare : i * mapCols / sectors;
               shapeCoords = new Vector.<Number>(0);
               this.mViewMngPlanet.tileAreaToWorldViewPos(sideLength,0,0,mapRows,shapeCoords);
               this.drawMapBorderShape(shapeCoords,Math.max(MIN_THICKNESS,MAX_THICKNESS - resolution / 12));
               i++;
            }
         }
      }
      
      private function drawMapBorderShape(shapeCoords:Vector.<Number>, thickness:Number) : void
      {
         var shape:Shape = new Shape();
         var shapeDO:DCDisplayObjectSWF = new DCDisplayObjectSWF(shape);
         DCUtils.drawShape(shape.graphics,shapeCoords,16777215,true,true,true,0.5,thickness);
         this.mBorderShapes.push(shapeDO);
         InstanceMng.getViewMngPlanet().addChildToLayer(shapeDO,"LayerParticles");
      }
      
      public function removeMapBorder() : void
      {
         for each(var DCShape in this.mBorderShapes)
         {
            InstanceMng.getViewMngPlanet().removeChildFromLayer(DCShape,"LayerParticles");
         }
      }
      
      public function drawTilesArea(tileX:int, tileY:int, tilesCountX:int = 1, tilesCountY:int = 1, color:uint = 16777215) : void
      {
         this.mItemBorder = new Shape();
         this.mDCItemBorder = new DCDisplayObjectSWF(this.mItemBorder);
         InstanceMng.getViewMngPlanet().cursorItemToolAddToStage(this.mDCItemBorder);
         this.mViewMngPlanet.tileAreaToWorldViewPos(tileX,tileY,tilesCountX,tilesCountY,this.mCorners);
         DCUtils.drawShape(this.mItemBorder.graphics,this.mCorners,color,false,true,true,1,2);
      }
      
      public function clearMap() : void
      {
         if(this.mItemBorder != null)
         {
            this.mItemBorder.graphics.clear();
         }
      }
      
      public function drawHouseBorder(wioItem:WorldItemObject, tileX:int, tileY:int) : void
      {
         var tileData:TileData = null;
         var item:WorldItemObject = null;
         var currentItemTileX:int = 0;
         var currentItemTileY:int = 0;
         var dist:Number = NaN;
         var alpha:Number = NaN;
         if(this.mItemBorder == null)
         {
            this.mItemBorder = new Shape();
            this.mDCItemBorder = new DCDisplayObjectSWF(this.mItemBorder);
         }
         if(this.mItemsDrawn == null)
         {
            this.mItemsDrawn = new Vector.<WorldItemObject>(0);
         }
         this.mItemsDrawn.length = 0;
         this.mItemBorder.graphics.clear();
         var tileXInit:int = tileX - 10;
         var tileYInit:int = tileY - 10;
         var tileXEnd:int = tileX + wioItem.getBaseCols() + 10;
         var tileYEnd:int = tileY + wioItem.getBaseRows() + 10;
         var coord1:DCCoordinate = new DCCoordinate();
         var coord2:DCCoordinate = new DCCoordinate();
         var coord13D:Vector3D = new Vector3D();
         var coord23D:Vector3D = new Vector3D();
         coord1.x = tileX;
         coord1.y = tileY;
         coord1 = this.mMapControllerPlanet.getTileXYToPos(coord1);
         coord13D.x = coord1.x;
         coord13D.y = coord1.y;
         if(tileXInit < 0)
         {
            tileXInit = 0;
         }
         if(tileYInit < 0)
         {
            tileYInit = 0;
         }
         if(tileXEnd > this.mMapControllerPlanet.mTilesCols)
         {
            tileXEnd = int(this.mMapControllerPlanet.mTilesCols);
         }
         if(tileYEnd > this.mMapControllerPlanet.mTilesRows)
         {
            tileYEnd = int(this.mMapControllerPlanet.mTilesRows);
         }
         for(tileY = tileYInit; tileY < tileYEnd; )
         {
            for(tileX = tileXInit; tileX < tileXEnd; )
            {
               if((tileData = this.mMapControllerPlanet.getTileDataFromTileXY(tileX,tileY)) != null)
               {
                  if((item = tileData.mBaseItem) != null && this.mItemsDrawn.indexOf(item) == -1)
                  {
                     currentItemTileX = int(this.mMapControllerPlanet.getTileRelativeXToTile(item.mTileRelativeX));
                     currentItemTileY = int(this.mMapControllerPlanet.getTileRelativeYToTile(item.mTileRelativeY));
                     coord2.x = currentItemTileX;
                     coord2.y = currentItemTileY;
                     coord2 = this.mMapControllerPlanet.getTileXYToPos(coord2);
                     coord23D.x = coord2.x;
                     coord23D.y = coord2.y;
                     if((dist = Math.abs(coord23D.subtract(coord13D).length)) == 0)
                     {
                        alpha = 0.5;
                     }
                     else
                     {
                        alpha = 0.5 * (200 / dist);
                     }
                     this.mItemsDrawn.push(item);
                     this.drawItemBorder(item,16777215,alpha);
                  }
               }
               tileX++;
            }
            tileY++;
         }
      }
      
      public function drawAllItemsBorder() : void
      {
         var wio:WorldItemObject = null;
         if(this.mItemBorder == null)
         {
            this.mItemBorder = new Shape();
            this.mDCItemBorder = new DCDisplayObjectSWF(this.mItemBorder);
         }
         if(this.mItemsDrawn == null)
         {
            this.mItemsDrawn = new Vector.<WorldItemObject>(0);
         }
         this.mItemsDrawn.length = 0;
         this.mItemBorder.graphics.clear();
         InstanceMng.getViewMngPlanet().cursorItemToolAddToStage(this.mDCItemBorder);
         var wioVector:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         for each(wio in wioVector)
         {
            if(this.mItemsDrawn.indexOf(wio) == -1)
            {
               this.mItemsDrawn.push(wio);
               this.drawItemBorder(wio,16777215,0.5);
            }
         }
      }
      
      public function drawItemBorder(item:WorldItemObject, color:uint, alpha:Number = 0.5) : void
      {
         var itemTileX:int = 0;
         var itemTileY:int = 0;
         itemTileX = int(this.mMapControllerPlanet.getTileRelativeXToTile(item.mTileRelativeX));
         itemTileY = int(this.mMapControllerPlanet.getTileRelativeYToTile(item.mTileRelativeY));
         this.mViewMngPlanet.tileAreaToWorldViewPos(itemTileX,itemTileY,item.getBaseCols(),item.getBaseRows(),this.mCorners);
         DCUtils.drawShape(this.mItemBorder.graphics,this.mCorners,color,false,true,true,alpha,2);
      }
      
      public function drawAttachedToMouseItemBorder(item:WorldItemObject) : void
      {
         if(this.mItemBorder == null)
         {
            this.mItemBorder = new Shape();
            this.mDCItemBorder = new DCDisplayObjectSWF(this.mItemBorder);
         }
         InstanceMng.getViewMngPlanet().cursorItemToolAddToStage(this.mDCItemBorder);
      }
      
      public function removeAttachedToMouseItemBorder() : void
      {
         InstanceMng.getViewMngPlanet().cursorItemToolRemoveFromStage(this.mDCItemBorder);
      }
      
      private function debugLoad() : void
      {
         this.mDebugPaths = new Dictionary(true);
      }
      
      private function debugUnload() : void
      {
         this.mDebugPaths = null;
         this.mDebugShape = null;
      }
      
      public function debugShowPath(p:DCPath) : void
      {
         var t:TileData = null;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var shape:Shape;
         var g:Graphics = (shape = new Shape()).graphics;
         this.mDebugPaths[p] = shape;
         for each(t in p.nodes)
         {
            this.mCoor.x = t.mCol;
            this.mCoor.setY(t.mRow);
            viewMng.tileXYToWorldViewPos(this.mCoor,true);
            DCUtils.fillCircle(g,16773120,3,this.mCoor.x,this.mCoor.y);
         }
         viewMng.addDebug(shape);
      }
      
      public function debugHidePaths() : void
      {
         var s:Shape = null;
         var viewMng:ViewMngrGame = InstanceMng.getViewMngGame();
         for each(s in this.mDebugPaths)
         {
            viewMng.removeDebug(s);
         }
      }
      
      public function debugDrawPoints(v:Vector.<TileData>) : void
      {
         var t:TileData = null;
         this.debugHidePaths();
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         if(this.mDebugShape == null)
         {
            this.mDebugShape = new Shape();
            viewMng.addDebug(this.mDebugShape);
         }
         else
         {
            this.mDebugShape.graphics.clear();
         }
         var g:Graphics = this.mDebugShape.graphics;
         for each(t in v)
         {
            this.mCoor.x = t.mCol;
            this.mCoor.y = t.mRow;
            viewMng.tileXYToWorldViewPos(this.mCoor,true);
            DCUtils.fillCircle(g,16777215,3,this.mCoor.x,this.mCoor.y);
         }
      }
      
      public function debugClearPoints() : void
      {
         if(this.mDebugShape != null)
         {
            this.mDebugShape.graphics.clear();
         }
      }
      
      public function onIncrementBorderResolution() : void
      {
         this.removeMapBorder();
         this.mBorderResolutionIndex += 1;
         if(this.mBorderResolutionIndex >= BORDER_RESOLUTION_SETTINGS.length)
         {
            this.mBorderResolutionIndex = 0;
         }
         this.drawMapBorder();
      }
      
      public function resetBorderResolution() : void
      {
         this.mBorderResolutionIndex = 0;
      }
      
      public function scrollBegin() : void
      {
         this.mScrollIsBegun = true;
         this.mMouseDownAndScroll = true;
      }
      
      public function scrollEnd() : void
      {
         this.mScrollIsBegun = false;
      }
      
      public function updateFriendsBarPathInfo() : void
      {
         var starName:String = InstanceMng.getApplication().goToGetCurrentStarName();
         var coords:DCCoordinate = InstanceMng.getApplication().goToGetCurrentStarCoors();
         InstanceMng.getUIFacade().navigationPanelSetSolarSystemData(starName,coords);
      }
      
      private function happeningsUnload() : void
      {
         var k:* = null;
         var happeningMapView:HappeningMapView = null;
         if(this.mHappeningsMapViews != null)
         {
            for(k in this.mHappeningsMapViews)
            {
               happeningMapView = this.mHappeningsMapViews[k];
               happeningMapView.unload();
            }
            this.mHappeningsMapViews = null;
         }
      }
      
      private function happeningsBegin() : void
      {
         var happeningMng:HappeningMng = null;
         var defs:Vector.<DCDef> = null;
         var happening:Happening = null;
         var happeningSku:String = null;
         var def:HappeningDef = null;
         if(Config.useHappenings())
         {
            happeningMng = InstanceMng.getHappeningMng();
            if(happeningMng.isActive())
            {
               defs = InstanceMng.getHappeningDefMng().getDefs();
               if(defs != null)
               {
                  for each(def in defs)
                  {
                     happeningSku = def.mSku;
                     if((happening = happeningMng.getHappening(happeningSku)) != null)
                     {
                        if(happening.isRunning())
                        {
                           this.happeningsShowHappening(def.mSku,true);
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function happeningsEnd() : void
      {
         var k:* = null;
         var sku:String = null;
         var happeningMapView:HappeningMapView = null;
         if(this.mHappeningsMapViews != null)
         {
            for(k in this.mHappeningsMapViews)
            {
               sku = k as String;
               happeningMapView = this.mHappeningsMapViews[sku] as HappeningMapView;
               happeningMapView.setOn(false);
            }
         }
      }
      
      public function happeningsShowHappening(happeningSku:String, value:Boolean) : void
      {
         var happeningDef:HappeningDef;
         if((happeningDef = InstanceMng.getHappeningDefMng().getDefBySku(happeningSku) as HappeningDef) != null)
         {
            happeningSku = happeningDef.getTypeSku();
         }
         if(this.mHappeningsMapViews == null)
         {
            this.mHappeningsMapViews = new Dictionary();
         }
         if(this.mHappeningsMapViews[happeningSku] == null)
         {
            this.mHappeningsMapViews[happeningSku] = new HappeningMapView(happeningSku);
         }
         var happeningMapView:HappeningMapView = this.mHappeningsMapViews[happeningSku];
         happeningMapView.setOn(value);
      }
      
      public function happeningsLogicUpdate(dt:int) : void
      {
         var k:* = null;
         var sku:String = null;
         var happeningMapView:HappeningMapView = null;
         if(this.mHappeningsMapViews != null)
         {
            for(k in this.mHappeningsMapViews)
            {
               sku = k as String;
               happeningMapView = this.mHappeningsMapViews[k] as HappeningMapView;
               happeningMapView.logicUpdate(dt);
            }
         }
      }
      
      public function introStart(type:int, listener:DCComponent = null, event:Object = null) : void
      {
         var happeningDef:HappeningDef = null;
         var sku:String = null;
         InstanceMng.getMissionsMng().hideTemporarilyMissionsInHud();
         InstanceMng.getGUIController().lockGUI();
         InstanceMng.getMissionsMng().enableMissionDrop(false);
         switch(type)
         {
            case 0:
               if((happeningDef = event.happeningDef) != null)
               {
                  switch(sku = happeningDef.getTypeSku())
                  {
                     case "halloween":
                        this.mIntroFsm = new IntroFsmHalloween(this.mBackgroundDO);
                        break;
                     case "doomsday":
                        this.mIntroFsm = new IntroFsmDoomsDay(this.mBackgroundDO);
                        break;
                     case "birthday":
                        this.mIntroFsm = new IntroFsmBirthday(this.mBackgroundDO);
                        break;
                     case "winter":
                     case "winter23":
                        this.mIntroFsm = new IntroFsmBirthday(this.mBackgroundDO);
                        break;
                     default:
                        this.mIntroFsm = new IntroFsmDoomsDay(this.mBackgroundDO);
                  }
                  InstanceMng.getUIFacade().blackStripsShow(true);
                  break;
               }
         }
         this.mIntroListener = listener;
         this.mIntroEvent = event;
      }
      
      public function introEnd() : void
      {
         InstanceMng.getGUIController().unlockGUI();
         InstanceMng.getMissionsMng().enableMissionDrop(true);
         InstanceMng.getMissionsMng().showBackMissionsInHud();
         this.mIntroFsm = null;
         if(this.mIntroListener != null)
         {
            InstanceMng.getNotifyMng().addEvent(this.mIntroListener,this.mIntroEvent,true);
            this.mIntroListener = null;
            this.mIntroEvent = null;
         }
         InstanceMng.getUIFacade().blackStripsHide();
      }
      
      private function introLogicUpdate(dt:int) : void
      {
         if(this.mIntroFsm != null)
         {
            if(this.mIntroFsm.logicUpdate(dt))
            {
               this.introEnd();
            }
         }
      }
   }
}
