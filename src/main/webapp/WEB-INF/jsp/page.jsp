<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="utf-8">
    <title>iotek</title>

    <style>
        html {
            box-sizing: border-box;
        }

        *,
        *:before,
        *:after {
            box-sizing: inherit;
            margin: 0;
            padding: 0;
        }

        html,
        body,
        canvas {
            width: 100%;
            height: 100%;
        }

        body {
            width: 100%;
            height: 100%;
            background-color: #222;
            position: relative;
            z-index: 0;
        }
        body:after {
            content: '';
            width: 100%;
            height: 100%;
            display: block;
            position: absolute;
            top: 0;
            left: 0;
            background-color: rgba(0, 0, 0, 0.1);
            z-index: 1;
            -webkit-animation: thunder-bg 6s infinite;
            animation: thunder-bg 6s infinite;
        }

        canvas {
            display: block;
            position: absolute;
            top: 0;
            left: 0;
        }

        #canvas3 {
            z-index: 5;
        }

        #canvas2 {
            z-index: 10;
        }

        #canvas1 {
            z-index: 100;
        }

        @-webkit-keyframes thunder-bg {
            0% {
                background-color: rgba(34, 34, 34, 0.9);
            }
            9% {
                background-color: rgba(34, 34, 34, 0.9);
            }
            10% {
                background-color: rgba(59, 59, 59, 0.3);
            }
            10.5% {
                background-color: rgba(34, 34, 34, 0.9);
            }
            80% {
                background-color: rgba(34, 34, 34, 0.9);
            }
            82% {
                background-color: rgba(59, 59, 59, 0.3);
            }
            83% {
                background-color: rgba(34, 34, 34, 0.9);
            }
            83.5% {
                background-color: rgba(59, 59, 59, 0.3);
            }
            100% {
                background-color: rgba(34, 34, 34, 0.9);
            }
        }
    </style>
</head>
<body>
<canvas id="canvas1"></canvas>
<canvas id="canvas2"></canvas>
<canvas id="canvas3"></canvas>

