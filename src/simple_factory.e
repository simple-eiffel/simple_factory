note
	description: "Abstract factory base class for creating objects of type G"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_FACTORY [G -> SIMPLE_CREATABLE]

feature -- Factory

	new_instance: G
			-- Create fresh instance
		deferred
		ensure
			result_exists: Result /= Void
			is_fresh: not was_recycled (Result)
		end

	new_instance_from_string (a_spec: READABLE_STRING_GENERAL): G
			-- Create instance from string specification
		require
			valid_spec: is_valid_specification (a_spec)
		deferred
		ensure
			matches_spec: matches_specification (Result, a_spec)
		end

feature -- Status Query

	is_valid_specification (a_spec: READABLE_STRING_GENERAL): BOOLEAN
			-- Can `a_spec` be used to create an instance?
			-- Note: a_spec is attached by default in void-safe mode
		deferred
		end

feature -- Contract Support

	matches_specification (a_object: G; a_spec: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_object` match `a_spec`?
			-- Note: Parameters are attached by default in void-safe mode
		deferred
		end

	was_recycled (a_object: G): BOOLEAN
			-- Was `a_object` returned from a pool rather than freshly created?
			-- Note: a_object is attached by default in void-safe mode
		do
			Result := False
		end

end
