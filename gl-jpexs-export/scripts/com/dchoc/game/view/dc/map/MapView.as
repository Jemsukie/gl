package com.dchoc.game.view.dc.map
{
   import com.dchoc.game.controller.map.MapController;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.utils.EUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class MapView extends DCComponentUI
   {
      
      public static const SPOTLIGHT_ALPHA:Number = 0.7;
      
      private static const FADE_INCREMENT:Number = 0.05;
      
      private static const FADE_TIMER:int = 100;
      
      private static const ZOOM_AMOUNT:Number = 0.25;
      
      public static const BOOKMARK_COORD:String = "coord";
      
      public static const BOOKMARK_ID:String = "id";
      
      public static const BOOKMARK_NAME:String = "name";
      
      public static const BOOKMARK_TYPE:String = "type";
       
      
      public var mViewMng:ViewMngrGame;
      
      protected var mMapController:MapController;
      
      private var mAlphaMap:Sprite;
      
      private var mCircleMask:Shape;
      
      private var mAlphaShadow:DCDisplayObjectSWF;
      
      private var mOrigin:Point;
      
      private var mFadeIncrement:Number;
      
      private var mFade:Number = 0;
      
      private var mFadeEnd:Number = 0;
      
      private var mFadeTimer:int;
      
      private var mFadePlaying:Boolean;
      
      private var mFadeIn:Boolean;
      
      private var mStartFade:Boolean;
      
      protected var mBookmarksList:Vector.<Dictionary>;
      
      protected var mBookmarksVisualsCatalog:Dictionary;
      
      private const BOOKMARKS_MAXIMUM_AMOUNT:int = 12;
      
      public function MapView()
      {
         super();
      }
      
      override protected function unloadDo() : void
      {
         this.removeSpotlight();
         this.mViewMng = null;
         this.mMapController = null;
      }
      
      override protected function unbuildDo() : void
      {
         this.mBookmarksList = null;
         this.mBookmarksVisualsCatalog = null;
      }
      
      public function setViewMng(value:ViewMngrGame) : void
      {
         this.mViewMng = value;
      }
      
      public function setMapController(value:MapController) : void
      {
         this.mMapController = value;
      }
      
      public function onAnimatedBackgroundToggled(value:Boolean) : void
      {
      }
      
      public function drawSpotlight(x:Number, y:Number, radius:Number) : void
      {
         var colors:Array = null;
         var alphas:Array = null;
         var rad2:Number = NaN;
         var ratios:Array = null;
         var matrix:Matrix = null;
         if(this.mAlphaMap == null)
         {
            this.mAlphaMap = new Sprite();
            this.mAlphaMap.graphics.beginFill(0,0.7);
            this.mAlphaMap.graphics.drawRect(0,0,InstanceMng.getViewMng().getStageWidth(),InstanceMng.getViewMng().getStageHeight() + 50);
            this.mAlphaMap.graphics.endFill();
            this.mAlphaMap.blendMode = "layer";
            this.mCircleMask = new Shape();
            this.mCircleMask.graphics.lineStyle();
            colors = [16777215,16777215];
            alphas = [1,0];
            rad2 = radius * 2;
            ratios = [200,255];
            (matrix = new Matrix()).createGradientBox(rad2,rad2);
            matrix.translate(-radius,-radius);
            this.mCircleMask.graphics.beginGradientFill("radial",colors,alphas,ratios,matrix);
            this.mCircleMask.graphics.drawCircle(0,0,radius);
            this.mCircleMask.graphics.endFill();
            this.mCircleMask.x = x;
            this.mCircleMask.y = y;
            this.mOrigin = new Point(x,y);
            this.mCircleMask.blendMode = "erase";
            this.mAlphaMap.addChild(this.mCircleMask);
            this.mAlphaMap.mouseEnabled = false;
            this.mAlphaMap.cacheAsBitmap = true;
            this.mAlphaShadow = new DCDisplayObjectSWF(this.mAlphaMap);
            if(!this.mViewMng.contains(this.mAlphaShadow))
            {
               this.mViewMng.addSpotlightToStage(this.mAlphaShadow);
            }
         }
         else
         {
            this.mCircleMask.x = x;
            this.mCircleMask.y = y;
         }
      }
      
      public function redrawSpotlight() : void
      {
         var stageWidth:Number = NaN;
         var stageHeight:Number = NaN;
         if(this.mAlphaMap != null)
         {
            stageWidth = InstanceMng.getViewMng().getStageWidth();
            stageHeight = InstanceMng.getViewMng().getStageHeight() + 50;
            this.mAlphaMap.graphics.clear();
            this.mAlphaMap.graphics.beginFill(0,0.7);
            this.mAlphaMap.graphics.drawRect(0,0,stageWidth,stageHeight);
            this.mAlphaMap.graphics.endFill();
         }
      }
      
      public function removeSpotlight() : void
      {
         if(this.mViewMng.contains(this.mAlphaShadow))
         {
            this.mViewMng.removeSpotlightFromStage(this.mAlphaShadow);
            this.mAlphaMap.removeChild(this.mCircleMask);
            this.mCircleMask = null;
            this.mAlphaMap = null;
            this.mAlphaShadow = null;
            this.mOrigin = null;
         }
      }
      
      public function getSpotlightDisplayObject() : DisplayObjectContainer
      {
         return this.mAlphaMap;
      }
      
      public function startFade(fadeIn:Boolean = false) : void
      {
         if(fadeIn)
         {
            this.mFadeIn = true;
            this.mFadeIncrement = 0.05;
            this.mFade = 0;
            this.mFadeEnd = 1.05;
         }
         else
         {
            this.mFadeIn = false;
            this.mFadeIncrement = -0.05;
            this.mFade = 1;
            this.mFadeEnd = 0.05;
         }
         this.mFadeTimer = 0;
         this.mAlphaMap = new Sprite();
         this.redrawShadow(this.mAlphaMap.graphics,this.mFade);
         this.mAlphaMap.cacheAsBitmap = true;
         this.mAlphaShadow = new DCDisplayObjectSWF(this.mAlphaMap);
         this.mAlphaShadow.alpha = this.mFade;
         this.mFadePlaying = true;
         if(!this.mViewMng.contains(this.mAlphaShadow))
         {
            this.mViewMng.addSpotlightToStage(this.mAlphaShadow);
         }
      }
      
      public function fadeUpdate(deltaTime:int) : void
      {
         var fadeAbs:Number = NaN;
         var getIn:* = false;
         if(this.mFadePlaying)
         {
            fadeAbs = Math.round(this.mFade * 100) / 100;
            if(this.mFadeIn)
            {
               getIn = fadeAbs <= this.mFadeEnd;
            }
            else
            {
               getIn = fadeAbs >= this.mFadeEnd;
            }
            if(getIn)
            {
               this.mFadeTimer += deltaTime;
               if(this.mFadeTimer > 100)
               {
                  this.mFadeTimer = 0;
                  this.mFade += this.mFadeIncrement;
                  this.mAlphaShadow.alpha = this.mFade;
                  if(fadeAbs == this.mFadeEnd)
                  {
                     this.endFade();
                  }
               }
            }
         }
      }
      
      private function redrawShadow(g:Graphics, alpha:Number) : void
      {
         g.clear();
         g.beginFill(0,alpha);
         g.drawRect(0,0,InstanceMng.getViewMng().getStageWidth(),InstanceMng.getViewMng().getStageHeight() + 50);
         g.endFill();
      }
      
      public function endFade() : void
      {
         if(this.mViewMng.contains(this.mAlphaShadow))
         {
            this.mViewMng.removeSpotlightFromStage(this.mAlphaShadow);
         }
         this.mAlphaMap = null;
         this.mAlphaShadow = null;
         this.mFadePlaying = false;
      }
      
      public function isFadeOver() : Boolean
      {
         return this.mAlphaMap == null && this.mFadePlaying == false;
      }
      
      public function zoomGetAmount() : Number
      {
         return 0.25;
      }
      
      public function loadPlanetsFromXML(info:XML) : void
      {
      }
      
      public function setUserBookmarks(xmlDoc:XML) : void
      {
         var xml:XML = null;
         var coordsArr:Array = null;
         var starCoor:DCCoordinate = null;
         var starId:Number = NaN;
         var starName:String = null;
         var starType:String = null;
         var solarSystemObj:Dictionary = null;
         if(xmlDoc != null)
         {
            for each(xml in EUtils.xmlGetChildrenList(xmlDoc,"star"))
            {
               coordsArr = EUtils.xmlReadString(xml,"sku").split(":");
               (starCoor = new DCCoordinate()).x = coordsArr[0];
               starCoor.y = coordsArr[1];
               starId = EUtils.xmlReadNumber(xml,"starId");
               starName = EUtils.xmlReadString(xml,"starName");
               starType = EUtils.xmlReadString(xml,"starType");
               if(this.mBookmarksList == null)
               {
                  this.mBookmarksList = new Vector.<Dictionary>(0);
               }
               (solarSystemObj = new Dictionary())["id"] = starId;
               solarSystemObj["coord"] = starCoor;
               solarSystemObj["name"] = starName;
               solarSystemObj["type"] = starType;
               if(starId != -1)
               {
                  this.mBookmarksList.push(solarSystemObj);
               }
            }
            return;
         }
         DCDebug.trace("Attention, the xmlDoc parameter should be non-null. Exiting",1);
      }
      
      public function checkIfStarAlreadyBookmarked(starId:Number) : Boolean
      {
         var solarSystemObj:Dictionary = null;
         var i:int = 0;
         var returnValue:Boolean = false;
         if(this.mBookmarksList != null)
         {
            for(i = 0; i < this.mBookmarksList.length; )
            {
               solarSystemObj = this.mBookmarksList[i];
               if(solarSystemObj["id"] == starId)
               {
                  return true;
               }
               i++;
            }
         }
         return returnValue;
      }
      
      public function addBookmark(starId:Number, starCoords:DCCoordinate, starName:String, starType:String) : Boolean
      {
         var solarSystemObj:Dictionary = null;
         var o:Object = null;
         var returnValue:Boolean = false;
         var viewMode:int = InstanceMng.getApplication().viewGetMode();
         if(this.mBookmarksList == null)
         {
            this.mBookmarksList = new Vector.<Dictionary>(0);
         }
         if(this.checkIfStarAlreadyBookmarked(starId))
         {
            o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_BOOKMARK_ALREADY_EXISTS");
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
            return false;
         }
         if(this.mBookmarksList.length == 12)
         {
            o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_BOOKMARK_MAXIMUM_REACHED");
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
            return false;
         }
         (solarSystemObj = new Dictionary())["id"] = starId;
         solarSystemObj["coord"] = starCoords;
         solarSystemObj["name"] = starName;
         solarSystemObj["type"] = starType;
         if(starId != -1)
         {
            returnValue = true;
            InstanceMng.getUserDataMng().updateBookmarks_addBookmark(starCoords.x,starCoords.y,starName,"",starId,starType);
            this.mBookmarksList.push(solarSystemObj);
            MessageCenter.getInstance().sendMessage("addedBookmarkedStars");
            return returnValue;
         }
         return false;
      }
      
      public function deleteBookmark(starCoords:DCCoordinate) : Boolean
      {
         var solarSystemObj:Dictionary = null;
         var i:int = 0;
         var returnValue:Boolean = false;
         var viewMode:int = InstanceMng.getApplication().viewGetMode();
         var found:Boolean = false;
         if(this.mBookmarksList == null)
         {
            return true;
         }
         i = 0;
         while(i < this.mBookmarksList.length)
         {
            solarSystemObj = this.mBookmarksList[i];
            if(starCoords.equals(solarSystemObj["coord"]))
            {
               InstanceMng.getUserDataMng().updateBookmarks_removeBookmark(starCoords.x,starCoords.y);
               this.mBookmarksList.splice(i,1);
               found = true;
               MessageCenter.getInstance().sendMessage("refreshBookmarkedStars");
               return true;
            }
            i++;
         }
         if(found == false)
         {
            DCDebug.trace("The star couldn\'t be found in the bookmarks list.",1);
         }
         return returnValue;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var returnValue:Boolean = false;
         switch(e.cmd)
         {
            case "NOTIFY_STAR_BUY_PLANET_POPUP":
               InstanceMng.getApplication().colonyPurchaseWait(e.planetSku,e.transaction,e.starId,e.starName,e.starType);
               returnValue = true;
               break;
            case "NOTIFY_STAR_MOVE_COLONY_POPUP":
               InstanceMng.getApplication().colonyMovedWait(e.planetId,e.newPlanetSku,e.transaction,e.starId,e.starName,e.starType);
               returnValue = true;
         }
         return returnValue;
      }
      
      public function buyPlanetByUser(planet:Planet, uInfo:UserInfo, starId:Number, starName:String, starType:int) : void
      {
         if(planet != null && uInfo != null)
         {
            planet.setURL(uInfo.mThumbnailURL);
            planet.setIsCapital(false);
            planet.setIsFree(false);
            planet.setParentStarId(starId);
            planet.setParentStarName(starName);
            planet.setParentStarType(starType);
         }
      }
   }
}
