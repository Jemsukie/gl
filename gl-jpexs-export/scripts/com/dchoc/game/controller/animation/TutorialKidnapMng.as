package com.dchoc.game.controller.animation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.animation.AnimationLogic;
   import com.dchoc.game.model.animation.AnimationLogicUfo;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class TutorialKidnapMng extends DCComponent
   {
      
      private static const NUM_UFOS:int = 8;
      
      private static const SCROLL_TO_SECONDS:int = 4;
      
      private static const SCROLL_BACK_SECONDS:int = 9;
      
      private static const SCROLL_POS_X:int = 650;
      
      private static const SCROLL_POS_Y:int = 900;
      
      private static const UFO_COORDS_FROM_OFFSET_X:int = -850;
      
      private static const UFO_COORDS_FROM_OFFSET_Y:int = -260;
      
      private static const UFO_HEIGHT_PX:int = 100;
      
      private static const STATE_KIDNAP_MNG_NONE:int = 0;
      
      private static const STATE_KIDNAP_MNG_SCROLL:int = 1;
      
      private static const STATE_KIDNAP_MNG_IN_PROGRESS:int = 2;
      
      private static const STATE_KIDNAP_MNG_END:int = 3;
      
      private static const USABLE_TILES:Array = [2257,1041,3072,2778,2756,2332,3779,1384];
      
      private static const TRAVEL_TIMES:Array = [3000,3500,4000,5000,8000,8500,9000,9500];
       
      
      private var mState:int;
      
      private var mUfosAnimation:Vector.<AnimationLogic>;
      
      public function TutorialKidnapMng()
      {
         super();
         this.setState(0);
         this.mUfosAnimation = new Vector.<AnimationLogic>(0);
      }
      
      override protected function unloadDo() : void
      {
         if(this.mUfosAnimation != null)
         {
            this.mUfosAnimation.length = 0;
            this.mUfosAnimation = null;
         }
      }
      
      public function hasEnded() : Boolean
      {
         return this.mState == 3;
      }
      
      public function setupVars() : void
      {
         var i:int = 0;
         var tileIndex:int = 0;
         var coordsTo:DCCoordinate = null;
         var ufoAnimation:AnimationLogicUfo = null;
         var bitmapMinion:DCBitmapMovieClip = null;
         var halfScreenY:* = InstanceMng.getApplication().stageGetHeight() >> 1;
         var coordsFromX:int = InstanceMng.getViewMngPlanet().mWorldCameraX + -850;
         var coordsFromY:int = InstanceMng.getViewMngPlanet().mWorldCameraY + halfScreenY + -260;
         var coordsFrom:DCCoordinate = new DCCoordinate(coordsFromX,coordsFromY);
         var viewMng:ViewMngrGame = InstanceMng.getViewMngGame();
         for(i = 0; i < 8; )
         {
            tileIndex = int(USABLE_TILES[i]);
            coordsTo = new DCCoordinate();
            InstanceMng.getViewMngPlanet().tileIndexToWorldViewPos(tileIndex,coordsTo);
            ufoAnimation = new AnimationLogicUfo();
            ufoAnimation.stop();
            ufoAnimation.setXY(coordsFrom.x,coordsFrom.y);
            ufoAnimation.setNotifyComponent(this);
            bitmapMinion = new DCBitmapMovieClip();
            bitmapMinion.stop();
            bitmapMinion.setXY(coordsTo.x,coordsTo.y);
            coordsTo.y -= 100;
            ufoAnimation.setParams(0,bitmapMinion,coordsFrom,coordsTo,TRAVEL_TIMES[i]);
            this.mUfosAnimation.push(ufoAnimation);
            viewMng.addParticle(ufoAnimation);
            viewMng.addParticle(bitmapMinion);
            i++;
         }
         if(true)
         {
            this.setState(1);
            this.notifyStartScroll();
            this.notifyStartKidnapping();
         }
      }
      
      private function setState(state:int) : void
      {
         var resourceMng:ResourceMng = null;
         this.mState = state;
         switch(this.mState - 1)
         {
            case 0:
               resourceMng = InstanceMng.getResourceMng();
               if(!resourceMng.isResourceLoaded("ovni"))
               {
                  resourceMng.requestResource("ovni");
               }
               if(!resourceMng.isResourceLoaded("assets/flash/tutorial/abduction_assets.swf"))
               {
                  resourceMng.requestResource("assets/flash/tutorial/abduction_assets.swf");
                  break;
               }
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         switch(this.mState - 1)
         {
            case 0:
               this.updateWaitState();
               break;
            case 1:
               this.updateKidnappingState(dt);
         }
         if((this.mUfosAnimation != null && this.hasUfos()) == false)
         {
            if(this.mState != 3)
            {
               this.setState(3);
               InstanceMng.getApplication().funnelNotify("wowEffectOver");
            }
         }
      }
      
      private function getUfosLeft() : int
      {
         if(this.mUfosAnimation == null)
         {
            return 0;
         }
         return this.mUfosAnimation.length;
      }
      
      private function hasUfos() : Boolean
      {
         return this.getUfosLeft() > 0;
      }
      
      private function updateWaitState() : void
      {
         var camCoords:DCCoordinate = null;
         if(InstanceMng.getMapControllerPlanet().cameraHasReachedTheTarget() && this.areAssetsLoaded())
         {
            camCoords = InstanceMng.getMapControllerPlanet().getBeforeAutoScrollCoords();
            if(camCoords == null)
            {
               camCoords = InstanceMng.getMapControllerPlanet().getOriginalCenterCamPos();
            }
            InstanceMng.getMapControllerPlanet().moveCameraTo(camCoords.x,camCoords.y,9);
            this.setState(2);
         }
      }
      
      private function areAssetsLoaded() : Boolean
      {
         return InstanceMng.getResourceMng().isResourceLoaded("assets/flash/tutorial/abduction_assets.swf") && InstanceMng.getResourceMng().isResourceLoaded("ovni");
      }
      
      private function updateKidnappingState(dt:int) : void
      {
         var i:int = 0;
         if(this.mUfosAnimation == null)
         {
            return;
         }
         for(i = this.mUfosAnimation.length - 1; i >= 0; )
         {
            this.mUfosAnimation[i].logicUpdate(dt);
            i--;
         }
      }
      
      private function updateEnd(bitmap:AnimationLogic) : void
      {
         if(InstanceMng.getViewMngGame().contains(bitmap) == true)
         {
            InstanceMng.getViewMngGame().removeParticle(bitmap);
         }
         var idx:int = this.mUfosAnimation.indexOf(bitmap);
         if(idx > -1)
         {
            this.mUfosAnimation.splice(idx,1);
         }
         if(this.getUfosLeft() == 8 >> 2)
         {
            this.notifyClosePopup();
         }
         if(this.hasUfos() == false)
         {
            this.mUfosAnimation = null;
            this.notifyEndKidnapping();
         }
      }
      
      private function notifyStartScroll() : void
      {
         InstanceMng.getGUIController().lockGUI();
         var scale:Number = InstanceMng.getViewMngPlanet().getZoom();
         var scrollX:int = 650;
         var scrollY:int = 900;
         if(scale != 0)
         {
            scrollX *= scale;
            scrollY *= scale;
         }
         InstanceMng.getMapControllerPlanet().moveCameraTo(scrollX,scrollY,4);
      }
      
      public function notifyStartKidnapping() : void
      {
         SoundManager.getInstance().stopAll(true);
         var music:String = InstanceMng.getUnitScene().battleGetMusic();
         SoundManager.getInstance().playSound(music,1,0,-1,0);
         InstanceMng.getApplication().speechPopupOpen("npc_B_normal","",DCTextMng.getText(763),null,"Body_7.mp3",null,true,false,75,1);
      }
      
      private function notifyClosePopup() : void
      {
         InstanceMng.getApplication().speechPopupClose();
      }
      
      public function notifyEndKidnapping() : void
      {
         SoundManager.getInstance().stopAll(true);
         SoundManager.getInstance().playSound("music_main.mp3",1,0,-1,0);
         InstanceMng.getUIFacade().blackStripsHide();
         InstanceMng.getGUIController().unlockGUI();
         InstanceMng.getMapViewPlanet().mouseEventsSetEnabledAnimsOnMap(true,true);
         InstanceMng.getVisitorMng().uiSetIsEnabled(true);
         var advisorId:String = "captain_normal";
         var title:String = "";
         var body:String = DCTextMng.getText(764);
         var buttonText:String = DCTextMng.getText(0);
         var sound:String = "Body_1.mp3";
         InstanceMng.getApplication().speechPopupOpen(advisorId,title,body,buttonText,sound,null,false,true);
      }
      
      override public function notify(e:Object) : Boolean
      {
         if(e.cmd == "NOTIFY_STATE_END")
         {
            this.updateEnd(e.ufoInstance as AnimationLogic);
         }
         return true;
      }
   }
}
