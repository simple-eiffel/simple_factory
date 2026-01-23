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
			model_empty: model_all.is_empty
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
			model_empty: model_all.is_empty
		end

feature -- Access

	acquire: G
			-- Get object from pool (creates if necessary)
		require
			can_acquire: can_acquire
		local
			l_old_available: MML_SET [G]
			l_old_in_use: MML_SET [G]
		do
			l_old_available := model_available
			l_old_in_use := model_in_use
			if available.is_empty then
				create Result.make_default
			else
				Result := available.item
				available.remove
			end
			in_use.extend (Result)
		ensure
			in_use_count_increased: in_use_count = old in_use_count + 1
			-- Model-based: Result is now in use
			model_result_in_use: model_in_use.has (Result)
			-- Model-based: Result was moved from available (if pool had available) or is new
			model_available_to_in_use: old available_count > 0 implies not model_available.has (Result)
			-- Model-based: in_use grew by exactly Result
			model_in_use_extended: model_in_use |=| (old model_in_use & Result)
		end

feature -- Modification

	release (a_object: G)
			-- Return object to pool
		require
			was_acquired: is_in_use (a_object)
		do
			in_use.prune_all (a_object)
			a_object.reset
			available.extend (a_object)
		ensure
			in_use_count_decreased: in_use_count = old in_use_count - 1
			available_count_increased: available_count = old available_count + 1
			object_reset: a_object.is_in_default_state
			-- Model-based: object moved from in_use to available
			model_no_longer_in_use: not model_in_use.has (a_object)
			model_now_available: model_available.has (a_object)
			model_in_use_shrunk: model_in_use |=| (old model_in_use / a_object)
			model_available_extended: model_available |=| (old model_available & a_object)
			-- Model-based: total objects unchanged
			model_count_preserved: model_all.count = old model_all.count
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
			-- Model-based: all objects now available
			model_in_use_empty: model_in_use.is_empty
			model_all_available: model_available |=| old model_all
			model_count_preserved: model_all.count = old model_all.count
		end

feature -- Status Query

	is_in_use (a_object: G): BOOLEAN
			-- Is `a_object` currently acquired?
		do
			Result := in_use.has (a_object)
		ensure
			definition: Result = model_in_use.has (a_object)
		end

	is_available (a_object: G): BOOLEAN
			-- Is `a_object` available for acquisition?
		do
			Result := across available as ic some ic = a_object end
		ensure
			definition: Result = model_available.has (a_object)
		end

feature -- Measurement

	count: INTEGER
			-- Total objects in pool (available + in use)
		do
			Result := available.count + in_use.count
		ensure
			definition: Result = available_count + in_use_count
			model_definition: Result = model_all.count
		end

	available_count: INTEGER
			-- Objects ready for acquisition
		do
			Result := available.count
		ensure
			model_definition: Result = model_available.count
		end

	in_use_count: INTEGER
			-- Objects currently acquired
		do
			Result := in_use.count
		ensure
			model_definition: Result = model_in_use.count
		end

feature -- Model Queries (Ghost/Specification)

	model_available: MML_SET [G]
			-- Mathematical model of available objects
		do
			create Result
			across available as ic loop
				Result := Result & ic
			end
		ensure
			count_matches: Result.count = available_count
		end

	model_in_use: MML_SET [G]
			-- Mathematical model of in-use objects
		do
			create Result
			across in_use as ic loop
				Result := Result & ic
			end
		ensure
			count_matches: Result.count = in_use_count
		end

	model_all: MML_SET [G]
			-- Mathematical model of all pooled objects
		do
			Result := model_available + model_in_use
		ensure
			definition: Result |=| (model_available + model_in_use)
			count_matches: Result.count = count
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
	-- Structural invariants
	count_consistent: count = available_count + in_use_count
	non_negative_counts: available_count >= 0 and in_use_count >= 0
	capacity_positive: initial_capacity > 0
	max_non_negative: max_capacity >= 0
	max_respects_count: max_capacity = 0 or else count <= max_capacity

	-- Model-based invariants
	model_partition: model_available.disjoint (model_in_use)
	model_count_consistent: model_all.count = available_count + in_use_count

end
