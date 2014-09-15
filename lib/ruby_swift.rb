class RubySwift

  def initialize(password)
    @password = password
    @client   = Savon.client(endpoint: "http://suite.peoplelogic.com.au/server/includes/apis/soap.php",
                             namespace: "ns1",
                             convert_request_keys_to: :none)
  end

  def read_person(email)
  end

 private

  def soap_request(message)
  end

end
