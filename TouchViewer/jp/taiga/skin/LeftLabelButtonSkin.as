package jp.taiga.skin {
    import spark.skins.spark.ButtonSkin;
    public class LeftLabelButtonSkin extends ButtonSkin {
        public function LeftLabelButtonSkin() {
            super();
        }
        protected override function commitProperties() : void {
            super.commitProperties();
            if(labelDisplay != null) {
                labelDisplay.setStyle("textAlign", "left");
            }
        }
    }
}