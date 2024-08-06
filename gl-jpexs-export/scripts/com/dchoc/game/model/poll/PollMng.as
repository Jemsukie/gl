package com.dchoc.game.model.poll
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   
   public class PollMng extends DCComponent
   {
       
      
      private var mPollDef:PollDef;
      
      private var mPollData:Object;
      
      public function PollMng()
      {
         super();
      }
      
      public function loadPollData(pollData:Object) : void
      {
         this.mPollData = {};
         if(pollData.hasOwnProperty("votes"))
         {
            this.mPollData["votes"] = pollData["votes"].split(",");
         }
         this.mPollData["myVote"] = parseInt(pollData["myVote"]);
         this.mPollDef = InstanceMng.getPollDefMng().getDefBySku(pollData["sku"]) as PollDef;
         InstanceMng.getUIFacade().getTopHudFacade().generalInfoNotification(this.isVoteAvailable());
      }
      
      public function pollIsActive() : Boolean
      {
         return this.mPollData != null && this.mPollDef != null;
      }
      
      public function getPollDef() : PollDef
      {
         return this.mPollDef;
      }
      
      public function isVoteAvailable() : Boolean
      {
         return this.mPollData["myVote"] == -1;
      }
      
      public function getMyVote() : int
      {
         return this.mPollData["myVote"];
      }
      
      public function getVotes() : Array
      {
         if(this.mPollData.hasOwnProperty("votes"))
         {
            return this.mPollData["votes"];
         }
         return null;
      }
      
      public function applyMyVote(optionId:int) : void
      {
         this.mPollData["myVote"] = optionId;
         if(this.getVotes() != null)
         {
            this.mPollData["votes"][optionId]++;
         }
         InstanceMng.getUIFacade().getTopHudFacade().generalInfoNotification(false);
         InstanceMng.getUserDataMng().updatePoll_vote(optionId);
      }
   }
}
