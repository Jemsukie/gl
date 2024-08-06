package com.dchoc.game.model.target
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.target.action.ActionHideArrow;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.core.target.DCTargetProviderInterface;
   
   public class Target extends DCTarget
   {
       
      
      public function Target(targetDef:DCTargetDef, stateId:int, componentCreator:DCTargetProviderInterface)
      {
         super(targetDef,stateId,componentCreator);
      }
      
      override public function logicUpdate() : void
      {
         var currRoleId:int = InstanceMng.getRole().mId;
         var validRole:Boolean = currRoleId == 0 || currRoleId == 5;
         if(validRole)
         {
            super.logicUpdate();
         }
         var targetDef:TargetDef = TargetDef(getDef());
         if(targetDef != null && targetDef.getHiddenInHud() && mStateId == 1)
         {
            changeState(mStateId + 1);
         }
      }
      
      override protected function checkIfArrowNeedsToBeHidden() : void
      {
         var extraCondIndex:String = null;
         var forceHideArrow:Boolean = false;
         var actionHideArrow:ActionHideArrow = null;
         if(mConditionHideArrow != null && getDef() != null && mStateId > 1)
         {
            extraCondIndex = getDef().getHideArrowConditionParameter(1);
            forceHideArrow = false;
            if(extraCondIndex != null)
            {
               if(mCondition != null)
               {
                  forceHideArrow = mCondition.check(this,int(extraCondIndex) - 1);
               }
            }
            if(mConditionHideArrow.check(this) == true || forceHideArrow == true)
            {
               actionHideArrow = new ActionHideArrow();
               actionHideArrow.execute(this,true);
            }
         }
      }
      
      override protected function checkTargetAccount(accId:String, userList:String) : Boolean
      {
         var userInfoObj:UserInfo = null;
         if(accId == null || userList == null || userList == "")
         {
            return true;
         }
         var searchOn:int = InstanceMng.getUserInfoMng().getUserListByKey(userList);
         var returnValue:* = false;
         if(searchOn == -1)
         {
            returnValue = accId == userList;
         }
         else
         {
            returnValue = (userInfoObj = InstanceMng.getUserInfoMng().getUserInfoObj(accId,0,searchOn)) != null;
         }
         return returnValue;
      }
      
      override protected function checkTargetProgressDoneFrom(location:String) : Boolean
      {
         if(location == null || location == "")
         {
            return true;
         }
         var returnValue:Boolean = false;
         var planetId:Number = Number(InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getLastOwnerPlanetIdVisited());
         var currLocation:String = "";
         currLocation = planetId > 1 ? "colony" : "mainPlanet";
         return location == currLocation;
      }
      
      override protected function checkTargetLevel(level:int, index:int) : Boolean
      {
         var targetLevelRequired:int = mTargetDef.getMiniTargetLevel(index);
         return level >= targetLevelRequired;
      }
      
      override protected function checkTimeToFinish(allConditionsOk:Boolean = true) : Boolean
      {
         var timeToFinish:Number = NaN;
         var currTime:Number = NaN;
         var returnValue:Boolean = false;
         if(mStateId > 1)
         {
            if((timeToFinish = getEndTime()) != -1)
            {
               if(allConditionsOk)
               {
                  timeToFinish += InstanceMng.getSettingsDefMng().getBattleTime();
               }
               currTime = DCInstanceMng.getInstance().getApplication().getCurrentServerTimeMillis();
               if(currTime >= timeToFinish)
               {
                  DCDebug.trace("TIME TO FINISH TARGET HAS EXPIRED");
                  DCInstanceMng.getInstance().getApplication().startResetTargetEvents(this.Id);
                  returnValue = true;
               }
            }
         }
         return returnValue;
      }
   }
}
