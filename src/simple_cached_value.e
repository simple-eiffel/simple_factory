note
	description: "Keyed cache with automatic computation"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_CACHED_VALUE [G, K -> HASHABLE]

create
	make

feature {NONE} -- Initialization

	make (a_factory: FUNCTION [K, G])
			-- Create with factory that computes value from key
			-- Note: a_factory is attached by default in void-safe mode
		do
			factory := a_factory
			create cache.make (Default_cache_capacity)
		ensure
			factory_set: factory = a_factory
			cache_empty: cache.is_empty
		end

feature -- Access

	item (a_key: K): G
			-- Value for `a_key`, computed if not cached
			-- Note: a_key is attached by K -> HASHABLE constraint
		do
			if attached cache.item (a_key) as l_value then
				Result := l_value
			else
				Result := factory.item ([a_key])
				cache.put (Result, a_key)
			end
		ensure
			is_cached: is_cached (a_key)
		end

feature -- Status Query

	is_cached (a_key: K): BOOLEAN
			-- Is value for `a_key` in cache?
			-- Note: a_key is attached by K -> HASHABLE constraint
		do
			Result := cache.has (a_key)
		end

feature -- Modification

	invalidate (a_key: K)
			-- Remove `a_key` from cache
			-- Note: a_key is attached by K -> HASHABLE constraint
		do
			cache.remove (a_key)
		ensure
			not_cached: not is_cached (a_key)
		end

	invalidate_all
			-- Clear entire cache
		do
			cache.wipe_out
		ensure
			cache_empty: cache.is_empty
			count_zero: cached_count = 0
		end

feature -- Measurement

	cached_count: INTEGER
			-- Number of cached values
		do
			Result := cache.count
		end

feature {NONE} -- Implementation

	factory: FUNCTION [K, G]
			-- Factory function

	cache: HASH_TABLE [G, K]
			-- Cached values

feature {NONE} -- Constants

	Default_cache_capacity: INTEGER = 10
			-- Initial capacity for cache hash table

invariant
	-- Note: factory and cache are attached by default in void-safe mode
	count_non_negative: cached_count >= 0

end
