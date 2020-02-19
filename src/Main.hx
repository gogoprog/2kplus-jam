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
        var lastFireTime:Int;
        var rseed;
        var mx;
        var life:Int;
        var mustFire:Bool;
        var bullets:Array<Bullet>;
        var enemies:Array<Enemy>;
        var time:Int;
        var extremes = [-1, 1];
        var m = Math;
        var abs = m.abs;
        var sin = m.sin;
        var state = 0;
        var score;
        var bestScore = 0;
        ctx.font = "20px monospace";
        function col(n) {
            ctx.fillStyle = n;
        }
        function alpha(n) {
            ctx.globalAlpha = n;
        }
        function scale(s) {
            ctx.scale(s, s);
        }
        function drawRect(x:Float, y:Float, w, h) {
            ctx.fillRect(x-w/2, y-h/2, w, h);
        }
        function mto(x, y) {
            ctx.moveTo(x, y);
        }
        function lto(x, y) {
            ctx.lineTo(x, y);
        }
        function beginPath() {
            ctx.beginPath();
        }
        function fill() {
            ctx.fill();
        }
        function drawShip(x:Float, y:Float) {
            col("#ccd");
            drawRect(x, y, 20, 40);
            col("#669");
            drawRect(x, y, 4, 8);
            beginPath();
            ctx.arc(x, y - 20, 10, 3.14, 0);
            fill();
            col("gold");
            drawRect(x, y + 20, 20, 4);

            for(i in extremes) {
                ctx.save();
                ctx.transform(i, 0, 0, 1, x, y - 16);
                col("#88d");
                beginPath();
                mto(10, 10);
                lto(10, 30);
                lto(20, 30);
                fill();
                ctx.restore();
            }
        }
        function drawEnemy(x:Float, y:Float) {
            col("red");
            drawRect(x, y, 20, 40);
            col("#669");
            drawRect(x, y, 4, 8);
            col("gold");
            drawRect(x, y - 20, 20, 4);

            for(i in extremes) {
                ctx.save();
                ctx.transform(i, 0, 0, 1, x, y - 36);
                col("#666");
                beginPath();
                mto(10, 30);
                lto(10, 10);
                lto(20, 10);
                fill();
                col("#a11");
                beginPath();
                mto(0, 65);
                lto(0, 55);
                lto(10, 55);
                fill();
                ctx.restore();
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
                if(abs(bullets[i].y) > screenSize*2) {
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
                drawRect(random() * screenSize, (random() * screenSize + t * (random() * 0.2)) % screenSize, 2, 2);
            }

            if(state == 0) {
                scale(4);
                ctx.fillText("SHIP2k", 24, 32);
                scale(1/2);
                ctx.fillText("Click to play!", 42, 232);
                scale(1/2);
                ctx.fillText("Best score: " + bestScore, 32, 232);

                // if(mustFire) {
                if(true) {
                    state++;
                    time = score = 0;
                    life = 10;
                    bullets = [];
                    enemies = [];
                    lastFireTime = 0;
                }
            } else if(state == 1) {
                alpha(1);

                for(b in bullets) {
                    b.y += 10 * b.d;
                    col(b.d == -1 ? "lightgreen" : "red");
                    drawRect(b.x, b.y, 4, 12);

                    if(b.d > 0) {
                        if(abs(b.y - 420) + abs(b.x-mx) < 32) {
                            life--;
                            b.y = 999;
                            alpha(0.5);

                            if(life < 1) {
                                bestScore = cast m.max(score, bestScore);
                                state = 0;
                            }
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
                    var y = -64 + e.t;

                    if(e.t % 60 == 0) {
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
                                    score += 100;
                                }
                            }
                        }
                    }

                    drawEnemy(x, y);
                }

                rseed = time;

                if((time % 150) == 0) {
                    var n = enemies.length;

                    for(e in 0...n) {
                        if(enemies[e].t > screenSize) {
                            n = e;
                            break;
                        }
                    }

                    enemies[n] = {x: screenSize * random(), t:0, life:5};
                }

                alpha(1);
                col("#455");
                drawRect(256, 500, screenSize, 24);
                col("white");
                var str = "";

                for(i in 0...10) { str+= i< life ? "O":"_"; }

                ctx.fillText("[" + str + "]", 12, 506);
                ctx.fillText(cast score, 400, 506);
                time++;
            }

            w.requestAnimationFrame(loop);
        }
        loop(0);
    }
}
