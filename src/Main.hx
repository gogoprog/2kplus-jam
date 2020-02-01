import js.Browser.document;
import js.Browser.window;

class Main {
    static function main() {
        var doc = window.document;
        var c:js.html.CanvasElement = cast doc.createElement("canvas");
        var time:Float = 0;
        var screenSize = 512;
        doc.body.appendChild(c);
        c.width = c.height = screenSize;
        var ctx:js.html.CanvasRenderingContext2D = c.getContext("2d");
        function loop(t:Float) {
            time = t/1000;
            ctx.clearRect(0, 0, screenSize, screenSize);
            ctx.fillRect(time * 50, 0, 32, 32);
            window.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
