import js.Browser.document;
import js.Browser.window;

typedef Point = {
    var x:Float;
    var y:Float;
}

class Main {
    static function main() {
        var w = window;
        var c:js.html.CanvasElement = cast w.document.querySelector("canvas");
        var time:Float = 0;
        var screenSize = 512;
        c.width = c.height = screenSize;
        var ctx:js.html.CanvasRenderingContext2D = c.getContext("2d");
        var pt:Float = 0;
        var lastFireTime:Float = 0;
        var a:Float = 0;
        function col(n) {
            ctx.fillStyle = n;
        }
        function drawRect(x:Float, y:Float, w, h) {
            ctx.fillRect(x-w/2, y-h/2, w, h);
        }
        function drawShip(x:Float, y:Float) {
            col("white");
            drawRect(x, y, 30, 60);
            col("orange");
            drawRect(x-15, y+32, 16, 28);
            drawRect(x+15, y+32, 16, 28);
        }
        var rseed = 1;
        function random():Float {
            var x = (Math.sin(rseed++) + 1) * 10000;
            return x - Std.int(x);
        }
        var mx = 0;
        var bullets:Array<Point> = [];
        var mustFire:Bool;
        w.onmousedown = w.onmouseup= function(e) {
            mustFire = untyped e.buttons;
        }
        w.onmousemove = function(e) {
            mx = e.clientX;
        }
        function fire() {
            for(b in bullets) {
                if(b.y < -32) {
                    b.y = 420;
                    b.x = mx;
                    return;
                }
            }

            bullets.push({x:mx, y:420});
        }
        function loop(t:Float) {
            var dt = (t-pt) / 1000;
            pt = t;
            a += 32 * dt;
            ctx.fillStyle="black";
            drawRect(256, 256, screenSize, screenSize);
            drawShip(mx, 460);
            rseed = 1;
            col("white");

            for(i in 0...50) {
                drawRect(random() * 512, (random() * 512 + t * (random() * 0.2)) % 512, 2, 2);
            }

            col("lightgreen");

            for(b in bullets) {
                b.y -= 200 * dt;
                drawRect(b.x, b.y, 4, 8);
            }

            if(mustFire) {
                if(t - lastFireTime > 200) {
                    fire();
                    lastFireTime = t;
                }
            }

            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
