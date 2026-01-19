note
	description: "Stress tests for simple_factory"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_STRESS

create
	make

feature {NONE} -- Initialization

	make
			-- Run stress tests
		do
			print ("Running stress tests...%N%N")
			run_all_tests
			print ("%N========================%N")
			print ("Stress Results: " + pass_count.out + " passed, " + fail_count.out + " failed%N")
		end

feature -- Test Execution

	run_all_tests
			-- Run all stress test cases
		do
			-- Pool stress tests
			test_pool_rapid_acquire_release
			test_pool_many_acquires
			test_pool_bounded_stress

			-- Cache stress tests
			test_cache_rapid_access
			test_cache_many_invalidations
			test_cache_large_key_space

			-- Once cell stress tests
			test_once_cell_rapid_invalidation
		end

feature -- Pool Stress Tests

	test_pool_rapid_acquire_release
			-- Rapidly acquire and release same object
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj: TEST_OBJECT
			i: INTEGER
		do
			print ("  test_pool_rapid_acquire_release: ")
			create l_pool.make (5)
			from i := 1 until i > 1000 loop
				l_obj := l_pool.acquire
				l_obj.set_value (i)
				l_pool.release (l_obj)
				i := i + 1
			end
			-- Pool should have exactly 1 object (reused 1000 times)
			if l_pool.count = 1 and l_pool.available_count = 1 then
				report_pass
			else
				report_fail ("pool should reuse single object, has " + l_pool.count.out)
			end
		end

	test_pool_many_acquires
			-- Acquire many objects without releasing
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj: TEST_OBJECT
			i: INTEGER
		do
			print ("  test_pool_many_acquires: ")
			create l_pool.make (10)
			from i := 1 until i > 100 loop
				l_obj := l_pool.acquire
				i := i + 1
			end
			if l_pool.count = 100 and l_pool.in_use_count = 100 then
				report_pass
			else
				report_fail ("expected 100 in use, got " + l_pool.in_use_count.out)
			end
		end

	test_pool_bounded_stress
			-- Stress bounded pool at capacity
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_objects: ARRAYED_LIST [TEST_OBJECT]
			l_obj: TEST_OBJECT
			i: INTEGER
		do
			print ("  test_pool_bounded_stress: ")
			create l_pool.make_bounded (5, 10)
			create l_objects.make (10)

			-- Acquire to max
			from i := 1 until i > 10 loop
				l_obj := l_pool.acquire
				l_objects.extend (l_obj)
				i := i + 1
			end

			-- Should be at capacity
			if not l_pool.is_at_capacity then
				report_fail ("should be at capacity")
			else
				-- Release and reacquire rapidly
				from i := 1 until i > 50 loop
					l_pool.release (l_objects.first)
					l_objects.start
					l_objects.remove
					l_obj := l_pool.acquire
					l_objects.extend (l_obj)
					i := i + 1
				end
				if l_pool.count = 10 then
					report_pass
				else
					report_fail ("count should stay at 10")
				end
			end
		end

feature -- Cache Stress Tests

	test_cache_rapid_access
			-- Rapidly access same key
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
			i: INTEGER
		do
			print ("  test_cache_rapid_access: ")
			counter := 0
			create l_cache.make (agent stress_factory)
			from i := 1 until i > 1000 loop
				l_value := l_cache.item (42)
				i := i + 1
			end
			-- Factory should only be called once
			if counter = 1 then
				report_pass
			else
				report_fail ("factory called " + counter.out + " times, expected 1")
			end
		end

	test_cache_many_invalidations
			-- Rapidly invalidate and recompute
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
			i: INTEGER
		do
			print ("  test_cache_many_invalidations: ")
			counter := 0
			create l_cache.make (agent stress_factory)
			from i := 1 until i > 100 loop
				l_value := l_cache.item (1)
				l_cache.invalidate (1)
				i := i + 1
			end
			-- Factory should be called 100 times
			if counter = 100 then
				report_pass
			else
				report_fail ("factory called " + counter.out + " times, expected 100")
			end
		end

	test_cache_large_key_space
			-- Access many different keys
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
			i: INTEGER
		do
			print ("  test_cache_large_key_space: ")
			counter := 0
			create l_cache.make (agent stress_factory)
			from i := 1 until i > 500 loop
				l_value := l_cache.item (i)
				i := i + 1
			end
			-- Each key should trigger one factory call
			if counter = 500 and l_cache.cached_count = 500 then
				report_pass
			else
				report_fail ("expected 500 cached, got " + l_cache.cached_count.out)
			end
		end

feature -- Once Cell Stress Tests

	test_once_cell_rapid_invalidation
			-- Rapidly invalidate and access
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_value: STRING
			i: INTEGER
		do
			print ("  test_once_cell_rapid_invalidation: ")
			counter := 0
			create l_cell.make (agent stress_cell_factory)
			from i := 1 until i > 500 loop
				l_value := l_cell.item
				l_cell.invalidate
				i := i + 1
			end
			-- Final access after invalidation
			l_value := l_cell.item
			-- Factory should be called 501 times (500 in loop + 1 final)
			if counter = 501 then
				report_pass
			else
				report_fail ("factory called " + counter.out + " times, expected 501")
			end
		end

feature -- Test Results

	pass_count: INTEGER
	fail_count: INTEGER

feature {NONE} -- Test Infrastructure

	counter: INTEGER

	stress_factory (a_k: INTEGER): STRING
			-- Factory that counts invocations
		do
			counter := counter + 1
			Result := "value_" + a_k.out + "_" + counter.out
		end

	stress_cell_factory: STRING
			-- Factory for once cell stress
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
