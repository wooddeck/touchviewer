package jp.taiga.util {
    import flash.system.Capabilities;
    public final class CapabilitiesUtil {
        public static var isWin:Boolean = (Capabilities.os.indexOf("Windows") >= 0);
        public static var isMac:Boolean = (Capabilities.os.indexOf("Mac OS")  >= 0);
    }
}