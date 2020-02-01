import js.Browser.document;

class Main {
    static function main() {
        new Main();
    }

    private var canvas:js.html.CanvasElement;
    private var ctx:js.html.CanvasRenderingContext2D;

    public function new() {
        canvas = cast document.createElement("canvas");
        document.body.appendChild(canvas);
        ctx = canvas.getContext("2d");
        ctx.fillRect(0, 0, 32, 32);
    }
}
