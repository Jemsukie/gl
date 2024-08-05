package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.messages.ENotificationWithImage;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EBuyWorkerPopup extends ENotificationWithImage
   {
       
      
      private const TYPE_WORKER:int = 0;
      
      private const TYPE_INVEST:int = 1;
      
      private var mWorkerDef:DroidDef;
      
      private var mWorkerItemsCount:int;
      
      private var mWorkerItems:int;
      
      private var mWorkerChips:int;
      
      private var mInvestItemsCount:int;
      
      private var mInvestItems:int;
      
      public function EBuyWorkerPopup()
      {
         super();
      }
      
      public function setupPopup(workerDef:DroidDef) : void
      {
         this.mWorkerDef = workerDef;
         setupBackground("PopL","pop_l");
         setTitleText(DCTextMng.getText(118));
         setupImage("worker_illus",mImageArea);
         this.setupBottom();
         this.setupButtons();
      }
      
      private function setupBottom() : void
      {
         var i:int = 0;
         var itemContainer:ESpriteContainer = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutContainerColonizeRequirements");
         var body:ESprite = getContent("body");
         var boxes:Array = [];
         var area:ELayoutArea = layoutFactory.getArea("area_requirements");
         var container:ESpriteContainer = this.getContainerItems(area,layoutFactory.getTextArea("text_title_requirements"));
         container.getContentAsETextField("title").setText(DCTextMng.getText(3148));
         body.eAddChild(container);
         setContent("workerItems",container);
         boxes.push(container);
         var itemsList:Array;
         var count:int = int((itemsList = InstanceMng.getRuleMng().getDroidPaymentItemsList(this.mWorkerDef)).length);
         var items:Array = [];
         this.mWorkerItemsCount = count;
         this.mWorkerItems = 0;
         this.mWorkerChips = 0;
         for(i = 0; i < count; )
         {
            itemContainer = this.getItem(itemsList[i],0);
            container.eAddChild(itemContainer);
            container.setContent("item" + i,itemContainer);
            items.push(itemContainer);
            i++;
         }
         mViewFactory.distributeSpritesInArea(area,items,1,1,count,1);
         if(Config.useInvests())
         {
            area = layoutFactory.getArea("area_move");
            container = this.getContainerItems(area,layoutFactory.getTextArea("text_title_move"));
            container.getContentAsETextField("title").setText(DCTextMng.getText(3146));
            body.eAddChild(container);
            setContent("InvestItems",container);
            boxes.push(container);
            count = int((itemsList = this.mWorkerDef.getInvestItemList()).length);
            items.length = 0;
            this.mInvestItemsCount = count;
            this.mInvestItems = 0;
            for(i = 0; i < count; )
            {
               itemContainer = this.getItem(itemsList[i],1);
               container.eAddChild(itemContainer);
               container.setContent("itemInvest" + i,itemContainer);
               items.push(itemContainer);
               i++;
            }
            mViewFactory.distributeSpritesInArea(area,items,1,1,count,1);
         }
         mViewFactory.distributeSpritesInArea(mBottomArea,boxes,1,1,boxes.length,1,true);
      }
      
      private function getItem(info:String, type:int = -1) : ESpriteContainer
      {
         var textprop:String = null;
         var checkArea:ELayoutArea = null;
         var img:EImage = null;
         var arr:Array = info.split(":");
         var sku:String = String(arr[0]);
         var amount:int = parseInt(arr[1]);
         var itemObject:ItemObject;
         var text:String = (itemObject = InstanceMng.getItemsMng().getItemObjectBySku(sku)).quantity + "/" + amount;
         if(itemObject.quantity >= amount)
         {
            textprop = "text_header";
         }
         else
         {
            textprop = "text_negative";
            if(type == 0)
            {
               this.mWorkerChips += (amount - itemObject.quantity) * itemObject.mDef.getOriginalChipsCost();
            }
         }
         var container:ESpriteContainer = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalM",itemObject.mDef.getAssetId(),text,null,textprop,true);
         if(itemObject.quantity >= amount)
         {
            (checkArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(container.getLayoutArea())).addBehavior(mViewFactory.getColorBehavior(16711680));
            img = mViewFactory.getEImage("icon_check",null,false,checkArea);
            container.eAddChild(img);
            container.setContent("check",img);
            if(type == 0)
            {
               this.mWorkerItems++;
            }
            else
            {
               this.mInvestItems++;
            }
         }
         ETooltipMng.getInstance().createTooltipInfoFromDef(itemObject.mDef,container,null,true,false);
         return container;
      }
      
      private function getContainerItems(area:ELayoutArea, titleArea:ELayoutTextArea) : ESpriteContainer
      {
         var container:ESpriteContainer = new ESpriteContainer();
         var bkg:EImage = mViewFactory.getEImage("generic_box",null,false,area);
         container.eAddChild(bkg);
         container.setContent("background",bkg);
         bkg.logicLeft = 0;
         bkg.logicTop = 0;
         var field:ETextField = mViewFactory.getETextField(null,titleArea,"text_header");
         container.eAddChild(field);
         container.setContent("title",field);
         field.logicTop -= area.y;
         field.logicLeft -= area.x;
         return container;
      }
      
      private function setupButtons() : void
      {
         var button:EButton = null;
         var entry:Entry = null;
         removeAllButtons();
         if(this.mWorkerItems < this.mWorkerItemsCount)
         {
            entry = EntryFactory.createCashSingleEntry(this.mWorkerChips);
            button = mViewFactory.getButtonPayment(null,entry);
            addButton("payButton",button);
            button.eAddEventListener("click",this.onClickBuyWithChips);
         }
         else
         {
            button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(118),0,"btn_accept");
            addButton("hireButton",button);
            button.eAddEventListener("click",this.onHireWorkerButton);
         }
         if(Config.useInvests())
         {
            if(this.mInvestItems < this.mInvestItemsCount)
            {
               button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3147),0,"btn_common");
               addButton("getTrainee",button);
               button.eAddEventListener("click",this.onClickGetTrainee);
            }
            else
            {
               button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(118),0,"btn_accept");
               addButton("hireButton2",button);
               button.eAddEventListener("click",this.onHireWorkerButton);
            }
         }
      }
      
      private function onClickGetTrainee(e:EEvent) : void
      {
         InstanceMng.getShopsDrawer().buyWorkerPopupOnClickOnInvests();
         onCloseClick(null);
      }
      
      private function onHireWorkerButton(e:EEvent) : void
      {
         var button:EButton = e.getTarget() as EButton;
         InstanceMng.getShopsDrawer().buyWorkerPopupOnClickOnHireWorker(this.mWorkerDef,button == getContent("hireButton2"));
      }
      
      private function onClickBuyWithChips(e:EEvent) : void
      {
         var i:int = 0;
         var o:Object = null;
         var amountLeft:int = 0;
         var sku:String = null;
         var amount:int = 0;
         var info:Array = null;
         var itemObject:ItemObject = null;
         var v:Vector.<Array> = new Vector.<Array>(0);
         var itemSku:String = "";
         var itemsList:Array = InstanceMng.getRuleMng().getDroidPaymentItemsList(this.mWorkerDef);
         for(i = 0; i < this.mWorkerItemsCount; )
         {
            sku = String((info = itemsList[i].split(":"))[0]);
            amount = parseInt(info[1]);
            itemObject = InstanceMng.getItemsMng().getItemObjectBySku(sku);
            amountLeft = amount - itemObject.quantity;
            if(amountLeft > 0)
            {
               v.push([sku,amountLeft]);
               itemSku += sku + ",";
            }
            i++;
         }
         (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_BUY_ITEMS_WITH_PREMIUM_CURRENCY")).itemList = v;
         o.phase = "OUT";
         o.button = "EventYesButtonPressed";
         o.itemSku = itemSku;
         o.workerDef = this.mWorkerDef;
         o.transaction = InstanceMng.getRuleMng().getTransactionPack(o);
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
      }
   }
}
