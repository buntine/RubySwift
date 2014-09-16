RubySwift
=========

A ruby wrapper of the [Swift Digital Suite Mail House API](https://suite.swiftdigital.com.au/login).

This is currently a relatively crude wrapper and does not tidy responses from Swift a lot.

INSTALLATION
------------
  You can install the library via Rubygems:

    $ gem install ruby-swift

  Or within your Gemfile if you're using Bundler:

    gem "ruby-swift"

USAGE
-----
  Initialize the connection:

```ruby
swift = RubySwift.new("API_PASSWORD")
```

  Does a person exist?

```ruby
swift.person_exists?("you@example.com") # -> true
```

  Read a person:

```ruby
person = swift.read_person("you@example.com")
```

  Add someone to a mail group:

```ruby
swift.add_group_member("you@example.com", "Group Name") # -> "0"
```

  Remove someone from a mail group:

```ruby
swift.remove_group_member("you@example.com", "Group Name") # -> "0"
```

  Create a person:

```ruby
swift.write_person(email: "me@example.com", first_name: "Dennis", last_name: "Ritchie") # -> "0"
```

  Update person:

```ruby
swift.update_person(email: "you@example.com", first_name: "Donald", last_name: "Knuth") # -> "0"
```

  Create or update existing person:

```ruby
swift.write_or_update_person(email: "me@example.com", first_name: "Dennis", last_name: "Ritchie") # -> "0"
```

  Create a group:

```ruby
swift.write_group("Group name") # -> "0"
```

  Read all groups:

```ruby
groups = swift.read_groups
```

  Read all members of a group:

```ruby
people = swift.read_persons("Group Name")
```

  Remove a group:

```ruby
swift.remove_group("Group Name") # -> "0"
```

  Remove a person:

```ruby
swift.remove_person("you@example.com") # -> "0"
```

TODO
----
  * Tidy up responses (Hashie?)
  * Return true/false instead of "0" for write actions
