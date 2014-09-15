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
    soap_request("read_person", {email: email})
  end

 private

  # Performs a SOAP request.
  def soap_request(operation, data)
    response = @client.call(operation, xml: request_body(operation, data))

    tidy_response(response.body)
  end

  # Generates a raw XML SOAP request document.
  # I need to do it this way because the Swift SOAP server expects a particularly weird XML
  # format that SAvon does not naturally produce.
  def request_body(operation, data)
    "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"urn:pl\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:#{operation}><param0 xsi:type=\"xsd:string\">#{@password}</param0><param1 xsi:type=\"ns2:Map\">#{hash_to_soap(data)}</param1></ns1:#{operation}></SOAP-ENV:Body></SOAP-ENV:Envelope>"
  end

  def hash_to_soap(data)
    data.map do |k, v|
      "<item><key xsi:type=\"xsd:string\">#{k}</key><value xsi:type=\"xsd:string\">#{v}</value></item>"
    end.join
  end

  # Tidies up the response that Swift gives us.
  def tidy_response(response)
    base = response.to_a[0][1][:return]

    if base.is_a?(Hash)
      transform_hash(base)
    else
      base
    end
  end

  def transform_hash(data)
    Hash[
      data[:item].map { |h| [h[:key], h[:value]] }
    ]
  end
end
