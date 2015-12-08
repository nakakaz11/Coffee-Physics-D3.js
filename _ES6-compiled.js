/* ES6 */

// Expression bodies
//var odds = evens.map(v => v + 1);
//var nums = evens.map((v, i) => v + i);
//var pairs = evens.map(v => ({even: v, odd: v + 1}));

// Statement bodies
/*nums.forEach(v => {
  if (v % 5 === 0)
    fives.push(v);
});*/

"use strict";

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var marked0$0 = [SquareAnim, gen].map(regeneratorRuntime.mark);

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var MYAPP = MYAPP || {};
MYAPP.name = "My First SPA";
MYAPP.data = "2015/06/25";
MYAPP.Update = function (a) {
  return a;
};
MYAPP.Delete = function (b) {
  return b;
};

// オブジェクトのコンテナ
MYAPP.modules = {};
MYAPP.modules.name = "My First SPA's first module";
MYAPP.modules.data = {
  1: "test",
  2: "test2",
  3: "test3"
};
console.info("MYAPP", MYAPP);

// () => {}で関数を記述。thisにバインドされる。
var a1 = ["Hydrogen", "Helium", "Lithium", "Beryl lium"];

// http://qiita.com/KENJU/items/c7fad62a12cc2809b507
// sw itar ita
function forFor() {
  for (var i = 0, _l = a1.length; i < _l; i++) {
    var obj = a1[i];
    console.info(obj);
  }
}
forFor();

//var a2 = a1.map(function(s){ return s.length });
var a3 = a1.map(function (s) {
  return s.length;
});
console.info( //"a2", a2,
"a3", a3);

// objectリテラルを返すためには括弧で囲むことを覚えてください。
//var func = () => {  foo: 1  };               // Calling func() returns undefined!
var func = function func() {
  return { foo: 1 };
};

// http://gao-tec.seesaa.net/article/420477038.html

var Square = (function () {
  function Square(x, y, size, v) {
    _classCallCheck(this, Square);

    this.x = x;
    this.y = y;
    this.size = size;
    this.v = v;
    this.angle = -v;
  }

  _createClass(Square, [{
    key: "rotate",
    value: function rotate() {
      this.angle += this.v;
    }
  }]);

  return Square;
})();

function SquareAnim(ctx, x, y, size, v, color) {
  var square;
  return regeneratorRuntime.wrap(function SquareAnim$(context$1$0) {
    while (1) switch (context$1$0.prev = context$1$0.next) {
      case 0:
        square = new Square(x, y, size, v);

      case 1:
        if (!true) {
          context$1$0.next = 14;
          break;
        }

        ctx.fillStyle = color;
        square.rotate();

        ctx.save();
        ctx.translate(square.x + square.size / 2, square.y + square.size / 2);
        ctx.rotate(square.angle);
        ctx.translate(-(square.x + square.size / 2), -(square.y + square.size / 2));
        ctx.fillRect(square.x, square.y, square.size, square.size);
        ctx.restore();
        context$1$0.next = 12;
        return;

      case 12:
        context$1$0.next = 1;
        break;

      case 14:
      case "end":
        return context$1$0.stop();
    }
  }, marked0$0[0], this);
}

jQuery(function ($) {
  var canv = $("#field");
  var ctx = canv[0].getContext("2d");

  var sqAnims = [SquareAnim(ctx, 30, 50, 50, 2 * Math.PI / 600, "#ff0000"), SquareAnim(ctx, 120, 50, 50, -(2 * Math.PI) / 1200, "#0000ff")];
  var loop = function loop() {
    ctx.clearRect(0, 0, canv[0].width, canv[0].height);
    sqAnims.forEach(function (e, i) {
      e.next();
    });
    requestAnimationFrame(loop);
  };
  loop();
});

// ジェネレータ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function gen() {
  return regeneratorRuntime.wrap(function gen$(context$1$0) {
    while (1) switch (context$1$0.prev = context$1$0.next) {
      case 0:
        context$1$0.next = 2;
        return 1;

      case 2:
        context$1$0.next = 4;
        return 1;

      case 4:
        context$1$0.next = 6;
        return 4;

      case 6:
        context$1$0.next = 8;
        return 5;

      case 8:
        context$1$0.next = 10;
        return 1;

      case 10:
        context$1$0.next = 12;
        return 4;

      case 12:
      case "end":
        return context$1$0.stop();
    }
  }, marked0$0[1], this);
}

var output = "";
var _iteratorNormalCompletion = true;
var _didIteratorError = false;
var _iteratorError = undefined;

