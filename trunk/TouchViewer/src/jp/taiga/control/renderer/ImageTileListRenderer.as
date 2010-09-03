/**
 *
 * Touch Viewer
 *
 * @author Copyright (c) 2009-2010 taiga.jp.
 * @version 1.2
 *
 * Developed by taiga
 * @see http://taiga.jp/
 *
 * Touch Viewer is (c) 2009-2010 taiga.jp and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */
package jp.taiga.control.renderer {
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.filters.BlurFilter;
    import flash.geom.Matrix;
    import flash.utils.getTimer;
    
    import jp.taiga.control.ExtensionLabel;
    import jp.taiga.event.ListSelectEvent;
    
    import mx.core.UIComponent;
    
    import spark.skins.spark.DefaultComplexItemRenderer;

    /** ImageTileListRenderer を選択した直後のタイミングに送出されます。 */
    [Event (name="imageSelecting", type="jp.taiga.event.ListSelectEvent")]
    /** ImageTileListRenderer を選択してエフェクトが完了したタイミングに送出されます。 */
    [Event (name="imageSelected", type="jp.taiga.event.ListSelectEvent")]
    /**
     * ImageTileListRenderer クラスは、TileList のレンダラークラスです。
     */
    public class ImageTileListRenderer extends DefaultComplexItemRenderer {
        /** @private */
        private static const FILTERS :Array = [new BlurFilter()];
        /** リストのデータ */
        private var __data           :Object;
        /** 更新直前のリストのデータ */
        private var __oldData        :Object;
        /** ファイル、 フォルダ用アイコン */
        protected var image          :UIComponent;
        /** アイコン選択時のエフェクト */
        protected var effect         :UIComponent;
        /** ファイル、フォルダ名ラベル */
        protected var labell         :ExtensionLabel
        /** ファイル、フォルダから取得できるビットマップ */
        protected var bitmapData     :BitmapData;
        /** @inheritDoc */
        public override function get data():Object {
            return __data;
        }
        /** @private */
        public override function set data(value:Object) : void {
            if(value != null) {
                if(__data != value) {
					var i        :int;
					var l        :int;
					var bitmaps_ :Array;
					var bd       :BitmapData;
                    __data = value;
//FIXME:Mac で File.icon.bitmaps は高コストなので、代替手段を検討する
					bitmaps_ = (__data as File).icon.bitmaps;
                    l = bitmaps_.length;
                    for (i = 0; i < l; i++) {
                        bd = bitmaps_[i] as BitmapData;
                        if (bd.height != 32) {
							continue;
                        }
						else {
	                        bitmapData = bd;
							break;
						}
                    }
                    invalidateDisplayList();
                }
            }
        }
        /**
         * コンストラクタ
         */
        public function ImageTileListRenderer() {
            super();
            minWidth  = 100;
            minHeight = 100;
            setStyle("selectionColor", 0x666666);
            setStyle("rollOverColor",  0x666666);
        }
        /** @inheritDoc */
        protected override function createChildren():void {
            super.createChildren();

            image  = addElement( new UIComponent()    ) as UIComponent;
			image.setStyle("verticalCenter", 0);
			image.setStyle("horizontalCenter", 0);

            effect = addElement( new UIComponent()    ) as UIComponent;
			effect.setStyle("verticalCenter", 0);
			effect.setStyle("horizontalCenter", 0);
			effect.setVisible(false, true);

			labell = addElement( new ExtensionLabel() ) as ExtensionLabel;
            labell.percentWidth = 100;
			labell.setStyle("color", 0xffffff);
			labell.setStyle("horizontalCenter", 0);
			labell.setStyle("bottom", 5);

            addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
        }
        /** @inheritDoc */
        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if(__oldData == __data) {
                return;
            }
            cacheAsBitmap = false;
            var bdw      :Number;
            var bdwh     :Number;
            var bdh      :Number;
            var bdhh     :Number;
            var m        :Matrix;
            var g        :Graphics;
            if(image != null) {
                if(bitmapData != null) {
                    bdw = bitmapData.width;
                    bdh = bitmapData.height;
                    bdwh = -bdw * 0.5;
                    bdhh = -bdh * 0.5;

                    m = new Matrix(1, 0, 0, 1, bdwh, bdhh);

                    g = image.graphics;
                    g.clear();
                    g.beginBitmapFill(bitmapData, m);
                    g.drawRect(bdwh, bdhh, bdw, bdh);
                    g.endFill();

                    g = effect.graphics;
                    g.clear();
                    g.beginBitmapFill(bitmapData, m);
                    g.drawRect(bdwh, bdhh, bdw, bdh);
                    g.endFill();
                }
            }
            if(labell != null) {
                if(__data != null) {
                    labell.text = ( __data as File ).name;
                    labell.validateNow();
                }
            }

            cacheAsBitmap = true;

            __oldData = __data;

        }
        /** レンダラー破棄処理 */
        protected function removedFromStageHandler(event:Event):void {
            if(bitmapData != null) {
                bitmapData.dispose();
                bitmapData = null;
            }
            if(image != null) {
                image.graphics.clear();
            }
            if(effect != null) {
                effect.graphics.clear();
            }
            __data = null;
            __oldData = null;
            cacheAsBitmap = false;
        }
        /** レンダラークリック処理 */
        protected function onClickHandler(event:MouseEvent):void {
            dispatchEvent( ListSelectEvent.createImageSelectingEvent() );
            cacheAsBitmap = false;
            effect.setVisible(true, true);
            effect.filters = FILTERS;
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
        /** レンダラークリック後のエフェクト処理 */
        protected function enterFrameHandler(event:Event):void {
            effect.scaleX += 0.1;
            effect.scaleY += 0.1;
            effect.alpha  -= 0.1;
            effect.validateNow();
            if(effect.alpha <= 0) {
                removeEventListener(event.type, arguments.callee);
                effect.setVisible(false, true);
                effect.filters = [];
                effect.scaleX  = 1;
                effect.scaleY  = 1;
                effect.alpha   = 1;
                dispatchEvent( ListSelectEvent.createImageSelectedEvent() );
                cacheAsBitmap = true;
            }
        }
    }
}
