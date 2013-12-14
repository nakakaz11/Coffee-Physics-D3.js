end = null  # end marker likely ruby
### Random ###
Random = (min, max) ->
  if not max?
      max = min
      min = 0
  min + Math.random() * (max - min)
Random.int = (min, max) ->
  if not max?
      max = min
      min = 0
  Math.floor min + Math.random() * (max - min)
Random.sign = (prob = 0.5) ->
  if do Math.random < prob then 1 else -1
Random.bool = (prob = 0.5) ->
  do Math.random < prob
Random.item = (list) ->
  list[ Math.floor Math.random() * list.length ]

### 2D Vector ###
class Vector
  ### 二つのベクトルを返しproductを追加. ###
  @add: (v1, v2) ->
    new Vector v1.x + v2.x, v1.y + v2.y
  ### v1からv2の減算と積を返します. ###
  @sub: (v1, v2) ->
    new Vector v1.x - v2.x, v1.y - v2.y
  ### 別の（V2）に投影つのベクトル（V1）を ###
  @project: (v1, v2) ->
    v1.clone().scale ((v1.dot v2) / v1.magSq())
  ### 新しいVectorインスタンスを作成します. ###
  constructor: (@x = 0.0, @y = 0.0) ->
  ### このベクトルの成分を設定します. ###
  set: (@x, @y) ->
    @
  ### このいずれかにベクトルを追加. ###
  add: (v) ->
    @x += v.x; @y += v.y; @
  ### このいずれかからベクトルを減算. ###
  sub: (v) ->
    @x -= v.x; @y -= v.y; @
  ### 値によってスケールこのベクトルを. ###
  scale: (f) ->
    @x *= f; @y *= f; @
  ### ベクトル間の内積を計算します. ###
  dot: (v) ->
    @x * v.x + @y * v.y
  ### ベクトル間の外積を計算します. ###
  cross: (v) ->
    (@x * v.y) - (@y * v.x)
  ### 大きさを計算します (length). ###
  mag: ->
    Math.sqrt @x*@x + @y*@y
  ### 乗の大きさを計算します (length). ###
  magSq: ->
    @x*@x + @y*@y
  ### 別のベクトルまでの距離を計算. ###
  dist: (v) ->
    dx = v.x - @x; dy = v.y - @y
    Math.sqrt dx*dx + dy*dy
  ### 別のベクトルに乗距離を計算. ###
  distSq: (v) ->
    dx = v.x - @x; dy = v.y - @y
    dx*dx + dy*dy
  ### それ単位ベクトル作り、ベクトルを正常化 (of length 1). ###
  norm: ->
    m = Math.sqrt @x*@x + @y*@y
    @x /= m
    @y /= m
    @
  ### 与えられた量をベクトルの長さを制限します. ###
  limit: (l) ->
    mSq = @x*@x + @y*@y
    if mSq > l*l
      m = Math.sqrt mSq
      @x /= m; @y /= m
      @x *= l; @y *= l
      @
  ### 別のベクトルから複製コンポーネント. ###
  copy: (v) ->
    @x = v.x; @y = v.y; @
  ### 新しい同じものにクローンがこのベクトル. ###
  clone: ->
    new Vector @x, @y
  ### Resets the vector to zero. ###
  clear: ->
    @x = 0.0; @y = 0.0; @

### Integrator ###
class Integrator
    integrate: (particles, dt) ->
        # Override...
### Euler Integrator ###
class Euler extends Integrator
    # v += a * dt
    # x += v * dt
    integrate: (particles, dt, drag) ->
        vel = new Vector()
        for p in particles when not p.fixed
            # Store previous location.
            p.old.pos.copy p.pos
            # Scale force to mass.
            p.acc.scale p.massInv
            # Duplicate velocity to preserve momentum.
            vel.copy p.vel
            # Add force to velocity.
            p.vel.add p.acc.scale dt
            # Add velocity to position.
            p.pos.add vel.scale dt
            # Apply friction.
            if drag then p.vel.scale drag
            # Reset forces.
            p.acc.clear()

