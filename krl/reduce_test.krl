ruleset reduce_test {
  meta {
    shares __testing, entry
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    entry = function(key){
      multiply = function(a,x){a*x};
      {
        "meta:host": meta:host,
        "empty array": [].reduce(multiply,key),
        "1, 2, 3": [1,2,3].reduce(multiply,key),
//        "pm": their_rk.reduce(
//        function(a,rk){
//          fm = a_msg:routeFwdMap(a[1],a.head()).klog("forward message");
//          [indy:pack(fm.encode(),[rk],meta:eci).klog("forward message packed"),rk]
//        },
//        [indy:pack(rm.encode(),publicKeys,meta:eci).klog("inner message packed"),their_vk]
//      ).head()
      }
    }
  }
}
