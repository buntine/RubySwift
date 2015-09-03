class RubySwift

  require "savon"

  def initialize(password, namespace="ns1", http_adapter=:net_http)
    HTTPI.adapter = http_adapter 

    @password = password
    @client   = Savon.client(endpoint: "http://suite.peoplelogic.com.au/server/includes/apis/soap.php",
                             namespace: namespace,
                             convert_request_keys_to: :none)
  end

  def person_exists?(email)
    read_person(email).is_a?(Hash)
  end

  def write_or_update_person(fields)
    if person_exists?(fields[:email])
      update_person(fields[:email], fields.reject { |k,v| k == :email})     
    else
      write_person(fields)
    end
  end

  def read_person(email)
    return_response(soap_request("read_person", {email: email})) do |sr|
      convert_to_person(sr)
    end
  end

  def write_person(fields)
    return_response(soap_request("write_person", fields))
  end

  def read_groups
    return_response(soap_request("read_groups")) do |sr|
      sr[:item].map do |group|
        group[:item][:value]
      end
    end
  end

  def add_group_member(email, group_name)
    return_response(soap_request("add_group_member", {email: email, group_name: group_name}))
  end

  def remove_group_member(email, group_name)
    return_response(soap_request("remove_group_member", {email: email, group_name: group_name}))
  end

  def read_persons(group_name)
    return_response(soap_request("read_persons", {group_name: group_name})) do |sr|
      sr[:item].map do |person|
        convert_to_person(person)
      end
    end
  end

  def remove_group(group_name)
    return_response(soap_request("remove_group", {group_name: group_name}))
  end

  def remove_person(email)
    return_response(soap_request("remove_person", {group_name: group_name}))
  end

  def update_person(old_email, fields)
    return_response(soap_request("update_person", {email_old: old_email}.merge(fields)))
  end

  def write_group(group_name)
    return_response(soap_request("write_group", {group_name: group_name}))
  end

 private

  # Performs a SOAP request.
  def soap_request(operation, data=nil)
    response = @client.call(operation, xml: request_body(operation, data))

    tidy_response(response.body)
  end

  # Generates a raw XML SOAP request document.
  # I need to do it this way because the Swift SOAP server expects a particularly weird XML
  # format that Savon does not naturally produce.
  def request_body(operation, data)
    "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"urn:pl\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:#{operation}><param0 xsi:type=\"xsd:string\">#{@password}</param0><param1 xsi:type=\"ns2:Map\">#{hash_to_soap(data)}</param1></ns1:#{operation}></SOAP-ENV:Body></SOAP-ENV:Envelope>"
  end

  def hash_to_soap(data)
    if data
      data.map do |k, v|
        "<item><key xsi:type=\"xsd:string\">#{k}</key><value xsi:type=\"xsd:string\">#{v}</value></item>"
      end.join
    end
  end

  # Tidies up the response that Swift gives us.
  def tidy_response(response)
    response.to_a[0][1][:return]
  end

  def convert_to_person(soap_response)
    Hash[*soap_response[:item].map { |line|
      [line[:key].to_sym, (line[:value].is_a? Hash) ? nil : line[:value]]
    }.flatten]
  end

  def return_response(soap_response, &block)
    status = soap_response.to_s.to_i
    resp = if status == 0
      if block_given?
        yield soap_response
      else
        true
      end
    end

    return {:status => status, :response => resp}
  end
end