### Improved Euler Integrator ###
class ImprovedEuler extends Integrator
    # x += (v * dt) + (a * 0.5 * dt * dt)
    # v += a * dt
    integrate: (particles, dt, drag) ->
        acc = new Vector()
        vel = new Vector()
        dtSq = dt * dt
        for p in particles when not p.fixed
            # Store previous location.
            p.old.pos.copy p.pos
            # Scale force to mass.
            p.acc.scale p.massInv
            # Duplicate velocity to preserve momentum.
            vel.copy p.vel
            # Duplicate force.
            acc.copy p.acc
            # Update position.
            p.pos.add (vel.scale dt).add (acc.scale 0.5 * dtSq)
            # Update velocity.
            p.vel.add p.acc.scale dt
            # Apply friction.
            if drag then p.vel.scale drag
            # Reset forces.
            p.acc.clear()
### Velocity Verlet Integrator ###
class Verlet extends Integrator
    # v = x - ox
    # x = x + (v + a * dt * dt)
    integrate: (particles, dt, drag) ->
        pos = new Vector()
        dtSq = dt * dt
        for p in particles when not p.fixed
            # Scale force to mass.
            p.acc.scale p.massInv
            # Derive velocity.
            (p.vel.copy p.pos).sub p.old.pos
            # Apply friction.
            if drag then p.vel.scale drag
            # Apply forces to new position.
            (pos.copy p.pos).add (p.vel.add p.acc.scale dtSq)
            # Store old position.
            p.old.pos.copy p.pos
            # update position.
            p.pos.copy pos
            # Reset forces.
            p.acc.clear()





### Particle ###
class Particle
  @GUID = 0
  constructor: (@mass = 1.0) ->
    # Set a unique id.
    @id = 'p' + Particle.GUID++
    # Set initial mass.質量
    @setMass @mass
    # Set initial radius.
    @setRadius 1.0
    # Apply forces.
    @fixed = false
    # Behaviours to be applied.
    @behaviours = []
    # Current position.
    @pos = new Vector()
    # Current velocity.
    @vel = new Vector()
    # Current force.
    @acc = new Vector()
    # Previous state.
    @old =
      pos: new Vector()
      vel: new Vector()
      acc: new Vector()
  ### Moves the particle to a given location vector. ###
  moveTo: (pos) ->
    @pos.copy pos
    @old.pos.copy pos
  ### Sets the mass of the particle. ###
  setMass: (@mass = 1.0) ->
    # The inverse mass.
    @massInv = 1.0 / @mass
  ### Sets the radius of the particle. ###
  setRadius: (@radius = 1.0) ->
    @radiusSq = @radius * @radius
  ### Applies all behaviours to derive new force. ###
  update: (dt, index) ->
    # Apply all behaviours.
    if not @fixed
      for behaviour in @behaviours
        behaviour.apply @, dt, index

### Physics Engine ###
class Physics
  # { swns拡張
  _swns = {}
  constructor: (@integrator = new Euler(),_config) ->
    _swns.config = _config
    # swns拡張 }
    # 固定タイムステップ.
    @timestep = 1.0 / 60
    # システム内の摩擦.
    @viscosity = _swns.config._viscosity || 0.87
    # Global behaviours.
    @behaviours = []
    # Time in seconds.
    @_time = 0.0
    # Last step duration.
    @_step = 0.0
    # Current time.
    @_clock = null
    # Time buffer.
    @_buffer = 0.0
    # Max iterations per step.
    @_maxSteps = 4
    # Particles in system.
    @particles = []
    # Springs in system.
    @springs = []
  ### 数値積分ステップを実行します. ###
  integrate: (dt) ->
    # Drag is 粘度に反比例.
    drag = 1.0 - @viscosity
    # Update particles / apply behaviours.
    for particle, index in @particles
      for behaviour in @behaviours
        behaviour.apply particle, dt, index
      particle.update dt, index
    # 統合する motion.
    @integrator.integrate @particles, dt, drag
    # Compute all springs.
    for spring in @springs
      spring.apply()
  ### Steps the system. ###
  step: ->
    # 最初のステップのクロックを初期化する.
    @_clock ?= new Date().getTime()
    # 最後のステップ以降デルタ時間を計算.
    time = new Date().getTime()
    delta = time - @_clock
    # 十分な変化なし.
    return if delta <= 0.0
    # Convert time to seconds.
    delta *= 0.001
    # Update the clock.
    @_clock = time
    # Increment time buffer.
    @_buffer += delta
    # バッファが空になるまで、又は、ステップごとの反復の最大量に達するまで積分.
    i = 0
    while @_buffer >= @timestep and ++i < @_maxSteps
      # 固定タイムステップでの動きを統合Integrateする.
      @integrate @timestep
      # Reduce buffer by one timestep.
      @_buffer -= @timestep
      # Increment running time.
      @_time += @timestep
    # Store step time for debugging.
    @_step = new Date().getTime() - time
  ### Clean up after yourself. ###
  destroy: ->
    @integrator = null
    @particles = null
    @springs = null

