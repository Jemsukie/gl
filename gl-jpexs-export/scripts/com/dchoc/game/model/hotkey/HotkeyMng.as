package com.dchoc.game.model.hotkey
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class HotkeyMng extends DCComponent
   {
      
      public static const KEYCODE_NONE:uint = 0;
      
      private static const KEY_VALUE:String = "keyCode";
      
      private static const KEY_MODIFIER_SHIFT:String = "shift";
      
      private static const KEY_MODIFIER_CONTROL:String = "ctrl";
      
      private static const KEY_MODIFIER_ALT:String = "alt";
      
      private static const KEY_MODIFIERS:Vector.<String> = new <String>["shift","ctrl","alt"];
      
      public static const NUM_MODIFIERS:int = KEY_MODIFIERS.length;
      
      public static const NUM_SPECIAL_ATTACK_SLOTS:int = 5;
      
      public static const NUM_UNIT_ATTACK_SLOTS:int = 5;
      
      public static const ACTION_ID_PREFIX_SPECIAL_ATTACK_SLOT:String = "sa-";
      
      public static const ACTION_ID_PREFIX_UNIT_ATTACK_SLOT:String = "ua-";
      
      public static const ACTION_ID_PREFIX_PLANET_SLOT:String = "p-";
      
      public static const ACTION_ID_FULLSCREEN:String = "fullscreen";
      
      public static const ACTION_ID_HIDE_HUD:String = "hideHUD";
      
      public static const ACTION_ID_MUTE:String = "mute";
      
      public static const ACTION_ID_INVENTORY:String = "inventory";
      
      public static const ACTION_ID_SKIN:String = "skin";
      
      public static const ACTION_ID_TOOL_SELECT:String = "none";
      
      public static const ACTION_ID_TOOL_MOVE:String = "move";
      
      public static const ACTION_ID_TOOL_UPGRADE:String = "upgrade";
      
      public static const ACTION_ID_TOOL_FLIP:String = "flip";
      
      public static const ACTION_ID_TOOL_DEMOLISH:String = "demolish";
      
      private static const TOGGLE_DELAY_MS:int = 1000;
      
      private static var smKeySkus:Vector.<String>;
       
      
      private var mProfile:Profile;
      
      private var mModifiersStates:Object;
      
      private var mTimeSinceLastFullscreenToggle:int = 0;
      
      private var mTimeSinceLastHUDToggle:int = 0;
      
      private var mNeedsToInitialize:Boolean = true;
      
      public function HotkeyMng()
      {
         this.mLogicUpdateFrequency = 500;
         super();
      }
      
      private function init() : void
      {
         if(InstanceMng.getUserInfoMng().isBuilt())
         {
            this.mProfile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(!this.mProfile || this.mProfile.getUserInfoObj() == null || !this.mProfile.getFlagsReaded())
            {
               return;
            }
            this.buildKeySkus();
            this.mModifiersStates = {};
            this.mModifiersStates["shift"] = false;
            this.mModifiersStates["ctrl"] = false;
            this.mModifiersStates["alt"] = false;
            InstanceMng.getApplication().stageGetStage().addEventListener("keyUp",this.onKeyUp);
            InstanceMng.getApplication().stageGetStage().addEventListener("keyDown",this.onKeyDown);
            this.mNeedsToInitialize = false;
         }
      }
      
      private function buildKeySkus() : void
      {
         var i:int = 0;
         smKeySkus = new <String>["fullscreen","hideHUD","mute","inventory","skin","none","move","upgrade","flip","demolish"];
         for(i = 0; i < 5; )
         {
            smKeySkus.push("sa-" + i);
            i++;
         }
         for(i = 0; i < 5; )
         {
            smKeySkus.push("ua-" + i);
            i++;
         }
         for(i = 0; i < this.getNumPlanetSlots(); )
         {
            smKeySkus.push("p-" + i);
            i++;
         }
      }
      
      private function getNumUnitAttackSlots() : int
      {
         var mercenariesUnlocked:Boolean = InstanceMng.getMissionsMng().isMissionEnded(InstanceMng.getSettingsDefMng().getMercenariesUnlockMissionSku());
         var userHasMercenaries:* = InstanceMng.getItemsMng().getMercenaries() > 0;
         return mercenariesUnlocked || userHasMercenaries ? 5 : 6;
      }
      
      public function getNumPlanetSlots() : int
      {
         return this.mProfile.getUserInfoObj().getPlanetsAmount();
      }
      
      private function getHotkeyDefault(sku:String) : Object
      {
         var slotId:int = 0;
         var returnValue:Object = {};
         returnValue["shift"] = false;
         returnValue["ctrl"] = false;
         returnValue["alt"] = false;
         if(sku == "fullscreen")
         {
            returnValue["keyCode"] = 70;
         }
         else if(sku == "hideHUD")
         {
            returnValue["keyCode"] = 72;
         }
         else if(sku == "mute")
         {
            returnValue["keyCode"] = 77;
         }
         else if(sku == "inventory")
         {
            returnValue["keyCode"] = 73;
         }
         else if(sku == "skin")
         {
            returnValue["keyCode"] = 75;
         }
         else if(sku == "none")
         {
            returnValue["keyCode"] = 90;
         }
         else if(sku == "move")
         {
            returnValue["keyCode"] = 88;
         }
         else if(sku == "upgrade")
         {
            returnValue["keyCode"] = 67;
         }
         else if(sku == "flip")
         {
            returnValue["keyCode"] = 86;
         }
         else if(sku == "demolish")
         {
            returnValue["keyCode"] = 66;
         }
         else if(sku.indexOf("sa-") == 0)
         {
            slotId = parseInt(sku.substring("sa-".length));
            returnValue["keyCode"] = [81,87,69,82,84][slotId];
         }
         else if(sku.indexOf("ua-") == 0)
         {
            slotId = parseInt(sku.substring("ua-".length));
            returnValue["keyCode"] = [49,50,51,52,53][slotId];
         }
         else if(sku.indexOf("p-") == 0)
         {
            slotId = parseInt(sku.substring("p-".length));
            returnValue["shift"] = true;
            returnValue["keyCode"] = [49,50,51,52,53,54,55,56,57,48,189,187][slotId];
         }
         else
         {
            returnValue["keyCode"] = 0;
         }
         return returnValue;
      }
      
      public function getHotkeyDefaultValue(sku:String) : uint
      {
         return this.getHotkeyDefault(sku)["keyCode"];
      }
      
      public function getHotkeyDefaultModifiers(sku:String) : Vector.<Boolean>
      {
         var hotkeyObj:Object = this.getHotkeyDefault(sku);
         var returnValue:Vector.<Boolean> = new Vector.<Boolean>(0);
         for each(var modifier in KEY_MODIFIERS)
         {
            returnValue.push(hotkeyObj[modifier]);
         }
         return returnValue;
      }
      
      private function getHotkeyBySku(sku:String) : Object
      {
         var tokens:Array = null;
         var hotkeyData:String = null;
         var modifierTokens:String = null;
         var returnValue:Object = {};
         if(this.mProfile == null)
         {
            return this.getHotkeyDefault(sku);
         }
         var hotkeysData:String;
         if((hotkeysData = this.mProfile.getHotkeys()) == null || hotkeysData == "")
         {
            return this.getHotkeyDefault(sku);
         }
         for each(var hotkey in hotkeysData.split(";"))
         {
            if((tokens = hotkey.split("="))[0] == sku)
            {
               hotkeyData = String(tokens[1]);
               returnValue["keyCode"] = uint(hotkeyData.split("/")[0]);
               modifierTokens = String(hotkeyData.split("/")[1]);
               returnValue["shift"] = modifierTokens.substr(0,1) == "1";
               returnValue["ctrl"] = modifierTokens.substr(1,1) == "1";
               returnValue["alt"] = modifierTokens.substr(2,1) == "1";
               return returnValue;
            }
         }
         return this.getHotkeyDefault(sku);
      }
      
      public function getHotkeyValue(sku:String) : uint
      {
         var hotkeyData:Object = this.getHotkeyBySku(sku);
         if(DCUtils.isObjectEmpty(hotkeyData))
         {
            return 0;
         }
         return hotkeyData["keyCode"];
      }
      
      public function getHotkeyModifiers(sku:String) : Vector.<Boolean>
      {
         var hotkeyData:Object = this.getHotkeyBySku(sku);
         if(DCUtils.isObjectEmpty(hotkeyData))
         {
            return new Vector.<Boolean>(NUM_MODIFIERS);
         }
         return new <Boolean>[hotkeyData["shift"],hotkeyData["ctrl"],hotkeyData["alt"]];
      }
      
      public function isShiftPressed() : Boolean
      {
         return this.mModifiersStates["shift"];
      }
      
      public function isControlPressed() : Boolean
      {
         return this.mModifiersStates["ctrl"];
      }
      
      public function isAltPressed() : Boolean
      {
         return this.mModifiersStates["alt"];
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         switch(int(e.keyCode) - 16)
         {
            case 0:
               this.mModifiersStates["shift"] = true;
               break;
            case 1:
               this.mModifiersStates["ctrl"] = true;
               break;
            case 2:
               this.mModifiersStates["alt"] = true;
         }
         this.handleKeyPress(e.keyCode);
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         switch(int(e.keyCode) - 16)
         {
            case 0:
               this.mModifiersStates["shift"] = false;
               break;
            case 1:
               this.mModifiersStates["ctrl"] = false;
               break;
            case 2:
               this.mModifiersStates["alt"] = false;
         }
      }
      
      private function handleKeyPress(key:uint) : void
      {
         var hotkeyData:Object = null;
         var focusObj:*;
         var inTextBox:* = (focusObj = InstanceMng.getApplication().stageGetStage().getImplementation().focus) is TextField;
         if(inTextBox)
         {
            return;
         }
         for each(var hotkeySku in smKeySkus)
         {
            hotkeyData = this.getHotkeyBySku(hotkeySku);
            if(!DCUtils.isObjectEmpty(hotkeyData) && hotkeyData["keyCode"] > 0 && hotkeyData["keyCode"] == key)
            {
               if((!hotkeyData["shift"] || isShiftPressed()) && (!hotkeyData["ctrl"] || isControlPressed()) && (!hotkeyData["alt"] || isAltPressed()))
               {
                  this.handleHotkeyActivation(hotkeySku);
               }
            }
         }
      }
      
      private function handleHotkeyActivation(hotkeySku:String) : void
      {
         var params:Dictionary = null;
         var planetId:int = 0;
         var navigationAllowed:Boolean = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getIsOwner() && InstanceMng.getFlowState().getCurrentRoleId() == 0 && !InstanceMng.getUnitScene().actualBattleIsRunning() && InstanceMng.getApplication().canStartLoading() && !InstanceMng.getBuildingsBufferController().isBufferOpen();
         if(hotkeySku.indexOf("p-") == 0 && navigationAllowed)
         {
            planetId = 1 + parseInt(hotkeySku.substring("p-".length));
            this.visitMyPlanet(String(planetId));
            return;
         }
         switch(hotkeySku)
         {
            case "fullscreen":
               if(this.mTimeSinceLastFullscreenToggle > 1000)
               {
                  this.mTimeSinceLastFullscreenToggle = 0;
                  InstanceMng.getApplication().toggleFullScreen();
               }
               break;
            case "hideHUD":
               if(this.mTimeSinceLastHUDToggle > 1000 && navigationAllowed && !InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting())
               {
                  this.mTimeSinceLastHUDToggle = 0;
                  InstanceMng.getUIFacade().getIsAllHudElementsHidden() ? InstanceMng.getUIFacade().showAllHUDElements() : InstanceMng.getUIFacade().hideAllHUDElements(0.1);
               }
               break;
            case "mute":
               this.mProfile.setSound(!this.mProfile.getSound());
               break;
            case "inventory":
               if(navigationAllowed && !InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting() && InstanceMng.getApplication().viewGetMode() == 0)
               {
                  InstanceMng.getItemsMng().guiOpenInventoryPopup();
               }
               break;
            case "skin":
               InstanceMng.getSkinsMng().cycleSkin();
               break;
            default:
               params = new Dictionary();
               params["sku"] = hotkeySku;
               MessageCenter.getInstance().sendMessage("hotkeyActivated",params);
         }
      }
      
      private function visitMyPlanet(planetId:String) : void
      {
         var userInfo:UserInfo = this.mProfile.getUserInfoObj();
         var planet:Planet = userInfo.getPlanetById(planetId);
         if(planet)
         {
            InstanceMng.getUserInfoMng().getProfileLogin().setCurrentPlanetId(planetId);
            InstanceMng.getApplication().goToSetCurrentDestinationInfo(planetId,userInfo);
            InstanceMng.getApplication().requestPlanet(userInfo.mAccountId,planetId,0,planet.getSku());
         }
      }
      
      public function keyCodeToString(input:uint) : String
      {
         if(input == 0)
         {
            return DCTextMng.getText(4304);
         }
         return DCUtils.keyCodeToString(input);
      }
      
      public function isKeyCodeValid(keyCode:uint) : Boolean
      {
         return keyCode >= 48 && keyCode <= 57 || keyCode >= 65 && keyCode <= 90 || keyCode >= 186 && keyCode <= 192 || keyCode >= 219 && keyCode <= 222 || keyCode >= 112 && keyCode <= 126 || keyCode >= 96 && keyCode <= 111;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         this.mTimeSinceLastFullscreenToggle += dt;
         this.mTimeSinceLastHUDToggle += dt;
         if(this.mNeedsToInitialize)
         {
            this.init();
         }
      }
   }
}
