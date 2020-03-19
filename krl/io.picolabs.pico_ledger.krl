ruleset io.picolabs.pico_ledger {
  meta {
    use module io.picolabs.wrangler alias wrangler
    shares __testing, read_ledger
    provides read_ledger
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "read_ledger", "args": ["did"] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    read_ledger = function(did) {
      endpoint = <<https://manifold.picolabs.io:9090/sky/cloud/HPhprBdwHXKzNcXeBwNH29/org.sovrin.pico_ledger/read_ledger?key=#{did}>>;
      http:get(endpoint){"content"}.decode()
    }
  }

  rule update_ledger {
   select when system online
   foreach wrangler:channel(null,"type","connection") setting(channel)
   pre {
     ledger_eci = "HPhprBdwHXKzNcXeBwNH29";
     domain = "ledger";
     type = "write_ledger";
     eid = "agent_to_ledger";
     host = "https://manifold.picolabs.io:9090";
     attrs = { "key": channel{["sovrin","did"]}, "value": meta:host }
   }

   event:send({"eci": ledger_eci, "eid": eid, "domain": domain, "type": type, "attrs": attrs}, host)
 }
}
