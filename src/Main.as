package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	[SWF(width="550",height="400",frameRate="48",backgroundColor="0x0066CC")]
	
	public class Main extends Sprite
	{		
		public var pause:Boolean = false;
		
		public var splashscreen:MC_Splash = new MC_Splash();
		public var gameover:MC_KO = new MC_KO();

		public var background:MC_BG = new MC_BG();

		public var moomin1:Moomin;
		public var snufkin:Snufkin;
		public var HUD:MC_MoominHUD = new MC_MoominHUD();
		
		public var coins:Array = new Array();
		
		public var score:int = 0;
		public var highScore:int = 0;
		
		public var coinscore:int = 0;
		
		public var timerID:int;
		
		public var timeLapse:int = 1000;
		public var timeLeft:int = 5;
						
		public var format1:TextFormat = new TextFormat();
		
		public var text1:TextField = new TextField();
		public var text2:TextField = new TextField();
		public var text3:TextField = new TextField();

		public var finalText:TextField = new TextField();
		
		public var sndBGMusic:BG_Music = new BG_Music();
		public var sndBGMusicChannel:SoundChannel;
		
		public function Main()
		{
			stage.addChild(splashscreen);
			setTimeout(function():void { stage.removeChild(splashscreen); playGame();}, 3000);
		}
		
		
		public function playGame():void
		{
			sndBGMusicChannel=sndBGMusic.play();
			stage.addChild(background);
			stage.addChild(HUD);
			stage.addChild(text1);
			stage.addChild(text2);
			stage.addChild(text3);
			
			moomin1 = new Moomin(stage);
			moomin1.init(200, 200);
			
			snufkin = new Snufkin(stage);
			snufkin.reset(stage.stageWidth, random(0, stage.stageHeight));
			
			createCoins();
			
			stage.addEventListener(Event.ENTER_FRAME,mainUpdate);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,pauseGame);
			
			format1.font = "Comic Sans MS";
			format1.size = 24;
			format1.color = 0xFFFFFF;
			format1.bold = true;
			format1.align = TextFormatAlign.LEFT;
			
			// Score display
			text1.defaultTextFormat = new TextFormat("Comic Sans MS", 24, 0xFFFFFF, true);
			
			text1.width = 500;
			text1.height = 40;
			
			text1.x = 20;
			text1.y = 20;
			
			text1.selectable = false;
			
			// Rubies / coin counter display
			text2.defaultTextFormat = format1;
			
			text2.width = 500;
			text2.height = 40;
			
			text2.x = 20;
			text2.y = 40;
			
			text2.selectable = false;
			
			// Life counter display
			HUD.x = stage.stageWidth - 80;
			HUD.y = stage.stageHeight - 40;
			
			text3.defaultTextFormat = format1;
			
			text3.width = 200;
			text3.height = 40;
			
			text3.x = stage.stageWidth - 60;
			text3.y = stage.stageHeight - 40;
			
			text3.selectable = false;
			
			timerID = setInterval(timeOver,timeLapse);	
		}
		
		public function timeOver():void
		{
			timeLeft -= 1;

			if (timeLeft == 0)
			{
				timeLeft = 5;
				createCoins();
			}
		}

		public function pauseGame(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.P)
			{
				if (pause == false)
				{
					pause = true;
					stage.removeEventListener(Event.ENTER_FRAME,mainUpdate);	
				}
				else if (moomin1.lifeCount > 0)
				{
					pause = false;
					stage.addEventListener(Event.ENTER_FRAME,mainUpdate);
				}
			}
		}
		
		public function mainUpdate(e:Event):void
		{
			moomin1.update();
			
			moveCoins();
			snufkin.move();
			
			colDetect();
			
			score++;
			
			// Extra life
			if (coinscore == 100) 
			{
				coinscore = 0;
				moomin1.lifeCount ++;
			}
			
			// Life lost
			if (moomin1.graf.y >= stage.stageHeight + moomin1.graf.width || snufkin.graf.hitTestObject(moomin1.graf))
			{
				moomin1.graf.x = random(0, stage.stageWidth);
				moomin1.graf.y = -moomin1.graf.height;
				moomin1.velY = 0;
				if (moomin1.lifeCount > 0) 
					moomin1.lifeCount --;
				else 
					gameOver();
			}
			
			var scoredisplay:int = score / 10;
			
			text1.text = "score : " + scoredisplay;
			text2.text = "rubies : " + coinscore;
			text3.text = " x " + moomin1.lifeCount;		
		}		
		
		
		public function gameOver():void
		{
			clearInterval(timerID); 
			stage.removeChild(moomin1.graf);
			stage.removeChild(snufkin.graf);
			stage.removeChild(background);
			for (var i:int = 0; i < coins.length; i++) 
			{			
				stage.removeChild(coins[i].graf);
				coins.splice(i,1);	
				break;
			}
			
			stage.addChild(gameover);
			stage.removeEventListener(Event.ENTER_FRAME,mainUpdate);
		}
						
		public function colDetect():void
		{
			for (var i:int = 0; i < coins.length; i++) 
			{
				if (coins[i].graf.hitTestObject(moomin1.graf))
				{
					coinscore++;
					
					stage.removeChild(coins[i].graf);
					coins.splice(i,1);	
			
					break;
				}	
			}
		}	
		
		public function createCoins():void
		{
			var posY:Number = random(0,stage.stageHeight);
			
			for (var i:int = 0; i < 5 ; i++) 
			{
				var coin:Coin = new Coin(stage);
				coin.reset(stage.stageWidth + 35 * i, posY);
				coins.push(coin);
			}
		}		
		
		public function moveCoins():void
		{	
			for (var i:int = 0; i < coins.length; i++) 
			{
				coins[i].move();
			
				if (coins[i].graf.x <  -coins[i].graf.width/2)
				{
					stage.removeChild(coins[i].graf);
					coins.splice(i,1);	
						
					break;	
				}
			}
		}
					
		public function random (min:int, max:int):int
		{
			var num:int = (Math.random() * (max - min)) + min;
			return num;
		}		
	}
}