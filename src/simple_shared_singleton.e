note
	description: "Inheritance-based shared singleton access"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_SHARED_SINGLETON [G]

feature -- Access

	shared_instance: G
			-- The shared singleton instance
		do
			if attached once_instance as l_instance then
				Result := l_instance
			else
				Result := new_shared_instance
				once_instance := Result
			end
		ensure
			same_instance: Result = shared_instance
			initialized: is_shared_initialized
		end

feature -- Status Query

	is_shared_initialized: BOOLEAN
			-- Has shared instance been created?
		do
			Result := once_instance /= Void
		end

feature {NONE} -- Implementation

	once_instance: detachable G
			-- Once-per-process cached instance
		attribute
		end

	new_shared_instance: G
			-- Create the shared singleton instance
		deferred
		ensure
			result_exists: Result /= Void
		end

end
