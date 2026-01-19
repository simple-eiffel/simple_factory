note
	description: "Mixin interface for objects that can be created by factories"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_CREATABLE

feature -- Initialization

	make_default
			-- Initialize with default values
		deferred
		ensure
			is_default: is_in_default_state
		end

feature -- Status Query

	is_in_default_state: BOOLEAN
			-- Is object in its default initialized state?
		deferred
		end

feature -- Resetting

	reset
			-- Return to default state (for pooling)
		do
			make_default
		ensure
			is_default: is_in_default_state
		end

end
