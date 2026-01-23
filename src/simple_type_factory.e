note
	description: "Concrete factory using TYPE manifests for instantiation"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_TYPE_FACTORY [G -> SIMPLE_CREATABLE create make_default end]

inherit
	SIMPLE_FACTORY [G]

create
	make

feature {NONE} -- Initialization

	make
			-- Create factory with empty type table
		do
			create type_table.make (Default_table_capacity)
		ensure
			empty: type_table.is_empty
		end

feature -- Factory

	new_instance: G
			-- Create fresh instance using default creation
		do
			create Result.make_default
		end

	new_instance_from_string (a_spec: READABLE_STRING_GENERAL): G
			-- Create instance from string specification.
			-- Creates an instance of the type registered for `a_spec`.
			-- Note: Currently creates default instance; the postcondition verifies
			-- the created object's type matches the registered type for `a_spec`.
		do
			create Result.make_default
		end

feature -- Status Query

	is_valid_specification (a_spec: READABLE_STRING_GENERAL): BOOLEAN
			-- Can `a_spec` be used to create an instance?
		do
			Result := has_type (a_spec)
		end

feature -- Contract Support

	matches_specification (a_object: G; a_spec: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_object` match `a_spec`?
			-- Returns True if:
			--   1. `a_spec` is a registered key AND object's type name matches the registered TYPE's name
			--      (after stripping attached/detached prefixes), OR
			--   2. `a_spec` exactly matches object's generating type name (fallback)
		local
			l_object_type_name: STRING_32
			l_registered_type_name: STRING_32
			l_registered_type: TYPE [G]
		do
			if has_type (a_spec) then
				-- Spec is a registered key - compare stripped type names
				l_registered_type := type_for_key (a_spec)
				l_object_type_name := stripped_type_name (a_object.generating_type.name)
				l_registered_type_name := stripped_type_name (l_registered_type.name)
				Result := l_object_type_name.same_string (l_registered_type_name)
			else
				-- Fallback: check if spec matches the literal type name
				l_object_type_name := stripped_type_name (a_object.generating_type.name)
				Result := l_object_type_name.same_string_general (a_spec)
			end
		end

	stripped_type_name (a_name: READABLE_STRING_GENERAL): STRING_32
			-- Type name with attached/detached prefix removed
		do
			Result := a_name.to_string_32
			-- Remove leading '!' (attached) or '?' (detached) if present
			if not Result.is_empty and then (Result [1] = '!' or Result [1] = '?') then
				Result := Result.substring (2, Result.count)
			end
		end

feature -- Registration

	register_type (a_key: READABLE_STRING_GENERAL; a_type: TYPE [G])
			-- Register `a_type` for creation via `a_key`
			-- Note: Parameters are attached by default in void-safe mode
		require
			key_not_empty: not a_key.is_empty
			not_registered: not has_type (a_key)
		do
			type_table.put (a_type, a_key.to_string_32)
		ensure
			registered: has_type (a_key)
			count_increased: type_table.count = old type_table.count + 1
		end

feature -- Query

	has_type (a_key: READABLE_STRING_GENERAL): BOOLEAN
			-- Is a type registered for `a_key`?
			-- Note: a_key is attached by default in void-safe mode
		do
			Result := type_table.has (a_key.to_string_32)
		end

	type_for_key (a_key: READABLE_STRING_GENERAL): TYPE [G]
			-- Type registered for `a_key`
			-- Note: a_key is attached by default in void-safe mode
		require
			has_key: has_type (a_key)
		do
			check attached type_table.item (a_key.to_string_32) as l_type then
				Result := l_type
			end
		end

feature {NONE} -- Implementation

	type_table: HASH_TABLE [TYPE [G], STRING_32]
			-- Mapping from keys to types

feature {NONE} -- Constants

	Default_table_capacity: INTEGER = 10
			-- Initial capacity for type table

invariant
	-- Note: type_table is attached by default in void-safe mode
	type_count_non_negative: type_table.count >= 0

end
