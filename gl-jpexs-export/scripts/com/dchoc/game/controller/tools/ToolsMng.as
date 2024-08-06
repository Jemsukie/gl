package com.dchoc.game.controller.tools
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.component.DCComponent;
   import flash.utils.Dictionary;
   
   public class ToolsMng extends DCComponent
   {
      
      public static const TOOL_SELECT_ID:int = 0;
      
      public static const TOOL_DEMOLISH_ID:int = 1;
      
      public static const TOOL_TERRAIN_ID:int = 2;
      
      public static const TOOL_SET_TILE_NOT_PLAYABLE_ID:int = 3;
      
      public static const TOOL_PLACE_ID:int = 4;
      
      public static const TOOL_MOVE_ID:int = 5;
      
      public static const TOOL_FLIP_ID:int = 6;
      
      public static const TOOL_WAR_CIRCLE_ID:int = 7;
      
      public static const TOOL_UPGRADE_ID:int = 8;
      
      public static const TOOL_LAUNCH_SPECIAL_ATTACK_ID:int = 9;
      
      public static const TOOL_SPY_ID:int = 10;
      
      public static const TOOL_NOTHING_ID:int = 11;
      
      public static const TOOL_DEBUG_UNITS_ID:int = 12;
      
      public static const TOOL_DEBUG_MAP_ID:int = 13;
      
      public static const TOOL_MERCENARIES_ID:int = 14;
      
      public static const TOOL_WALLS_ID:int = 15;
      
      public static const TOOL_MOVE_FOR_BUFFER_ID:int = 16;
      
      public static const TOOL_COUNT:int = 17;
      
      public static const TOOL_DEFAULT_ID:int = 0;
      
      public static const TOOL_PARAM_STORE_PREVIOUS:String = "storePreviousTool";
      
      public static const TOOL_PARAM_SPY_TYPE:String = "spyType";
      
      private static const DEFAULT_CURSOR_SIZES:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[1,1],new <int>[1,1],new <int>[1,1],new <int>[1,1],new <int>[1,1],new <int>[1,1],new <int>[1,1],new <int>[5,5],new <int>[1,1],new <int>[1,1],new <int>[6,6],new <int>[0,0],new <int>[1,1],new <int>[1,1],new <int>[5,5],new <int>[1,1],new <int>[1,1]];
      
      private static const DEFAULT_CURSOR_SIZES_STR:String = "" + DEFAULT_CURSOR_SIZES;
      
      private static const WHAT_TO_DROP_UNIT:int = 0;
      
      private static const WHAT_TO_DROP_SPECIAL_ATTACK:int = 1;
       
      
      public var mToolsDictionary:Dictionary;
      
      private var mTools:Vector.<Tool>;
      
      private var mMapController:MapControllerPlanet;
      
      private var mCurrentToolId:int;
      
      private var mCurrentToolParams:Object;
      
      private var mPreviousToolId:int;
      
      private var mWhatsToDrop:Dictionary;
      
      public function ToolsMng()
      {
         super();
      }
      
      public function getToolValueByKey(key:String) : int
      {
         if(key == null || key == "")
         {
            return -1;
         }
         return this.mToolsDictionary[key];
      }
      
      private function fillToolsDictionary() : void
      {
         this.mToolsDictionary["tool_select"] = 0;
         this.mToolsDictionary["tool_demolish"] = 1;
         this.mToolsDictionary["tool_terrain"] = 2;
         this.mToolsDictionary["tool_set_tile_not_payable"] = 3;
         this.mToolsDictionary["tool_place"] = 4;
         this.mToolsDictionary["tool_move"] = 5;
         this.mToolsDictionary["tool_move_for_buffer"] = 16;
         this.mToolsDictionary["tool_flip"] = 6;
         this.mToolsDictionary["tool_war_circle"] = 7;
         this.mToolsDictionary["tool_mercenaries"] = 14;
         this.mToolsDictionary["tool_upgrade"] = 8;
         this.mToolsDictionary["tool_launch_special_attack"] = 9;
         this.mToolsDictionary["tool_spy"] = 10;
         this.mToolsDictionary["tool_nothing"] = 11;
         this.mToolsDictionary["tool_debug_units"] = 12;
         this.mToolsDictionary["tool_debug_map"] = 13;
         this.mToolsDictionary["tool_walls"] = 15;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var tool:Tool = null;
         if(step == 0)
         {
            this.mToolsDictionary = new Dictionary(true);
            this.mTools = new Vector.<Tool>(17);
            this.registerTools();
            this.fillToolsDictionary();
            this.whatsToDropLoad();
            for each(tool in this.mTools)
            {
               if(tool != null)
               {
                  tool.load();
               }
            }
         }
      }
      
      override protected function unloadDo() : void
      {
         var tool:Tool = null;
         for each(tool in this.mTools)
         {
            if(tool != null)
            {
               tool.unload();
            }
         }
         this.mTools = null;
         this.mMapController = null;
         this.mToolsDictionary = null;
         this.whatsToDropUnload();
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         var tool:Tool = null;
         for each(tool in this.mTools)
         {
            if(tool != null)
            {
               tool.build();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         var tool:Tool = null;
         for each(tool in this.mTools)
         {
            if(tool != null)
            {
               tool.unbuild();
            }
         }
      }
      
      override protected function beginDo() : void
      {
         this.mCurrentToolId = -1;
         Tool.setMapController(this.mMapController);
         var toolId:int = 0;
         this.setTool(toolId);
         this.mPreviousToolId = -1;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(this.mCurrentToolId > -1)
         {
            Tool(this.mTools[this.mCurrentToolId]).logicUpdate(dt);
         }
      }
      
      public function sigCalculate(calculate:Boolean) : String
      {
         return DEFAULT_CURSOR_SIZES_STR;
      }
      
      public function setMapController(value:MapControllerPlanet) : void
      {
         this.mMapController = value;
      }
      
      protected function registerTools() : void
      {
         this.mTools[0] = new ToolSelect(0);
         this.mTools[1] = new ToolDemolish(1);
         this.mTools[2] = new ToolSetTile(2,1);
         this.mTools[15] = new ToolSelectGroup(15,false,24,19);
         this.mTools[3] = new ToolSetTile(3,2);
         this.mTools[4] = new ToolPlaceItem(4,-1,1,"AddItem",false);
         this.mTools[5] = new ToolPlaceItem(5,9,1,"MoveItem",true);
         this.mTools[16] = new ToolMoveForBuffer(16);
         this.mTools[6] = new ToolFlipItem(6,10,1,"FlipItem",true);
         this.mTools[7] = new ToolWarCircle(7,-1,1);
         this.mTools[14] = new ToolWarCircle(14,-1,1);
         this.mTools[11] = new Tool(11,false,-1,25,false);
         this.mTools[8] = new ToolUpgrade(8,8,9);
         this.mTools[9] = new ToolLaunchSpecialAttack(9,15);
         this.mTools[10] = new ToolSpy(10);
         if(Config.DEBUG_UNIT_SCENE)
         {
            this.mTools[12] = new ToolDebugUnits(12);
         }
         if(Config.DEBUG_MODE)
         {
            this.mTools[13] = new ToolDebugMap(13);
         }
      }
      
      public function getTool(toolId:int) : Tool
      {
         return this.mTools[toolId];
      }
      
      public function getCurrentToolId() : int
      {
         return this.mCurrentToolId;
      }
      
      public function getCurrentTool() : Tool
      {
         return this.mTools[this.mCurrentToolId];
      }
      
      public function getCurrentToolParams() : Object
      {
         return this.mCurrentToolParams;
      }
      
      public function getCurrentSpyType() : int
      {
         var returnValue:int = -1;
         if(this.mCurrentToolParams != null)
         {
            returnValue = int(this.mCurrentToolParams["spyType"]);
         }
         return returnValue;
      }
      
      public function setTool(toolId:int, params:Object = null) : void
      {
         this.mCurrentToolParams = params;
         if(this.mCurrentToolParams == null)
         {
            this.mCurrentToolParams = {};
         }
         var tool:Tool = this.mMapController.uiGetTool();
         var paramsOut:Dictionary = new Dictionary();
         if(tool != null)
         {
            tool.end();
         }
         if(this.mCurrentToolParams.hasOwnProperty("storePreviousTool"))
         {
            if(this.mCurrentToolParams["storePreviousTool"] == true)
            {
               this.mPreviousToolId = this.mCurrentToolId;
            }
         }
         if(this.mCurrentToolParams.hasOwnProperty("spyType"))
         {
            paramsOut["spyType"] = this.mCurrentToolParams["spyType"];
         }
         if(toolId != this.mCurrentToolId)
         {
            this.mCurrentToolId = toolId;
         }
         tool = this.mTools[toolId];
         this.mMapController.uiSetTool(tool);
         this.resetCurrentTool(false);
         paramsOut["toolId"] = toolId;
         MessageCenter.getInstance().sendMessage("toolChanged",paramsOut);
      }
      
      public function getPreviousToolId() : int
      {
         return this.mPreviousToolId;
      }
      
      public function setPreviousTool(toolId:int) : void
      {
         this.mPreviousToolId = toolId;
      }
      
      public function recoverPreviousTool() : void
      {
         if(this.mPreviousToolId > -1)
         {
            this.setTool(this.mPreviousToolId);
         }
      }
      
      public function setToolPlaceItem(itemSku:String, transactionPack:Transaction, allowKeepPlacing:Boolean = true) : void
      {
         var tool:ToolPlaceItem;
         (tool = this.getTool(4) as ToolPlaceItem).setItemSku(itemSku);
         tool.setCanKeepPlacing(allowKeepPlacing);
         tool.setTransaction(transactionPack);
         if(this.getCurrentTool().isSelectionMade())
         {
            this.getCurrentTool().destroySelection();
         }
         this.setTool(4);
      }
      
      public function setToolLaunchSpecialAttack(attackSku:String, payedWithCash:Boolean) : void
      {
         var toolId:int = 0;
         var toolWarCircle:ToolWarCircle = null;
         var tool:ToolLaunchSpecialAttack = null;
         var def:SpecialAttacksDef = SpecialAttacksDef(InstanceMng.getSpecialAttacksDefMng().getDefBySku(attackSku));
         var storePreviousTool:* = true;
         var whatToDrop:WhatToDropSpecialAttack = this.whatsToDropGetSpecialAttack();
         var params:Object = {};
         whatToDrop.setupParams(def,payedWithCash);
         if(def.getType() == "mercenaries")
         {
            (toolWarCircle = this.getTool(14) as ToolWarCircle).cursorSetCenterTileIsEnabled(false);
            toolWarCircle.whatToDropSetup(whatToDrop);
            toolId = 14;
            storePreviousTool = this.mCurrentToolId != 9;
         }
         else
         {
            (tool = this.getTool(9) as ToolLaunchSpecialAttack).setDef(def);
            tool.whatToDropSetup(whatToDrop);
            toolId = 9;
         }
         params["storePreviousTool"] = storePreviousTool;
         this.setTool(toolId,params);
         if(Config.DEBUG_MODE && InstanceMng.getRole().mId == 0)
         {
            InstanceMng.getWorld().setAttackNotification(1);
         }
         var sku:String = null;
         switch(def.getType())
         {
            case "nuke":
               sku = "nuke";
               break;
            case "mercenaries":
               sku = "capsule";
         }
         if(sku != null)
         {
            InstanceMng.getResourceMng().featureLoadResources(sku);
         }
      }
      
      public function setToolWarCircle(unitSku:String) : void
      {
         var whatToDrop:WhatToDropUnit = this.whatsToDropGetUnit();
         whatToDrop.setupSetUnitSku(unitSku);
         var tool:ToolWarCircle = this.getTool(7) as ToolWarCircle;
         tool.cursorSetCenterTileIsEnabled(true);
         tool.whatToDropSetup(whatToDrop);
         this.setTool(7);
      }
      
      public function resetCurrentTool(doEnd:Boolean = true) : void
      {
         var roleCursorWidth:int = 0;
         var roleCursorHeight:* = 0;
         var currRole:Role;
         if((currRole = InstanceMng.getRole()) != null)
         {
            roleCursorWidth = currRole.toolGetCursorSize();
            if(roleCursorWidth > -1)
            {
               roleCursorHeight = roleCursorWidth;
            }
            else
            {
               roleCursorWidth = DEFAULT_CURSOR_SIZES[this.mCurrentToolId][0];
               roleCursorHeight = DEFAULT_CURSOR_SIZES[this.mCurrentToolId][1];
            }
         }
         var tool:Tool;
         if((tool = this.mMapController.uiGetTool()) != null)
         {
            tool.cursorSetSize(roleCursorWidth,roleCursorHeight);
            if(doEnd)
            {
               tool.end();
            }
            tool.begin();
         }
      }
      
      public function toggleSpy(spyType:int) : void
      {
         var params:Object = {};
         params["spyType"] = spyType;
         if(this.mCurrentToolId == 10 && this.getCurrentSpyType() == spyType)
         {
            this.setTool(0);
         }
         else
         {
            this.setTool(10,params);
            InstanceMng.getMapViewPlanet().spyCursorCheckFilters();
         }
      }
      
      private function whatsToDropLoad() : void
      {
         this.mWhatsToDrop = new Dictionary();
      }
      
      private function whatsToDropUnload() : void
      {
         var what:WhatToDrop = null;
         if(this.mWhatsToDrop != null)
         {
            for each(what in this.mWhatsToDrop)
            {
               what.unbuild();
            }
            this.mWhatsToDrop = null;
         }
      }
      
      private function whatsToDropGetUnit() : WhatToDropUnit
      {
         if(this.mWhatsToDrop[0] == null)
         {
            this.mWhatsToDrop[0] = new WhatToDropUnit();
         }
         return this.mWhatsToDrop[0];
      }
      
      private function whatsToDropGetSpecialAttack() : WhatToDropSpecialAttack
      {
         if(this.mWhatsToDrop[1] == null)
         {
            this.mWhatsToDrop[1] = new WhatToDropSpecialAttack();
         }
         return this.mWhatsToDrop[1];
      }
   }
}
