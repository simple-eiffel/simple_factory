# S05: CONSTRAINTS - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Technical Constraints

### Generic Constraints

| Class | Constraint | Rationale |
|-------|------------|-----------|
| SIMPLE_FACTORY | G -> SIMPLE_CREATABLE | Pooling support |
| SIMPLE_OBJECT_POOL | G -> SIMPLE_CREATABLE create make_default end | Pool creation |
| SIMPLE_CACHED_VALUE | K -> HASHABLE | Hash table keys |
| SIMPLE_TYPE_FACTORY | G -> SIMPLE_CREATABLE create make_default end | Type creation |

### Thread Safety

| Class | SCOOP-Safe | Notes |
|-------|------------|-------|
| SIMPLE_SINGLETON | NO | Documented warning |
| SIMPLE_SHARED_SINGLETON | NO | Documented warning |
| SIMPLE_OBJECT_POOL | NO | Single-thread only |
| SIMPLE_CACHED_VALUE | NO | Single-thread only |

## Business Rules

### Object Pool Rules

1. **Acquire requires availability:**
   - Either available objects exist
   - Or pool not at max capacity

2. **Release requires ownership:**
   - Object must be in in_use set
   - Object is reset before return

3. **Capacity rules:**
   - max_capacity = 0 means unlimited
   - count <= max_capacity (if bounded)

### Singleton Rules

1. **Single instance:** Same object returned always
2. **Lazy init:** Created on first access
3. **Reset warning:** Breaks existing references

### Cache Rules

1. **Factory function:** Called on cache miss
2. **Key-based:** One value per key
3. **Invalidation:** Manual only

## State Transitions

### Pool Object States
```
[New] -- acquire() --> [In Use]
[In Use] -- release() --> [Available]
[Available] -- acquire() --> [In Use]
```

### Singleton States
```
[Not Initialized] -- instance --> [Initialized]
[Initialized] -- reset_instance --> [Not Initialized]
```

### Cache Entry States
```
[Not Cached] -- item() --> [Cached]
[Cached] -- invalidate() --> [Not Cached]
```
