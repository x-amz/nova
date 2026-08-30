; Language injection for body interiors. Bodies are opaque lines in the
; grammar (the engine's split: HttpSyntax tokenizes, ContentFormats parses
; the formats), so coloring inside one is another syntax's job.
;
; JSON and XML are typed by the body's first line, the way the engine types
; them. `message/http` cannot be — a wire message is ordinary text until a
; Content-Type says otherwise — so there the header names the language, as it
; does on the wire. The carrier is the echo (`echo.http.vet`): it answers
; `200` with the request's own octets as the body, under that Content-Type.

((json_body) @injection.content
  (#set! injection.language "json"))

((xml_body) @injection.content
  (#set! injection.language "xml"))

([
  (request
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (raw_body) @injection.content)
  (response
    (header
      name: (header_name) @_content_type
      value: (value) @_media_type)
    body: (raw_body) @injection.content)
 ]
 (#match? @_content_type "(?i)^content-type[ \t]*$")
 (#match? @_media_type "(?i)^message/http[ \t]*($|;)")
 (#set! injection.language "http_message"))
