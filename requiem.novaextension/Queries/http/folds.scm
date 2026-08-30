; Each ### section folds from its separator line to the end of the section.
((section
  (separator) @start) @end.after)

; A message with a body folds from its first line.
((request
  target: (target) @start
  body: (_)) @end.after)
((response
  status: (status_code) @start
  body: (_)) @end.after)
