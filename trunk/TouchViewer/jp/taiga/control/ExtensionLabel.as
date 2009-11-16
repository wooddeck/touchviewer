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
package jp.taiga.control {
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import mx.core.UIComponent;
    import mx.utils.StringUtil;
    /** @private */
    [Style(name="color",             type="uint",   format="Color",                    inherit="yes")]
    /** @private */
    [Style(name="disabledColor",     type="uint",   format="Color",                    inherit="yes")]
    /** @private */
    [Style(name="ellipsisColor",     type="uint",   format="Color",                    inherit="yes")]
    /** @private */
    [Style(name="fontAntiAliasType", type="String", enumeration="normal,advanced",     inherit="yes")]
    /** @private */
    [Style(name="fontFamily",        type="String",                                    inherit="yes")]
    /** @private */
    [Style(name="fontGridFitType",   type="String", enumeration="none,pixel,subpixel", inherit="yes")]
    /** @private */
    [Style(name="fontSharpness",     type="Number",                                    inherit="yes")]
    /** @private */
    [Style(name="fontSize",          type="Number", format="Length",                   inherit="yes")]
    /** @private */
    [Style(name="fontStyle",         type="String", enumeration="normal,italic",       inherit="yes")]
    /** @private */
    [Style(name="fontThickness",     type="Number",                                    inherit="yes")]
    /** @private */
    [Style(name="fontWeight",        type="String", enumeration="normal,bold",         inherit="yes")]
    /** @private */
    [Style(name="kerning",           type="Boolean",                                   inherit="yes")]
    /** @private */
    [Style(name="letterSpacing",     type="Number",                                    inherit="yes")]
    /** @private */
    [Style(name="textAlign",         type="String", enumeration="left,center,right",   inherit="yes")]
    /** @private */
    [Style(name="textDecoration",    type="String", enumeration="none,underline",      inherit="yes")]
    /** @private */
    [Style(name="textIndent",        type="Number", format="Length",                   inherit="yes")]
    /** @private */
    [Style(name="leading",           type="Number", format="Length",                   inherit="yes")]
    /** @private */
    [Style(name="paddingRight",      type="Number", format="Length",                   inherit="no") ]
    /** @private */
    [Style(name="paddingLeft",       type="Number", format="Length",                   inherit="no") ]
    /**
     * ExtensionLabel クラスは、自身の矩形領域を超えたとき、内包したラベルの表示内容を省略するラベルコンポーネントです。
     */
    public class ExtensionLabel extends UIComponent {
        /** @private */
        private var __text      :String;
        /** @private */
        private var _ellipsis   :String;
        /** TextField インスタンス */
        protected var textField :TextField;
        /** テキスト */
        public function get text():String           { return __text;                          }
        /** @private */
        public function set text(s:String):void     { __text = s;    invalidateDisplayList(); }
        /** 区切り文字です。 */
        public function set ellipsis(s:String):void { _ellipsis = s; invalidateDisplayList(); }
        /**
         * コンストラクタ
         */
        public function ExtensionLabel() {
            super();
            _ellipsis = "...";
            addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        }
        /** @inheritDoc */
        protected override function createChildren():void {
            super.createChildren();

            textField            = addChild( new TextField() ) as TextField;
            textField.multiline  = false;
            textField.wordWrap   = false;
            textField.selectable = false;

        }
        /** @inheritDoc */
        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            var prefixIndex          :int;
            var suffixIndex          :int;
            var prefixText_          :String;
            var suffixText_          :String;
            var tmpText              :String;
            var tmpTextFormat        :TextFormat;
            var ellipsisColorString_ :String;

            if(textField != null) {
                tmpTextFormat = getTextFormat();
                textField.defaultTextFormat = tmpTextFormat;

                textField.setTextFormat(tmpTextFormat);

                textField.text     = "あj";
                textField.autoSize = TextFieldAutoSize.LEFT;
                super.height       = textField.height;
                textField.autoSize = TextFieldAutoSize.NONE;
                textField.text     = "";
                textField.width    = unscaledWidth;

                tmpText = textField.text = __text ? __text : "";
                prefixIndex = suffixIndex = int(textField.length / 2) + 1;

                ellipsisColorString_ = getFigure ( ( getStyle("ellipsisColor") ? getStyle("ellipsisColor") : 0xffffff).toString(16) );

                while(textField.textWidth + 4 > width && (width > 0) ) {
                    prefixText_ = tmpText.substr(0, --prefixIndex);
                    suffixText_ = tmpText.substring(++suffixIndex);
//                    textField.text = prefixText_ + _ellipsis + suffixText_;
                    textField.htmlText = prefixText_ + "<font color='"
                        + ellipsisColorString_
                        + "'><b>"
                        + _ellipsis
                        + "</b></font>" + suffixText_;
                }
            }
        }
        /** ロールオーバー処理 */
        protected function rollOverHandler(event:MouseEvent):void {
            if(__text != null && __text != "") {
                super.toolTip = __text;
            }
        }
        /** スタイルで定義された内容を TextFormat に変換して返します */
        protected function getTextFormat():TextFormat {
            var resultTextFormat:TextFormat = new TextFormat();

            resultTextFormat.align         = /*getStyle("textAlign") ? getStyle("textAlign") : */"center";
            resultTextFormat.bold          = getStyle("fontWeight") == "bold";

            if (enabled) {
                resultTextFormat.color     = getStyle("color") | 0;
            }
            else {
                resultTextFormat.color     = getStyle("disabledColor") ? getStyle("disabledColor") : 0x333333;
            }
            resultTextFormat.font          = getStyle("fontFamily") ? StringUtil.trimArrayElements(getStyle("fontFamily"), ",")
                                             : StringUtil.trimArrayElements("ＭＳ ゴシック, Osaka, メイリオ", ",");

            resultTextFormat.indent        = getStyle("textIndent") | 0;
            resultTextFormat.italic        = getStyle("fontStyle") == "italic";
            resultTextFormat.kerning       = getStyle("kerning");
            resultTextFormat.leading       = getStyle("leading") ? getStyle("leading") : 2;
            resultTextFormat.leftMargin    = getStyle("paddingLeft") | 0;
            resultTextFormat.letterSpacing = getStyle("letterSpacing") | 0;
            resultTextFormat.rightMargin   = getStyle("paddingRight") | 0;
            resultTextFormat.size          = getStyle("fontSize") ? getStyle("fontSize") : 11;
            resultTextFormat.underline     = getStyle("textDecoration") == "underline";

            return resultTextFormat;
        }
        /** 桁あわせ */
        private function getFigure(s:String):String {
            var i  :int;
            var l  :int = s.length;
            var sp :String = "#";
            if (6 > l) {
                for (i = 0; i < 6 - l; i++) {
                    sp += "0";
                }
                sp += s;
                return sp;
            }
            else {
                return String("#" + s);
            }
        }
    }
}
