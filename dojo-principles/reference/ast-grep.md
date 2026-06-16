# ast-grep — Pattern Syntax and Task Table

Load on demand. Summary rule lives in dojo-principles → Code Navigation.

## Pattern syntax

```bash
# Metavariables
$VAR      # matches any single AST node
$$$ARGS   # matches zero or more nodes (variadic)

# Find all calls to a function
sg -p 'applyDiscount($ORDER)' --lang cs

# Find all function definitions matching a shape
sg -p 'fn $NAME($$$ARGS) -> Result<$T, $E>' --lang rust

# Find all usages of a type
sg -p 'List<$T>' --lang cs

# Structural rewrite (safe rename / transform)
sg -p 'console.log($ARG)' -r 'logger.info($ARG)' --lang ts

# JSON output for agent parsing
sg -p 'applyDiscount($$$)' --lang cs --json | jq '.matches[].range'

# Scan entire project with a YAML rule
sg scan --rule rules/no-raw-sql.yml
```

## When to use which

| Task | Tool |
|---|---|
| Check if a name is distinct enough | `rg "name" .` |
| Find all actual call sites before changing a signature | `sg -p 'fn($$$)' --lang X` |
| Find structural duplicates (same pattern, different names) | `sg -p 'pattern' --lang X` |
| Safe bulk rename or transform | `sg -p 'old' -r 'new' --lang X` |
| Find where a type is used | `sg -p 'TypeName' --lang X` |
| Search in comments or strings | `rg "text" .` |

`sg --rewrite` is structural — it won't touch the same pattern inside comments or strings.
Always run dojo-check after a rewrite.
