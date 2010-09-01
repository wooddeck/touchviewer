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
package jp.taiga.event {
    import flash.events.Event;
    /**
     * ListSelectEvent クラスは、ImageTileListRenderer の操作に関わるイベントクラスです。
     * @see jp.taiga.control.renderer.ImageTileListRenderer
     */
    public class ListSelectEvent extends Event {
        /** ListSelectEvent.IMAGE_SELECTING 定数は、imageSelecting イベントのイベントオブジェクトの type プロパティ値を定義します。この値は、ImageTileListRenderer を選択した直後のタイミングを示します。 */
        public static const IMAGE_SELECTING :String = "imageSelecting";
        /** ListSelectEvent.IMAGE_SELECTED 定数は、imageSelected イベントのイベントオブジェクトの type プロパティ値を定義します。この値は、ImageTileListRenderer を選択してエフェクトが完了したタイミングを示します。 */
        public static const IMAGE_SELECTED  :String = "imageSelected";
        /** タイプ imageSelecting の ListSelectEvent インスタンスを生成します。 */
        public static function createImageSelectingEvent():ListSelectEvent {
            var resultEvent:ListSelectEvent = new ListSelectEvent(ListSelectEvent.IMAGE_SELECTING);
            return resultEvent;
        }
        /** タイプ imageSelected の ListSelectEvent インスタンスを生成します。 */
        public static function createImageSelectedEvent():ListSelectEvent {
            var resultEvent:ListSelectEvent = new ListSelectEvent(ListSelectEvent.IMAGE_SELECTED);
            return resultEvent;
        }
        /**
         * コンストラクタ
         */
        public function ListSelectEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }
        /** @inheritDoc */
        public override function clone():Event {
            return new ListSelectEvent(type, bubbles, cancelable);
        }
        /** @inheritDoc */
        public override function toString():String {
            return formatToString("ListSelectEvent", "type", "bubbles", "cancelable", "eventPhase");
        }
    }
}