### Spring ###
class Spring
  constructor: (@p1, @p2, @restLength = 100, @stiffness = 1.0) ->
    @_delta = new Vector()
  # F = -kx
  apply: ->
    (@_delta.copy @p2.pos).sub @p1.pos
    dist = @_delta.mag() + 0.000001
    force = (dist - @restLength) / (dist * (@p1.massInv + @p2.massInv)) * @stiffness
    if not @p1.fixed
      @p1.pos.add (@_delta.clone().scale force * @p1.massInv)
    if not @p2.fixed
      @p2.pos.add (@_delta.scale -force * @p2.massInv)
### Behaviour ###
class Behaviour
  # 各動作は、一意のIDを持っている
  @GUID = 0
  constructor: ->
    @GUID = Behaviour.GUID++
    @interval = 1
    ## console.log @, @GUID
  apply: (p, dt, index) ->
    # Store some data in each particle.
    (p['__behaviour' + @GUID] ?= {counter: 0}).counter++
### Attraction Behaviour ###
class Attraction extends Behaviour
    constructor: (@target = new Vector(), @radius = 1000, @strength = 100.0) ->
        @_delta = new Vector()
        @setRadius @radius
        super
    ### bahaviousの有効半径を設定. ###
    setRadius: (radius) ->
        @radius = radius
        @radiusSq = radius * radius
    apply: (p, dt, index) ->
        #super p, dt, index
        # particleからターゲットを指すVector.
        (@_delta.copy @target).sub p.pos
        # Squared distance to target.
        distSq = @_delta.magSq()
        # 行動半径に力を制限する.
        if distSq < @radiusSq and distSq > 0.000001
            # Calculate force vector.
            @_delta.norm().scale (1.0 - distSq / @radiusSq)
            #Apply force.
            p.acc.add @_delta.scale @strength
### Collision Behaviour ###
# TODO: Collision response for non Verlet integrators.
class Collision extends Behaviour
    constructor: (@useMass = yes, @callback = null) ->
        # Pool 衝突可能 粒子のプール.
        @pool = []
        # 粒子の位置との間のデルタ.
        @_delta = new Vector()
        super
    apply: (p, dt, index) ->
        #super p, dt, index
        # Check pool for collisions.
        for o in @pool[index..] when o isnt p
            # Delta between particles positions.
            (@_delta.copy o.pos).sub p.pos
            # 粒子間の二乗距離.
            distSq = @_delta.magSq()
            # Sum of both radii.
            radii = p.radius + o.radius
            # Check if particles collide.
            if distSq <= radii * radii
                # Compute real distance.
                dist = Math.sqrt distSq
                # Determine overlap.
                overlap = (p.radius + o.radius) - dist
                overlap += 0.5
                # Total mass.
                mt = p.mass + o.mass
                # 配る collision responses.
                r1 = if @useMass then o.mass / mt else 0.5
                r2 = if @useMass then p.mass / mt else 0.5
                # 彼らはもはや重複しないように、粒子を移動させる.
                p.pos.add (@_delta.clone().norm().scale overlap * -r1)
                o.pos.add (@_delta.norm().scale overlap * r2)
                # Fire callback if defined.
                @callback?(p, o, overlap)
