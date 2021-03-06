module.exports =
  config:
    enableTypeChecking:
      type: 'boolean'
      default: true
    interceptJumpToDeclarationCallsFor:
      type: 'array',
      default: ['C++','PHP']
      items:
        type: 'string'
    typeCheckerCommand:
      type: 'string'
      default: 'hh_client'
  Subscriptions:[]
  TypeCheckerDecorations:[]
  V:{}
  Status:{}
  activate:->
    @V.MP = require('atom-message-panel')
    @V.H = require('./h')(this)
    @V.TE = require('./typechecker-error')(this);
    @V.TTV = require('./tooltip-view')(this);

    require('./cmenu')(this).initialize();
    @V.MPI = new @V.MP.MessagePanelView title: "Hack TypeChecker"

    @Status.TypeChecker = false
    setTimeout =>
      @V.H.readConfig().then =>
        @V.TC = require('./typechecker')(this);
        atom.config.observe 'Atom-Hack.enableTypeChecking',(status)=>
          if status
            @V.TC.activate()
          else
            @V.TC.deactivate()
    ,1000
  deactivate:->
    @V.TC.deactivate();
    @Subscriptions.forEach (sub)-> sub.dispose()
    @Subscriptions = []