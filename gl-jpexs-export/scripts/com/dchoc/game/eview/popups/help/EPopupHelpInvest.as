package com.dchoc.game.eview.popups.help
{
   import com.dchoc.game.eview.popups.investments.EInvestStripe;
   import com.dchoc.game.model.invests.Invest;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.core.Esparragon;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.display.ETexture;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class EPopupHelpInvest extends EPopupHelp
   {
      
      private static const INVEST_IMAGE:String = "InvestImage";
       
      
      private var mPetitions:Array;
      
      public function EPopupHelpInvest()
      {
         super("invest");
      }
      
      private function createFakeInvest(petition:Array) : Boolean
      {
         var SCALE:Number = NaN;
         var bmp:BitmapData = null;
         var matrix:Matrix = null;
         var texture:ETexture = null;
         var image:EImage = null;
         var body:ESprite = null;
         var field:ETextField = null;
         var state:int = int(petition[0]);
         var invest:Invest = new Invest(state);
         var boxInvest:EInvestStripe;
         (boxInvest = new EInvestStripe(null)).setup(null,invest);
         if(boxInvest.checkContentsLoaded())
         {
            SCALE = 0.7;
            bmp = new BitmapData(boxInvest.width * SCALE,boxInvest.height * SCALE,true,16777215);
            (matrix = new Matrix()).scale(SCALE,SCALE);
            bmp.draw(boxInvest,matrix);
            texture = Esparragon.getDisplayFactory().createTextureFromBitmapData(bmp);
            image = petition[1];
            image.setTexture(texture);
            (body = getContent("Body")).eAddChild(image);
            setContent("InvestImage",image);
            image.logicLeft = mBkgDescArea.x + (mBkgDescArea.width - image.width) / 2;
            image.logicTop = mBkgDescArea.y + mBkgDescArea.height - image.height;
            (field = getContentAsETextField("description")).layoutApplyTransformations(mTextDescriptionArea);
            field.applySkinProp(null,"text_body_2");
            field.height -= image.height;
            return true;
         }
         return false;
      }
      
      private function createPetition(state:int) : void
      {
         if(this.mPetitions == null)
         {
            this.mPetitions = [];
         }
         var petition:Array = [state,Esparragon.getDisplayFactory().createImage(null)];
         this.mPetitions.push(petition);
      }
      
      override public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var field:ETextField = null;
         var image:EImage = null;
         var body:ESprite = null;
         var state:int = 0;
         if(mCurrentPage != id)
         {
            mCurrentPage = id;
            setupSpeechBubble();
            (field = getContentAsETextField("description")).layoutApplyTransformations(mTextDescriptionArea);
            field.applySkinProp(null,"text_body_2");
            body = getContent("Body");
            image = getContentAsEImage("InvestImage");
            if(image != null)
            {
               body.eRemoveChild(image);
               image.destroy();
               image = null;
            }
            if((state = mHelpDef.getState(id)) != -1)
            {
               this.createPetition(state);
            }
            setTitleText(DCTextMng.replaceParameters(mHelpDef.getTitle(id),["" + mHelpDef.getPagesCount()]));
            field.setText(mHelpDef.getTip(id));
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var count:int = 0;
         var i:int = 0;
         super.logicUpdate(dt);
         if(this.mPetitions != null)
         {
            count = int(this.mPetitions.length);
            for(i = 0; i < count; )
            {
               if(this.createFakeInvest(this.mPetitions[i]))
               {
                  this.mPetitions.splice(i,1);
                  count--;
                  i--;
               }
               i++;
            }
         }
      }
   }
}
