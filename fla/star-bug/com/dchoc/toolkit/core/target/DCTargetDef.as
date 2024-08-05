package com.dchoc.toolkit.core.target
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.utils.EUtils;
   
   public class DCTargetDef extends DCDef
   {
      
      public static const MAX_NUM_MINI_TARGETS:int = 3;
      
      private static const TARGET_TYPES_PATTERN:String = "targetType";
      
      private static const TARGET_BODY_PATTERN:String = "targetBody";
      
      private static const TARGET_AMOUNT_PATTERN:String = "targetAmount";
      
      private static const TARGET_SKU_PATTERN:String = "targetSku";
      
      private static const TARGET_MINI_ICON_PATTERN:String = "targetIcon";
      
      private static const TARGET_DONE_FROM_PATTERN:String = "targetProgressDoneFrom";
      
      private static const TARGET_FBCREDITS_PATTERN:String = "targetFBCredits";
      
      private static const TARGET_GO_TO_TAB_PATTERN:String = "targetGoToTab";
      
      private static const TARGET_RECEIVE_ATTACK_PATTERN:String = "targetReceiveAttack";
      
      private static const TARGET_SEND_ATTACK_PATTERN:String = "targetSendAttack";
      
      private static const TARGET_ATTACK_BOUND_PATTERN:String = "targetAttackBound";
      
      private static const TARGET_LEVEL_PATTERN:String = "targetLevel";
      
      private static const TARGET_NPC_PATTERN:String = "targetNPC";
      
      private static const TARGET_PROGRESS_ABSOLUTE:String = "targetProgressAbsolute";
      
      private static const WILDCARD:String = "?";
       
      
      private var mConditionUnlocked:String;
      
      private var mConditionAmount:String;
      
      private var mConditionAccomplished:String;
      
      private var mConditionOriginal:String;
      
      private var mConditionParameterSku:String;
      
      private var mConditionExtra:String;
      
      private var mAmount:SecureInt;
      
      private var mPreAction:String;
      
      private var mPostAction:String;
      
      private var mTutorialTitle:String;
      
      private var mTutorialBody:String;
      
      private var mTutorialButton:String;
      
      private var mAdvisorPresentation:String;
      
      private var mAdvisorCompleted:String;
      
      private var mSoundAttached:String;
      
      private var mHideArrowCondArr:Array;
      
      private var mHideArrowCondParameterArr:Array;
      
      private var mPreactionTargetCoordX:int;
      
      private var mPreactionTargetCoordY:int;
      
      private var mPreactionTargetRotation:int;
      
      private var mPreactionTargetSid:String;
      
      private var mPostactionTargetCoordX:int;
      
      private var mPostactionTargetCoordY:int;
      
      private var mPostactionTargetRotation:int;
      
      private var mPostactionTargetSku:String;
      
      private var mTargetTitle:String;
      
      private var mTargetSummary:String;
      
      private var mTargetHelp:String;
      
      private var mMiniTargetTypes:Array;
      
      private var mMiniTargetTypeParameters:Array;
      
      private var mMiniTargetBodies:Array;
      
      private var mMiniTargetAmounts:Array;
      
      private var mMiniTargetSkus:Array;
      
      private var mMiniTargetSkusTokens:Array;
      
      private var mMiniTargetFBCredits:Array;
      
      private var mMiniTargetGoToTab:Array;
      
      private var mMiniTargetReceiveAttack:Array;
      
      private var mMiniTargetSendAttack:Array;
      
      private var mMiniTargetAttackBound:Array;
      
      private var mMiniTargetDoneFrom:Array;
      
      private var mNumMinitargetsFound:int;
      
      private var mMiniTargetLevels:Array;
      
      private var mMiniTargetNPC:Array;
      
      private var mMiniTargetIsProgressAbsolute:Array;
      
      private var mIntroMovie:String;
      
      private var mEndMovie:String;
      
      private var mTimeToFinish:String;
      
      private var mMiniTargetIcons:Array;
      
      private var mHintIcon:String;
      
      private var mPriority:String;
      
      private var mNewEventIconText:String;
      
      public function DCTargetDef()
      {
         mAmount = new SecureInt("DCTargetDef.mAmount");
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mConditionUnlocked = "level";
         this.mConditionAmount = "";
         this.mConditionAccomplished = null;
         this.mConditionOriginal = null;
         this.mConditionParameterSku = null;
         this.mConditionExtra = null;
         this.mPreAction = null;
         this.mPostAction = null;
         this.mTutorialTitle = null;
         this.mTutorialBody = null;
         this.mTutorialButton = null;
         this.mAdvisorPresentation = null;
         this.mAdvisorCompleted = null;
         this.mSoundAttached = null;
         this.mTargetTitle = null;
         this.mTargetSummary = null;
         this.mTargetHelp = null;
         this.mIntroMovie = null;
         this.mEndMovie = null;
         this.mTimeToFinish = null;
         this.mHintIcon = null;
         this.mPriority = null;
         this.mNewEventIconText = null;
         this.mNumMinitargetsFound = 0;
         this.mAmount.value = 0;
         this.mPreactionTargetCoordX = 0;
         this.mPreactionTargetCoordY = 0;
         this.mPreactionTargetRotation = 0;
         this.mPreactionTargetSid = null;
         this.mPostactionTargetCoordX = 0;
         this.mPostactionTargetCoordY = 0;
         this.mPostactionTargetRotation = 0;
         this.mPostactionTargetSku = null;
         this.mHideArrowCondArr = [];
         this.mHideArrowCondParameterArr = [];
         this.mMiniTargetTypes = [];
         this.mMiniTargetTypeParameters = [];
         this.mMiniTargetBodies = [];
         this.mMiniTargetAmounts = [];
         this.mMiniTargetSkus = [];
         this.mMiniTargetSkusTokens = [];
         this.mMiniTargetFBCredits = [];
         this.mMiniTargetGoToTab = [];
         this.mMiniTargetReceiveAttack = [];
         this.mMiniTargetSendAttack = [];
         this.mMiniTargetAttackBound = [];
         this.mMiniTargetDoneFrom = [];
         this.mMiniTargetLevels = [];
         this.mMiniTargetNPC = [];
         this.mMiniTargetIsProgressAbsolute = [];
         this.mMiniTargetIcons = [];
      }
      
      public function getConditionUnlocked() : String
      {
         return this.mConditionUnlocked;
      }
      
      public function setConditionUnlocked(value:String) : void
      {
         this.mConditionUnlocked = value;
      }
      
      public function getConditionAmount() : String
      {
         return this.mConditionAmount;
      }
      
      private function setConditionAmount(value:String) : void
      {
         this.mConditionAmount = value;
      }
      
      public function getConditionAccomplished() : String
      {
         return this.mConditionAccomplished;
      }
      
      public function setConditionAccomplished(value:String) : void
      {
         this.mConditionAccomplished = value;
      }
      
      public function getConditionOriginal() : String
      {
         return this.mConditionOriginal;
      }
      
      public function setConditionOriginal(value:String) : void
      {
         this.mConditionOriginal = value;
      }
      
      public function getConditionParameterSku() : String
      {
         return this.mConditionParameterSku;
      }
      
      private function setConditionParameterSku(value:String) : void
      {
         this.mConditionParameterSku = value;
      }
      
      public function getConditionExtra() : String
      {
         return this.mConditionExtra;
      }
      
      private function setConditionExtra(value:String) : void
      {
         this.mConditionExtra = value;
      }
      
      public function getAmount() : int
      {
         return this.mAmount.value;
      }
      
      protected function setAmount(value:int) : void
      {
         this.mAmount.value = value;
      }
      
      public function getHintIcon() : String
      {
         return this.mHintIcon;
      }
      
      private function setHintIcon(value:String) : void
      {
         this.mHintIcon = value;
      }
      
      public function getPriority() : String
      {
         return this.mPriority;
      }
      
      private function setPriority(value:String) : void
      {
         this.mPriority = value;
      }
      
      public function getPreAction() : String
      {
         return this.mPreAction;
      }
      
      private function setPreAction(value:String) : void
      {
         this.mPreAction = value;
      }
      
      public function getPostAction() : String
      {
         return this.mPostAction;
      }
      
      private function setPostAction(value:String) : void
      {
         this.mPostAction = value;
      }
      
      public function getTutorialTitle() : String
      {
         return this.mTutorialTitle;
      }
      
      private function setTutorialTitle(value:String) : void
      {
         this.mTutorialTitle = value;
      }
      
      public function getTutorialBody() : String
      {
         return this.mTutorialBody;
      }
      
      private function setTutorialBody(value:String) : void
      {
         this.mTutorialBody = value;
      }
      
      public function getTutorialButton() : String
      {
         return this.mTutorialButton;
      }
      
      private function setTutorialButton(value:String) : void
      {
         this.mTutorialButton = value;
      }
      
      public function getAdvisorPresentation() : String
      {
         return this.mAdvisorPresentation;
      }
      
      private function setAdvisorPresentation(value:String) : void
      {
         this.mAdvisorPresentation = value;
      }
      
      public function getAdvisorCompleted() : String
      {
         return this.mAdvisorCompleted;
      }
      
      private function setAdvisorCompleted(value:String) : void
      {
         this.mAdvisorCompleted = value;
      }
      
      public function getPreactionTargetCoordX() : int
      {
         return this.mPreactionTargetCoordX;
      }
      
      private function setPreactionTargetCoordX(value:int) : void
      {
         this.mPreactionTargetCoordX = value;
      }
      
      public function getPreactionTargetCoordY() : int
      {
         return this.mPreactionTargetCoordY;
      }
      
      private function setPreactionTargetCoordY(value:int) : void
      {
         this.mPreactionTargetCoordY = value;
      }
      
      public function getPreactionTargetRotation() : int
      {
         return this.mPreactionTargetRotation;
      }
      
      private function setPreactionTargetRotation(value:int) : void
      {
         this.mPreactionTargetRotation = value;
      }
      
      public function getPreactionTargetSid() : String
      {
         return this.mPreactionTargetSid;
      }
      
      private function setPreactionTargetSid(value:String) : void
      {
         this.mPreactionTargetSid = value;
      }
      
      public function getPostactionTargetCoordX() : int
      {
         return this.mPostactionTargetCoordX;
      }
      
      private function setPostactionTargetCoordX(value:int) : void
      {
         this.mPostactionTargetCoordX = value;
      }
      
      public function getPostactionTargetCoordY() : int
      {
         return this.mPostactionTargetCoordY;
      }
      
      private function setPostactionTargetCoordY(value:int) : void
      {
         this.mPostactionTargetCoordY = value;
      }
      
      public function getPostactionTargetRotation() : int
      {
         return this.mPostactionTargetRotation;
      }
      
      private function setPostactionTargetRotation(value:int) : void
      {
         this.mPostactionTargetRotation = value;
      }
      
      public function getPostactionTargetSku() : String
      {
         return this.mPostactionTargetSku;
      }
      
      private function setPostactionTargetSku(value:String) : void
      {
         this.mPostactionTargetSku = value;
      }
      
      private function setHideArrowCondition(value:String, index:int = 0) : void
      {
         if(value == "")
         {
            value = null;
         }
         this.mHideArrowCondArr[index] = value;
      }
      
      public function getHideArrowCondition(index:int = 0) : String
      {
         return this.mHideArrowCondArr[index];
      }
      
      private function setHideArrowConditionParameter(value:String, index:int = 0) : void
      {
         this.mHideArrowCondParameterArr[index] = value;
      }
      
      public function getHideArrowConditionParameter(index:int = 0) : String
      {
         return this.mHideArrowCondParameterArr[index];
      }
      
      public function setNewEventIconText(value:String) : void
      {
         this.mNewEventIconText = value;
      }
      
      public function getNewEventIconText() : String
      {
         return this.mNewEventIconText;
      }
      
      public function isThisStateUseful(stateId:int) : Boolean
      {
         return true;
      }
      
      public function getTargetSummary() : String
      {
         return this.mTargetSummary;
      }
      
      public function getTargetHelp() : String
      {
         return this.mTargetHelp;
      }
      
      public function getTargetTitle() : String
      {
         return this.mTargetTitle;
      }
      
      public function getMiniTargetTypes(targetNumber:int) : String
      {
         return this.mMiniTargetTypes[targetNumber];
      }
      
      public function getMiniTargetTypeParameter(targetNumber:int) : String
      {
         return this.mMiniTargetTypeParameters[targetNumber];
      }
      
      public function getMiniTargetBody(targetNumber:int) : String
      {
         return this.mMiniTargetBodies[targetNumber];
      }
      
      public function getMiniTargetAmount(targetNumber:int) : Number
      {
         return this.mMiniTargetAmounts[targetNumber];
      }
      
      public function getMiniTargetSku(targetNumber:int) : String
      {
         return this.mMiniTargetSkus[targetNumber];
      }
      
      public function getMiniTargetIcon(targetNumber:int) : String
      {
         return this.mMiniTargetIcons[targetNumber];
      }
      
      public function getNumMinitargetsFound() : int
      {
         return this.mNumMinitargetsFound;
      }
      
      public function getMiniTargetFBCredits(targetNumber:int) : String
      {
         return this.mMiniTargetFBCredits[targetNumber];
      }
      
      public function getMiniTargetGoToTab(targetNumber:int) : String
      {
         return this.mMiniTargetGoToTab[targetNumber];
      }
      
      public function getMiniTargetReceiveAttack(targetNumber:int) : Boolean
      {
         return DCUtils.stringToBoolean(this.mMiniTargetReceiveAttack[targetNumber]);
      }
      
      public function getMiniTargetSendAttack(targetNumber:int) : Boolean
      {
         return DCUtils.stringToBoolean(this.mMiniTargetSendAttack[targetNumber]);
      }
      
      public function getMiniTargetAttackBound(targetNumber:int) : int
      {
         return this.mMiniTargetAttackBound[targetNumber];
      }
      
      public function getMiniTargetDoneFrom(targetNumber:int) : String
      {
         return this.mMiniTargetDoneFrom[targetNumber];
      }
      
      public function getMiniTargetLevel(targetNumber:int) : int
      {
         return this.mMiniTargetLevels[targetNumber];
      }
      
      public function getMiniTargetNPC(targetNumber:int) : String
      {
         return this.mMiniTargetNPC[targetNumber];
      }
      
      public function isMiniTargetProgressAbsolute(targetNumber:int) : Boolean
      {
         return this.mMiniTargetIsProgressAbsolute[targetNumber];
      }
      
      private function setTargetSummary(value:String) : void
      {
         this.mTargetSummary = value;
      }
      
      private function setTargetHelp(value:String) : void
      {
         this.mTargetHelp = value;
      }
      
      private function setTargetTitle(value:String) : void
      {
         this.mTargetTitle = value;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var coord:DCCoordinate = null;
         var hideArrowAllCondsArr:Array = null;
         var hideArrowCondArr:Array = null;
         var i:int = 0;
         var typeArr:Array = null;
         super.doFromXml(info);
         var unlockBySku:String = EUtils.xmlReadString(info,"unlockSku");
         var title:String = EUtils.xmlReadString(info,"tidTitle");
         var body:String = EUtils.xmlReadString(info,"tidBody");
         var button:String = EUtils.xmlReadString(info,"tidButton");
         var advisorPresentation:String = EUtils.xmlReadString(info,"advisorPresentation");
         var advisorCompleted:String = EUtils.xmlReadString(info,"advisorCompleted");
         var soundAttached:String = EUtils.xmlReadString(info,"soundAttached");
         var introMovie:String = EUtils.xmlReadString(info,"introMovie");
         var endMovie:String = EUtils.xmlReadString(info,"endMovie");
         var timeToFinish:String = EUtils.xmlReadString(info,"timeToFinish");
         var hintIcon:String = EUtils.xmlReadString(info,"hintIcon");
         var hideArrowCond:String = EUtils.xmlReadString(info,"hideArrowCondition");
         var priority:String = EUtils.xmlReadString(info,"prio");
         var newEventIconText:String = EUtils.xmlReadString(info,"tidIconText");
         var type:String = EUtils.xmlReadString(info,"type");
         var amount:String = EUtils.xmlReadString(info,"amount");
         var preAction:String = EUtils.xmlReadString(info,"preaction");
         var postAction:String = EUtils.xmlReadString(info,"postaction");
         var targetTitle:String = EUtils.xmlReadString(info,"tidTitle");
         var targetSummary:String = EUtils.xmlReadString(info,"tidSummary");
         var targetHelp:String = EUtils.xmlReadString(info,"tidHelp");
         if(unlockBySku != "")
         {
            if(unlockBySku == "notAllowed")
            {
               this.setConditionUnlocked("notAllowed");
            }
            else
            {
               this.setConditionUnlocked("targets");
            }
            this.setConditionAmount(unlockBySku);
         }
         else
         {
            this.setConditionUnlocked("level");
            this.setConditionAmount("1");
         }
         if(title != "")
         {
            this.setTutorialTitle(title);
         }
         if(body != "")
         {
            this.setTutorialBody(body);
         }
         if(button != "")
         {
            this.setTutorialButton(button);
         }
         if(advisorPresentation != "")
         {
            this.setAdvisorPresentation(advisorPresentation);
         }
         if(advisorCompleted != "")
         {
            this.setAdvisorCompleted(advisorCompleted);
         }
         if(soundAttached != "")
         {
            this.setSoundAttached(soundAttached);
         }
         if(introMovie != "")
         {
            this.setIntroMovie(introMovie);
         }
         if(endMovie != "")
         {
            this.setEndMovie(endMovie);
         }
         if(timeToFinish != "")
         {
            this.setTimeToFinish(timeToFinish);
         }
         if(hintIcon != "")
         {
            this.setHintIcon(hintIcon);
         }
         if(priority != "")
         {
            this.setPriority(priority);
         }
         if(newEventIconText != "")
         {
            this.setNewEventIconText(newEventIconText);
         }
         if(targetTitle != "")
         {
            this.setTargetTitle(targetTitle);
         }
         if(targetSummary != "")
         {
            this.setTargetSummary(targetSummary);
         }
         if(targetHelp != "")
         {
            this.setTargetHelp(targetHelp);
         }
         if(hideArrowCond != "")
         {
            if((hideArrowAllCondsArr = hideArrowCond.split("|")) != null)
            {
               for(i = 0; i < hideArrowAllCondsArr.length; )
               {
                  hideArrowCondArr = String(hideArrowAllCondsArr[i]).split(":");
                  this.setHideArrowCondition(hideArrowCondArr[0],i);
                  this.setHideArrowConditionParameter(hideArrowCondArr[1],i);
                  i++;
               }
            }
         }
         if(type != "")
         {
            typeArr = type.split(":");
            this.setConditionOriginal(typeArr[0]);
            this.setConditionAccomplished(typeArr[0]);
            this.setConditionParameterSku(typeArr[1]);
            this.setConditionExtra(typeArr[2]);
         }
         if(amount != "")
         {
            this.setAmount(int(amount));
         }
         if(preAction != "")
         {
            this.setPreactionTargetSid(this.checkIfSku(preAction));
            if((coord = this.checkIfCoords(preAction)) != null)
            {
               if(coord.z != 0)
               {
                  this.setPreactionTargetRotation(coord.z);
               }
               this.setPreactionTargetCoordX(coord.x);
               this.setPreactionTargetCoordY(coord.y);
            }
            this.setPreAction(this.removeSeparators(preAction));
         }
         if(postAction != "")
         {
            this.setPostactionTargetSku(this.checkIfSku(postAction));
            if((coord = this.checkIfCoords(postAction)) != null)
            {
               if(coord.z != 0)
               {
                  this.setPostactionTargetRotation(coord.z);
               }
               this.setPostactionTargetCoordX(coord.x);
               this.setPostactionTargetCoordY(coord.y);
            }
            this.setPostAction(this.removeSeparators(postAction));
         }
         this.fillParams(info,"targetType");
         this.fillParams(info,"targetBody");
         this.fillParams(info,"targetAmount");
         this.fillParams(info,"targetSku");
         this.fillParams(info,"targetIcon");
         this.fillParams(info,"targetFBCredits");
         this.fillParams(info,"targetGoToTab");
         this.fillParams(info,"targetReceiveAttack");
         this.fillParams(info,"targetSendAttack");
         this.fillParams(info,"targetAttackBound");
         this.fillParams(info,"targetLevel");
         this.fillParams(info,"targetNPC");
         this.fillParams(info,"targetProgressAbsolute");
         this.fillParams(info,"targetProgressDoneFrom");
      }
      
      private function fillParams(info:XML, pattern:String) : void
      {
         var key:* = null;
         var valueToFind:String = null;
         var value:* = undefined;
         var i:int = 0;
         var arr:Array = null;
         var attribute:String = null;
         var miniIndex:int = 0;
         var skuTokens:Array = null;
         var bool:Boolean = false;
         var valueFound:* = false;
         for(i = 1; i <= 3; )
         {
            key = (key = pattern) + String(i);
            valueToFind = info.attribute(key).toString();
            valueFound = false;
            if(valueToFind.length == 0)
            {
               switch(pattern)
               {
                  case "targetLevel":
                     value = 0;
                     valueFound = i >= this.mMiniTargetLevels.length;
                     break;
                  case "targetSku":
                     value = 0;
                     valueFound = i >= this.mMiniTargetSkus.length;
                     break;
                  case "targetNPC":
                     value = 0;
                     valueFound = true;
                     break;
                  case "targetProgressAbsolute":
                     value = 0;
                     valueFound = i >= this.mMiniTargetIsProgressAbsolute.length;
               }
            }
            arr = valueToFind.split(":");
            attribute = null;
            if(arr.length > 1)
            {
               valueToFind = String(arr[0]);
               attribute = String(arr[1]);
            }
            if(valueToFind.length > 0 || valueFound)
            {
               miniIndex = i - 1;
               switch(pattern)
               {
                  case "targetType":
                     if(this.mNumMinitargetsFound < 3)
                     {
                        if(valueToFind != "")
                        {
                           this.mNumMinitargetsFound++;
                        }
                        this.mMiniTargetTypes.push(valueToFind);
                        this.mMiniTargetTypeParameters.push(attribute);
                     }
                     else
                     {
                        this.mMiniTargetTypes[miniIndex] = valueToFind;
                        this.mMiniTargetTypeParameters[miniIndex] = attribute;
                     }
                     break;
                  case "targetBody":
                     if(i > this.mMiniTargetBodies.length)
                     {
                        this.mMiniTargetBodies.push(valueToFind);
                     }
                     else
                     {
                        this.mMiniTargetBodies[miniIndex] = valueToFind;
                     }
                     break;
                  case "targetAmount":
                     if(i > this.mMiniTargetAmounts.length)
                     {
                        this.mMiniTargetAmounts.push(valueToFind);
                     }
                     else
                     {
                        this.mMiniTargetAmounts[miniIndex] = valueToFind;
                     }
                     break;
                  case "targetSku":
                     skuTokens = valueToFind.split("|");
                     if(i > this.mMiniTargetSkus.length)
                     {
                        this.mMiniTargetSkus.push(valueToFind);
                        this.mMiniTargetSkusTokens.push(skuTokens);
                     }
                     else
                     {
                        this.mMiniTargetSkus[miniIndex] = valueToFind;
                        this.mMiniTargetSkusTokens[miniIndex] = skuTokens;
                     }
                     break;
                  case "targetIcon":
                     if(i > this.mMiniTargetIcons.length)
                     {
                        this.mMiniTargetIcons.push(valueToFind);
                     }
                     else
                     {
                        this.mMiniTargetIcons[miniIndex] = valueToFind;
                     }
                     break;
                  case "targetFBCredits":
                     this.mMiniTargetFBCredits[miniIndex] = valueToFind;
                     break;
                  case "targetGoToTab":
                     this.mMiniTargetGoToTab[miniIndex] = valueToFind;
                     break;
                  case "targetReceiveAttack":
                     this.mMiniTargetReceiveAttack[miniIndex] = valueToFind;
                     break;
                  case "targetSendAttack":
                     this.mMiniTargetSendAttack[miniIndex] = valueToFind;
                     break;
                  case "targetAttackBound":
                     this.mMiniTargetAttackBound[miniIndex] = valueToFind;
                     break;
                  case "targetProgressDoneFrom":
                     this.mMiniTargetDoneFrom[miniIndex] = valueToFind;
                     break;
                  case "targetLevel":
                     if(!valueFound)
                     {
                        value = int(valueToFind);
                        value--;
                     }
                     if(i > this.mMiniTargetLevels.length)
                     {
                        this.mMiniTargetLevels.push(value);
                     }
                     else
                     {
                        this.mMiniTargetLevels[miniIndex] = value;
                     }
                     break;
                  case "targetNPC":
                     this.mMiniTargetNPC[miniIndex] = valueToFind;
                     break;
                  case "targetProgressAbsolute":
                     this.mMiniTargetIsProgressAbsolute[miniIndex] = valueToFind == "1";
               }
            }
            i++;
         }
      }
      
      private function removeSeparators(action:String) : String
      {
         var sku:Array = null;
         var returnValue:String = "";
         if(action != "")
         {
            sku = action.split(":");
            returnValue = String(sku[0]);
         }
         return returnValue;
      }
      
      private function checkIfSku(action:String) : String
      {
         var sku:Array = null;
         var areCoordsArray:Array = null;
         var returnValue:String = "";
         if(action != "")
         {
            if((sku = action.split(":")).length > 2)
            {
               sku.splice(0,1);
               returnValue = sku.join(":");
            }
            else if(sku[1] != null)
            {
               areCoordsArray = String(sku[1]).split(",");
               if(areCoordsArray[1] == null)
               {
                  returnValue = String(sku[1]);
               }
            }
         }
         return returnValue;
      }
      
      private function checkIfCoords(action:String) : DCCoordinate
      {
         var returnValue:DCCoordinate = null;
         var sku:Array = null;
         var coords:Array = null;
         if(action != "")
         {
            sku = action.split(":");
            if(sku[1] != null)
            {
               returnValue = new DCCoordinate();
               coords = String(sku[1]).split(",");
               returnValue.x = coords[0];
               returnValue.y = coords[1];
               if(coords[2] != null)
               {
                  returnValue.z = coords[2];
               }
            }
         }
         return returnValue;
      }
      
      public function getPostactionTargetSid() : String
      {
         return this.mPostactionTargetSku;
      }
      
      public function getSoundAttached() : String
      {
         return this.mSoundAttached;
      }
      
      private function setSoundAttached(value:String) : void
      {
         this.mSoundAttached = value;
      }
      
      public function getIntroMovie() : String
      {
         return this.mIntroMovie;
      }
      
      private function setIntroMovie(value:String) : void
      {
         this.mIntroMovie = value;
      }
      
      public function getEndMovie() : String
      {
         return this.mEndMovie;
      }
      
      private function setEndMovie(value:String) : void
      {
         this.mEndMovie = value;
      }
      
      public function getTimeToFinish() : String
      {
         return this.mTimeToFinish;
      }
      
      private function setTimeToFinish(value:String) : void
      {
         this.mTimeToFinish = value;
      }
      
      public function containsTargetSku(targetNumber:int, sku:String) : Boolean
      {
         var returnValue:Boolean = false;
         if(this.mMiniTargetSkusTokens[targetNumber] != null)
         {
            returnValue = this.mMiniTargetSkusTokens[targetNumber].indexOf(sku) > -1 || this.mMiniTargetSkusTokens[targetNumber].indexOf("?") > -1;
         }
         else
         {
            returnValue = sku == this.mMiniTargetSkus[targetNumber] || "?" == this.mMiniTargetSkus[targetNumber];
         }
         return returnValue;
      }
   }
}
