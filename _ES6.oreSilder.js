/* sw ES6 151202 */
"use strict";
(($, win, doc)=> {
  let $win = $(win),
      $doc = $(doc),
      swns = {};

  const FRAME_RATE = 567,
        STOP_RATE  = 8765,
        EASING     = 'easeOutExpo';

  class CarouselAssyL {
    constructor(list, speed, _flag) {
      this.thumbsWrapL = $(list);
      this.thumbs = $(list).find("li");
      this.first_thumb = "li:first";
      this.last_thumb = "li:last";
      this.item_width = $(this.thumbs).outerWidth();
      swns.item_width = this.item_width;
      this.item_height = $(this.thumbs).outerHeight();
      this.left_value = this.item_width * (-2);
      $(this.thumbsWrapL).css("width", this.thumbs.length * this.item_width);
      $(this.thumbsWrapL).find(this.first_thumb).before($(this.thumbsWrapL).find(this.last_thumb));
      $(this.thumbsWrapL).css({
        left: this.left_value
      });
      this.count = 0;
      this._initialPager();
    }
    rotateLeft(_flag) {
      let self = this;
      let sabun = Math.abs(self.item_width + parseInt($(self.thumbsWrapL).css("left")));
      let speed = !_flag ? self.speed : sabun * (FRAME_RATE / 100);
      return $(self.thumbsWrapL).animate({
        left: self.item_width * (-1)
      }, speed, EASING, ()=> {
        let ref;
        $(self.thumbsWrapL).find(self.first_thumb).before($(self.thumbsWrapL).find(self.last_thumb));
        $(self.thumbsWrapL).css({
          left: self.item_width * (-2)
        });
        if (Math.abs(self.count) === 0) {
          self.count = self.thumbs.length - 1;
        } else if ((0 < (ref = Math.abs(self.count)) && ref <= self.thumbs.length - 1)) {
          self.count -= 1;
        }
        return self._pagerAssy();
      });
    }
    rotateRight(_flag) {
      let self = this;
      let sabun = Math.abs((self.item_width * 3) + parseInt($(self.thumbsWrapL).css("left")));
      let speed = !_flag ? self.speed : sabun * (FRAME_RATE / 100);
      return $(self.thumbsWrapL).animate({
        left: self.item_width * (-3)
      }, speed, EASING, ()=> {
        $(self.thumbsWrapL).find(self.last_thumb).after($(self.thumbsWrapL).find(self.first_thumb));
        $(self.thumbsWrapL).css({
          left: self.item_width * (-2)
        });
        if (Math.abs(self.count) === self.thumbs.length - 1) {
          self.count = 0;
        } else {
          self.count += 1;
        }
        return self._pagerAssy();
      });
    }
    _initialPager() {
      let self = this;
      self.pager = $("#CarouselArea").find(".pagerMaker");
      self.pagerList = $(self.pager).find(".sliderThumbs");
      return $(self.pagerList).eq(0).addClass("active");
    }
    _pagerAssy() {
      let self = this;
      return $(self.pagerList).each((i, val)=> {
        let j = self.count - 1;
        $(self.pagerList).eq(j).addClass("active");
        $(self.pagerList).eq(j).siblings().removeClass("active");
      });
    }
    clickSnippet() {
      let self = this;
      let j = self.count;
      let href = $(self.thumbs).eq(j).find("a").attr("href");
      let target = $(self.thumbs).eq(j).find("a").attr("target");
    }
  } // CarouselAssyL }

  let timerID = void 0;

  // do it DRF
  $(()=> {
    let carousel1 = new CarouselAssyL("ul#cycleList1", FRAME_RATE);
    let $sliderUL = $("ul#cycleList1");

    let initLoopFunc = (flag)=> {
      carousel1.rotateRight(flag);
    };
    let startTimeout = ()=> {
      initLoopFunc(false);
      return timerID = setTimeout(startTimeout, STOP_RATE);
    };
    let stopTimeout = ()=> {
      return clearTimeout(timerID);
    };
    let initial = ()=> {
      $("div#h_resume a").hide();
      return $sliderUL.animate({
        opacity: 1
      }, FRAME_RATE, EASING);
    };
    let fncFireTouchMove = (e, bool)=> {
      e.preventDefault();
      if (!bool) {
        if (!$sliderUL.is(":animated")) {
          return $sliderUL.css("left", function(i, val) {
            val = swns.diffX - swns.item_width * 2;
          });
        }
      }
    };
    let fncFireNext = (e, bool)=> {
      e.preventDefault();
      if (!bool) {
        if (!$sliderUL.is(":animated")) {
          carousel1.rotateLeft();
          return false;
        }
      }
    };
    let fncFirePrev = (e, bool)=> {
      e.preventDefault();
      if (!bool) {
        if (!$sliderUL.is(":animated")) {
          carousel1.rotateRight();
          return false;
        }
      }
    };
    $("div#h_rotate-left").on("click", (e)=> {
      fncFireNext(e);
      return false;
    });
    $("div#h_rotate-right").on("click", (e)=> {
      fncFirePrev(e);
      return false;
    });
    let toggleStopFunc = (_flag)=> {
      if (_flag) {
        $("div#h_resume a").show();
      } else {
        $("div#h_resume a").hide();
      }
    };
    $("div#pause a").on("click", (e)=> {
      toggleStopFunc(true);
      stopTimeout();
      $("ul.cycleList").stop(true, true);
      return false;
    });
    $("div#h_resume a").on("click", (e)=> {
      $("#ovLay").children("li").remove();
      initLoopFunc(true);
      startTimeout();
      toggleStopFunc(false);
      return false;
    });
    let thumbsClickFuncTest = (_elem)=> {
      let myClone;
      myClone = $(_elem).clone();
      $("#ovLay").append(myClone);
    };
    let getTouchHandler = (bool)=> {
      let clkDefs, diffX, sTime, startX, timeBrank, touchDefs;
      sTime = 0;
      startX = 0;
      diffX = 0;
      touchDefs = 111;
      timeBrank = 123;
      clkDefs = 55;
      return (e)=> {
        let t, touch;
        touch = e.originalEvent.touches[0];
        if (e.type === "touchstart") {
          startX = touch.pageX;
          sTime = (new Date()).getTime();
        } else if (e.type === "touchmove") {
          e.preventDefault();
          diffX = touch.pageX - startX;
          swns.diffX = diffX;
          fncFireTouchMove(e, bool);
        } else if (e.type === "touchend") {
          t = (new Date()).getTime() - sTime;
          if ((0 <= diffX && diffX < touchDefs) || t < timeBrank) {
          } else if ((diffX > touchDefs) || (t < timeBrank && diffX > clkDefs)) {
            fncFireNext(e, bool);
          } else if ((diffX < -touchDefs) || (t < timeBrank && diffX < -clkDefs)) {
            fncFirePrev(e, bool);
          } else {
            return null
          }
        }
      };
    };
    let SMPevt = ()=> {
      let touchHandler1 = getTouchHandler();
      $sliderUL.on("touchstart.box touchmove.box touchend.box", touchHandler1);
    };
    let PCevt = ()=> {
      /*
      arrow function内のthisは、関数が定義されたコンテキストのthisにバインドされるようです。
      これは var self = this; みたいなことをやっていたベストプラクティスが不要になるので
      基本的には歓迎なのですが、今回のようなケースでは困ることになります。
      てっとり早いのはarrow functionをやめることです。
      */
      let $thumbsList = $sliderUL.find("li"); //$("ul#cycleList1 li");
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
      for (let i = 0, l = $thumbsList.length; i < l; i++) {
        //console.info($($thumbsList[i]));
        let getAttr = $($thumbsList[i]).attr("class");
        getAttr = getAttr + ` index:${i}`;
        $($thumbsList[i]).hover(()=>{
          console.info(`for:mouseenter ${getAttr}`);
        }, ()=>{
          console.info(`for:mouseleave ${getAttr}`);
        })
      }
      console.info($thumbsList);

      /*for (let ele of $thumbsList) {
        console.info(ele);
      }*/

    }; // PCevt }

    if ((doc.ontouchstart !== void 0) || (doc.createTouch !== void 0)) {
      SMPevt();
    } else {
      PCevt();
    }

    return initial();

  }); // DRF }


})(jQuery, window, document);
// EOF