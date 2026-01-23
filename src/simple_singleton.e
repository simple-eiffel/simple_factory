note
	description: "Singleton holder with lazy initialization"
	warning: "Not SCOOP-safe. For SCOOP environments, use separate regions."
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_SINGLETON [G]

feature -- Access

	instance: G
			-- The singleton instance
		do
			if attached internal_instance as l_instance then
				Result := l_instance
			else
				Result := new_instance
				internal_instance := Result
			end
		ensure
			same_instance: Result = instance
			initialized: is_initialized
		end

feature -- Status Query

	is_initialized: BOOLEAN
			-- Has instance been created?
		do
			Result := internal_instance /= Void
		end

feature -- Modification

	reset_instance
			-- Clear singleton (use with caution)
			-- WARNING: This breaks singleton contract for existing references!
			-- Only use for testing or controlled shutdown scenarios.
			-- Note: Implementation uses default_value workaround for void-safe generic reset.
		local
			l_default: detachable G
		do
			internal_instance := l_default
		ensure
			not_initialized: not is_initialized
		end

feature {NONE} -- Implementation

	internal_instance: detachable G
			-- Cached instance
		attribute
		end

	new_instance: G
			-- Create the singleton instance
		deferred
		ensure
			result_exists: Result /= Void
		end

end
