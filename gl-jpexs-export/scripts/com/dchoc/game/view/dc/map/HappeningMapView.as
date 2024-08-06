package com.dchoc.game.view.dc.map
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class HappeningMapView
   {
      
      private static const HALLOWEEN_ANIM:String = "halloween/halloween_npc_anim";
      
      private static const DOOMSDAY_ANIM:String = "background/background_animated_doomsday_winter";
       
      
      private var mIsOn:Boolean = false;
      
      private var mDO:DCDisplayObject;
      
      private var mSku:String;
      
      public function HappeningMapView(sku:String)
      {
         super();
         this.mSku = sku;
         this.setOn(true);
      }
      
      public function unload() : void
      {
         this.mSku = null;
         this.mDO = null;
         this.mIsOn = false;
      }
      
      public function setOn(value:Boolean) : void
      {
         var resourceMng:ResourceMng = null;
         if(this.mIsOn != value)
         {
            switch(this.mSku)
            {
               case "halloween":
                  if(value)
                  {
                     resourceMng = InstanceMng.getResourceMng();
                     resourceMng.catalogAddResource("halloween/halloween_npc_anim",DCResourceMng.getFileName("assets/flash/halloween/halloween_npc_anim.swf"),".swf",0);
                     resourceMng.requestResource("halloween/halloween_npc_anim");
                  }
                  else if(this.mDO != null)
                  {
                     InstanceMng.getViewMngPlanet().removeDropOnMapFromStage(this.mDO);
                     this.mDO = null;
                  }
                  break;
               case "doomsday":
                  if(value)
                  {
                     resourceMng = InstanceMng.getResourceMng();
                     resourceMng.catalogAddResource("background/background_animated_doomsday_winter",DCResourceMng.getFileName("assets/flash/background/background_animated_doomsday_winter.swf"),".swf",0);
                     resourceMng.requestResource("background/background_animated_doomsday_winter");
                  }
                  else if(this.mDO != null)
                  {
                     InstanceMng.getViewMngPlanet().removeDropOnMapFromStage(this.mDO);
                     this.mDO = null;
                  }
            }
            this.mIsOn = value;
         }
      }
      
      public function logicUpdate(dt:int) : void
      {
         var coor:DCCoordinate = null;
         var viewMng:ViewMngPlanet = null;
         if(this.mDO == null && this.mIsOn)
         {
            switch(this.mSku)
            {
               case "halloween":
                  this.mDO = InstanceMng.getResourceMng().getDCDisplayObject("halloween/halloween_npc_anim","animatic_halloween_2",true);
                  if(this.mDO != null)
                  {
                     coor = MyUnit.smCoor;
                     coor.x = 0;
                     coor.y = 0;
                     coor.z = 0;
                     viewMng = InstanceMng.getViewMngPlanet();
                     viewMng.tileRelativeXYToWorldViewPos(coor);
                     this.mDO.x = coor.x;
                     this.mDO.y = coor.y - 205;
                     InstanceMng.getViewMngPlanet().addDropOnMapToStage(this.mDO);
                  }
                  break;
               case "doomsday":
                  this.mDO = InstanceMng.getResourceMng().getDCDisplayObject("background/background_animated_doomsday_winter","event_anim_3",true);
                  if(this.mDO != null)
                  {
                     coor = MyUnit.smCoor;
                     coor.x = 0;
                     coor.y = 0;
                     coor.z = 0;
                     viewMng = InstanceMng.getViewMngPlanet();
                     viewMng.tileRelativeXYToWorldViewPos(coor);
                     this.mDO.x = coor.x;
                     this.mDO.y = coor.y - 205;
                     InstanceMng.getViewMngPlanet().addDropOnMapToStage(this.mDO);
                  }
            }
         }
      }
   }
}
