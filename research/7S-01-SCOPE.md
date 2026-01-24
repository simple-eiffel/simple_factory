# 7S-01: SCOPE - simple_factory


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Problem Domain

Object creation patterns for Eiffel applications. The library provides factory, singleton, object pool, and caching patterns with proper Design by Contract support.

## Target Users

- Eiffel developers needing controlled object creation
- Applications with expensive object instantiation
- Systems requiring singleton guarantees
- Performance-critical code with object reuse needs

## Problem Statement

Creating objects in Eiffel requires boilerplate. Developers need:
1. Abstract factory pattern for type-safe creation
2. Singleton pattern with lazy initialization
3. Object pooling for expensive resources
4. Lazy value computation with caching

## Boundaries

### In Scope
- Abstract factory base class (SIMPLE_FACTORY)
- Concrete type-based factory (SIMPLE_TYPE_FACTORY)
- Singleton holder (SIMPLE_SINGLETON)
- Shared singleton via inheritance (SIMPLE_SHARED_SINGLETON)
- Object pool with acquire/release (SIMPLE_OBJECT_POOL)
- Keyed cache with lazy computation (SIMPLE_CACHED_VALUE)
- Once cell for lazy values (SIMPLE_ONCE_CELL)
- Creatable mixin interface (SIMPLE_CREATABLE)

### Out of Scope
- Dependency injection container
- Service locator pattern
- Builder pattern
- Prototype pattern
- SCOOP-safe singleton (documented limitation)

## Success Criteria

1. Type-safe factory creation
2. Proper singleton guarantees (single-threaded)
3. Efficient object pooling
4. MML-based model contracts
5. Clean API with DBC

## Dependencies

- EiffelBase (ARRAYED_STACK, ARRAYED_LIST, HASH_TABLE)
- MML (MML_SET, MML_MAP for contracts)
