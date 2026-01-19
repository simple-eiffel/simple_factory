<p align="center">
  <img src="docs/images/logo.png" alt="simple_factory logo" width="200">
</p>

<h1 align="center">simple_factory</h1>

<p align="center">
  <a href="https://simple-eiffel.github.io/simple_factory/">Documentation</a> â€¢
  <a href="https://github.com/simple-eiffel/simple_factory">GitHub</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Eiffel-25.02-purple.svg" alt="Eiffel 25.02">
  <img src="https://img.shields.io/badge/DBC-Contracts-green.svg" alt="Design by Contract">
</p>

Object creation patterns for Eiffel: factories, singletons, object pools, and lazy initialization.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

âœ… **Production Ready** â€” v1.0.0
- 53 tests passing, full coverage
- Design by Contract throughout
- Void-safe implementation

## Overview

SIMPLE_FACTORY provides battle-tested creational design patterns for Eiffel applications:

- **Factory Pattern** - Abstract and concrete factories for type-safe object creation
- **Singleton Pattern** - Lazy-initialized singletons with proper encapsulation
- **Object Pool** - Reusable object pooling for expensive-to-create objects
- **Lazy Initialization** - Once cells and cached values for deferred computation

## Quick Start

### Factory Pattern

```eiffel
class MY_OBJECT inherit SIMPLE_CREATABLE
feature
    make_default do value := 0 end
    is_in_default_state: BOOLEAN do Result := value = 0 end
    value: INTEGER
end

-- Usage:
local
    factory: SIMPLE_TYPE_FACTORY [MY_OBJECT]
do
    create factory.make
    factory.register_type ("my_type", {MY_OBJECT})
    
    -- Create by type key
    if factory.is_valid_specification ("my_type") then
        my_obj := factory.new_instance_from_string ("my_type")
    end
    
    -- Or create directly
    my_obj := factory.new_instance
end
```

### Object Pool

```eiffel
local
    pool: SIMPLE_OBJECT_POOL [MY_OBJECT]
    obj: MY_OBJECT
do
    -- Unbounded pool
    create pool.make (10)
    
    -- Or bounded pool (max 100 objects)
    create pool.make_bounded (10, 100)
    
    -- Acquire/release pattern
    obj := pool.acquire
    -- use obj...
    pool.release (obj)  -- Object reset and returned to pool
end
```

### Lazy Initialization

```eiffel
local
    cell: SIMPLE_ONCE_CELL [EXPENSIVE_RESOURCE]
do
    -- Value computed only when first accessed
    create cell.make (agent compute_expensive_resource)
    
    if cell.is_computed then
        print ("Already computed")
    end
    
    resource := cell.item  -- Computes on first access
    resource := cell.item  -- Returns cached value
    
    cell.invalidate  -- Force recomputation on next access
end
```

### Keyed Cache

```eiffel
local
    cache: SIMPLE_CACHED_VALUE [PARSED_DATA, STRING]
do
    create cache.make (agent parse_file)
    
    data := cache.item ("config.json")  -- Parses file
    data := cache.item ("config.json")  -- Returns cached
    
    cache.invalidate ("config.json")    -- Remove from cache
    cache.invalidate_all                -- Clear all cached values
end
```

## API Reference

### SIMPLE_FACTORY [G]
Abstract base for factories creating objects of type G.

| Feature | Description |
|---------|-------------|
| `new_instance: G` | Create fresh instance |
| `new_instance_from_string (spec): G` | Create from string specification |
| `is_valid_specification (spec): BOOLEAN` | Can spec create an instance? |

### SIMPLE_TYPE_FACTORY [G]
Concrete factory using TYPE manifests.

| Feature | Description |
|---------|-------------|
| `make` | Create factory with empty type table |
| `register_type (key, type)` | Register TYPE for creation via key |
| `has_type (key): BOOLEAN` | Is type registered for key? |
| `type_for_key (key): TYPE [G]` | Get registered TYPE |

### SIMPLE_OBJECT_POOL [G]
Reusable object pool.

| Feature | Description |
|---------|-------------|
| `make (capacity)` | Create unbounded pool |
| `make_bounded (capacity, max)` | Create pool with max size |
| `acquire: G` | Get object from pool |
| `release (obj)` | Return object to pool |
| `release_all` | Return all objects |
| `count`, `available_count`, `in_use_count` | Pool metrics |

### SIMPLE_ONCE_CELL [G]
Lazy initialization container.

| Feature | Description |
|---------|-------------|
| `make (factory)` | Create with factory function |
| `item: G` | Get value (computes if needed) |
| `is_computed: BOOLEAN` | Has value been computed? |
| `invalidate` | Force recomputation |

### SIMPLE_CACHED_VALUE [G, K]
Keyed cache with automatic computation.

| Feature | Description |
|---------|-------------|
| `make (factory)` | Create with factory function |
| `item (key): G` | Get cached or compute value |
| `is_cached (key): BOOLEAN` | Is value in cache? |
| `invalidate (key)` | Remove from cache |
| `invalidate_all` | Clear entire cache |
| `cached_count: INTEGER` | Number of cached values |

### SIMPLE_SINGLETON [G]
Singleton holder with lazy initialization.

| Feature | Description |
|---------|-------------|
| `instance: G` | The singleton instance |
| `is_initialized: BOOLEAN` | Has instance been created? |
| `reset_instance` | Clear singleton (testing only) |

### SIMPLE_CREATABLE
Interface for factory-creatable objects.

| Feature | Description |
|---------|-------------|
| `make_default` | Initialize with defaults |
| `is_in_default_state: BOOLEAN` | Is in default state? |
| `reset` | Return to default state |

## Installation

1. Set the ecosystem environment variable:
```
SIMPLE_EIFFEL=D:\prod
```

2. Add to your ECF:
```xml
<library name="simple_factory" location="$SIMPLE_EIFFEL/simple_factory/simple_factory.ecf"/>
```

## Dependencies

None. Uses only EiffelBase from the standard library.

## License

MIT License - see [LICENSE](LICENSE) file.

---

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.
