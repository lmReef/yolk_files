((string) @injection.content
  (#match? @injection.content "^\"\"\"")
  (#set! injection.include-children)
  (#offset! @injection.content 1 0 0 -1)
  (#set! injection.language "bash"))

; (string
;   name: (string) @name
;   (#match? @name "python")
;   argument: (string) @arg1
;   (#match? @arg1 "-c")
;   argument: (string_content) @python)
