package com.dchoc.game.eview.facade
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.hud.EUnitItemViewWarBar;
   import com.dchoc.game.eview.hud.EWarBarMercenariesBox;
   import com.dchoc.game.eview.widgets.hud.EHudOptionsView;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.view.dc.gui.components.GUIBar;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class WarBarFacade extends GUIBar implements INotifyReceiver
   {
      
      private static const HUD_BG:String = "container_hud_bottom";
      
      private static const AREA_NEXT_TARGET:String = "area_next_target";
      
      private static const AREA_MERCENARIES:String = "area_mercenaries";
      
      private static const SETTINGS:String = "preferences";
      
      private static const TEXT_FEEDBACK:String = "text_feedback";
      
      private static const BTN_ARROW_LEFT:String = "btn_arrow_left";
      
      private static const BTN_ARROW_RIGHT:String = "btn_arrow_right";
      
      private static const NUM_BOXES:int = 6;
      
      private static const NUM_BOXES_SMALL:int = 4;
       
      
      private var mPage:int = 0;
      
      private var mNumBoxes:int = 0;
      
      private var mBoxesLayoutAreaName:String;
      
      private var mLastUnitSelectedSku:String;
      
      private var mLayoutAreaFactoryAttack:ELayoutAreaFactory;
      
      private var mLayoutAreaFactoryUnits:ELayoutAreaFactory;
      
      private var mViewFactory:ViewFactory;
      
      private var mCanvas:ESpriteContainer;
      
      private var mContentHolders:Dictionary;
      
      private var mBoxes:Vector.<EUnitItemViewWarBar>;
      
      private var mCanUseMercenaries:Boolean;
      
      private var mHangarUnitsInfo:Vector.<Array>;
      
      private var mDeployments:Vector.<String>;
      
      public function WarBarFacade()
      {
         super("war_menu");
         this.mContentHolders = new Dictionary();
         this.mBoxes = new Vector.<EUnitItemViewWarBar>(0);
      }
      
      public function getName() : String
      {
         return "EWarBar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["putTutorialCircle","warBarUnitClicked","hideNextTargetPanel","hotkeyActivated"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var sku:String = null;
         var slotId:int = 0;
         var itemSlot:EUnitItemViewWarBar = null;
         var numVisibleBoxes:int = 0;
         var numSpecialAttacks:int = 0;
         var box:EWarBarMercenariesBox = null;
         var name:String = null;
         var component:ESprite = null;
         var boxName:String = null;
         var i:int = 0;
         switch(task)
         {
            case "putTutorialCircle":
               name = String(params["elementName"]);
               if(component = this.getHudElement(name))
               {
                  InstanceMng.getViewMngPlanet().addHighlightFromContainer(component);
               }
               break;
            case "warBarUnitClicked":
               boxName = String(params["name"]);
               if(params["selected"] === true)
               {
                  this.mLastUnitSelectedSku = params["unitSku"];
               }
               else
               {
                  this.mLastUnitSelectedSku = null;
               }
               for(i = 0; i < this.mBoxes.length; )
               {
                  if(this.mBoxes[i].name != boxName)
                  {
                     this.mBoxes[i].unSelect();
                  }
                  i++;
               }
               break;
            case "hideNextTargetPanel":
               this.getHudElement("area_next_target").visible = false;
               break;
            case "hotkeyActivated":
               if(InstanceMng.getRole().mId == 3)
               {
                  if((sku = String(params["sku"])).indexOf("ua-") == 0)
                  {
                     slotId = parseInt(sku.substring("ua-".length));
                     numVisibleBoxes = 0;
                     for(i = 0; i < this.mBoxes.length; )
                     {
                        if(this.mBoxes[i].visible)
                        {
                           numVisibleBoxes++;
                        }
                        i++;
                     }
                     if(slotId >= numVisibleBoxes)
                     {
                        break;
                     }
                     i = 0;
                     while(i < numVisibleBoxes)
                     {
                        itemSlot = this.mBoxes[i];
                        if(i == slotId)
                        {
                           itemSlot.setToggled(true);
                           itemSlot.sendClickedEvent();
                        }
                        else
                        {
                           itemSlot.setToggled(false);
                        }
                        i++;
                     }
                  }
                  else if(sku.indexOf("sa-") == 0)
                  {
                     slotId = parseInt(sku.substring("sa-".length));
                     numSpecialAttacks = int(InstanceMng.getItemsMng().getArrayVectorForSpecialAttacks().length);
                     if(slotId == numSpecialAttacks && this.canUseMercenaries())
                     {
                        if(box = this.getHudElement("area_mercenaries") as EWarBarMercenariesBox)
                        {
                           box.emulateActionClicked();
                        }
                     }
                  }
                  break;
               }
         }
      }
      
      public function getPage() : int
      {
         return 0;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 3;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && InstanceMng.getItemsMng().isBuilt() && InstanceMng.getUserInfoMng().getProfileLogin().isBuilt())
         {
            this.mViewFactory = InstanceMng.getViewFactory();
            this.mCanvas = this.mViewFactory.getESpriteContainer();
            this.createLayouts();
            this.createView();
            buildAdvanceSyncStep();
         }
         else if(step == 1)
         {
            this.createMercenaries();
            buildAdvanceSyncStep();
         }
         else if(step == 2)
         {
            if(Config.useBuyBattleTime())
            {
               this.createAnotherTargetPanel();
            }
            this.createSettingsButton();
            this.createFeedbackText();
            buildAdvanceSyncStep();
         }
      }
      
      override protected function beginDo() : void
      {
         MessageCenter.getInstance().registerObject(this);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvas,InstanceMng.getViewMngGame().getHudLayerSku(),8);
         if(InstanceMng.getRole().mId != 3)
         {
            this.mCanvas.visible = false;
         }
         this.setupDefaults();
         this.checkArrows();
         this.fillData();
      }
      
      override protected function endDo() : void
      {
         MessageCenter.getInstance().unregisterObject(this);
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvas,InstanceMng.getViewMngGame().getHudLayerSku());
      }
      
      override protected function unbuildDo() : void
      {
         var id:* = null;
         for(id in this.mContentHolders)
         {
            this.mContentHolders[id].destroy();
            delete this.mContentHolders[id];
         }
         this.mBoxes.length = 0;
         this.mCanvas.destroy();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var s:ESprite = null;
         for each(s in this.mContentHolders)
         {
            s.logicUpdate(dt);
         }
      }
      
      private function createLayouts() : void
      {
         this.mLayoutAreaFactoryAttack = this.mViewFactory.getLayoutAreaFactory("LayoutHudBottomAttack");
         if(this.canUseMercenaries())
         {
            this.mLayoutAreaFactoryUnits = this.mViewFactory.getLayoutAreaFactory("LayoutHudBottomUnitsSmall");
            this.mNumBoxes = 4;
            this.mBoxesLayoutAreaName = "area_units_s";
         }
         else
         {
            this.mLayoutAreaFactoryUnits = this.mViewFactory.getLayoutAreaFactory("LayoutHudBottomUnits");
            this.mNumBoxes = 6;
            this.mBoxesLayoutAreaName = "area_units_l";
         }
      }
      
      private function createView() : void
      {
         var i:int = 0;
         var box:EUnitItemViewWarBar = null;
         var bg:ESprite = this.mViewFactory.getEImage("skin_ui_hud_area_bottom",null,false,this.mLayoutAreaFactoryAttack.getArea("container_hud_bottom"),null);
         this.addHudElement("container_hud_bottom",bg,this.mCanvas,false);
         var boxesArea:ELayoutArea = this.mLayoutAreaFactoryAttack.getArea(this.mBoxesLayoutAreaName);
         var btn:EButton;
         (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactoryUnits.getArea("btn_arrow_left"))).name = "btn_arrow_left";
         btn.logicLeft += boxesArea.x;
         btn.logicTop += boxesArea.y;
         btn.eAddEventListener("click",this.onArrowLeftClick);
         this.addHudElement("btn_arrow_left",btn,this.mCanvas,true);
         (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactoryUnits.getArea("btn_arrow_right"))).name = "btn_arrow_right";
         btn.logicLeft += boxesArea.x;
         btn.logicTop += boxesArea.y;
         btn.eAddEventListener("click",this.onArrowRightClick);
         this.addHudElement("btn_arrow_right",btn,this.mCanvas,true);
         for(i = 0; i < this.mNumBoxes; )
         {
            (box = new EUnitItemViewWarBar()).build();
            box.name = "area_" + i;
            box.setLayoutArea(this.mLayoutAreaFactoryUnits.getArea(box.name),true);
            box.logicLeft += boxesArea.x;
            box.logicTop += boxesArea.y;
            this.addHudElement(box.name,box,this.mCanvas,true);
            this.mBoxes.push(box);
            i++;
         }
      }
      
      private function createMercenaries() : void
      {
         if(!this.canUseMercenaries())
         {
            return;
         }
         var mercenariesVector:Vector.<Array> = InstanceMng.getItemsMng().getArrayVectorForSpecialAttacks("showInMercenariesBar");
         var def:Array = mercenariesVector[0];
         var s:EWarBarMercenariesBox = new EWarBarMercenariesBox(def[0]);
         s.setLayoutArea(this.mLayoutAreaFactoryAttack.getArea("area_mercenaries"),true);
         s.name = "area_mercenaries";
         this.addHudElement(s.name,s,this.mCanvas,false);
      }
      
      private function createAnotherTargetPanel() : void
      {
         var layoutAreaFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudBattleTimer");
         var s:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var bkg:ESprite = this.mViewFactory.getEImage("hud_area_btns",null,false,layoutAreaFactory.getArea("container_battle"));
         s.eAddChild(bkg);
         s.setContent("container_battle",bkg);
         var transaction:Transaction = InstanceMng.getRuleMng().getTransactionQuickAttack(Config.useQuickAttackFirstTimeFree() && InstanceMng.getRole().mId != 3,null);
         var text:ESpriteContainer = this.mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_mineral",Math.abs(transaction.getTransMinerals()).toString(),null,"text_title_3");
         text.setLayoutArea(layoutAreaFactory.getArea("container_text_icon_xs"),true);
         s.eAddChild(text);
         s.setContent("container_text_icon_xs",text);
         var btn:EButton;
         (btn = this.mViewFactory.getButton("btn_hud_attack",null,"S",DCTextMng.getText(585))).setLayoutArea(layoutAreaFactory.getArea("btn"),true);
         btn.eAddEventListener("click",this.onNextTargetClick);
         s.eAddChild(btn);
         s.setContent("btn",btn);
         s.setLayoutArea(this.mLayoutAreaFactoryAttack.getArea("area_next_target"),true);
         this.addHudElement("area_next_target",s,this.mCanvas,false);
      }
      
      private function createSettingsButton() : void
      {
         var optionsDropDown:EHudOptionsView = new EHudOptionsView();
         optionsDropDown.setLayoutArea(this.mLayoutAreaFactoryAttack.getArea("preferences"),true);
         optionsDropDown.name = "preferences";
         this.addHudElement("preferences",optionsDropDown,this.mCanvas,false);
      }
      
      private function createFeedbackText() : void
      {
         var txt:ESprite = this.mViewFactory.getETextField(null,this.mLayoutAreaFactoryAttack.getTextArea("text_feedback"),"text_title");
         txt.name = "text_feedback";
         this.addHudElement(txt.name,txt,this.mCanvas,false);
      }
      
      private function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      private function addHudElement(id:String, s:ESprite, where:ESpriteContainer, addMouseOverBehaviours:Boolean) : void
      {
         s.name = id;
         if(addMouseOverBehaviours)
         {
            s.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
            s.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
         }
         s.eAddEventListener("rollOver",uiEnable);
         s.eAddEventListener("rollOut",uiDisable);
         if(where == null)
         {
            where = this.mCanvas;
         }
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      public function addFillBarCurrentAmount(value:int) : void
      {
      }
      
      public function updateElements() : void
      {
      }
      
      public function getNextDeployWave() : String
      {
         if(this.mDeployments == null)
         {
            return null;
         }
         return this.mDeployments.shift();
      }
      
      public function checkReorder(unitSku:String) : void
      {
         var reorder:Boolean = false;
         var arrToEnd:* = null;
         var i:int = 0;
         var arr:Array = null;
         if(Config.useReorderUnits())
         {
            reorder = false;
            for(i = 0; i < this.mHangarUnitsInfo.length; )
            {
               arr = this.mHangarUnitsInfo[i];
               if(arr.length > 3 && (arr[2] as DCDef).mSku == unitSku && arr[3] == 0)
               {
                  arrToEnd = arr;
                  this.mHangarUnitsInfo.splice(i,1);
                  reorder = true;
                  break;
               }
               i++;
            }
            if(reorder)
            {
               this.mHangarUnitsInfo.push(arrToEnd);
               this.fillData();
               this.setUnselectedBoxes();
            }
         }
      }
      
      override public function lock() : void
      {
         super.lock();
         this.lockWarboxes(true);
      }
      
      override public function unlock(exception:Object = null) : void
      {
         if(InstanceMng.getUnitScene().warBarMustBeLocked())
         {
            return;
         }
         super.unlock(exception);
         this.lockWarboxes(false);
      }
      
      public function lockWarboxes(lockIt:Boolean) : void
      {
         var unitBox:EUnitItemViewWarBar = null;
         var mercenaries:EWarBarMercenariesBox = null;
         for each(unitBox in this.mBoxes)
         {
            unitBox.setIsEnabled(!lockIt);
         }
         if(this.getHudElement("area_mercenaries"))
         {
            mercenaries = this.getHudElement("area_mercenaries") as EWarBarMercenariesBox;
            mercenaries.setIsEnabled(!lockIt);
         }
         this.lockArrows(lockIt);
      }
      
      public function lockButton(buttonName:String, lockIt:Boolean) : void
      {
      }
      
      public function resetUnitBar() : void
      {
      }
      
      public function reload() : void
      {
      }
      
      public function reset() : void
      {
         if(this.mDeployments != null)
         {
            this.mDeployments.length = 0;
         }
         if(this.mHangarUnitsInfo != null)
         {
            this.mHangarUnitsInfo.length = 0;
            this.mHangarUnitsInfo = null;
         }
      }
      
      public function areAllyUnitsLeft() : Boolean
      {
         return false;
      }
      
      public function setUnselectedBoxes() : void
      {
      }
      
      private function setupDefaults() : void
      {
         this.reset();
         this.mHangarUnitsInfo = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getAllUnitsStored();
         this.mLastUnitSelectedSku = null;
      }
      
      public function updateUnits() : void
      {
         var forceUnselect:Boolean = false;
         var unitPos:int = 0;
         var numberOfUnits:int = 0;
         var params:Dictionary = null;
         if(this.mLastUnitSelectedSku)
         {
            forceUnselect = true;
            unitPos = this.getUnitPositionFromSku(this.mLastUnitSelectedSku);
            if(unitPos >= 0)
            {
               numberOfUnits = int(this.mHangarUnitsInfo[unitPos][3]);
               if(numberOfUnits > 0)
               {
                  forceUnselect = false;
               }
            }
            if(forceUnselect)
            {
               (params = new Dictionary())["unitSku"] = this.mLastUnitSelectedSku;
               params["selected"] = false;
               MessageCenter.getInstance().sendMessage("warBarUnitSelectedUpdate",params);
               this.fillData();
               this.mLastUnitSelectedSku = null;
            }
         }
      }
      
      private function fillData() : void
      {
         var i:int = 0;
         var info:Array = null;
         var enabled:* = false;
         for(i = 0; i < this.mBoxes.length; )
         {
            this.mBoxes[i].setIsEnabled(true);
            if(this.mHangarUnitsInfo && i + this.mPage * this.mBoxes.length < this.mHangarUnitsInfo.length)
            {
               info = this.mHangarUnitsInfo[i + this.mPage * this.mBoxes.length];
               enabled = info[3] > 0;
               this.mBoxes[i].visible = true;
               this.mBoxes[i].fillData(info);
               if(enabled)
               {
                  this.mBoxes[i].setToggled(this.mBoxes[i].getBaseItemSku() == this.mLastUnitSelectedSku);
               }
               else
               {
                  this.mBoxes[i].unSelect();
               }
               this.mBoxes[i].setIsEnabled(enabled);
            }
            else
            {
               this.mBoxes[i].visible = false;
            }
            i++;
         }
      }
      
      private function updateHangarUnitsInfo() : void
      {
         var item:ItemObject = null;
         var unitSku:String = null;
         var idx:int = 0;
         var updatedArrElement:Array = null;
         var itemsMng:ItemsMng = InstanceMng.getItemsMng();
         var currentHangarUnits:Vector.<Array> = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getStoredUnitsInfo();
         var myUnitSkuArr:Array = DCUtils.vector2Array(this.mHangarUnitsInfo).map(this.mapGetSku);
         var profileHangarSkuArr:Array = DCUtils.vector2Array(currentHangarUnits).map(this.mapGetSku);
         for each(unitSku in myUnitSkuArr)
         {
            idx = myUnitSkuArr.indexOf(unitSku);
            if(this.mHangarUnitsInfo[idx][4])
            {
               if((idx = profileHangarSkuArr.indexOf(unitSku)) == -1)
               {
                  idx = myUnitSkuArr.indexOf(unitSku);
                  this.mHangarUnitsInfo[idx][1] = "";
                  this.mHangarUnitsInfo[idx][3] = 0;
               }
               else
               {
                  updatedArrElement = currentHangarUnits[idx];
                  idx = myUnitSkuArr.indexOf(unitSku);
                  this.mHangarUnitsInfo[idx][3] = updatedArrElement[3];
                  this.mHangarUnitsInfo[idx][1] = updatedArrElement[1];
               }
            }
            else
            {
               item = itemsMng.getItemObjectBySku(this.mHangarUnitsInfo[idx][5]);
               this.mHangarUnitsInfo[idx][3] = item == null ? 0 : item.quantity;
            }
         }
      }
      
      private function canUseMercenaries() : Boolean
      {
         var missionUnlocked:Boolean = InstanceMng.getMissionsMng().isMissionEnded(InstanceMng.getSettingsDefMng().getMercenariesUnlockMissionSku());
         var userHasMercenaries:* = InstanceMng.getItemsMng().getMercenaries() > 0;
         this.mCanUseMercenaries = missionUnlocked || userHasMercenaries;
         return this.mCanUseMercenaries;
      }
      
      public function unitLaunched(def:UnitDef, hangarId:String, comesFromHangar:Boolean) : void
      {
         if(this.mDeployments == null)
         {
            this.mDeployments = new Vector.<String>(0);
         }
         var deployWave:String = InstanceMng.getUnitScene().translateSingleUnitRequestToString(def,hangarId,comesFromHangar);
         this.mDeployments.push(deployWave);
         if(comesFromHangar)
         {
            InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getFromSid(hangarId).removeUnit(def.mSku,false);
         }
         else
         {
            InstanceMng.getItemsMng().addItemAmount(hangarId,-1,false);
         }
         this.updateHangarUnitsInfo();
      }
      
      private function getUnitPositionFromSku(sku:String) : int
      {
         var ship:Array = null;
         var result:* = -1;
         var i:int = 0;
         while(this.mHangarUnitsInfo && i < this.mHangarUnitsInfo.length)
         {
            ship = this.mHangarUnitsInfo[i];
            if(ship[0] == sku)
            {
               result = i;
            }
            i++;
         }
         return result;
      }
      
      public function notifyUnitDropped(unitSku:String) : void
      {
         var hangarId:String = null;
         var arr:Array = null;
         var shipPos:int;
         if((shipPos = this.getUnitPositionFromSku(unitSku)) < 0)
         {
            throw new Error("esto peta :(");
         }
         var ship:Array;
         var comesFromHangar:Boolean = Boolean((ship = this.mHangarUnitsInfo[shipPos])[4]);
         var box:EUnitItemViewWarBar = this.mBoxes[shipPos % this.mBoxes.length];
         var hangarIds:String = String(ship[1]);
         if(comesFromHangar)
         {
            arr = hangarIds.split(",");
            hangarId = arr.shift();
            hangarIds = arr.join(",");
         }
         else
         {
            hangarId = String(ship[5]);
         }
         if(hangarId == null || hangarId == "" || hangarId == "0")
         {
            return;
         }
         var def:UnitDef = ship[2];
         this.unitLaunched(def,hangarId,comesFromHangar);
         this.fillData();
      }
      
      public function nextBuyBattleTimePack() : void
      {
      }
      
      public function isBuyBattleTimeEnabled() : Boolean
      {
         return true;
      }
      
      public function resetBuyBattleTime() : void
      {
      }
      
      public function showMessage(text:String, showLoading:Boolean, pLock:Boolean, needLock:Boolean) : void
      {
         if(this.getHudElement("text_feedback"))
         {
            ETextField(this.getHudElement("text_feedback")).setText(text);
            this.getHudElement("text_feedback").visible = true;
         }
         if(pLock)
         {
            this.lock();
         }
         else
         {
            this.unlock();
         }
      }
      
      public function hideMessage(needsToBeLocked:Boolean = false) : void
      {
         if(this.getHudElement("text_feedback"))
         {
            this.getHudElement("text_feedback").visible = false;
         }
         if(needsToBeLocked)
         {
            this.lock();
         }
         else
         {
            this.unlock();
         }
      }
      
      private function onArrowLeftClick(evt:EEvent) : void
      {
         this.mPage = Math.max(0,this.mPage - 1);
         this.checkArrows();
         this.fillData();
      }
      
      private function onArrowRightClick(evt:EEvent) : void
      {
         this.mPage = Math.min(this.mHangarUnitsInfo.length / this.mBoxes.length,this.mPage + 1);
         this.checkArrows();
         this.fillData();
      }
      
      private function checkArrows() : void
      {
         var leftArrow:EButton = this.getHudElement("btn_arrow_left") as EButton;
         var rightArrow:EButton = this.getHudElement("btn_arrow_right") as EButton;
         if(leftArrow == null || rightArrow == null || this.mHangarUnitsInfo == null || this.mBoxes == null)
         {
            return;
         }
         leftArrow.setIsEnabled(this.mPage > 0);
         rightArrow.setIsEnabled(this.mPage + 1 < Math.ceil(this.mHangarUnitsInfo.length / this.mBoxes.length));
      }
      
      public function lockArrows(lock:Boolean) : void
      {
         if(lock)
         {
            (this.getHudElement("btn_arrow_left") as EButton).setIsEnabled(false);
            (this.getHudElement("btn_arrow_right") as EButton).setIsEnabled(false);
         }
         else
         {
            this.checkArrows();
         }
      }
      
      private function onNextTargetClick(evt:EEvent) : void
      {
         InstanceMng.getApplication().lockUIWaitForQuickAttackTarget(false);
      }
      
      public function setNextTargetButtonEnabled(value:Boolean) : void
      {
         var btn:EButton = null;
         var espc:ESpriteContainer = this.getHudElement("area_next_target") as ESpriteContainer;
         if(espc)
         {
            btn = espc.getContentAsEButton("btn");
            if(btn)
            {
               btn.setIsEnabled(value);
            }
         }
      }
      
      private function mapGetSku(element:Array, index:int, array:Array) : String
      {
         return element[0];
      }
   }
}
