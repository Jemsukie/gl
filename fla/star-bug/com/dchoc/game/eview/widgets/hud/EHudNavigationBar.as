package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EDropDownButton;
   import com.dchoc.game.eview.widgets.EDropDownSprite;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   
   public class EHudNavigationBar extends ESpriteContainer implements INotifyReceiver
   {
      
      private static const BOOKMARK:String = "icon";
      
      private static const ARROW:String = "btn_go";
      
      private static const TEXT_X:String = "text_x";
      
      private static const TEXT_Y:String = "text_y";
      
      private static const TEXT_INPUT_X_BG:String = "bkg_x";
      
      private static const TEXT_INPUT_Y_BG:String = "bkg_y";
      
      private static const TEXT_INPUT_X:String = "text_input_x";
      
      private static const TEXT_INPUT_Y:String = "text_input_y";
      
      private static const STAR_VIEW_IMAGE:String = "container_planet";
      
      private static const STAR_VIEW_TEXT:String = "text_galaxy";
      
      private static const STAR_VIEW_CLOSE:String = "btn_close";
       
      
      private var mXTF:ETextField;
      
      private var mYTF:ETextField;
      
      private var mNavigationSpeech:EDropDownSprite;
      
      private var mIsRepositioningDone:Boolean = false;
      
      public function EHudNavigationBar()
      {
         super();
         this.build();
      }
      
      private static function getGalaxyView(star:Dictionary) : ESpriteContainer
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var result:ESpriteContainer = InstanceMng.getViewFactory().getESpriteContainer();
         var layout:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("BoxGalaxy");
         var resourceStr:String = InstanceMng.getResourceMng().getAssetByParameter(parseInt(star["type"]),-1,true,false,false);
         var img:EImage;
         (img = viewFactory.getEImage(resourceStr,null,true,layout.getArea("container_planet"),null)).name = star["coord"];
         img.eAddEventListener("click",onPlanetClick);
         result.eAddChild(img);
         result.setContent("container_planet",img);
         var text:ETextField;
         (text = viewFactory.getETextField(null,layout.getTextArea("text_galaxy"),"text_title_3")).setText(star["name"]);
         text.mouseEnabled = false;
         text.mouseChildren = false;
         result.eAddChild(text);
         result.setContent("text_galaxy",text);
         var btn:EButton;
         (btn = viewFactory.getButtonClose(null,layout.getArea("btn_close"))).eAddEventListener("click",onPlanetCloseClick);
         btn.name = star["coord"];
         result.eAddChild(btn);
         result.setContent("btn_close",btn);
         return result;
      }
      
      private static function onPlanetClick(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["coords"] = DCCoordinate.fromString(evt.getTarget().name);
         MessageCenter.getInstance().sendMessage("gotoBookmarkedStar",params);
      }
      
      private static function onPlanetCloseClick(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["coords"] = DCCoordinate.fromString(evt.getTarget().name);
         MessageCenter.getInstance().sendMessage("deleteBookmarkedStar",params);
         MessageCenter.getInstance().sendMessage("refreshBookmarkedStars");
      }
      
      public function getName() : String
      {
         return "HudNavigationBar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["refreshBookmarkedStars","addedBookmarkedStars"];
      }
      
      public function onMessage(cmd:String, params:Dictionary) : void
      {
         switch(cmd)
         {
            case "addedBookmarkedStars":
            case "refreshBookmarkedStars":
               this.buildNavigationDropDown();
         }
      }
      
      public function build() : void
      {
         var iconButton:EButton = null;
         var bg:EImage = null;
         var tf:ETextField = null;
         var layout:ELayoutAreaFactory = InstanceMng.getViewFactory().getLayoutAreaFactory("NavigationBarHud");
         var viewFactory:ViewFactory;
         bg = (viewFactory = InstanceMng.getViewFactory()).getEImage("bar",null,false,layout.getArea("bkg_x"));
         eAddChild(bg);
         setContent("bkg_x",bg);
         bg = viewFactory.getEImage("bar",null,false,layout.getArea("bkg_y"));
         eAddChild(bg);
         setContent("bkg_y",bg);
         tf = viewFactory.getETextField(null,layout.getTextArea("text_x"),"text_body");
         tf.setText("X:");
         eAddChild(tf);
         setContent("text_x",tf);
         tf = viewFactory.getETextField(null,layout.getTextArea("text_y"),"text_body");
         tf.setText("Y:");
         eAddChild(tf);
         setContent("text_y",tf);
         this.mXTF = viewFactory.getETextField(null,layout.getTextArea("text_input_x"),"text_body");
         this.mXTF.setText("0");
         this.mXTF.setEditable(true);
         this.mXTF.setMultiline(false);
         this.mXTF.getTextField().restrict = "0-9";
         this.mXTF.getTextField().addEventListener("keyDown",this.onCoordKeyDown);
         eAddChild(this.mXTF);
         setContent("text_input_x",this.mXTF);
         this.mYTF = viewFactory.getETextField(null,layout.getTextArea("text_input_y"),"text_body");
         this.mYTF.setText("0");
         this.mYTF.setEditable(true);
         this.mYTF.setMultiline(false);
         this.mYTF.getTextField().restrict = "0-9";
         this.mYTF.getTextField().addEventListener("keyDown",this.onCoordKeyDown);
         eAddChild(this.mYTF);
         setContent("text_input_y",this.mYTF);
         if(InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
         {
            this.mXTF.getTextField().displayAsPassword = true;
            this.mYTF.getTextField().displayAsPassword = true;
         }
         (iconButton = viewFactory.getButtonImage("btn_arrow",null,layout.getArea("btn_go"))).eAddEventListener("click",this.onArrowClick);
         eAddChild(iconButton);
         setContent("btn_go",iconButton);
         this.buildNavigationDropDown();
      }
      
      public function buildNavigationDropDown() : void
      {
         var wasOpen:Boolean = false;
         var finalButton:EDropDownButton;
         if(finalButton = getContent("icon") as EDropDownButton)
         {
            wasOpen = finalButton.isOpen();
            getContent("icon").destroy();
         }
         var layout:ELayoutAreaFactory = InstanceMng.getViewFactory().getLayoutAreaFactory("NavigationBarHud");
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var content:ESpriteContainer = this.getBookmarkedStars();
         this.mNavigationSpeech = viewFactory.getDropDownSprite(null,content,"LayoutHudEmptyDropDownArrowUp","down");
         this.mNavigationSpeech.getContentAsETextField("text_title").setText(DCTextMng.getText(2748));
         var iconButton:EButton = viewFactory.getButtonIcon("btn_hud","btn_bookmark",null,layout.getArea("icon"));
         this.mNavigationSpeech.logicTop = iconButton.logicTop + iconButton.getLogicHeight();
         this.mNavigationSpeech.logicLeft = iconButton.logicLeft + iconButton.getLogicWidth() / 2;
         finalButton = viewFactory.getDropDownButton(iconButton,this.mNavigationSpeech);
         if(wasOpen)
         {
            finalButton.open();
         }
         this.mIsRepositioningDone = false;
         eAddChild(finalButton);
         setContent("icon",finalButton);
      }
      
      public function setXCoord(_x:int) : void
      {
         this.mXTF.setText(_x.toString());
      }
      
      public function setYCoord(_y:int) : void
      {
         this.mYTF.setText(_y.toString());
      }
      
      public function getXCoord() : int
      {
         return parseInt(this.mXTF.getText());
      }
      
      public function getYCoord() : int
      {
         return parseInt(this.mYTF.getText());
      }
      
      private function getBookmarkedStars() : ESpriteContainer
      {
         var boxes:Array = null;
         var star:Dictionary = null;
         var layoutArea:ELayoutArea = null;
         var box:ESpriteContainer = null;
         var result:ESpriteContainer = InstanceMng.getViewFactory().getESpriteContainer();
         var stars:Vector.<Dictionary>;
         if((stars = InstanceMng.getMapViewGalaxy().getBookmarksList()) && stars.length)
         {
            boxes = [];
            for each(star in stars)
            {
               box = getGalaxyView(star);
               boxes.push(box);
               result.eAddChild(box);
               result.setContent(star["id"],box);
            }
            layoutArea = InstanceMng.getViewFactory().createMinimumLayoutArea(boxes,3,0,8,0);
            InstanceMng.getViewFactory().distributeSpritesInArea(layoutArea,boxes,1,1,3,-1,true);
         }
         return result;
      }
      
      override public function getLogicWidth() : Number
      {
         var result:Number = NaN;
         var childIndex:int = 0;
         var p:ESpriteContainer = null;
         if(this.mNavigationSpeech)
         {
            childIndex = this.mNavigationSpeech.parent.getChildIndex(this.mNavigationSpeech);
            p = this.mNavigationSpeech.parent as ESpriteContainer;
            p.removeChild(this.mNavigationSpeech);
            result = super.getLogicWidth();
            p.addChildAt(this.mNavigationSpeech,childIndex);
         }
         else
         {
            result = super.getLogicWidth();
         }
         return result;
      }
      
      override public function getLogicHeight() : Number
      {
         var result:Number = NaN;
         var childIndex:int = 0;
         var p:ESpriteContainer = null;
         if(this.mNavigationSpeech)
         {
            childIndex = this.mNavigationSpeech.parent.getChildIndex(this.mNavigationSpeech);
            p = this.mNavigationSpeech.parent as ESpriteContainer;
            p.removeChild(this.mNavigationSpeech);
            result = super.getLogicHeight();
            p.addChildAt(this.mNavigationSpeech,childIndex);
         }
         else
         {
            result = super.getLogicHeight();
         }
         return result;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var lastLeft:Number = NaN;
         var diff:Number = NaN;
         super.logicUpdate(dt);
         if(!this.mIsRepositioningDone && this.mNavigationSpeech.stage)
         {
            lastLeft = this.mNavigationSpeech.logicLeft;
            InstanceMng.getViewFactory().arrangeToFitInMinimumScreen(this.mNavigationSpeech);
            diff = this.mNavigationSpeech.logicLeft - lastLeft;
            this.mNavigationSpeech.getContent("arrow").logicX = this.mNavigationSpeech.getContent("arrow").logicX - diff;
            this.mIsRepositioningDone = true;
         }
      }
      
      private function onArrowClick(evt:EEvent) : void
      {
         var coord:DCCoordinate = new DCCoordinate();
         var x:int = this.getXCoord();
         var y:int = this.getYCoord();
         coord.x = x;
         coord.y = y;
         var params:Dictionary;
         (params = new Dictionary())["coords"] = coord;
         MessageCenter.getInstance().sendMessage("gotoBookmarkedStar",params);
      }
      
      private function onCoordKeyDown(e:KeyboardEvent) : void
      {
         if(e.charCode == 13)
         {
            this.onArrowClick(null);
         }
      }
   }
}
