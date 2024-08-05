package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.SolarSystem;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.DisplayObjectContainer;
   
   public class ESolarSystemPanel extends EGamePopup
   {
       
      
      private const BODY:String = "body";
      
      private const BOOKMARK_ADD:String = "BookmarkAdd";
      
      private const BOOKMARK_REMOVE:String = "BookmarkRemove";
      
      private var mFilledPlanets:Vector.<Planet>;
      
      private var mEmptyPlanets:Vector.<Planet>;
      
      private var mIsBookmarked:Boolean;
      
      private var mStar:SolarSystem;
      
      private var mFilledPlanetsView:Array;
      
      private var mEmptyPlanetsView:Array;
      
      public function ESolarSystemPanel()
      {
         super();
      }
      
      public function setupPopup(filledPlanets:Vector.<Planet>, emptyPlanets:Vector.<Planet>, isBookMarked:Boolean) : void
      {
         this.mIsBookmarked = isBookMarked;
         this.mFilledPlanets = filledPlanets;
         this.mEmptyPlanets = emptyPlanets;
         this.setupBody();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground("PopM","pop_m");
      }
      
      protected function setupBackground(layoutName:String, background:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(layoutName);
         var bkg:EImage = mViewFactory.getEImage(background,null,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         var body:ESprite = mViewFactory.getESprite(null,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("body",body);
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      private function setupBody() : void
      {
         var i:int = 0;
         var container:ESpriteContainer = null;
         var body:ESprite = getContent("body");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutSystemVisit");
         var button:EButton = mViewFactory.getButtonImage("btn_bookmark_add",null,layoutFactory.getArea("btn_bookmark"));
         body.eAddChild(button);
         setContent("BookmarkAdd",button);
         button.eAddEventListener("click",this.onBookmarkAdd);
         button = mViewFactory.getButtonImage("btn_bookmark_remove",null,layoutFactory.getArea("btn_bookmark"));
         body.eAddChild(button);
         setContent("BookmarkRemove",button);
         button.eAddEventListener("click",this.onBookmarkRemove);
         this.updateBookmark();
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(143),0,"btn_accept");
         addButton("visitButton",button);
         button.eAddEventListener("click",this.onVisit);
         var boxes:Array = [];
         var numPlanets:int = int(this.mFilledPlanets.length);
         this.mFilledPlanetsView = [];
         for(i = 0; i < numPlanets; )
         {
            container = mViewFactory.getProfileExtendedFromPlanet(this.mFilledPlanets[i],true);
            body.eAddChild(container);
            setContent("planet" + i,container);
            boxes.push(container);
            container.mouseChildren = false;
            container.buttonMode = true;
            container.eAddEventListener("click",this.onClickPlanet);
            container.eAddEventListener("rollOver",this.onMouseOver);
            container.eAddEventListener("rollOut",this.onMouseOut);
            this.mFilledPlanetsView.push(container);
            i++;
         }
         if(this.mEmptyPlanets != null)
         {
            this.mEmptyPlanetsView = [];
            numPlanets = int(this.mEmptyPlanets.length);
            for(i = 0; i < numPlanets; )
            {
               container = mViewFactory.getEmptyPlanetView(this.mEmptyPlanets[i]);
               body.eAddChild(container);
               setContent("emptyplanet" + i,container);
               boxes.push(container);
               container.mouseChildren = false;
               container.buttonMode = true;
               container.eAddEventListener("click",this.onClickEmptyPlanet);
               container.eAddEventListener("rollOver",this.onMouseOver);
               container.eAddEventListener("rollOut",this.onMouseOut);
               this.mEmptyPlanetsView.push(container);
               i++;
            }
         }
         mViewFactory.distributeSpritesInArea(layoutFactory.getArea("area_players"),boxes,1,1,6,2,true);
         var titleText:String = this.mStar.getName();
         if(!InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
         {
            titleText = titleText + " (" + this.mStar.getCoordX() + "," + this.mStar.getCoordY() + ")";
         }
         setTitleText(titleText);
      }
      
      public function setStar(star:SolarSystem) : void
      {
         this.mStar = star;
      }
      
      public function getStar() : SolarSystem
      {
         return this.mStar;
      }
      
      private function updateBookmark() : void
      {
         var button:EButton = getContentAsEButton("BookmarkAdd");
         button.visible = !this.mIsBookmarked;
         button = getContentAsEButton("BookmarkRemove");
         button.visible = this.mIsBookmarked;
      }
      
      protected function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onBookmarkAdd(e:EEvent) : void
      {
         if(InstanceMng.getMapViewGalaxy().addBookmark(this.mStar.getId(),this.mStar.getCoords(),this.mStar.getName(),String(this.mStar.getType())))
         {
            this.mIsBookmarked = true;
            this.updateBookmark();
         }
      }
      
      private function onBookmarkRemove(e:EEvent) : void
      {
         if(InstanceMng.getMapViewGalaxy().deleteBookmark(this.mStar.getCoords()))
         {
            this.mIsBookmarked = false;
            this.updateBookmark();
         }
      }
      
      private function onVisit(e:EEvent) : void
      {
         InstanceMng.getMapViewGalaxy().setEmptyPlanetClicked(null);
         this.onCloseClick(null);
         InstanceMng.getApplication().goToSolarSystem(this.mStar.getCoords(),this.mStar.getName(),this.mStar.getId(),this.mStar.getType());
      }
      
      private function onClickPlanet(e:EEvent) : void
      {
         var planet:Planet = null;
         var user:UserInfo = null;
         var o:Object = null;
         var planetView:ESpriteContainer = e.getTarget() as ESpriteContainer;
         var planetIndex:int = this.mFilledPlanetsView.indexOf(planetView);
         if(planetIndex > -1)
         {
            planet = this.mFilledPlanets[planetIndex];
            user = InstanceMng.getUserInfoMng().getUserInfoObj(planet.getOwnerAccId(),0);
            DCDebug.traceCh("AttackLogic","[ESolSys] user = " + user + " | planet = " + planet);
            if(user != null && mViewFactory.userCanBeAttackedPlanet(user,planet))
            {
               DCDebug.traceCh("AttackLogic","[ESolSys] Attackable, requesting attack");
               InstanceMng.getMapViewGalaxy().onAttackRequest(user.getAccountId(),planet);
               return;
            }
            (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","PopupPlanetOccupiedOptions")).planet = planet;
            o.accId = planet.getOwnerAccId();
            o.doc = planetView as DisplayObjectContainer;
            InstanceMng.getMapViewSolarSystem().getStarType();
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
         }
      }
      
      private function onClickEmptyPlanet(e:EEvent) : void
      {
         var planet:Planet = null;
         var o:Object = null;
         var planetView:ESpriteContainer = e.getTarget() as ESpriteContainer;
         var planetIndex:int = this.mEmptyPlanetsView.indexOf(planetView);
         if(planetIndex > -1)
         {
            planet = this.mEmptyPlanets[planetIndex];
            (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_STAR_SHOW_EMPTY_PLANET_POPUP")).planet = planet;
            o.star = this.mStar;
            o.doc = planetView as DisplayObjectContainer;
            InstanceMng.getMapViewSolarSystem().getStarType();
            InstanceMng.getMapViewGalaxy().setEmptyPlanetClicked(planet);
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
         }
      }
      
      private function onMouseOver(e:EEvent) : void
      {
         var sp:ESprite = e.getTarget() as ESprite;
         sp.applySkinProp(null,"mouse_over_button");
      }
      
      private function onMouseOut(e:EEvent) : void
      {
         var sp:ESprite = e.getTarget() as ESprite;
         sp.unapplySkinProp(null,"mouse_over_button");
      }
   }
}
