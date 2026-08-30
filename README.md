# requiem for Nova

`.http` files in [Nova](https://nova.app): syntax highlighting, folding, the Symbols sidebar, and bodies colored in their own language. The parser is [tree-sitter-http](https://github.com/x-amz/tree-sitter-http), written to the same rules [requiem](https://requiem.rest) uses to read a file, so what the editor shows as a request is what the app would send.

Install it from Nova's Extension Library, or build it from this repo.

## What it does

- Opens `.http` and `.rest` files, with `#` comment toggling.
- Colors requests, inline responses, headers, `@variable` declarations, `{{placeholders}}`, and `###` sections.
- Folds each `###` section.
- Symbols sidebar: each section's requests, their headers, inline responses, and variables.
- JSON and XML bodies colored by Nova's own JSON and XML syntaxes.
- A body sent as `Content-Type: message/http` colored as the HTTP message it carries.
- ` ```http ` and ` ```message/http ` fences in Markdown.

## Layout

```
requiem.novaextension/   the extension bundle
  extension.json         manifest
  Syntaxes/              http.xml, http_message.xml, and the parser dylibs (built, untracked)
  Queries/http/          highlights, folds, symbols, injections for .http files
  Queries/http_message/  highlights, injections for HTTP wire messages
examples/                sample files
Makefile                 builds the parsers from a tree-sitter-http checkout
```

Two syntaxes from one grammar. `http` is the file format. `http_message` is a raw HTTP message with no file-format features, and has no detectors: it exists to be injected into a `message/http` body or a Markdown fence.

## Building

Requires Nova (the parsers link against its `SyntaxKit` framework), a C compiler, the `tree-sitter` CLI, and a checkout of tree-sitter-http at the tag this extension ships. By default the Makefile looks for it at `../tree-sitter-http`; pass `GRAMMAR=path` to point elsewhere.

```bash
make            # both parsers as universal dylibs, ad-hoc signed, into Syntaxes/
make check      # run each query file against its grammar; unknown node types fail here rather than in Nova
make test       # the grammar's corpus tests
make generate   # regenerate parser.c from the grammar source, at tree-sitter ABI 14
```

Nova loads grammars at ABI 14. If the Extension Console reports an incompatible Tree-sitter API version, regenerate with `make generate`.

## Running from source

1. Settings ▸ General ▸ enable "Show extension development items in Extensions menu".
2. `make`.
3. Open `requiem.novaextension/` as a project, then Extensions ▸ **Activate Project as Extension**. Reactivate after changing a dylib or a query.
4. Open the files in `examples/`.

## Queries

Queries use Nova's dialect: capture names are Nova theme selectors, folds use `@start` and `@end.after`, symbols use `@name`, `@displayname`, and `@subtree` with `#set! role`. Stick to `#eq?`, `#match?`, `#set!`, and the text directives so `make check` can still run them through the tree-sitter CLI.

Coloring, folding, symbols, and body injection are all changes to a query file. Anything the grammar cannot see is a change to tree-sitter-http, and ships with its next tag.

## License

MIT.
