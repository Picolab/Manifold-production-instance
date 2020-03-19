ruleset agent_inspector {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ { "domain": "sovrin", "type": "connections_response", "attrs": [ "message" ] }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
  }
  rule look_into_connections_response {
    select when sovrin connections_response
    pre {
      msg = event:attr("message")
        .decode() // for use with Testing tab
      unused = msg{["connection~sig","sig_data"]}
        .math:base64decode()
        .extract(re#........(.+)#).head().decode()
        .klog("sig_data")
    }
  }
}
