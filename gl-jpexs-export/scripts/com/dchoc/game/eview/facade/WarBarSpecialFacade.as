package com.dchoc.game.eview.facade
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.hud.EWarBarSpecialBox;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.view.dc.gui.components.GUIBar;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import flash.utils.Dictionary;
   
   public class WarBarSpecialFacade extends GUIBar implements INotifyReceiver
   {
      
      private static const AREA_SPECIAL_ATTACKS:String = "special_attacks";
       
      
      protected var mViewFactory:ViewFactory;
      
      private var mContentHolders:Dictionary;
      
      private var mCanvas:ESpriteContainer;
      
      private var mSpecialAttacks:Dictionary;
      
      public var popupShown:Boolean = false;
      
      public var popupAccepted:Boolean = false;
      
      public function WarBarSpecialFacade()
      {
         super("war_menu_special");
         this.mContentHolders = new Dictionary();
         this.mSpecialAttacks = new Dictionary();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            if(InstanceMng.getItemsMng().isBuilt())
            {
               this.mViewFactory = InstanceMng.getViewFactory();
               this.mCanvas = this.mViewFactory.getESpriteContainer();
               this.createSpecialAttacksPanel();
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function beginDo() : void
      {
         MessageCenter.getInstance().registerObject(this);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvas,InstanceMng.getViewMngGame().getHudLayerSku(),1);
         if(InstanceMng.getRole().mId != 3 || !InstanceMng.getApplication().isTutorialCompleted())
         {
            this.mCanvas.visible = false;
         }
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
      
      public function getName() : String
      {
         return "EWarBarSpecial";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["hotkeyActivated"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var sku:String = null;
         var slotId:int = 0;
         var result:ESpriteContainer = null;
         var specialAttackName:* = undefined;
         var specialAttackSprite:ESprite = null;
         var box:EWarBarSpecialBox = null;
         var i:int = 0;
         var _loc11_:* = task;
         if("hotkeyActivated" === _loc11_)
         {
            if(InstanceMng.getRole().mId == 3)
            {
               if((sku = String(params["sku"])).indexOf("sa-") == 0)
               {
                  slotId = parseInt(sku.substring("sa-".length));
                  result = null;
                  specialAttackName = null;
                  specialAttackSprite = this.getHudElement("special_attacks");
                  i = 0;
                  if(specialAttackSprite != null)
                  {
                     result = (specialAttackSprite as ESpriteContainer).getContentAsESpriteContainer("CONTENT");
                     for(specialAttackName in this.mSpecialAttacks)
                     {
                        if(i == slotId)
                        {
                           (box = result.getContent(specialAttackName) as EWarBarSpecialBox).emulateActionClicked();
                           break;
                        }
                        i++;
                     }
                  }
               }
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
         super.unlock(exception);
         this.lockWarboxes(false);
      }
      
      public function lockWarboxes(lockIt:Boolean) : void
      {
         var result:ESpriteContainer = null;
         var specialAttackName:* = null;
         var specialAttackSprite:ESprite = this.getHudElement("special_attacks");
         if(specialAttackSprite != null)
         {
            result = (specialAttackSprite as ESpriteContainer).getContentAsESpriteContainer("CONTENT");
            for(specialAttackName in this.mSpecialAttacks)
            {
               result.getContent(specialAttackName).setIsEnabled(!lockIt);
            }
         }
      }
      
      public function battleSetMenuClockMode(value:int) : void
      {
         if(value == 2 || value == 3)
         {
            this.lock();
         }
         else
         {
            this.unlock();
         }
      }
      
      private function createSpecialAttacksPanel() : ESprite
      {
         var item:Array = null;
         var layoutButtons:ELayoutArea = null;
         var rewardObject:RewardObject = null;
         var container:EWarBarSpecialBox = null;
         var attacks:Vector.<Array> = InstanceMng.getItemsMng().getArrayVectorForSpecialAttacks();
         var result:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var boxes:Array = [];
         attacks.sort(function(a:Array, b:Array):int
         {
            var aListOrder:int = (a[0] as RewardObject).getSpecialAttackDef().getListOrder();
            var bListOrder:int = (b[0] as RewardObject).getSpecialAttackDef().getListOrder();
            return aListOrder - bListOrder;
         });
         for each(item in attacks)
         {
            rewardObject = item[0];
            container = new EWarBarSpecialBox(rewardObject);
            container.build();
            boxes.push(container);
            result.eAddChild(container);
            result.setContent(container.name,container);
            this.mSpecialAttacks[container.name] = rewardObject;
         }
         layoutButtons = this.mViewFactory.createMinimumLayoutArea(boxes,1);
         this.mViewFactory.distributeSpritesInArea(layoutButtons,boxes,1,1,1,-1,false);
         result = this.createLeftDynamicPanel(result);
         result.getContentAsETextField("TITLE").setText(DCTextMng.getText(261));
         this.addHudElement("special_attacks",result,this.mCanvas,false);
         return container;
      }
      
      private function getHudElement(id:String) : ESprite
      {
         var returnValue:ESprite = null;
         if(this.mContentHolders != null)
         {
            returnValue = this.mContentHolders[id];
         }
         return returnValue;
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
      
      private function createLeftDynamicPanel(content:ESpriteContainer) : ESpriteContainer
      {
         var container:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var layoutAreaFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudLeftVisiting");
         var layoutBkg:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaFactory.getArea("area_colonies"));
         content.logicTop = layoutBkg.y + layoutBkg.height - 8;
         content.logicLeft = layoutBkg.x + 2 * 8;
         layoutBkg.height += content.height;
         layoutBkg.width = 2 * 8 + content.width - layoutBkg.x;
         var bkg:EImage = this.mViewFactory.getEImage("hud_box",null,false,layoutBkg);
         container.eAddChild(bkg);
         container.setContent("BKG",bkg);
         container.eAddChild(content);
         container.setContent("CONTENT",content);
         var title:ETextField = this.mViewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_title"),"text_title");
         container.eAddChild(title);
         title.logicLeft = content.logicLeft + (content.getLogicWidth() - title.getLogicWidth()) / 2;
         container.setContent("TITLE",title);
         return container;
      }
      
      public function reload() : void
      {
      }
   }
}
