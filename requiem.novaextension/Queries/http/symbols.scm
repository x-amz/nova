; Hierarchy comes from @subtree containment: a titled ### section owns the
; messages after it; a message owns its headers. A titleless `###`
; contributes no heading, so its messages appear at the level above.

; ### Title → heading over the whole section
((section
  (separator title: (title) @name)) @subtree
  (#set! role heading))

; A request, shown as "METHOD target"
((request
  method: (method)? @_method
  target: (target) @name @displayname) @subtree
  (#set! role function)
  (#prefix! @displayname @_method " ")
  (#strip! @displayname "\\s+"))

; Headers
((header
  name: (header_name) @name) @subtree
  (#set! role property))

; An inline response, shown as "HTTP/1.1 200 OK"
((response
  version: (version) @_version
  status: (status_code) @name @displayname
  reason: (status_text)? @_reason) @subtree
  (#set! role block)
  (#prefix! @displayname @_version " ")
  (#append! @displayname " " @_reason)
  (#strip! @displayname "\\s+"))

; @name = value
((declaration
  name: (identifier) @name) @subtree
  (#set! role variable))