### Constant Force Behaviour ###
class ConstantForce extends Behaviour
  constructor: (@force = new Vector()) ->
    super
  apply: (p, dt,index) ->
    #super p, dt, index
    p.acc.add @force
### Edge Bounce Behaviour ###
class EdgeBounce extends Behaviour
  constructor: (@min = new Vector(), @max = new Vector()) ->
    super
  apply: (p, dt, index) ->
    #super p, dt, index
    if p.pos.x - p.radius < @min.x
      p.pos.x = @min.x + p.radius
    else if p.pos.x + p.radius > @max.x
      p.pos.x = @max.x - p.radius
    if p.pos.y - p.radius < @min.y
      p.pos.y = @min.y + p.radius
    else if p.pos.y + p.radius > @max.y
      p.pos.y = @max.y - p.radius
### Edge Wrap Behaviour ###
class EdgeWrap extends Behaviour
  constructor: (@min = new Vector(), @max = new Vector()) ->
    super
  apply: (p, dt, index) ->
    #super p, dt, index
    if p.pos.x + p.radius < @min.x
      p.pos.x = @max.x + p.radius
      p.old.pos.x = p.pos.x
    else if p.pos.x - p.radius > @max.x
      p.pos.x = @min.x - p.radius
      p.old.pos.x = p.pos.x
    if p.pos.y + p.radius < @min.y
      p.pos.y = @max.y + p.radius
      p.old.pos.y = p.pos.y
    else if p.pos.y - p.radius > @max.y
      p.pos.y = @min.y - p.radius
      p.old.pos.y = p.pos.y
### Wander Behaviour ###
class Wander extends Behaviour
  constructor: (@jitter = 0.5, @radius = 100, @strength = 1.0) ->
    @theta = Math.random() * Math.PI * 2
    super
  apply: (p, dt, index) ->
    #super p, dt, index
    @theta += (Math.random() - 0.5) * @jitter * Math.PI * 2
    p.acc.x += Math.cos(@theta) * @radius * @strength
    p.acc.y += Math.sin(@theta) * @radius * @strength




### Allows safe, dyamic creation of namespaces. ###

namespace = (id) ->
  root = self
  root = root[path] ?= {} for path in id.split '.'

### RequestAnimationFrame shim. ###
do ->

    time = 0
    vendors = ['ms', 'moz', 'webkit', 'o']

    for vendor in vendors when not window.requestAnimationFrame
        window.requestAnimationFrame = window[ vendor + 'RequestAnimationFrame']
        window.cancelRequestAnimationFrame = window[ vendor + 'CancelRequestAnimationFrame']

    if not window.requestAnimationFrame

        window.requestAnimationFrame = (callback, element) ->
            now = new Date().getTime()
            delta = Math.max 0, 16 - (now - old)
            setTimeout (-> callback(time + delta)), delta
            old = now + delta

    if not window.cancelAnimationFrame

        window.cancelAnimationFrame = (id) ->
            clearTimeout id



