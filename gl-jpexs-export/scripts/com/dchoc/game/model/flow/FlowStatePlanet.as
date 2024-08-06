package com.dchoc.game.model.flow
{
   import com.dchoc.game.controller.animation.JailAnimMng;
   import com.dchoc.game.controller.animation.TutorialKidnapMng;
   import com.dchoc.game.controller.gameunit.GameUnitMngController;
   import com.dchoc.game.controller.gui.GUIControllerPlanet;
   import com.dchoc.game.controller.hangar.BunkerController;
   import com.dchoc.game.controller.hangar.HangarControllerMng;
   import com.dchoc.game.controller.map.BackgroundController;
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.controller.shop.BuildingsBufferController;
   import com.dchoc.game.controller.shop.BuildingsShopController;
   import com.dchoc.game.controller.shop.ShipyardController;
   import com.dchoc.game.controller.tools.Tool;
   import com.dchoc.game.controller.tools.ToolsMng;
   import com.dchoc.game.controller.world.item.WorldItemObjectController;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.utils.animations.AnimMng;
   import com.dchoc.game.core.utils.collisionboxes.CollisionBoxMng;
   import com.dchoc.game.core.utils.memory.PoolMng;
   import com.dchoc.game.model.dailyreward.DailyRewardMng;
   import com.dchoc.game.model.friends.VisitorMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.powerups.PowerUpMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.target.TargetDefMng;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.target.missions.MissionsMng;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.core.target.DCTargetMng;
   import com.dchoc.toolkit.core.target.DCTargetProviderInterface;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.collisionboxes.DCCollisionBoxMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.map.DCMapViewDef;
   import esparragon.utils.EUtils;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   
   public class FlowStatePlanet extends FlowState implements DCTargetProviderInterface
   {
      
      public static var smMissionsEngineEnabled:Boolean = true;
       
      
      private var mIsTutorialRunning:Boolean;
      
      private var mTutorialTimer:Number;
      
      private var mTutorialTimerOver:Boolean;
      
      private var mGUIControllerPlanet:GUIControllerPlanet;
      
      private var mMapControllerPlanet:MapControllerPlanet;
      
      private var mTutorialKidnapMng:TutorialKidnapMng;
      
      private var mTutorialPlayerIsBackFromVisiting:Boolean;
      
      private var mTutorialNeedsToFillTargets:Boolean = false;
      
      protected var mMapModel:MapModel;
      
      private var mShopController:BuildingsShopController;
      
      private var mBuildingsBufferController:BuildingsBufferController;
      
      private var mShipyardController:ShipyardController;
      
      private var mHangarControllerMng:HangarControllerMng;
      
      private var mBunkerController:BunkerController;
      
      private var mGameUnitMngController:GameUnitMngController;
      
      private var mVisitorMng:VisitorMng;
      
      private var mDailyRewardMng:DailyRewardMng;
      
      private var mBackgroundController:BackgroundController;
      
      private var mJailAnimMng:JailAnimMng;
      
      private var mNeedsToWaitForPendingTransactions:Boolean = false;
      
      private var mEventGameStartedSent:Boolean;
      
      private var mAlliancesPopupShown:Boolean;
      
      public function FlowStatePlanet()
      {
         super();
      }
      
      override protected function beginDo() : void
      {
         var userInfo:UserInfo = null;
         var tutoComplete:Boolean = false;
         var planetId:String = null;
         var planet:Planet = null;
         var starId:int = 0;
         var starName:String = null;
         var starCoord:DCCoordinate = null;
         super.beginDo();
         if(mVisitRoleId == 7)
         {
            InstanceMng.getGUIControllerPlanet().startReplay();
         }
         this.mTutorialTimerOver = true;
         var profile:Profile;
         if((profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()) != null)
         {
            userInfo = profile.getUserInfoObj();
            if(userInfo != null)
            {
               tutoComplete = userInfo.mIsTutorialCompleted.value;
               if((planet = (planetId = profile.getCurrentPlanetId()) != "-2" ? userInfo.getPlanetById(planetId) : userInfo.getCapital()) != null)
               {
                  starId = planet.getParentStarId();
                  starName = planet.getParentStarName();
                  starCoord = planet.getParentStarCoords();
                  planetId = planetId != "-2" ? planetId : userInfo.getCapital().getPlanetId();
                  InstanceMng.getApplication().goToSetCurrentDestinationInfo(planetId,userInfo,starId,starName,starCoord,planet.getSku());
                  InstanceMng.getMapViewPlanet().updateFriendsBarPathInfo();
               }
            }
         }
         this.mEventGameStartedSent = false;
         if(this.mNeedsToWaitForPendingTransactions)
         {
            InstanceMng.getApplication().lockUIWaitForPendingTransactions();
            this.setNeedsToWaitForPendingTransactions(false);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mTutorialNeedsToFillTargets)
         {
            if(InstanceMng.getTargetMng().isBuilt())
            {
               this.fillTutorialTargets();
               this.mTutorialNeedsToFillTargets = false;
            }
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         super.logicUpdateDo(dt);
         if(!this.mEventGameStartedSent)
         {
            DCDebug.traceCh("LOADING","game started");
            InstanceMng.getResourceMng().requestsNotifyEvent("requestsGameStart");
            this.mEventGameStartedSent = true;
         }
         if(this.mTutorialTimerOver == false)
         {
            this.mTutorialTimer--;
            if(this.mTutorialTimer == 0)
            {
               this.mTutorialTimerOver = true;
            }
         }
         if(this.mTutorialKidnapMng != null)
         {
            this.mTutorialKidnapMng.logicUpdate(dt);
         }
      }
      
      public function setNeedsToWaitForPendingTransactions(value:Boolean) : void
      {
         this.mNeedsToWaitForPendingTransactions = value;
      }
      
      override protected function requestResourcesDo() : void
      {
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         mapController.setMapViewDef(DCMapViewDef(InstanceMng.getMapViewDefMng().getDefBySku("iso")));
      }
      
      override public function provideData() : void
      {
         var c:DCComponent = null;
         var universeXML:XML = null;
         var battleReplay:XML = null;
         var targetsXML:XML = null;
         var happeningXML:XML = null;
         var powerUpMng:PowerUpMng = null;
         var betsXML:XML = null;
         var missionsXML:XML = null;
         DCDebug.traceCh("profile","FlowStatePlanet> provideData");
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         if(mVisitRoleId == 7)
         {
            battleReplay = userDataMng.getFileXML(UserDataMng.KEY_BATTLE_REPLAY);
            universeXML = EUtils.xmlGetChildrenListAsXML(battleReplay,"Universe");
            InstanceMng.getUnitScene().replayStart(battleReplay);
         }
         else
         {
            universeXML = userDataMng.getFileXML(UserDataMng.KEY_UNIVERSE);
            userDataMng.freeFile(UserDataMng.KEY_UNIVERSE);
         }
         var profileXML:XML = EUtils.xmlGetChildrenListAsXML(universeXML,"Profile");
         var userId:String;
         if((userId = mVisitUserId) == "0")
         {
            userId = InstanceMng.getUserDataMng().mUserAccountId;
         }
         InstanceMng.getUserInfoMng().setProfileXML(profileXML,userId);
         var uInfo:UserInfo;
         if((uInfo = InstanceMng.getUserInfoMng().getUserInfoObj(userId,0)).mIsNPC.value == false)
         {
            InstanceMng.getUserInfoMng().setupUserInfoObj(uInfo,profileXML,uInfo.getIsOwnerProfile());
         }
         c = InstanceMng.getTargetMng();
         if(!c.persistenceIsLoaded())
         {
            targetsXML = EUtils.xmlGetChildrenListAsXML(profileXML,"Targets");
            c.persistenceSetData(targetsXML);
         }
         if(Config.useHappenings())
         {
            c = InstanceMng.getHappeningMng();
            if(!c.persistenceIsLoaded())
            {
               happeningXML = EUtils.xmlGetChildrenListAsXML(profileXML,"Happenings");
               c.persistenceSetData(happeningXML);
            }
         }
         if(Config.usePowerUps())
         {
            (powerUpMng = InstanceMng.getPowerUpMng()).setPowerUpsUniverse(EUtils.xmlGetChildrenListAsXML(profileXML,"PowerUps"));
         }
         if(Config.useBets())
         {
            c = InstanceMng.getBetMng();
            if(!c.persistenceIsLoaded())
            {
               betsXML = EUtils.xmlGetChildrenListAsXML(profileXML,"Bets");
               c.persistenceSetData(betsXML);
            }
         }
         if(mTutorialDefs == null && getCurrentRoleId() == 0)
         {
            this.checkIfTutorialCompleted(profileXML);
         }
         c = InstanceMng.getMissionsMng();
         if(!c.persistenceIsLoaded())
         {
            missionsXML = EUtils.xmlGetChildrenListAsXML(profileXML,"Missions");
            c.persistenceSetData(missionsXML);
         }
         var worldXML:XML = EUtils.xmlGetChildrenListAsXML(universeXML,"World");
         InstanceMng.getWorld().itemsSetSid(EUtils.xmlReadInt(universeXML,"highestSId"));
         var itemsXML:XML = EUtils.xmlGetChildrenListAsXML(worldXML,"Items");
         InstanceMng.getWorld().persistenceSetData(itemsXML);
         var mapXML:XML = EUtils.xmlGetChildrenListAsXML(worldXML,"Map");
         InstanceMng.getMapModel().persistenceSetData(mapXML);
         var shipyardsXML:XML = EUtils.xmlGetChildrenListAsXML(worldXML,"Shipyards");
         InstanceMng.getShipyardController().persistenceSetData(shipyardsXML);
         var hangarsXML:XML = EUtils.xmlGetChildrenListAsXML(worldXML,"Hangars");
         var role:Role = InstanceMng.getRole();
         if(InstanceMng.getApplication().isTutorialCompleted() && role.mId == 3)
         {
            InstanceMng.getHangarControllerMng().persistenceSetDataVisitor(hangarsXML);
            hangarsXML = userDataMng.getFileXML(UserDataMng.KEY_HANGARS_OWNER);
            InstanceMng.getHangarControllerMng().persistenceSetDataOwner(hangarsXML,true);
         }
         else
         {
            InstanceMng.getHangarControllerMng().persistenceSetData(hangarsXML);
         }
         var bunkersXML:XML = EUtils.xmlGetChildrenListAsXML(worldXML,"Bunkers");
         InstanceMng.getBunkerController().persistenceSetData(bunkersXML);
         var gameUnitsXML:XML = EUtils.xmlGetChildrenListAsXML(worldXML,"GameUnits");
         var gameUnitMngController:GameUnitMngController;
         (gameUnitMngController = InstanceMng.getGameUnitMngController()).persistenceSetData(gameUnitsXML);
      }
      
      override protected function createGUIController() : void
      {
         var guiController:GUIControllerPlanet = InstanceMng.getGUIControllerPlanet();
         if(guiController == null)
         {
            this.mGUIControllerPlanet = new GUIControllerPlanet();
            InstanceMng.registerGUIControllerPlanet(this.mGUIControllerPlanet);
            childrenAddChild(this.mGUIControllerPlanet);
            this.mGUIControllerPlanet.setViewMng(ViewMngrGame(mViewMng));
         }
         else
         {
            InstanceMng.unregisterGUIControllerPlanet();
            InstanceMng.registerGUIControllerPlanet(this.mGUIControllerPlanet);
            this.mGUIControllerPlanet = guiController;
            this.mGUIControllerPlanet.setViewMng(ViewMngrGame(mViewMng));
            childrenAddChild(this.mGUIControllerPlanet);
         }
      }
      
      override protected function createMapController() : void
      {
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         if(mapController == null)
         {
            this.mMapControllerPlanet = new MapControllerPlanet();
            InstanceMng.registerMapControllerPlanet(this.mMapControllerPlanet);
            childrenAddChild(this.mMapControllerPlanet);
            WorldItemObject.setMapController(this.mMapControllerPlanet);
         }
         else
         {
            this.mMapControllerPlanet = mapController;
            childrenAddChild(this.mMapControllerPlanet);
         }
      }
      
      override protected function childrenCreate() : void
      {
         var collisionBoxMng:DCCollisionBoxMng = null;
         var animMng:AnimMng = null;
         super.childrenCreate();
         var collBoxMng:CollisionBoxMng = InstanceMng.getCollisionBoxMng();
         if(collBoxMng == null)
         {
            collisionBoxMng = new CollisionBoxMng();
            collisionBoxMng.build();
            InstanceMng.registerCollisionBoxMng(collisionBoxMng);
         }
         var animationMng:AnimMng;
         if((animationMng = InstanceMng.getAnimMng()) == null)
         {
            animMng = new AnimMng();
            InstanceMng.registerAnimMng(animMng);
            childrenAddChild(animMng);
            WorldItemObject.setAnimMng(animMng);
         }
         else
         {
            childrenAddChild(animationMng);
         }
         var mapModel:MapModel = InstanceMng.getMapModel();
         if(mapModel == null)
         {
            this.mMapModel = new MapModel();
            InstanceMng.registerMapModel(this.mMapModel);
            childrenAddChild(this.mMapModel);
         }
         else
         {
            this.mMapModel = mapModel;
            childrenAddChild(this.mMapModel);
         }
         InstanceMng.registerWorld(new World());
         childrenAddChild(InstanceMng.getWorld());
         WorldItemObject.setViewMng(ViewMngPlanet(mViewMng));
         var mapView:MapViewPlanet;
         (mapView = InstanceMng.getMapViewPlanet()).setViewMng(ViewMngrGame(mViewMng));
         mapView.setMapController(this.mMapControllerPlanet);
         this.mMapControllerPlanet.setMapModel(this.mMapModel);
         this.mMapControllerPlanet.setMapView(mapView);
         var toolsMng:ToolsMng;
         (toolsMng = new ToolsMng()).setMapController(this.mMapControllerPlanet);
         InstanceMng.registerToolsMng(toolsMng);
         childrenAddChild(toolsMng);
         var wioController:WorldItemObjectController = new WorldItemObjectController();
         InstanceMng.registerWorldItemObjectController(wioController);
         childrenAddChild(wioController);
         WorldItemObject.setWorldItemObjectController(wioController);
         var poolMng:PoolMng = new PoolMng();
         InstanceMng.registerPoolMng(poolMng);
         childrenAddChild(poolMng);
         WorldItemObject.setPoolMng(poolMng);
         this.mShopController = new BuildingsShopController();
         this.mBuildingsBufferController = new BuildingsBufferController();
         this.mShipyardController = new ShipyardController();
         this.mHangarControllerMng = new HangarControllerMng();
         this.mBunkerController = new BunkerController();
         this.mGameUnitMngController = new GameUnitMngController();
         this.mVisitorMng = new VisitorMng();
         this.mDailyRewardMng = new DailyRewardMng();
         this.mJailAnimMng = new JailAnimMng();
         this.mBackgroundController = new BackgroundController();
         InstanceMng.registerBuildingsShopController(this.mShopController);
         InstanceMng.registerBuildingsBufferController(this.mBuildingsBufferController);
         InstanceMng.registerShipyardController(this.mShipyardController);
         InstanceMng.registerHangarControllerMng(this.mHangarControllerMng);
         InstanceMng.registerBunkerController(this.mBunkerController);
         InstanceMng.registerGameUnitMngController(this.mGameUnitMngController);
         InstanceMng.registerVisitorMng(this.mVisitorMng);
         InstanceMng.registerDailyRewardMng(this.mDailyRewardMng);
         InstanceMng.registerJailAnimMng(this.mJailAnimMng);
         InstanceMng.registerBackgroundController(this.mBackgroundController);
         childrenAddChild(this.mShopController);
         childrenAddChild(this.mBuildingsBufferController);
         childrenAddChild(this.mShipyardController);
         childrenAddChild(this.mHangarControllerMng);
         childrenAddChild(this.mBunkerController);
         childrenAddChild(this.mGameUnitMngController);
         childrenAddChild(this.mVisitorMng);
         childrenAddChild(this.mJailAnimMng);
         childrenAddChild(this.mBackgroundController);
      }
      
      override public function unbuildMode(mode:int) : void
      {
         var child:DCComponent = null;
         for each(child in mChildren)
         {
            child.unbuildMode(mode);
         }
      }
      
      override protected function childrenUnbuildMode(mode:int) : void
      {
         var uInfo:UserInfo = null;
         var roleId:int = InstanceMng.getApplication().goToGetRequestRoleId();
         var currentRoleId:int = InstanceMng.getFlowState().getCurrentRoleId();
         InstanceMng.getWorld().unbuild(mode);
         this.mGUIControllerPlanet.unbuild(mode);
         var currProfileLoaded:Profile;
         if((currProfileLoaded = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()) != null)
         {
            uInfo = currProfileLoaded.getUserInfoObj();
            if(uInfo != null)
            {
               InstanceMng.getUserInfoMng().unBuildNPCList();
            }
         }
         if(Config.useUmbrella())
         {
            InstanceMng.getUmbrellaMng().unbuild(mode);
         }
         super.childrenUnbuildMode(mode);
      }
      
      override protected function viewMngCreate() : void
      {
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         if(viewMng == null)
         {
            mViewMng = new ViewMngPlanet();
            InstanceMng.registerViewMngPlanet(ViewMngPlanet(mViewMng));
         }
         else
         {
            mViewMng = viewMng;
         }
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         var tool:Tool = null;
         var playerInfo:UserInfo = null;
         var o:Object = null;
         var objectMb:Object = null;
         var arr:Array = null;
         var wave:String = null;
         var deployAreas:Array = null;
         var shape:Sprite = null;
         var viewMng:ViewMngPlanet = null;
         var corners:Vector.<Number> = null;
         var digitCode:int = 0;
         var i:int = 0;
         var rect:Array = null;
         if(this.mAlliancesPopupShown)
         {
            return;
         }
         var found:Boolean = false;
         if(Config.DEBUG_MODE)
         {
            if((tool = InstanceMng.getToolsMng().getCurrentTool()) != null)
            {
               tool.onKeyDown(e);
               if(tool.isBlockingKeys())
               {
                  return;
               }
            }
         }
         switch(e.keyCode)
         {
            case 40:
               InstanceMng.getWorld().mStartedRepairs = true;
               found = true;
               break;
            case 37:
               InstanceMng.getTrafficMng().notify({"cmd":"battleEventHasStarted"});
               found = true;
               break;
            case 39:
               InstanceMng.getTrafficMng().notify({"cmd":"battleEventHasFinished"});
               found = true;
               break;
            case 112:
               o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_MODIFY_CURRENT_DROID_TASK");
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o);
               break;
            case 114:
               found = true;
               break;
            case 115:
               DCDebug.traceObject(Star.flashVars,"flashVars: ");
               (objectMb = {}).cmd = "mobilePricePoints";
               arr = [];
               arr.push({
                  "credits":9,
                  "local_currency":"EUR",
                  "sku":"mobile0",
                  "user_price":"1.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":19,
                  "local_currency":"EUR",
                  "sku":"mobile1",
                  "user_price":"2.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":29,
                  "local_currency":"EUR",
                  "sku":"mobile2",
                  "user_price":"3.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":49,
                  "local_currency":"EUR",
                  "sku":"mobile4",
                  "user_price":"5.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":39,
                  "local_currency":"EUR",
                  "sku":"mobile3",
                  "user_price":"4.82",
                  "items":"10:2"
               });
               objectMb.mobile = arr;
               Application.externalNotification(4,objectMb);
               break;
            case 117:
               wave = "8:warSmallShips_001_001";
               InstanceMng.getUnitScene().wavesCreateReturnedArmyWave(wave,700,1000);
               InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addMineralCapacityAmount(150);
               found = true;
               break;
            case 118:
               InstanceMng.getUserDataMng().getAdsManager().adsReady(true,"");
               break;
            case 119:
               InstanceMng.getUserDataMng().getAdsManager().videoCompleted("2");
               break;
            case 107:
               this.skipCurrentTutorialStep();
               found = true;
               break;
            case 71:
               InstanceMng.getMapViewPlanet().tilesetToggleVisibility();
               found = true;
               break;
            case 72:
               InstanceMng.getToolsMng().setTool(0);
               found = true;
               break;
            case 77:
               InstanceMng.getToolsMng().setTool(13);
               found = true;
               break;
            case 78:
               if(getCurrentRoleId() == 4)
               {
                  InstanceMng.getToolsMng().setTool(3);
               }
               found = true;
               break;
            case 82:
               InstanceMng.getUserDataMng().browserRefresh();
               break;
            case 83:
               if(Config.OFFLINE_GAMEPLAY_MODE)
               {
                  saveUniverse("universe.xml");
               }
               found = true;
               break;
            case 84:
               InstanceMng.getMapViewPlanet().tilesetToggleVisibility();
               InstanceMng.getToolsMng().setTool(13);
               deployAreas = InstanceMng.getMapModel().getDeployAreas();
               shape = InstanceMng.getUnitScene().debugGetSprite(this,"deployAreas");
               viewMng = InstanceMng.getViewMngPlanet();
               corners = new Vector.<Number>(8);
               for(i = 0; i < deployAreas.length; )
               {
                  rect = deployAreas[i];
                  viewMng.areaToWorldViewPos(rect[0],rect[1],rect[2] - rect[0],Math.abs(rect[3] - rect[1]),corners);
                  DCUtils.drawShape(shape.graphics,corners,16777215,i == 0,true,true,0.5,5);
                  i++;
               }
               if(UnitScene.DEBUG_ENABLED)
               {
                  InstanceMng.getUnitScene().debugToggleVisibility();
               }
               found = true;
               break;
            case 85:
               InstanceMng.getToolsMng().setTool(12);
               found = true;
               break;
            case 86:
               found = true;
               break;
            case 87:
               break;
            case 88:
               found = true;
               break;
            case 90:
               found = true;
               break;
            default:
               if((digitCode = e.keyCode - 49) >= 0 && digitCode <= 9)
               {
                  getCurrentRole().toolSetCursorSize(digitCode + 1);
                  InstanceMng.getToolsMng().resetCurrentTool();
               }
         }
         if(found == false)
         {
            super.onKeyDown(e);
         }
      }
      
      public function visitReturnToOwnWorld() : void
      {
         this.setPlayerIsBackFromVisiting(true);
         var uInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         var planetId:String = uInfo.getCapital().getPlanetId();
         InstanceMng.getApplication().requestPlanet(InstanceMng.getUserDataMng().mUserAccountId,planetId,0);
      }
      
      public function visitReturnToOwnCurrentPlanet() : void
      {
         var planetId:String = null;
         this.setPlayerIsBackFromVisiting(true);
         var p:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(p)
         {
            planetId = p.getCurrentPlanetId();
            InstanceMng.getApplication().requestPlanet(InstanceMng.getUserDataMng().mUserAccountId,planetId,0);
         }
      }
      
      override protected function checkIfTutorialCompleted(profileXML:XML) : void
      {
         var key:String = "tutorialCompleted";
         var attribute:XMLList = profileXML.attribute(key);
         var complete:* = false;
         if(attribute.length() > 0)
         {
            complete = int(attribute[0]) != 0;
         }
         if(!complete)
         {
            this.startTutorial();
         }
      }
      
      public function isFirstTargetDone() : Boolean
      {
         var target:DCTarget = InstanceMng.getTargetMng().getTargetById("tutorial_prestep_0");
         if(target != null)
         {
            return target.isDone();
         }
         return true;
      }
      
      public function startTutorial() : void
      {
         this.mTutorialNeedsToFillTargets = true;
         changeRole(5);
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         resourceMng.requestResource("orange_normal");
         resourceMng.requestResource("orange_happy");
         resourceMng.requestResource("orange_worried");
         resourceMng.requestResource("firebit_normal");
         resourceMng.requestResource("captain_normal");
         resourceMng.requestResource("captain_happy");
         resourceMng.requestResource("captain_worried");
         resourceMng.requestResource("elderby_normal");
         resourceMng.requestResource("builder_worried");
      }
      
      public function finishTutorial() : void
      {
         var transaction:Transaction = null;
         var friends:Vector.<UserInfo> = null;
         InstanceMng.getUserInfoMng().getProfileLogin().setTutorialCompleted(true);
         this.setTutorialRunning(false);
         DCDebug.trace("FINISHING TUTORIAL");
         InstanceMng.getUserDataMng().updateProfile_tutorialCompleted();
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(Config.useInvests() && profile.hasAnInvestorValid())
         {
            transaction = InstanceMng.getRuleMng().createTransactionAcceptInvest();
            InstanceMng.getInvestMng().guiOpenInvestRewardTutorialPopup(profile.getInvestorAccountId(),transaction);
            InstanceMng.getUserDataMng().updateInvest_accept(transaction);
         }
         else if(InstanceMng.getSettingsDefMng().getShowPopupInviteAfterTutorial() > 0)
         {
            friends = InstanceMng.getUserInfoMng().getFriendsFromList(InstanceMng.getUserInfoMng().getNoPlayerFriendsList(),4);
            if(friends != null && friends.length > 0)
            {
               this.openIdlePopupAfterTutorial();
            }
            else
            {
               this.postFinishTutorial();
            }
         }
         else
         {
            this.postFinishTutorial();
         }
      }
      
      public function postFinishTutorial() : void
      {
         changeRole(0);
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         InstanceMng.getMapControllerPlanet().setIsScrollAllowed(true);
         uiFacade.navigationPanelBuild();
         var missionsMng:MissionsMng = InstanceMng.getMissionsMng();
         if(missionsMng != null && smMissionsEngineEnabled == true)
         {
            missionsMng.loadFromXML();
         }
         InstanceMng.getWorld().mStartedRepairs = true;
         InstanceMng.getApplication().funnelSetIsEnabled(true);
         InstanceMng.getMissionsMng().showBackMissionsInHud();
      }
      
      public function openIdlePopupAfterTutorial() : void
      {
         var o:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyAFKPopup");
         o.idleType = "PopupAfkTypeTutorial";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
      }
      
      private function fillTutorialTargets() : void
      {
         var tutorialDef:DCTargetDef = null;
         var targetDefMng:TargetDefMng = InstanceMng.getTargetDefMng();
         var targetMng:DCTargetMng = InstanceMng.getTargetMng();
         mTutorialDefs = targetDefMng.getTutorialDefs();
         var state_locked:int = 0;
         for each(tutorialDef in mTutorialDefs)
         {
            targetMng.addTarget(new DCTarget(tutorialDef,state_locked,this),state_locked);
         }
         this.mIsTutorialRunning = true;
      }
      
      private function skipCurrentTutorialStep() : void
      {
         var target:DCTarget = null;
         var allTargets:Array = InstanceMng.getTargetMng().getAllTargets();
         for each(target in allTargets)
         {
            if(target.State == 2 && this.mIsTutorialRunning == true)
            {
               target.changeState(target.State + 1);
            }
         }
      }
      
      public function isTutorialTimerOver() : Boolean
      {
         return this.mTutorialTimerOver;
      }
      
      public function setTutorialTimerTime(time:Number) : void
      {
         this.mTutorialTimer = DCTimerUtil.secondToMs(time) / 10;
         this.mTutorialTimerOver = false;
      }
      
      public function setTutorialRunning(isRunning:Boolean) : void
      {
         this.mIsTutorialRunning = isRunning;
         if(isRunning == false)
         {
            InstanceMng.getMapControllerPlanet().enableTooltips();
         }
      }
      
      public function isTutorialRunning() : Boolean
      {
         return this.mIsTutorialRunning;
      }
      
      public function isPlayerIsBackFromVisiting() : Boolean
      {
         return this.mTutorialPlayerIsBackFromVisiting;
      }
      
      public function setPlayerIsBackFromVisiting(isBack:Boolean) : void
      {
         this.mTutorialPlayerIsBackFromVisiting = isBack;
      }
      
      public function isPlayerAttackingInTutorial() : Boolean
      {
         var userInfoMng:UserInfoMng = null;
         var returnValue:* = false;
         if(InstanceMng.getRole().mId == 5)
         {
            userInfoMng = InstanceMng.getUserInfoMng();
            returnValue = userInfoMng.getProfileLogin() != userInfoMng.getCurrentProfileLoaded();
         }
         return returnValue;
      }
      
      public function isPlayerInHerCityInTutorial() : Boolean
      {
         var returnValue:* = false;
         if(InstanceMng.getRole().mId == 5)
         {
            returnValue = !this.isPlayerAttackingInTutorial();
         }
         return returnValue;
      }
      
      public function createTutorialKidnapMng() : void
      {
         if(this.mTutorialKidnapMng == null)
         {
            this.mTutorialKidnapMng = new TutorialKidnapMng();
            InstanceMng.registerTutorialKidnapMng(this.mTutorialKidnapMng);
         }
      }
      
      public function destroyTutorialKidnapMng() : void
      {
         if(this.mTutorialKidnapMng != null)
         {
            InstanceMng.unregisterTutorialKidnapMng();
            this.mTutorialKidnapMng.unload();
            this.mTutorialKidnapMng = null;
         }
      }
      
      override public function isThisStateUseful(state:int) : Boolean
      {
         return state != 1;
      }
      
      public function isPossibleCalculateTotalScoreAttack() : Boolean
      {
         return InstanceMng.getWorld().isBuilt() && InstanceMng.getBunkerController().isBuilt();
      }
      
      public function getTotalScoreAttack() : Number
      {
         return InstanceMng.getWorld().getBuildingsScoreAttack() + InstanceMng.getBunkerController().getUnitsScoreAttack();
      }
      
      public function getTotalScoreAttackWithDestroyed() : Number
      {
         return InstanceMng.getWorld().getBuildingsScoreAttackWithDestroyed();
      }
   }
}
