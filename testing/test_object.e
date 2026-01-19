note
	description: "Concrete SIMPLE_CREATABLE for testing purposes"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_OBJECT

inherit
	SIMPLE_CREATABLE

create
	make_default

feature -- Initialization

	make_default
			-- Initialize with default values
		do
			value := 0
			name := "default"
		ensure then
			value_zero: value = 0
			name_default: name.same_string ("default")
		end

feature -- Access

	value: INTEGER
			-- Test value

	name: STRING
			-- Test name

feature -- Status Query

	is_in_default_state: BOOLEAN
			-- Is object in its default initialized state?
		do
			Result := value = 0 and name.same_string ("default")
		end

feature -- Modification

	set_value (a_value: INTEGER)
			-- Set `value` to `a_value`
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

	set_name (a_name: STRING)
			-- Set `name` to `a_name`
		require
			name_exists: a_name /= Void
		do
			name := a_name
		ensure
			name_set: name = a_name
		end

invariant
	name_exists: name /= Void

end
