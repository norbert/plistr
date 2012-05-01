# Plistr

Fast XML property list reader.

## Example

```ruby
require 'plistr'

plist = Plistr::Reader.open("#{ENV['HOME']}/Library/Cookies/Cookies.plist")
puts plist.value.size
```
