# simple_factory Bug Hunting Report

**Library:** simple_factory
**Version:** 1.0.0
**Date:** 2026-01-19
**Workflow:** Bug Hunting (Steps 29-36) + Bug Fixing (Steps 37-43)

## Executive Summary

Bug hunting and fixing workflows completed. **53 tests pass** with **1 bug fixed**. The library is stable for production use.

## Test Coverage

| Suite | Tests | Pass | Fail |
|-------|-------|------|------|
| Unit | 19 | 19 | 0 |
| Adversarial | 9 | 9 | 0 |
| Stress | 7 | 7 | 0 |
| Edge Cases | 9 | 9 | 0 |
| State Sequences | 7 | 7 | 0 |
| Regression | 2 | 2 | 0 |
| **TOTAL** | **53** | **53** | **0** |

## Step 29: Risk Area Survey

### High Risk Areas Identified

| ID | Class | Line | Risk Description |
|----|-------|------|------------------|
| R01 | SIMPLE_OBJECT_POOL | 74 | `prune_all` removes all occurrences |
| R02 | SIMPLE_OBJECT_POOL | 86-89 | Iteration during modification |
| R03 | SIMPLE_CACHED_VALUE | 34 | Expanded type handling |
| R04 | SIMPLE_ONCE_CELL | 35 | Factory returns Void |
| R05 | SIMPLE_OBJECT_POOL | 60 | Duplicate object acquisition |
| R06 | SIMPLE_TYPE_FACTORY | 34-42 | Ignores spec parameter |
| R07 | SIMPLE_SINGLETON | 14-20 | SCOOP race condition |

## Step 30: Semantic Alignment Analysis

### Layer Alignment Report

| Class | Spec | Contract | Code | Test | Status |
|-------|------|----------|------|------|--------|
| SIMPLE_OBJECT_POOL | OK | OK | OK | OK | Aligned |
| SIMPLE_CACHED_VALUE | OK | OK | OK | OK | Aligned |
| SIMPLE_ONCE_CELL | OK | OK | OK | OK | Aligned |
| SIMPLE_TYPE_FACTORY | OK | OK | OK | OK | **FIXED** |
| SIMPLE_SINGLETON | OK | OK | OK | N/A | Documented limitation |

## Step 31: Edge Case Testing

9 edge case tests written and passed:

| Test | Target | Description |
|------|--------|-------------|
| `test_pool_single_capacity` | Pool | Capacity = 1 |
| `test_pool_bounded_equals_initial` | Pool | max = initial |
| `test_pool_acquire_release_acquire` | Pool | Object reuse |
| `test_pool_acquire_same_object_check` | Pool | Distinct objects |
| `test_cache_zero_key` | Cache | Key = 0 |
| `test_cache_negative_key` | Cache | Key < 0 |
| `test_cache_invalidate_nonexistent` | Cache | Safe invalidate |
| `test_once_cell_multiple_invalidate` | Cell | Repeated invalidate |
| `test_once_cell_access_after_invalidate` | Cell | Access post-invalidate |

## Step 32: State Sequence Testing

7 state sequence tests written and passed:

| Test | Sequence | Description |
|------|----------|-------------|
| `test_pool_sequence_acquire_acquire_release_release` | A-A-R-R | Ordered operations |
| `test_pool_sequence_mixed_operations` | A-A-R-A-R | Interleaved operations |
| `test_pool_sequence_release_all_then_acquire` | A-A-RA-A | Release all, reuse |
| `test_cache_sequence_invalidate_access_invalidate` | I-A-I | Invalidate cycle |
| `test_cache_sequence_invalidate_all_then_populate` | Pop-IA-Pop | Full cycle |
| `test_once_cell_sequence_access_invalidate_access` | A-I-A | Cell recompute |
| `test_once_cell_fresh_after_creation` | Create | Lazy initialization |

## Step 33: Concurrency Analysis

**Finding:** Library is NOT SCOOP-safe (documented in class notes).

**Affected Classes:**
- SIMPLE_SINGLETON - Race condition in `instance` feature
- SIMPLE_SHARED_SINGLETON - Same race condition
- SIMPLE_OBJECT_POOL - Shared mutable state
- SIMPLE_CACHED_VALUE - Shared mutable state
- SIMPLE_ONCE_CELL - Shared mutable state

**Recommendation:** For SCOOP environments, wrap instances in separate regions.

## Step 34: Exploit Construction

### Exploit: E01 - new_instance_from_string Postcondition Violation

**Location:** `SIMPLE_TYPE_FACTORY.new_instance_from_string` (line 34-42)

**Original Trigger Condition:**
```eiffel
l_factory.register_type ("my_alias", {TEST_OBJECT})
l_obj := l_factory.new_instance_from_string ("my_alias")  -- CRASH!
```

