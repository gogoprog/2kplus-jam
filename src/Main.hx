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
        function col(n) {
            ctx.fillStyle = n;
        }
        function drawRect(x:Float, y:Float, w, h) {
            ctx.fillRect(x-w/2, y-h/2, w, h);
        }
        function drawShip(x:Float, y:Float) {
            col("white");
            drawRect(x, y, 32, 64);
            col("orange");
            drawRect(x-20, y+32, 16, 28);
            drawRect(x+20, y+32, 16, 28);
        }
        function drawStar(x:Float, y:Float) {
            drawRect(x, y, 2, 2);
        }
        function loop(t:Float) {
            var dt = (t-pt) / 1000;
            pt = t;
            a += 32 * dt;
            ctx.fillStyle="black";
            drawRect(256, 256, screenSize, screenSize);
            drawShip(256 + Math.sin(a/10) * 100, 400);
            drawStar(50, 50);
            drawStar(250, 90);
            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
