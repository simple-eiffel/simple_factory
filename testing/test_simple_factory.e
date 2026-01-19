note
	description: "Tests for simple_factory library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_SIMPLE_FACTORY

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests
		local
			l_adversarial: TEST_ADVERSARIAL
			l_stress: TEST_STRESS
			l_edge: TEST_EDGE_CASES
			l_state: TEST_STATE_SEQUENCES
			l_exploit: TEST_EXPLOITS
			l_total_pass, l_total_fail: INTEGER
		do
			print ("Running simple_factory tests...%N%N")
			run_all_tests
			print ("%N========================%N")
			print ("Unit Test Results: " + pass_count.out + " passed, " + fail_count.out + " failed%N")

			-- Run adversarial tests
			print ("%N")
			create l_adversarial.make

			-- Run stress tests
			print ("%N")
			create l_stress.make

			-- Run edge case tests
			print ("%N")
			create l_edge.make

			-- Run state sequence tests
			print ("%N")
			create l_state.make

			-- Run exploit tests (documents known bugs)
			print ("%N")
			create l_exploit.make

			-- Calculate totals
			l_total_pass := pass_count + l_adversarial.pass_count + l_stress.pass_count + l_edge.pass_count + l_state.pass_count + l_exploit.pass_count
			l_total_fail := fail_count + l_adversarial.fail_count + l_stress.fail_count + l_edge.fail_count + l_state.fail_count + l_exploit.fail_count

			print ("%N========================%N")
			print ("FINAL SUMMARY%N")
			print ("  Unit:       " + pass_count.out + "/" + (pass_count + fail_count).out + "%N")
			print ("  Adversarial:" + l_adversarial.pass_count.out + "/" + (l_adversarial.pass_count + l_adversarial.fail_count).out + "%N")
			print ("  Stress:     " + l_stress.pass_count.out + "/" + (l_stress.pass_count + l_stress.fail_count).out + "%N")
			print ("  Edge Cases: " + l_edge.pass_count.out + "/" + (l_edge.pass_count + l_edge.fail_count).out + "%N")
			print ("  State Seq:  " + l_state.pass_count.out + "/" + (l_state.pass_count + l_state.fail_count).out + "%N")
			print ("  Regression: " + l_exploit.pass_count.out + "/" + (l_exploit.pass_count + l_exploit.fail_count).out + "%N")
			print ("  TOTAL:      " + l_total_pass.out + "/" + (l_total_pass + l_total_fail).out + "%N")
			if l_total_fail = 0 then
				print ("ALL TESTS PASSED%N")
			end
		end

feature -- Test Execution

	run_all_tests
			-- Run all test cases
		do
			-- SIMPLE_ONCE_CELL tests
			test_once_cell_creation
			test_once_cell_lazy_computation
			test_once_cell_caching
			test_once_cell_invalidation

			-- SIMPLE_CACHED_VALUE tests
			test_cached_value_creation
			test_cached_value_lazy_computation
			test_cached_value_caching
			test_cached_value_invalidation
			test_cached_value_invalidate_all

			-- SIMPLE_OBJECT_POOL tests
			test_object_pool_creation
			test_object_pool_acquire
			test_object_pool_release
			test_object_pool_release_all
			test_object_pool_reuse

			-- SIMPLE_TYPE_FACTORY tests
			test_type_factory_creation
			test_type_factory_new_instance
			test_type_factory_register_type
			test_type_factory_has_type
			test_type_factory_type_for_key
		end

