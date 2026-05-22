# Error Test Programs

All test files are in `tests/errors/`. Run from the project root after `make`:

```
./rpal20 tests/errors/<filename>.rpal
```

---

## Test Catalog

| File | Error Category | Trigger | Expected Message |
|------|---------------|---------|-----------------|
| `err01_lexical_bad_char.rpal` | **Lexical** | `?` is not a valid RPAL character | `Lexical Error: invalid token '?' at line 2, column 11` |
| `err02_lexical_unterminated_string.rpal` | **Lexical** | String literal with no closing `'` | `Lexical Error: invalid token '...' at line 2, ...` |
| `err03_syntax_missing_in.rpal` | **Syntax** | `let x = 10` without `in` | `Syntax Error: expected 'in' but found 'Print' at line 2, column 1` |
| `err04_syntax_missing_equals.rpal` | **Syntax** | `let x 5` (missing `=`) | `Syntax Error: expected '=' but found '5' at line 2, column 7` |
| `err05_syntax_unmatched_paren.rpal` | **Syntax** | `(3 + 4` without closing `)` | `Syntax Error: expected ')' but found 'in' at line 3, column 1` |
| `err06_syntax_missing_pipe.rpal` | **Syntax** | `cond -> 'yes'` without `\| 'no'` | `Syntax Error: expected '\|' but found ...` |
| `err07_syntax_extra_tokens.rpal` | **Syntax** | Junk tokens after a complete expression | `Syntax Error: expected end of program but found 'garbage' at line 2, column 1` |
| `err08_runtime_div_by_zero.rpal` | **Runtime** | `10 / 0` (literal zero) | `Error: Runtime Error: division by zero` |
| `err09_runtime_div_by_zero_expr.rpal` | **Runtime** | Divisor computed to `0` via function | `Error: Runtime Error: division by zero` |
| `err10_type_add_string.rpal` | **Type** | `5 + 'hello'` | `Error: Type Error: '+' requires integer operands, got a non-integer value` |
| `err11_type_not_on_int.rpal` | **Type** | `not 42` | `Error: Type Error: 'not' requires a truth-value (boolean) operand, got a non-boolean value` |
| `err12_type_or_on_int.rpal` | **Type** | `1 or 0` (integers, not booleans) | `Error: Type Error: 'or' requires a truth-value (boolean) operand, got a non-boolean value` |
| `err13_type_cond_non_bool.rpal` | **Type** | `(x+1) -> 'yes' \| 'no'` | `Error: conditional guard must be a truth value` |
| `err14_runtime_apply_non_fn_int.rpal` | **Runtime** | `42 10` (integer applied as function) | `Error: Runtime Error: cannot apply a non-function value (got type 'integer')` |
| `err15_runtime_apply_non_fn_str.rpal` | **Runtime** | `'hello' 99` (string applied as function) | `Error: Runtime Error: cannot apply a non-function value (got type 'string')` |
| `err16_runtime_unbound_var.rpal` | **Runtime** | Using undefined variable `z` | `Error: unbound variable: z` (from Environment lookup) |
| `err17_runtime_tuple_oob.rpal` | **Runtime** | Accessing index 5 of a 3-element tuple | `Error: tuple index out of range` |
| `err18_runtime_builtin_stem_int.rpal` | **Runtime** | `Stem 42` (Stem expects string) | `Error: Stem expects string` |
| `err19_runtime_conc_non_string.rpal` | **Runtime** | `Conc 'hello' 99` (second arg is int) | `Error: Conc expects two strings` |

---

## Error Flow

All errors follow a consistent path:
```
Lexical Error  →  printed directly to stderr, exit 1
Syntax Error   →  thrown as runtime_error → caught in main → "Error: ..." to stderr, exit 1
Runtime Error  →  thrown as runtime_error → caught in main → "Error: ..." to stderr, exit 1
```
