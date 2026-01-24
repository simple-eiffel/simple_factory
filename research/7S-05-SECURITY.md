# 7S-05: SECURITY - simple_factory


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Security Considerations

### Threat Model

| Threat | Mitigation | Status |
|--------|------------|--------|
| Object state leakage | reset() on pool return | Implemented |
| Singleton mutation | Application responsibility | N/A |
| Type confusion | Generic constraints | Type-safe |
| Resource exhaustion | Bounded pools | Optional |

### Object Pool Security

#### State Cleanup
Objects returned to pool are reset:
```eiffel
release (a_object: G)
    do
        a_object.reset  -- Clears sensitive state
        available.extend (a_object)
    ensure
        object_reset: a_object.is_in_default_state
```

#### Bounded Pools
```eiffel
make_bounded (a_capacity: INTEGER; a_max: INTEGER)
    -- Prevents memory exhaustion
```

### Singleton Security

#### Instance Protection
- Singleton instance is cached in internal attribute
- reset_instance exists but warns about danger
- No external mutation of instance reference

#### Warning in Code
```eiffel
reset_instance
        -- Clear singleton (use with caution)
        -- WARNING: This breaks singleton contract!
```

### Type Factory Security

#### Type Registration
- Only registered types can be created
- Type manifests are compile-time checked
- No reflection-based instantiation

### Known Limitations

1. **Not SCOOP-safe:** Singletons can be accessed concurrently
2. **No instance counting:** Can't limit total objects
3. **Trust in SIMPLE_CREATABLE:** reset() must be properly implemented

### Security Recommendations

1. Implement reset() to clear ALL sensitive data
2. Don't use singleton for mutable shared state in SCOOP
3. Use bounded pools in resource-constrained environments
4. Validate objects acquired from pools before use
