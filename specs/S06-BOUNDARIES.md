# S06: BOUNDARIES - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Class Boundaries

### Inheritance Relationships

```
+--------------------+
| SIMPLE_CREATABLE   |  (mixin interface)
+--------------------+
         ^
         | constraint
+--------------------+       +---------------------+
| SIMPLE_FACTORY [G] |------>| SIMPLE_TYPE_FACTORY |
| (deferred)         |       | [G]                 |
+--------------------+       +---------------------+

+--------------------+       +------------------------+
| SIMPLE_SINGLETON   |       | SIMPLE_SHARED_SINGLETON|
| [G] (deferred)     |       | [G] (deferred)         |
+--------------------+       +------------------------+
```

### Composition Relationships

```
SIMPLE_OBJECT_POOL [G]
    +-- available: ARRAYED_STACK [G]
    +-- in_use: ARRAYED_LIST [G]

SIMPLE_CACHED_VALUE [G, K]
    +-- factory: FUNCTION [K, G]
    +-- cache: HASH_TABLE [G, K]

SIMPLE_ONCE_CELL [G]
    +-- factory: FUNCTION [G]
    +-- cached_value: detachable G

SIMPLE_TYPE_FACTORY [G]
    +-- type_table: HASH_TABLE [TYPE [G], STRING_32]
```

## Interface Boundaries

### SIMPLE_CREATABLE (Mixin)

Implemented by any poolable class:
```eiffel
class MY_POOLABLE inherit SIMPLE_CREATABLE
feature
    make_default do ... end
    is_in_default_state: BOOLEAN do ... end
```

### Factory Interface

```eiffel
-- Creation
new_instance: G
new_instance_from_string (spec): G

-- Validation
is_valid_specification (spec): BOOLEAN
matches_specification (obj, spec): BOOLEAN
```

### Pool Interface

```eiffel
-- Lifecycle
acquire: G
release (obj)
release_all

-- Query
is_in_use (obj): BOOLEAN
count, available_count, in_use_count: INTEGER
```

### Singleton Interface

```eiffel
-- Access
instance: G
is_initialized: BOOLEAN
```

## Data Flow

### Pool Acquire Flow
```
Application
    |
    | pool.acquire
    v
SIMPLE_OBJECT_POOL
    |
    | available.is_empty?
    |-- Yes --> create new G
    |-- No --> available.item + remove
    |
    | in_use.extend
    v
G instance
```

### Pool Release Flow
```
Application
    |
    | pool.release (obj)
    v
SIMPLE_OBJECT_POOL
    |
    | in_use.prune_all (obj)
    | obj.reset
    | available.extend (obj)
    v
Object returned to pool
```
