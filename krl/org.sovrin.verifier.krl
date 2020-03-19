ruleset org.sovrin.verifier {
  meta {
    use module org.sovrin.agent alias agent
    shares __testing, nameForUUID
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "nameForUUID", "args": [ "uuid" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    hasUUID = function(msgs,uuid){
      msgs.any(function(m){m{"content"}==uuid})
    }
    nameForUUID = function(uuid){
      connections = agent:ui(){"connections"};
      name = connections.isnull()
        => null
         | connections
             .filter(function(c){c{"messages"}.hasUUID(uuid)})
             .head(){"label"}
         ;
      name => name | ""
    }
  }
}
