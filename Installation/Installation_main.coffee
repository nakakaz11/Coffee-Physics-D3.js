end = null  # end marker likely ruby
require.config
  baseUrl : "./"
  paths   :           # dir
    jquery            : "//cdnjs.cloudflare.com/ajax/libs/jquery/1.8.3/jquery.min"
    d3                : "//cdnjs.cloudflare.com/ajax/libs/d3/3.3.11/d3.min"
    Stats             : "//cdnjs.cloudflare.com/ajax/libs/stats.js/r11/Stats"
    dat               : "//cdnjs.cloudflare.com/ajax/libs/dat-gui/0.5/dat.gui.min"
    # Core
    colorbrewer       : "//samuraiworks.org/_demos/swCoffeePhysics/js/lib/colorbrewerSW/colorbrewer"
    _Engine           : "//samuraiworks.org/_demos/swCoffeePhysics/Installation/_CombineEngine"

  # 依存関係
  shim:
    jquery:
      exports: "$"
    d3:
      exports: "d3"

  # js dependencies
  _Engine:
    deps   : [
      "d3"
      ]
  init:
    deps   : [
      "jquery"
      "Stats"
      "dat"
      ]


define [
    # Assy
    "jquery"
    "colorbrewer"
    "Stats"
    "dat"
    "d3"
    "_Engine"
  ], ($, _, d3) ->

    class SWDemo extends Demo
      # { swns拡張
      _swns = {}
      constructor : (globalSwobj,_config) ->
        super
        _swns.opt = globalSwobj
        _swns.config = _config
      # swns拡張 }
      setup: (full = yes) ->

        super

        @physics.integrator = new ImprovedEuler()
        attraction = new Attraction @mouse.pos, (_swns.config._aRadius || 1000), (_swns.config._aStrength || 100.0)

        # Add gravity to the simulation.
        @gravity = new ConstantForce new Vector (_swns.config._forceX || 0.0),
          (_swns.config._forceY || 0.0)

        @physics.behaviours.push @gravity

        @.stiffness = (_swns.config._stiffness || 0.99)
        # 剛性(1 > n)

        # wander : さまよう
        wander = new Wander (_swns.config._wJitter || 0.2),
                            (_swns.config._wRadius || 1111),
                            (_swns.config._wStrength || 3)

        max = _swns.config._particleLEN || if full then 111 else 77

        for i in [0..max]

          p = new Particle (Random 0.25, 4.0)   # (@mass = 1.0)
          p.setRadius p.mass * (_swns.config._radius || 2)

          switch true
            when _swns.config._flag2
              p.behaviours.push wander
              p.behaviours.push attraction
            else # false
              null
          #p.behaviours.push wander
          #p.behaviours.push attraction

          #p.behaviours.push edge    # push 衝突する壁

          p.moveTo new Vector (Random @width), (Random @height)

          s = new Spring @mouse, p, Random (_swns.config._sprRandMin || 290),
            (_swns.config._sprRandMax || 300),
            @.stiffness
            #(@p1, @p2, @restLength = 100, @stiffness = 1.0)

          @physics.particles.push p

          switch true
            when _swns.config._flag1
              @physics.springs.push s
            else # false
              null

      init : ()->
        super

    (-> # do it inits
    #(($, win, doc) ->
    #  $win = $(win)
    #  $doc = $(doc)
      # ---------------------- sw initial add dat.gui
      config =
        "COLOR_Val"       : "CB-Greys"
        "ConsoleAndBool"  : true
        "_flag1"          : true
        "_flag2"          : true
        "_gradient"       : false  #false
        "_shape"          : true
        "粘度(viscosity)"  : 0.836
        "剛性(stiffness)"  : 0.065  #0.001
        "mouseMass"       : 99
        "mouseMassInv"    : 0.001
        "forceX"          : 0
        "forceY"          : 0
        "integratorVal"   : "integratorNone"
        "radius"          : 1
        "attractRadius"   : 1000
        "attractStrength" : 100.0
        "wanderJitter"    : 0.00001
        "wanderRadius"    : 0.0001
        "wanderStrength"  : 0.00003
        "springRandMin"   : 33
        "springRandMax"   : 333
        "particleLEN"     : 222

        "integratorNone"  : new Verlet  # init integrator

        "vB_hasDelaunay"  : false
        "vB_hasVoronoi"   : true

      integrators =
        "integratorNone"  : new Integrator
        "Euler"           : new Euler
        "ImprovedEuler"   : new ImprovedEuler
        "Verlet"          : new Verlet

      initIros =
        "COLOURS0":  ['DC0048', 'F14646', '4AE6A9', '7CFF3F', '4EC9D9', 'E4272E']
        "COLOUR_SW1":['6CB1DC', 'EFF13E', '4AE6A9', '7CFF3F', 'F46AC0', 'E4A043']
        "COLOUR_SW2":['ffffff', 'e7e7e7', 'cdcdcd', 'C9C1AF', 'DAFFEF', 'C9DAFF']
        "COLOUR_SW3":['30928c', '357c9f', '4ec4ae', '31946f', '4a9ac2', '71becf']
        "CB-YlGn"    : colorbrewer.YlGn[9]
        "CB-YlGnBu"  : colorbrewer.YlGnBu[9]
        "CB-GnBu"    : colorbrewer.GnBu[9]
        "CB-BuGn"    : colorbrewer.BuGn[9]
        "CB-PuBuGn"  : colorbrewer.PuBuGn[9]
        "CB-PuBu"    : colorbrewer.PuBu[9]
        "CB-BuPu"    : colorbrewer.BuPu[9]
        "CB-RdPu"    : colorbrewer.RdPu[9]
        "CB-PuRd"    : colorbrewer.PuRd[9]
        "CB-OrRd"    : colorbrewer.OrRd[9]
        "CB-YlOrRd"  : colorbrewer.YlOrRd[9]
        "CB-YlOrBr"  : colorbrewer.YlOrBr[9]
        "CB-Purples" : colorbrewer.Purples[9]
        "CB-Blues"   : colorbrewer.Blues[9]
        "CB-Greens"  : colorbrewer.Greens[9]
        "CB-Oranges" : colorbrewer.Oranges[9]
        "CB-Reds"    : colorbrewer.Reds[9]
        "CB-Greys"   : colorbrewer.Greys[9]
        "CB-PuOr"    : colorbrewer.PuOr[11]
        "CB-BrBG"    : colorbrewer.BrBG[11]
        "CB-PRGn"    : colorbrewer.PRGn[11]
        "CB-PiYG"    : colorbrewer.PiYG[11]
        "CB-RdBu"    : colorbrewer.RdBu[11]
        "CB-RdGy"    : colorbrewer.RdGy[11]
        "CB-RdYlBu"  : colorbrewer.RdYlBu[11]
        "CB-Spectral": colorbrewer.Spectral[11]
        "CB-RdYlGn"  : colorbrewer.RdYlGn[11]
        "CB-Accent"  : colorbrewer.Accent[8]
        "CB-Dark2"   : colorbrewer.Dark2[8]
        "CB-Paired"  : colorbrewer.Paired[12]
        "CB-Pastel1" : colorbrewer.Pastel1[9]
        "CB-Pastel2" : colorbrewer.Pastel2[8]
        "CB-Set1"    : colorbrewer.Set1[9]
        "CB-Set2"    : colorbrewer.Set2[8]
        "CB-Set3"    : colorbrewer.Set3[12]

      #col = colorbrewer.Set3[11]

      #make D3 svg renderer
      d3ns = {}
      _config = {
        v3D : null
      }        # _内部継承
      _config = config    # _内部継承
      # Available demos.
      # Initialises the testbed and starts the default demo.
      DEMOS = {
        "Installation_sw(chain)"     : SWDemo
      }

      list = undefined
      demo = undefined
      stats = undefined
      items = undefined
      playing = undefined
      demoName = undefined
      renderer = undefined
      container = undefined
      $renderer = undefined


      # Generates a click handler.
      generateClick = (name) ->
        ->
          setDemo name
          false

      # Updates current demo.
      update = ()->

        requestAnimationFrame update

        demo.step()  if playing and demo

        stats.update()

      #resizeWhenEnd (one Time) for SMP
      resizeForSMPOnce = (demoName)->
        rtime = new Date(1999, 11, 31, 23, 59, 59)
        timeout = false
        delta = 200
        resizeend = ->
          if new Date() - rtime < delta
            setTimeout resizeend, delta
          else
            timeout = false
            #alert "Done resizing"
            #console?.info "self__demoName:", self.__demoName,
            #  "_config.demoName:", _config.demoName,
            #  "config.initialDEMO:", config.initialDEMO   #-- sw Log --(´･_･`)
            setDemo "Installation_sw(chain)"
        $(window).on "resize", (e)->
          rtime = new Date()
          if timeout is false
            timeout = true
            setTimeout resizeend, delta

      # Sets the current demo.
      setDemo = (name) ->
        demoName = name
        _config.demoName = demoName
        # Kill any running demo.
        if demo
          demo.destroy()
          demo = null

        # todo Initialise new demo.
        demo = new DEMOS[name]("swAugtest", _config)  # _そとへ継承
        demo.init container[0], new self[renderer]("swAugtest", _config, d3ns)
        # d3用に、第三引数拡張

        # Activate / deactivate links.
        for id of items
          if id is name then items[id].addClass "active"
          else items[id].removeClass "active"

        # Provide access from console for debugging.
        self.__demo = demo

      onKeyDown = (event) ->
        if event.which is 32 || event.which is 80 #space || p
          event.preventDefault()
          playing = not playing
          demo.physics._clock = new Date().getTime()  if playing and demo


      init = ->
        items = {}
        stats = new Stats()
        list = $("#demo-select")
        playing = true
        renderer = "d3SVGRenderer"    #WebGLRenderer CanvasRenderer d3SVGRenderer DOMRenderer
        container = $("#container")
        $renderer = $("#renderer-select a")
        item = undefined

        ###for name of DEMOS
          item = $("<a href=\"#\"/>").on("click", generateClick(name) )
          .data("demo", name).text(name)
          items[name] = item
          list.append item###


        # Append stats.
        stats.domElement.className = "stats"
        document.body.appendChild stats.domElement

        $(window).bind "keydown", onKeyDown

        # Set default demo and start updating.
        setDemo "Installation_sw(chain)"
        _config.demoName = "Installation_sw(chain)"
        update()

        _config.demo = demo

      # ---------------------- sw add dat.gui
      #config = {}

      gui = new dat.GUI()
      gControl = gui.addFolder("GlobalControl")
      gControl.open()
      pControl = gui.addFolder("ParticleControl")
      sControl = gui.addFolder("SubControl")


      changer11 = gControl.add(config, "COLOR_Val", Object.keys(initIros) )
      changer11.onChange (val) ->
        _config._COLOURS = initIros[val]
        setDemo(demoName)

      changer2 = gControl.add(config, "粘度(viscosity)", 0 , 1.00)
      changer2.onChange (value) ->
        _config._viscosity = value
        demo.physics.viscosity = _config["_viscosity"]

      changer4 = gControl.add(config, "forceX", -1000 , 1000)
      changer4.onChange (value) ->
        _config._forceX = value
        demo.gravity.force.x = _config["forceX"] # +()


      changer5 = gControl.add(config, "forceY", -1000 , 1000)
      changer5.onChange (value) ->
        _config._forceY = value
        demo.gravity.force.y = _config["forceY"]

      ###changer7 = gControl.add(config, "integratorVal", Object.keys(integrators) )
      changer7.onChange (val) ->
        _config.integrator = integrators[val]
        demo.physics.integrator = _config.integrator###

      changer8 = pControl.add(config, "radius", 1 , 95)
      changer8.onChange (value) ->
        _config._radius = value
        setDemo(demoName)

      changer3 = pControl.add(config, "剛性(stiffness)", 0.000 , 1.000)
      changer3.onChange (value) ->
        _config._stiffness = value
        demo.stiffness = value
        setDemo(demoName)

      changer9 = pControl.add(config, "attractRadius", -3333 , 3333)
      changer9.onChange (value) ->
        _config._aRadius = value
        setDemo(demoName)

      changer10 = pControl.add(config, "attractStrength", -3333 , 3333)
      changer10.onChange (value) ->
        _config._aStrength = value
        setDemo(demoName)

      changer12 = pControl.add(config, "wanderJitter", 0.000 , 1.000)
      changer12.onChange (value) ->
        _config._wJitter = value
        setDemo(demoName)

      changer13 = pControl.add(config, "wanderRadius", 0.0001 , 333)
      changer13.onChange (value) ->
        _config._wRadius = value
        setDemo(demoName)

      changer14 = pControl.add(config, "wanderStrength", 0.0000 , 10.0000)
      changer14.onChange (value) ->
        _config._wStrength = value
        setDemo(demoName)

      changer15 = sControl.add(config, "springRandMin", 0.01 , 555)
      changer15.onChange (value) ->
        _config._sprRandMin = value
        setDemo(demoName)

      changer16 = sControl.add(config, "springRandMax", 0.01 , 555)
      changer16.onChange (value) ->
        _config._sprRandMax = value
        setDemo(demoName)

      changer17 = sControl.add(config, "particleLEN", 3 , 333)
      changer17.onChange (value) ->
        _config._particleLEN = value
        #update()
        setDemo(demoName)

      # bool 1
      changer1 = sControl.add(config, "ConsoleAndBool").listen()   #boolian
      changer1.onChange (value) ->
        #config.ConsoleAndLine = value
        _config._flag1 = value
        setDemo(demoName)
        console?.info "demo:", demo       #------- sw Log --(´･_･`)

      # bool 2
      changer18 = sControl.add(config, "_flag2").listen()          #boolian
      changer18.onChange (value) ->
        #config._flag2 = value
        _config._flag2 = value
        setDemo(demoName)



      # ---------------------- sw add dat.gui

      # sw do it!
      init()
      resizeForSMPOnce()


    )()   # }
