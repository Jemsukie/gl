package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.paginator.PaginatorViewSimple;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutArea;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   
   public class ESkinPaginator implements EPaginatorController
   {
       
      
      private var mSkinPaginatorAsset:ESpriteContainer;
      
      private var mSkinPaginatorComponent:EPaginatorComponent;
      
      private var mSkinPaginatorView:PaginatorViewSimple;
      
      private var mSpriteReference:ESpriteContainer;
      
      private var mSkinContentContainer:ESpriteContainer;
      
      public function ESkinPaginator()
      {
         super();
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.fillSkinData(id,true);
         this.mSkinPaginatorView.setPageId(id);
      }
      
      public function init(spriteReference:ESpriteContainer, layoutArea:ELayoutArea) : void
      {
         this.mSpriteReference = spriteReference;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         this.mSkinPaginatorAsset = viewFactory.getPaginatorAssetSimple(layoutArea,"BtnImgM");
         this.mSpriteReference.eAddChild(this.mSkinPaginatorAsset);
         this.mSkinPaginatorView = new PaginatorViewSimple(this.mSkinPaginatorAsset,0);
         this.mSkinPaginatorComponent = new EPaginatorComponent();
         this.mSkinPaginatorComponent.init(this.mSkinPaginatorView,this);
         this.mSkinPaginatorView.setPaginatorComponent(this.mSkinPaginatorComponent);
         this.mSkinContentContainer = new ESpriteContainer();
         this.mSkinPaginatorAsset.eAddChild(this.mSkinContentContainer);
         this.fillSkinData(0,true);
      }
      
      private function fillSkinData(index:int, rebuild:Boolean) : void
      {
         var itemContainer:ESprite = null;
         var skinContainer:ESkinItemView = null;
         var skins:Vector.<String> = InstanceMng.getSkinsMng().getSkinsVector();
         var titles:Vector.<int> = InstanceMng.getSkinsMng().getTitlesVector();
         var descs:Vector.<int> = InstanceMng.getSkinsMng().getDescsVector();
         this.mSkinPaginatorView.setTotalPages(skins.length - 1);
         if(rebuild)
         {
            while(this.mSkinContentContainer.numChildren)
            {
               (itemContainer = this.mSkinContentContainer.getChildAt(0) as ESkinItemView).destroy();
            }
            if(skins[index] != "skinDefault")
            {
               (skinContainer = new ESkinItemView()).buildSkinItem(skins[index],DCTextMng.getText(titles[index]),DCTextMng.getText(descs[index]));
               this.mSkinContentContainer.eAddChild(skinContainer);
               skinContainer.logicTop = 2;
               this.mSkinContentContainer.setContent("itemContainer" + index,skinContainer);
            }
         }
      }
      
      public function setSkinToDefault() : void
      {
         InstanceMng.getSkinsMng().changeSkin("skin_basic_blue");
         InstanceMng.getUserInfoMng().getProfileLogin().setSkin("skin_basic_blue");
         this.fillSkinData(0,true);
      }
   }
}
