package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author umhr
	 */
	[SWF(width = 465, height = 465, backgroundColor = 0x000000, frameRate = 30)]
	public class Main extends Sprite 
	{
		private var _mousePoint:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
		private var _count:int;
		private var _bitmap:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000));
		private var _shape:Shape = new Shape();
		private const FADE:ColorTransform = new ColorTransform(1, 1, 1, 1, -0x6, -0x6, -0x6);
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.addChild(_bitmap);
			_bitmap.filters = [new BlurFilter(8,8)];
			this.addChild(_shape);
			
			var point:Point = new Point(mouseX, mouseY);
			for (var i:int = 0; i < 3; i++) {
				var vector:Vector.<Point> = new Vector.<Point>();
				for (var j:int = 0; j < 3; j++) {
					vector[j] = point;
				}
				_mousePoint[i] = vector;
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:Event):void 
		{
			_count++;
			for (var i:int = 0; i < 3; i++) {
				var inertiaPoint:Point = _mousePoint[i][0].subtract(_mousePoint[i][1]).add(_mousePoint[i][0]);
				var radian:Number = _count / 6 + Math.PI * 2 * i / 3;
				var r:Number = 10 * (1 + 1 * Math.sin(_count / 12));
				var mousePoint:Point = new Point(mouseX + Math.cos(radian) * r , mouseY + Math.sin(radian) * r);
				inertiaPoint.x = inertiaPoint.x * 0.97 + mousePoint.x * 0.03;
				inertiaPoint.y = inertiaPoint.y * 0.97 + mousePoint.y * 0.03;
				_mousePoint[i].unshift(inertiaPoint);
				_mousePoint[i].length = 2;
			}
			draw(_mousePoint);
		}
		
		/**
		 * 線を描画
		 * @param	mousePoint
		 */
		private function draw(mousePoint:Vector.<Vector.<Point>>):void {
			_shape.graphics.clear();
			var colors:Array = [0xFF0000, 0x00FF00, 0x0000FF];
			for (var i:int = 0; i < 3; i++) {
				_shape.graphics.lineStyle(4, colors[i]);
				_shape.graphics.moveTo(mousePoint[i][0].x, mousePoint[i][0].y);
				var m:int = mousePoint[0].length;
				for (var j:int = 1; j < m; j++) {
					_shape.graphics.lineTo(mousePoint[i][j].x, mousePoint[i][j].y);
				}
				
				_shape.graphics.lineStyle(0, colors[i]);
				_shape.graphics.beginFill(colors[i]);
				_shape.graphics.drawCircle(mousePoint[i][0].x, mousePoint[i][0].y, 2);
			}
			_bitmap.bitmapData.colorTransform(_bitmap.bitmapData.rect, FADE);
			_bitmap.bitmapData.draw(_shape, null, null, "add");
		}
	}
	
}