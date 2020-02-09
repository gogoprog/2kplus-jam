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
        var life = 100;
        var mustFire:Bool;
        var bullets:Array<Bullet> = [];
        var enemies:Array<Enemy> = [];
        var time:Int = 0;
        var extremes = [-1, 1];
        var m = Math;
        var abs = m.abs;
        var sin = m.sin;
        function col(n) {
            ctx.fillStyle = n;
        }
        function alpha(n) {
            ctx.globalAlpha = n;
        }
        function drawRect(x:Float, y:Float, w, h) {
            ctx.fillRect(x-w/2, y-h/2, w, h);
        }
        function drawShip(x:Float, y:Float) {
            col("white");
            drawRect(x, y, 20, 30);
            drawRect(x, y -20, 16, 20);
            col("orange");

            for(i in extremes) {
                drawRect(x + (i*10), y+16, 12, 20);
            }
        }
        function drawEnemy(x:Float, y:Float) {
            col("red");
            drawRect(x, y, 20, 40);

            for(i in extremes) {
                col("brown");
                drawRect(x + (i*10), y-32, 16, 28);
                col("cyan");
                drawRect(x + (i*4), y-10, 4, 20);
            }
        }
        function random():Float {
            var x = (sin(rseed++) + 1) * 10000;
            return x - Std.int(x);
        }
        w.onmousedown = w.onmouseup = function(e) {
            mustFire = untyped e.buttons;
        }
        w.onmousemove = function(e) {
            mx = e.clientX;
        }
        function fire(x, y, d) {
            var n = bullets.length;

            for(i in 0...n) {
                if(abs(bullets[i].y) > 1024) {
                    n = i;
                    break;
                }
            }

            bullets[n] = {x:x, y:y, d:d};
        }
        function loop(t:Float) {
            col("black");
            drawRect(256, 256, screenSize, screenSize);
            rseed = 1;
            col("white");

            for(i in 0...50) {
                drawRect(random() * 512, (random() * 512 + t * (random() * 0.2)) % 512, 2, 2);
            }

            alpha(1);

            for(b in bullets) {
                b.y += 5 * b.d;
                col(b.d == -1 ? "lightgreen" : "red");
                drawRect(b.x, b.y, 4, 12);

                if(b.d > 0) {
                    if(abs(b.y - 420) + abs(b.x-mx) < 32) {
                        life--;
                        b.y = 999;
                        alpha(0.5);
                    }
                }
            }

            drawShip(mx, 460);

            if(mustFire) {
                if(time - lastFireTime > 10) {
                    fire(mx, 420, -1);
                    lastFireTime = time;
                }
            }

            for(e in enemies) {
                var x = e.x + sin(++e.t / 100) * 100;
                var y =  -64 + e.t;

                if(e.t % 30 == 0) {
                    fire(x, y, 1);
                }

                alpha(1);

                for(b in bullets) {
                    if(b.d < 0) {
                        if(abs(b.y - y) + abs(b.x-x) < 32) {
                            b.y = -999;
                            e.life -= 1;
                            alpha(0.5);

                            if(e.life < 1) {
                                e.t = 666;
                            }
                        }
                    }
                }

                drawEnemy(x, y);
            }

            rseed = time;

            if((time % 100) == 0) {
                var n = enemies.length;

                for(e in 0...n) {
                    if(enemies[e].t > 666) {
                        n = e;
                        break;
                    }
                }

                enemies[n] = {x: 512 * random(), t:0, life:5};
            }

            col("white");
            ctx.font = "20px Courier New";
            ctx.fillText("HP: " + life, 12, 500);
            time++;
            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
