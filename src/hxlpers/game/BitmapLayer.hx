package hxlpers.game;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.utils.ByteArray;

/**
 * ...
 * @author damrem
 */
class BitmapLayer extends Sprite
{
	var fillColor:UInt;

	public var bitmapData:BitmapData;
	
	public function new(w:UInt, h:UInt, ratio:UInt, transparent:Bool=true, fillColor:UInt=0xFFFFFFFF) 
	{
		super();
		this.fillColor = fillColor;
		bitmapData = new BitmapData(w, h, transparent, fillColor);
	}
	
	public function render(?fillColor:UInt):BitmapData
	{
		if (fillColor == null)
		{
			fillColor = this.fillColor;
		}
		bitmapData.fillRect(bitmapData.rect, fillColor);
		bitmapData.draw(this);
		return bitmapData;
	}
	
	public function getBuffer(rerender:Bool=true):ByteArray
	{
		if (rerender)
		{
			render();
		}
		var _buffer = bitmapData.getPixels(bitmapData.rect);
		_buffer.position = 0;
		return _buffer;
	}
	
	
	
	
	
}