### Demo ###
class Demo
  # sw @COLOURSはdatのためinitから操作（gl , 初期値だけ残す）
  #@COLOURS0 = ['DC0048', 'F14646', '4AE6A9', '7CFF3F', '4EC9D9', 'E4272E']
  #@COLOURS1 = ['6CB1DC', 'EFF13E', '4AE6A9', '7CFF3F', 'F46AC0', 'E4A043']
  #@COLOURS2 = ['ffffff', 'e7e7e7', 'cdcdcd', 'C9C1AF', 'DAFFEF', 'C9DAFF']
  #@COLOURSinit = ['6CB1DC', 'EFF13E', '4AE6A9', '7CFF3F', 'F46AC0', 'E4A043']
  #@COLOURSinit = ['30928c', '357c9f', '4ec4ae', '31946f', '4a9ac2', '71becf']
  @COLOURSinit = ["f0f0f0","d9d9d9","bdbdbd","969696","737373","525252","252525","000000"]
  # { swns拡張
  _swns = {}
  constructor : (globalSwobj,_config) ->
    _swns.opt = globalSwobj
    _swns.config = _config
  # swns拡張 }

    @physics = new Physics( null, _config)

    @mouse = new Particle()
    @mouse.fixed = true
    @height = window.innerHeight
    @width = window.innerWidth

    @renderTime = 0
    @counter = 0
  setup: (full = yes) ->
    ### Override and add paticles / springs here ###
  ### Initialise the demo (override). ###
  init: (@container, @renderer = new WebGLRenderer()) ->
    # Build the scene.
    @setup renderer.gl?
    # Give the particles random colours.
    # sw @COLOURSはdatのためinitから操作
    #if renderer.gl?       #------- sw bool gl?
    for particle in @physics.particles
       particle.colour ?= Random.item(_swns.config._COLOURS || Demo.COLOURSinit)
    # Add event handlers.
    document.addEventListener 'touchmove', @mousemove, false
    document.addEventListener 'mousemove', @mousemove, false
    document.addEventListener 'resize', @resize, false
    # Add to render output to the DOM.
    @container.appendChild @renderer.domElement
    # Prepare the renderer.
    @renderer.mouse = @mouse
    @renderer.init @physics
    # Resize for the sake of the renderer.
    do @resize
  ### Handler for window resize event. ###
  resize: (event) =>
    @width = window.innerWidth
    @height = window.innerHeight
    @renderer.setSize @width, @height
  ### Update loop. ###
  step: ->
    #console.profile 'physics'
    # Step physics.
    do @physics.step
    #console.profileEnd()
    #console.profile 'render'
    # Render.
    # Render every frame for WebGL, or every 3 frames for canvas.
    @renderer.render @physics if @renderer.gl? or ++@counter % 3 is 0
    #console.profileEnd()
  ### Clean up after yourself. ###
  destroy: ->
    ## console.log @, 'destroy'
    # Remove event handlers.
    document.removeEventListener 'touchmove', @mousemove, false
    document.removeEventListener 'mousemove', @mousemove, false
    document.removeEventListener 'resize', @resize, false
    # Remove the render output from the DOM.
    try container.removeChild @renderer.domElement
    catch error
    do @renderer.destroy
    do @physics.destroy
    @renderer = null
    @physics = null
    @mouse = null
  ### Handler for window mousemove event. ###
  mousemove: (event) =>
    do event.preventDefault
    if event.touches and !!event.touches.length
      touch = event.touches[0]
      @mouse.pos.set touch.pageX, touch.pageY
    else
      @mouse.pos.set event.clientX, event.clientY



### Base Renderer ###
class Renderer
    constructor: ->
        @width = 0
        @height = 0
        @renderParticles = true
        @renderSprings = true
        @renderMouse = true
        @initialized = false
        @renderTime = 0

    init: (physics) -> @initialized = true
    render: (physics) -> if not @initialized then @init physics
    setSize: (@width, @height) =>
    destroy: ->


