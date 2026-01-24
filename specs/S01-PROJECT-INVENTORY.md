# S01: PROJECT INVENTORY - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Project Structure

```
simple_factory/
    +-- src/
    |   +-- simple_factory.e         # Abstract factory
    |   +-- simple_type_factory.e    # Type-based factory
    |   +-- simple_singleton.e       # Singleton holder
    |   +-- simple_shared_singleton.e # Inheritance singleton
    |   +-- simple_object_pool.e     # Object pooling
    |   +-- simple_cached_value.e    # Keyed cache
    |   +-- simple_once_cell.e       # Lazy value
    |   +-- simple_creatable.e       # Poolable interface
    |
    +-- testing/
    |   +-- test_app.e
    |   +-- lib_tests.e
    |   +-- test_simple_factory.e
    |   +-- test_object.e
    |   +-- test_edge_cases.e
    |   +-- test_state_sequences.e
    |   +-- test_stress.e
    |   +-- test_adversarial.e
    |   +-- test_exploits.e
    |
    +-- research/
    +-- specs/
    +-- simple_factory.ecf
    +-- README.md
```

## File Inventory

| File | Lines | Purpose |
|------|-------|---------|
| simple_factory.e | 50 | Abstract factory |
| simple_type_factory.e | 140 | Concrete factory |
| simple_singleton.e | 65 | Singleton pattern |
| simple_shared_singleton.e | 50 | Inheritance singleton |
| simple_object_pool.e | 240 | Object pooling |
| simple_cached_value.e | 95 | Keyed cache |
| simple_once_cell.e | 75 | Lazy computation |
| simple_creatable.e | 35 | Poolable interface |

## Dependencies

### Internal
- None

### External
- EiffelBase
- MML (Mathematical Model Library)

## Build Targets

| Target | Purpose |
|--------|---------|
| simple_factory | Library |
| simple_factory_tests | Test suite |
