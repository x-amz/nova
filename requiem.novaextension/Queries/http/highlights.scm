; Request line
(method) @keyword
(target) @markup.link
(continuation) @markup.link
(version) @identifier.constant
(trailer) @invalid

; Headers
(header
  name: (header_name) @identifier.key
  ":" @punctuation.delimiter)
(header value: (value) @string)

; {{placeholders}}
(placeholder
  "{{" @bracket
  "}}" @bracket)
(reference name: (identifier) @identifier.variable)
(reference path: (path_expression) @identifier.property)
(dynamic name: (dynamic_name) @identifier.variable.builtin)
(dynamic (argument) @identifier.argument)

; @name = value
(declaration
  "@" @operator
  name: (identifier) @identifier.variable
  "=" @operator)
(declaration value: (value) @string)

; Comments and # @directives
(comment) @comment
(directive) @comment
(directive
  "@" @identifier.decorator
  name: (identifier) @identifier.decorator)
(directive argument: (value) @identifier.argument)

; ### separators
(separator) @processing

; Inline responses
(status_code) @value.number
(status_text) @string

; Bodies
(file_body path: (path) @string)
