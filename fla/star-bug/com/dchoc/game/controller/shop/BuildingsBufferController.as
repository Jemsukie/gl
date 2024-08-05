package com.dchoc.game.controller.shop
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.BuildingBufferFacade;
   import com.dchoc.game.eview.popups.buffer.EPopupBufferTemplates;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.online.Server;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCUtils;
   import esparragon.utils.EUtils;
   
   public class BuildingsBufferController extends DCComponent
   {
       
      
      private var smMapController:MapControllerPlanet;
      
      private var mIsBufferOpen:Boolean;
      
      private var mBuildingsBuffer:Vector.<WorldItemObject>;
      
      private var mItemsAmount:Object;
      
      private var mInitialPosWasSaved:Boolean;
      
      public function BuildingsBufferController()
      {
         super();
         this.mBuildingsBuffer = new Vector.<WorldItemObject>(0);
         this.mItemsAmount = {};
         this.mInitialPosWasSaved = false;
         this.smMapController = InstanceMng.getMapControllerPlanet();
      }
      
      public function isBufferOpen() : Boolean
      {
         return this.mIsBufferOpen;
      }
      
      public function getCancelButtonAvailability() : Boolean
      {
         return true;
      }
      
      public function setBufferOpen(value:Boolean) : void
      {
         this.mIsBufferOpen = value;
      }
      
      public function getShopResourcesInfo(types:String = null) : Vector.<WorldItemObject>
      {
         if(this.mBuildingsBuffer == null)
         {
            return new Vector.<WorldItemObject>(0);
         }
         return this.mBuildingsBuffer;
      }
      
      public function tryToAddItem() : void
      {
         var item:WorldItemObject = null;
         if(InstanceMng.getToolsMng().getCurrentTool().isItemAttached())
         {
            item = InstanceMng.getToolsMng().getCurrentTool().getAttachedItem();
            item.moveBegin();
            item.setTileXY(1000,0);
            item.moveEnd();
            this.mBuildingsBuffer.push(item);
         }
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_move_buffer");
         InstanceMng.getToolsMng().setTool(16);
         this.calculateQuantity(item);
      }
      
      public function saveItemsOldPositions() : void
      {
         var item:WorldItemObject = null;
         var allItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         for each(item in allItems)
         {
            item.setOldTiles(this.smMapController.getTileRelativeXToTile(item.mTileRelativeX),this.smMapController.getTileRelativeXToTile(item.mTileRelativeY));
         }
      }
      
      public function addAllItems() : void
      {
         var item:WorldItemObject = null;
         var allItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_move");
         DCDebug.traceCh("BB","ALLITEMS:" + allItems.length.toString());
         DCDebug.traceCh("BB","BUFFERLENGTH:" + this.mBuildingsBuffer.length.toString());
         for each(item in allItems)
         {
            if(item.moveCanBeMoved() && !this.checkItemInBuffer(item) && this.isItemAllowedInBuffer(item))
            {
               this.mBuildingsBuffer.push(item);
               this.moveBegin(item);
               item.setTileXY(this.smMapController.getTileRelativeXToTile(item.mTileRelativeX) + 1000,this.smMapController.getTileRelativeYToTile(item.mTileRelativeY));
               this.moveEnd(item);
               this.calculateQuantity(item);
            }
         }
         InstanceMng.getUIFacade().getBuildingsBufferBar().loadShop();
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_move_buffer");
      }
      
      public function calculateQuantity(item:WorldItemObject) : void
      {
         if(item != null)
         {
            if(!this.mItemsAmount.hasOwnProperty(item.mDef.getSku()))
            {
               this.mItemsAmount[item.mDef.getSku()] = 1;
            }
            else
            {
               this.mItemsAmount[item.mDef.getSku()] = this.mItemsAmount[item.mDef.getSku()] + 1;
            }
         }
      }
      
      public function removeItem(object:WorldItemObject) : void
      {
         this.mItemsAmount[object.mDef.getSku()] = this.mItemsAmount[object.mDef.getSku()] - 1;
         var index:int = this.mBuildingsBuffer.indexOf(object);
         object = null;
         this.mBuildingsBuffer.splice(index,1);
      }
      
      public function sendConfirmationToServer() : void
      {
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_cursor");
         InstanceMng.getUserDataMng().updateItem_moveAll(this.getItemsArrayFull());
      }
      
      private function isItemInMap(wio:WorldItemObject) : Boolean
      {
         if(wio == null)
         {
            return false;
         }
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         return mapController.isTileXYInMap(mapController.getTileRelativeXToTile(wio.mTileRelativeX),mapController.getTileRelativeYToTile(wio.mTileRelativeY));
      }
      
      private function getItemsArrayFull() : Array
      {
         var item:WorldItemObject = null;
         var allItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         var buildingsAndPositions:Array = [];
         for each(item in allItems)
         {
            buildingsAndPositions.push(item.mSid,item.mTileRelativeX,item.mTileRelativeY);
         }
         return buildingsAndPositions;
      }
      
      public function getItemsDataForTemplate() : Object
      {
         var sku:String = null;
         var tileX:* = 0;
         var tileY:* = 0;
         var upgradeId:int = 0;
         var flipped:int = 0;
         var item:WorldItemObject = null;
         var allItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         var itemsData:Object = {};
         for each(item in allItems)
         {
            if(item.moveCanBeMoved() && this.isItemInMap(item) && this.isItemAllowedInBuffer(item))
            {
               sku = item.mDef.mSku;
               tileX = mapController.getTileRelativeXToTile(item.mTileRelativeX);
               tileY = mapController.getTileRelativeYToTile(item.mTileRelativeY);
               upgradeId = item.mUpgradeId;
               flipped = item.mIsFlipped ? 1 : 0;
               if(!itemsData.hasOwnProperty(sku))
               {
                  itemsData[sku] = [];
               }
               itemsData[sku].push({
                  "x":tileX,
                  "y":tileY,
                  "l":upgradeId,
                  "f":flipped
               });
            }
         }
         return itemsData;
      }
      
      public function tryToApplyTemplate(itemsData:Object) : int
      {
         var realItem:* = null;
         var sku:String = null;
         var itemObj:* = null;
         var x:int = 0;
         var y:int = 0;
         var upgradeId:int = 0;
         var flipped:* = false;
         var isPlaced:Boolean = false;
         var def:WorldItemDef = null;
         if(DCUtils.isObjectEmpty(itemsData))
         {
            return 3;
         }
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_move_buffer");
         InstanceMng.getUserInfoMng().getProfileLogin().setFlatbed(0);
         this.addAllItems();
         for(sku in itemsData)
         {
            for each(itemObj in itemsData[sku])
            {
               if(sku == null || sku == "" || !itemObj.hasOwnProperty("x") || !itemObj.hasOwnProperty("y"))
               {
                  return 4;
               }
               x = int(itemObj["x"]);
               y = int(itemObj["y"]);
               upgradeId = 0;
               flipped = Boolean(0);
               if(itemObj.hasOwnProperty("l"))
               {
                  upgradeId = int(itemObj["l"]);
               }
               else
               {
                  itemObj["l"] = upgradeId;
               }
               if(itemObj.hasOwnProperty("f"))
               {
                  flipped = itemObj["f"] == 1;
               }
               else
               {
                  itemObj["f"] = flipped;
               }
               if((def = InstanceMng.getWorldItemDefMng().getDefBySku(sku) as WorldItemDef) == null || def.isAnObstacle())
               {
                  return 4;
               }
               if(!InstanceMng.getMapModel().placeIsItemDefPlaceable(def,x,y))
               {
                  return 2;
               }
            }
         }
         var realItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         for(sku in itemsData)
         {
            for each(itemObj in itemsData[sku])
            {
               isPlaced = false;
               x = int(itemObj["x"]);
               y = int(itemObj["y"]);
               upgradeId = int(itemObj["l"]);
               flipped = itemObj["f"] == 1;
               for each(realItem in realItems)
               {
                  if(sku == realItem.mDef.mSku && upgradeId == realItem.mUpgradeId && !isPlaced && !this.isItemInMap(realItem))
                  {
                     realItem.viewReset();
                     this.moveBegin(realItem,false);
                     realItem.setTileXY(x,y);
                     this.moveEnd(realItem,false,false);
                     if(flipped != realItem.mIsFlipped)
                     {
                        realItem.flip();
                     }
                     isPlaced = true;
                     this.removeItem(realItem);
                     break;
                  }
               }
               if(!isPlaced)
               {
                  for each(realItem in realItems)
                  {
                     if(sku == realItem.mDef.mSku && !isPlaced && !this.isItemInMap(realItem))
                     {
                        realItem.viewReset();
                        this.moveBegin(realItem,false);
                        realItem.setTileXY(x,y);
                        this.moveEnd(realItem,false,false);
                        if(flipped != realItem.mIsFlipped)
                        {
                           realItem.flip();
                        }
                        isPlaced = true;
                        this.removeItem(realItem);
                        break;
                     }
                  }
               }
            }
         }
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_move_buffer");
         var bufferBar:BuildingBufferFacade;
         (bufferBar = InstanceMng.getUIFacade().getBuildingsBufferBar()).noLongerInitialState();
         bufferBar.reloadView();
         bufferBar.updateButtons();
         return 0;
      }
      
      public function checkItemInBuffer(item:WorldItemObject) : Boolean
      {
         var wio:WorldItemObject = null;
         var result:Boolean = false;
         for each(wio in this.mBuildingsBuffer)
         {
            if(wio == item)
            {
               result = true;
            }
         }
         return result;
      }
      
      public function cancelSelection() : void
      {
         InstanceMng.getUserInfoMng().getProfileLogin().setFlatbed(0);
         var wio:WorldItemObject = null;
         var allItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         var correction:int = 3;
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_move_buffer");
         for each(wio in allItems)
         {
            wio.viewReset();
            this.moveBegin(wio);
            wio.setTileXY(wio.getOldTileX(),wio.getOldTileY() + correction);
            this.moveEnd(wio,false,true);
            this.removeItem(wio);
            this.mItemsAmount[wio.mDef.getSku()] = 0;
            wio.moveEnd();
         }
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_cursor");
      }
      
      public function getBuildingAmount(item:String) : int
      {
         return this.mItemsAmount[item];
      }
      
      public function setItem(item:WorldItemObject) : void
      {
         if(item.mState.mStateId == 11)
         {
            item.viewLayersTypeRequiredSet(3,-1);
         }
         var bbController:BuildingsBufferController = InstanceMng.getBuildingsBufferController();
         InstanceMng.getToolsMng().setTool(16);
         InstanceMng.getToolsMng().getCurrentTool().moveBuildingForBuffer(bbController.getBuildingByTypeSku(item));
         bbController.removeItem(bbController.getBuildingByTypeSku(item));
         InstanceMng.getUIFacade().getBuildingsBufferBar().loadShop();
         InstanceMng.getMapViewPlanet().clearMap();
      }
      
      public function getBuildingByTypeSku(item:WorldItemObject) : WorldItemObject
      {
         var wio:WorldItemObject = null;
         for each(wio in this.mBuildingsBuffer)
         {
            if(wio.mDef.getSku() == item.mDef.getSku())
            {
               return wio;
            }
         }
         return null;
      }
      
      public function moveBegin(item:WorldItemObject, checkTool:Boolean = true) : void
      {
         if(item.mDef.isHeadQuarters())
         {
            if(item.umbrellaGetIsEnabled())
            {
               InstanceMng.getUmbrellaMng().moveUmbrellaBegin();
            }
         }
         if(checkTool)
         {
            InstanceMng.getToolsMng().getCurrentTool().cursorEnd();
            InstanceMng.getToolsMng().getCurrentTool().itemSelectedSetIsAllowed(false);
         }
         this.smMapController.mMapModel.placeUnplaceItem(item);
         item.moveBegin(false,true);
         if(checkTool)
         {
            InstanceMng.getToolsMng().getCurrentTool().cursorBegin();
         }
      }
      
      public function moveEnd(item:WorldItemObject, notifyServer:Boolean = false, onCancel:Boolean = false) : void
      {
         InstanceMng.getToolsMng().getCurrentTool().itemSelectedSetIsAllowed(true);
         item.moveEnd();
         var e:Object;
         (e = {}).cmd = "WorldEventPlaceItem";
         e.item = item;
         e.isForBuffer = true;
         e.subcmd = "RestoreItem";
         e.tileX = item.mTileRelativeX;
         e.tileY = item.mTileRelativeY;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorld(),e,true);
         if(onCancel && item.mDef.isHeadQuarters())
         {
            InstanceMng.getUmbrellaMng().moveUmbrellaEnd();
         }
      }
      
      public function isAnythingPlaced() : Boolean
      {
         var allItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         for each(var wio in allItems)
         {
            if(!wio.mDef.isAnObstacle() && !wio.isBeingMoved() && this.isItemInMap(wio))
            {
               return true;
            }
         }
         return false;
      }
      
      public function isItemAllowedInBuffer(item:WorldItemObject) : Boolean
      {
         var stateId:int = item.mState.mStateId;
         return stateId != 18 && stateId != 22 && stateId != 7 && stateId != 1;
      }
      
      public function convertSkuBasedItemsDataToItemArray(itemsData:Object) : Array
      {
         var itemsForThisSku:Array = null;
         var returnValue:Array = [];
         for(var sku in itemsData)
         {
            itemsForThisSku = itemsData[sku];
            for each(var item in itemsForThisSku)
            {
               returnValue.push({
                  "x":item["x"],
                  "y":item["y"],
                  "upgradeId":item["l"],
                  "isFlipped":item["f"],
                  "sku":sku
               });
            }
         }
         return returnValue;
      }
      
      public function convertItemsXMLListToSkuBasedItemsData(itemsXMLList:XMLList) : Object
      {
         var wioSku:String = null;
         var tileX:int = 0;
         var tileY:int = 0;
         var upgradeId:int = 0;
         var flipped:int = 0;
         var returnValue:Object = {};
         for each(var wioXML in itemsXMLList)
         {
            wioSku = EUtils.xmlReadString(wioXML,"sku");
            tileX = EUtils.xmlReadInt(wioXML,"x");
            tileY = EUtils.xmlReadInt(wioXML,"y");
            upgradeId = EUtils.xmlReadInt(wioXML,"upgradeId");
            flipped = EUtils.xmlReadInt(wioXML,"isFlipped");
            if(!returnValue.hasOwnProperty(wioSku))
            {
               returnValue[wioSku] = [];
            }
            returnValue[wioSku].push({
               "x":tileX,
               "y":tileY,
               "l":upgradeId,
               "f":flipped
            });
         }
         return returnValue;
      }
      
      public function deleteTemplateLocally(slotId:int) : void
      {
         var currentSlotId:int = 0;
         var templatesXML:XML;
         if((templatesXML = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_TEMPLATES)) == null)
         {
            return;
         }
         var dataHasChanged:Boolean = false;
         var newTotalTemplatesObject:Object = {"TemplateList":[]};
         for each(var template in EUtils.xmlGetChildrenList(templatesXML))
         {
            if((currentSlotId = EUtils.xmlReadInt(template,"slotId")) != slotId)
            {
               newTotalTemplatesObject["TemplateList"].push(Server.XMLToObject(template));
            }
            else
            {
               dataHasChanged = true;
            }
         }
         if(dataHasChanged)
         {
            InstanceMng.getUserDataMng().saveTemplatesLocally(newTotalTemplatesObject);
         }
      }
      
      public function saveTemplateLocally(slotId:int, itemsData:Object, templateUUID:String, doApply:Boolean) : void
      {
         if(itemsData == null && (templateUUID == null || templateUUID == ""))
         {
            return;
         }
         this.deleteTemplateLocally(slotId);
         var templatesXML:XML = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_TEMPLATES);
         var newTotalTemplatesArray:Array = [];
         var thisTemplateItemsArray:Array = this.convertSkuBasedItemsDataToItemArray(itemsData);
         if(templatesXML != null)
         {
            for each(var template in EUtils.xmlGetChildrenList(templatesXML))
            {
               newTotalTemplatesArray.push(Server.XMLToObject(template));
            }
         }
         newTotalTemplatesArray.push({
            "slotId":slotId,
            "id":templateUUID,
            "Items":thisTemplateItemsArray
         });
         InstanceMng.getUserDataMng().saveTemplatesLocally({"TemplateList":newTotalTemplatesArray});
         var popup:EPopupBufferTemplates;
         if((popup = InstanceMng.getPopupMng().getPopupOpened("PopupBufferTemplates") as EPopupBufferTemplates) != null && popup.isPopupBeingShown())
         {
            popup.updateExportCode(slotId,templateUUID);
         }
         if(doApply)
         {
            this.tryToApplyTemplate(itemsData);
         }
      }
   }
}
