ruleset io.picolabs.dummydata {
  meta {
    shares __testing, getData
  }
  
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "getData" }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    
    getData = function() {
      {
        "c1": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "c2": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "c3": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "c4": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "c5": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "c6": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "c7": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t1": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t2": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t3": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t4": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t5": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t6": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t7": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t8": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t9": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t10": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t11": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "t12": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "l1": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "l2": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "l3": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "l4": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "l5": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "s1": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "s2": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "s3": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "s4": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},
        "s5": { "min": random:integer(upper = 4, lower = 0), "max": random:integer(upper = 10, lower = 6)},

      }
    }
  }
  
}
