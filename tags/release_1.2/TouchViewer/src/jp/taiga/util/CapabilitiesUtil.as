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
package jp.taiga.util {
    import flash.system.Capabilities;
    /**
     * CapabilitiesUtil は、Capabilities クラスの Util クラスです。
     */
    public final class CapabilitiesUtil {
        public static var isWin  :Boolean = (Capabilities.os.toLocaleLowerCase().indexOf("win")   > -1);
        public static var isMac  :Boolean = (Capabilities.os.toLocaleLowerCase().indexOf("mac")   > -1);
        public static var isLinux:Boolean = (Capabilities.os.toLocaleLowerCase().indexOf("linux") > -1);
    }
}
