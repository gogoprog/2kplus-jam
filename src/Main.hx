import js.Browser.document;
import js.Browser.window;

typedef Bullet = {
    var x:Float;
    var y:Float;
    var d:Int;
}

typedef Enemy = {
    var x:Float;
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
            drawRect(x, y, 30, 40);
            drawRect(x, y - 32, 20, 30);
            col("orange");

            for(i in [-1, 1]) {
                drawRect(x + (i*15), y+22, 16, 28);
            }
        }
        function drawEnemy(x:Float, y:Float) {
            col("red");
            drawRect(x, y, 20, 40);

            for(i in [-1, 1]) {
                col("brown");
                drawRect(x + (i*10), y-32, 16, 28);
                col("cyan");
                drawRect(x + (i*4), y-10, 4, 20);
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
        function fire(x, y, d) {
            for(b in bullets) {
                if(b.y < -32) {
                    b.y = y;
                    b.x = x;
                    b.d = d;
                    return;
                }
            }

            bullets.push({x:x, y:y, d:d});
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
                    fire(mx, 420, -1);
                    lastFireTime = time;
                }
            }

            for(e in enemies) {
                e.t++;
                var x = e.x + Math.sin(e.t / 100) * 100;
                var y =  -20 + e.t * 1;
                drawEnemy(x, y);

                if(e.t % 30 == 0) {
                    fire(x, y, 1);
                }
            }

            rseed = time;

            if((time % 100) == 0) {
                enemies.push({x: 512 * random(), t:0, life:100});
            }

            time++;
            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
