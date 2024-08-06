package com.dchoc.game.model.flow
{
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.controller.role.RoleAttacking;
   import com.dchoc.game.controller.role.RoleEditor;
   import com.dchoc.game.controller.role.RoleSpy;
   import com.dchoc.game.controller.role.RoleTutorial;
   import com.dchoc.game.controller.role.RoleVisitor;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.model.unit.FireWorksMng;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.utils.CheatConsole;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngSpace;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.flow.DCFlowState;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.target.DCTargetProviderInterface;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class FlowState extends DCFlowState implements DCTargetProviderInterface
   {
      
      public static var mBmpDataLoading:BitmapData;
      
      public static var mBitmap:Bitmap;
      
      private static const UNIT_STATE_CREATE:int = 0;
      
      private static const UNIT_STATE_GIVE_PATH:int = 1;
      
      private static const UNIT_STATE_STOP:int = 2;
      
      public static var mVisitTransaction:Transaction;
       
      
      protected var mGUIControllerRef:GUIController;
      
      protected var mAttack:Function;
      
      protected var mAttackDoAttack:Boolean;
      
      protected var mAttackedUser:UserInfo;
      
      protected var mAttackType:int;
      
      protected var mTutorialDefs:Vector.<DCDef>;
      
      private var mIdleTimer:SecureInt;
      
      private var mDCBitmap:DCDisplayObject;
      
      private var mGamePaused:Boolean = false;
      
      private var mRolesList:Vector.<Role>;
      
      private var mCurrentRoleId:SecureInt;
      
      public var mVisitUserId:String = "0";
      
      private var mVisitPlanetId:String = "0";
      
      private var mVisitPlanetSku:String = "";
      
      protected var mVisitRoleId:int = 0;
      
      public function FlowState()
      {
         mIdleTimer = new SecureInt("FlowState.mIdleTimer");
         super();
      }
      
      public static function unloadStatic() : void
      {
         mBmpDataLoading = null;
         mBitmap = null;
         mVisitTransaction = null;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mIsAutomaticBegin = false;
         this.loadRoles();
      }
      
      override protected function unloadDo() : void
      {
         InstanceMng.getApplication().lockUIUnload();
      }
      
      override protected function beginDo() : void
      {
         var role:Role = null;
         var music:String = null;
         super.beginDo();
         if(Config.USE_SOUNDS)
         {
            role = InstanceMng.getRole();
            if(role.mId == 3 || role.mId == 7)
            {
               music = InstanceMng.getUnitScene().battleGetMusic();
               if(SoundManager.getInstance().getLastMusic() != music)
               {
                  SoundManager.getInstance().stopAll();
               }
               SoundManager.getInstance().playSound(music,1,0,-1,0);
            }
            else if(InstanceMng.getApplication().viewGetMode() == 0)
            {
               if(SoundManager.getInstance().getLastMusic() != "music_main.mp3")
               {
                  SoundManager.getInstance().stopAll();
               }
               SoundManager.getInstance().playSound("music_main.mp3",1,0,-1,0);
            }
            else
            {
               if(SoundManager.getInstance().getLastMusic() != "music_map.mp3")
               {
                  SoundManager.getInstance().stopAll();
               }
               SoundManager.getInstance().playSound("music_map.mp3",1,0,-1,0);
            }
         }
         InstanceMng.getApplication().lockUIReset();
         InstanceMng.getApplication().stageGetStage().getImplementation().addEventListener("mouseDown",this.resetIdleTimer);
         this.mIdleTimer.value = 0;
      }
      
      override protected function endDo() : void
      {
         var music:String = null;
         super.endDo();
         if(Config.USE_SOUNDS)
         {
            music = InstanceMng.getUnitScene().battleGetMusic();
            if(InstanceMng.getRole().mId == 3 || SoundManager.getInstance().isSoundPlaying(music) && InstanceMng.getRole().mId != 3)
            {
               SoundManager.getInstance().stopAll();
            }
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         this.checkifPlayerOnline(dt);
      }
      
      public function setFreezedImage(takeScreenshot:Boolean) : void
      {
         var viewMng:ViewMngrGame = null;
         var layerId:int = 0;
         var bmp:BitmapData = null;
         var sp:Sprite = null;
         var bitmap:Bitmap = null;
         var shp:Shape = null;
         if(this.mDCBitmap == null && takeScreenshot)
         {
            viewMng = InstanceMng.getViewMngGame();
            if(viewMng is ViewMngPlanet)
            {
               layerId = viewMng.getLayerIdFromSku(viewMng.getParticlesLayerSku());
               bmp = viewMng.takeScreenShot(layerId);
            }
            else
            {
               layerId = 1;
               bmp = ViewMngSpace(viewMng).takeScreenShot(layerId);
            }
            sp = new Sprite();
            (bitmap = new Bitmap(bmp)).name = "bitmap";
            sp.addChild(bitmap);
            (shp = new Shape()).graphics.beginFill(0,0.5);
            shp.graphics.drawRect(0,0,bitmap.width,bitmap.height);
            shp.graphics.endFill();
            sp.addChild(shp);
            shp.name = "shape";
            this.mDCBitmap = new DCDisplayObjectSWF(sp);
            InstanceMng.getViewMngGame().addPopup(this.mDCBitmap);
         }
         InstanceMng.getGUIController().lockGUI();
      }
      
      public function removeFreezedImage() : void
      {
         var sp:Sprite = null;
         var bitmap:Bitmap = null;
         var shp:Shape = null;
         if(this.mDCBitmap != null)
         {
            InstanceMng.getViewMngGame().removePopup(this.mDCBitmap);
            sp = this.mDCBitmap.getDisplayObject() as Sprite;
            bitmap = sp.getChildByName("bitmap") as Bitmap;
            shp = sp.getChildByName("shape") as Shape;
            sp.removeChild(bitmap);
            sp.removeChild(shp);
            if(bitmap != null)
            {
               if(bitmap.bitmapData != null)
               {
                  bitmap.bitmapData.dispose();
               }
               bitmap = null;
            }
            if(shp != null)
            {
               shp = null;
            }
            sp = null;
            this.mDCBitmap = null;
         }
         if(InstanceMng.getApplication().isTutorialCompleted())
         {
            InstanceMng.getGUIController().unlockGUI();
         }
      }
      
      protected function checkifPlayerOnline(dt:int) : void
      {
         var role:Role = null;
         var hud:TopHudFacade = null;
         var goHud:Boolean = false;
         var currRoleId:int = 0;
         var isTutorial:* = false;
         var isAlreadyShown:Boolean = false;
         if(InstanceMng.getSettingsDefMng().isBuilt())
         {
            role = InstanceMng.getRole();
            goHud = (hud = InstanceMng.getTopHudFacade()) != null && !hud.cheatsTimeIsEnabled();
            if(goHud && role != null && !InstanceMng.getFlowStatePlanet().isTutorialRunning())
            {
               isTutorial = (currRoleId = InstanceMng.getFlowStatePlanet().getCurrentRoleId()) == 5;
               isAlreadyShown = InstanceMng.getApplication().idleHasBeenToldToOpen();
               this.mIdleTimer.value += dt;
               if(this.mIdleTimer.value > InstanceMng.getSettingsDefMng().mSettingsDef.getIdleTime() && !isAlreadyShown && !isTutorial && InstanceMng.getUserDataMng().isLogged())
               {
                  this.showIdlePopup();
               }
               else if(isAlreadyShown)
               {
                  this.mIdleTimer.value = 0;
               }
            }
         }
      }
      
      public function showIdlePopup() : void
      {
         if(!Config.OFFLINE_GAMEPLAY_MODE)
         {
            this.setFreezedImage(true);
         }
         var o:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyAFKPopup");
         o.msg = DCTextMng.getText(355);
         o.title = DCTextMng.getText(356);
         o.tutoPopupButtn = 2903;
         o.idleType = "PopupAfkTypeIdle";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
         this.mIdleTimer.value = 0;
         if(InstanceMng.getSettingsDefMng().mSettingsDef.getShowCrossPromoPopup() == 1)
         {
            InstanceMng.getUserDataMng().notifyShowCrossPromotion();
         }
         SoundManager.getInstance().muteOn();
      }
      
      private function resetIdleTimer(mouseEvent:MouseEvent) : void
      {
         this.mIdleTimer.value = 0;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         InstanceMng.getCollisionBoxMng().logicUpdate(dt);
         FireWorksMng.getInstance().logicUpdate(dt);
      }
      
      override protected function viewMngCreate() : void
      {
         var viewMng:ViewMngrGame = InstanceMng.getViewMngSpace();
         if(viewMng == null)
         {
            mViewMng = new ViewMngSpace();
            InstanceMng.registerViewMngSpace(ViewMngSpace(mViewMng));
         }
         else
         {
            mViewMng = viewMng;
         }
      }
      
      protected function createGUIController() : void
      {
         var guiController:GUIController = InstanceMng.getGUIController();
         if(guiController == null)
         {
            this.mGUIControllerRef = new GUIController();
            InstanceMng.registerGUIController(this.mGUIControllerRef);
            this.mGUIControllerRef.setViewMng(ViewMngrGame(mViewMng));
         }
         else
         {
            this.mGUIControllerRef = guiController;
            this.mGUIControllerRef.setViewMng(ViewMngrGame(mViewMng));
         }
      }
      
      protected function createMapController() : void
      {
      }
      
      override protected function childrenCreate() : void
      {
         this.createMapController();
         if(!mChildrensCreated)
         {
            super.childrenCreate();
         }
         this.createGUIController();
      }
      
      override protected function unbuildDo() : void
      {
         ParticleMng.removeAllActiveParticles();
      }
      
      override public function unbuild(mode:int = 0) : void
      {
         super.unbuild(InstanceMng.getApplication().mFlowStateUnbuildMode);
      }
      
      override protected function childrenUnbuildMode(mode:int) : void
      {
         InstanceMng.getMapModel().unbuild(mode);
         InstanceMng.getMapControllerPlanet().unbuild(mode);
         if(mode == 1)
         {
            InstanceMng.getUserInfoMng().getProfileLogin().unbuild(mode);
         }
         super.childrenUnbuildMode(mode);
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         var obj:Object = null;
         super.onKeyDown(e);
         if(Config.DEBUG_MODE)
         {
            switch(e.keyCode)
            {
               case 118:
                  InstanceMng.getWorldItemObjectController().collectAllCollectableItems();
                  break;
               case 119:
                  InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addCash(234);
                  break;
               case 120:
                  InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addMinerals(1100);
                  InstanceMng.getUnitScene();
                  break;
               case 187:
                  if(Config.DEBUG_SCREEN)
                  {
                     ViewMngrGame(mViewMng).cameraAddSize(10,10);
                  }
                  break;
               case 189:
                  if(Config.DEBUG_SCREEN)
                  {
                     ViewMngrGame(mViewMng).cameraAddSize(-10,-10);
                  }
                  break;
               case 65:
                  this.mGamePaused = !this.mGamePaused;
                  if(this.mGamePaused)
                  {
                     InstanceMng.getApplication().pauseGame();
                  }
                  else
                  {
                     InstanceMng.getApplication().resumeGame();
                  }
                  break;
               case 66:
                  obj = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyAttackToNPCResult");
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),obj);
                  break;
               case 67:
                  CheatConsole.toggle();
                  break;
               case 68:
                  if(UnitScene.DEBUG_ENABLED)
                  {
                     InstanceMng.getUnitScene().debugToggleVisibility();
                  }
                  break;
               case 69:
                  this.changeRole(4);
                  break;
               case 70:
                  InstanceMng.getApplication().toggleFullScreen();
                  break;
               case 73:
                  InstanceMng.getMissionsMng().hideTemporarilyMissionsInHud();
                  break;
               case 74:
                  InstanceMng.getMissionsMng().showBackMissionsInHud();
                  break;
               case 75:
                  InstanceMng.getMissionsMng().setMissionDropDelay(2000);
                  break;
               case 76:
                  InstanceMng.getWorldItemObjectController().collectAllCollectableItems();
                  break;
               case 77:
                  break;
               case 79:
                  this.changeRole(0);
                  break;
               case 81:
                  InstanceMng.getResourceMng().profilingPrintDownloadedAmount();
                  break;
               case 48:
                  InstanceMng.getUserInfoMng().removeNeighbor("7");
                  break;
               case 122:
                  InstanceMng.getMapModel().createObstacles(100,true);
                  break;
               case 123:
                  InstanceMng.getMapModel().removeObstaclesFromScene();
                  break;
               case 88:
                  InstanceMng.getGUIController().onZoomMove(-0.25);
                  break;
               case 89:
                  Application.externalNotification(4,{
                     "cmd":"msgCenterReceiveGift",
                     "sku":"1"
                  });
                  break;
               case 188:
                  InstanceMng.getGUIController().onZoomMove(0.25);
                  break;
               case 190:
                  Application.externalNotification(4,{
                     "cmd":"visit",
                     "accountId":"2"
                  });
            }
         }
         InstanceMng.getGUIController().onKeyDown(e);
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         super.onResize(stageWidth,stageHeight);
         InstanceMng.getGUIController().onResize(stageWidth,stageHeight);
      }
      
      override public function onMouseDown(e:MouseEvent) : void
      {
         InstanceMng.getGUIController().onMouseDown(e);
      }
      
      override public function onMouseUp(e:MouseEvent) : void
      {
         InstanceMng.getGUIController().onMouseUp(e);
      }
      
      override public function onMouseWheel(e:MouseEvent) : void
      {
         InstanceMng.getGUIController().onMouseWheel(e);
      }
      
      public function loadRoles() : void
      {
         this.mCurrentRoleId = new SecureInt();
         this.mRolesList = new Vector.<Role>(Role.ROLE_COUNT);
         this.mRolesList[0] = new Role(0);
         this.mRolesList[1] = new RoleVisitor();
         this.mRolesList[2] = new RoleSpy();
         this.mRolesList[3] = new RoleAttacking();
         this.mRolesList[4] = new RoleEditor();
         this.mRolesList[5] = new RoleTutorial();
         this.mRolesList[6] = new Role(6);
         this.mRolesList[7] = new Role(7);
         this.changeRole(0);
         this.printRoles();
      }
      
      public function changeRole(roleId:int) : void
      {
         var factionMode:int = 0;
         if(this.findRole(roleId) == true)
         {
            if(Config.DEBUG_MODE)
            {
               DCDebug.trace("role changed from " + Role.ROLE_NAMES[this.getCurrentRoleId()] + " to " + Role.ROLE_NAMES[roleId]);
            }
            this.mCurrentRoleId.value = roleId;
            InstanceMng.registerRole(this.mRolesList[this.getCurrentRoleId()]);
            factionMode = 0;
            switch(this.getCurrentRoleId() - 1)
            {
               case 0:
               case 1:
               case 2:
                  factionMode = 1;
            }
            GameConstants.unitsSetFactionMode(factionMode);
            if(InstanceMng.getToolsMng() != null && Config.DEBUG_MODE)
            {
               InstanceMng.getToolsMng().resetCurrentTool(true);
            }
         }
      }
      
      public function findRole(role:int) : Boolean
      {
         var value:int = 0;
         for each(value in Role.ROLE_LIST)
         {
            if(value == role)
            {
               return true;
            }
         }
         return false;
      }
      
      public function printRoles() : void
      {
         var role:int = 0;
         DCDebug.trace("***-------------***");
         DCDebug.trace("***----ROLES----***");
         for each(role in Role.ROLE_LIST)
         {
            DCDebug.trace("Role:" + Role.ROLE_LIST[role] + "->" + Role.ROLE_NAMES[role]);
         }
         DCDebug.trace("**-END OF ROLES-***");
         DCDebug.trace("***-------------***");
      }
      
      public function getCurrentRole() : Role
      {
         return this.mRolesList[this.getCurrentRoleId()];
      }
      
      public function getCurrentRoleId() : int
      {
         return this.mCurrentRoleId.value;
      }
      
      public function isCurrentRoleOwner() : Boolean
      {
         return this.getCurrentRoleId() == 0;
      }
      
      public function isThisStateUseful(state:int) : Boolean
      {
         return state != 1;
      }
      
      protected function checkIfTutorialCompleted(profileXML:XML) : void
      {
      }
      
      public function visitAskUniverse() : void
      {
         var user:UserInfo = null;
         var revengeId:String = null;
         var obj:Object = {};
         if(this.mVisitRoleId == 7)
         {
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_BATTLE_REPLAY,obj);
         }
         else
         {
            if(InstanceMng.getUserInfoMng().isThisSkuFromNPC(this.mVisitUserId))
            {
               obj.advisorSku = this.mVisitUserId;
            }
            else
            {
               obj.userId = this.mVisitUserId;
            }
            obj.attack = this.mVisitRoleId == 3 ? "1" : "0";
            if(InstanceMng.getApplication().goToGetIsQuickAttack())
            {
               obj.quickAttack = "1";
            }
            if(InstanceMng.getApplication().goToGetAttackMode() == 2)
            {
               obj.betAttack = "1";
            }
            obj.planetId = this.mVisitPlanetId;
            user = InstanceMng.getUserInfoMng().getUserInfoObj(this.mVisitUserId,0);
            revengeId = null;
            if(this.mVisitRoleId == 3)
            {
               revengeId = InstanceMng.getUserInfoMng().getRevengeAvailable(user);
            }
            if(revengeId != null)
            {
               obj.revengeAttackId = revengeId;
               InstanceMng.getUserInfoMng().lastAttackersPerformRevenge(user,revengeId);
            }
            if(obj.userId != InstanceMng.getUserInfoMng().getProfileLogin().getAccountId())
            {
               obj.planetX = 0;
               obj.planetY = 0;
               obj.planetSku = this.mVisitPlanetSku;
            }
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_UNIVERSE,obj,mVisitTransaction);
            if(InstanceMng.getApplication().isTutorialCompleted() && this.mVisitRoleId == 3)
            {
               InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_HANGARS_OWNER);
            }
            mVisitTransaction = null;
         }
      }
      
      public function visitFriendWorld(userId:String, roleId:int, planetId:String = "0", planetSku:String = "") : void
      {
         InstanceMng.getUserDataMng().flushUniverse();
         var newStateId:int = 1;
         if(roleId == 3)
         {
            newStateId = 2;
         }
         else if(roleId == 2)
         {
            newStateId = 8;
         }
         else if(roleId == 0)
         {
            newStateId = 9;
         }
         this.changeRole(roleId);
         this.mVisitUserId = userId;
         this.mVisitPlanetId = planetId;
         this.mVisitPlanetSku = planetSku;
         this.mVisitRoleId = roleId;
         var planetBelongsToUser:*;
         if(planetBelongsToUser = userId == InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getAccountId())
         {
            InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().setLastOwnerPlanetVisited(planetId);
         }
         InstanceMng.getUserInfoMng().unbuildProfileVisiting();
         InstanceMng.getApplication().fsmChangeState(newStateId);
      }
      
      public function getUniversePersistence() : XML
      {
         var universeXml:XML = <Universe/>;
         var profileXml:XML = InstanceMng.getUserInfoMng().getProfileLogin().persistenceGetData();
         var worldXml:XML = InstanceMng.getWorld().persistenceGetData();
         var mapXml:XML = InstanceMng.getMapModel().persistenceGetData();
         var missionsXML:XML = InstanceMng.getMissionsMng().persistenceGetData();
         var targetsXML:XML = InstanceMng.getTargetMng().persistenceGetTargetsData();
         var timedTargetsXML:XML = InstanceMng.getTargetMng().persistenceGetTimedTargetsData();
         var shipyardsXML:XML = InstanceMng.getShipyardController().persistenceGetData();
         var hangarsXML:XML = InstanceMng.getHangarControllerMng().persistenceGetData();
         var bunkersXML:XML = InstanceMng.getBunkerController().persistenceGetData();
         var gameUnitsXML:XML = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().persistenceGetData();
         worldXml.appendChild(mapXml);
         worldXml.appendChild(shipyardsXML);
         worldXml.appendChild(hangarsXML);
         worldXml.appendChild(bunkersXML);
         worldXml.appendChild(gameUnitsXML);
         profileXml.appendChild(targetsXML);
         profileXml.appendChild(missionsXML);
         missionsXML.appendChild(timedTargetsXML);
         universeXml.appendChild(profileXml);
         universeXml.appendChild(worldXml);
         return universeXml;
      }
      
      public function saveUniverse(fileName:String) : void
      {
         var universeXml:XML = this.getUniversePersistence();
         InstanceMng.getUserDataMng().saveUniverse(universeXml,fileName);
      }
      
      public function solarSystemAskWindow(coordX:int, coordY:int, starId:Number) : void
      {
         var obj:Object;
         (obj = {}).coordX = coordX;
         obj.coordY = coordY;
         obj.coords = new DCCoordinate(coordX,coordY);
         obj.starId = starId;
         if(!isNaN(starId))
         {
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_STAR_PLANETS_WINDOW,obj);
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_BOOKMARKS);
         }
      }
      
      public function takeScreenShot() : void
      {
         var viewMng:ViewMngrGame = ViewMngrGame(viewMngGet());
         var layerId:int = viewMng.getLayerIdFromSku(viewMng.getParticlesLayerSku());
         if(InstanceMng.getApplication().viewGetMode() == 1 || InstanceMng.getApplication().viewGetMode() == 2)
         {
            layerId = 1;
            viewMng = InstanceMng.getViewMngSpace();
         }
         mBmpDataLoading = viewMng.takeScreenShot(layerId);
         mBitmap = new Bitmap(mBmpDataLoading);
      }
   }
}
