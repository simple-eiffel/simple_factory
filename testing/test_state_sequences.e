note
	description: "State sequence tests for operation ordering"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_STATE_SEQUENCES

create
	make

feature {NONE} -- Initialization

	make
			-- Run state sequence tests
		do
			print ("Running state sequence tests...%N%N")
			run_all_tests
			print ("%N========================%N")
			print ("State Sequence Results: " + pass_count.out + " passed, " + fail_count.out + " failed%N")
		end

feature -- Test Execution

	run_all_tests
			-- Run all state sequence test cases
		do
			-- Pool state sequences
			test_pool_sequence_acquire_acquire_release_release
			test_pool_sequence_mixed_operations
			test_pool_sequence_release_all_then_acquire

			-- Cache state sequences
			test_cache_sequence_invalidate_access_invalidate
			test_cache_sequence_invalidate_all_then_populate

			-- Once cell state sequences
			test_once_cell_sequence_access_invalidate_access
			test_once_cell_fresh_after_creation
		end

feature -- Pool State Sequences

	test_pool_sequence_acquire_acquire_release_release
			-- Test A-A-R-R sequence
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2: TEST_OBJECT
		do
			print ("  test_pool_sequence_acquire_acquire_release_release: ")
			create l_pool.make (5)

			-- Acquire two
			l_obj1 := l_pool.acquire
			l_obj2 := l_pool.acquire

			-- Release in same order
			l_pool.release (l_obj1)
			l_pool.release (l_obj2)

			if l_pool.count = 2 and l_pool.available_count = 2 and l_pool.in_use_count = 0 then
				report_pass
			else
				report_fail ("after A-A-R-R: count=" + l_pool.count.out + " avail=" + l_pool.available_count.out)
			end
		end

	test_pool_sequence_mixed_operations
			-- Test interleaved acquire/release
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2, l_obj3: TEST_OBJECT
		do
			print ("  test_pool_sequence_mixed_operations: ")
			create l_pool.make (5)

			l_obj1 := l_pool.acquire  -- in_use=1
			l_obj2 := l_pool.acquire  -- in_use=2
			l_pool.release (l_obj1)   -- in_use=1, avail=1
			l_obj3 := l_pool.acquire  -- in_use=2, avail=0 (reuses l_obj1)
			l_pool.release (l_obj2)   -- in_use=1, avail=1

			if l_pool.in_use_count = 1 and l_pool.available_count = 1 then
				-- l_obj3 should be the reused l_obj1
				if l_obj3 = l_obj1 then
					report_pass
				else
					report_fail ("object should be reused from available stack")
				end
			else
				report_fail ("counts wrong: in_use=" + l_pool.in_use_count.out + " avail=" + l_pool.available_count.out)
			end
		end

	test_pool_sequence_release_all_then_acquire
			-- Test release_all followed by acquire
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2, l_obj3: TEST_OBJECT
		do
			print ("  test_pool_sequence_release_all_then_acquire: ")
			create l_pool.make (5)

			l_obj1 := l_pool.acquire
			l_obj2 := l_pool.acquire
			l_pool.release_all

			-- Now acquire should reuse from available
			l_obj3 := l_pool.acquire

			if l_pool.count = 2 and l_pool.in_use_count = 1 and (l_obj3 = l_obj1 or l_obj3 = l_obj2) then
				report_pass
			else
				report_fail ("should reuse released object")
			end
		end

feature -- Cache State Sequences

	test_cache_sequence_invalidate_access_invalidate
			-- Test I-A-I sequence
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
		do
			print ("  test_cache_sequence_invalidate_access_invalidate: ")
			counter := 0
			create l_cache.make (agent seq_factory)

			l_cache.invalidate (1)  -- No-op (not cached)
			l_value := l_cache.item (1)  -- Computes
			l_cache.invalidate (1)  -- Removes

			if counter = 1 and not l_cache.is_cached (1) then
				report_pass
			else
				report_fail ("expected 1 computation, not cached")
			end
		end

	test_cache_sequence_invalidate_all_then_populate
			-- Test invalidate_all then repopulate
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
			i: INTEGER
		do
			print ("  test_cache_sequence_invalidate_all_then_populate: ")
			counter := 0
			create l_cache.make (agent seq_factory)

			-- Populate
			from i := 1 until i > 5 loop
				l_value := l_cache.item (i)
				i := i + 1
			end

			l_cache.invalidate_all

			-- Repopulate same keys
			from i := 1 until i > 5 loop
				l_value := l_cache.item (i)
				i := i + 1
			end

			if counter = 10 and l_cache.cached_count = 5 then
				report_pass
			else
				report_fail ("expected 10 computations, 5 cached")
			end
		end

feature -- Once Cell State Sequences

	test_once_cell_sequence_access_invalidate_access
			-- Test A-I-A sequence
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_val1, l_val2: STRING
		do
			print ("  test_once_cell_sequence_access_invalidate_access: ")
			counter := 0
			create l_cell.make (agent seq_cell_factory)

			l_val1 := l_cell.item
			l_cell.invalidate
			l_val2 := l_cell.item

			if counter = 2 and l_val1 /= l_val2 then
				report_pass
			else
				report_fail ("should compute twice with different results")
			end
		end

	test_once_cell_fresh_after_creation
			-- Test cell is not computed immediately after creation
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
		do
			print ("  test_once_cell_fresh_after_creation: ")
			counter := 0
			create l_cell.make (agent seq_cell_factory)

			-- Factory should NOT be called yet
			if counter = 0 and not l_cell.is_computed then
				report_pass
			else
				report_fail ("factory should not be called until item accessed")
			end
		end

feature -- Test Results

	pass_count: INTEGER
	fail_count: INTEGER

feature {NONE} -- Test Infrastructure

	counter: INTEGER

	seq_factory (a_k: INTEGER): STRING
		do
			counter := counter + 1
			Result := "seq_" + a_k.out + "_" + counter.out
		end

	seq_cell_factory: STRING
		do
			counter := counter + 1
			Result := "cell_" + counter.out
		end

	report_pass
		do
			pass_count := pass_count + 1
			print ("PASS%N")
		end

	report_fail (a_reason: STRING)
		do
			fail_count := fail_count + 1
			print ("FAIL - " + a_reason + "%N")
		end

end
