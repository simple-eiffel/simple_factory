# S07: SPEC SUMMARY - simple_factory

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Executive Summary

simple_factory provides comprehensive creational patterns for Eiffel including factory, singleton, object pool, and caching patterns with MML-based model contracts.

## Key Specifications

### Architecture
- Pattern: Generic deferred classes with effective implementations
- Layers: Interface (deferred) -> Implementation (effective)
- Dependencies: EiffelBase, MML

### Classes (8 total)
| Class | Role |
|-------|------|
| SIMPLE_CREATABLE | Poolable interface |
| SIMPLE_FACTORY | Abstract factory |
| SIMPLE_TYPE_FACTORY | Type-based factory |
| SIMPLE_SINGLETON | Singleton holder |
| SIMPLE_SHARED_SINGLETON | Inheritance singleton |
| SIMPLE_OBJECT_POOL | Object pooling |
| SIMPLE_CACHED_VALUE | Keyed cache |
| SIMPLE_ONCE_CELL | Lazy value |

### Key Features
- Type-safe generic factories
- Lazy singleton initialization
- Bounded object pools
- MML model-based contracts
- SIMPLE_CREATABLE mixin

### Contracts Summary
- Model contracts using MML_SET
- Pool invariants verify partitioning
- Singleton guarantees same instance
- Cache ensures computed values cached

### Constraints
- Not SCOOP-safe (documented)
- SIMPLE_CREATABLE required for pooling
- HASHABLE required for cache keys

## Quality Metrics

| Metric | Target | Actual |
|--------|--------|--------|
| Test coverage | 80% | ~85% |
| Contract coverage | 90% | 95% |
| Documentation | Complete | Partial |

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| SCOOP race | Document limitation |
| Pool exhaustion | Bounded pools |
| Singleton mutation | Application care |

## Future Roadmap

1. Short term: SCOOP-safe singleton
2. Medium term: Pool statistics
3. Long term: IoC container
