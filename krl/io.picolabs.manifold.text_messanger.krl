ruleset io.picolabs.manifold.text_messanger {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ {"domain": "text_messanger", "type": "set_account_sid", "attrs":["sid"]}, 
        {"domain": "text_messanger", "type": "set_auth_token", "attrs":["token"]},
        {"domain": "text_messanger", "type": "set_twilio_number", "attrs":["number"]},
        {"domain": "text_messanger", "type": "notification", "attrs":["toPhone", "Body"]}
      //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    
  }
  
  rule setTwilioAccountSID {
    select when text_messanger set_account_sid
    pre {
      sid = event:attr("sid")
    }
    always {
      ent:twilioSID := sid
    }
  }
  
  rule setTwilioAuthToken {
    select when text_messanger set_auth_token
    pre {
      token = event:attr("token")
    }
    always {
      ent:twilioAuthToken := token
    }
  }
  
  rule setTwilioNumber {
    select when text_messanger set_twilio_number
    pre {
      number = event:attr("number")
    }
    always {
      ent:twilioNumber := number
    }
  }
  
  rule notifyThrougTwilio {
    select when text_messanger notification
    pre {
      toPhone = event:attr("toPhone");
      body = event:attr("Body");
    }
    http:post(<<https://#{ent:twilioSID}:#{ent:twilioAuthToken}@api.twilio.com/2010-04-01/Accounts/#{ent:twilioSID}/Messages.json>>, form = {
      "From": ent:twilioNumber,
      "Body": body,
      "To": toPhone
    })
  }
}
