ruleset engine {
  meta {
    shares __testing, getPicoIDByECI, listAllEnabledRIDs
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "getPicoIDByECI", "args": [ "eci" ] }
      , { "name": "listAllEnabledRIDs" }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    getPicoIDByECI = function(eci){
      engine:getPicoIDByECI(eci)
    }
    listAllEnabledRIDs = function(){
      engine:listAllEnabledRIDs()
    }
  }
}
