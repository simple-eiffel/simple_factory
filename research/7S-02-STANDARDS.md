# 7S-02: STANDARDS - simple_factory


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_factory

## Applicable Standards

### Gang of Four Design Patterns

#### Abstract Factory (GoF)
- Provide interface for creating families of objects
- Implementation: SIMPLE_FACTORY [G]

#### Singleton (GoF)
- Ensure class has only one instance
- Implementation: SIMPLE_SINGLETON [G], SIMPLE_SHARED_SINGLETON [G]

#### Object Pool (GoF variant)
- Reuse expensive objects
- Implementation: SIMPLE_OBJECT_POOL [G]

### OOSC2 Patterns

#### Once Functions
- Compute value once, cache forever
- Implementation: SIMPLE_ONCE_CELL [G]

#### Design by Contract
- Preconditions, postconditions, invariants
- Implementation: All classes

### Model-Based Specification

#### MML Integration
- Mathematical models for contracts
- MML_SET for pool membership
- MML_MAP for registry/cache

## Implementation Status

| Pattern | Coverage | Notes |
|---------|----------|-------|
| Abstract Factory | Complete | SIMPLE_FACTORY |
| Type Factory | Complete | SIMPLE_TYPE_FACTORY |
| Singleton | Complete | SIMPLE_SINGLETON |
| Shared Singleton | Complete | SIMPLE_SHARED_SINGLETON |
| Object Pool | Complete | SIMPLE_OBJECT_POOL |
| Lazy Value | Complete | SIMPLE_ONCE_CELL |
| Keyed Cache | Complete | SIMPLE_CACHED_VALUE |

## Compliance Notes

- Singleton NOT SCOOP-safe (documented)
- Object pool uses MML for model contracts
- Type factory uses TYPE manifests