feature -- SIMPLE_ONCE_CELL Tests

	test_once_cell_creation
			-- Test SIMPLE_ONCE_CELL creation
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
		do
			print ("  test_once_cell_creation: ")
			create l_cell.make (agent: STRING do Result := "computed" end)
			if not l_cell.is_computed then
				report_pass
			else
				report_fail ("should not be computed after creation")
			end
		end

	test_once_cell_lazy_computation
			-- Test SIMPLE_ONCE_CELL lazy computation
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_value: STRING
		do
			print ("  test_once_cell_lazy_computation: ")
			create l_cell.make (agent: STRING do Result := "computed" end)
			l_value := l_cell.item
			if l_value.same_string ("computed") and l_cell.is_computed then
				report_pass
			else
				report_fail ("value should be 'computed'")
			end
		end

	test_once_cell_caching
			-- Test SIMPLE_ONCE_CELL caches value
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_value1, l_value2: STRING
		do
			print ("  test_once_cell_caching: ")
			test_counter := 0
			create l_cell.make (agent counting_factory)
			l_value1 := l_cell.item
			l_value2 := l_cell.item
			if l_value1 = l_value2 and test_counter = 1 then
				report_pass
			else
				report_fail ("factory should be called only once")
			end
		end

	test_once_cell_invalidation
			-- Test SIMPLE_ONCE_CELL invalidation
		local
			l_cell: SIMPLE_ONCE_CELL [STRING]
			l_value1, l_value2: STRING
		do
			print ("  test_once_cell_invalidation: ")
			test_counter := 0
			create l_cell.make (agent counting_factory)
			l_value1 := l_cell.item
			l_cell.invalidate
			l_value2 := l_cell.item
			if l_value1.same_string ("computed_1") and l_value2.same_string ("computed_2") then
				report_pass
			else
				report_fail ("invalidation should trigger recomputation")
			end
		end

