; extends

; highlight html around go template actions (hugo layouts)
((text) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined))
