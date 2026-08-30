# requiem

`.http` files in Nova.

- Syntax highlighting, folding, and symbols for `.http` and `.rest` files, from a tree-sitter grammar.
- Bodies colored in their own language: JSON, XML, and, where a `Content-Type: message/http` says so, the HTTP message carried as content.
- The Symbols sidebar nests each `###` section's requests, their headers, inline responses, and `@variable` declarations.
- ` ```http ` fences in Markdown are colored the same way.

The grammar is [tree-sitter-http](https://github.com/x-amz/tree-sitter-http), written to the rules [requiem](https://requiem.rest) uses to read a file, so what the editor shows as a request is what the app would send.
