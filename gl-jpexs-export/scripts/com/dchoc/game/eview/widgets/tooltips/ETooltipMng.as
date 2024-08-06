package com.dchoc.game.eview.widgets.tooltips
{
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.controller.tools.Tool;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.ERefineryPopup;
   import com.dchoc.game.eview.widgets.smallStructures.IconBarTime;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.powerups.PowerUpDef;
   import com.dchoc.game.model.rule.ProtectionTimeDef;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   import esparragon.events.EEvent;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class ETooltipMng extends DCComponent implements INotifyReceiver
   {
      
      private static var smInstance:ETooltipMng;
      
      private static var smInstanceAllow:Boolean = false;
      
      private static const Y_OFFSET:int = 10;
      
      private static const PLACE_POSITION_NONE:int = 0;
      
      private static const PLACE_POSITION_UNIVERSE:int = 1;
      
      private static const PLACE_POSITION_WIO:int = 2;
      
      private static const PLACE_POSITION_ALLIANCES:int = 3;
      
      private static const DEFAULT_SHOW_IMMEDIATELY:Boolean = true;
      
      private static const DEFAULT_ADD_CALLBACKS:Boolean = false;
       
      
      private var mCurrentTooltip:ETooltip;
      
      private var mContainerToTooltipInfoDictionary:Dictionary;
      
      private var mLastGlobalMouseX:Number;
      
      private var mLastGlobalMouseY:Number;
      
      public function ETooltipMng()
      {
         super();
         if(!smInstanceAllow)
         {
            throw new Error();
         }
         this.mContainerToTooltipInfoDictionary = new Dictionary();
         MessageCenter.getInstance().registerObject(this);
      }
      
      public static function getInstance() : ETooltipMng
      {
         if(!smInstance)
         {
            smInstanceAllow = true;
            smInstance = new ETooltipMng();
            smInstanceAllow = false;
         }
         return smInstance;
      }
      
      public static function getTooltipBodyForItemDef(itemDef:ItemsDef) : String
      {
         var tid:int = 0;
         var tooltipText:String = null;
         var powerup:PowerUpDef = null;
         var shieldSku:String = null;
         var shieldDef:ProtectionTimeDef = null;
         var timeValues:Array = null;
         var descText:* = itemDef.getDescToDisplay();
         var actionType:String = itemDef.getActionType();
         switch(actionType)
         {
            case "powerups":
               powerup = InstanceMng.getPowerUpDefMng().getDefBySku(itemDef.getActionParam(0)) as PowerUpDef;
               switch(powerup.getType())
               {
                  case "turretsExtraDamage":
                     tid = 1070;
                     break;
                  case "turretsExtraRange":
                     tid = 1073;
                     break;
                  case "turretsExtraHealth":
                     tid = 1076;
                     break;
                  default:
                     tid = 1070;
               }
               tooltipText = DCTextMng.replaceParameters(tid,[powerup.getExtra().toString() + "%",GameConstants.getTimeTextFromMs(powerup.getDuration(),false)]);
               break;
            case "shield":
               shieldSku = itemDef.getActionParam();
               timeValues = (shieldDef = InstanceMng.getProtectionTimeDefMng().getDefBySku(shieldSku) as ProtectionTimeDef).getTimeAsTexts();
               tooltipText = DCTextMng.replaceParameters(TextIDs[itemDef.getDescTID()],timeValues);
               descText = null;
               break;
            default:
               tooltipText = itemDef.getInfoToDisplay();
         }
         if(descText != null)
         {
            if(tooltipText.indexOf("_KEY_NOT_FOUND") == -1)
            {
               descText += "\n\n" + tooltipText;
            }
         }
         if(descText == null)
         {
            descText = tooltipText;
         }
         return descText;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(this.mCurrentTooltip)
         {
            this.mCurrentTooltip.logicUpdate(dt);
         }
      }
      
      public function showTooltip(tooltipInfo:ETooltipInfo, setAsCurrentTooltip:Boolean = true) : ETooltip
      {
         var tooltip:ETooltip = null;
         var behavior:EBehavior = null;
         var tooltipSimple:ETooltipSimple = null;
         var tooltipComplex:ETooltipComplex = null;
         var tooltipComplexIcons:ETooltipComplexWithIcons = null;
         var pointLeftTop:Point = null;
         var pointRightBottom:Point = null;
         var rect:Rectangle = null;
         if(tooltipInfo.type == 0)
         {
            (tooltipSimple = new ETooltipSimple()).build(tooltipInfo.text,tooltipInfo.textPropSku);
            tooltip = tooltipSimple;
         }
         else if(tooltipInfo.type == 1)
         {
            tooltipComplex = new ETooltipComplex();
            tooltipComplex.build(tooltipInfo);
            tooltip = tooltipComplex;
         }
         else if(tooltipInfo.type == 2)
         {
            (tooltipComplexIcons = new ETooltipComplexWithIcons()).build(tooltipInfo);
            tooltip = tooltipComplexIcons;
         }
         if(!tooltip)
         {
            return null;
         }
         var behaviorVec:Vector.<EBehavior> = tooltipInfo.getBehaviors();
         for each(behavior in behaviorVec)
         {
            tooltip.eAddEventBehavior("addedToStage",behavior);
         }
         if(tooltipInfo.espriteRef)
         {
            if(tooltipInfo.espriteRef.stage)
            {
               rect = tooltipInfo.espriteRef.getRect(tooltipInfo.espriteRef.stage);
               pointLeftTop = new Point(rect.left,rect.top);
               pointRightBottom = new Point(rect.right,rect.bottom);
            }
            else
            {
               pointRightBottom = (pointLeftTop = new Point(tooltipInfo.espriteRef.x,tooltipInfo.espriteRef.y)).clone().add(new Point(tooltipInfo.espriteRef.getLogicWidth(),tooltipInfo.espriteRef.getLogicHeight()));
            }
            if(tooltipInfo.anchorPoint == "center")
            {
               pointLeftTop.x += tooltip.getLogicWidth() >> 1;
            }
            tooltip.logicLeft = pointLeftTop.x + (tooltipInfo.espriteRef.getLogicWidth() - tooltip.getLogicWidth()) / 2;
            tooltip.logicTop = pointLeftTop.y - 10 - tooltip.getLogicHeight();
            if(pointLeftTop.y - 10 - tooltip.getLogicHeight() <= 0)
            {
               tooltip.logicTop = pointRightBottom.y + 10;
            }
            tooltip.setPivotLogicXY(0.5,0.5);
         }
         else
         {
            this.placeTooltip(tooltip,tooltipInfo);
         }
         if(setAsCurrentTooltip)
         {
            if(this.mCurrentTooltip)
            {
               this.removeTooltip(this.mCurrentTooltip);
               this.mCurrentTooltip.destroy();
            }
            this.mCurrentTooltip = tooltip;
         }
         InstanceMng.getViewMng().addChildToLayer(tooltip,InstanceMng.getViewMngGame().getTooltipLayerSku());
         InstanceMng.getViewFactory().arrangeToFitInMinimumScreen(tooltip,true);
         tooltip.setArrowVisible(true,tooltipInfo.espriteRef);
         return tooltip;
      }
      
      public function removeTooltip(tooltip:ETooltip) : ETooltip
      {
         InstanceMng.getViewMng().removeChildFromLayer(tooltip,InstanceMng.getViewMngGame().getTooltipLayerSku());
         return tooltip;
      }
      
      public function removeCurrentTooltip() : ETooltip
      {
         var tooltip:ETooltip = null;
         if(this.mCurrentTooltip)
         {
            tooltip = this.removeTooltip(this.mCurrentTooltip);
            tooltip.destroy();
            this.mCurrentTooltip = null;
         }
         return tooltip;
      }
      
      private function getPlacePositionId(action:String) : int
      {
         var returnValue:int = 0;
         if(GUIController.isASpyTooltip(action))
         {
            returnValue = 2;
         }
         else
         {
            switch(action)
            {
               case "TooltipWIOBuilt":
               case "TooltipWIORecollecting":
               case "TooltipWIOConstructing":
               case "TooltipWIOWaitingForDroid":
               case "TooltipWIORepairing":
                  returnValue = 2;
                  break;
               case "TooltipAllianceCouncil":
               case "TooltipEmbassy":
                  returnValue = 3;
            }
         }
         return returnValue;
      }
      
      private function placeTooltip(tooltip:ETooltip, tooltipInfo:ETooltipInfo) : void
      {
         var tooltipY:Number = NaN;
         var container:ESprite = null;
         var point:Point = null;
         var posX:Number = NaN;
         var posY:Number = NaN;
         var upperCorner:DCCoordinate = null;
         var stageWidth:Number = InstanceMng.getApplication().stageGetWidth();
         var tooltipWidth:Number = tooltip.getLogicWidth();
         var tooltipHeight:Number = tooltip.getLogicHeight();
         var tooltipX:* = 0;
         tooltipY = 0;
         var offsetX:Number = 0;
         var offsetY:Number = 0;
         var mViewMngrGame:ViewMngrGame = InstanceMng.getViewMngGame();
         var positionId:int = this.getPlacePositionId(tooltipInfo.getParam("action") as String);
         var worldItemObject:WorldItemObject = tooltipInfo.getParam("wio") as WorldItemObject;
         var starObject:DisplayObjectContainer = tooltipInfo.getParam("starObject") as DisplayObjectContainer;
         if(!worldItemObject)
         {
            positionId = 1;
         }
         switch(positionId - 1)
         {
            case 0:
               tooltipX = starObject.stage.mouseX + tooltip.getLogicWidth() * 0.55;
               tooltipY = starObject.stage.mouseY + tooltip.getLogicHeight() * 0.55;
               tooltip.logicX = tooltipX;
               tooltip.logicY = tooltipY;
               break;
            case 1:
               upperCorner = new DCCoordinate();
               worldItemObject.getCornerUpLeftWorldViewPos(upperCorner);
               mViewMngrGame.worldToScreen(upperCorner);
               tooltipX = upperCorner.x;
               tooltipY = upperCorner.y - tooltipHeight * 0.75;
               tooltip.logicX = tooltipX;
               tooltip.logicY = tooltipY;
               break;
            case 2:
               container = tooltipInfo.espriteRef;
               point = new Point(0,0);
               posX = (point = container.localToGlobal(point)).x;
               posY = point.y;
               tooltipX = posX;
               tooltipY = posY - tooltipHeight / 2;
               tooltip.logicX = tooltipX;
               tooltip.logicY = tooltipY;
         }
         tooltip.setPivotLogicXY(0.5,0.5);
         if((offsetY = tooltipY - tooltipHeight) < 0)
         {
            tooltip.logicY = tooltipY - offsetY;
            offsetX = tooltipX >= stageWidth / 2 ? tooltipX - tooltipWidth / 1.5 : tooltipX + tooltipWidth / 1.5;
            tooltip.logicX = offsetX;
         }
      }
      
      public function createTooltipInfoFromText(text:String, container:*, anchorPoint:String = null, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).anchorPoint = !!anchorPoint ? anchorPoint : "top_left";
         tooltipInfo.text = text;
         tooltipInfo.espriteRef = container;
         tooltipInfo.type = 0;
         this.addToDictionary(tooltipInfo,container,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipInfoFromDef(def:DCDef, container:*, anchorPoint:String = null, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var secondText:String = def.getInfoToDisplay();
         var descText:String = def.getDescToDisplay();
         if(secondText.indexOf("_KEY_NOT_FOUND") == -1)
         {
            descText += "\n\n" + secondText;
         }
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).title = def.getNameToDisplay().toUpperCase();
         tooltipInfo.text = descText;
         tooltipInfo.textPropSku = "text_tooltip";
         tooltipInfo.espriteRef = container;
         tooltipInfo.type = 1;
         tooltipInfo.anchorPoint = !!anchorPoint ? anchorPoint : "top_left";
         this.addToDictionary(tooltipInfo,container,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipInfoFromTexts(title:String, text:String, container:*, anchorPoint:String = null, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).title = title;
         tooltipInfo.text = text;
         tooltipInfo.textPropSku = "text_tooltip";
         tooltipInfo.espriteRef = container;
         tooltipInfo.type = 1;
         tooltipInfo.anchorPoint = !!anchorPoint ? anchorPoint : "top_left";
         this.addToDictionary(tooltipInfo,container,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipInfoFromShipDefForBuilding(def:ShipDef, container:*, anchorPoint:String = null, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var infoText:String = def.getInfoToDisplay();
         var descText:String = def.getDescToDisplay();
         var buildTime:String = GameConstants.getTimeTextFromMs(def.getConstructionTime());
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).title = def.getNameToDisplay().toUpperCase();
         tooltipInfo.textPropSku = "text_tooltip";
         tooltipInfo.espriteRef = container;
         tooltipInfo.type = 2;
         tooltipInfo.anchorPoint = !!anchorPoint ? anchorPoint : "top_left";
         tooltipInfo.addElementIconTwoTexts("icon_clock",DCTextMng.getText(544),buildTime,"text_body_3");
         tooltipInfo.addElementText(infoText,"text_body_3");
         this.addToDictionary(tooltipInfo,container,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipInfoFromShipDef(def:ShipDef, container:*, anchorPoint:String = null, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var dmgText:String = null;
         var resourceIcon:String = null;
         var text:String = null;
         var infoText:String = def.getInfoToDisplay();
         var descText:String = def.getDescToDisplay();
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).title = def.getNameToDisplay().toUpperCase();
         tooltipInfo.textPropSku = "text_tooltip";
         tooltipInfo.espriteRef = container;
         tooltipInfo.type = 2;
         tooltipInfo.anchorPoint = !!anchorPoint ? anchorPoint : "top_left";
         tooltipInfo.beginBlockOfElements("ship_column");
         tooltipInfo.addElementIconTwoTexts("icon_health",DCTextMng.getText(543),"" + def.getMaxEnergy(),"text_body_3");
         if(def.getShotDamage() > 0)
         {
            dmgText = def.getShotDamage().toString();
            if(def.getShotBurstLength() > 1)
            {
               dmgText = String(def.getShotDamage()) + " X" + String(def.getShotBurstLength());
            }
            tooltipInfo.addElementIconTwoTexts("icon_damage",DCTextMng.getText(539),dmgText,"text_body_3");
         }
         else
         {
            tooltipInfo.addElementIconTwoTexts("icon_heal",DCTextMng.getText(712),(-def.getShotDamage()).toString(),"text_body_3");
         }
         text = DCTextMng.getText(542);
         resourceIcon = "icon_damage_type_shot";
         if(def.getBlastRadius() > 0)
         {
            text = DCTextMng.getText(541);
            resourceIcon = "icon_damage_type_blast";
         }
         if(def.getShotBurstLength() > 1)
         {
            text = DCTextMng.getText(4094);
            resourceIcon = "icon_damage_type_shot";
         }
         tooltipInfo.addElementIconTwoTexts(resourceIcon,DCTextMng.getText(540),text,"text_body_3");
         switch(def.getShotPriorityTarget())
         {
            case "anything":
               text = DCTextMng.getText(177);
               break;
            case "walls":
               text = DCTextMng.getText(174);
               break;
            case "defenses":
               text = DCTextMng.getText(176);
               break;
            case "resources":
               text = DCTextMng.getText(175);
         }
         tooltipInfo.addElementIconTwoTexts("icon_target",DCTextMng.getText(172),text,"text_body_3");
         tooltipInfo.endBlockOfElements();
         this.addToDictionary(tooltipInfo,container,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipInfoFromWorldItemDef(def:WorldItemDef, container:*, anchorPoint:String = null, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var coinsStorageStr:String = null;
         var mineralsStorageStr:String = null;
         var infoText:String = def.getInfoToDisplay();
         var descText:String = def.getDescToDisplay();
         var buildTime:String = GameConstants.getTimeTextFromMs(def.getConstructionTime());
         var resourceType:int = def.getTypeId();
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).title = def.getNameToDisplay().toUpperCase();
         tooltipInfo.textPropSku = "text_tooltip";
         tooltipInfo.espriteRef = container;
         tooltipInfo.type = 2;
         tooltipInfo.anchorPoint = !!anchorPoint ? anchorPoint : "top_left";
         switch(resourceType)
         {
            case 0:
            case 1:
            case 2:
            case 3:
            case 6:
            case 7:
            case 8:
            case 9:
               tooltipInfo.beginBlockOfElements("row");
               if(def.getShotDamage() > 0)
               {
                  tooltipInfo.addElementIconText("icon_damage",def.getShotDamage().toString(),"text_title_3");
               }
               if(def.getMaxEnergy() > 0)
               {
                  tooltipInfo.addElementIconText("icon_health",def.getMaxEnergy().toString(),"text_title_3");
               }
               tooltipInfo.endBlockOfElements();
         }
         tooltipInfo.beginBlockOfElements("column");
         if(resourceType != 4 && def.getConstructionTime() > 1000)
         {
            tooltipInfo.addElementIconTwoTexts("icon_clock",DCTextMng.getText(4101),buildTime,"text_title_3");
         }
         var incomePerMinuteStr:String = def.getIncomePerMinute() + "/" + DCTextMng.getText(46);
         var incomeCapacityStr:String = "+ " + DCTextMng.convertNumberToString(def.getIncomeCapacity(),1,5);
         switch(resourceType)
         {
            case 0:
               tooltipInfo.addElementIconTwoTexts("icon_coin",DCTextMng.getText(547),incomePerMinuteStr,"text_title_3");
               tooltipInfo.addElementFillbarIcon("icon_coins",50,100,DCTextMng.getText(548),incomeCapacityStr);
               break;
            case 1:
               tooltipInfo.addElementIconTwoTexts("icon_mineral",DCTextMng.getText(547),incomePerMinuteStr,"text_title_3");
               tooltipInfo.addElementFillbarIcon("icon_minerals",50,100,DCTextMng.getText(548),incomeCapacityStr);
               break;
            case 2:
               coinsStorageStr = "+" + def.getCoinsStorage().toString();
               mineralsStorageStr = "+" + def.getMineralsStorage().toString();
               if(def.getCoinsStorage())
               {
                  tooltipInfo.addElementIconText("icon_bag_coins",coinsStorageStr,"text_coins");
                  break;
               }
               tooltipInfo.addElementIconText("icon_bag_minerals",mineralsStorageStr,"text_minerals");
               break;
            case 3:
            case 6:
            case 7:
            case 8:
            case 9:
               tooltipInfo.addElementText(infoText,"text_body_3");
               break;
            case 4:
               tooltipInfo.text = descText;
         }
         tooltipInfo.endBlockOfElements();
         this.addToDictionary(tooltipInfo,container,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipForMissionProgress(target:DCTarget, container:*, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var i:int = 0;
         var miniTargetProgStr:String = null;
         var totalProgStr:String = null;
         var mainText:String = null;
         var miniTargetProgress:int = 0;
         var targetDef:DCTargetDef = target.getDef();
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).title = DCTextMng.getText(TextIDs[targetDef.getTargetTitle()]).toUpperCase();
         tooltipInfo.type = 1;
         tooltipInfo.espriteRef = container;
         tooltipInfo.text = "";
         var numElems:int = targetDef.getNumMinitargetsFound();
         for(i = 0; i < numElems; )
         {
            mainText = targetDef.getMiniTargetBody(i);
            if(i)
            {
               tooltipInfo.text += "\n";
            }
            tooltipInfo.text += DCTextMng.getText(TextIDs[mainText]);
            miniTargetProgress = InstanceMng.getTargetMng().getProgress(targetDef.mSku,i);
            miniTargetProgStr = DCTextMng.convertNumberToString(miniTargetProgress,1,4,true);
            totalProgStr = DCTextMng.convertNumberToString(targetDef.getMiniTargetAmount(i),1,4);
            tooltipInfo.text = tooltipInfo.text + "  " + miniTargetProgStr + "/" + totalProgStr;
            i++;
         }
         tooltipInfo.textPropSku = "text_body_3";
         this.addToDictionary(tooltipInfo,container,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipForSpecialMapObject(title:String, building:DisplayObjectContainer, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).title = title;
         tooltipInfo.type = 1;
         tooltipInfo.text = InstanceMng.getFlowState().getCurrentRoleId() == 3 ? "" : DCTextMng.getText(169);
         tooltipInfo.textPropSku = "text_positive";
         tooltipInfo.bkgPropSku = "tooltip_bkg_wio";
         tooltipInfo.setParam("starObject",building);
         this.addToDictionary(tooltipInfo,building,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipForStarDisplayObject(text:String, starObject:DisplayObjectContainer, addCallbacks:Boolean = false, showImmediately:Boolean = true) : ETooltipInfo
      {
         var tooltipInfo:ETooltipInfo;
         (tooltipInfo = new ETooltipInfo()).type = 0;
         tooltipInfo.text = text;
         tooltipInfo.setParam("starObject",starObject);
         this.addToDictionary(tooltipInfo,starObject,addCallbacks);
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      public function createTooltipForUIAction(action:String, worldItemObject:WorldItemObject, showImmediately:Boolean = true) : ETooltipInfo
      {
         var unitInfoVector:* = undefined;
         var MAX_PER_ROW:int = 0;
         var unitsInRow:int = 0;
         var customPadding:int = 0;
         var hangar:Hangar = null;
         var bunker:Bunker = null;
         var incomeAmount:Number = NaN;
         var maxIncome:Number = NaN;
         var tooltipText:int = 0;
         var resourceIDWIORecolecting:String = null;
         var resourceIconId:String = null;
         var profileLogin:Profile = null;
         var resourceIconStr:String = null;
         var world:World = null;
         var sid:String = null;
         var coins:Number = NaN;
         var minerals:Number = NaN;
         var total:Number = NaN;
         var icon:String = null;
         var incomeAmountTxt:String = null;
         var textPropSku:String = null;
         var storageStr:String = null;
         var dmg:int = 0;
         var energy:int = 0;
         var curCapacity:int = 0;
         var maxCapacity:int = 0;
         var slowdownTime:Number = NaN;
         var slowdownSpeed:Number = NaN;
         var slowdownRate:Number = NaN;
         var shipyard:Shipyard = null;
         var shipUnderConstruction:String = null;
         var textId:int = 0;
         var resourceType:int = worldItemObject.mDef.getTypeId();
         var tooltipInfo:ETooltipInfo = new ETooltipInfo();
         var spyType:int = worldItemObject.spyGetSpyStateType();
         tooltipInfo.title = worldItemObject.mDef.getNameToDisplay();
         tooltipInfo.type = 2;
         tooltipInfo.textPropSku = "text_tooltip";
         tooltipInfo.blockVerticalPadding = 1;
         tooltipInfo.bkgPropSku = "tooltip_bkg_wio";
         tooltipInfo.setParam("action",action);
         tooltipInfo.setParam("wio",worldItemObject);
         var isVisiting:*;
         if(isVisiting = InstanceMng.getFlowState().getCurrentRoleId() == 1)
         {
            tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,564,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
         }
         else
         {
            if(resourceType != 12 && resourceType != 4)
            {
               tooltipInfo.addElementText(DCTextMng.replaceParameters(136,[worldItemObject.mUpgradeId + 1]),"text_title_3");
            }
            tooltipInfo.beginBlockOfElements("column");
            switch(action)
            {
               case "TooltipWIORepairing":
               case "TooltipWIOConstructing":
                  tooltipInfo.addElementFillbarTime("icon_clock",this.onUpdateWIOTooltipTime,[worldItemObject]);
                  break;
               case "TooltipWIORecollecting":
                  resourceType = worldItemObject.mDef.getTypeId();
                  incomeAmount = worldItemObject.getIncomeAmount();
                  maxIncome = worldItemObject.mDef.getIncomeCapacity();
                  tooltipText = 559;
                  resourceIDWIORecolecting = "text_positive";
                  resourceIconId = "icon_coins";
                  if(worldItemObject.mDef.getIncomeCurrencyId() == 2)
                  {
                     resourceIconId = "icon_minerals";
                  }
                  tooltipInfo.endBlockOfElements();
                  if(incomeAmount != maxIncome)
                  {
                     tooltipInfo.addElementFillbarTime(resourceIconId,this.onUpdateWIOTooltipTime,[worldItemObject]);
                  }
                  else
                  {
                     incomeAmountTxt = maxIncome.toString();
                     if(worldItemObject.hasCollectionBonus())
                     {
                        incomeAmountTxt += worldItemObject.getCollectionBonusText(true);
                     }
                     tooltipInfo.addElementIconText(resourceIconId,incomeAmountTxt,"text_title_3");
                  }
                  tooltipInfo.beginBlockOfElements("column");
                  profileLogin = InstanceMng.getUserInfoMng().getProfileLogin();
                  switch(resourceType)
                  {
                     case 0:
                     case 2:
                        if(!profileLogin.wouldCoinsFit(incomeAmount))
                        {
                           if(InstanceMng.getToolsMng().getCurrentToolId() == 0)
                           {
                              resourceIDWIORecolecting = "text_light_negative";
                           }
                           tooltipText = 222;
                        }
                        break;
                     case 1:
                        if(!profileLogin.wouldMineralsFit(incomeAmount))
                        {
                           if(InstanceMng.getToolsMng().getCurrentToolId() == 0)
                           {
                              resourceIDWIORecolecting = "text_light_negative";
                           }
                           tooltipText = 222;
                           break;
                        }
                  }
                  tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,tooltipText,worldItemObject),resourceIDWIORecolecting);
                  break;
               case "TooltipWIOBuilt":
                  switch(resourceType - 2)
                  {
                     case 0:
                        resourceIconStr = !!worldItemObject.mDef.getCoinsStorage() ? "icon_bag_coins" : "icon_bag_minerals";
                        textPropSku = !!worldItemObject.mDef.getCoinsStorage() ? "text_coins" : "text_minerals";
                        storageStr = "+ " + (!!worldItemObject.mDef.getCoinsStorage() ? GameConstants.convertNumberToStringUseDecimals(worldItemObject.mDef.getCoinsStorage()) : GameConstants.convertNumberToStringUseDecimals(worldItemObject.mDef.getMineralsStorage()));
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("row");
                        tooltipInfo.addElementIconText(resourceIconStr,storageStr,textPropSku);
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("column");
                        tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,52,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("row");
                        if(worldItemObject.mDef.isASiloOfCoins())
                        {
                           incomeAmount = InstanceMng.getWorldItemObjectController().getAmountOfCollectableResources(0);
                           tooltipInfo.addElementIconText("icon_coins","+ " + DCTextMng.convertNumberToString(incomeAmount,-1,-1),"text_coins");
                        }
                        else if(worldItemObject.mDef.isASiloOfMinerals())
                        {
                           incomeAmount = InstanceMng.getWorldItemObjectController().getAmountOfCollectableResources(1);
                           tooltipInfo.addElementIconText("icon_minerals","+ " + DCTextMng.convertNumberToString(incomeAmount,-1,-1),"text_minerals");
                        }
                        break;
                     case 1:
                        shipyard = InstanceMng.getShipyardController().getShipyard(worldItemObject.mSid);
                        textId = 558;
                        if(shipyard != null)
                        {
                           if((shipUnderConstruction = shipyard.getProducingElementSku()) != null)
                           {
                              tooltipInfo.addElementFillbarTime("icon_clock",this.onUpdateWIOTooltipTime,[worldItemObject]);
                           }
                        }
                        tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,textId,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        break;
                     case 2:
                     case 10:
                        if(worldItemObject.mDef.belongsToGroup("play"))
                        {
                           tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,564,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                           break;
                        }
                        tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,52,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        break;
                     case 3:
                        if(worldItemObject.mDef.isHeadQuarters())
                        {
                           tooltipInfo.endBlockOfElements();
                           tooltipInfo.beginBlockOfElements("row");
                           tooltipInfo.addElementIconText("icon_bag_coins","+ " + GameConstants.convertNumberToStringUseDecimals(worldItemObject.mDef.getCoinsStorage()),"text_coins");
                           tooltipInfo.addElementIconText("icon_bag_minerals","+ " + GameConstants.convertNumberToStringUseDecimals(worldItemObject.mDef.getMineralsStorage()),"text_minerals");
                           tooltipInfo.endBlockOfElements();
                           tooltipInfo.beginBlockOfElements("column");
                           tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,52,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        }
                        break;
                     case 4:
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("column");
                        if((dmg = InstanceMng.getPowerUpMng().unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(worldItemObject.mDef.mSku,1,"turretsExtraDamage",worldItemObject.mDef.getShotDamage())) > 0)
                        {
                           tooltipInfo.addElementIconText("icon_damage",DCTextMng.convertNumberToString(dmg,-1,-1),"text_title_3");
                        }
                        else
                        {
                           slowdownTime = worldItemObject.mDef.shotEffectsGetSlowDownTime();
                           slowdownSpeed = worldItemObject.mDef.shotEffectsGetSlowDownSpeedPercent();
                           slowdownRate = worldItemObject.mDef.shotEffectsGetSlowDownRatePercent();
                           if(slowdownTime > 0)
                           {
                              tooltipInfo.addElementIconText("icon_clock",GameConstants.getTimeTextFromMs(slowdownTime),"text_title_3");
                              if(slowdownSpeed > 0)
                              {
                                 tooltipInfo.addElementIconText("icon_speed","-" + String(slowdownSpeed) + "%","text_title_3");
                              }
                              if(slowdownRate > 0)
                              {
                                 tooltipInfo.addElementIconText("icon_rate","-" + String(slowdownRate) + "%","text_title_3");
                              }
                           }
                        }
                        if((energy = worldItemObject.mDef.getMaxEnergy()) > 0)
                        {
                           tooltipInfo.addElementIconText("icon_health",DCTextMng.convertNumberToString(energy,-1,-1),"text_title_3");
                        }
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("column");
                        tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,textId,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        break;
                     case 5:
                        curCapacity = (hangar = InstanceMng.getHangarControllerMng().getHangarController().getFromSid(worldItemObject.mSid)).getCapacityOccupied();
                        maxCapacity = hangar.getMaxCapacity();
                        tooltipInfo.addElementFillbarIcon("icon_hangar",curCapacity,maxCapacity,DCTextMng.getText(548),curCapacity + "/" + maxCapacity);
                        tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,169,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        break;
                     case 6:
                        curCapacity = (bunker = InstanceMng.getBunkerController().getFromSid(worldItemObject.mSid) as Bunker).getCapacityOccupied();
                        maxCapacity = bunker.getMaxCapacity();
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("row");
                        tooltipInfo.addElementIconText("icon_range",DCTextMng.convertNumberToString(worldItemObject.mDef.getShotDistance(),-1,-1),"text_title_3");
                        tooltipInfo.addElementIconText("icon_health",DCTextMng.convertNumberToString(worldItemObject.mDef.getMaxEnergy(),-1,-1),"text_title_3");
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("column");
                        tooltipInfo.addElementFillbarIcon("icon_hangar",curCapacity,maxCapacity,DCTextMng.getText(548),curCapacity + "/" + maxCapacity);
                        tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,169,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        break;
                     case 7:
                        if(worldItemObject.mDef.belongsToGroup("observatory"))
                        {
                           tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,560,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        }
                        else
                        {
                           if(worldItemObject.mDef.isARefinery())
                           {
                              if(ERefineryPopup.getRemainingTime() > 0 && ERefineryPopup.getCurrentSku() != null)
                              {
                                 icon = InstanceMng.getItemsMng().getItemObjectBySku(ERefineryPopup.getCurrentSku()).mDef.getAssetId();
                                 tooltipInfo.addElementFillbarTime(icon,this.onUpdateWIOTooltipTime,[worldItemObject]);
                              }
                           }
                           else if(worldItemObject.mDef.isALaboratory())
                           {
                              if(InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradingUnit() != null)
                              {
                                 icon = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradingUnit().mDef.getIcon();
                                 tooltipInfo.addElementFillbarTime(icon,this.onUpdateWIOTooltipTime,[worldItemObject]);
                              }
                           }
                           tooltipInfo.addElementText(this.getTooltipInfoToolDepending(action,558,worldItemObject),this.getTooltipInfoToolPropSkuDepending(action,worldItemObject));
                        }
                  }
                  break;
               case "TooltipWIOSpyDefault":
                  break;
               case "TooltipWIOSpyBunker":
                  if(hangar = InstanceMng.getHangarControllerMng().getHangarController().getFromSid(worldItemObject.mSid))
                  {
                     tooltipInfo.addElementFillbarIcon("icon_hangar",hangar.getCapacityOccupied(),hangar.getMaxCapacity(),DCTextMng.getText(548),hangar.getCapacityOccupied() + "/" + hangar.getMaxCapacity());
                  }
                  if((bunker = InstanceMng.getBunkerController().getFromSid(worldItemObject.mSid) as Bunker) != null)
                  {
                     tooltipInfo.endBlockOfElements();
                     tooltipInfo.beginBlockOfElements("row");
                     tooltipInfo.addElementIconText("icon_range",DCTextMng.convertNumberToString(worldItemObject.mDef.getShotDistance(),-1,-1),"text_title_3");
                     tooltipInfo.addElementIconText("icon_health",DCTextMng.convertNumberToString(worldItemObject.mDef.getMaxEnergy(),-1,-1),"text_title_3");
                     tooltipInfo.endBlockOfElements();
                     tooltipInfo.beginBlockOfElements("column");
                     tooltipInfo.addElementFillbarIcon("icon_hangar",bunker.getCapacityOccupied(),bunker.getMaxCapacity(),DCTextMng.getText(548),bunker.getCapacityOccupied() + "/" + bunker.getMaxCapacity());
                     if(spyType == 1)
                     {
                        tooltipInfo.endBlockOfElements();
                        tooltipInfo.beginBlockOfElements("row");
                        unitInfoVector = bunker.getWarUnitsInfoAsVector();
                        MAX_PER_ROW = 4;
                        unitsInRow = 0;
                        for each(var unitInfo in unitInfoVector)
                        {
                           if(unitsInRow >= MAX_PER_ROW)
                           {
                              tooltipInfo.endBlockOfElements();
                              tooltipInfo.beginBlockOfElements("row");
                              unitsInRow = 0;
                           }
                           customPadding = unitsInRow == MAX_PER_ROW - 1 ? 13 : -13 * unitsInRow;
                           tooltipInfo.addElementIconUnit(unitInfo[0],unitInfo[2],unitInfo[3],60,customPadding);
                           unitsInRow++;
                        }
                     }
                  }
                  break;
               case "TooltipWIOSpyDefense":
                  if((dmg = InstanceMng.getPowerUpMng().unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(worldItemObject.mDef.mSku,1,"turretsExtraDamage",worldItemObject.mDef.getShotDamage())) > 0)
                  {
                     tooltipInfo.addElementIconText("icon_damage",DCTextMng.convertNumberToString(dmg,-1,-1),"text_title_3");
                  }
                  else
                  {
                     slowdownTime = worldItemObject.mDef.shotEffectsGetSlowDownTime();
                     slowdownSpeed = worldItemObject.mDef.shotEffectsGetSlowDownSpeedPercent();
                     slowdownRate = worldItemObject.mDef.shotEffectsGetSlowDownRatePercent();
                     if(slowdownTime > 0)
                     {
                        tooltipInfo.addElementIconText("icon_clock",GameConstants.getTimeTextFromMs(slowdownTime),"text_title_3");
                        if(slowdownSpeed > 0)
                        {
                           tooltipInfo.addElementIconText("icon_speed","-" + String(slowdownSpeed) + "%","text_title_3");
                        }
                        if(slowdownRate > 0)
                        {
                           tooltipInfo.addElementIconText("icon_rate","-" + String(slowdownRate) + "%","text_title_3");
                        }
                     }
                  }
                  if((energy = worldItemObject.mDef.getMaxEnergy()) > 0)
                  {
                     tooltipInfo.addElementIconText("icon_health",DCTextMng.convertNumberToString(energy,-1,-1),"text_title_3");
                  }
                  break;
               case "TooltipWIOSpyResourceCoins":
               case "TooltipWIOSpyResourceMinerals":
               case "TooltipWIOSpySiloCoins":
               case "TooltipWIOSpySiloMinerals":
                  if(spyType == 1)
                  {
                     world = InstanceMng.getWorld();
                     sid = worldItemObject.mSid;
                     coins = world.lootGetMaxCoinsBySid(sid);
                     minerals = world.lootGetMaxMineralsBySid(sid);
                     total = coins + minerals;
                     icon = action == "TooltipWIOSpyResourceCoins" || action == "TooltipWIOSpySiloCoins" ? "icon_coins" : "icon_minerals";
                     tooltipInfo.addElementIconText(icon,DCTextMng.convertNumberToString(total,-1,-1),"text_title_3");
                  }
                  break;
               case "TooltipWIOSpyHQ":
                  if(spyType == 1)
                  {
                     world = InstanceMng.getWorld();
                     sid = worldItemObject.mSid;
                     coins = world.lootGetMaxCoinsBySid(sid);
                     minerals = world.lootGetMaxMineralsBySid(sid);
                     tooltipInfo.addElementIconText("icon_minerals",DCTextMng.convertNumberToString(minerals,-1,-1),"text_title_3");
                     tooltipInfo.addElementIconText("icon_coins",DCTextMng.convertNumberToString(coins,-1,-1),"text_title_3");
                  }
            }
            tooltipInfo.endBlockOfElements();
         }
         if(showImmediately)
         {
            this.showTooltip(tooltipInfo);
         }
         return tooltipInfo;
      }
      
      private function getTooltipInfoToolDepending(tooltipType:String, defaultText:int, worldItem:WorldItemObject) : String
      {
         var currRoleId:int = 0;
         var incomeAmount:Number = NaN;
         var actionsLeft:int = 0;
         var tool:Tool;
         var toolId:int = (tool = InstanceMng.getMapControllerPlanet().uiGetTool()).mId;
         var text:String = "";
         var textPropSku:String = "text_positive";
         var toolActionId:int;
         switch((toolActionId = tool.getToolActionId(worldItem)) - 7)
         {
            case 0:
               if(tooltipType == "TooltipWIOConstructing")
               {
                  toolId = 0;
                  break;
               }
               toolId = 1;
               break;
            case 2:
               toolId = 8;
         }
         switch(toolId)
         {
            case 0:
               text = DCTextMng.getText(defaultText);
               if(worldItem.getIncomeAmount() != 0)
               {
                  text = DCTextMng.getText(defaultText);
               }
               else if(tooltipType == "TooltipWIORecollecting")
               {
                  text = "";
               }
               if(worldItem.mDef.isHeadQuarters())
               {
                  if(worldItem.mDroidLabourId == 1)
                  {
                     text = DCTextMng.getText(558);
                  }
                  else
                  {
                     text = DCTextMng.getText(569);
                  }
               }
               else if(worldItem.mDef.isASilo())
               {
                  text = DCTextMng.getText(567);
                  if(worldItem.mDef.isASiloOfCoins())
                  {
                     incomeAmount = InstanceMng.getWorldItemObjectController().getAmountOfCollectableResources(0);
                     if(!InstanceMng.getUserInfoMng().getProfileLogin().wouldCoinsFit(incomeAmount))
                     {
                        text = DCTextMng.getText(222);
                     }
                  }
                  else if(worldItem.mDef.isASiloOfMinerals())
                  {
                     incomeAmount = InstanceMng.getWorldItemObjectController().getAmountOfCollectableResources(1);
                     if(!InstanceMng.getUserInfoMng().getProfileLogin().wouldMineralsFit(incomeAmount))
                     {
                        text = DCTextMng.getText(222);
                     }
                  }
               }
               if((currRoleId = InstanceMng.getFlowStatePlanet().getCurrentRoleId()) == 1)
               {
                  if((actionsLeft = InstanceMng.getVisitorMng().getAmountActionsLeft()) > 0)
                  {
                     text = DCTextMng.getText(568);
                  }
                  else
                  {
                     text = DCTextMng.getText(244);
                     textPropSku = "text_light_negative";
                  }
               }
               break;
            case 1:
               text = DCTextMng.getText(561);
               break;
            case 5:
            case 16:
               text = DCTextMng.getText(562);
               break;
            case 6:
               text = DCTextMng.getText(563);
               break;
            case 8:
               if(worldItem.canBeUpgraded() && worldItem.canStateBeUpgraded())
               {
                  text = DCTextMng.getText(560);
               }
               else if(worldItem.hasSeveralUpgrades())
               {
                  text = DCTextMng.getText(590);
               }
               else
               {
                  text = DCTextMng.getText(591);
               }
         }
         return text;
      }
      
      private function getTooltipInfoToolPropSkuDepending(tooltipType:String, worldItem:WorldItemObject) : String
      {
         var currRoleId:int = 0;
         var actionsLeft:int = 0;
         var incomeAmount:Number = NaN;
         var tool:Tool;
         var toolId:int = (tool = InstanceMng.getMapControllerPlanet().uiGetTool()).mId;
         var textPropSku:String = "text_positive";
         var toolActionId:int;
         switch((toolActionId = tool.getToolActionId(worldItem)) - 7)
         {
            case 0:
               if(tooltipType == "TooltipWIOConstructing")
               {
                  toolId = 0;
                  break;
               }
               toolId = 1;
               break;
            case 2:
               toolId = 8;
         }
         switch(toolId)
         {
            case 0:
               if((currRoleId = InstanceMng.getFlowStatePlanet().getCurrentRoleId()) == 1)
               {
                  if((actionsLeft = InstanceMng.getVisitorMng().getAmountActionsLeft()) < 1)
                  {
                     textPropSku = "text_light_negative";
                  }
                  break;
               }
               if(worldItem.mDef.isASilo())
               {
                  if(worldItem.mDef.isASiloOfCoins())
                  {
                     incomeAmount = InstanceMng.getWorldItemObjectController().getAmountOfCollectableResources(0);
                     if(!InstanceMng.getUserInfoMng().getProfileLogin().wouldCoinsFit(incomeAmount))
                     {
                        textPropSku = "text_light_negative";
                     }
                     break;
                  }
                  if(worldItem.mDef.isASiloOfMinerals())
                  {
                     incomeAmount = InstanceMng.getWorldItemObjectController().getAmountOfCollectableResources(1);
                     if(!InstanceMng.getUserInfoMng().getProfileLogin().wouldMineralsFit(incomeAmount))
                     {
                        textPropSku = "text_light_negative";
                     }
                  }
               }
               break;
         }
         return textPropSku;
      }
      
      private function addToDictionary(tooltipInfo:ETooltipInfo, container:*, addCallbacks:Boolean) : void
      {
         var eContainer:ESprite = null;
         if(container)
         {
            this.mContainerToTooltipInfoDictionary[container] = tooltipInfo;
            if(addCallbacks)
            {
               if(eContainer = container as ESprite)
               {
                  eContainer.eAddEventListener("rollOver",this.onTooltipComplexEBoxOver);
                  eContainer.eAddEventListener("rollOut",this.onTooltipComplexEBoxOut);
               }
               else
               {
                  container.addEventListener("rollOver",this.onTooltipComplexBoxOver,false,0,true);
                  container.addEventListener("rollOut",this.onTooltipComplexBoxOut,false,0,true);
                  container.addEventListener("mouseMove",this.onMouseMove);
               }
            }
         }
         else
         {
            DCDebug.traceCh("ERROR","ETooltipMng::addToDictionary attempted to add a tooltipInfo when the container is null");
         }
      }
      
      public function destroyTooltipFromContainer(container:*) : ETooltipInfo
      {
         var esprite:ESprite = null;
         var tooltip:ETooltipInfo = this.mContainerToTooltipInfoDictionary[container];
         if(this.mContainerToTooltipInfoDictionary[container] != undefined)
         {
            delete this.mContainerToTooltipInfoDictionary[container];
            esprite = container as ESprite;
            if(esprite)
            {
               container.eRemoveEventListener("rollOver",this.onTooltipComplexEBoxOver);
               container.eRemoveEventListener("rollOut",this.onTooltipComplexEBoxOut);
            }
            else
            {
               container.removeEventListener("rollOver",this.onTooltipComplexBoxOver);
               container.removeEventListener("rollOut",this.onTooltipComplexBoxOut);
               container.removeEventListener("mouseMove",this.onMouseMove);
            }
         }
         return tooltip;
      }
      
      public function flushTooltipsDictionary() : void
      {
         var container:* = undefined;
         for each(container in this.mContainerToTooltipInfoDictionary)
         {
            this.destroyTooltipFromContainer(container);
         }
      }
      
      private function onTooltipComplexEBoxOver(e:EEvent) : void
      {
         this.removeCurrentTooltip();
         this.mCurrentTooltip = this.showTooltip(this.mContainerToTooltipInfoDictionary[e.getTarget()]);
      }
      
      private function onTooltipComplexEBoxOut(e:EEvent) : void
      {
         this.removeCurrentTooltip();
      }
      
      private function onTooltipComplexBoxOver(e:MouseEvent) : void
      {
         this.removeCurrentTooltip();
         this.mCurrentTooltip = this.showTooltip(this.mContainerToTooltipInfoDictionary[e.target]);
         this.mLastGlobalMouseX = e.target.stage.mouseX;
         this.mLastGlobalMouseY = e.target.stage.mouseY;
      }
      
      private function onTooltipComplexBoxOut(e:MouseEvent) : void
      {
         this.removeCurrentTooltip();
      }
      
      private function onMouseMove(e:MouseEvent) : void
      {
         var movementX:Number = NaN;
         var movementY:Number = NaN;
         if(this.mCurrentTooltip)
         {
            movementX = e.target.stage.mouseX - this.mLastGlobalMouseX;
            movementY = e.target.stage.mouseY - this.mLastGlobalMouseY;
            this.mCurrentTooltip.logicX += movementX;
            this.mCurrentTooltip.logicY += movementY;
            this.mLastGlobalMouseX = e.target.stage.mouseX;
            this.mLastGlobalMouseY = e.target.stage.mouseY;
         }
      }
      
      private function onUpdateWIOTooltipTime(iconBarTime:IconBarTime, dt:int, params:Array) : void
      {
         var refineryStageTokens:Array = null;
         var i:int = 0;
         var gameUnit:GameUnit = null;
         var sku:String = null;
         var upgradeLevel:int = 0;
         var def:ShipDef = null;
         var worldItemObject:WorldItemObject = null;
         var timeText:String = null;
         var timeLeft:Number = NaN;
         var totalTime:Number = NaN;
         var constructionTime:Number = NaN;
         var perc:Number = NaN;
         var shipyard:Shipyard = null;
         var incomeText:* = null;
         var incomeAmount:Number = NaN;
         var world:World = null;
         var sid:String = null;
         var coins:Number = NaN;
         var minerals:Number = NaN;
         var total:Number = NaN;
         var umbrellaMng:UmbrellaMng = null;
         var shipUnderConstruction:String = null;
         var progressTime:Number = (worldItemObject = params[0]).getProgressTime();
         var type:String = InstanceMng.getWorldItemObjectController().actionsUIGetAction(worldItemObject.getActionUIId()).getTooltipType();
         iconBarTime.setBarCurrentValue(progressTime);
         timeLeft = worldItemObject.getTimeLeft(true);
         switch(type)
         {
            case "TooltipWIORecollecting":
               incomeAmount = worldItemObject.getIncomeAmount();
               incomeText = DCTextMng.convertNumberToString(incomeAmount,-1,-1);
               if(worldItemObject.hasCollectionBonus())
               {
                  incomeText += worldItemObject.getCollectionBonusText(true);
               }
               timeText = DCTextMng.getText(574);
               iconBarTime.setBarCurrentValue(incomeAmount);
               iconBarTime.setBarMaxValue(worldItemObject.mDef.getIncomeCapacity());
               break;
            case "TooltipWIOSpyResourceCoins":
            case "TooltipWIOSpyResourceMinerals":
            case "TooltipWIOSpySiloCoins":
            case "TooltipWIOSpySiloMinerals":
               world = InstanceMng.getWorld();
               sid = worldItemObject.mSid;
               coins = world.lootGetMaxCoinsBySid(sid);
               minerals = world.lootGetMaxMineralsBySid(sid);
               total = coins + minerals;
               incomeText = DCTextMng.convertNumberToString(total,-1,-1);
               break;
            case "TooltipWIOSpyHQ":
               break;
            case "TooltipWIOConstructing":
               progressTime = worldItemObject.getTimeMax() - worldItemObject.getTimeLeft();
               iconBarTime.setBarCurrentValue(progressTime);
               iconBarTime.setBarMaxValue(worldItemObject.getTimeMax());
               timeText = worldItemObject.mServerStateId == 0 ? DCTextMng.getText(571) : DCTextMng.getText(572);
               break;
            case "TooltipWIORepairing":
               progressTime = worldItemObject.getEnergy();
               iconBarTime.setBarCurrentValue(progressTime);
               iconBarTime.setBarMaxValue(worldItemObject.mDef.getMaxEnergy());
               timeText = DCTextMng.getText(573);
               break;
            case "TooltipWIOBuilt":
               if(Config.useUmbrella() && worldItemObject.umbrellaGetIsEnabled() && worldItemObject.mDef.isHeadQuarters())
               {
                  umbrellaMng = InstanceMng.getUmbrellaMng();
                  iconBarTime.setBarCurrentValue(umbrellaMng.energyGetTarget());
                  iconBarTime.setBarMaxValue(umbrellaMng.energyGetMax());
               }
               else if((shipyard = InstanceMng.getShipyardController().getShipyard(worldItemObject.mSid)) != null)
               {
                  if((shipUnderConstruction = shipyard.getProducingElementSku()) != null)
                  {
                     constructionTime = shipyard.getShipConstructionTime();
                     if((timeLeft = shipyard.getShipTimeLeft()) < 0)
                     {
                        timeLeft = 0;
                     }
                     iconBarTime.setBarCurrentValue(constructionTime - timeLeft);
                     iconBarTime.setBarMaxValue(constructionTime);
                     timeText = DCTextMng.getText(575);
                     iconBarTime.updateTopText(timeText + DCTextMng.convertTimeToStringColon(timeLeft,false));
                     totalTime = this.getTimeMaxFillBar(worldItemObject);
                     perc = (constructionTime - timeLeft) / constructionTime;
                     incomeText = Math.floor(perc * 100) + "%";
                     return;
                  }
               }
               else if(worldItemObject.mDef.isARefinery())
               {
                  if(ERefineryPopup.getRemainingTime() > 0 && ERefineryPopup.getCurrentSku() != null)
                  {
                     refineryStageTokens = worldItemObject.mDef.getRefineryStages().split(",");
                     for(i = 0; i < refineryStageTokens.length; )
                     {
                        if(i % 3 == 2 && refineryStageTokens[i] == ERefineryPopup.getCurrentSku())
                        {
                           constructionTime = Number(refineryStageTokens[i - 1]);
                           break;
                        }
                        i++;
                     }
                     if(isNaN(constructionTime))
                     {
                        return;
                     }
                     constructionTime = DCTimerUtil.minToMs(constructionTime);
                     iconBarTime.setBarMaxValue(constructionTime);
                     timeText = DCTextMng.getText(4333);
                     timeLeft = ERefineryPopup.getRemainingTime();
                     progressTime = constructionTime - timeLeft;
                     iconBarTime.setBarCurrentValue(progressTime);
                     perc = (constructionTime - timeLeft) / constructionTime;
                     incomeText = Math.floor(perc * 100) + "%";
                  }
               }
               else if(worldItemObject.mDef.isALaboratory())
               {
                  if((gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradingUnit()) != null)
                  {
                     sku = gameUnit.mDef.mSku;
                     upgradeLevel = gameUnit.mDef.getUpgradeId();
                     if((def = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(sku,upgradeLevel + 1)) == null)
                     {
                        return;
                     }
                     constructionTime = def.getCostTime();
                     iconBarTime.setBarMaxValue(constructionTime);
                     timeText = DCTextMng.getText(572);
                     timeLeft = gameUnit.mTimeLeft;
                     progressTime = constructionTime - timeLeft;
                     iconBarTime.setBarCurrentValue(progressTime);
                     perc = (constructionTime - timeLeft) / constructionTime;
                     incomeText = Math.floor(perc * 100) + "%";
                  }
               }
               break;
            default:
               timeText = DCTextMng.getText(574);
         }
         if(incomeText == null)
         {
            totalTime = this.getTimeMaxFillBar(worldItemObject);
            if(worldItemObject.needsRepairs())
            {
               progressTime = worldItemObject.getEnergy();
               totalTime = worldItemObject.mDef.getMaxEnergy();
            }
            perc = progressTime / totalTime;
            incomeText = Math.floor(perc * 100) + "%";
         }
         iconBarTime.updateTopText(timeText + DCTextMng.convertTimeToStringColon(timeLeft));
         iconBarTime.updateText(incomeText);
      }
      
      protected function getTimeMaxFillBar(worldItemObjectAttached:WorldItemObject) : Number
      {
         var shipUnderConstruction:String = null;
         var returnValue:Number = worldItemObjectAttached.getTimeMax();
         var shipyard:Shipyard = InstanceMng.getShipyardController().getShipyard(worldItemObjectAttached.mSid);
         if(worldItemObjectAttached.needsRepairs())
         {
            returnValue = worldItemObjectAttached.mRepairTimeMax;
         }
         else if(shipyard != null && shipyard.getWorldItemObject().mServerStateId == 1)
         {
            if((shipUnderConstruction = shipyard.getProducingElementSku()) != null)
            {
               returnValue = shipyard.getShipConstructionTime();
            }
         }
         return returnValue;
      }
      
      public function getName() : String
      {
         return "ETooltipMng";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new Vector.<String>(0);
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
      }
   }
}