feature -- SIMPLE_CACHED_VALUE Tests

	test_cached_value_creation
			-- Test SIMPLE_CACHED_VALUE creation
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
		do
			print ("  test_cached_value_creation: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "value_" + a_k.out end)
			if l_cache.cached_count = 0 then
				report_pass
			else
				report_fail ("cache should be empty after creation")
			end
		end

	test_cached_value_lazy_computation
			-- Test SIMPLE_CACHED_VALUE lazy computation
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
		do
			print ("  test_cached_value_lazy_computation: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "value_" + a_k.out end)
			l_value := l_cache.item (42)
			if l_value.same_string ("value_42") then
				report_pass
			else
				report_fail ("value should be 'value_42'")
			end
		end

	test_cached_value_caching
			-- Test SIMPLE_CACHED_VALUE caches values
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value1, l_value2: STRING
		do
			print ("  test_cached_value_caching: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "value_" + a_k.out end)
			l_value1 := l_cache.item (1)
			l_value2 := l_cache.item (1)
			if l_value1 = l_value2 and l_cache.is_cached (1) then
				report_pass
			else
				report_fail ("second access should return cached value")
			end
		end

	test_cached_value_invalidation
			-- Test SIMPLE_CACHED_VALUE key invalidation
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
		do
			print ("  test_cached_value_invalidation: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "value_" + a_k.out end)
			l_value := l_cache.item (1)
			l_cache.invalidate (1)
			if not l_cache.is_cached (1) then
				report_pass
			else
				report_fail ("key should not be cached after invalidation")
			end
		end

	test_cached_value_invalidate_all
			-- Test SIMPLE_CACHED_VALUE invalidate all
		local
			l_cache: SIMPLE_CACHED_VALUE [STRING, INTEGER]
			l_value: STRING
		do
			print ("  test_cached_value_invalidate_all: ")
			create l_cache.make (agent (a_k: INTEGER): STRING do Result := "value_" + a_k.out end)
			l_value := l_cache.item (1)
			l_value := l_cache.item (2)
			l_value := l_cache.item (3)
			l_cache.invalidate_all
			if l_cache.cached_count = 0 then
				report_pass
			else
				report_fail ("cache should be empty after invalidate_all")
			end
		end

feature -- SIMPLE_OBJECT_POOL Tests

	test_object_pool_creation
			-- Test SIMPLE_OBJECT_POOL creation
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
		do
			print ("  test_object_pool_creation: ")
			create l_pool.make (10)
			if l_pool.count = 0 and l_pool.available_count = 0 and l_pool.in_use_count = 0 then
				report_pass
			else
				report_fail ("pool should be empty after creation")
			end
		end

	test_object_pool_acquire
			-- Test SIMPLE_OBJECT_POOL acquire
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj: TEST_OBJECT
		do
			print ("  test_object_pool_acquire: ")
			create l_pool.make (10)
			l_obj := l_pool.acquire
			if l_obj /= Void and l_pool.in_use_count = 1 and l_pool.is_in_use (l_obj) then
				report_pass
			else
				report_fail ("object should be acquired and in use")
			end
		end

	test_object_pool_release
			-- Test SIMPLE_OBJECT_POOL release
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj: TEST_OBJECT
		do
			print ("  test_object_pool_release: ")
			create l_pool.make (10)
			l_obj := l_pool.acquire
			l_obj.set_value (99)
			l_pool.release (l_obj)
			if l_pool.in_use_count = 0 and l_pool.available_count = 1 and l_obj.is_in_default_state then
				report_pass
			else
				report_fail ("object should be released and reset")
			end
		end

	test_object_pool_release_all
			-- Test SIMPLE_OBJECT_POOL release_all
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2, l_obj3: TEST_OBJECT
		do
			print ("  test_object_pool_release_all: ")
			create l_pool.make (10)
			l_obj1 := l_pool.acquire
			l_obj2 := l_pool.acquire
			l_obj3 := l_pool.acquire
			l_pool.release_all
			if l_pool.in_use_count = 0 and l_pool.available_count = 3 then
				report_pass
			else
				report_fail ("all objects should be released")
			end
		end

	test_object_pool_reuse
			-- Test SIMPLE_OBJECT_POOL object reuse
		local
			l_pool: SIMPLE_OBJECT_POOL [TEST_OBJECT]
			l_obj1, l_obj2: TEST_OBJECT
		do
			print ("  test_object_pool_reuse: ")
			create l_pool.make (10)
			l_obj1 := l_pool.acquire
			l_pool.release (l_obj1)
			l_obj2 := l_pool.acquire
			if l_obj1 = l_obj2 then
				report_pass
			else
				report_fail ("released object should be reused")
			end
		end

feature -- SIMPLE_TYPE_FACTORY Tests

	test_type_factory_creation
			-- Test SIMPLE_TYPE_FACTORY creation
		local
			l_factory: SIMPLE_TYPE_FACTORY [TEST_OBJECT]
		do
			print ("  test_type_factory_creation: ")
			create l_factory.make
			report_pass
		end

	test_type_factory_new_instance
			-- Test SIMPLE_TYPE_FACTORY new_instance
		local
			l_factory: SIMPLE_TYPE_FACTORY [TEST_OBJECT]
			l_obj: TEST_OBJECT
		do
			print ("  test_type_factory_new_instance: ")
			create l_factory.make
			l_obj := l_factory.new_instance
			if l_obj /= Void and l_obj.is_in_default_state then
				report_pass
			else
				report_fail ("new instance should exist and be in default state")
			end
		end

	test_type_factory_register_type
			-- Test SIMPLE_TYPE_FACTORY register_type
		local
			l_factory: SIMPLE_TYPE_FACTORY [TEST_OBJECT]
		do
			print ("  test_type_factory_register_type: ")
			create l_factory.make
			l_factory.register_type ("test", {TEST_OBJECT})
			if l_factory.has_type ("test") then
				report_pass
			else
				report_fail ("type should be registered")
			end
		end

	test_type_factory_has_type
			-- Test SIMPLE_TYPE_FACTORY has_type
		local
			l_factory: SIMPLE_TYPE_FACTORY [TEST_OBJECT]
		do
			print ("  test_type_factory_has_type: ")
			create l_factory.make
			if not l_factory.has_type ("nonexistent") then
				l_factory.register_type ("exists", {TEST_OBJECT})
				if l_factory.has_type ("exists") then
					report_pass
				else
					report_fail ("registered type should be found")
				end
			else
				report_fail ("nonexistent type should not be found")
			end
		end

	test_type_factory_type_for_key
			-- Test SIMPLE_TYPE_FACTORY type_for_key
		local
			l_factory: SIMPLE_TYPE_FACTORY [TEST_OBJECT]
			l_type: TYPE [TEST_OBJECT]
		do
			print ("  test_type_factory_type_for_key: ")
			create l_factory.make
			l_factory.register_type ("test_obj", {TEST_OBJECT})
			l_type := l_factory.type_for_key ("test_obj")
			if l_type /= Void then
				report_pass
			else
				report_fail ("type_for_key should return registered type")
			end
		end

feature {NONE} -- Test Infrastructure

	pass_count: INTEGER
			-- Number of passed tests

	fail_count: INTEGER
			-- Number of failed tests

	test_counter: INTEGER
			-- Counter for factory call tracking

	counting_factory: STRING
			-- Factory function that increments counter
		do
			test_counter := test_counter + 1
			Result := "computed_" + test_counter.out
		end

	report_pass
			-- Report test passed
		do
			pass_count := pass_count + 1
			print ("PASS%N")
		end

	report_fail (a_reason: STRING)
			-- Report test failed with reason
		do
			fail_count := fail_count + 1
			print ("FAIL - " + a_reason + "%N")
		end

end
