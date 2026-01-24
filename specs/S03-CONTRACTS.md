# S03: CONTRACTS - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## SIMPLE_FACTORY Contracts

### new_instance
```eiffel
ensure
    result_exists: Result /= Void
    is_fresh: not was_recycled (Result)
```

### new_instance_from_string
```eiffel
require
    valid_spec: is_valid_specification (a_spec)
ensure
    matches_spec: matches_specification (Result, a_spec)
```

---

## SIMPLE_OBJECT_POOL Contracts

### Invariants
```eiffel
invariant
    count_consistent: count = available_count + in_use_count
    non_negative_counts: available_count >= 0 and in_use_count >= 0
    capacity_positive: initial_capacity > 0
    max_non_negative: max_capacity >= 0
    max_respects_count: max_capacity = 0 or else count <= max_capacity
    model_partition: model_available.disjoint (model_in_use)
    model_count_consistent: model_all.count = available_count + in_use_count
```

### acquire
```eiffel
require
    can_acquire: can_acquire
ensure
    in_use_count_increased: in_use_count = old in_use_count + 1
    model_result_in_use: model_in_use.has (Result)
    model_available_to_in_use: old available_count > 0 implies not model_available.has (Result)
    model_in_use_extended: model_in_use |=| (old model_in_use & Result)
```

### release
```eiffel
require
    was_acquired: is_in_use (a_object)
ensure
    in_use_count_decreased: in_use_count = old in_use_count - 1
    available_count_increased: available_count = old available_count + 1
    object_reset: a_object.is_in_default_state
    model_no_longer_in_use: not model_in_use.has (a_object)
    model_now_available: model_available.has (a_object)
    model_count_preserved: model_all.count = old model_all.count
```

---

## SIMPLE_SINGLETON Contracts

### instance
```eiffel
ensure
    same_instance: Result = instance
    initialized: is_initialized
```

### reset_instance
```eiffel
ensure
    not_initialized: not is_initialized
```

---

## SIMPLE_CREATABLE Contracts

### make_default
```eiffel
ensure
    is_default: is_in_default_state
```

### reset
```eiffel
ensure
    is_default: is_in_default_state
```

---

## SIMPLE_CACHED_VALUE Contracts

### item
```eiffel
ensure
    is_cached: is_cached (a_key)
```

### invalidate
```eiffel
ensure
    not_cached: not is_cached (a_key)
```

### invalidate_all
```eiffel
ensure
    cache_empty: cache.is_empty
    count_zero: cached_count = 0
```

---

## SIMPLE_ONCE_CELL Contracts

### item
```eiffel
ensure
    is_computed: is_computed
```

### invalidate
```eiffel
ensure
    not_computed: not is_computed
```
