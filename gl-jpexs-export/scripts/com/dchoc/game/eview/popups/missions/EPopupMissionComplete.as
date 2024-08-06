package com.dchoc.game.eview.popups.missions
{
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.eview.widgets.contest.PopupRewardObtained;
   import com.dchoc.game.model.target.TargetDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutArea;
   
   public class EPopupMissionComplete extends PopupRewardObtained
   {
       
      
      public function EPopupMissionComplete()
      {
         super();
      }
      
      public function setReward(targetDef:TargetDef) : void
      {
         var boxes:Array = null;
         var rewardBox:ESpriteContainer = null;
         var body:ESprite = null;
         var rewardsArea:ELayoutArea = null;
         var title:String = DCTextMng.getText(TextIDs[targetDef.getTargetTitle()]);
         var rewardCoins:String = String(targetDef.getRewardCoins());
         var rewardMinerals:String = String(targetDef.getRewardMinerals());
         var rewardXp:String = String(targetDef.getRewardXp());
         var rewardCash:String = String(targetDef.getRewardCash());
         var rewardItemSku:String;
         var rewardItemAmount:String = String((rewardItemSku = targetDef.getRewardItemSku(false)) != "" ? rewardItemSku.split(":")[1] : "0");
         getTitle().setText(title);
         setTopText(DCTextMng.getText(203));
         setIllustration("illus_mission_complete");
         var entryStr:String = "";
         if(rewardCoins != "0")
         {
            entryStr = EntryFactory.createCoinsSingleEntry(parseInt(rewardCoins)).getEntryRaw();
         }
         if(rewardMinerals != "0")
         {
            if(entryStr != "")
            {
               entryStr += ",";
            }
            entryStr += EntryFactory.createMineralsSingleEntry(parseInt(rewardMinerals)).getEntryRaw();
         }
         if(rewardXp != "0")
         {
            if(entryStr != "")
            {
               entryStr += ",";
            }
            entryStr += EntryFactory.createScoreSingleEntry(parseInt(rewardXp)).getEntryRaw();
         }
         if(rewardCash != "0")
         {
            if(entryStr != "")
            {
               entryStr += ",";
            }
            entryStr += EntryFactory.createCashSingleEntry(parseInt(rewardCash)).getEntryRaw();
         }
         if(rewardItemSku != "")
         {
            if(entryStr != "")
            {
               entryStr += ",";
            }
            entryStr += EntryFactory.createItemSingleEntry(rewardItemSku,parseInt(rewardItemAmount)).getEntryRaw();
         }
         if(entryStr.indexOf(",") < 0)
         {
            createRewardBox(entryStr,"box_with_border",true);
         }
         else
         {
            boxes = [];
            for each(var miniEntryStr in entryStr.split(","))
            {
               rewardBox = mViewFactory.getRewardBox(miniEntryStr,"box_with_border",null);
               boxes.push(rewardBox);
               (body = getContent("body")).eAddChild(rewardBox);
            }
            rewardsArea = mViewFactory.createMinimumLayoutArea(boxes,0,1);
            rewardsArea.y = this.mRewardArea.y;
            rewardsArea.x = this.mRewardArea.x + (this.mRewardArea.width - rewardsArea.width) / 2;
            mViewFactory.distributeSpritesInArea(rewardsArea,boxes,1,1,-1,1,true);
         }
      }
   }
}
