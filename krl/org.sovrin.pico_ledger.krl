ruleset org.sovrin.pico_ledger {
  meta {
    shares __testing, read_ledger
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }, {"name": "read_ledger", "args": ["key"]}
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ { "domain": "ledger", "type": "write_ledger", "attrs": [ "key", "value" ] }
      ]
    }
    
    read_ledger = function(key) {
      ledger = ent:ledger;
      vals = ledger.filter(function(x) {
        x.keys()[0] == key;
      });
      vals[vals.length()-1].values()[0];
    }
    
  }
  
  rule write_ledger {
    select when ledger write_ledger
    
    pre {
      key = event:attr("key")
      value = event:attr("value")
    }
    
    if key && value then noop()
    
    fired {
     ent:ledger := ent:ledger.defaultsTo([]).append({}.put(key, value))
    }
  }
}