<script>
    var canvas1 = document.getElementById('canvas1');
    var canvas2 = document.getElementById('canvas2');
    var canvas3 = document.getElementById('canvas3');
    var ctx1 = canvas1.getContext('2d');
    var ctx2 = canvas2.getContext('2d');
    var ctx3 = canvas3.getContext('2d');

    var rainthroughnum = 500;
    var speedRainTrough = 25;
    var RainTrough = [];

    var rainnum = 500;
    var rain = [];

    var lightning = [];
    var lightTimeCurrent = 0;
    var lightTimeTotal = 0;

    var w = canvas1.width = canvas2.width = canvas3.width = window.innerWidth;
    var h = canvas1.height = canvas2.height = canvas3.height = window.innerHeight;
    window.addEventListener('resize', function() {
        w = canvas1.width = canvas2.width = canvas3.width = window.innerWidth;
        h = canvas1.height = canvas2.height = canvas3.height = window.innerHeight;
    });

    function random(min, max) {
        return Math.random() * (max - min + 1) + min;
    }

    function clearcanvas1() {
        ctx1.clearRect(0, 0, w, h);
    }

    function clearcanvas2() {
        ctx2.clearRect(0, 0, canvas2.width, canvas2.height);
    }

    function clearCanvas3() {
        ctx3.globalCompositeOperation = 'destination-out';
        ctx3.fillStyle = 'rgba(0,0,0,' + random(1, 30) / 100 + ')';
        ctx3.fillRect(0, 0, w, h);
        ctx3.globalCompositeOperation = 'source-over';
    };

    function createRainTrough() {
        for (var i = 0; i < rainthroughnum; i++) {
            RainTrough[i] = {
                x: random(0, w),
                y: random(0, h),
                length: Math.floor(random(1, 830)),
                opacity: Math.random() * 0.2,
                xs: random(-2, 2),
                ys: random(10, 20)
            };
        }
    }

    function createRain() {
        for (var i = 0; i < rainnum; i++) {
            rain[i] = {
                x: Math.random() * w,
                y: Math.random() * h,
                l: Math.random() * 1,
                xs: -4 + Math.random() * 4 + 2,
                ys: Math.random() * 10 + 10
            };
        }
    }

    function createLightning() {
        var x = random(100, w - 100);
        var y = random(0, h / 4);

        var createCount = random(1, 3);
        for (var i = 0; i < createCount; i++) {
            single = {
                x: x,
                y: y,
                xRange: random(5, 30),
                yRange: random(10, 25),
                path: [{
                    x: x,
                    y: y
                }],
                pathLimit: random(40, 55)
            };
            lightning.push(single);
        }
    };

    function drawRainTrough(i) {
        ctx1.beginPath();
        var grd = ctx1.createLinearGradient(0, RainTrough[i].y, 0, RainTrough[i].y + RainTrough[i].length);
        grd.addColorStop(0, "rgba(255,255,255,0)");
        grd.addColorStop(1, "rgba(255,255,255," + RainTrough[i].opacity + ")");

        ctx1.fillStyle = grd;
        ctx1.fillRect(RainTrough[i].x, RainTrough[i].y, 1, RainTrough[i].length);
        ctx1.fill();
    }

    function drawRain(i) {
        ctx2.beginPath();
        ctx2.moveTo(rain[i].x, rain[i].y);
        ctx2.lineTo(rain[i].x + rain[i].l * rain[i].xs, rain[i].y + rain[i].l * rain[i].ys);
        ctx2.strokeStyle = 'rgba(174,194,224,0.5)';
        ctx2.lineWidth = 1;
        ctx2.lineCap = 'round';
        ctx2.stroke();
    }

    function drawLightning() {
        for (var i = 0; i < lightning.length; i++) {
            var light = lightning[i];

            light.path.push({
                x: light.path[light.path.length - 1].x + (random(0, light.xRange) - (light.xRange / 2)),
                y: light.path[light.path.length - 1].y + (random(0, light.yRange))
            });

            if (light.path.length > light.pathLimit) {
                lightning.splice(i, 1);
            }

            ctx3.strokeStyle = 'rgba(255, 255, 255, .1)';
            ctx3.lineWidth = 3;
            if (random(0, 15) === 0) {
                ctx3.lineWidth = 6;
            }
            if (random(0, 30) === 0) {
                ctx3.lineWidth = 8;
            }

            ctx3.beginPath();
            ctx3.moveTo(light.x, light.y);
            for (var pc = 0; pc < light.path.length; pc++) {
                ctx3.lineTo(light.path[pc].x, light.path[pc].y);
            }
            if (Math.floor(random(0, 30)) === 1) { //to fos apo piso
                ctx3.fillStyle = 'rgba(255, 255, 255, ' + random(1, 3) / 100 + ')';
                ctx3.fillRect(0, 0, w, h);
            }

            if(i == lightning.length - 1){
                ctx3 .font="50px 微软雅黑"
                ctx3.fillStyle='white'
                ctx3.fillText('海同教育，NB!', lightning[i].x - 100, lightning[i].y + 300,300)

            }
            ctx3.lineJoin = 'miter';

            ctx3.stroke();
        }
    };

    function animateRainTrough() {
        clearcanvas1();
        for (var i = 0; i < rainthroughnum; i++) {
            if (RainTrough[i].y >= h) {
                RainTrough[i].y = h - RainTrough[i].y - RainTrough[i].length * 5;
            } else {
                RainTrough[i].y += speedRainTrough;
            }
            drawRainTrough(i);
        }
    }

    function animateRain() {
        clearcanvas2();
        for (var i = 0; i < rainnum; i++) {
            rain[i].x += rain[i].xs;
            rain[i].y += rain[i].ys;
            if (rain[i].x > w || rain[i].y > h) {
                rain[i].x = Math.random() * w;
                rain[i].y = -20;
            }
            drawRain(i);
        }
    }

    function animateLightning() {
        clearCanvas3();
        lightTimeCurrent++;
        if (lightTimeCurrent >= lightTimeTotal) {
            createLightning();
            lightTimeCurrent = 0;
            lightTimeTotal = 200;  //rand(100, 200)
        }
        drawLightning();
    }

    function init() {
        createRainTrough();
        createRain();
        window.addEventListener('resize', createRainTrough);
    }
    init();

    function animloop() {
        animateRainTrough();
        animateRain();
        animateLightning();
        requestAnimationFrame(animloop);
    }
    animloop();</script>

</body>
</html>
