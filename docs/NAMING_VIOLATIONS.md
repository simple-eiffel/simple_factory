# simple_factory Naming Violation Scan

**Library:** simple_factory
**Date:** 2026-01-19
**Workflow:** Naming Review (Step 44-51)

## Summary

| Category | Critical | High | Medium | Low | Total |
|----------|----------|------|--------|-----|-------|
| Class names | 0 | 0 | 0 | 0 | 0 |
| Feature names | 0 | 0 | 0 | 0 | 0 |
| Constant names | 0 | 0 | 0 | 0 | 0 |
| Argument names | 0 | 0 | 12 | 0 | 12 |
| Local names | 0 | 0 | 0 | 0 | 0 |
| Cursor names | 0 | 0 | 0 | 0 | 0 |
| Generic params | 0 | 0 | 0 | 0 | 0 |
| Contract tags | 0 | 0 | 0 | 0 | 0 |
| Tuple labels | 0 | 0 | 0 | 0 | 0 |
| Clause labels | 0 | 0 | 0 | 0 | 0 |
| Magic numbers | 0 | 0 | 0 | 2 | 2 |
| **TOTAL** | **0** | **0** | **12** | **2** | **14** |

## Critical Violations (Must Fix)
None.

## High Violations
None.

## Medium Violations: Argument Names

All violations are missing `a_` prefix on arguments in inline agents and helper functions.

### test_simple_factory.e (5 violations)

| Line | Current | Should Be |
|------|---------|-----------|
| 178 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |
| 193 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |
| 209 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |
| 226 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |
| 243 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |

### test_adversarial.e (2 violations)

| Line | Current | Should Be |
|------|---------|-----------|
| 94 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |
| 113 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |

### test_stress.e (1 violation)

| Line | Current | Should Be |
|------|---------|-----------|
| 233 | `stress_factory (k: INTEGER)` | `stress_factory (a_k: INTEGER)` |

### test_edge_cases.e (3 violations)

| Line | Current | Should Be |
|------|---------|-----------|
| 129 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |
| 145 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |
| 160 | `agent (k: INTEGER)` | `agent (a_k: INTEGER)` |

### test_state_sequences.e (1 violation)

| Line | Current | Should Be |
|------|---------|-----------|
| 223 | `seq_factory (k: INTEGER)` | `seq_factory (a_k: INTEGER)` |

## Low Violations: Magic Numbers

### simple_cached_value.e (1 violation)

| Line | Magic Number | Context | Suggested Constant |
|------|--------------|---------|-------------------|
| 21 | `10` | `create cache.make (10)` | `Default_cache_capacity` |

### simple_type_factory.e (1 violation)

| Line | Magic Number | Context | Suggested Constant |
|------|--------------|---------|-------------------|
| 21 | `10` | `create type_table.make (10)` | `Default_table_capacity` |

## Compliant Items

### Class Names (ALL_CAPS) - All Compliant
- SIMPLE_CREATABLE
- SIMPLE_SHARED_SINGLETON
- SIMPLE_ONCE_CELL
- SIMPLE_CACHED_VALUE
- SIMPLE_SINGLETON
- SIMPLE_OBJECT_POOL
- SIMPLE_FACTORY
- SIMPLE_TYPE_FACTORY
- TEST_OBJECT
- TEST_ADVERSARIAL
- TEST_STRESS
- TEST_EDGE_CASES
- TEST_STATE_SEQUENCES
- TEST_EXPLOITS
- TEST_SIMPLE_FACTORY

### Feature Names (snake_case) - All Compliant
All features use proper snake_case naming.

### Generic Parameters (Single Letter) - All Compliant
- G, K (used appropriately)

### Loop Cursors (ic_ prefix) - All Compliant
- `ic_obj` in simple_object_pool.e:86

### Boolean Queries (is_/has_ prefix) - All Compliant
- is_in_default_state, is_computed, is_cached, is_in_use, is_at_capacity, etc.

### Contract Tags - All Compliant
All contract tags are descriptive and follow patterns.
