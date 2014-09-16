RubySwift
=========

A ruby wrapper of the [Swift Digital Suite Mail House API](https://suite.swiftdigital.com.au).

INSTALLATION
------------
  You can install the library via Rubygems:

    $ gem install ruby-swift

  Or within your Gemfile if you're using Bundler:

    gem "ruby-swift"

USAGE
-----
  Initialize the connection:
    swift = RubySwift.new("API_PASSWORD")

  Read a person:
    person = swift.read_person("you@example.com")

  Add someone to a mail group:
    swift.add_group_member("you@example.com", "Group Name")

  Update person:
    swift.update_person(email: "you@example.com", first_name: "Donald", last_name: "Knuth")
