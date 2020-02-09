import js.Browser.document;
import js.Browser.window;

typedef Bullet = {
    var x:Float;
    var y:Float;
    var d:Int;
}

typedef Enemy = {
    var t:Float;
    var life:Int;
}

class Main {
    static function main() {
        var w = window;
        var c:js.html.CanvasElement = cast w.document.querySelector("canvas");
        var screenSize = 512;
        c.width = c.height = screenSize;
        var ctx:js.html.CanvasRenderingContext2D = c.getContext("2d");
        var lastFireTime:Float = 0;
        var rseed;
        var mx;
        var mustFire:Bool;
        var bullets:Array<Bullet> = [];
        var enemies:Array<Enemy> = [];
        var time:Int = 0;
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

            for(i in [-1, 1]) {
                drawRect(x + (i*15), y+32, 16, 28);
            }
        }
        function drawEnemy(x:Float, y:Float) {
            col("red");
            drawRect(x, y, 30, 60);
            col("brown");

            for(i in [-1, 1]) {
                drawRect(x + (i*15), y-32, 16, 28);
            }
        }
        function random():Float {
            var x = (Math.sin(rseed++) + 1) * 10000;
            return x - Std.int(x);
        }
        w.onmousedown = w.onmouseup= function(e) {
            mustFire = untyped e.buttons;
        }
        w.onmousemove = function(e) {
            mx = e.clientX;
        }
        function fire(d) {
            for(b in bullets) {
                if(b.y < -32) {
                    b.y = 420;
                    b.x = mx;
                    b.d = d;
                    return;
                }
            }

            bullets.push({x:mx, y:420, d:d});
        }
        function loop(t:Float) {
            col("black");
            drawRect(256, 256, screenSize, screenSize);
            drawShip(mx, 460);
            rseed = 1;
            col("white");

            for(i in 0...50) {
                drawRect(random() * 512, (random() * 512 + t * (random() * 0.2)) % 512, 2, 2);
            }

            for(b in bullets) {
                b.y += 5 * b.d;
                col(b.d == -1 ? "lightgreen" : "red");
                drawRect(b.x, b.y, 4, 12);
            }

            if(mustFire) {
                if(time - lastFireTime > 10) {
                    fire(-1);
                    lastFireTime = time;
                }
            }

            for(e in enemies) {
                e.t++;
                drawEnemy(200, -20 + e.t * 1);
            }

            if((time % 100) == 0) {
                enemies.push({t:0, life:100});
            }

            time++;
            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
