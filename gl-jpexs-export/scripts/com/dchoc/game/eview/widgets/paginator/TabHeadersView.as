package com.dchoc.game.eview.widgets.paginator
{
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.display.ESprite;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorView;
   import flash.ui.Mouse;
   
   public class TabHeadersView implements EPaginatorView
   {
      
      public static const TAB_TEXTFIELD:String = "textField";
      
      public static const TAB_BACKGROUND:String = "background";
      
      public static const TAB_HEADERS_TEXT:String = "text";
      
      public static const TAB_HEADERS_IMG:String = "img";
      
      public static const TAB_HEADERS_TEXT_BKG_SCALED:String = "textScale";
      
      private static const TAB_TEXT_MARGIN:int = 10;
       
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      private var mHeaders:Vector.<EButton>;
      
      private var mHeadersArea:ELayoutArea;
      
      private var mHeadersType:String;
      
      private var mHeadersCount:int;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mHeaderSelected:int;
      
      public function TabHeadersView(area:ELayoutArea, viewFactory:ViewFactory, skin:String, type:String = "textScale")
      {
         super();
         this.mHeadersArea = area;
         this.mHeadersType = type;
         this.mViewFactory = viewFactory;
         this.mSkinSku = skin;
         this.mHeaderSelected = -1;
      }
      
      public function destroy() : void
      {
         this.mViewFactory = null;
         this.mSkinSku = null;
         this.mHeaders = null;
         this.mHeadersArea = null;
         this.mHeadersType = null;
         this.mPaginatorComponent = null;
      }
      
      public function setTabHeaders(headers:Vector.<EButton>) : void
      {
         var button:EButton = null;
         var i:int = 0;
         this.mHeaders = headers;
         if(this.mHeaders != null)
         {
            this.mHeadersCount = this.mHeaders.length;
            this.mViewFactory.distributeButtons(this.mHeaders,this.mHeadersArea,true);
            for(i = 0; i < this.mHeadersCount; )
            {
               button = this.mHeaders[i];
               button.eAddEventListener("click",this.onTabHeaderClick);
               this.viewDisableTab(i);
               i++;
            }
            this.setPageId(0);
         }
      }
      
      public function setPageId(id:int) : void
      {
         if(this.mHeaders != null && this.mHeaderSelected != id)
         {
            this.viewDisableTab(this.mHeaderSelected);
            this.mHeaderSelected = id;
            this.viewEnableTab(this.mHeaderSelected);
         }
      }
      
      private function isAValidIndex(id:int) : Boolean
      {
         return this.mHeaders != null && id >= 0 && id < this.mHeaders.length;
      }
      
      private function viewDisableTab(id:int) : void
      {
         var tab:EButton = null;
         var bkg:ESprite = null;
         if(this.isAValidIndex(id))
         {
            tab = this.mHeaders[id];
            if(tab != null)
            {
               if(!tab.swapBkg(false))
               {
                  bkg = tab.getBackground();
                  if(bkg != null)
                  {
                     bkg.applySkinProp(this.mSkinSku,tab.getUnselectedProp());
                  }
               }
               tab.parent.addChildAt(tab,1);
            }
         }
      }
      
      private function viewEnableTab(id:int) : void
      {
         var tab:EButton = null;
         var bkg:ESprite = null;
         if(this.isAValidIndex(id))
         {
            tab = this.mHeaders[id];
            if(tab != null)
            {
               if(!tab.swapBkg(true))
               {
                  bkg = tab.getBackground();
                  if(bkg != null)
                  {
                     bkg.unapplySkinProp(this.mSkinSku,tab.getUnselectedProp());
                  }
               }
               tab.parent.addChild(tab);
            }
         }
      }
      
      public function setPaginatorComponent(pc:EPaginatorComponent) : void
      {
         this.mPaginatorComponent = pc;
      }
      
      private function onTabHeaderClick(e:EEvent) : void
      {
         var tab:EButton = e.getTarget() as EButton;
         var index:int = this.mHeaders.indexOf(tab);
         if(index > -1 && this.mPaginatorComponent != null)
         {
            this.mPaginatorComponent.setPageId(index);
            Mouse.cursor = "auto";
         }
      }
      
      public function getTabHeaderSelected() : int
      {
         return this.mHeaderSelected;
      }
   }
}
