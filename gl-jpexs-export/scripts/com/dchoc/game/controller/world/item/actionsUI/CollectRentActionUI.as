package com.dchoc.game.controller.world.item.actionsUI
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   
   public class CollectRentActionUI extends ActionUI
   {
       
      
      private var mCollectAll:Boolean;
      
      public function CollectRentActionUI(actionId:int, target:DCComponent, event:Object, collectAll:Boolean = false)
      {
         var tooltip:String = collectAll ? "TooltipWIOBuilt" : "TooltipWIORecollecting";
         super(actionId,2,target,event,tooltip);
         this.mCollectAll = collectAll;
      }
      
      private function getTypeId(item:WorldItemObject) : int
      {
         var def:WorldItemDef = item.mDef;
         var returnValue:int = def.getTypeId();
         if(this.mCollectAll)
         {
            if(def.isASiloOfCoins())
            {
               returnValue = 0;
            }
            else if(def.isASiloOfMinerals())
            {
               returnValue = 1;
            }
         }
         return returnValue;
      }
      
      override public function getCursorId(item:WorldItemObject) : int
      {
         return this.getTypeId(item) == 0 ? 2 : 3;
      }
      
      override public function mouseClick(item:WorldItemObject, tileIndex:int) : Boolean
      {
         var typeId:int = 0;
         var goAhead:* = false;
         var profileLogin:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(this.mCollectAll)
         {
            if(item.mDef.getCoinsStorage() > 0)
            {
               goAhead = profileLogin.getCoinsFit() > 0;
            }
            else
            {
               goAhead = profileLogin.getMineralsFit() > 0;
            }
            if(goAhead)
            {
               typeId = this.getTypeId(item);
               InstanceMng.getWorldItemObjectController().collectAllCollectableItems(typeId);
               return true;
            }
         }
         if(goAhead = item.getIncomeAmount() > 0)
         {
            if(item.mDef.getTypeId() == 0)
            {
               goAhead = profileLogin.getCoinsFit() > 0;
            }
            else
            {
               goAhead = profileLogin.getMineralsFit() > 0;
            }
         }
         InstanceMng.getMapViewPlanet().lastClickSetLabel("clickOnCompactHouse");
         return goAhead ? super.mouseClick(item,tileIndex) : false;
      }
   }
}
