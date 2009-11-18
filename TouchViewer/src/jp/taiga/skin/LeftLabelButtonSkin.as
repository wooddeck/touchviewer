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
package jp.taiga.skin {
    import spark.skins.spark.ButtonSkin;
    /**
     * LeftLabelButtonSkin は、Spark の Button クラススキンのサブクラスです。
     */
    public class LeftLabelButtonSkin extends ButtonSkin {
        /**
         * コンストラクタ
         */
        public function LeftLabelButtonSkin() {
            super();
        }
        /** @inheritDoc */
        protected override function commitProperties() : void {
            super.commitProperties();
            if(labelDisplay != null) {
                labelDisplay.setStyle("textAlign", "left");
            }
        }
    }
}
