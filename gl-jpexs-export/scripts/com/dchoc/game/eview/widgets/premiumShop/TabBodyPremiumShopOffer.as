package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.items.ItemsDef;
   import esparragon.display.ESprite;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.paginator.EPaginatorController;
   
   public class TabBodyPremiumShopOffer extends TabBodyPremiumShop implements EPaginatorController
   {
      
      private static const OFFER:String = "offer";
      
      private static const SUBBODY:String = "subBody";
       
      
      private var mBodyOffer:ELayoutArea;
      
      private var mSubBody:ESprite;
      
      private var mSubArea:ELayoutArea;
      
      public function TabBodyPremiumShopOffer(viewFactory:ViewFactory, skinSku:String)
      {
         super(viewFactory,skinSku,true);
         MAX_BOXES = 3;
         mCheckBoxesSpace = false;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mBodyOffer = null;
         this.mSubBody.destroy();
         this.mSubBody = null;
         this.mSubArea = null;
      }
      
      override public function setup() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         super.setup();
         layoutFactory = mViewFactory.getLayoutAreaFactory("PremiumShopPageOffer");
         this.mSubArea = layoutFactory.getArea("container_boxes");
         this.mSubBody = mViewFactory.getESprite(mSkinSku,this.mSubArea);
         eAddChild(this.mSubBody);
         setContent("subBody",this.mSubBody);
         this.mSubBody.logicTop += mBodyArea.y;
         this.mBodyOffer = layoutFactory.getArea("container_offer");
         mBodyCols = 3;
         mBodyRows = 1;
         mItemsAreaRowHeight = this.mSubArea.height;
         mItemsAreaRowWidth = this.mSubArea.width;
      }
      
      override protected function setInfo(info:Vector.<ItemsDef>) : void
      {
         var i:int = 0;
         var def:ItemsDef = null;
         var defsCount:int = int(info.length);
         var newVector:Vector.<ItemsDef> = new Vector.<ItemsDef>(0);
         for(i = 0; i < defsCount; )
         {
            def = info[i];
            if(def.getIsOffer())
            {
               this.setOffer(def);
            }
            else
            {
               newVector.push(def);
            }
            i++;
         }
         super.setInfo(newVector);
      }
      
      override protected function getBodyArea() : ELayoutArea
      {
         return this.mSubArea;
      }
      
      override protected function getBodyContainer() : ESprite
      {
         return this.mSubBody;
      }
      
      private function setOffer(info:ItemsDef) : void
      {
         var offer:PremiumShopOffer = getContent("offer") as PremiumShopOffer;
         if(offer != null)
         {
            offer.destroy();
            offer = null;
         }
         offer = new PremiumShopOffer(mViewFactory,mSkinSku,mTimerOnBoxesIsAllowed,buyAction);
         offer.setup(info);
         setContent("offer",offer);
         eAddChild(offer);
         this.mBodyOffer.centerContent(offer);
         offer.logicTop += mBodyArea.y;
      }
   }
}
