# 7S-04: SIMPLE-STAR - simple_factory


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Ecosystem Integration

### Used By

| Library | Purpose |
|---------|---------|
| simple_json | Object creation from JSON |
| simple_http | Connection pooling |
| Application | Various creation patterns |

### Dependencies

| Library | Purpose |
|---------|---------|
| EiffelBase | Collections |
| MML | Model contracts |

## API Consistency

### Naming Conventions
- SIMPLE_* prefix for all classes
- Deferred classes for abstract patterns
- Effective classes for concrete implementations

### Creation Pattern
```eiffel
-- Factory usage
factory: SIMPLE_TYPE_FACTORY [MY_CLASS]
create factory.make
factory.register_type ("my_type", {MY_CLASS})
obj := factory.new_instance_from_string ("my_type")

-- Pool usage
pool: SIMPLE_OBJECT_POOL [MY_CLASS]
create pool.make (10)
obj := pool.acquire
pool.release (obj)

-- Singleton usage
class MY_SINGLETON inherit SIMPLE_SINGLETON [MY_DATA]
-- Use: singleton.instance
```

## Ecosystem Patterns Applied

### Deferred Classes
- SIMPLE_FACTORY: Abstract factory
- SIMPLE_SINGLETON: Singleton holder
- SIMPLE_SHARED_SINGLETON: Inheritance-based
- SIMPLE_CREATABLE: Poolable interface

### Model-Based Contracts
Uses MML_SET and MML_MAP for pool contracts:
```eiffel
model_available: MML_SET [G]
model_in_use: MML_SET [G]
model_all: MML_SET [G]
```

### Generic Constraints
```eiffel
SIMPLE_FACTORY [G -> SIMPLE_CREATABLE]
SIMPLE_OBJECT_POOL [G -> SIMPLE_CREATABLE create make_default end]
SIMPLE_CACHED_VALUE [G, K -> HASHABLE]
```
