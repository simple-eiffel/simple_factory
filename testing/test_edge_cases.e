note
	description: "Edge case tests probing boundary conditions"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_EDGE_CASES

create
	make

feature {NONE} -- Initialization

	make
			-- Run edge case tests
		do
			print ("Running edge case tests...%N%N")
			run_all_tests
			print ("%N========================%N")
			print ("Edge Case Results: " + pass_count.out + " passed, " + fail_count.out + " failed%N")
		end

feature -- Test Execution

	run_all_tests
			-- Run all edge case test cases
		do
			-- Pool edge cases
			test_pool_single_capacity
			test_pool_bounded_equals_initial
			test_pool_acquire_release_acquire
			test_pool_acquire_same_object_check

			-- Cache edge cases
			test_cache_zero_key
			test_cache_negative_key
			test_cache_invalidate_nonexistent

			-- Once cell edge cases
			test_once_cell_multiple_invalidate
			test_once_cell_access_after_invalidate
		end

feature -- Pool Edge Cases

	test_pool_single_capacity
			-- Test pool with capacity of 1
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj: TEST_OBJECT
		do
			print ("  test_pool_single_capacity: ")
			create l_pool.make (1)
			l_obj := l_pool.acquire
			l_pool.release (l_obj)
			l_obj := l_pool.acquire
			if l_pool.count = 1 then
				report_pass
			else
				report_fail ("pool should have exactly 1 object")
			end
		end

	test_pool_bounded_equals_initial
			-- Test bounded pool where max equals initial
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj: TEST_OBJECT
		do
			print ("  test_pool_bounded_equals_initial: ")
			create l_pool.make_bounded (5, 5)
			-- Acquire 5 objects (max)
			from until l_pool.is_at_capacity loop
				l_obj := l_pool.acquire
			end
			if l_pool.count = 5 and not l_pool.can_acquire then
				report_pass
			else
				report_fail ("pool at max=5 should not allow more acquires")
			end
		end

	test_pool_acquire_release_acquire
			-- Test acquire-release-acquire cycle returns same object
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2: TEST_OBJECT
		do
			print ("  test_pool_acquire_release_acquire: ")
			create l_pool.make (5)
			l_obj1 := l_pool.acquire
			l_pool.release (l_obj1)
			l_obj2 := l_pool.acquire
			if l_obj1 = l_obj2 then
				report_pass
			else
				report_fail ("same object should be returned")
			end
		end

	test_pool_acquire_same_object_check
			-- Verify same object cannot be acquired twice
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2: TEST_OBJECT
		do
			print ("  test_pool_acquire_same_object_check: ")
			create l_pool.make (5)
			l_obj1 := l_pool.acquire
			l_obj2 := l_pool.acquire
			-- Both should be different objects
			if l_obj1 /= l_obj2 then
				report_pass
			else
				report_fail ("two acquires should return different objects")
			end
		end

feature -- Cache Edge Cases

	test_cache_zero_key
			-- Test cache with key = 0
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
		do
			print ("  test_cache_zero_key: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "val_" + a_k.out end)
			l_value := l_cache.item (0)
			if l_value.same_string ("val_0") and l_cache.is_cached (0) then
				report_pass
			else
				report_fail ("key 0 should work correctly")
			end
		end

	test_cache_negative_key
			-- Test cache with negative key
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
		do
			print ("  test_cache_negative_key: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "val_" + a_k.out end)
			l_value := l_cache.item (-999)
			if l_value.same_string ("val_-999") and l_cache.is_cached (-999) then
				report_pass
			else
				report_fail ("negative key should work correctly")
			end
		end

	test_cache_invalidate_nonexistent
			-- Test invalidating a key that was never cached
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
		do
			print ("  test_cache_invalidate_nonexistent: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "val_" + a_k.out end)
			-- Invalidate key that was never cached
			l_cache.invalidate (12345)
			if not l_cache.is_cached (12345) then
				report_pass
			else
				report_fail ("invalidating nonexistent should be safe")
			end
		end

feature -- Once Cell Edge Cases

	test_once_cell_multiple_invalidate
			-- Test multiple invalidations without access
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
		do
			print ("  test_once_cell_multiple_invalidate: ")
			create l_cell.make (agent: STRING do Result := "computed" end)
			-- Multiple invalidations without accessing
			l_cell.invalidate
			l_cell.invalidate
			l_cell.invalidate
			if not l_cell.is_computed then
				report_pass
			else
				report_fail ("multiple invalidations should keep cell not computed")
			end
		end

	test_once_cell_access_after_invalidate
			-- Test access immediately after invalidate
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_value: STRING
		do
			print ("  test_once_cell_access_after_invalidate: ")
			counter := 0
			create l_cell.make (agent edge_counting_factory)
			l_value := l_cell.item  -- First compute
			l_cell.invalidate
			l_value := l_cell.item  -- Should recompute
			if counter = 2 and l_cell.is_computed then
				report_pass
			else
				report_fail ("should compute twice, got " + counter.out)
			end
		end

feature -- Test Results

	pass_count: INTEGER
	fail_count: INTEGER

feature {NONE} -- Test Infrastructure

	counter: INTEGER

	edge_counting_factory: STRING
		do
			counter := counter + 1
			Result := "edge_" + counter.out
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
