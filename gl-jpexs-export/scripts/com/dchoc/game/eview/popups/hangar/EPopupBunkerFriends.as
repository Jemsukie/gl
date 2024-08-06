package com.dchoc.game.eview.popups.hangar
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.PaginatorViewSimple;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.utils.Dictionary;
   
   public class EPopupBunkerFriends extends EGamePopup implements EPaginatorController, INotifyReceiver
   {
      
      private static const CONTAINER_UNITS:String = "container_units";
      
      private static const AREA_PRICE:String = "area_price";
      
      private static const AREA_PRICE_BKG:String = "container_btn_minerals";
      
      private static const AREA_TRANSFER_BUTTON:String = "base";
      
      private static const SPEECH_CONTENT:String = "speech_content";
      
      private static const SPEECH_ARROW:String = "speech_arrow";
      
      private static const SPEECH_BOX:String = "speech_box";
      
      private static const TEXT_DEFENSE_BUNKER:String = "text_title_bunker";
      
      private static const TEXT_INFO:String = "text_info";
      
      private static const UNITS_PER_PAGE:int = 5;
      
      private static const NUM_BOXES_SUPPORT:int = 4;
       
      
      protected var mCapacityBar:IconBar;
      
      protected var mBunkerRef:Bunker;
      
      protected var mBunkerBoxes:Vector.<EUnitItemView>;
      
      protected var mSupportBoxes:Vector.<EFriendView>;
      
      protected var mBunkerPaginatorComponent:EPaginatorComponent;
      
      protected var mBunkerPaginatorView:PaginatorViewSimple;
      
      private var mFriendsIds:Vector.<String>;
      
      public function EPopupBunkerFriends(bunker:Bunker)
      {
         super();
         this.mBunkerRef = bunker;
         this.mBunkerBoxes = new Vector.<EUnitItemView>(5);
         this.mSupportBoxes = new Vector.<EFriendView>(4);
      }
      
      public function build(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var image:EImage = null;
         var tf:ETextField = null;
         super.setup(popupId,viewFactory,skinId);
         var popupLayoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutBunkerFriends");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXL");
         var content:ESprite = mViewFactory.getESprite(skinId);
         var title:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setFooterArea(layoutFactory.getArea("footer"));
         this.mFriendsIds = this.mBunkerRef.getHelpUserAccountIds();
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = mViewFactory.getEImage("pop_xl",mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         setTitle(title);
         setTitleText(DCTextMng.getText(1026));
         bkg.eAddChild(getTitle());
         content.eAddChild(image = mViewFactory.getEImage("bunker_box",mSkinSku,false,popupLayoutFactory.getArea("area_units_transfered")));
         setContent("area_units_transfered",image);
         this.mCapacityBar = new IconBar();
         this.mCapacityBar.setup("IconBarL",this.mBunkerRef.getCapacityOccupied(),this.mBunkerRef.getMaxCapacity(),"color_capacity","icon_hangar");
         this.mCapacityBar.updateText(this.mBunkerRef.getCapacityOccupied() + "/" + this.mBunkerRef.getMaxCapacity());
         this.mCapacityBar.updateTopText(DCTextMng.getText(610));
         this.mCapacityBar.logicUpdate(0);
         this.mCapacityBar.layoutApplyTransformations(popupLayoutFactory.getArea("container_bar_l"));
         content.eAddChild(this.mCapacityBar);
         setContent("container_bar_l",this.mCapacityBar);
         content.eAddChild(tf = mViewFactory.getETextField(mSkinSku,popupLayoutFactory.getTextArea("text_title_bunker")));
         setContent("text_title_bunker",tf);
         tf.applySkinProp(mSkinSku,"text_title_0");
         var paginatorBunker:ESpriteContainer = mViewFactory.getPaginatorAssetSimple(popupLayoutFactory.getArea("container_units"),"BtnImgM",mSkinSku);
         this.mBunkerPaginatorView = new PaginatorViewSimple(paginatorBunker,1);
         this.mBunkerPaginatorComponent = new EPaginatorComponent();
         this.mBunkerPaginatorComponent.init(this.mBunkerPaginatorView,this);
         this.mBunkerPaginatorView.setPaginatorComponent(this.mBunkerPaginatorComponent);
         content.eAddChild(paginatorBunker);
         setContent("container_units",paginatorBunker);
         var advisor:EImage = mViewFactory.getEImage("friends",mSkinSku,true,popupLayoutFactory.getArea("character"));
         content.eAddChild(advisor);
         setContent("character",advisor);
         var arrow:EImage = mViewFactory.getEImage("speech_arrow",mSkinSku,false,popupLayoutFactory.getArea("speech_arrow"),"speech_color");
         setContent("speech_arrow",arrow);
         var speechContent:ESpriteContainer = mViewFactory.getESpriteContainer();
         setContent("speech_content",speechContent);
         this.loadBoxes(popupLayoutFactory.getArea("container_units"),popupLayoutFactory.getArea("container_profiles"));
         var speechBox:ESprite = mViewFactory.getSpeechBubble(popupLayoutFactory.getArea("area_speech"),arrow.getLayoutArea(),null,mSkinSku,"speech_color",false);
         setContent("speech_box",speechBox);
         popupLayoutFactory.getArea("area_speech").centerContent(speechContent);
         content.eAddChild(speechBox);
         content.eAddChild(speechContent);
         content.eAddChild(tf = mViewFactory.getETextField(mSkinSku,popupLayoutFactory.getTextArea("text_info")));
         setContent("text_info",tf);
         tf.setText(DCTextMng.getText(1028));
         tf.applySkinProp(mSkinSku,"text_body");
         tf.visible = this.mFriendsIds.length == 0;
         content.eAddChild(getContent("speech_arrow"));
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         closeButton.eAddEventListener("click",notifyPopupMngClose);
         bkg.eAddChild(content);
         setContent("CONTENT",content);
         content.layoutApplyTransformations(layoutFactory.getArea("body"));
         this.reloadView();
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         MessageCenter.getInstance().unregisterObject(this);
      }
      
      private function loadBoxes(bunkerArea:ELayoutArea, friendsArea:ELayoutArea) : void
      {
         var i:int = 0;
         var esprite:ESprite = null;
         var offsetX:int = 0;
         var userInfo:UserInfo = null;
         esprite = getContent("container_units");
         offsetX = 0;
         for(i = 0; i < this.mBunkerBoxes.length; )
         {
            this.mBunkerBoxes[i] = new EUnitItemView();
            this.mBunkerBoxes[i].build();
            esprite.eAddChild(this.mBunkerBoxes[i]);
            offsetX += this.mBunkerBoxes[i].getLogicWidth();
            i++;
         }
         offsetX = (bunkerArea.width - offsetX) / (5 + 1);
         for(i = 0; i < this.mBunkerBoxes.length; )
         {
            this.mBunkerBoxes[i].logicLeft += offsetX * (i + 1) + this.mBunkerBoxes[i].getLogicWidth() * i;
            i++;
         }
         esprite = getContent("speech_content");
         offsetX = 0;
         for(i = 0; i < this.mSupportBoxes.length; )
         {
            this.mSupportBoxes[i] = new EFriendView(1);
            userInfo = i < this.mFriendsIds.length ? InstanceMng.getUserInfoMng().getUserInfoObj(this.mFriendsIds[i],0) : null;
            this.mSupportBoxes[i].build(userInfo);
            if(i < this.mFriendsIds.length)
            {
               this.mSupportBoxes[i].setButtonEnabled(!this.mBunkerRef.isHelpUserThanked(this.mFriendsIds[i]));
            }
            esprite.eAddChild(this.mSupportBoxes[i]);
            offsetX += this.mSupportBoxes[i].getLogicWidth();
            i++;
         }
         offsetX = (friendsArea.width - offsetX) / (5 + 1);
         for(i = 0; i < this.mSupportBoxes.length; )
         {
            this.mSupportBoxes[i].logicLeft += offsetX * (i + 1) + this.mSupportBoxes[i].getLogicWidth() * i;
            i++;
         }
      }
      
      public function reloadView() : void
      {
         var unit:Array = null;
         var i:int = 0;
         var bunkerRemainingSpace:int = this.mBunkerRef.getCapacityLeft();
         var vector:Vector.<Array> = this.mBunkerRef.getWarUnitsInfoAsVector();
         this.mBunkerPaginatorView.setTotalPages(Math.ceil(vector.length / 5));
         var currentPage:int = this.mBunkerPaginatorView.getCurrentPage();
         i = 0;
         while(i < 5 && i + 5 * currentPage < vector.length)
         {
            unit = vector[i + 5 * currentPage];
            this.mBunkerBoxes[i].fillData(unit);
            this.mBunkerBoxes[i].visible = true;
            i++;
         }
         while(i < 5)
         {
            this.mBunkerBoxes[i].visible = false;
            i++;
         }
         i = 0;
         while(i < 4 && i < this.mFriendsIds.length)
         {
            this.mSupportBoxes[i].visible = true;
            i++;
         }
         while(i < 4)
         {
            this.mSupportBoxes[i].visible = false;
            i++;
         }
         this.updateCapacityLabel();
      }
      
      private function updateCapacityLabel() : void
      {
         var currentCapacity:int = this.mBunkerRef.getCapacityOccupied();
         var maxCapacity:int = this.mBunkerRef.getMaxCapacity();
         this.mCapacityBar.setBarMaxValue(maxCapacity);
         this.mCapacityBar.setBarCurrentValue(currentCapacity);
         var currentCapacityStr:String = "" + currentCapacity;
         var maxCapacityStr:String = "" + maxCapacity;
         this.mCapacityBar.updateText(currentCapacityStr + "/" + maxCapacityStr);
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.reloadView();
      }
      
      public function getName() : String
      {
         return "PopupBunker";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["hangarKillUnit"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var user:UserInfo = null;
         var _loc4_:* = task;
         if("hangarKillUnit" === _loc4_)
         {
            this.mBunkerRef.removeUnit(params["sku"]);
            InstanceMng.getUserDataMng().updateShips_killUnitFromBunker(params["sku"],parseInt(this.mBunkerRef.getSid()),null);
            this.reloadView();
         }
      }
   }
}
