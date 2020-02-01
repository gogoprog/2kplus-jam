import js.Browser.document;
import js.Browser.window;

class Main {
    static function main() {
        var w = window;
        var c:js.html.CanvasElement = cast w.document.querySelector("canvas");
        var time:Float = 0;
        var screenSize = 512;
        c.width = c.height = screenSize;
        var ctx:js.html.CanvasRenderingContext2D = c.getContext("2d");
        var pt:Float = 0;
        var a:Float = 0;
        function loop(t:Float) {
            var dt = (t-pt) / 1000;
            pt = t;
            a += 32 * dt;
            ctx.clearRect(0, 0, screenSize, screenSize);
            ctx.fillRect(a, 0, 32, 32);
            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
