package com.dchoc.game.model.shop
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.items.ItemsDefMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class ShopDef extends DCDef
   {
      
      public static const LAYOUT_TYPE_GRID:String = "grid";
      
      public static const LAYOUT_TYPE_SHIELD:String = "shields";
      
      public static const LAYOUT_TYPE_3X1:String = "3x1";
       
      
      private var mItemSkus:String = null;
      
      private var mTabTitle:String = null;
      
      private var mTabDesc:String = null;
      
      private var mTabContent:Vector.<ItemsDef> = null;
      
      private var mContainsOffer:Boolean = false;
      
      private var mTimeLeftSku:String = null;
      
      private var mOrder:int = 0;
      
      private var mLayout:String;
      
      private var mServerProvided:Boolean = false;
      
      public function ShopDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "items";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setItemSkus(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tabTitleTID";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTabTitleTID(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tabDescTID";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTabDescTID(EUtils.xmlReadString(info,attribute));
         }
         attribute = "order";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOrder(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "layout";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLayout(EUtils.xmlReadString(info,attribute));
         }
         attribute = "serverprovided";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIsServerProvided(EUtils.xmlReadBoolean(info,attribute));
         }
      }
      
      override public function build() : void
      {
         this.mTabContent = null;
         this.mTimeLeftSku = null;
      }
      
      private function setItemSkus(value:String) : void
      {
         this.mItemSkus = value;
      }
      
      private function setTabTitleTID(value:String) : void
      {
         this.mTabTitle = value;
      }
      
      public function getTabTitleTID() : String
      {
         return this.mTabTitle;
      }
      
      private function setTabDescTID(value:String) : void
      {
         this.mTabDesc = value;
      }
      
      public function getTabDescTID() : String
      {
         return this.mTabDesc;
      }
      
      private function setOrder(value:int) : void
      {
         this.mOrder = value;
      }
      
      override public function getOrder() : int
      {
         return this.mOrder;
      }
      
      public function getTabContent() : Vector.<ItemsDef>
      {
         var itemsDefMng:ItemsDefMng = null;
         var tokens:Array = null;
         var token:String = null;
         var itemDef:ItemsDef = null;
         var sameClock:Boolean = false;
         var timeLeftSku:* = null;
         var itemTimeLeftSku:String = null;
         if(this.mTabContent == null)
         {
            this.mTabContent = new Vector.<ItemsDef>(0);
            this.mContainsOffer = false;
            if(this.mItemSkus != null)
            {
               itemsDefMng = InstanceMng.getItemsDefMng();
               tokens = this.mItemSkus.split(",");
               sameClock = true;
               timeLeftSku = "";
               itemTimeLeftSku = null;
               for each(token in tokens)
               {
                  itemDef = itemsDefMng.getDefBySku(token) as ItemsDef;
                  if(itemDef != null)
                  {
                     this.mTabContent.push(itemDef);
                     if(itemDef.getIsOffer())
                     {
                        this.mContainsOffer = true;
                     }
                     itemTimeLeftSku = itemDef.getTimeLeftSku();
                     if(timeLeftSku == "")
                     {
                        timeLeftSku = itemTimeLeftSku;
                     }
                     else if(timeLeftSku != itemTimeLeftSku)
                     {
                        sameClock = false;
                     }
                  }
               }
               if(tokens == null || tokens.length == 1)
               {
                  this.mTimeLeftSku = null;
               }
               else
               {
                  this.mTimeLeftSku = timeLeftSku;
               }
            }
         }
         return this.mTabContent;
      }
      
      public function containsOffer() : Boolean
      {
         if(this.mTabContent == null)
         {
            this.getTabContent();
         }
         return this.mContainsOffer;
      }
      
      public function needsToShowClock() : Boolean
      {
         return this.mLayout == "shields";
      }
      
      public function getTimeLeft() : Number
      {
         return InstanceMng.getApplication().timeLeftGet(this.mTimeLeftSku);
      }
      
      protected function sortItemsByPrice(a:ItemsDef, b:ItemsDef) : Number
      {
         var aNum:Number = a.getCredits();
         var bNum:Number = b.getCredits();
         if(aNum > 0 && bNum > 0)
         {
            return this.valueComparison(aNum,bNum);
         }
         if(aNum == 0 && bNum == 0)
         {
            aNum = a.getCash();
            bNum = b.getCash();
            return this.valueComparison(aNum,bNum);
         }
         if(aNum == 0)
         {
            return -1;
         }
         if(bNum == 0)
         {
            return 1;
         }
         return 0;
      }
      
      private function valueComparison(a:Number, b:Number) : Number
      {
         if(a > b)
         {
            return 1;
         }
         if(a < b)
         {
            return -1;
         }
         return 0;
      }
      
      private function setLayout(value:String) : void
      {
         this.mLayout = value;
      }
      
      public function getLayout() : String
      {
         return this.mLayout;
      }
      
      private function setIsServerProvided(value:Boolean) : void
      {
         this.mServerProvided = value;
      }
      
      public function getIsServerProvided() : Boolean
      {
         return this.mServerProvided;
      }
   }
}
