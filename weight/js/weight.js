/* sw ES6 151203 */
"use strict";
(()=> {

  let brushed = ()=> {
    x.domain((brush.empty() ? x2.domain() : brush.extent()));
    focus.select("path").attr("d", area);
    focus.select(".x.axis").call(xAxis);
  };
  let margin = {
    top   : 10,
    right : 10,
    bottom: 100,
    left  : 40
  };
  let margin2 = {
    top   : 430,
    right : 10,
    bottom: 20,
    left  : 40
  };
  let width = 960 - margin.left - margin.right;
  let height = 500 - margin.top - margin.bottom;
  let height2 = 500 - margin2.top - margin2.bottom;
  let parseDate = d3.time.format("%Y-%m-%d").parse;
  let x = d3.time.scale().range([0, width]);
  let x2 = d3.time.scale().range([0, width]);
  let y = d3.scale.linear().range([height, 0]);
  let y2 = d3.scale.linear().range([height2, 0]);
  let xAxis = d3.svg.axis().scale(x).orient("bottom");
  let xAxis2 = d3.svg.axis().scale(x2).orient("bottom");
  let yAxis = d3.svg.axis().scale(y).tickSize(width).orient("right");
  let brush = d3.svg.brush().x(x2).on("brush", brushed);

  let area = d3.svg.area().interpolate("step-after")
    .x((d)=> { return x(d.date); }).y0(height).y1((d)=> { return y(d.price); });
  let area2 = d3.svg.area().interpolate("monotone")
    .x((d)=> { return x2(d.date); }).y0(height2).y1((d)=> { return y2(d.price); });

  let svg = d3.select("#svg3").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom);

  svg.append("defs").append("clipPath").attr("id", "clipVia").append("rect").attr("width", width).attr("height", height);
  let focus = svg.append("g").attr("transform", `translate(${margin.left},${margin.top})`);
  let context = svg.append("g").attr("class", "swCont").attr("transform", `translate(${margin2.left},${margin2.top})`);

  d3.csv("/_jsFiddle_/swES6/json/weight.csv", (error, data)=> {
    let bisectDate, formatCurrency, formatValue, mousemove, tip;

    data.forEach((d) =>{
      d.date = parseDate(d.date);
      return d.price = +d.price;
    });
    x.domain(d3.extent(data.map((d) =>{
      return d.date;
    })));
    y.domain([
      d3.min(data.map((d) =>{
        return d.price;
      })) - 5
      , d3.max(data.map((d) =>{
        return d.price;
      })) + 5
    ]);
    x2.domain(x.domain());
    y2.domain(y.domain());

    focus.append("path").datum(data).attr("clipVia-path", "url(#clipVia)").attr("d", area);
    focus.append("g").attr("class", "x axis").attr("transform", `translate(0, ${height})`).call(xAxis);
    focus.append("g").attr("class", "y axis").call(yAxis);
    focus.selectAll("g").filter((d) =>{ return d; }).classed("minor", true);
    focus.selectAll("text").attr("x", 4).attr("dy", 4);

    tip = svg.append("g").attr("class", "tip").style("display", "none");
    tip.append("circle").attr("r", 4.5);
    tip.append("text").attr("x", -10 - margin.left).attr("dy", ".35em");
    bisectDate = d3.bisector((d) =>{
      return d.date;
    }).left;

    //formatValue = d3.format(",.2f");
    //formatCurrency = (d) =>{ return "cal." + formatValue(d); };
    
    mousemove = function () {
      var d, d0, d1, i, x0;
      x0 = x.invert(d3.mouse(this)[0]);
      i = bisectDate(data, x0, 1);
      d0 = data[i - 1];
      d1 = (data[i]) ? data[i] : 0;
      d = (x0 - d0.date > d1.date - x0) ? d1 : d0;
      tip.attr("transform", `translate(${x(d.date) + margin.left}, ${y(d.price) + margin.top})`);
      tip.select("text").text(d.price);
    };


    svg.append("rect").attr("class", "overlay")
      .attr("width", width).attr("height", height)
      .attr("transform", `translate(${margin.left},${margin.top})`)
      .on("mouseover", function () {
        tip.style("display", null);
      }).on("mouseout", function () {
        tip.style("display", "none");
      }).on("mousemove", mousemove);

    context.append("path").datum(data).attr("d", area2);
    context.append("g").attr("class", "x axis").attr("transform", `translate(0,${height2 })`)
      .call(xAxis2);
    context.append("g").attr("class", "x brush")
      .call(brush).selectAll("rect").attr("y", -6).attr("height", height2 + 7);
  });


})();
