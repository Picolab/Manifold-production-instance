ruleset io.picolabs.tag_registry {
  meta {
    name "Tag Registry" //tag meaning QR codes
    description <<
      This registry ruleset allows developers to register QR codes in a globally available location; this allows anyone who scans that tag to
      reach this pico and be redirected to a SPA (Single Page Application). This SPA is custom set when a tag is first registered and may be
      updated at any time. The SPA will handle all interesting things. This registry pico is therefore just a router from initial scan to the
      determined SPA.
    >>
    author "BYU Pico Labs"

    shares __testing, isTagRegistered, buildSpaRedirectURL, tagRegistry//tagRegistry is used for testing only... remove from production
  }
  global {
    __testing = { "queries":
      [
        { "name": "__testing" },
        { "name": "tagRegistry" },
        { "name": "buildSpaRedirectURL", "args": [ "tagID", "devDomain" ] },
        { "name": "isTagRegistered", "args": [ "tagID", "devDomain" ] }
      ] , "events":
      [
       { "domain": "registry", "type": "tag_scanned", "attrs": [ "devDomain", "tagID" ] },
       { "domain": "registry", "type": "new_tag", "attrs": [ "devDomain", "tagID", "DID", "appName", "engineLoc", "passcode" ] },
       { "domain": "registry", "type": "unneeded_tag", "attrs": [ "devDomain", "tagID" ] },
       { "domain": "redirect", "type": "test", "attrs": [  ] }
      ]
    }
    
    DID_Policy = {
        "name": "Only allow registry new_tag, tag_scanned, and unneeded_tag events",
        "event": {
            "allow": [
                { "domain": "registry", "type": "new_tag"},
                { "domain": "registry", "type": "tag_scanned"},
                { "domain": "registry", "type": "unneeded_tag"}
            ]
        }
    }

    /* REGISTRY_STRUCTURE ent:tagRegistry
    This map stores all data that a Single Page Application (SPA) like Manifold would need in order to query the tag's associated pico. When a QR code (tag)
    is scanned, this registry is consulted; its spaHost and spaPort are then used as the redirect location with the other information provided as url parameters
    {
      devDomain: {
        tagID: {
          tagID: <tagID::string>, ex. ABC123
          DID: <pico's DID::string>,
          engineLoc: <optional host and port of engine::string>, ex. https://manifold.picolabs.io:9090
          devDomain: <developer's domain name::string>, ex. "picolabs" useful for avoiding tagID conflicts between developers who both produce large amounts of tagID's,
          appName: <dev's user friendly app name::string>, ex. "safeandmine"
          passcode: <unique string which is needed to unregister a tag::string>//it will be stored on the pico in which the tag is registered
        }
        ...
      }
      ...
    }
    */

    isTagRegistered = function(tagID, devDomain) {
      ent:tagRegistry.defaultsTo({}){[devDomain, tagID]} => true | false
    }

    tagRegistry = function() {
      ent:tagRegistry.defaultsTo({})
    }
    
    tagInfo = function(tagID, devDomain) {
      ent:tagRegistry.defaultsTo({}){[devDomain, tagID]}.delete(["passcode"])
    }
    
    hasValidPasscode = function(tagID, devDomain, passcode) {
      ent:tagRegistry.defaultsTo({}){[devDomain, tagID, "passcode"]} == passcode => true | false
    }

  }//end global
  
  rule createPolicyDID {
    select when wrangler ruleset_added where rids >< meta:rid
    every{
      engine:newPolicy(DID_Policy) setting(registered_policy)
      engine:newChannel(name="tag_registry", type="register", policy_id = registered_policy{"id"})
    }
  }

  rule handleScan {
    select when registry tag_scanned
    pre {
      devDomain = event:attr("devDomain") || false
      tagID = event:attr("tagID") || false


      //see if it is in the registry or not?
      isRegistered = isTagRegistered(tagID, devDomain)

      validScan = (devDomain && tagID)
    }
    if validScan && isRegistered then
      send_directive("Returning tagInfo", tagInfo(tagID, devDomain))
    fired {
      raise registry event "valid_scan"
        attributes event:attrs
    }else {
      raise registry event "invalid_scan"
        attributes event:attrs if (not validScan);

      raise registry event "unregistered_scan"
        attributes event:attrs if (validScan && not isRegistered) //perhaps do something interesting here, like redirect to a default place with an error message?
    }
  }

  rule invalidScan {
    select when registry invalid_scan
    send_directive("Failed to scan tag because of missing attributes")
  }

  rule unregisteredScan {
    select when registry unregistered_scan
    send_directive("This tag has not yet been registered. Please visit your favorite SPA and register the tag")
  }

  rule addTag {
    select when registry new_tag
    pre {
      tagID = event:attr("tagID")
      devDomain = event:attr("devDomain")
      DID = event:attr("DID")
      engineLoc = event:attr("engineLoc") => event:attr("engineLoc") | "https://manifold.picolabs.io:9090"
      appName = event:attr("appName")
      passcode = event:attr("passcode")

      validTag = (tagID && devDomain && passcode && DID && appName) => true | false
      isRegistered = isTagRegistered(tagID, devDomain)
    }
    if validTag && not isRegistered then
      send_directive(<<Adding tag #{tagID} to registry under domain #{devDomain}>>, { "DID": DID, "tagID": tagID, "passcode": passcode})
    fired {
      //update tagRegistry
      ent:tagRegistry{[devDomain, tagID]} := {
        "tagID": tagID,
        "devDomain": devDomain,
        "DID": DID,
        "engineLoc": engineLoc,
        "appName": appName,
        "passcode": passcode
      }
    }else {
      raise registry event "new_tag_failure"
        attributes event:attrs if (not validTag);

      raise registry event "tag_already_taken"
        attributes event:attrs if (validTag).klog("valid tag: ") && isRegistered
    }
  }

  rule newTagFailed {
    select when registry new_tag_failure
    send_directive("Failed to create tag because of missing attributes")
  }

  rule tagTaken {
    select when registry tag_already_taken
    send_directive("Failed to create tag because this one is already registered")
  }

  rule removeTag {
    select when registry unneeded_tag
    pre {
      tagID = event:attr("tagID")
      devDomain = event:attr("devDomain")
      passcode = event:attr("passcode")
      isRegistered = isTagRegistered(tagID, devDomain)

      hasValidAttrs = (tagID && devDomain && passcode)
      
      //authenticate request
      hasValidPasscode = hasValidPasscode(tagID, devDomain, passcode)
      
    }
    if isRegistered && hasValidAttrs && hasValidPasscode then
      send_directive(<<Removing tag #{tagID} under domain #{devDomain}>>)
    fired {
      clear ent:tagRegistry{[devDomain, tagID]}
    }else {
      raise registry event "invalid_removal"
        attributes event:attrs if (not hasValidAttrs);

      raise registry event "removal_tag_not_found"
        attributes event:attrs if (hasValidAttrs && not isRegistered);
        
      raise registry event "incorrect_passcode"
        attributes event:attrs if (isRegistered && hasValidAttrs && not hasValidPasscode)
    }
  }
}
