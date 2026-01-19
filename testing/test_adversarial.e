note
	description: "Adversarial tests attempting to break simple_factory"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ADVERSARIAL

create
	make

feature {NONE} -- Initialization

	make
			-- Run adversarial tests
		do
			print ("Running adversarial tests...%N%N")
			run_all_tests
			print ("%N========================%N")
			print ("Adversarial Results: " + pass_count.out + " passed, " + fail_count.out + " failed%N")
		end

feature -- Test Execution

	run_all_tests
			-- Run all adversarial test cases
		do
			-- Boundary tests
			test_pool_bounded_capacity
			test_pool_at_max_cannot_acquire
			test_cache_many_keys
			test_once_cell_repeated_invalidation

			-- State consistency tests
			test_pool_release_resets_state
			test_pool_release_all_resets_all
			test_once_cell_invalidate_recomputes

			-- Edge case tests
			test_factory_empty_type_table
			test_cache_same_key_twice
		end

feature -- Bounded Pool Tests

	test_pool_bounded_capacity
			-- Test bounded pool respects max capacity
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2, l_obj3: TEST_OBJECT
		do
			print ("  test_pool_bounded_capacity: ")
			create l_pool.make_bounded (2, 3)
			l_obj1 := l_pool.acquire
			l_obj2 := l_pool.acquire
			l_obj3 := l_pool.acquire
			-- Pool should now be at capacity (3 objects)
			if l_pool.is_at_capacity and l_pool.count = 3 then
				report_pass
			else
				report_fail ("pool should be at capacity with 3 objects")
			end
		end

	test_pool_at_max_cannot_acquire
			-- Test that bounded pool prevents acquisition at max
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2: TEST_OBJECT
		do
			print ("  test_pool_at_max_cannot_acquire: ")
			create l_pool.make_bounded (1, 2)
			l_obj1 := l_pool.acquire
			l_obj2 := l_pool.acquire
			-- Pool is at max (2), all in use, cannot acquire
			if not l_pool.can_acquire then
				report_pass
			else
				report_fail ("should not be able to acquire when at max with none available")
			end
		end

feature -- Cache Tests

	test_cache_many_keys
			-- Test cache with many different keys
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
			i: INTEGER
		do
			print ("  test_cache_many_keys: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "val_" + a_k.out end)
			from i := 1 until i > 100 loop
				l_value := l_cache.item (i)
				i := i + 1
			end
			if l_cache.cached_count = 100 then
				report_pass
			else
				report_fail ("cache should have 100 entries, has " + l_cache.cached_count.out)
			end
		end

	test_cache_same_key_twice
			-- Test cache returns same value for same key
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_val1, l_val2: STRING
		do
			print ("  test_cache_same_key_twice: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "val_" + a_k.out end)
			l_val1 := l_cache.item (42)
			l_val2 := l_cache.item (42)
			if l_val1 = l_val2 then
				report_pass
			else
				report_fail ("same key should return same object reference")
			end
		end

feature -- Once Cell Tests

	test_once_cell_repeated_invalidation
			-- Test repeated invalidation
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_value: STRING
			i: INTEGER
		do
			print ("  test_once_cell_repeated_invalidation: ")
			counter := 0
			create l_cell.make (agent adv_counting_factory)
			from i := 1 until i > 10 loop
				l_value := l_cell.item
				l_cell.invalidate
				i := i + 1
			end
			l_value := l_cell.item  -- Final access
			if counter = 11 then
				report_pass
			else
				report_fail ("factory should be called 11 times, was " + counter.out)
			end
		end

	test_once_cell_invalidate_recomputes
			-- Test that invalidate forces fresh computation
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_val1, l_val2: STRING
		do
			print ("  test_once_cell_invalidate_recomputes: ")
			counter := 0
			create l_cell.make (agent adv_counting_factory)
			l_val1 := l_cell.item
			l_cell.invalidate
			l_val2 := l_cell.item
			if l_val1 /= l_val2 and counter = 2 then
				report_pass
			else
				report_fail ("invalidation should produce different object")
			end
		end

feature -- Pool State Tests

	test_pool_release_resets_state
			-- Test that release resets object state
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj: TEST_OBJECT
		do
			print ("  test_pool_release_resets_state: ")
			create l_pool.make (5)
			l_obj := l_pool.acquire
			l_obj.set_value (999)
			l_obj.set_name ("modified")
			l_pool.release (l_obj)
			if l_obj.value = 0 and l_obj.name.same_string ("default") then
				report_pass
			else
				report_fail ("released object should be reset to default state")
			end
		end

	test_pool_release_all_resets_all
			-- Test that release_all resets all objects
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2: TEST_OBJECT
		do
			print ("  test_pool_release_all_resets_all: ")
			create l_pool.make (5)
			l_obj1 := l_pool.acquire
			l_obj2 := l_pool.acquire
			l_obj1.set_value (111)
			l_obj2.set_value (222)
			l_pool.release_all
			if l_obj1.is_in_default_state and l_obj2.is_in_default_state then
				report_pass
			else
				report_fail ("all released objects should be in default state")
			end
		end

feature -- Factory Edge Case Tests

	test_factory_empty_type_table
			-- Test factory with no registered types
		local
			l_factory: SIMPLE_TYPE_FACTORY [TEST_OBJECT]
		do
			print ("  test_factory_empty_type_table: ")
			create l_factory.make
			-- Empty factory should not have any types
			if not l_factory.has_type ("anything") then
				report_pass
			else
				report_fail ("empty factory should not have any types")
			end
		end

feature -- Test Results

	pass_count: INTEGER
			-- Number of passed tests

	fail_count: INTEGER
			-- Number of failed tests

feature {NONE} -- Test Infrastructure

	counter: INTEGER

	adv_counting_factory: STRING
			-- Factory that counts invocations
		do
			counter := counter + 1
			create Result.make_from_string ("computed_" + counter.out)
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
