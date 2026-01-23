note
	description: "Lazy initialization container for expensive computations"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ONCE_CELL [G]

create
	make

feature {NONE} -- Initialization

	make (a_factory: FUNCTION [G])
			-- Create with factory function
			-- Note: a_factory is attached by default in void-safe mode
		do
			factory := a_factory
			is_invalidated := True
		ensure
			factory_set: factory = a_factory
			not_computed: not is_computed
		end

feature -- Access

	item: G
			-- The lazily-computed value
		do
			if not is_invalidated and then attached cached_value as l_value then
				Result := l_value
			else
				Result := factory.item ([])
				cached_value := Result
				is_invalidated := False
			end
		ensure
			is_computed: is_computed
		end

feature -- Status Query

	is_computed: BOOLEAN
			-- Has value been computed?
		do
			Result := not is_invalidated and then cached_value /= Void
		end

feature -- Modification

	invalidate
			-- Force recomputation on next access
		do
			is_invalidated := True
		ensure
			not_computed: not is_computed
		end

feature {NONE} -- Implementation

	factory: FUNCTION [G]
			-- Factory function for creating value

	cached_value: detachable G
			-- Cached computed value

	is_invalidated: BOOLEAN
			-- Has cache been invalidated?

invariant
	-- Note: factory is attached by default in void-safe mode
	invalidation_state_consistent: is_invalidated implies not is_computed

end
