/**
 *
 * Touch Viewer
 *
 * @author Copyright (c) 2009 taiga.jp.
 * @version 1.0
 *
 * Developed by taiga
 * @see http://taiga.jp/
 *
 * Touch Viewer is (c) 2009 taiga.jp and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */
package jp.taiga.control.renderer {
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.filters.BlurFilter;
    import flash.geom.Matrix;
    
    import jp.taiga.control.ExtensionLabel;
    
    import mx.core.UIComponent;
    
    import spark.skins.spark.DefaultComplexItemRenderer;
    /**
     * ImageTileListRenderer クラスは、TileList のレンダラークラスです。
     */
    public class ImageTileListRenderer extends DefaultComplexItemRenderer {
        /** リストのデータ */
        private var __data    :Object;
        /** ファイル、 フォルダ用アイコン */
        protected var image   :UIComponent;
        /** アイコン選択時のエフェクト */
        protected var effect  :UIComponent;
        /** ファイル、フォルダ名ラベル */
        protected var labell  :ExtensionLabel
        /** ファイル、フォルダから取得できるビットマップ */
        protected var bmpData :BitmapData;
        /** @inheritDoc */
        public override function get data():Object {
            return __data;
        }
        /** @private */
        public override function set data(value:Object) : void {
            if(value != null) {
                __data = value;
                invalidateProperties();
            }
            else {
                if(bmpData != null) {
                    bmpData.dispose();
                    bmpData = null;
                }
                if(image != null) {
                    removeElement(image);
                    image = null;
                }
                if(effect != null) {
                    removeElement(effect);
                    effect = null;
                }
                if(labell != null) {
                    removeElement(labell);
                    labell = null;
                }
                __data = value;
            }
        }
        /**
         * コンストラクタ
         */
        public function ImageTileListRenderer() {
            super();
            selectionColor = 0x666666;
            rollOverColor  = 0x666666;
        }
        /** @inheritDoc */
        protected override function createChildren():void {
            super.createChildren();
            image  = addElement( new UIComponent()    ) as UIComponent;
            effect = addElement( new UIComponent()    ) as UIComponent;
            labell = addElement( new ExtensionLabel() ) as ExtensionLabel;
            labell.percentWidth = 100;
            addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
        }
        /** @inheritDoc */
        protected override function measure() : void {
            minWidth  = 100;
            minHeight = 100;
        }
        /** @inheritDoc */
        protected override function commitProperties() : void {
            super.commitProperties();
            var i        :int;
            var length_  :int;
            var bitmaps_ :Array;
            var bmpData_ :BitmapData;
            
            if(image != null) {
                image.setStyle("verticalCenter", 0);
                image.setStyle("horizontalCenter", 0);
                effect.setStyle("verticalCenter", 0);
                effect.setStyle("horizontalCenter", 0);
                if(__data != null) {
                    bmpData = new BitmapData(1,1);
                    bitmaps_ = ( __data as File ).icon.bitmaps;
                    length_ = bitmaps_.length;
                    for (i = 0; i < length_; i++) {
                        bmpData_ = bitmaps_[i] as BitmapData;
                        if (bmpData_.height > bmpData.height && bmpData_.height <= 32) {
                            bmpData = bmpData_;
                        }
                        else {
                            bmpData_.dispose();
                            bmpData_ = null;
                        }
                    }
                    image.graphics.clear();
                    image.graphics.beginBitmapFill(bmpData, new Matrix(1,0,0,1,-bmpData.width / 2,-bmpData.height / 2));
                    image.graphics.drawRect(-bmpData.width / 2, -bmpData.height / 2, bmpData.width,bmpData.height);
                    image.graphics.endFill();
                    effect.graphics.clear();
                    effect.graphics.beginBitmapFill(bmpData, new Matrix(1,0,0,1,-bmpData.width / 2,-bmpData.height / 2));
                    effect.graphics.drawRect(-bmpData.width / 2, -bmpData.height / 2, bmpData.width,bmpData.height);
                    effect.graphics.endFill();
                }
                effect.setVisible(false, true);
            }
            if(labell != null) {
                labell.setStyle("color", 0xffffff);
                labell.setStyle("horizontalCenter", 0);
                labell.setStyle("bottom", 5);
                if(__data != null) {
                    labell.text = ( __data as File ).name;
                }
            }
        }
        /** レンダラークリック処理 */
        protected function onClickHandler(event:MouseEvent):void {
            effect.setVisible(true, true);
            effect.filters = [new BlurFilter()];
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
                dispatchEvent( new Event("imageSelect", true) );
            }
        }
    }
}
