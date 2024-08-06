package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupChooseHotkeys extends EGamePopup
   {
       
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mBodyArea:ELayoutArea;
      
      private var mBody:ESprite;
      
      private var mScrollArea:ELayoutArea;
      
      private var mApplyCallback:Function;
      
      private var mHotkeys:Vector.<EHotkeyOption>;
      
      private var mProfile:Profile;
      
      private var mIsConflicting:Boolean;
      
      public function EPopupChooseHotkeys()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mProfile = InstanceMng.getUserInfoMng().getProfileLogin();
         this.mHotkeys = new Vector.<EHotkeyOption>();
         this.setupBackground();
         setTitleText(DCTextMng.getText(4303));
         this.setupBody();
      }
      
      public function setApplyCallback(func:Function) : void
      {
         this.mApplyCallback = func;
      }
      
      private function setupBackground() : void
      {
         this.mLayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopLTabs");
         setLayoutArea(this.mLayoutAreaFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage("pop_l",null,false,this.mLayoutAreaFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,this.mLayoutAreaFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,this.mLayoutAreaFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         this.mBodyArea = this.mLayoutAreaFactory.getArea("body");
         this.mBody = mViewFactory.getESprite(null,this.mBodyArea);
         bkg.eAddChild(this.mBody);
         setContent("body",this.mBody);
         mFooterArea = this.mLayoutAreaFactory.getArea("footer");
      }
      
      private function setupBody() : void
      {
         var button:EButton = null;
         this.mScrollArea = ELayoutAreaFactory.createLayoutArea(this.mBodyArea.width - 15,this.mBodyArea.height);
         this.mScrollArea.x = 0;
         this.mScrollArea.y = this.mLayoutAreaFactory.getTextArea("text_title").height + 20;
         var scrollArea:EScrollArea = new EScrollArea();
         var numRows:int = 14 + Math.ceil(InstanceMng.getHotkeyMng().getNumPlanetSlots() / 2);
         scrollArea.build(this.mScrollArea,numRows,ESpriteContainer,this.fillHotkeyOptions,10);
         mViewFactory.getEScrollBar(scrollArea);
         setContent("content",scrollArea);
         eAddChild(scrollArea);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3969),0,"btn_accept");
         addButton("resetBtn",button);
         button.eAddEventListener("click",this.onResetClicked);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(4319),0,"btn_accept");
         addButton("applyBtn",button);
         button.eAddEventListener("click",this.onApplyClicked);
      }
      
      private function getHotkeyOption(sku:String, layout:ELayoutArea, spriteReference:ESpriteContainer, titleText:String) : EHotkeyOption
      {
         var option:EHotkeyOption = null;
         var initialValue:uint = InstanceMng.getHotkeyMng().getHotkeyValue(sku);
         var initialModifiers:Vector.<Boolean> = InstanceMng.getHotkeyMng().getHotkeyModifiers(sku);
         (option = new EHotkeyOption(sku,titleText,this.checkConflicts)).init(layout,initialValue,initialModifiers);
         spriteReference.setContent(sku,option);
         spriteReference.eAddChild(option);
         return option;
      }
      
      private function fillHotkeyOptions(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var headerField:ETextField = null;
         var skus:* = undefined;
         var sku:String = null;
         var tids:* = undefined;
         var tid:int = 0;
         var option:EHotkeyOption = null;
         var i:int = 0;
         var layout:ELayoutArea = null;
         var itemId:int = 0;
         var multiSkus:* = undefined;
         var multiTitleTids:* = undefined;
         var numPlanetsInRow:int = 0;
         var planetId:int = 0;
         var NUM_COLUMNS:int = 2;
         var ROW_WIDTH:int = this.mScrollArea.width;
         var ROW_HEIGHT:int = 30;
         var COLUMN_PADDING:int = 10;
         var COLUMN_WIDTH:int = ROW_WIDTH / NUM_COLUMNS - COLUMN_PADDING * (NUM_COLUMNS - 1);
         var rowContents:Array = [];
         var optionLayout:ELayoutArea = ELayoutAreaFactory.createLayoutArea(COLUMN_WIDTH,ROW_HEIGHT);
         var rowLayout:ELayoutArea = ELayoutAreaFactory.createLayoutArea(ROW_WIDTH,ROW_HEIGHT);
         var numPlanets:int = InstanceMng.getHotkeyMng().getNumPlanetSlots();
         loop5:
         switch(rowOffset)
         {
            case 0:
               i = 0;
               while(i < NUM_COLUMNS)
               {
                  (layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(optionLayout)).x = i * (COLUMN_WIDTH + COLUMN_PADDING);
                  layout.y = 0;
                  headerField = mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layout),"text_title_0");
                  tid = (tids = new <int>[4335,4336])[i];
                  headerField.setText(DCTextMng.getText(tid));
                  headerField.setFontSize(16);
                  headerField.setHAlign("center");
                  spriteReference.setContent("header-" + rowOffset + "-" + i,headerField);
                  spriteReference.eAddChild(headerField);
                  rowContents.push(headerField);
                  i++;
               }
               break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
               itemId = rowOffset - 1;
               for(i = 0; i < NUM_COLUMNS; )
               {
                  sku = (multiSkus = new <Vector.<String>>[new <String>["none","move","upgrade","flip","demolish"],new <String>["fullscreen","hideHUD","mute","inventory","skin"]])[i][itemId];
                  tid = (multiTitleTids = new <Vector.<int>>[new <int>[15,513,516,514,515],new <int>[33,4337,4338,616,709]])[i][itemId];
                  layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(optionLayout);
                  option = this.getHotkeyOption(sku,layout,spriteReference,DCTextMng.getText(tid));
                  spriteReference.setContent(sku,option);
                  spriteReference.eAddChild(option);
                  rowContents.push(option);
                  this.mHotkeys.push(option);
                  i++;
               }
               break;
            case 6:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(rowLayout);
               (headerField = mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layout),"text_title_0")).setText(DCTextMng.getText(4334));
               headerField.setFontSize(18);
               headerField.setHAlign("center");
               spriteReference.setContent("header-" + rowOffset,headerField);
               spriteReference.eAddChild(headerField);
               rowContents.push(headerField);
               break;
            case 7:
               i = 0;
               while(i < NUM_COLUMNS)
               {
                  (layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(optionLayout)).x = i * (COLUMN_WIDTH + COLUMN_PADDING);
                  headerField = mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layout),"text_title_0");
                  tid = (tids = new <int>[4308,4309])[i];
                  headerField.setText(DCTextMng.getText(tid));
                  headerField.setFontSize(16);
                  headerField.setHAlign("center");
                  spriteReference.setContent("header-" + rowOffset + "-" + i,headerField);
                  spriteReference.eAddChild(headerField);
                  rowContents.push(headerField);
                  i++;
               }
               break;
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
               i = 0;
               while(i < NUM_COLUMNS)
               {
                  sku = (skus = new <String>["sa-","ua-"])[i] + (rowOffset - 8);
                  layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(optionLayout);
                  option = this.getHotkeyOption(sku,layout,spriteReference,"" + (rowOffset - 7));
                  spriteReference.setContent(sku,option);
                  spriteReference.eAddChild(option);
                  rowContents.push(option);
                  this.mHotkeys.push(option);
                  i++;
               }
               break;
            case 13:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(rowLayout);
               (headerField = mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layout),"text_title_0")).setText(DCTextMng.getText(635));
               headerField.setFontSize(16);
               headerField.setHAlign("center");
               spriteReference.setContent("header-" + rowOffset,headerField);
               spriteReference.eAddChild(headerField);
               rowContents.push(headerField);
               break;
            default:
               numPlanetsInRow = Math.min(NUM_COLUMNS,Math.floor(numPlanets / (rowOffset - 13)));
               i = 0;
               while(true)
               {
                  if(i >= numPlanetsInRow)
                  {
                     break loop5;
                  }
                  planetId = rowOffset - 14 + i * Math.ceil(numPlanets / NUM_COLUMNS);
                  sku = "p-" + planetId;
                  layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(optionLayout);
                  option = this.getHotkeyOption(sku,layout,spriteReference,"" + (planetId + 1));
                  spriteReference.setContent(sku,option);
                  spriteReference.eAddChild(option);
                  rowContents.push(option);
                  this.mHotkeys.push(option);
                  i++;
               }
         }
         mViewFactory.distributeSpritesInArea(rowLayout,rowContents,1,1,-1,1,true);
      }
      
      private function onResetClicked(e:EEvent) : void
      {
         for each(var option in this.mHotkeys)
         {
            option.reset();
         }
         this.checkConflicts();
      }
      
      private function onApplyClicked(e:EEvent) : void
      {
         if(this.mIsConflicting)
         {
            return;
         }
         this.mApplyCallback(this.getHotkeysString());
         this.onCloseClick(null);
      }
      
      private function checkConflicts() : void
      {
         var option:* = null;
         var keyChoiceObj:Object = null;
         var thisKeyChoiceObjIsConflictingAt:* = 0;
         var i:int = 0;
         var oldKeyChoiceObj:Object = null;
         this.mIsConflicting = false;
         var hotkeys:Vector.<Array> = new Vector.<Array>(0);
         for each(option in this.mHotkeys)
         {
            keyChoiceObj = option.getObjectForCheckConflicts();
            thisKeyChoiceObjIsConflictingAt = -1;
            for(i = 0; i < hotkeys.length; )
            {
               oldKeyChoiceObj = hotkeys[i][0];
               if(DCUtils.areObjectsEquivalent(oldKeyChoiceObj,keyChoiceObj) && keyChoiceObj["value"] != 0)
               {
                  thisKeyChoiceObjIsConflictingAt = i;
               }
               i++;
            }
            if(thisKeyChoiceObjIsConflictingAt > -1)
            {
               hotkeys[thisKeyChoiceObjIsConflictingAt][1].push(option);
               this.mIsConflicting = true;
            }
            else
            {
               hotkeys.push([keyChoiceObj,new <EHotkeyOption>[option]]);
            }
         }
         for each(var objPair in hotkeys)
         {
            for each(option in objPair[1])
            {
               if(objPair[1].length > 1)
               {
                  option.applySkinProp(null,"glow_red_high");
               }
               else
               {
                  option.unapplySkinProp(null,"glow_red_high");
               }
            }
         }
         getContentAsEButton("applyBtn").setIsEnabled(!this.mIsConflicting);
      }
      
      private function getHotkeysString() : String
      {
         var result:String = "";
         for each(var hotkey in this.mHotkeys)
         {
            result += hotkey.getDataString() + ";";
         }
         if(result == "")
         {
            return result;
         }
         return result.substr(0,result.length - 1);
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
