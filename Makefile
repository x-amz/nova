# Builds the tree-sitter parsers into the extension bundle, the way Nova's
# SyntaxKit expects them: universal, linked against SyntaxKit, ad-hoc signed.
# Both dialects of the sibling checkout ../tree-sitter-http (override GRAMMAR)
# are built: `http` colors the document, `http_message` colors the
# message/http bodies injected into it.
#
# Nova loads Syntaxes/libtree-sitter-<language>.dylib and calls
# tree_sitter_<language>, so a dylib carries its grammar's name, underscore
# and all (SyntaxKit's own built-ins: libtree-sitter-embedded_template.a).
# A grammar's name is its name everywhere here: the dialect's directory in
# $(GRAMMAR), the dylib, the entry point, the Nova syntax, and that syntax's
# directory under Queries/.

NOVA     ?= /Applications/Nova.app
GRAMMAR  ?= ../tree-sitter-http
BUNDLE   := requiem.novaextension
GRAMMARS := http http_message
DYLIBS   := $(GRAMMARS:%=$(BUNDLE)/Syntaxes/libtree-sitter-%.dylib)

# The sample each grammar's queries are checked against. Both are .http so
# Nova opens them; the wire one is a bare exchange, the shape a body carries
# under Content-Type: message/http.
EXAMPLE_http    := examples/example.http
EXAMPLE_http_message := examples/message.http

ARCHS   := -arch arm64 -arch x86_64
CFLAGS  := $(ARCHS) -mmacosx-version-min=11.6 -O3 -std=gnu99 -fPIC
LDFLAGS := $(ARCHS) -dynamiclib \
           -F$(NOVA)/Contents/Frameworks -framework SyntaxKit \
           -Wl,-rpath,@loader_path/../Frameworks

all: $(DYLIBS)

# One rule per grammar: it names the dylib, its symbols, and the directory
# holding the generated source.
define parser
$(BUNDLE)/Syntaxes/libtree-sitter-$(1).dylib: \
    $(GRAMMAR)/$(1)/src/parser.c $(GRAMMAR)/$(1)/src/scanner.c $(GRAMMAR)/common/scanner.h
	$$(CC) $$(CFLAGS) -I$(GRAMMAR)/$(1)/src $$(LDFLAGS) \
	    -Wl,-install_name,@rpath/libtree-sitter-$(1).dylib \
	    $(GRAMMAR)/$(1)/src/parser.c $(GRAMMAR)/$(1)/src/scanner.c -o $$@
	codesign --force --sign - $$@
endef
$(foreach g,$(GRAMMARS),$(eval $(call parser,$(g))))

# Regenerate each dialect's src/parser.c from its grammar.js. ABI 14 is the
# version both consumers of these grammars (SyntaxKit, SwiftTreeSitter) are
# known to load.
generate:
	@for g in $(GRAMMARS); do \
	  echo "$$g"; (cd $(GRAMMAR)/$$g && tree-sitter generate --abi 14) || exit 1; \
	done

# The grammars' own corpus tests.
test:
	@for g in $(GRAMMARS); do \
	  echo "$$g"; (cd $(GRAMMAR)/$$g && tree-sitter test) || exit 1; \
	done

# Compile each syntax's queries against the grammar they are written for, to
# catch unknown node types and malformed patterns before Nova does. Nova-only
# predicates are not understood by the CLI; keep the queries to #eq? / #match?
# / #set!. The grammar's directory is what forces the CLI's choice of grammar.
check: $(GRAMMARS:%=check-%)

check-%:
	@for q in $(BUNDLE)/Queries/$*/*.scm; do \
	  printf '%s ' "$${q#$(BUNDLE)/Queries/}"; \
	  (cd $(GRAMMAR)/$* && tree-sitter query $(CURDIR)/$$q $(CURDIR)/$(EXAMPLE_$*) > /dev/null) \
	    && echo ok || exit 1; \
	done

clean:
	rm -f $(DYLIBS)

.PHONY: all generate test check clean
