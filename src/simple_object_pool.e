note
	description: "Reusable object pool for expensive-to-create objects"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_OBJECT_POOL [G -> SIMPLE_CREATABLE create make_default end]

create
	make,
	make_bounded

feature {NONE} -- Initialization

	make (a_capacity: INTEGER)
			-- Create pool with initial capacity and no max limit
		require
			positive_capacity: a_capacity > 0
		do
			create available.make (a_capacity)
			create in_use.make (a_capacity)
			initial_capacity := a_capacity
			max_capacity := 0  -- 0 means unlimited
		ensure
			empty: count = 0
			capacity_set: initial_capacity = a_capacity
			unlimited: max_capacity = 0
		end

	make_bounded (a_capacity: INTEGER; a_max: INTEGER)
			-- Create pool with initial capacity and maximum size
		require
			positive_capacity: a_capacity > 0
			valid_max: a_max >= a_capacity
		do
			create available.make (a_capacity)
			create in_use.make (a_capacity)
			initial_capacity := a_capacity
			max_capacity := a_max
		ensure
			empty: count = 0
			capacity_set: initial_capacity = a_capacity
			max_set: max_capacity = a_max
		end

feature -- Access

	acquire: G
			-- Get object from pool (creates if necessary)
		require
			can_acquire: can_acquire
		do
			if available.is_empty then
				create Result.make_default
			else
				Result := available.item
				available.remove
			end
			in_use.extend (Result)
		ensure
			result_exists: Result /= Void
			in_use_count_increased: in_use_count = old in_use_count + 1
		end

feature -- Modification

	release (a_object: G)
			-- Return object to pool
		require
			object_exists: a_object /= Void
			was_acquired: is_in_use (a_object)
		do
			in_use.prune_all (a_object)
			a_object.reset
			available.extend (a_object)
		ensure
			in_use_count_decreased: in_use_count = old in_use_count - 1
			available_count_increased: available_count = old available_count + 1
			object_reset: a_object.is_in_default_state
		end

	release_all
			-- Return all objects to pool
		do
			across in_use as ic_obj loop
				ic_obj.reset
				available.extend (ic_obj)
			end
			in_use.wipe_out
		ensure
			none_in_use: in_use_count = 0
			total_preserved: count = old count
		end

feature -- Status Query

	is_in_use (a_object: G): BOOLEAN
			-- Is `a_object` currently acquired?
		require
			object_exists: a_object /= Void
		do
			Result := in_use.has (a_object)
		end

feature -- Measurement

	count: INTEGER
			-- Total objects in pool (available + in use)
		do
			Result := available.count + in_use.count
		end

	available_count: INTEGER
			-- Objects ready for acquisition
		do
			Result := available.count
		end

	in_use_count: INTEGER
			-- Objects currently acquired
		do
			Result := in_use.count
		end

feature {NONE} -- Implementation

	available: ARRAYED_STACK [G]
			-- Pool of available objects

	in_use: ARRAYED_LIST [G]
			-- Currently acquired objects

	initial_capacity: INTEGER
			-- Initial pool capacity

	max_capacity: INTEGER
			-- Maximum pool size (0 = unlimited)

feature -- Status Query (Capacity)

	is_at_capacity: BOOLEAN
			-- Is pool at maximum capacity?
		do
			Result := max_capacity > 0 and then count >= max_capacity
		end

	can_acquire: BOOLEAN
			-- Can another object be acquired?
		do
			Result := available_count > 0 or else not is_at_capacity
		end

invariant
	count_consistent: count = available_count + in_use_count
	non_negative_counts: available_count >= 0 and in_use_count >= 0
	available_exists: available /= Void
	in_use_exists: in_use /= Void
	capacity_positive: initial_capacity > 0
	max_non_negative: max_capacity >= 0
	max_respects_count: max_capacity = 0 or else count <= max_capacity

end
