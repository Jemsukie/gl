package com.dchoc.game.eview.widgets.bet
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.smallStructures.ResourceFillBar;
   import com.dchoc.game.model.bet.Bet;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class PopupBetResult extends EGamePopup
   {
      
      private static const BODY_BATTLE_ID:String = "BODY_BATTLE";
      
      private static const BODY_VICTORY_ID:String = "BODY_VICTORY";
      
      private static const CLOSE_BUTTON_ID:String = "CLOSE_BUTTON";
      
      private static const SHARE_BUTTON_ID:String = "SHARE_BUTTON";
      
      private static const PROFILE_CONT_ID:String = "PROFILE_CONT";
      
      private static const PROFILE_NAME_ID:String = "PROFILE_NAME";
      
      private static const PROFILE_PICTURE_ID:String = "PROFILE_PICTURE";
      
      private static const PROFILE_CONT_ENEMY_ID:String = "PROFILE_CONT_ENEMY";
      
      private static const PROFILE_NAME_ENEMY_ID:String = "PROFILE_NAME_ENEMY";
      
      private static const PROFILE_PICTURE_ENEMY_ID:String = "PROFILE_PICTURE_ENEMY";
      
      private static const RAY_IMAGE_ID:String = "RAY_IMAGE";
      
      private static const VS_TEXT_ID:String = "VS_TEXT";
      
      private static const CLOCK_CONT_ID:String = "CLOCK_CONT";
      
      private static const CLOCK_ICON_ID:String = "CLOCK_ICON";
      
      private static const CLOCK_TEXT_ID:String = "CLOCK_TEXT";
      
      private static const CLOCK_CONT_ENEMY_ID:String = "CLOCK_CONT_ENEMY";
      
      private static const CLOCK_ICON_ENEMY_ID:String = "CLOCK_CON_ENEMY";
      
      private static const CLOCK_TEXT_ENEMY_ID:String = "CLOCK_TEXT_ENEMY";
      
      private static const TEXT_REWARD_ID:String = "TEXT_REWARD";
      
      private static const TEXT_RESULT_ID:String = "TEXT_RESULT";
      
      private static const REWARD_VALUE_ID:String = "REWARD_VALUE";
      
      private static const SCORE_PERCENT_ICON_ID:String = "SCORE_PERCENT_ICON";
      
      private static const SCORE_PERCENT_TEXT_ID:String = "SCORE_PERCENT_TEXT";
      
      private static const SCORE_PERCENT_TEXT_ENEMY_ID:String = "SCORE_PERCENT_TEXT_ENEMY";
      
      private static const CHIPS_ID:String = "CHIPS_IMG";
      
      private static const LAUREL_ID:String = "LAUREL";
      
      private static const LAUREL_FLIP_ID:String = "LAUREL_FLIP";
      
      private static const SPEECH_BOX_ID:String = "SPEECH_BOX";
      
      private static const SPEECH_ARROW_ID:String = "SPEECH_ARROW";
      
      private static const SPEECH_TEXT_ID:String = "SPEECH_TEXT";
      
      private static const HEADLINE_TEXT_ID:String = "HEADLINE_TEXT";
      
      private static const TIME_REMAINING_TEXT_ID:String = "TIME_REMAINING_TEXT";
      
      private static const HEADLINE_ADVISOR_ID:String = "HEADLINE_ADVISOR";
      
      private static const SCORE_BATTLE_FILL_BAR_ID:String = "SCORE_BATTLE_FILL_BAR";
      
      private static const SCORE_VICTORY_FILL_BAR_ID:String = "SCORE_VICTORY_FILL_BAR";
      
      private static const RESULTS_COINS_ANIM_TIME:int = 1500;
      
      private static const RESULTS_MINERALS_ANIM_TIME:int = 1500;
      
      private static const RESULTS_SCORE_ANIM_SPEED:Number = 0.035;
      
      private static const RESULTS_BLINK_SCORE_ANIM_TIME:int = 4000;
      
      private static const RESULTS_TIME_ANIM_SPEED:Number = 80;
      
      private static const RESULTS_BLINK_MAX_SCALE:Number = 1.12;
      
      private static const RESULTS_BLINK_INC_SCALE:Number = 0.0003;
      
      public static const STATE_NONE:int = -1;
      
      public static const STATE_WAITING_FOR_OPPONENT_END_BATTLE:int = 0;
      
      public static const STATE_RESULTS_ANIMATION:int = 1;
      
      public static const STATE_END:int = 2;
      
      private static const HEADLINES_STATE_EMPTY:int = 0;
      
      private static const HEADLINES_STATE_SHOW:int = 1;
      
      private static const HEADLINES_TIME_BETWEEN_HEADLINES:int = 2000;
       
      
      private var mFillBars:Array;
      
      private var mCurrentBet:Bet;
      
      private var mMyUser:UserInfo;
      
      private var mTimeAnim:Number;
      
      private var mShowScoreAnim:Boolean;
      
      private var mBlinkMyScoreAnim:Boolean;
      
      private var mBlinkHisScoreAnim:Boolean;
      
      private var mBlinkMyTimeAnim:Boolean;
      
      private var mBlinkHisTimeAnim:Boolean;
      
      private var mMyScaleUp:Boolean;
      
      private var mHisScaleUp:Boolean;
      
      private var mShowTimesAnim:Boolean;
      
      private var mMyAnimEnd:Boolean;
      
      private var mHisAnimEnd:Boolean;
      
      private var mShowFinalResult:Boolean;
      
      private var mShowFinalResultNow:Boolean;
      
      private var mShowReward:Boolean;
      
      private var mMyScorePercent:int;
      
      private var mHisScorePercent:int;
      
      private var mMyTime:Number;
      
      private var mHisTime:Number;
      
      private var mResultContainer:ESprite;
      
      private var mState:int = -1;
      
      private var FAKE_HEADLINES:Vector.<int>;
      
      private var mHeadlinesState:int = 0;
      
      private var mFakeHeadlinesShuffled:Vector.<int>;
      
      private var mFakeHeadlinesIdx:int;
      
      private var mTotalTimeShowHeadline:Number = 0;
      
      private var mTimeShowHeadline:Number = 0;
      
      private var mTimeEmptyHeadline:Number = 0;
      
      private var mHasToldServerHisTimeUp:Boolean = false;
      
      public function PopupBetResult()
      {
         this.mLogicUpdateFrequency = 1000;
         this.FAKE_HEADLINES = new <int>[342,343,344,345];
         super();
         this.mTimeAnim = 0;
         this.mCurrentBet = null;
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinSku:String) : void
      {
         var shareButton:EButton = null;
         var footer:ELayoutArea = null;
         super.setup(popupId,viewFactory,skinSku);
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = viewFactory.getLayoutAreaFactory("PopXL")).getArea("bg");
         setLayoutArea(area);
         var bkg:ESprite = viewFactory.getEImage("pop_xl_battle",mSkinSku,false,area);
         setBackground(bkg);
         eAddChild(bkg);
         var textArea:ELayoutTextArea = layoutFactory.getTextArea("text_title");
         var title:ETextField = viewFactory.getETextField(skinSku,textArea);
         setTitle(title);
         bkg.eAddChild(title);
         title.applySkinProp(mSkinSku,"text_title_0");
         area = layoutFactory.getArea("body");
         var bodyBattle:ESprite = viewFactory.getESprite(mSkinSku);
         setContent("BODY_BATTLE",bodyBattle);
         bodyBattle.layoutApplyTransformations(area);
         var bodyVictory:ESprite = viewFactory.getESprite(mSkinSku);
         setContent("BODY_VICTORY",bodyVictory);
         bodyVictory.layoutApplyTransformations(area);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku);
         setContent("CLOSE_BUTTON",closeButton);
         closeButton.layoutApplyTransformations(layoutFactory.getArea("btn_close"));
         closeButton.eAddEventListener("click",this.notifyPopupMngClose);
         closeButton.visible = false;
         bkg.eAddChild(closeButton);
         shareButton = mViewFactory.getButton("btn_social",mSkinSku,"L",DCTextMng.getText(0));
         setContent("SHARE_BUTTON",shareButton);
         bkg.eAddChild(shareButton);
         footer = layoutFactory.getArea("footer");
         mViewFactory.distributeSpritesInArea(footer,[shareButton],1,1,1,1,true);
         shareButton.eAddEventListener("click",this.notifyPopupMngClose);
         shareButton.visible = false;
         this.buildCommon();
         this.buildBattleLayout();
      }
      
      private function buildCommon() : void
      {
         var profileName:ETextField = null;
         var profilePicture:ESprite = null;
         var profileNameEnemy:ETextField = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ProfileRes");
         var profileCont:ESprite = getContent("PROFILE_CONT");
         if(profileCont == null)
         {
            this.mMyUser = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
            profileCont = mViewFactory.getESprite(mSkinSku);
            setContent("PROFILE_CONT",profileCont);
            profileName = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_name"));
            setContent("PROFILE_NAME",profileName);
            profileName.setText(this.mMyUser.getPlayerName());
            profileName.applySkinProp(mSkinSku,"text_title_2");
            profileCont.eAddChild(profileName);
            profilePicture = mViewFactory.getEImageProfileFromURL(this.mMyUser.mThumbnailURL,mSkinSku,"glow_green_high");
            setContent("PROFILE_PICTURE",profilePicture);
            profilePicture.layoutApplyTransformations(layoutFactory.getArea("img"));
            profileCont.eAddChild(profilePicture);
         }
         var profileContEnemy:ESprite;
         if((profileContEnemy = getContent("PROFILE_CONT_ENEMY")) == null)
         {
            profileContEnemy = mViewFactory.getESprite(mSkinSku);
            setContent("PROFILE_CONT_ENEMY",profileContEnemy);
            profileNameEnemy = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_name"));
            setContent("PROFILE_NAME_ENEMY",profileNameEnemy);
            profileNameEnemy.visible = false;
            profileNameEnemy.applySkinProp(mSkinSku,"text_title_2");
            profileContEnemy.eAddChild(profileNameEnemy);
         }
         var rayImage:ESprite;
         if((rayImage = getContent("RAY_IMAGE")) == null)
         {
            rayImage = mViewFactory.getEImage("BetRayImg",mSkinSku,false);
            setContent("RAY_IMAGE",rayImage);
         }
      }
      
      private function buildBattleLayout() : void
      {
         var bkg:ESprite;
         (bkg = getBackground()).eAddChild(getContent("BODY_BATTLE"));
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopBattle");
         setTitleText(DCTextMng.getText(348));
         var rayImage:ESprite = getContent("RAY_IMAGE");
         rayImage.layoutApplyTransformations(layoutFactory.getArea("rays"));
         var bodyBattle:ESprite = getContent("BODY_BATTLE");
         bodyBattle.eAddChild(rayImage);
         var vsText:ETextField = getContentAsETextField("VS_TEXT");
         (vsText = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_versus"))).setText("VS");
         bodyBattle.eAddChild(vsText);
         vsText.applySkinProp(mSkinSku,"text_title_2");
         var profileCont:ESprite;
         (profileCont = getContent("PROFILE_CONT")).setLayoutArea(layoutFactory.getArea("area_profile"),true);
         bodyBattle.eAddChild(profileCont);
         var profileContEnemy:ESprite;
         (profileContEnemy = getContent("PROFILE_CONT_ENEMY")).setLayoutArea(layoutFactory.getArea("area_profile_rival"),true);
         bodyBattle.eAddChild(profileContEnemy);
         var layoutFactoryClock:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("IconTextMLarge");
         var clockContEnemy:ESprite = mViewFactory.getESprite(mSkinSku);
         setContent("CLOCK_CONT_ENEMY",clockContEnemy);
         bodyBattle.eAddChild(clockContEnemy);
         var clockIconEnemy:ESprite = mViewFactory.getEImage("icon_clock",mSkinSku,true,layoutFactoryClock.getArea("icon"));
         setContent("CLOCK_CON_ENEMY",clockIconEnemy);
         clockContEnemy.eAddChild(clockIconEnemy);
         var clockTextEnemy:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactoryClock.getTextArea("text"));
         setContent("CLOCK_TEXT_ENEMY",clockTextEnemy);
         clockTextEnemy.setText(DCTextMng.convertTimeToStringColon(DCTimerUtil.secondToMs(0),false));
         clockContEnemy.eAddChild(clockTextEnemy);
         clockTextEnemy.applySkinProp(mSkinSku,"text_title_2");
         clockTextEnemy.autoSize(true);
         clockContEnemy.layoutApplyTransformations(layoutFactory.getArea("area_clock"));
         var timeRemainingText:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_time"));
         setContent("TIME_REMAINING_TEXT",timeRemainingText);
         timeRemainingText.setText(DCTextMng.getText(346));
         bodyBattle.eAddChild(timeRemainingText);
         timeRemainingText.applySkinProp(mSkinSku,"text_title_2");
         var headlineAdvisor:ESprite = mViewFactory.getEImage("captain_normal",mSkinSku,true,layoutFactory.getArea("character"));
         setContent("HEADLINE_ADVISOR",headlineAdvisor);
         bodyBattle.eAddChild(headlineAdvisor);
         this.stateChangeState(0);
      }
      
      private function buildVictoryLayout() : void
      {
         var bkg:ESprite = getBackground();
         var bodyVictory:ESprite = getContent("BODY_VICTORY");
         bkg.eAddChild(bodyVictory);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopVictory");
         var rayImage:ESprite;
         (rayImage = getContent("RAY_IMAGE")).layoutApplyTransformations(layoutFactory.getArea("rays"));
         bodyVictory.eAddChild(rayImage);
         var vsText:ETextField = getContentAsETextField("VS_TEXT");
         if(vsText == null)
         {
            vsText = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_versus"));
            setContent("VS_TEXT",vsText);
            vsText.setText("VS");
            vsText.applySkinProp(mSkinSku,"text_title_2");
         }
         bodyVictory.eAddChild(vsText);
         var profileCont:ESprite = getContent("PROFILE_CONT");
         profileCont.setLayoutArea(layoutFactory.getArea("area_profile"),true);
         bodyVictory.eAddChild(profileCont);
         var profileContEnemy:ESprite = getContent("PROFILE_CONT_ENEMY");
         bodyVictory.eAddChild(profileContEnemy);
         profileContEnemy.setLayoutArea(layoutFactory.getArea("area_profile_rival"),true);
         var textArea:ELayoutTextArea = layoutFactory.getTextArea("text_reward");
         var textReward:ETextField = mViewFactory.getETextField(mSkinSku,textArea);
         setContent("TEXT_REWARD",textReward);
         textReward.setText(DCTextMng.getText(35));
         textReward.applySkinProp(mSkinSku,"text_title_2");
         var textResult:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_result"));
         setContent("TEXT_RESULT",textResult);
         bodyVictory.eAddChild(textResult);
         var rewardValue:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_reward_value"));
         setContent("REWARD_VALUE",rewardValue);
         rewardValue.applySkinProp(mSkinSku,"text_title_2");
         this.createVictoryFillBars(layoutFactory,bodyVictory);
         this.mResultContainer = mViewFactory.getESprite(null,layoutFactory.getArea("area_result"));
         setContent("resultContainer",this.mResultContainer);
         bodyVictory.eAddChild(this.mResultContainer);
         this.getPercentage(mViewFactory.getLayoutAreaFactory("ContainerResults"));
      }
      
      private function getPercentage(layoutFactory:ELayoutAreaFactory) : void
      {
         var scorePercentText:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_percent"));
         setContent("SCORE_PERCENT_TEXT",scorePercentText);
         scorePercentText.setText("0%");
         this.mResultContainer.eAddChild(scorePercentText);
         scorePercentText.applySkinProp(mSkinSku,"text_title_2");
         var scorePercentTextEnemy:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_percent_rival"));
         setContent("SCORE_PERCENT_TEXT_ENEMY",scorePercentTextEnemy);
         scorePercentTextEnemy.setText("0%");
         this.mResultContainer.eAddChild(scorePercentTextEnemy);
         scorePercentTextEnemy.applySkinProp(mSkinSku,"text_title_2");
      }
      
      private function updateBattleData() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         var profileContEnemy:ESprite = null;
         var profileNameEnemy:ETextField = null;
         var profilePictureEnemy:ESprite = null;
         if(this.mCurrentBet != null)
         {
            layoutFactory = mViewFactory.getLayoutAreaFactory("PopBattle");
            this.createBattleFillBars(layoutFactory,getContent("BODY_BATTLE"));
            layoutFactory = mViewFactory.getLayoutAreaFactory("ProfileRes");
            profileContEnemy = getContent("PROFILE_CONT_ENEMY");
            profileNameEnemy = getContentAsETextField("PROFILE_NAME_ENEMY");
            profileNameEnemy.visible = true;
            profileNameEnemy.setText(this.mCurrentBet.getHisName());
            profilePictureEnemy = mViewFactory.getEImageProfileFromURL(this.mCurrentBet.getHisUrl(),mSkinSku,"glow_red_high");
            setContent("PROFILE_PICTURE_ENEMY",profilePictureEnemy);
            profilePictureEnemy.layoutApplyTransformations(layoutFactory.getArea("img"));
            profileContEnemy.eAddChild(profilePictureEnemy);
         }
      }
      
      private function createBattleFillBars(layoutFactory:ELayoutAreaFactory, cont:ESprite) : void
      {
         var myProgress:Number = NaN;
         var myTotal:Number = NaN;
         var fillBar:ResourceFillBar = null;
         var scoreBattleFillBar:BetResultsBattleResourceFillBar = null;
         this.mFillBars = [];
         if(this.mCurrentBet != null)
         {
            myProgress = this.mCurrentBet.getMyProgress(0);
            myTotal = this.mCurrentBet.getMyProgress(1);
            (fillBar = new ResourceFillBar(mViewFactory,mSkinSku)).setup(myTotal,myProgress,"icon_bag_coins","color_coins","text_coins");
            cont.eAddChild(fillBar);
            this.mFillBars.push(fillBar);
            myProgress = this.mCurrentBet.getMyProgress(2);
            myTotal = this.mCurrentBet.getMyProgress(3);
            (fillBar = new ResourceFillBar(mViewFactory,mSkinSku)).setup(myTotal,myProgress,"icon_bag_minerals","color_minerals","text_minerals");
            cont.eAddChild(fillBar);
            this.mFillBars.push(fillBar);
            mViewFactory.distributeSpritesInArea(layoutFactory.getArea("container_bars"),this.mFillBars,1,1,1,2,true);
            myProgress = this.mCurrentBet.getMyProgress(4);
            myTotal = this.mCurrentBet.getMyProgress(5);
            scoreBattleFillBar = new BetResultsBattleResourceFillBar(mViewFactory,mSkinSku);
            setContent("SCORE_BATTLE_FILL_BAR",scoreBattleFillBar);
            scoreBattleFillBar.setup(myTotal,myProgress,"icon_score","color_score","text_score");
            scoreBattleFillBar.layoutApplyTransformations(layoutFactory.getArea("container_score"));
            cont.eAddChild(scoreBattleFillBar);
         }
      }
      
      private function createVictoryFillBars(layoutFactory:ELayoutAreaFactory, cont:ESprite) : void
      {
         var myProgress:Number = NaN;
         var myTotal:Number = NaN;
         var fillBar:ResourceFillBar = null;
         var hisProgress:Number = NaN;
         var hisTotal:Number = NaN;
         var area:ELayoutArea = null;
         var scoreVictoryFillBar:BetResultsResourceFillBar = null;
         this.mFillBars = [];
         if(this.mCurrentBet != null)
         {
            myProgress = this.mCurrentBet.getMyProgress(0);
            myTotal = this.mCurrentBet.getMyProgress(1);
            (fillBar = new ResourceFillBar(mViewFactory,mSkinSku)).setup(myTotal,myProgress,"icon_bag_coins","color_coins","text_coins");
            cont.eAddChild(fillBar);
            this.mFillBars.push(fillBar);
            myProgress = this.mCurrentBet.getMyProgress(2);
            myTotal = this.mCurrentBet.getMyProgress(3);
            (fillBar = new ResourceFillBar(mViewFactory,mSkinSku)).setup(myTotal,myProgress,"icon_bag_minerals","color_minerals","text_minerals");
            cont.eAddChild(fillBar);
            this.mFillBars.push(fillBar);
            mViewFactory.distributeSpritesInArea(layoutFactory.getArea("container_bars"),[this.mFillBars[0],this.mFillBars[1]],1,1,1,2,true);
            hisProgress = this.mCurrentBet.getHisProgress(0);
            hisTotal = this.mCurrentBet.getHisProgress(1);
            (fillBar = new ResourceFillBar(mViewFactory,mSkinSku)).setup(hisTotal,hisProgress,"icon_bag_coins","color_coins","text_coins");
            cont.eAddChild(fillBar);
            this.mFillBars.push(fillBar);
            hisProgress = this.mCurrentBet.getHisProgress(2);
            hisTotal = this.mCurrentBet.getHisProgress(3);
            (fillBar = new ResourceFillBar(mViewFactory,mSkinSku)).setup(hisTotal,hisProgress,"icon_bag_minerals","color_minerals","text_minerals");
            cont.eAddChild(fillBar);
            this.mFillBars.push(fillBar);
            area = layoutFactory.getArea("container_bars_rival");
            mViewFactory.distributeSpritesInArea(area,[this.mFillBars[2],this.mFillBars[3]],1,1,1,2,true);
            myProgress = this.mCurrentBet.getMyProgress(4);
            hisProgress = this.mCurrentBet.getHisProgress(4);
            myTotal = this.mCurrentBet.getMyProgress(5);
            hisTotal = this.mCurrentBet.getHisProgress(5);
            scoreVictoryFillBar = new BetResultsResourceFillBar(mViewFactory,mSkinSku);
            setContent("SCORE_VICTORY_FILL_BAR",scoreVictoryFillBar);
            scoreVictoryFillBar.setup(myTotal,0,hisTotal,0,"icon_score","color_score","text_score",false,0);
            scoreVictoryFillBar.layoutApplyTransformations(layoutFactory.getArea("container_score"));
            cont.eAddChild(scoreVictoryFillBar);
         }
      }
      
      private function destroyBattleLayout() : void
      {
         var bodyBattle:ESprite = getContent("BODY_BATTLE");
         this.destroyFillBars(bodyBattle,false);
         var timeRemainingText:ESprite = getContent("TIME_REMAINING_TEXT");
         if(timeRemainingText != null)
         {
            setContent("TIME_REMAINING_TEXT",null);
         }
         var headlineAdvisor:ESprite = getContent("HEADLINE_ADVISOR");
         if(headlineAdvisor != null)
         {
            setContent("HEADLINE_ADVISOR",null);
         }
         if(bodyBattle != null)
         {
            setContent("BODY_BATTLE",null);
         }
      }
      
      private function destroyLaurelImgs() : void
      {
         setContent("LAUREL",null);
         setContent("LAUREL_FLIP",null);
      }
      
      private function destroyFillBars(cont:ESprite, victory:Boolean) : void
      {
         var bar:ESprite = null;
         if(this.mFillBars != null)
         {
            for each(bar in this.mFillBars)
            {
               if(bar != null)
               {
                  if(cont != null && cont.eContains(bar))
                  {
                     cont.eRemoveChild(bar);
                  }
                  bar.destroy();
                  bar = null;
               }
            }
            this.mFillBars.length = 0;
            this.mFillBars = null;
         }
         if(victory)
         {
            setContent("SCORE_VICTORY_FILL_BAR",null);
         }
         else
         {
            setContent("SCORE_BATTLE_FILL_BAR",null);
         }
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.destroyFillBars(null,true);
      }
      
      private function swapBodies() : void
      {
         this.destroyBattleLayout();
         this.buildVictoryLayout();
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var currentMS:Number = NaN;
         switch(this.mState - -1)
         {
            case 0:
               break;
            case 1:
               if(this.mCurrentBet != null)
               {
                  getContentAsETextField("CLOCK_TEXT_ENEMY").setText(DCTextMng.convertTimeToStringColon(this.mCurrentBet.getHisBattleTimeLeft(),false));
               }
               this.headlinesLogicUpdate();
               if(this.mCurrentBet.getHisBattleTimeLeft() <= 0 && !this.mHasToldServerHisTimeUp)
               {
                  InstanceMng.getUserDataMng().updateBets_timeUp();
                  this.mHasToldServerHisTimeUp = true;
               }
               break;
            case 2:
               currentMS = InstanceMng.getApplication().getCurrentServerTimeMillis();
               if(this.resultsAnimation(dt) == false)
               {
                  this.stateChangeState(2);
               }
         }
      }
      
      private function initResultsAnimationVars() : void
      {
         this.mShowScoreAnim = true;
         this.mShowTimesAnim = false;
         this.mMyAnimEnd = false;
         this.mHisAnimEnd = false;
         this.mBlinkMyScoreAnim = false;
         this.mBlinkHisScoreAnim = false;
         this.mBlinkMyTimeAnim = false;
         this.mBlinkHisTimeAnim = false;
         this.mMyScorePercent = 0;
         this.mHisScorePercent = 0;
         this.mMyTime = 0;
         this.mHisTime = 0;
         this.mShowFinalResult = false;
         this.mShowFinalResultNow = false;
         this.mShowReward = false;
      }
      
      private function resultsAnimation(dt:int) : Boolean
      {
         var currentMS:Number = NaN;
         var finalScore:int = 0;
         var currentScore:Number = NaN;
         var refund:int = 0;
         var bodyVictory:ESprite = getContent("BODY_VICTORY");
         var textResult:ETextField = getContentAsETextField("TEXT_RESULT");
         var scoreVictoryFillBar:BetResultsResourceFillBar = getContent("SCORE_VICTORY_FILL_BAR") as BetResultsResourceFillBar;
         var scorePercentText:ETextField = getContentAsETextField("SCORE_PERCENT_TEXT");
         var scorePercentTextEnemy:ETextField = getContentAsETextField("SCORE_PERCENT_TEXT_ENEMY");
         var clockCont:ESprite = getContent("CLOCK_CONT");
         var clockIcon:ESprite = getContent("CLOCK_ICON");
         var clockText:ETextField = getContentAsETextField("CLOCK_TEXT");
         var clockContEnemy:ESprite = getContent("CLOCK_CONT_ENEMY");
         var clockIconEnemy:ESprite = getContent("CLOCK_CON_ENEMY");
         var clockTextEnemy:ETextField = getContentAsETextField("CLOCK_TEXT_ENEMY");
         var chipsImg:ESprite = getContent("CHIPS_IMG");
         var textReward:ETextField = getContentAsETextField("TEXT_REWARD");
         var rewardValue:ETextField = getContentAsETextField("REWARD_VALUE");
         if(this.mCurrentBet != null)
         {
            if(this.mShowScoreAnim)
            {
               if(!this.mMyAnimEnd)
               {
                  this.mMyScorePercent += int(dt * 0.035);
                  finalScore = this.mCurrentBet.getMyProgress(6);
                  if(this.mMyScorePercent >= finalScore)
                  {
                     scorePercentText.setText(finalScore + "%");
                     scoreVictoryFillBar.setMyValue(this.mCurrentBet.getMyProgress(4));
                     this.mMyAnimEnd = true;
                  }
                  else
                  {
                     currentScore = this.mMyScorePercent * this.mCurrentBet.getMyProgress(5) * 0.01;
                     scorePercentText.setText(this.mMyScorePercent + "%");
                     scoreVictoryFillBar.setMyValue(currentScore);
                  }
               }
               if(!this.mHisAnimEnd)
               {
                  this.mHisScorePercent += int(dt * 0.035);
                  finalScore = this.mCurrentBet.getHisProgress(6);
                  if(this.mHisScorePercent >= finalScore)
                  {
                     scorePercentTextEnemy.setText(finalScore + "%");
                     scoreVictoryFillBar.setHisValue(this.mCurrentBet.getHisProgress(4));
                     this.mHisAnimEnd = true;
                  }
                  else
                  {
                     currentScore = this.mHisScorePercent * this.mCurrentBet.getHisProgress(5) * 0.01;
                     scorePercentTextEnemy.setText(this.mHisScorePercent + "%");
                     scoreVictoryFillBar.setHisValue(currentScore);
                  }
               }
            }
            else if(this.mShowTimesAnim)
            {
               if(!this.mMyAnimEnd)
               {
                  this.mMyTime += dt * 80;
                  if(DCTimerUtil.msToSec(this.mMyTime) >= this.mCurrentBet.getMyProgress(7))
                  {
                     clockText.setText(DCTextMng.convertTimeToStringColon(DCTimerUtil.secondToMs(this.mCurrentBet.getMyProgress(7)),false));
                     this.mMyAnimEnd = true;
                  }
                  else
                  {
                     clockText.setText(DCTextMng.convertTimeToStringColon(this.mMyTime,false));
                  }
               }
               if(!this.mHisAnimEnd)
               {
                  this.mHisTime += dt * 80;
                  if(DCTimerUtil.msToSec(this.mHisTime) >= this.mCurrentBet.getHisProgress(7))
                  {
                     clockTextEnemy.setText(DCTextMng.convertTimeToStringColon(DCTimerUtil.secondToMs(this.mCurrentBet.getHisProgress(7)),false));
                     this.mHisAnimEnd = true;
                  }
                  else
                  {
                     clockTextEnemy.setText(DCTextMng.convertTimeToStringColon(this.mHisTime,false));
                  }
               }
            }
            if(this.mBlinkMyScoreAnim)
            {
               this.blinkMyScoreOrMyTime(dt,scorePercentText);
            }
            if(this.mBlinkHisScoreAnim)
            {
               this.blinkHisScoreOrHisTime(dt,scorePercentTextEnemy);
            }
            if(this.mBlinkMyTimeAnim)
            {
               this.blinkMyScoreOrMyTime(dt,clockText);
            }
            if(this.mBlinkHisTimeAnim)
            {
               this.blinkHisScoreOrHisTime(dt,clockTextEnemy);
            }
            currentMS = InstanceMng.getApplication().getCurrentServerTimeMillis();
            if(this.mShowScoreAnim && this.mMyAnimEnd && this.mHisAnimEnd)
            {
               if(this.mCurrentBet.areScoresPercentEqual())
               {
                  this.mBlinkMyScoreAnim = true;
                  this.mBlinkHisScoreAnim = true;
               }
               else if(this.mCurrentBet.amITheWinner())
               {
                  this.mBlinkMyScoreAnim = true;
               }
               else
               {
                  this.mBlinkHisScoreAnim = true;
               }
               this.mShowScoreAnim = false;
               this.mMyAnimEnd = false;
               this.mHisAnimEnd = false;
               this.mMyScaleUp = true;
               this.mHisScaleUp = true;
               this.mTimeAnim = currentMS;
            }
            else if((this.mBlinkMyScoreAnim || this.mBlinkHisScoreAnim) && currentMS - this.mTimeAnim >= 4000)
            {
               scorePercentText.scaleLogicX = 1;
               scorePercentText.scaleLogicY = 1;
               scorePercentTextEnemy.scaleLogicX = 1;
               scorePercentTextEnemy.scaleLogicY = 1;
               if(this.mCurrentBet.areScoresPercentEqual() && this.mCurrentBet.getMyProgress(6) != 0)
               {
                  this.mBlinkMyScoreAnim = false;
                  this.mBlinkHisScoreAnim = false;
                  this.mShowTimesAnim = true;
                  this.mMyAnimEnd = false;
                  this.mHisAnimEnd = false;
                  this.mResultContainer.eAddChild(clockCont);
                  clockCont.eAddChild(clockIcon);
                  clockCont.eAddChild(clockText);
                  this.mResultContainer.eAddChild(clockContEnemy);
                  clockContEnemy.eAddChild(clockIconEnemy);
                  clockContEnemy.eAddChild(clockTextEnemy);
               }
               else
               {
                  this.mBlinkMyScoreAnim = false;
                  this.mBlinkHisScoreAnim = false;
                  this.mMyAnimEnd = false;
                  this.mHisAnimEnd = false;
                  this.mShowFinalResultNow = true;
                  this.mTimeAnim = currentMS;
                  if(this.mCurrentBet.amITheWinner())
                  {
                     scorePercentText.unapplySkinProp(mSkinSku,"text_title_2");
                     scorePercentText.applySkinProp(mSkinSku,"text_positive");
                  }
                  else if(this.mCurrentBet.amITheLoser())
                  {
                     scorePercentText.unapplySkinProp(mSkinSku,"text_title_2");
                     scorePercentText.applySkinProp(mSkinSku,"text_light_negative");
                  }
               }
            }
            else if(this.mShowTimesAnim && this.mMyAnimEnd && this.mHisAnimEnd)
            {
               this.mShowTimesAnim = false;
               if(this.mCurrentBet.isADraw())
               {
                  this.mBlinkMyTimeAnim = true;
                  this.mBlinkHisTimeAnim = true;
               }
               else if(this.mCurrentBet.amITheWinner())
               {
                  this.mBlinkMyTimeAnim = true;
               }
               else
               {
                  this.mBlinkHisTimeAnim = true;
               }
               this.mTimeAnim = currentMS;
            }
            else if(this.mShowFinalResultNow || (this.mBlinkMyTimeAnim || this.mBlinkHisTimeAnim) && currentMS - this.mTimeAnim >= 4000)
            {
               this.mBlinkMyTimeAnim = false;
               this.mBlinkHisTimeAnim = false;
               this.mShowFinalResultNow = false;
               this.mShowFinalResult = true;
               this.mTimeAnim = currentMS;
               if(this.mCurrentBet.isADraw())
               {
                  textResult.setText(DCTextMng.getText(349));
                  setTitleText(DCTextMng.getText(349));
                  textResult.applySkinProp(mSkinSku,"text_betDraw");
               }
               else
               {
                  bodyVictory.eRemoveChild(textResult);
                  bodyVictory.eAddChild(getContent("LAUREL"));
                  bodyVictory.eAddChild(getContent("LAUREL_FLIP"));
                  bodyVictory.eAddChild(textResult);
                  if(this.mCurrentBet.amITheWinner())
                  {
                     textResult.setText(DCTextMng.getText(2897));
                     setTitleText(DCTextMng.getText(2897));
                     textResult.applySkinProp(mSkinSku,"text_positive");
                     if(clockText != null)
                     {
                        clockText.applySkinProp(mSkinSku,"text_positive");
                     }
                  }
                  else
                  {
                     textResult.setText(DCTextMng.getText(2898));
                     setTitleText(DCTextMng.getText(2898));
                     textResult.applySkinProp(mSkinSku,"text_light_negative");
                     if(clockText != null)
                     {
                        clockText.applySkinProp(mSkinSku,"text_light_negative");
                     }
                  }
               }
               if(clockText != null)
               {
                  clockText.scaleLogicX = 1;
                  clockText.scaleLogicY = 1;
               }
               if(clockTextEnemy != null)
               {
                  clockTextEnemy.scaleLogicX = 1;
                  clockTextEnemy.scaleLogicY = 1;
               }
            }
            else if(this.mShowFinalResult && currentMS - this.mTimeAnim >= DCTimerUtil.secondToMs(InstanceMng.getBetsSettingsDefMng().getSummaryAnimationResultTime()))
            {
               this.mShowFinalResult = false;
               this.mShowReward = true;
               this.mTimeAnim = currentMS;
               if(this.mCurrentBet.isADraw())
               {
                  if((refund = int(this.mCurrentBet.getRefund().split(":")[1])) > 0)
                  {
                     textResult.visible = false;
                     bodyVictory.eAddChild(chipsImg);
                     textReward.setText(DCTextMng.getText(350));
                     rewardValue.setText(DCTextMng.convertNumberToString(refund,1,7));
                     bodyVictory.eAddChild(textReward);
                     bodyVictory.eAddChild(rewardValue);
                  }
               }
               else if(this.mCurrentBet.amITheWinner())
               {
                  textResult.visible = false;
                  this.destroyLaurelImgs();
                  bodyVictory.eAddChild(chipsImg);
                  textReward.setText(DCTextMng.getText(35));
                  rewardValue.setText(DCTextMng.convertNumberToString(this.mCurrentBet.getReward().split(":")[1],1,7));
                  bodyVictory.eAddChild(textReward);
                  bodyVictory.eAddChild(rewardValue);
               }
               if(textResult.visible)
               {
                  return false;
               }
            }
            else if(this.mShowReward && currentMS - this.mTimeAnim >= 4000)
            {
               return false;
            }
         }
         return true;
      }
      
      private function blinkMyScoreOrMyTime(dt:int, textField:ETextField) : void
      {
         if(this.mMyScaleUp && textField.scaleLogicX < 1.12)
         {
            textField.scaleLogicX += 0.0003 * dt;
            textField.scaleLogicY += 0.0003 * dt;
         }
         if(this.mMyScaleUp && textField.scaleLogicX >= 1.12 - 0.02)
         {
            textField.scaleLogicX = 1.12;
            textField.scaleLogicY = 1.12;
            this.mMyScaleUp = false;
         }
         if(!this.mMyScaleUp && textField.scaleLogicX > 1)
         {
            textField.scaleLogicX -= 0.0003 * dt;
            textField.scaleLogicY -= 0.0003 * dt;
         }
         if(!this.mMyScaleUp && textField.scaleLogicX <= 1)
         {
            textField.scaleLogicX = 1;
            textField.scaleLogicY = 1;
            this.mMyScaleUp = true;
         }
      }
      
      private function blinkHisScoreOrHisTime(dt:int, textField:ETextField) : void
      {
         if(this.mHisScaleUp && textField.scaleLogicX < 1.12)
         {
            textField.scaleLogicX += 0.0003 * dt;
            textField.scaleLogicY += 0.0003 * dt;
         }
         if(this.mHisScaleUp && textField.scaleLogicX >= 1.12 - 0.02)
         {
            textField.scaleLogicX = 1.12;
            textField.scaleLogicY = 1.12;
            this.mHisScaleUp = false;
         }
         if(!this.mHisScaleUp && textField.scaleLogicX > 1)
         {
            textField.scaleLogicX -= 0.0003 * dt;
            textField.scaleLogicY -= 0.0003 * dt;
         }
         if(!this.mHisScaleUp && textField.scaleLogicX <= 1)
         {
            textField.scaleLogicX = 1;
            textField.scaleLogicY = 1;
            this.mHisScaleUp = true;
         }
      }
      
      public function stateChangeState(newState:int) : void
      {
         this.stateExitState();
         DCDebug.traceCh("bets","[PopupBetResult] Change state " + this.mState + " to " + newState);
         this.mState = newState;
         this.stateEnterState();
      }
      
      private function stateEnterState() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         var area:ELayoutArea = null;
         var laurel:ESprite = null;
         var laurelFlip:ESprite = null;
         var chipsImg:ESprite = null;
         var layoutFactoryClock:ELayoutAreaFactory = null;
         var layoutFactoryResult:ELayoutAreaFactory = null;
         var areaIcon:ELayoutArea = null;
         var textArea:ELayoutTextArea = null;
         var clockCont:ESprite = null;
         var clockIcon:ESprite = null;
         var clockText:ETextField = null;
         var clockContEnemy:ESprite = null;
         var clockIconEnemy:ESprite = null;
         var clockTextEnemy:ETextField = null;
         var shareButton:ESprite = null;
         switch(this.mState - -1)
         {
            case 0:
            case 1:
               break;
            case 2:
               this.swapBodies();
               this.initResultsAnimationVars();
               setTitleText(DCTextMng.getText(577));
               this.mTimeAnim = InstanceMng.getApplication().getCurrentServerTimeMillis();
               area = (layoutFactory = mViewFactory.getLayoutAreaFactory("PopVictory")).getArea("chips");
               if(this.mCurrentBet.amITheWinner() || this.mCurrentBet.isADraw())
               {
                  chipsImg = mViewFactory.getEImage("bet_chips_reward",mSkinSku,true,area);
                  setContent("CHIPS_IMG",chipsImg);
                  if(this.mCurrentBet.amITheWinner())
                  {
                     laurel = mViewFactory.getEImage("betLaurel",mSkinSku,true,layoutFactory.getArea("img_laurel"));
                     setContent("LAUREL",laurel);
                     laurelFlip = mViewFactory.getEImage("betLaurel",mSkinSku,true,layoutFactory.getArea("img_laurel_flip"));
                     setContent("LAUREL_FLIP",laurelFlip);
                  }
               }
               else
               {
                  laurel = mViewFactory.getEImage("betLaurel_defeat",mSkinSku,true,layoutFactory.getArea("img_laurel"));
                  setContent("LAUREL",laurel);
                  laurelFlip = mViewFactory.getEImage("betLaurel_defeat",mSkinSku,true,layoutFactory.getArea("img_laurel_flip"));
                  setContent("LAUREL_FLIP",laurelFlip);
               }
               if(this.mCurrentBet.areScoresPercentEqual())
               {
                  layoutFactoryClock = mViewFactory.getLayoutAreaFactory("IconTextMLarge");
                  layoutFactoryResult = mViewFactory.getLayoutAreaFactory("ContainerResultsMatch");
                  areaIcon = layoutFactoryClock.getArea("icon");
                  textArea = layoutFactoryClock.getTextArea("text");
                  clockCont = mViewFactory.getESprite(mSkinSku);
                  setContent("CLOCK_CONT",clockCont);
                  clockIcon = mViewFactory.getEImage("icon_clock",mSkinSku,true,areaIcon);
                  setContent("CLOCK_ICON",clockIcon);
                  clockText = mViewFactory.getETextField(mSkinSku,textArea);
                  setContent("CLOCK_TEXT",clockText);
                  clockText.autoSize(true);
                  clockText.setText(DCTextMng.convertTimeToStringColon(DCTimerUtil.secondToMs(0),false));
                  clockText.applySkinProp(mSkinSku,"text_title_2");
                  clockCont.layoutApplyTransformations(layoutFactoryResult.getArea("area_clock_player"));
                  clockContEnemy = mViewFactory.getESprite(mSkinSku);
                  setContent("CLOCK_CONT_ENEMY",clockContEnemy);
                  clockIconEnemy = mViewFactory.getEImage("icon_clock",mSkinSku,true,areaIcon);
                  setContent("CLOCK_CON_ENEMY",clockIconEnemy);
                  clockTextEnemy = mViewFactory.getETextField(mSkinSku,textArea);
                  setContent("CLOCK_TEXT_ENEMY",clockTextEnemy);
                  clockTextEnemy.autoSize(true);
                  clockTextEnemy.setText(DCTextMng.convertTimeToStringColon(DCTimerUtil.secondToMs(0),false));
                  clockTextEnemy.applySkinProp(mSkinSku,"text_title_2");
                  clockContEnemy.layoutApplyTransformations(layoutFactoryResult.getArea("area_clock_rival"));
                  this.getPercentage(layoutFactoryResult);
               }
               break;
            case 3:
               getContent("CLOSE_BUTTON").visible = true;
               if(this.mCurrentBet != null)
               {
                  if(this.mCurrentBet.amITheWinner())
                  {
                     if((shareButton = getContent("SHARE_BUTTON")) != null)
                     {
                        shareButton.visible = true;
                     }
                  }
                  break;
               }
         }
      }
      
      private function stateExitState() : void
      {
         switch(this.mState - -1)
         {
         }
      }
      
      public function getState() : int
      {
         return this.mState;
      }
      
      public function setCurrentBet(value:Bet) : void
      {
         this.mCurrentBet = value;
         this.updateBattleData();
      }
      
      override public function notifyPopupMngClose(e:Object) : void
      {
         super.notifyPopupMngClose(e);
         InstanceMng.getBetMng().closeBet();
      }
      
      private function headlinesLogicUpdate() : void
      {
         var currentMS:Number = InstanceMng.getApplication().getCurrentServerTimeMillis();
         switch(this.mHeadlinesState)
         {
            case 0:
               if(currentMS - this.mTimeEmptyHeadline > 2000)
               {
                  this.headlinesChangeState(1);
               }
               break;
            case 1:
               if(currentMS - this.mTimeShowHeadline > this.mTotalTimeShowHeadline)
               {
                  this.headlinesChangeState(0);
                  break;
               }
         }
      }
      
      private function headlinesChangeState(newHeadlinesState:int) : void
      {
         this.mHeadlinesState = newHeadlinesState;
         var currentMS:Number = InstanceMng.getApplication().getCurrentServerTimeMillis();
         switch(this.mHeadlinesState)
         {
            case 0:
               this.mTimeEmptyHeadline = currentMS;
               this.removeSpeechText();
               break;
            case 1:
               this.mTimeShowHeadline = currentMS;
               this.createSpeechText(DCTextMng.getText(this.getFakeHeadline()));
               this.mTotalTimeShowHeadline = DCTimerUtil.secondToMs(InstanceMng.getBetsSettingsDefMng().getBetSummaryFakeSentencesChangeTime());
         }
      }
      
      private function getFakeHeadline() : int
      {
         var randomPos:Number = NaN;
         var i:int = 0;
         if(this.mFakeHeadlinesShuffled == null)
         {
            this.mFakeHeadlinesShuffled = new Vector.<int>(this.FAKE_HEADLINES.length);
            randomPos = 0;
            for(i = 0; i < this.mFakeHeadlinesShuffled.length; )
            {
               randomPos = int(Math.random() * this.FAKE_HEADLINES.length);
               this.mFakeHeadlinesShuffled[i] = this.FAKE_HEADLINES[randomPos];
               this.FAKE_HEADLINES.splice(randomPos,1);
               i++;
            }
            this.mFakeHeadlinesIdx = 0;
         }
         else if(this.mFakeHeadlinesIdx < this.mFakeHeadlinesShuffled.length - 1)
         {
            this.mFakeHeadlinesIdx++;
         }
         else
         {
            this.mFakeHeadlinesIdx = 0;
         }
         return this.mFakeHeadlinesShuffled[this.mFakeHeadlinesIdx];
      }
      
      public function createSpeechText(text:String) : void
      {
         var bodyBattle:ESprite = getContent("BODY_BATTLE");
         var layoutFactory:ELayoutAreaFactory;
         var areaArrow:ELayoutArea = (layoutFactory = mViewFactory.getLayoutAreaFactory("PopBattle")).getArea("arrow");
         var propSku:String = "battle_color";
         var speechArrow:ESprite = mViewFactory.getEImage("speech_arrow",mSkinSku,false,areaArrow,propSku);
         setContent("SPEECH_ARROW",speechArrow);
         bodyBattle.eAddChild(speechArrow);
         var speechText:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"));
         setContent("SPEECH_TEXT",speechText);
         speechText.setText(text);
         speechText.applySkinProp(mSkinSku,"text_title_2");
         var speechBox:ESprite = mViewFactory.getSpeechBubble(layoutFactory.getArea("area_speech"),areaArrow,speechText,mSkinSku,propSku);
         setContent("SPEECH_BOX",speechBox);
         bodyBattle.eAddChild(speechBox);
         bodyBattle.eAddChild(speechText);
      }
      
      public function removeSpeechText() : void
      {
         setContent("SPEECH_ARROW",null);
         setContent("SPEECH_TEXT",null);
         setContent("SPEECH_BOX",null);
      }
   }
}
