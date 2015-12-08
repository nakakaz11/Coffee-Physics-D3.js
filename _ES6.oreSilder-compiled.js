/* sw ES6 151202 */
"use strict";

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

(function ($, win, doc) {
  var $win = $(win),
      $doc = $(doc),
      swns = {};

  var FRAME_RATE = 567,
      STOP_RATE = 8765,
      EASING = 'easeOutExpo';

  var CarouselAssyL = (function () {
    function CarouselAssyL(list, speed, _flag) {
      _classCallCheck(this, CarouselAssyL);

      this.thumbsWrapL = $(list);
      this.thumbs = $(list).find("li");
      this.first_thumb = "li:first";
      this.last_thumb = "li:last";
      this.item_width = $(this.thumbs).outerWidth();
      swns.item_width = this.item_width;
      this.item_height = $(this.thumbs).outerHeight();
      this.left_value = this.item_width * -2;
      $(this.thumbsWrapL).css("width", this.thumbs.length * this.item_width);
      $(this.thumbsWrapL).find(this.first_thumb).before($(this.thumbsWrapL).find(this.last_thumb));
      $(this.thumbsWrapL).css({
        left: this.left_value
      });
      this.count = 0;
      this._initialPager();
    }

    // CarouselAssyL }

    _createClass(CarouselAssyL, [{
      key: "rotateLeft",
      value: function rotateLeft(_flag) {
        var self = this;
        var sabun = Math.abs(self.item_width + parseInt($(self.thumbsWrapL).css("left")));
        var speed = !_flag ? self.speed : sabun * (FRAME_RATE / 100);
        return $(self.thumbsWrapL).animate({
          left: self.item_width * -1
        }, speed, EASING, function () {
          var ref = undefined;
          $(self.thumbsWrapL).find(self.first_thumb).before($(self.thumbsWrapL).find(self.last_thumb));
          $(self.thumbsWrapL).css({
            left: self.item_width * -2
          });
          if (Math.abs(self.count) === 0) {
            self.count = self.thumbs.length - 1;
          } else if (0 < (ref = Math.abs(self.count)) && ref <= self.thumbs.length - 1) {
            self.count -= 1;
          }
          return self._pagerAssy();
        });
      }
    }, {
      key: "rotateRight",
      value: function rotateRight(_flag) {
        var self = this;
        var sabun = Math.abs(self.item_width * 3 + parseInt($(self.thumbsWrapL).css("left")));
        var speed = !_flag ? self.speed : sabun * (FRAME_RATE / 100);
        return $(self.thumbsWrapL).animate({
          left: self.item_width * -3
        }, speed, EASING, function () {
          $(self.thumbsWrapL).find(self.last_thumb).after($(self.thumbsWrapL).find(self.first_thumb));
          $(self.thumbsWrapL).css({
            left: self.item_width * -2
          });
          if (Math.abs(self.count) === self.thumbs.length - 1) {
            self.count = 0;
          } else {
            self.count += 1;
          }
          return self._pagerAssy();
        });
      }
    }, {
      key: "_initialPager",
      value: function _initialPager() {
        var self = this;
        self.pager = $("#CarouselArea").find(".pagerMaker");
        self.pagerList = $(self.pager).find(".sliderThumbs");
        return $(self.pagerList).eq(0).addClass("active");
      }
    }, {
      key: "_pagerAssy",
      value: function _pagerAssy() {
        var self = this;
        return $(self.pagerList).each(function (i, val) {
          var j = self.count - 1;
          $(self.pagerList).eq(j).addClass("active");
          $(self.pagerList).eq(j).siblings().removeClass("active");
        });
      }
    }, {
      key: "clickSnippet",
      value: function clickSnippet() {
        var self = this;
        var j = self.count;
        var href = $(self.thumbs).eq(j).find("a").attr("href");
        var target = $(self.thumbs).eq(j).find("a").attr("target");
      }
    }]);

    return CarouselAssyL;
  })();

  var timerID = void 0;

  // do it DRF
  $(function () {
    var carousel1 = new CarouselAssyL("ul#cycleList1", FRAME_RATE);
    var $sliderUL = $("ul#cycleList1");

    var initLoopFunc = function initLoopFunc(flag) {
      carousel1.rotateRight(flag);
    };
    var startTimeout = function startTimeout() {
      initLoopFunc(false);
      return timerID = setTimeout(startTimeout, STOP_RATE);
    };
    var stopTimeout = function stopTimeout() {
      return clearTimeout(timerID);
    };
    var initial = function initial() {
      $("div#h_resume a").hide();
      return $sliderUL.animate({
        opacity: 1
      }, FRAME_RATE, EASING);
    };
    var fncFireTouchMove = function fncFireTouchMove(e, bool) {
      e.preventDefault();
      if (!bool) {
        if (!$sliderUL.is(":animated")) {
          return $sliderUL.css("left", function (i, val) {
            val = swns.diffX - swns.item_width * 2;
          });
        }
      }
    };
    var fncFireNext = function fncFireNext(e, bool) {
      e.preventDefault();
      if (!bool) {
        if (!$sliderUL.is(":animated")) {
          carousel1.rotateLeft();
          return false;
        }
      }
    };
    var fncFirePrev = function fncFirePrev(e, bool) {
      e.preventDefault();
      if (!bool) {
        if (!$sliderUL.is(":animated")) {
          carousel1.rotateRight();
          return false;
        }
      }
    };
    $("div#h_rotate-left").on("click", function (e) {
      fncFireNext(e);
      return false;
    });
    $("div#h_rotate-right").on("click", function (e) {
      fncFirePrev(e);
      return false;
    });
    var toggleStopFunc = function toggleStopFunc(_flag) {
      if (_flag) {
        $("div#h_resume a").show();
      } else {
        $("div#h_resume a").hide();
      }
    };
    $("div#pause a").on("click", function (e) {
      toggleStopFunc(true);
      stopTimeout();
      $("ul.cycleList").stop(true, true);
      return false;
    });
    $("div#h_resume a").on("click", function (e) {
      $("#ovLay").children("li").remove();
      initLoopFunc(true);
      startTimeout();
      toggleStopFunc(false);
      return false;
    });
    var thumbsClickFuncTest = function thumbsClickFuncTest(_elem) {
      var myClone = undefined;
      myClone = $(_elem).clone();
      $("#ovLay").append(myClone);
    };
    var getTouchHandler = function getTouchHandler(bool) {
      var clkDefs = undefined,
          diffX = undefined,
          sTime = undefined,
          startX = undefined,
          timeBrank = undefined,
          touchDefs = undefined;
      sTime = 0;
      startX = 0;
      diffX = 0;
      touchDefs = 111;
      timeBrank = 123;
      clkDefs = 55;
      return function (e) {
        var t = undefined,
            touch = undefined;
        touch = e.originalEvent.touches[0];
        if (e.type === "touchstart") {
          startX = touch.pageX;
          sTime = new Date().getTime();
        } else if (e.type === "touchmove") {
          e.preventDefault();
          diffX = touch.pageX - startX;
          swns.diffX = diffX;
          fncFireTouchMove(e, bool);
        } else if (e.type === "touchend") {
          t = new Date().getTime() - sTime;
          if (0 <= diffX && diffX < touchDefs || t < timeBrank) {} else if (diffX > touchDefs || t < timeBrank && diffX > clkDefs) {
            fncFireNext(e, bool);
          } else if (diffX < -touchDefs || t < timeBrank && diffX < -clkDefs) {
            fncFirePrev(e, bool);
          } else {
            return null;
          }
        }
      };
    };
    var SMPevt = function SMPevt() {
      var touchHandler1 = getTouchHandler();
      $sliderUL.on("touchstart.box touchmove.box touchend.box", touchHandler1);
    };
    var PCevt = function PCevt() {
      /*
      arrow function内のthisは、関数が定義されたコンテキストのthisにバインドされるようです。
      これは var self = this; みたいなことをやっていたベストプラクティスが不要になるので
      基本的には歓迎なのですが、今回のようなケースでは困ることになります。
      てっとり早いのはarrow functionをやめることです。
      */
      var $thumbsList = $sliderUL.find("li"); //$("ul#cycleList1 li");
      /*$thumbsList.each((i, ele)=> {
        //console.info($(ele).attr("class"));
       let getAttr = $(ele).attr("class");
       $(ele).hover(()=>{
          console.info("$each:mouseenter-> " + getAttr);
        }, ()=>{
          console.info("$each:mouseleave<- " + getAttr);
        })
      });*/
      // todo for

      var _loop = function (i, l) {
        //console.info($($thumbsList[i]));
        var getAttr = $($thumbsList[i]).attr("class");
        getAttr = getAttr + (" index:" + i);
        $($thumbsList[i]).hover(function () {
          console.info("for:mouseenter " + getAttr);
        }, function () {
          console.info("for:mouseleave " + getAttr);
        });
      };

      for (var i = 0, l = $thumbsList.length; i < l; i++) {
        _loop(i, l);
      }
      console.info($thumbsList);

      /*for (let ele of $thumbsList) {
        console.info(ele);
      }*/
    }; // PCevt }

    if (doc.ontouchstart !== void 0 || doc.createTouch !== void 0) {
      SMPevt();
    } else {
      PCevt();
    }

    return initial();
  }); // DRF }
})(jQuery, window, document);
// EOF

//# sourceMappingURL=_ES6.oreSilder-compiled.js.map