**Why It Crashed (Before Fix):**
1. Code creates `TEST_OBJECT` via `create Result.make_default`
2. Postcondition calls `matches_specification(Result, "my_alias")`
3. Old `matches_specification` compared `Result.generating_type.name` ("TEST_OBJECT") with "my_alias"
4. `"TEST_OBJECT" /= "my_alias"` -> Postcondition violation

**Status:** FIXED (see Steps 37-43)

## Step 35: Root Cause Analysis

### Bug: V01 - new_instance_from_string

| Layer | Status | Issue |
|-------|--------|-------|
| Specification | CORRECT | Intent is clear |
| Contract | **FIXED** | `matches_specification` now checks registered type |
| Code | CORRECT | Creates default instance as documented |
| Test | COVERED | Regression tests added |

**Root Cause:** The `matches_specification` feature compared type NAME strings directly, but TYPE manifest names include attached prefix (e.g., `!TEST_OBJECT`) while runtime type names don't.

## Steps 37-43: Bug Fix

### Step 37: REPRODUCE-BUG
Created reproduction test that triggered postcondition violation.

### Step 38: CLASSIFY-FIX-LAYERS
- Specification: CORRECT (no change needed)
- Contract: NEEDS FIX (`matches_specification` semantics)
- Code: CORRECT (implementation fine, contract was wrong)

### Step 39: FIX-SPEC-CONTRACT
Modified `matches_specification` in SIMPLE_TYPE_FACTORY:

```eiffel
matches_specification (a_object: G; a_spec: READABLE_STRING_GENERAL): BOOLEAN
    -- Does `a_object` match `a_spec`?
    -- Returns True if:
    --   1. `a_spec` is a registered key AND object's type name matches
    --      the registered TYPE's name (after stripping attached/detached prefixes), OR
    --   2. `a_spec` exactly matches object's generating type name (fallback)
  local
    l_object_type_name: STRING_32
    l_registered_type_name: STRING_32
    l_registered_type: TYPE [G]
  do
    if has_type (a_spec) then
      -- Spec is a registered key - compare stripped type names
      l_registered_type := type_for_key (a_spec)
      l_object_type_name := stripped_type_name (a_object.generating_type.name)
      l_registered_type_name := stripped_type_name (l_registered_type.name)
      Result := l_object_type_name.same_string (l_registered_type_name)
    else
      -- Fallback: check if spec matches the literal type name
      l_object_type_name := stripped_type_name (a_object.generating_type.name)
      Result := l_object_type_name.same_string_general (a_spec)
    end
  end

stripped_type_name (a_name: READABLE_STRING_GENERAL): STRING_32
    -- Type name with attached/detached prefix removed
  do
    Result := a_name.to_string_32
    -- Remove leading '!' (attached) or '?' (detached) if present
    if not Result.is_empty and then (Result [1] = '!' or Result [1] = '?') then
      Result := Result.substring (2, Result.count)
    end
  end
```

### Step 40: FIX-CODE
No code changes needed - the contract fix resolved the issue.

### Step 41: VERIFY-FIX
Original exploit no longer triggers postcondition violation.

### Step 42: VERIFY-NO-REGRESSION
All 53 tests pass.

### Step 43: ADD-REGRESSION-TEST
Added two regression tests:
- `test_regression_v01_aliased_type_name` - Verifies aliased keys work
- `test_exact_type_name_still_works` - Verifies exact names still work

## Bug Report (RESOLVED)

### BUG-001: new_instance_from_string Ignores Specification

**Severity:** Medium -> RESOLVED
**Status:** FIXED
**Component:** SIMPLE_TYPE_FACTORY

**Description:**
The `new_instance_from_string` feature's postcondition `matches_specification` was incorrectly comparing type name strings, failing when the registered key (alias) differed from the actual type name.

**Root Cause:**
TYPE manifest `.name` returns attached prefix (e.g., `!TEST_OBJECT`) but runtime `generating_type.name` returns plain name (`TEST_OBJECT`).

**Fix Applied:**
Added `stripped_type_name` helper to normalize type names before comparison.

**Verification:**
- 53/53 tests pass
- Regression tests prevent future recurrence

---

## Recommendations

1. **SCOOP Consideration:** Add SCOOP-safe wrappers in Phase 2
2. **Documentation:** Class notes updated with warning about SCOOP limitations

## Files Created/Modified

| File | Status |
|------|--------|
| `src/simple_type_factory.e` | MODIFIED (contract fix) |
| `testing/test_edge_cases.e` | NEW |
| `testing/test_state_sequences.e` | NEW |
| `testing/test_exploits.e` | NEW -> REGRESSION |
| `testing/test_simple_factory.e` | MODIFIED |
| `docs/BUG_HUNTING_REPORT.md` | NEW |

## Conclusion

**simple_factory has completed Bug Hunting + Bug Fixing workflows.**

- 53/53 tests pass
- 1 bug found, analyzed, and fixed
- Regression tests prevent recurrence
- Library is production-ready
