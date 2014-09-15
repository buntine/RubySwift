class RubySwift

  require "savon"

  def initialize(password)
    HTTPI.adapter = :net_http 

    @password = password
    @client   = Savon.client(endpoint: "http://suite.peoplelogic.com.au/server/includes/apis/soap.php",
                             namespace: "ns1",
                             convert_request_keys_to: :none)
  end

  def read_person(email)
    soap_request("read_person", {:email => email})
  end

 private

  def soap_request(operation, data)
    response = @client.call(operation, xml: request_body(operation, data))

    response.body
  end

  def request_body(operation, data)
    "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"urn:pl\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:#{operation}><param0 xsi:type=\"xsd:string\">#{@password}</param0><param1 xsi:type=\"ns2:Map\">#{hash_to_soap(data)}</param1></ns1:#{operation}></SOAP-ENV:Body></SOAP-ENV:Envelope>"
  end

  def hash_to_soap(data)
    "<item><key xsi:type=\"xsd:string\">email</key><value xsi:type=\"xsd:string\">amir_izwan7@hotmail.com</value></item>"
  end
end