try {
  for (var _iterator = gen()[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
    var v = _step.value;

    output += v;
  }
  //console.log(output); // "114514"

  // https://1000ch.net/posts/2013/es6-features-1.html
} catch (err) {
  _didIteratorError = true;
  _iteratorError = err;
} finally {
  try {
    if (!_iteratorNormalCompletion && _iterator["return"]) {
      _iterator["return"]();
    }
  } finally {
    if (_didIteratorError) {
      throw _iteratorError;
    }
  }
}

var fib = regeneratorRuntime.mark(function fib() {
  var prev, curr;
  return regeneratorRuntime.wrap(function fib$(context$1$0) {
    while (1) switch (context$1$0.prev = context$1$0.next) {
      case 0:
        prev = 0;
        curr = 1;

      case 2:
        if (!true) {
          context$1$0.next = 9;
          break;
        }

        prev = curr;
        curr = prev + curr;
        context$1$0.next = 7;
        return curr;

      case 7:
        context$1$0.next = 2;
        break;

      case 9:
      case "end":
        return context$1$0.stop();
    }
  }, fib, this);
});
var seq = fib();
//console.log(seq.next()); // {value: 1, done: false}
//console.log(seq.next()); // {value: 2, done: false}
//console.log(seq.next()); // {value: 3, done: false}
//console.log(seq.next()); // {value: 5, done: false}
//console.log(seq.next()); // {value: 8, done: false}

var _iteratorNormalCompletion2 = true;
var _didIteratorError2 = false;
var _iteratorError2 = undefined;

try {
  for (var _iterator2 = fib()[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
    var seq2 = _step2.value;

    if (seq2 > 1000) {
      break;
    }
    //console.info(seq2);
  }
} catch (err) {
  _didIteratorError2 = true;
  _iteratorError2 = err;
} finally {
  try {
    if (!_iteratorNormalCompletion2 && _iterator2["return"]) {
      _iterator2["return"]();
    }
  } finally {
    if (_didIteratorError2) {
      throw _iteratorError2;
    }
  }
}

var array = [1, 10, 100, 1000, 10000];
var data = {
  a: 10,
  b: 20,
  c: 30
};
var entries = regeneratorRuntime.mark(function entries(obj) {
  var keys, i, len;
  return regeneratorRuntime.wrap(function entries$(context$1$0) {
    while (1) switch (context$1$0.prev = context$1$0.next) {
      case 0:
        keys = Object.keys(obj);
        i = 0, len = keys.length;

      case 2:
        if (!(i < len)) {
          context$1$0.next = 8;
          break;
        }

        context$1$0.next = 5;
        return [obj[keys[i]], keys[i]];

      case 5:
        i++;
        context$1$0.next = 2;
        break;

      case 8:
      case "end":
        return context$1$0.stop();
    }
  }, entries, this);
});
var _iteratorNormalCompletion3 = true;
var _didIteratorError3 = false;
var _iteratorError3 = undefined;

try {
  for (var _iterator3 = entries(data)[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
    var item = _step3.value;
    // obj
    console.info("OBJ,KEY", item);
  }
} catch (err) {
  _didIteratorError3 = true;
  _iteratorError3 = err;
} finally {
  try {
    if (!_iteratorNormalCompletion3 && _iterator3["return"]) {
      _iterator3["return"]();
    }
  } finally {
    if (_didIteratorError3) {
      throw _iteratorError3;
    }
  }
}

_.each(data, function (v, k, l) {
  return console.info(v, k);
});

function swTest2() {
  var _iteratorNormalCompletion4 = true;
  var _didIteratorError4 = false;
  var _iteratorError4 = undefined;

  try {
    for (var _iterator4 = array[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
      var item = _step4.value;
      //array
      console.info(item);
    }
  } catch (err) {
    _didIteratorError4 = true;
    _iteratorError4 = err;
  } finally {
    try {
      if (!_iteratorNormalCompletion4 && _iterator4["return"]) {
        _iterator4["return"]();
      }
    } finally {
      if (_didIteratorError4) {
        throw _iteratorError4;
      }
    }
  }
}
//swTest2();

// class

var Foo = (function () {
  function Foo(bazz) {
    _classCallCheck(this, Foo);

    this.bazz = bazz;
  }

  _createClass(Foo, [{
    key: "getBazz",
    value: function getBazz() {
      return this.bazz;
    }
  }], [{
    key: "hello",
    value: function hello() {
      var word = arguments.length <= 0 || arguments[0] === undefined ? "hello" : arguments[0];

      return word;
    }
  }]);

  return Foo;
})();

var foo = new Foo("getBazz");
//console.debug(foo.getBazz());
//console.debug(Foo.hello("nakakazChan"));

//# sourceMappingURL=_ES6-compiled.js.map