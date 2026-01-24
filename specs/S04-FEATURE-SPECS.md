# S04: FEATURE SPECS - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## SIMPLE_CREATABLE Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make_default | `()` | Initialize to default (deferred) |
| is_in_default_state | `: BOOLEAN` | Check default (deferred) |
| reset | `()` | Return to default |

## SIMPLE_FACTORY Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| new_instance | `: G` | Create fresh (deferred) |
| new_instance_from_string | `(spec: STRING): G` | From spec (deferred) |
| is_valid_specification | `(spec: STRING): BOOLEAN` | Validate (deferred) |
| matches_specification | `(obj: G; spec: STRING): BOOLEAN` | Match check (deferred) |
| was_recycled | `(obj: G): BOOLEAN` | Pool check |

## SIMPLE_TYPE_FACTORY Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `()` | Create factory |
| new_instance | `: G` | Create default |
| new_instance_from_string | `(spec: STRING): G` | From registered type |
| register_type | `(key: STRING; type: TYPE [G])` | Register type |
| has_type | `(key: STRING): BOOLEAN` | Key exists |
| type_for_key | `(key: STRING): TYPE [G]` | Get type |
| is_valid_specification | `(spec: STRING): BOOLEAN` | Key registered |
| matches_specification | `(obj: G; spec: STRING): BOOLEAN` | Type matches |

## SIMPLE_SINGLETON Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| instance | `: G` | Get singleton |
| is_initialized | `: BOOLEAN` | Created flag |
| reset_instance | `()` | Clear (dangerous) |
| new_instance | `: G` | Create (deferred) |

## SIMPLE_OBJECT_POOL Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `(capacity: INTEGER)` | Unbounded pool |
| make_bounded | `(capacity, max: INTEGER)` | Bounded pool |
| acquire | `: G` | Get from pool |
| release | `(obj: G)` | Return to pool |
| release_all | `()` | Return all |
| is_in_use | `(obj: G): BOOLEAN` | Check acquired |
| is_available | `(obj: G): BOOLEAN` | Check available |
| count | `: INTEGER` | Total objects |
| available_count | `: INTEGER` | Available count |
| in_use_count | `: INTEGER` | In-use count |
| is_at_capacity | `: BOOLEAN` | At max |
| can_acquire | `: BOOLEAN` | Can get object |
| model_available | `: MML_SET [G]` | Available model |
| model_in_use | `: MML_SET [G]` | In-use model |
| model_all | `: MML_SET [G]` | All objects model |

## SIMPLE_CACHED_VALUE Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `(factory: FUNCTION [K, G])` | Create with factory |
| item | `(key: K): G` | Get/compute value |
| is_cached | `(key: K): BOOLEAN` | In cache |
| invalidate | `(key: K)` | Remove entry |
| invalidate_all | `()` | Clear cache |
| cached_count | `: INTEGER` | Cache size |

## SIMPLE_ONCE_CELL Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `(factory: FUNCTION [G])` | Create with factory |
| item | `: G` | Get/compute value |
| is_computed | `: BOOLEAN` | Computed flag |
| invalidate | `()` | Force recompute |
