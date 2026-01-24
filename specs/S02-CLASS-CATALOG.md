# S02: CLASS CATALOG - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Class Hierarchy

```
ANY
    +-- SIMPLE_CREATABLE (deferred)
    +-- SIMPLE_FACTORY [G -> SIMPLE_CREATABLE] (deferred)
    |       +-- SIMPLE_TYPE_FACTORY [G]
    +-- SIMPLE_SINGLETON [G] (deferred)
    +-- SIMPLE_SHARED_SINGLETON [G] (deferred)
    +-- SIMPLE_OBJECT_POOL [G -> SIMPLE_CREATABLE]
    +-- SIMPLE_CACHED_VALUE [G, K -> HASHABLE]
    +-- SIMPLE_ONCE_CELL [G]
```

## Class Details

### SIMPLE_CREATABLE (deferred)

**Purpose:** Mixin for poolable objects
**Responsibility:** Define reset and default state interface

| Feature | Description |
|---------|-------------|
| make_default | Initialize to default state |
| is_in_default_state | Check if in default |
| reset | Return to default state |

---

### SIMPLE_FACTORY [G] (deferred)

**Purpose:** Abstract factory base
**Responsibility:** Define creation interface

| Feature | Description |
|---------|-------------|
| new_instance | Create fresh instance |
| new_instance_from_string | Create from spec |
| is_valid_specification | Validate spec |
| matches_specification | Check result matches |
| was_recycled | Check if from pool |

---

### SIMPLE_TYPE_FACTORY [G]

**Purpose:** Concrete factory using TYPE manifests
**Responsibility:** Type registration and creation

| Feature | Description |
|---------|-------------|
| register_type | Register type for key |
| has_type | Check key registered |
| type_for_key | Get registered type |

---

### SIMPLE_SINGLETON [G] (deferred)

**Purpose:** Singleton holder with lazy init
**Responsibility:** Single instance guarantee

| Feature | Description |
|---------|-------------|
| instance | Get/create singleton |
| is_initialized | Check if created |
| reset_instance | Clear (dangerous!) |
| new_instance | Create (deferred) |

---

### SIMPLE_OBJECT_POOL [G]

**Purpose:** Reusable object pool
**Responsibility:** Acquire/release pooled objects

| Feature | Description |
|---------|-------------|
| acquire | Get object from pool |
| release | Return object to pool |
| release_all | Return all objects |
| model_available | MML model of available |
| model_in_use | MML model of in-use |

---

### SIMPLE_CACHED_VALUE [G, K]

**Purpose:** Keyed cache with computation
**Responsibility:** Cache values by key

| Feature | Description |
|---------|-------------|
| item | Get/compute value |
| is_cached | Check if cached |
| invalidate | Remove from cache |
| invalidate_all | Clear all |

---

### SIMPLE_ONCE_CELL [G]

**Purpose:** Lazy single value
**Responsibility:** Compute once on demand

| Feature | Description |
|---------|-------------|
| item | Get/compute value |
| is_computed | Check if computed |
| invalidate | Force recompute |
