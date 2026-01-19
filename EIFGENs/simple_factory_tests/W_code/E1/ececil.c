#include "eif_eiffel.h"
#include "eif_rout_obj.h"
#include "eaddress.h"

#ifdef __cplusplus
extern "C" {
#endif

	/* TEST_SIMPLE_FACTORY inline-agent#1 of test_cached_value_invalidate_all */
EIF_TYPED_VALUE _A14_58_2 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) F14_4976)(closed [1].it_r, open [1]);
}

	/* TEST_SIMPLE_FACTORY inline-agent#1 of test_cached_value_invalidation */
EIF_TYPED_VALUE _A14_59_2 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) F14_4977)(closed [1].it_r, open [1]);
}

	/* TEST_SIMPLE_FACTORY inline-agent#1 of test_cached_value_caching */
EIF_TYPED_VALUE _A14_60_2 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) F14_4978)(closed [1].it_r, open [1]);
}

	/* TEST_SIMPLE_FACTORY inline-agent#1 of test_cached_value_lazy_computation */
EIF_TYPED_VALUE _A14_61_2 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) F14_4979)(closed [1].it_r, open [1]);
}

	/* TEST_SIMPLE_FACTORY inline-agent#1 of test_cached_value_creation */
EIF_TYPED_VALUE _A14_62_2 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) F14_4980)(closed [1].it_r, open [1]);
}

	/* TEST_SIMPLE_FACTORY counting_factory */
EIF_TYPED_VALUE _A14_55 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTVF(541, "counting_factory", closed [1].it_r))(closed [1].it_r);
}

	/* TEST_SIMPLE_FACTORY inline-agent#1 of test_once_cell_lazy_computation */
EIF_TYPED_VALUE _A14_63 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) F14_4981)(closed [1].it_r);
}

	/* TEST_SIMPLE_FACTORY inline-agent#1 of test_once_cell_creation */
EIF_TYPED_VALUE _A14_64 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) F14_4982)(closed [1].it_r);
}

	/* RT_DBG_CALL_RECORD inline-agent#1 of record_fields */
void _A109_159_2 ( void(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) F109_4994)(closed [1].it_r, open [1]);
}

	/* MISMATCH_INFORMATION wipe_out */
void A125_98 (EIF_REFERENCE Current)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE)) RTVF(1880, "wipe_out", Current))(Current);
}

	/* MISMATCH_INFORMATION internal_put */
void A125_162 (EIF_REFERENCE Current, EIF_REFERENCE arg1, EIF_POINTER arg2)
{
	EIF_TYPED_VALUE u [2];
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTVF(2384, "internal_put", Current))(Current, ((u [0].type = SK_REF), (u [0].it_r = arg1), u [0]), ((u [1].type = SK_POINTER), (u [1].it_p = arg2), u [1]));
}

	/* MISMATCH_INFORMATION set_string_versions */
void A125_163 (EIF_REFERENCE Current, EIF_POINTER arg1, EIF_POINTER arg2)
{
	EIF_TYPED_VALUE u [2];
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTVF(2385, "set_string_versions", Current))(Current, ((u [0].type = SK_POINTER), (u [0].it_p = arg1), u [0]), ((u [1].type = SK_POINTER), (u [1].it_p = arg2), u [1]));
}


static fnptr feif_address_table[] = {
(fnptr)0,
(fnptr)A125_98,
(fnptr)A125_162,
(fnptr)A125_163,
};

fnptr *egc_address_table_init = feif_address_table;



#ifdef __cplusplus
}
#endif
