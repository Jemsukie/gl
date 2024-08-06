package com.dchoc.game.view.dc.mng
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.view.display.layer.LayerSWF;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCTileSet;
   import com.dchoc.toolkit.core.view.display.layer.DCLayer;
   import com.dchoc.toolkit.core.view.display.layer.DCLayerSWF;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.animations.AnimationsReader;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.map.DCMapViewDef;
   import com.dchoc.toolkit.view.map.perspective.DCMapPerspective;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ViewMngPlanet extends ViewMngrGame
   {
      
      public static const LAYER_WORLD_SKU:String = "LayerWorld";
      
      private static const LAYER_WORLD_INTERACTIVITY_SKU:String = "LayerWorldInteractivity";
      
      public static const LAYER_WORLD_ITEMS_SKU:String = "LayerWorldItems";
      
      public static const LAYER_WORLD_ICONS_SKU:String = "LayerGame";
      
      private static const LAYER_POPUP_SKU:String = "LayerPopup";
      
      private static const LAYER_PORTAL_SKU:String = "LayerPortal";
      
      private static const LAYER_HUD_SKU:String = "LayerHud";
      
      private static const LAYER_TOOLTIP_SKU:String = "LayerTooltip";
      
      private static const LAYER_DEBUG_SKU:String = "LayerDebug";
      
      public static const LAYER_PARTICLES_UNDER_SHIPS_SKU:String = "LayerParticlesUnderShips";
      
      public static const LAYER_SHIPS_SKU:String = "LayerShips";
      
      public static const LAYER_PARTICLES_SKU:String = "LayerParticles";
      
      public static const LAYER_CURSOR_WORLD_SKU:String = "LayerCursorWorld";
      
      private static const LAYER_CURSOR_SCREEN_SKU:String = "LayerCursorScreen";
      
      private static const LAYER_CURSOR_ITEM_TOOL_SKU:String = "LayerCursorItemTool";
      
      private static const LAYER_MISSIONS_SKU:String = "LayerMissions";
      
      private static const LAYER_WORLD:int = 1;
      
      private static const LAYER_INTERACTIVITY:int = 2;
      
      private static const LAYER_WORLD_ITEMS:int = 3;
      
      private static const LAYER_WORLD_ICONS:int = 4;
      
      public static const LAYER_PARTICLES_UNDER_SHIPS:int = 5;
      
      public static const LAYER_SHIPS:int = 6;
      
      public static const LAYER_PARTICLES:int = 7;
      
      private static const LAYER_CURSOR_WORLD:int = 8;
      
      private static const LAYER_CURSOR_ITEM_TOOL:int = 9;
      
      private static const LAYER_HUD:int = 10;
      
      private static const LAYER_MISSIONS:int = 11;
      
      public static const LAYER_POPUP:int = 12;
      
      private static const LAYER_TOOLTIP:int = 13;
      
      private static const LAYER_PORTAL:int = 14;
      
      private static const LAYER_DEBUG:int = 15;
      
      private static const LAYER_CURSOR_SCREEN:int = 16;
       
      
      private var mWorldWidth:int;
      
      private var mWorldHeight:int;
      
      public var mWorldCameraX:int;
      
      public var mWorldCameraY:int;
      
      private var mWorldCameraMinX:int;
      
      private var mWorldCameraMinY:int;
      
      private var mWorldCameraMaxX:int;
      
      private var mWorldCameraMaxY:int;
      
      private var mWorldCameraWidth:int;
      
      private var mWorldCameraHeight:int;
      
      private var mWorldZoom:Number = 1;
      
      private var mWorldZoomRefPercentX:Number = 1;
      
      private var mWorldZoomRefPercentY:Number = 1;
      
      private var mWorldMapX:int;
      
      private var mWorldMapY:int;
      
      private var mWorldMapWidth:int;
      
      private var mWorldMapHeight:int;
      
      public var mWorldMapLogicX:int;
      
      public var mWorldMapLogicY:int;
      
      private var mMapController:MapControllerPlanet;
      
      private var mCoor:DCCoordinate;
      
      private var mMapPerspective:DCMapPerspective;
      
      public function ViewMngPlanet()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         super.loadDoStep(step);
         if(step == 0)
         {
            this.mCoor = new DCCoordinate();
         }
      }
      
      override protected function unloadDo() : void
      {
         super.unloadDo();
         this.worldUnload();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            this.mMapController = InstanceMng.getMapControllerPlanet();
            if(this.mMapController != null && this.mMapController.isBuilt())
            {
               this.mMapPerspective = this.mMapController.mMapViewDef.mPerspective;
               buildAdvanceSyncStep();
            }
         }
      }
      
      private function createLayer(needCamera:Boolean = false, needZoom:Boolean = false, screenCamera:DCViewMng = null) : DCLayer
      {
         return new DCLayerSWF(needCamera,needZoom,screenCamera);
      }
      
      override protected function layersPopulate() : void
      {
         mLayers[4] = this.createLayer(true,true,this);
         if(Config.DEBUG_MODE)
         {
            mLayers[15] = this.createLayer(true,true,this);
         }
         mLayers[12] = this.createLayer();
         mLayers[11] = this.createLayer();
         mLayers[10] = this.createLayer();
         mLayers[13] = this.createLayer();
         DCLayerSWF(mLayers[13]).setMouseChildren(false);
         mLayers[14] = this.createLayer();
         mLayers[8] = this.createLayer(true,true);
         mLayers[16] = this.createLayer();
         var sprite:Sprite = Sprite(mLayers[16].getDisplayObject());
         if(sprite != null)
         {
            sprite.mouseChildren = false;
            sprite.mouseEnabled = false;
         }
         mLayers[1] = this.createLayer(true,true);
         mLayers[2] = this.createLayer(true,true);
         mLayers[3] = new LayerSWF(true,true,this);
         mLayers[9] = this.createLayer(true,true);
         mLayers[5] = this.createLayer(true,true);
         mLayers[6] = this.createLayer(true,true);
         mLayers[7] = this.createLayer(true,true);
         mLayerDictionary["LayerGame"] = 4;
         mLayerDictionary["LayerWorldInteractivity"] = 2;
         mLayerDictionary["LayerDebug"] = 15;
         mLayerDictionary["LayerPopup"] = 12;
         mLayerDictionary["LayerHud"] = 10;
         mLayerDictionary["LayerTooltip"] = 13;
         mLayerDictionary["LayerCursorWorld"] = 8;
         mLayerDictionary["LayerCursorItemTool"] = 9;
         mLayerDictionary["LayerCursorScreen"] = 16;
         mLayerDictionary["LayerWorld"] = 1;
         mLayerDictionary["LayerWorldItems"] = 3;
         mLayerDictionary["LayerParticlesUnderShips"] = 5;
         mLayerDictionary["LayerShips"] = 6;
         mLayerDictionary["LayerParticles"] = 7;
         mLayerDictionary["LayerMissions"] = 11;
         mLayerDictionary["LayerPortal"] = 14;
      }
      
      public function getLayer(sku:String) : DCLayer
      {
         return mLayers[mLayerDictionary[sku]];
      }
      
      override public function addFireworksToStage(d:*, addToWorldLayer:Boolean = true) : void
      {
         var layer:String = addToWorldLayer ? "LayerParticles" : "background";
         addChildToLayer(d,layer);
      }
      
      override public function removeFireworksFromStage(d:*, addToWorldLayer:Boolean = true) : void
      {
         var layer:String = addToWorldLayer ? "LayerParticles" : "background";
         removeChildFromLayer(d,layer);
      }
      
      override public function getCursorLayerSku() : String
      {
         return "LayerCursorScreen";
      }
      
      override public function getHudLayerSku() : String
      {
         return "LayerHud";
      }
      
      override public function getParticlesLayerSku() : String
      {
         return "LayerParticles";
      }
      
      override public function getPopupLayerSku() : String
      {
         return "LayerPopup";
      }
      
      override public function getPortalLayerSku() : String
      {
         return "LayerPortal";
      }
      
      override public function getTooltipLayerSku() : String
      {
         return "LayerTooltip";
      }
      
      override public function getMissionsLayerSku() : String
      {
         return "LayerMissions";
      }
      
      override public function getAdvisorIconLayerSku() : String
      {
         return "LayerMissions";
      }
      
      override public function getDebugLayerSku() : String
      {
         return "LayerDebug";
      }
      
      override public function getTutorialArrowLayerSku() : String
      {
         return "LayerCursorWorld";
      }
      
      override public function getMapBackgroundLayerSku() : String
      {
         return "LayerWorld";
      }
      
      override protected function particlesGetLayerStage(type:int) : String
      {
         switch(type)
         {
            case 3:
            case 4:
            case 5:
            case 11:
               return "LayerParticles";
            case 17:
               return "LayerParticlesUnderShips";
            case 0:
            case 18:
            case 7:
            case 6:
            case 1:
            case 23:
            case 24:
            case 25:
            case 8:
            case 9:
            case 10:
            case 13:
            case 14:
            case 15:
            case 16:
            case 20:
            case 21:
               break;
            case 12:
               return "LayerWorld";
            default:
               return "LayerGame";
         }
         return "LayerShips";
      }
      
      override protected function particlesAddText(t:TextField) : void
      {
         this.addSWF(t);
      }
      
      override protected function particlesRemoveText(t:TextField) : void
      {
         this.removeSWF(t);
      }
      
      public function addSWF(d:*) : void
      {
         addChildToLayer(d,"LayerGame");
      }
      
      public function removeSWF(d:*) : void
      {
         removeChildFromLayer(d,"LayerGame");
      }
      
      public function createDOCForZoomOutPlanet() : Sprite
      {
         var doc:Sprite = null;
         var dsp:DisplayObject = null;
         doc = new Sprite();
         var i:int = 0;
         removeFromStageDo();
         for(i = 0; i <= 6; )
         {
            dsp = DCLayer(mLayers[i]).getDisplayObject();
            dsp.x = 0;
            dsp.y = 0;
            doc.addChild(dsp);
            i++;
         }
         doc.x -= this.mWorldCameraX;
         doc.y -= this.mWorldCameraY;
         mStage.addChild(doc);
         return doc;
      }
      
      public function mapCreate(mapViewDef:DCMapViewDef, mapTilesWidth:int, mapTilesHeight:int) : DCTileSet
      {
         var cor:Vector.<int> = null;
         var returnValue:DCTileSet = null;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         var corFileName:* = mapViewDef.getResourceName() + "_cor";
         var pngFileName:* = mapViewDef.getResourceName() + "_png";
         if(resourceMng.isResourceLoaded(corFileName) && resourceMng.isResourceLoaded(pngFileName))
         {
            cor = AnimationsReader.getCor(resourceMng.getResource(corFileName));
            cor = null;
            (returnValue = new DCTileSet()).build(pngFileName,cor,mapViewDef,mapTilesWidth,mapTilesHeight);
            returnValue.x = this.mWorldMapX;
            returnValue.y = this.mWorldMapY;
         }
         return returnValue;
      }
      
      public function mapAddToStage(d:*) : void
      {
         addChildToLayer(d,"LayerWorld");
      }
      
      public function mapRemoveFromStage(d:*) : void
      {
         removeChildFromLayer(d,"LayerWorld");
      }
      
      public function mapCursorCreate(mapViewDef:DCMapViewDef) : DCTileSet
      {
         var cor:Vector.<int> = null;
         var returnValue:DCTileSet = null;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         var corFileName:* = mapViewDef.getResourceName() + "_cor";
         var pngFileName:* = mapViewDef.getResourceName() + "_png";
         if(resourceMng.isResourceLoaded(corFileName) && resourceMng.isResourceLoaded(pngFileName))
         {
            cor = AnimationsReader.getCor(resourceMng.getResource(corFileName));
            cor = null;
            returnValue = new DCTileSet();
            returnValue.build(pngFileName,cor,mapViewDef,1,1);
            returnValue.x = this.mWorldMapX;
            returnValue.y = this.mWorldMapY;
         }
         return returnValue;
      }
      
      public function mapCursorAddToStage(d:DCDisplayObject) : void
      {
         addChildToLayer(d,"LayerCursorWorld");
      }
      
      public function mapCursorRemoveFromStage(d:DCDisplayObject) : void
      {
         removeChildFromLayer(d,"LayerCursorWorld");
      }
      
      public function mapGridAddToStage(d:DCDisplayObject) : void
      {
         addChildToLayer(d,"LayerCursorWorld");
      }
      
      public function mapGridRemoveFromStage(d:DCDisplayObject) : void
      {
         removeChildFromLayer(d,"LayerCursorWorld");
      }
      
      public function mapExpansionsAddToStage(d:DCDisplayObject) : void
      {
         addChildToLayer(d,"LayerWorld");
      }
      
      public function mapExpansionsRemoveFromStage(d:DCDisplayObject) : void
      {
         removeChildFromLayer(d,"LayerWorld");
      }
      
      public function mapExpansionsCursorAddToStage(d:DCDisplayObject) : void
      {
         addChildToLayer(d,"LayerCursorWorld");
      }
      
      public function mapExpansionsCursorRemoveFromStage(d:DCDisplayObject) : void
      {
         removeChildFromLayer(d,"LayerCursorWorld");
      }
      
      public function cursorItemToolAddToStage(d:DCDisplayObject) : void
      {
         addChildToLayer(d,"LayerCursorItemTool");
      }
      
      public function cursorItemToolRemoveFromStage(d:DCDisplayObject) : void
      {
         removeChildFromLayer(d,"LayerCursorItemTool");
      }
      
      public function cursorToolDropAddToStage(d:*) : void
      {
         addChildToLayer(d,"LayerGame");
      }
      
      public function cursorToolDropRemoveFromStage(d:*) : void
      {
         removeChildFromLayer(d,"LayerGame");
      }
      
      public function shipAddToStage(d:*) : void
      {
         addChildToLayer(d,"LayerShips");
      }
      
      public function shipRemoveFromStage(d:*) : void
      {
         removeChildFromLayer(d,"LayerShips");
      }
      
      public function addStarGateToStage(d:*) : void
      {
         addChildToLayer(d,"LayerShips");
      }
      
      public function removeStarGateFromStage(d:*) : void
      {
         removeChildFromLayer(d,"LayerShips");
      }
      
      private function unitGetLayerStage(u:MyUnit) : String
      {
         if(u.mDef.mSku == "sa_catapult")
         {
            return "LayerShips";
         }
         return u.mDef.isTerrainUnit() ? "LayerWorldItems" : "LayerShips";
      }
      
      public function unitAddToStage(u:MyUnit, d:DCDisplayObject) : void
      {
         var layer:String = this.unitGetLayerStage(u);
         if(layer != null)
         {
            addChildToLayer(d,layer);
         }
      }
      
      public function unitRemoveFromStage(u:MyUnit, d:DCDisplayObject) : void
      {
         var layer:String = this.unitGetLayerStage(u);
         if(layer != null)
         {
            removeChildFromLayer(d,layer);
         }
      }
      
      public function unitShadowAddToStage(d:DCDisplayObject) : void
      {
         addChildToLayer(d,"LayerWorldInteractivity");
      }
      
      public function unitShadowRemoveFromStage(d:DCDisplayObject) : void
      {
         removeChildFromLayer(d,"LayerWorldInteractivity");
      }
      
      private function getDropOnMapLayer() : String
      {
         return "LayerShips";
      }
      
      private function getNukeCraterLayer() : String
      {
         return "LayerWorldInteractivity";
      }
      
      private function getNukeCraterProgressBarLayer() : String
      {
         return "LayerGame";
      }
      
      private function getSpyCapsuleLayer() : String
      {
         return "LayerShips";
      }
      
      private function getUnitEffectLayer(type:int) : String
      {
         return type == 2 ? "LayerGame" : "LayerWorldItems";
      }
      
      public function addDropOnMapToStage(d:DCDisplayObject) : void
      {
         var layer:String = this.getDropOnMapLayer();
         if(layer != null)
         {
            addChildToLayer(d,layer);
         }
      }
      
      public function removeDropOnMapFromStage(d:DCDisplayObject) : void
      {
         var layer:String = this.getDropOnMapLayer();
         if(layer != null)
         {
            removeChildFromLayer(d,layer);
         }
      }
      
      public function addNukeCraterToStage(d:DCDisplayObject) : void
      {
         var layer:String = this.getNukeCraterLayer();
         if(layer != null)
         {
            addChildToLayer(d,layer);
         }
      }
      
      public function removeNukeCraterFromStage(d:DCDisplayObject) : void
      {
         var layer:String = this.getNukeCraterLayer();
         if(layer != null)
         {
            removeChildFromLayer(d,layer);
         }
      }
      
      public function addNukeCraterProgressBarToStage(d:DCDisplayObject) : void
      {
         var layer:String = this.getNukeCraterProgressBarLayer();
         if(layer != null)
         {
            addChildToLayer(d,layer);
         }
      }
      
      public function removeNukeCraterProgressBarFromStage(d:DCDisplayObject) : void
      {
         var layer:String = this.getNukeCraterProgressBarLayer();
         if(layer != null)
         {
            removeChildFromLayer(d,layer);
         }
      }
      
      public function addSpyCapsuleToStage(d:DisplayObjectContainer) : void
      {
         var layer:String = this.getSpyCapsuleLayer();
         if(layer != null)
         {
            addChildToLayer(d,layer);
         }
      }
      
      public function removeSpyCapsuleFromStage(d:DisplayObjectContainer) : void
      {
         var layer:String = this.getSpyCapsuleLayer();
         if(layer != null)
         {
            removeChildFromLayer(d,layer);
         }
      }
      
      public function unitAddEffectToStage(type:int, d:DCDisplayObject) : void
      {
         var layer:String = this.getUnitEffectLayer(type);
         if(d == null)
         {
            return;
         }
         var box:DCBox = DCBox(d.getSortingBox().clone(null));
         box.mZ += 1;
         d.mBoundingBox = box;
         if(layer != null)
         {
            addChildToLayer(d,layer);
         }
      }
      
      public function unitRemoveEffectFromStage(type:int, d:DCDisplayObject) : void
      {
         var layer:String = this.getUnitEffectLayer(type);
         if(layer != null)
         {
            removeChildFromLayer(d,layer);
         }
      }
      
      private function worldItemGetLayerStage(layerId:int, item:WorldItemObject, typeId:int) : String
      {
         var returnValue:String = null;
         switch(layerId)
         {
            case 0:
               returnValue = typeId == 33 ? "LayerWorldInteractivity" : "LayerWorld";
               break;
            case 1:
               returnValue = "LayerWorldItems";
               break;
            case 2:
               returnValue = "LayerGame";
               break;
            case 3:
               returnValue = typeId == 20 ? "LayerGame" : "LayerWorldItems";
               break;
            case 5:
               returnValue = item.viewLayersNeedsToBeRaised(layerId) ? "LayerWorldItems" : "LayerGame";
               break;
            default:
               returnValue = "LayerGame";
         }
         return returnValue;
      }
      
      public function worldItemAddToStage(layerId:int, item:WorldItemObject, typeId:int) : void
      {
         var updateScreen:Boolean = false;
         var d:DCDisplayObject;
         if((d = item.viewLayersAnimGet(layerId)) != null)
         {
            updateScreen = false;
            switch(typeId - 25)
            {
               case 0:
                  layerId = 1;
                  updateScreen = true;
            }
            addChildToLayer(d,this.worldItemGetLayerStage(layerId,item,typeId),-1,updateScreen);
         }
      }
      
      public function worldItemRemoveFromStage(layerId:int, item:WorldItemObject, typeId:int) : void
      {
         var d:*;
         if((d = item.viewLayersAnimGet(layerId)) != null)
         {
            switch(typeId - 25)
            {
               case 0:
                  layerId = 1;
            }
            removeChildFromLayer(d,this.worldItemGetLayerStage(layerId,item,typeId));
         }
      }
      
      private function getCupolaLayerSku() : String
      {
         return "LayerWorld";
      }
      
      public function cupolaAddToStage(d:Object) : void
      {
         addChildToLayer(d,this.getCupolaLayerSku());
      }
      
      public function cupolaRemoveFromStage(d:Object) : void
      {
         removeChildFromLayer(d,this.getCupolaLayerSku());
      }
      
      private function getWorldItemLiveBarLayerSku() : String
      {
         return "LayerParticles";
      }
      
      public function worldItemAddLiveBarToStage(d:Object) : void
      {
         addChildToLayer(d,this.getWorldItemLiveBarLayerSku());
      }
      
      public function worldItemRemoveLiveBarFromStage(d:Object) : void
      {
         removeChildFromLayer(d,this.getWorldItemLiveBarLayerSku());
      }
      
      public function worldItemAddWeaponsEffects(d:DCDisplayObject) : void
      {
         addChildToLayer(d,"LayerShips");
      }
      
      public function worldItemRemoveWeaponsEffect(d:DCDisplayObject) : void
      {
         removeChildFromLayer(d,"LayerShips");
      }
      
      private function umbrellaGetLayerSku() : String
      {
         return "LayerParticles";
      }
      
      public function umbrellaAddToStage(d:Object) : void
      {
         addChildToLayer(d,this.umbrellaGetLayerSku());
      }
      
      public function umbrellaRemoveFromStage(d:Object) : void
      {
         removeChildFromLayer(d,this.umbrellaGetLayerSku());
      }
      
      private function umbrellaBeamGetLayerSku() : String
      {
         return "LayerParticlesUnderShips";
      }
      
      public function umbrellaBeamAddToStage(d:Object) : void
      {
         addChildToLayer(d,this.umbrellaBeamGetLayerSku());
      }
      
      public function umbrellaBeamRemoveFromStage(d:Object) : void
      {
         removeChildFromLayer(d,this.umbrellaBeamGetLayerSku());
      }
      
      private function worldUnload() : void
      {
         this.mMapController = null;
         this.mCoor = null;
         this.mMapPerspective = null;
      }
      
      public function tileIndexToWorldPos(tileIndex:int, coor:DCCoordinate, center:Boolean = false) : DCCoordinate
      {
         this.mMapController.getIndexToTileXY(tileIndex,coor);
         return this.tileXYToWorldPos(coor,center);
      }
      
      public function tileRelativeXYToWorldPos(coor:DCCoordinate, center:Boolean = false) : DCCoordinate
      {
         coor.x = this.mMapController.getTileRelativeXToTile(coor.x);
         coor.y = this.mMapController.getTileRelativeYToTile(coor.y);
         coor.z = 0;
         return this.tileXYToWorldPos(coor,center);
      }
      
      public function tileXYToWorldPos(coor:DCCoordinate, center:Boolean = false) : DCCoordinate
      {
         coor = this.mMapController.getTileXYToPos(coor,center,false);
         coor.y = -coor.z;
         coor.z = 0;
         coor.x += this.mWorldMapLogicX;
         coor.y += this.mWorldMapLogicY;
         return coor;
      }
      
      public function logicPosToViewPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.z = -coor.y;
         coor.y = 0;
         this.mMapPerspective.mapToScreen(coor);
         return coor;
      }
      
      public function viewPosToLogicPos(coor:DCCoordinate) : DCCoordinate
      {
         this.mMapPerspective.screenToMap(coor);
         coor.y = -coor.z;
         coor.z = 0;
         return coor;
      }
      
      public function worldBegin() : void
      {
         this.worldCameraBegin();
         this.worldCameraSetSize(mStage.getStageWidth(),mStage.getStageHeight());
      }
      
      public function worldSetMapSize(width:int, height:int) : void
      {
         this.mWorldMapWidth = width;
         this.mWorldMapHeight = height;
      }
      
      public function worldSetSize(width:int, height:int) : void
      {
         this.mWorldWidth = width;
         this.mWorldHeight = height;
      }
      
      public function worldGetMapX() : int
      {
         return this.mWorldMapX;
      }
      
      public function worldGetMapY() : int
      {
         return this.mWorldMapY;
      }
      
      public function worldSetMapXY(x:int, y:int) : void
      {
         this.mWorldMapX = x;
         this.mWorldMapY = y;
         this.mCoor.x = x;
         this.mCoor.y = y;
         this.mCoor.z = 0;
         this.viewPosToLogicPos(this.mCoor);
         this.mWorldMapLogicX = this.mCoor.x;
         this.mWorldMapLogicY = this.mCoor.y;
      }
      
      public function worldToMapX(x:int) : int
      {
         return x - this.mWorldMapX;
      }
      
      public function worldToMapY(y:int) : int
      {
         return y - this.mWorldMapY;
      }
      
      public function zoomGetPercentX() : Number
      {
         return this.mWorldZoomRefPercentX;
      }
      
      public function zoomGetPercentY() : Number
      {
         return this.mWorldZoomRefPercentY;
      }
      
      public function getZoom() : Number
      {
         return this.mWorldZoom;
      }
      
      public function tileRelativeXYToWorldViewPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mMapController.getTileRelativeXToTile(coor.x);
         coor.y = this.mMapController.getTileRelativeYToTile(coor.y);
         return this.tileXYToWorldViewPos(coor);
      }
      
      public function tileXYToWorldViewPos(coor:DCCoordinate, center:Boolean = false) : DCCoordinate
      {
         this.mMapController.getTileXYToPos(coor,center);
         coor.x += this.mWorldMapX;
         coor.y += this.mWorldMapY;
         return coor;
      }
      
      public function worldViewPosToTileXY(coor:DCCoordinate, decimals:Boolean = false, clamp:Boolean = false) : DCCoordinate
      {
         coor.x = this.worldToMapX(coor.x);
         coor.y = this.worldToMapY(coor.y);
         return this.mMapController.getPosToTileXY(coor,decimals,clamp);
      }
      
      public function worldViewPosToTileRelativeXY(coor:DCCoordinate, decimals:Boolean = false, clamp:Boolean = false) : DCCoordinate
      {
         this.worldViewPosToTileXY(coor,decimals,clamp);
         coor.x = this.mMapController.getTileToTileRelativeX(coor.x);
         coor.y = this.mMapController.getTileToTileRelativeY(coor.y);
         return coor;
      }
      
      public function worldViewPosToTileIndex(coor:DCCoordinate, decimals:Boolean = false, clamp:Boolean = false) : int
      {
         this.worldViewPosToTileXY(coor,decimals);
         return this.mMapController.getTileXYToIndex(coor.x,coor.y,clamp);
      }
      
      public function logicPosToTileIndex(coor:DCCoordinate) : int
      {
         this.logicPosToTileXY(coor);
         return this.mMapController.getTileXYToIndex(coor.x,coor.y,false);
      }
      
      public function logicPosToTileXY(coor:DCCoordinate, clamp:Boolean = false) : DCCoordinate
      {
         coor.x -= this.mWorldMapLogicX;
         coor.y -= this.mWorldMapLogicY;
         this.mMapController.getLogicPosToTileXY(coor,false,false);
         return coor;
      }
      
      public function logicPosToTileRelativeXY(coor:DCCoordinate, clamp:Boolean = false) : DCCoordinate
      {
         coor = this.logicPosToTileXY(coor,clamp);
         coor.x = this.mMapController.getTileToTileRelativeX(coor.x);
         coor.y = this.mMapController.getTileToTileRelativeY(coor.y);
         return coor;
      }
      
      public function tileAreaToWorldViewPos(tileX:Number, tileY:Number, tilesWidth:Number, tilesHeight:Number, corners:Vector.<Number>) : void
      {
         if(corners == null)
         {
            corners = new Vector.<Number>(8);
         }
         var i:int = 0;
         var right:Number = tileX + tilesWidth;
         var bottom:Number = tileY + tilesHeight;
         this.mCoor.x = tileX;
         this.mCoor.y = tileY;
         this.tileXYToWorldViewPos(this.mCoor);
         var _loc6_:* = i++;
         corners[_loc6_] = this.mCoor.x;
         var _loc12_:* = i++;
         corners[_loc12_] = this.mCoor.y;
         this.mCoor.x = right;
         this.mCoor.y = tileY;
         this.tileXYToWorldViewPos(this.mCoor);
         var _loc13_:* = i++;
         corners[_loc13_] = this.mCoor.x;
         var _loc10_:* = i++;
         corners[_loc10_] = this.mCoor.y;
         this.mCoor.x = right;
         this.mCoor.y = bottom;
         this.tileXYToWorldViewPos(this.mCoor);
         var _loc11_:* = i++;
         corners[_loc11_] = this.mCoor.x;
         var _loc15_:* = i++;
         corners[_loc15_] = this.mCoor.y;
         this.mCoor.x = tileX;
         this.mCoor.y = bottom;
         this.tileXYToWorldViewPos(this.mCoor);
         var _loc16_:* = i++;
         corners[_loc16_] = this.mCoor.x;
         var _loc14_:* = i++;
         corners[_loc14_] = this.mCoor.y;
      }
      
      public function areaToWorldViewPos(x:Number, y:Number, width:Number, height:Number, corners:Vector.<Number>) : void
      {
         if(corners == null)
         {
            corners = new Vector.<Number>(8);
         }
         var i:int = 0;
         var right:Number = x + width;
         var bottom:Number = y + height;
         this.mCoor.x = x;
         this.mCoor.y = y;
         this.logicPosToViewPos(this.mCoor);
         var _loc6_:* = i++;
         corners[_loc6_] = this.mCoor.x;
         var _loc12_:* = i++;
         corners[_loc12_] = this.mCoor.y;
         this.mCoor.x = right;
         this.mCoor.y = y;
         this.logicPosToViewPos(this.mCoor);
         var _loc13_:* = i++;
         corners[_loc13_] = this.mCoor.x;
         var _loc10_:* = i++;
         corners[_loc10_] = this.mCoor.y;
         this.mCoor.x = right;
         this.mCoor.y = bottom;
         this.logicPosToViewPos(this.mCoor);
         var _loc11_:* = i++;
         corners[_loc11_] = this.mCoor.x;
         var _loc15_:* = i++;
         corners[_loc15_] = this.mCoor.y;
         this.mCoor.x = x;
         this.mCoor.y = bottom;
         this.logicPosToViewPos(this.mCoor);
         var _loc16_:* = i++;
         corners[_loc16_] = this.mCoor.x;
         var _loc14_:* = i++;
         corners[_loc14_] = this.mCoor.y;
      }
      
      public function tileIndexToWorldViewPos(tileIndex:int, coor:DCCoordinate, center:Boolean = false) : DCCoordinate
      {
         this.mMapController.getIndexToTileXY(tileIndex,coor);
         return this.tileXYToWorldViewPos(coor,center);
      }
      
      public function mapToWorldX(x:int) : int
      {
         return x + this.mWorldMapX;
      }
      
      public function mapToWorldY(y:int) : int
      {
         return y + this.mWorldMapY;
      }
      
      public function screenToWorldX(x:int) : int
      {
         if(this.mWorldCameraMinX > 0)
         {
            x -= this.mWorldCameraMinX;
         }
         else
         {
            x += this.mWorldCameraX;
         }
         return x / this.mWorldZoom;
      }
      
      public function screenToWorldY(y:int) : int
      {
         if(this.mWorldCameraMinY > 0)
         {
            y -= this.mWorldCameraMinY;
         }
         else
         {
            y += this.mWorldCameraY;
         }
         return y / this.mWorldZoom;
      }
      
      override public function worldToScreen(coor:DCCoordinate) : DCCoordinate
      {
         var offX:int = this.mWorldCameraMinX > 0 ? this.mWorldCameraMinX : int(-this.mWorldCameraX);
         coor.x = coor.x * this.mWorldZoom + offX;
         var offY:int = this.mWorldCameraMinY > 0 ? this.mWorldCameraMinY : int(-this.mWorldCameraY);
         coor.y = coor.y * this.mWorldZoom + offY;
         return coor;
      }
      
      public function screenToTileXY(coor:DCCoordinate, decimals:Boolean = false) : DCCoordinate
      {
         coor.x = this.screenToWorldX(coor.x);
         coor.y = this.screenToWorldY(coor.y);
         return this.worldViewPosToTileXY(coor,decimals);
      }
      
      private function worldCameraBegin() : void
      {
         this.worldCameraSetXY(0,0);
         this.worldOnZoomSet(1);
         this.worldOnZoomMove(1);
      }
      
      public function worldCameraSetSize(width:int, height:int, doCenter:Boolean = false) : void
      {
         var cameraWidthOld:int = this.mWorldCameraWidth;
         var cameraHeightOld:int = this.mWorldCameraHeight;
         this.mWorldCameraWidth = width;
         this.mWorldCameraHeight = height;
         if(this.mWorldWidth * this.mWorldZoom > this.mWorldCameraWidth)
         {
            this.mWorldCameraMinX = 0;
         }
         else
         {
            this.mWorldCameraMinX = this.mWorldCameraWidth - this.mWorldWidth * this.mWorldZoom >> 1;
         }
         if(this.mWorldHeight * this.mWorldZoom > this.mWorldCameraHeight)
         {
            this.mWorldCameraMinY = 0;
         }
         else
         {
            this.mWorldCameraMinY = this.mWorldCameraHeight - this.mWorldHeight * this.mWorldZoom >> 1;
         }
         this.mWorldCameraMaxX = this.mWorldCameraMinX + this.mWorldWidth * this.mWorldZoom - this.mWorldCameraWidth;
         this.mWorldCameraMaxY = this.mWorldCameraMinY + this.mWorldHeight * this.mWorldZoom - this.mWorldCameraHeight;
         mCameraBox.setSize(this.mWorldCameraWidth - CAMERA_BOX_OFF_X * 2,this.mWorldCameraHeight - CAMERA_BOX_OFF_X * 2);
         if(doCenter)
         {
            this.worldCameraCenterInPosition(this.mWorldCameraX + (cameraWidthOld >> 1),this.mWorldCameraY + (cameraHeightOld >> 1));
         }
         if(Config.DEBUG_SCREEN)
         {
            cameraViewRender(false);
         }
      }
      
      public function worldCameraSetXY(x:int, y:int, effective:Boolean = true) : void
      {
         var layer:DCLayer = null;
         if(x < this.mWorldCameraMinX)
         {
            x = this.mWorldCameraMinX;
         }
         if(x > this.mWorldCameraMaxX)
         {
            x = this.mWorldCameraMaxX;
         }
         if(y < this.mWorldCameraMinY)
         {
            y = this.mWorldCameraMinY;
         }
         if(y > this.mWorldCameraMaxY)
         {
            y = this.mWorldCameraMaxY;
         }
         mCameraBox.setXY(x + CAMERA_BOX_OFF_X,y + CAMERA_BOX_OFF_Y);
         if(Config.DEBUG_SCREEN)
         {
            cameraViewRender(false);
         }
         for each(layer in mLayers)
         {
            if(layer.needCamera)
            {
               layer.cameraSetXY(-x,-y);
            }
         }
         if(effective)
         {
            this.mWorldCameraX = x;
            this.mWorldCameraY = y;
         }
      }
      
      public function worldCameraMove(dx:int, dy:int, effective:Boolean = true) : void
      {
         this.worldCameraSetXY(this.mWorldCameraX + dx,this.mWorldCameraY + dy,effective);
      }
      
      public function worldCameraCenterInTileXY(tileX:int, tileY:int) : void
      {
         this.mCoor.x = tileX;
         this.mCoor.y = tileY;
         this.tileXYToWorldViewPos(this.mCoor);
         this.worldCameraCenterInPosition(this.mCoor.x,this.mCoor.y);
      }
      
      public function worldCameraCenterInPosition(x:int, y:int) : void
      {
         this.worldCameraSetXY(x - (this.mWorldCameraWidth >> 1),y - (this.mWorldCameraHeight >> 1));
      }
      
      public function worldOnZoomSet(value:Number) : void
      {
         var refX:int = this.mWorldCameraX + (this.mWorldCameraWidth >> 1);
         var refY:int = this.mWorldCameraY + (this.mWorldCameraHeight >> 1);
         this.mWorldZoomRefPercentX = DCMath.ruleOf3(refX,this.mWorldWidth * this.mWorldZoom,100);
         this.mWorldZoomRefPercentY = DCMath.ruleOf3(refY,this.mWorldHeight * this.mWorldZoom,100);
      }
      
      public function worldOnZoomForce(value:Number) : void
      {
         this.worldOnZoomSet(value);
         this.worldOnZoomMove(value);
      }
      
      public function worldOnZoomMove(off:Number) : void
      {
         var layer:DCLayer = null;
         this.mWorldZoom = off;
         var i:int = 0;
         for each(layer in mLayers)
         {
            if(layer.needZoom)
            {
               layer.zoom(this.mWorldZoom);
            }
            i++;
         }
         this.worldCameraSetSize(this.mWorldCameraWidth,this.mWorldCameraHeight,false);
         this.worldCameraCenterInPosition(this.mWorldWidth * this.mWorldZoomRefPercentX * this.mWorldZoom / 100,this.mWorldHeight * this.mWorldZoomRefPercentY * this.mWorldZoom / 100);
      }
      
      override public function cameraCollision(x:Number, y:Number, width:Number, height:Number) : Boolean
      {
         return x + width >= this.mWorldCameraX && x <= this.mWorldCameraX + this.mWorldCameraWidth && y + height >= this.mWorldCameraY && y <= this.mWorldCameraY + this.mWorldCameraHeight;
      }
      
      override protected function cameraShakeCalculateShake() : void
      {
         mCameraShakeX = (Math.random() * mCameraShakeIntensity * this.mWorldCameraWidth * 2 - mCameraShakeIntensity * this.mWorldCameraWidth) * this.mWorldZoom;
         mCameraShakeY = (Math.random() * mCameraShakeIntensity * this.mWorldCameraHeight * 2 - mCameraShakeIntensity * this.mWorldCameraHeight) * this.mWorldZoom;
      }
      
      override protected function cameraShakeMoveCamera(shakeX:int, shakeY:int) : void
      {
         this.worldCameraMove(shakeX,shakeY,false);
      }
      
      override protected function fadeGetLayerSku() : String
      {
         return "LayerCursorScreen";
      }
   }
}
