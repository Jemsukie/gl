package com.dchoc.game.eview.widgets.contest
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.contest.ContestDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   
   public class PopupContestResults extends PopupRewardObtained
   {
       
      
      private var mHasWon:Boolean;
      
      private var mPosition:String;
      
      public function PopupContestResults()
      {
         super();
      }
      
      public function setReward(contestSku:String, rewardStr:String, pos:String, hasWon:Boolean) : void
      {
         var contestDef:ContestDef = null;
         var title:ETextField = null;
         var field:ETextField = null;
         if(contestSku != null)
         {
            if((contestDef = InstanceMng.getContestDefMng().getDefBySku(contestSku) as ContestDef) != null)
            {
               (title = getTitle()).setText(DCTextMng.getText(TextIDs[contestDef.getTitle()]));
            }
         }
         this.mHasWon = hasWon;
         this.mPosition = pos;
         var text:String = DCTextMng.getText(3318);
         if(hasWon)
         {
            text = DCTextMng.getText(135);
         }
         setTopText(text);
         var illusId:String = "illus_mission_complete";
         if(!hasWon)
         {
            illusId = "illus_lose";
         }
         setIllustration(illusId);
         text = DCTextMng.getText(3320);
         if(hasWon)
         {
            text = DCTextMng.getText(3319);
         }
         text = DCTextMng.replaceParameters(text,[pos]);
         setBottomText(text);
         var textureSku:String = hasWon ? "box_with_border" : "box_negative";
         createRewardBox(rewardStr,textureSku,false);
         var reward:ESpriteContainer = getContent("rewardBox") as ESpriteContainer;
         if(!hasWon)
         {
            (field = reward.getContent("title") as ETextField).setText(DCTextMng.getText(3321));
            field.unapplySkinProp(mSkinSku,"text_title_1");
            field.applySkinProp(mSkinSku,"text_light_negative");
            (field = reward.getContent("amount") as ETextField).unapplySkinProp(mSkinSku,"text_title_1");
            field.applySkinProp(mSkinSku,"text_light_negative");
         }
      }
      
      override public function notifyPopupMngClose(e:Object) : void
      {
         if(this.mHasWon)
         {
            InstanceMng.getContestMng().hudOnClosePopupUserHasWon();
         }
         else
         {
            InstanceMng.getContestMng().hudOnClosePopupUserHasLost();
         }
         super.notifyPopupMngClose(e);
      }
   }
}
