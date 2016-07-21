package
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Moomin
	{
		public var graf:MC_Moomin = new MC_Moomin();
		
		public var lifeCount:int = 3;
		
		public var velX:Number = 3;
		public var velY:Number = 0;
		
		public var boost:Number = -4;
		public var grav:Number = 0.8;
		public var topSpeed:Number = 5;
		
		public var jump:Boolean = false;
		
		public var left:Boolean = false;
		public var right:Boolean = false;
		
		public var stage:Stage;
		
		public function Moomin(mainStage:Stage)
		{
			stage = mainStage;
		}		
		
		public function init(x:Number, y:Number):void
		{
			stage.addChild(graf);
			graf.x = x;
			graf.y = y;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyReleased);
		}
		
		public function update():void
		{
			moveMoomin();
		}
			
		public function keyPressed(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.LEFT && e.keyCode != Keyboard.RIGHT)
			{
				left = true;
				graf.scaleX = -1;
			}
			else if (e.keyCode == Keyboard.RIGHT && e.keyCode != Keyboard.LEFT)
			{
				right = true;
				graf.scaleX = 1;
			}
			else if (e.keyCode == Keyboard.SPACE)
				jump = true;
		}
		
		public function keyReleased(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
					left = false;
					break;
				case Keyboard.RIGHT:
					right = false;
					break;
				case Keyboard.SPACE:
					jump = false;
					break;
			}
		}
		
		public function moveMoomin():void
		{
			if (right == true && graf.x < stage.stageWidth - graf.width/2) graf.x += velX;
			if (left == true && graf.x > graf.width/2) graf.x -= velX;
			
			if (jump == true)
				velY = boost;
			else velY += grav;
			
			if (velY > topSpeed)
				velY = topSpeed;
			else if (velY < -topSpeed)
				velY = -topSpeed;
			
			if (graf.y > 0) 
				graf.y += velY;
			else graf.y += grav;
		}
				
		public function random (min:int, max:int):int
		{
			var num:int = (Math.random() * (max - min)) + min;
			return num;
		}
		
		/*
		public function crtlAnim():void
		{
			if (jump == true)
				changeAnim("jump");
			else if (left == true || right == true)
				changeAnim("fly");
			else changeAnim("idle");
		}
		
		public function changeAnim(nextAnim:String):void
		{
			if (graf.currentLabel != nextAnim)
				graf.gotoAndPlay(nextAnim);
		}
		
		*/
	}
}