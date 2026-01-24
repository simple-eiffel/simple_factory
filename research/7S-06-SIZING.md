# 7S-06: SIZING - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Implementation Size

### Actual Implementation

| Component | Lines | Complexity |
|-----------|-------|------------|
| SIMPLE_FACTORY | ~50 | Low (deferred) |
| SIMPLE_TYPE_FACTORY | ~140 | Medium |
| SIMPLE_SINGLETON | ~65 | Low |
| SIMPLE_SHARED_SINGLETON | ~50 | Low |
| SIMPLE_OBJECT_POOL | ~240 | Medium |
| SIMPLE_CACHED_VALUE | ~95 | Low |
| SIMPLE_ONCE_CELL | ~75 | Low |
| SIMPLE_CREATABLE | ~35 | Low (deferred) |
| **Total Source** | **~750** | **Medium** |

### Test Coverage

| Test File | Lines | Tests |
|-----------|-------|-------|
| test_simple_factory.e | ~100 | Factory tests |
| test_object.e | ~50 | Test objects |
| test_edge_cases.e | ~80 | Edge cases |
| test_state_sequences.e | ~100 | State tests |
| test_stress.e | ~100 | Performance |
| test_adversarial.e | ~80 | Adversarial |
| test_exploits.e | ~60 | Security |
| **Total Tests** | **~570** | |

### Complexity Breakdown

#### Simple (boilerplate)
- SIMPLE_CREATABLE: Interface only
- SIMPLE_SINGLETON: Lazy init
- SIMPLE_SHARED_SINGLETON: Once pattern

#### Medium (logic + contracts)
- SIMPLE_TYPE_FACTORY: Type registration
- SIMPLE_OBJECT_POOL: Acquire/release with MML
- SIMPLE_CACHED_VALUE: Hash table caching

### Dependencies

```
simple_factory
    +-- EiffelBase
    |   +-- ARRAYED_STACK
    |   +-- ARRAYED_LIST
    |   +-- HASH_TABLE
    |   +-- FUNCTION
    +-- MML
        +-- MML_SET
        +-- MML_MAP
```

### Build Time Impact
- Clean build: ~8 seconds
- Incremental: ~3 seconds
- No C compilation

### Runtime Footprint
- Memory: ~5KB per class
- Pool: O(n) for n objects
- Cache: O(n) for n entries