### sw do it d3 SVG Renderer ###
class d3SVGRenderer extends Renderer
    # { swns拡張
    _swns = {}
    _d3ns = {}
    constructor : (globalSwobj,_config, d3ns) ->
      super
      # Set the DOM element.(fake)
      @domElement = document.createElement 'div'
      _swns.opt = globalSwobj
      _swns.config = _config
      _d3ns = d3ns
      # swns拡張 }

      @width =  window.innerWidth
      @height = window.innerHeight


      _d3ns.svg = d3.select("#container").append("svg")
                  .attr("width",  window.innerWidth)
                  .attr("height", window.innerHeight)

    init: (physics) ->
      super physics

      _d3ns.voronoiVertices = []
      _d3ns.vPath = _d3ns.svg.selectAll(".vPath")
      _d3ns.vLink = _d3ns.svg.selectAll(".vLink")
      _d3ns.edge = (a, b) ->
        source: a
        target: b

      # todo DragEvent
      _d3ns.dragstarted = (d) ->
        d3.event.sourceEvent.stopPropagation()
        d3.select(this).classed "dragging", true
        #physics.particles[d.idx].pos.x = d.gx
        #physics.particles[d.idx].pos.y = d.gy

      _d3ns.dragged = (d) ->
        g = d3.select(this)
        physics.particles[d.idx].pos.x += d3.event.dx
        physics.particles[d.idx].pos.y += d3.event.dy
        ### d3.event
        もしあれば、現在のイベントを格納します。このグローバルは、上の演算子を使用して登録されたイベントリスナのコールバック中です。
        リスナーはfinallyブロックで通知された後に、現在のイベントはリセットされます。これは、リスナー関数は、
        現在の測地系Dおよびインデックスiを渡されて、他の演算子関数と同じ形式を持つことができます。###

        d.x = physics.particles[d.idx].pos.x
        d.y = physics.particles[d.idx].pos.y

        g.attr "transform", (d) -> "translate(#{d.x},#{d.y})"

      _d3ns.dragended = (d) ->
        d3.select(this).classed "dragging", false

      _d3ns.drag = d3.behavior.drag()
        .origin((d) -> d )
        .on("dragstart", _d3ns.dragstarted)
        .on("drag", _d3ns.dragged)
        .on("dragend", _d3ns.dragended)


      # sw initial d3 Objects
      _d3ns.nodes = d3.range(physics.particles.length).map (d, i) ->
        radius     : (physics.particles[i].radius).toFixed(1)
        x          : physics.particles[i].pos.x
        y          : physics.particles[i].pos.y
        swColor    : '#' + (physics.particles[i].colour or 'FFFFFF')
        swText     : "　<-|´･_･`) #{i}"

      _d3ns.swPartiG = _d3ns.svg.selectAll(".swD3g")
      # sw make springs 131019
      #_d3ns.svg.append("line").attr("class", "swD3VectPath") for s in physics.springs
      _d3ns.vectPath = _d3ns.svg.selectAll(".swD3VectPath")


      _d3ns.swPartiG = _d3ns.swPartiG.data(_d3ns.nodes)
      _d3ns.swPartiG.enter().append("g").attr("class", "swD3g")
      _d3ns.swPartiG.append("circle").attr("class", "swD3c")
      _d3ns.swPartiCir = _d3ns.svg.selectAll(".swD3c")


    render: (physics) ->
      super physics

      # make G
      _d3ns.swPartiG.attr("transform", (d, i) ->
          "translate(#{physics.particles[i].pos.x},#{physics.particles[i].pos.y})")

        .on "click",(d, i)->  # add a {Data}
          physics.particles[i].fixed = true
          physics.particles[i].colour = "BCB11B"
          g = d3.select(this)
          g.append("text").attr("class", "swD3tText2")
            .text((d) -> _d3ns.nodes[i].swText )
            .style("font-size", (d, i)-> "#{ d.radius / 1 }px")
          g.attr "d", (d)->
            d.idx = i
            #d.gx  = physics.particles[i].pos.x
            #d.gy  = physics.particles[i].pos.y

          g.call(_d3ns.drag)

      # make Circle
      #_d3ns.swPartiCir.data(_d3ns.nodes).enter().append("circle").attr("class", "swD3c")
      _d3ns.swPartiCir
          .style("fill", (d, i)-> "##{physics.particles[i].colour}")
          .attr "r", (d, i)-> (physics.particles[i].radius).toFixed(1)


      # sw make springs 131019
      if @renderSprings
        #for s in physics.springs
        _d3ns.springsNodes = d3.range(physics.springs.length).map (d, i) ->
            x1 : physics.springs[i].p1.pos.x
            y1 : physics.springs[i].p1.pos.y
            x2 : physics.springs[i].p2.pos.x
            y2 : physics.springs[i].p2.pos.y

        _d3ns.vectPath = _d3ns.vectPath.data(_d3ns.springsNodes)
        _d3ns.vectPath.enter().append("line").attr("class", "swD3VectPath")
        _d3ns.vectPath
            .attr("x1", (d) -> d.x1 ) #physics.springs[i].p1.pos.x)
            .attr("y1", (d) -> d.y1 ) #physics.springs[i].p1.pos.y)
            .attr("x2", (d) -> d.x2 ) #physics.springs[i].p2.pos.x)
            .attr("y2", (d) -> d.y2 ) #physics.springs[i].p2.pos.y)
            .attr(
              "fill"          : "none"
              "stroke"        : "#C0D9FF"
              "stroke-opacity": "0.15"
              "stroke-width"  : "1px"
            )
        _d3ns.vectPath.exit().remove()   # view更新

      #if @renderMouse then null


      # ボロノイ
      _d3ns.moves = d3.range(physics.particles.length).map (d, i) ->
              x          : physics.particles[i].pos.x
              y          : physics.particles[i].pos.y
      _d3ns.voronoiVertices = _d3ns.moves.map((o) -> [o.x, o.y, o])

      switch true
        when _swns.config.vB_hasVoronoi
          # do it edgeを削ってみる。
          # http://bl.ocks.org/mbostock/4636377
          resample = (points) ->
            i = -1
            n = points.length
            p0 = points[n - 1]
            x0 = p0[0]
            y0 = p0[1]
            p1 = undefined
            x1 = undefined
            y1 = undefined
            points2 = []
            while ++i < n
              p1 = points[i]
              x1 = p1[0]
              y1 = p1[1]
              points2.push [(x0 * 2 + x1) / 3, (y0 * 2 + y1) / 3],
                [(x0 + x1 * 2) / 3, (y0 + y1 * 2) / 3], p1
              p0 = p1
              x0 = x1
              y0 = y1
            points2

          line = d3.svg.line().interpolate("basis-closed")
          voronoies = d3.geom.voronoi(_d3ns.voronoiVertices)
                        #.clipExtent([[10, 10], [@width - 10, @height - 10]])

          _d3ns.vPath = _d3ns.vPath
          .data(voronoies)

          _d3ns.vPath.enter().append("path")
            .attr("class", (d, i) -> "vPath vP#{i}")
            .attr("d", (d, i) ->
              "M" + d.join("L") + "Z"
              #line(resample(voronoies[i]))
              #line(voronoies[i])
            )
            .style(
              "fill"        : (d, i)-> "##{physics.particles[i].colour}"
              "fill-opacity": (d, i)-> .88   # fill足してみる
            )

          _d3ns.vPath
            .attr("d", (d, i) ->
              "M" + d.join("L") + "Z"
              #line(resample(voronoies[i]))
              #line(voronoies[i])

            )
          _d3ns.vPath.exit().remove()   # view更新

        else # false
          null
      end

      switch true
        when _swns.config.vB_hasDelaunay

          strokes = []
          _d3ns.vLinks = []
          d3.geom.delaunay(_d3ns.voronoiVertices)
            .forEach (d) ->
              _d3ns.vLinks.push _d3ns.edge(d[0], d[1])
              _d3ns.vLinks.push _d3ns.edge(d[1], d[2])
              _d3ns.vLinks.push _d3ns.edge(d[2], d[0])
          _d3ns.vLink = _d3ns.vLink.data(_d3ns.vLinks)
          _d3ns.vLink.enter().append("line")
            .attr("class", (d, i) -> "vLine vL#{i}")
            .style("stroke", (d, i)->
              strokes[i] = physics.particles[ ~~(Random(0, physics.particles.length)) ]?.colour
              return "##{strokes[i]}"
            )

          _d3ns.vLink.attr("x1", (d) -> d.source[2].x )
                     .attr("y1", (d) -> d.source[2].y )
                     .attr("x2", (d) -> d.target[2].x )
                     .attr("y2", (d) -> d.target[2].y )
          _d3ns.vLink.exit().remove()   # view更新

        else # false
          null
      end







    setSize: (@width, @height) =>
      super @width, @height
      _d3ns.svg.attr("width",  @width)
               .attr("height", @height)

    destroy: ->
      #while @domElement.hasChildNodes()
      #_d3ns.div.remove()
      $('#container svg').remove()
      #document.removeChild 'svg'

