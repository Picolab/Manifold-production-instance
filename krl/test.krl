ruleset test {
  meta {
    shares __testing, wassup
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "wassup", "args": [ "idx","val" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    foo = [1,2,3,4]
    foo[2] = 7
    update = function(idx,val){
      urk = foo;
      urk[idx] = val;
      urk
    }
    wassup = function(idx,val){
      idx && val => update(idx,val)
      |
      foo
    }
  }
}
