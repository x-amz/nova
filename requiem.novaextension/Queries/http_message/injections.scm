; On the wire a body's type is declared, never sniffed: Content-Type names
; it, and the body is one opaque node running to the end of the message.
; A message/http body nests — an echoed message that itself carried one.

([
  (request
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (body) @injection.content)
  (response
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (body) @injection.content)
 ]
 (#match? @_content_type "(?i)^content-type[ \t]*$")
 (#match? @_media_type "(?i)[/+]json[ \t]*($|;)")
 (#set! injection.language "json"))

([
  (request
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (body) @injection.content)
  (response
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (body) @injection.content)
 ]
 (#match? @_content_type "(?i)^content-type[ \t]*$")
 (#match? @_media_type "(?i)[/+]xml[ \t]*($|;)")
 (#set! injection.language "xml"))

([
  (request
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (body) @injection.content)
  (response
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (body) @injection.content)
 ]
 (#match? @_content_type "(?i)^content-type[ \t]*$")
 (#match? @_media_type "(?i)^message/http[ \t]*($|;)")
 (#set! injection.language "http_message"))
