package com.dchoc.game.eview.facade
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.hud.EHudFriendBarProfileBox;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.view.dc.gui.components.GUIBar;
   import com.gskinner.motion.GTween;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class FriendsBarFacade extends GUIBar
   {
      
      public static const AREA_FRIENDS:String = "container_friends";
      
      public static const BUTTON_ARROW_LEFT:String = "btn_arrow_left";
      
      public static const BUTTON_ARROW_LEFT_DOUBLE:String = "btn_double_arrow_left";
      
      public static const BUTTON_ARROW_RIGHT:String = "btn_arrow_right";
      
      public static const BUTTON_ARROW_RIGHT_DOUBLE:String = "btn_double_arrow_right";
      
      public static const BUTTON_FRIENDS:String = "btn_friends";
      
      public static const MAX_FRIENDS_SHOWN_NORMAL:int = 5;
      
      public static const MAX_FRIENDS_SHOWN_SMALL:int = 7;
      
      public static const MIDDLE_BOX_ID:int = 2;
       
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mViewFactory:ViewFactory;
      
      private var mFriendBoxes:Vector.<EHudFriendBarProfileBox>;
      
      private var mNeighbors:Vector.<UserInfo>;
      
      private var mCanvas:ESpriteContainer;
      
      private var mContentHolders:Dictionary;
      
      private var mFirstFriendToShowIdx:int;
      
      private var mHomeNeighborIdx:int;
      
      private var mSelectedNeighborIdx:int;
      
      public function FriendsBarFacade()
      {
         super("hud_friend_bar");
         this.mContentHolders = new Dictionary();
         this.mFirstFriendToShowIdx = -1;
         this.mSelectedNeighborIdx = -1;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            if(InstanceMng.getResourceMng().isGUIResourcesLoaded())
            {
               buildAdvanceSyncStep();
               this.mViewFactory = InstanceMng.getViewFactory();
               this.mCanvas = this.mViewFactory.getESpriteContainer();
               this.mCanvas.eAddEventListener("rollOver",uiEnable);
               this.mCanvas.eAddEventListener("rollOut",uiDisable);
               this.createLayoutsView();
            }
         }
         else if(step == 1 && InstanceMng.getUserInfoMng().isBuilt() && InstanceMng.getUserInfoMng().getProfileLogin().isBuilt())
         {
            buildAdvanceSyncStep();
            this.getFriendsList();
            this.createFriends();
            this.calculateFirstFriendToShow();
         }
      }
      
      private function createLayoutsView() : void
      {
         this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory(InstanceMng.getUIFacade().getHudBottomLayoutName());
      }
      
      private function createFriends() : void
      {
         var i:int = 0;
         var btn:EButton = null;
         var box:EHudFriendBarProfileBox = null;
         var friendsBar:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         friendsBar.name = "container_friends";
         friendsBar.setLayoutArea(this.mLayoutAreaFactory.getArea("container_friends"));
         this.addHudElement("container_friends",friendsBar,this.mCanvas,false);
         (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactory.getArea("btn_arrow_left"))).eAddEventListener("click",this.onLeftClicked);
         btn.name = "btn_arrow_left";
         this.addHudElement("btn_arrow_left",btn,this.mCanvas,true);
         (btn = this.mViewFactory.getButtonImage("btn_double_arrow",null,this.mLayoutAreaFactory.getArea("btn_double_arrow_left"))).eAddEventListener("click",this.onDoubleLeftClicked);
         btn.name = "btn_double_arrow_left";
         this.addHudElement("btn_double_arrow_left",btn,this.mCanvas,true);
         (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactory.getArea("btn_arrow_right"))).eAddEventListener("click",this.onRightClicked);
         btn.name = "btn_arrow_right";
         this.addHudElement("btn_arrow_right",btn,this.mCanvas,true);
         (btn = this.mViewFactory.getButtonImage("btn_double_arrow",null,this.mLayoutAreaFactory.getArea("btn_double_arrow_right"))).eAddEventListener("click",this.onDoubleRightClicked);
         btn.name = "btn_double_arrow_right";
         this.addHudElement("btn_double_arrow_right",btn,this.mCanvas,true);
         this.mFriendBoxes = new Vector.<EHudFriendBarProfileBox>(0);
         var boxes:Array = [];
         var numFriendsToShow:int = this.getNumFriendsToShow();
         for(i = 0; i < numFriendsToShow; )
         {
            box = new EHudFriendBarProfileBox();
            this.mFriendBoxes.push(box);
            boxes.push(box);
            this.addHudElement("box" + i,box,this.mCanvas,false);
            i++;
         }
         this.mViewFactory.distributeSpritesInArea(this.mLayoutAreaFactory.getArea("container_friends"),boxes,1,1,-1,1,true);
      }
      
      private function getFriendsList() : void
      {
         var otherPlayers:Vector.<UserInfo> = null;
         var accountId:String = null;
         var i:int = 0;
         var sortType:int = 5;
         this.mNeighbors = InstanceMng.getUserInfoMng().getRankingNeighborsList(sortType);
         if(this.mNeighbors == null)
         {
            return;
         }
         if(InstanceMng.getPlatformSettingsDefMng().getUseInvite())
         {
            otherPlayers = InstanceMng.getUserInfoMng().getRandomFriendsToInvite();
            if(otherPlayers != null)
            {
               this.mNeighbors = this.mNeighbors.concat(otherPlayers);
            }
            accountId = InstanceMng.getUserInfoMng().getProfileLogin().getAccountId();
            for(i = 0; i < this.mNeighbors.length; )
            {
               if(this.mNeighbors[i].getAccountId() == accountId)
               {
                  this.mHomeNeighborIdx = i;
                  break;
               }
               i++;
            }
         }
      }
      
      private function calculateFirstFriendToShow() : void
      {
         var boxnum:int = 0;
         var playerBox:int = 0;
         var idx:int = 0;
         var centered:Boolean = false;
         if(this.mSelectedNeighborIdx < 0)
         {
            centered = true;
            this.mSelectedNeighborIdx = this.mHomeNeighborIdx;
         }
         if(this.mNeighbors.length <= this.mFriendBoxes.length)
         {
            this.mFirstFriendToShowIdx = this.mFriendBoxes.length - 1;
         }
         else
         {
            boxnum = this.getBoxFromNeighborId(this.mSelectedNeighborIdx);
            if(centered || boxnum == -1)
            {
               playerBox = this.mHomeNeighborIdx < 2 ? this.mHomeNeighborIdx : 2;
               if(playerBox == 2 && this.mHomeNeighborIdx < this.mFriendBoxes.length)
               {
                  playerBox = this.mFriendBoxes.length - 1 - this.mHomeNeighborIdx;
               }
               if(playerBox < 2)
               {
                  this.mFirstFriendToShowIdx = this.mFriendBoxes.length - 1;
               }
               else
               {
                  if((idx = this.mHomeNeighborIdx + 2) > this.mNeighbors.length - 1 && this.mNeighbors.length > this.mFriendBoxes.length)
                  {
                     idx = this.mNeighbors.length - 1;
                  }
                  this.mFirstFriendToShowIdx = idx;
               }
            }
            else
            {
               this.mFirstFriendToShowIdx = this.mSelectedNeighborIdx + boxnum;
            }
         }
         this.mFirstFriendToShowIdx = Math.max(this.mFriendBoxes.length - 1,this.mFirstFriendToShowIdx);
         this.mFirstFriendToShowIdx = Math.min(this.mNeighbors.length - 1,this.mFirstFriendToShowIdx);
      }
      
      private function getNumFriendsToShow() : int
      {
         var roleId:int = InstanceMng.getFlowState().getCurrentRoleId();
         var viewId:int = InstanceMng.getApplication().viewGetMode();
         if((roleId == 0 || roleId == 5) && viewId == 0)
         {
            return 5;
         }
         return 7;
      }
      
      private function getBoxFromNeighborId(neighborIndex:int) : int
      {
         var l:int = int(this.mFriendBoxes.length);
         var boxIndex:int = this.mFirstFriendToShowIdx - neighborIndex;
         if(boxIndex >= l || boxIndex < 0)
         {
            return -1;
         }
         return boxIndex;
      }
      
      private function fillFriendsInfo() : void
      {
         if(this.mFirstFriendToShowIdx == -1)
         {
            this.calculateFirstFriendToShow();
         }
         var i:int = 0;
         while(this.mFirstFriendToShowIdx - i >= 0 && this.mFirstFriendToShowIdx - i < this.mNeighbors.length && i < this.mFriendBoxes.length)
         {
            this.mFriendBoxes[i].setProfile(this.mNeighbors[this.mFirstFriendToShowIdx - i]);
            i++;
         }
      }
      
      private function checkArrows() : void
      {
         if(this.mFirstFriendToShowIdx == this.mFriendBoxes.length - 1 || this.mFriendBoxes.length > this.mNeighbors.length)
         {
            this.getHudElement("btn_arrow_right").setIsEnabled(false);
            this.getHudElement("btn_double_arrow_right").setIsEnabled(false);
         }
         else
         {
            this.getHudElement("btn_arrow_right").setIsEnabled(true);
            this.getHudElement("btn_double_arrow_right").setIsEnabled(true);
         }
         if(this.mFirstFriendToShowIdx == this.mNeighbors.length - 1)
         {
            this.getHudElement("btn_arrow_left").setIsEnabled(false);
            this.getHudElement("btn_double_arrow_left").setIsEnabled(false);
         }
         else
         {
            this.getHudElement("btn_arrow_left").setIsEnabled(true);
            this.getHudElement("btn_double_arrow_left").setIsEnabled(true);
         }
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvas,InstanceMng.getViewMngGame().getHudLayerSku(),8);
         this.mCanvas.logicY = this.mCanvas.logicY;
         var role:int = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
         setVisible(role != 3 && role != 7);
         if(!InstanceMng.getFlowStatePlanet().isFirstTargetDone() || !isVisible())
         {
            this.mCanvas.pivotLogicY -= 1;
            setVisible(false);
         }
         this.fillFriendsInfo();
         this.checkArrows();
      }
      
      override protected function endDo() : void
      {
         super.beginDo();
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvas,InstanceMng.getViewMngGame().getHudLayerSku());
      }
      
      override protected function uiDisableDoDo() : void
      {
         this.removeMouseEvents();
      }
      
      override protected function uiEnableDoDo() : void
      {
         this.addMouseEvents();
      }
      
      private function addHudElement(id:String, s:ESprite, where:ESpriteContainer, addMouseOverBehaviours:Boolean) : void
      {
         s.name = id;
         if(addMouseOverBehaviours)
         {
            s.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
            s.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
         }
         if(where == null)
         {
            where = this.mCanvas;
         }
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      private function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var s:ESprite = null;
         super.logicUpdateDo(dt);
         for each(s in this.mContentHolders)
         {
            s.logicUpdate(dt);
         }
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
      
      override public function moveDisappearUpToDown(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(isVisible())
         {
            values = {"pivotLogicY":-1};
            tween = new GTween(this.mCanvas,numSeconds,values);
            tween.autoPlay = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(false);
            };
         }
      }
      
      override public function moveAppearDownToUp(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(!isVisible())
         {
            values = {"pivotLogicY":0};
            tween = new GTween(this.mCanvas,numSeconds,values);
            tween.autoPlay = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(true);
            };
         }
      }
      
      public function reload() : void
      {
         if(this.mFriendBoxes != null && this.mFriendBoxes.length > 0)
         {
            this.getFriendsList();
            this.fillFriendsInfo();
         }
      }
      
      public function lockVisitButtonToFriendBox(accountId:String, mode:Boolean) : void
      {
         var f:EHudFriendBarProfileBox = null;
         for each(f in mElements)
         {
            if(f.getAccountId() == accountId)
            {
               if(mode == true)
               {
                  f.disableVisit();
               }
               else
               {
                  f.enableVisit();
               }
            }
         }
      }
      
      public function setSelectedFromList(accountId:String = "-1", neighborIndex:int = -1) : void
      {
         var neighIndex:int = 0;
         var userinfo:UserInfo = null;
         var i:int = 0;
         if(accountId == "-1")
         {
            neighIndex = int(this.mHomeNeighborIdx > 0 ? this.mHomeNeighborIdx - 1 : this.mHomeNeighborIdx);
            accountId = this.mNeighbors[neighIndex].mAccountId;
         }
         if(neighborIndex == -1)
         {
            i = 0;
            for each(userinfo in this.mNeighbors)
            {
               if(userinfo.mAccountId == accountId)
               {
                  neighborIndex = i;
                  break;
               }
               i++;
            }
         }
         this.mSelectedNeighborIdx = neighborIndex;
      }
      
      override public function addMouseEvents() : void
      {
         var s:ESprite = null;
         for each(s in this.mContentHolders)
         {
            s.mouseChildren = true;
            s.mouseEnabled = true;
         }
      }
      
      override public function removeMouseEvents() : void
      {
         var s:ESprite = null;
         for each(s in this.mContentHolders)
         {
            s.mouseChildren = false;
            s.mouseEnabled = false;
         }
      }
      
      override public function unlock(exception:Object = null) : void
      {
         var s:ESprite = null;
         super.unlock();
         this.addMouseEvents();
         if(exception)
         {
            s = this.getHudElement(exception.toString());
            if(s)
            {
               s.mouseChildren = false;
               s.mouseEnabled = false;
            }
         }
      }
      
      override public function lock() : void
      {
         super.lock();
         this.removeMouseEvents();
      }
      
      private function onRightClicked(evt:EEvent) : void
      {
         this.mFirstFriendToShowIdx--;
         this.mFirstFriendToShowIdx = Math.max(this.mFriendBoxes.length - 1,this.mFirstFriendToShowIdx);
         this.fillFriendsInfo();
         this.checkArrows();
      }
      
      private function onLeftClicked(evt:EEvent) : void
      {
         this.mFirstFriendToShowIdx++;
         this.mFirstFriendToShowIdx = Math.min(this.mNeighbors.length - 1,this.mFirstFriendToShowIdx);
         this.fillFriendsInfo();
         this.checkArrows();
      }
      
      private function onDoubleRightClicked(evt:EEvent) : void
      {
         this.mFirstFriendToShowIdx = this.mFriendBoxes.length - 1;
         this.fillFriendsInfo();
         this.checkArrows();
      }
      
      private function onDoubleLeftClicked(evt:EEvent) : void
      {
         this.mFirstFriendToShowIdx = this.mNeighbors.length - 1;
         this.fillFriendsInfo();
         this.checkArrows();
      }
   }
}
