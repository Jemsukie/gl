package com.dchoc.game.eview.popups.levelup
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.contest.PopupRewardObtained;
   import com.dchoc.game.model.rule.LevelScoreDef;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   
   public class EPopupLevelUp extends PopupRewardObtained
   {
       
      
      private var mFriendsPassed:Vector.<UserInfo>;
      
      private var level:int;
      
      public function EPopupLevelUp()
      {
         super();
      }
      
      public function setLevelUp(level:int, friendPassedIds:Vector.<UserInfo> = null) : void
      {
         this.level = level;
         if(level == InstanceMng.getUserInfoMng().getProfileLogin().getLevel())
         {
            this.mFriendsPassed = friendPassedIds;
         }
         getTitle().setText(DCTextMng.getText(134));
         setIllustration("illus_level_up");
         var levelScoreDef:LevelScoreDef;
         var entry:Entry = (levelScoreDef = InstanceMng.getLevelScoreDefMng().getDefBySku(level.toString()) as LevelScoreDef).getRewardAsEntry();
         createRewardBox(entry.getEntryRaw(),"box_with_border");
         createSubtitleIconBox(level.toString());
      }
      
      override public function notifyPopupMngClose(e:Object) : void
      {
         var event:Object = {};
         event.action = "NotifyLevelUp";
         event.popup = this;
         event.phase = "OUT";
         event.cmd = "NotifyLevelUp";
         event.type = "EventPopup";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
         if(this.mFriendsPassed && this.mFriendsPassed.length)
         {
            event.button = "EVENT_ARROW_RIGHT_PRESSED";
         }
         else
         {
            event.button = "EventCloseButtonPressed";
         }
         event.friendsPassed = this.mFriendsPassed;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
         super.notifyPopupMngClose(e);
      }
   }
}
