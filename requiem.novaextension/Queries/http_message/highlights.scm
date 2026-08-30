; The wire dialect: the .http highlights minus every construct the format
; adds. No placeholders, comments, directives, declarations, or separators
; exist here — an injected region is bytes that crossed the wire.

; Request line
(method) @keyword
(target) @markup.link
(version) @identifier.constant
(trailer) @invalid

; Headers
(header
  name: (header_name) @identifier.key
  ":" @punctuation.delimiter)
(header value: (value) @string)

; Status line
(status_code) @value.number
(status_text) @string
