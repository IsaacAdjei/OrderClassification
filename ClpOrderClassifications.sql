/*
	THIS IS JUST A TEST COMMENT TO TEST GIT
*/

WITH ORDER_BASE AS
(
  SELECT
    BASE.*,
    CASE
      WHEN BASE.ORDER_SIZE = BASE.TOTAL_BP THEN 'BP'
      ELSE 'NOT BP'
    END BP_IND
  FROM
  (
  SELECT
    ORDERDATE,
    ORDERID,
    COUNT(*)ORDER_SIZE,
    COUNT(DISTINCT HANDLING_TYPE) HANDLING_GROUPS,
    SUM(CASE WHEN HANDLING_TYPE = 'HANGING' THEN 1 ELSE 0 END) HANGING_COUNT,
    SUM(CASE WHEN HANDLING_TYPE = 'BINNABLE' THEN 1 ELSE 0 END) BINNABLE_COUNT,
    SUM(CASE WHEN HANDLING_TYPE = 'FLAT' THEN 1 ELSE 0 END) FLAT_COUNT,
    SUM(QUANTITY)UNITS,
    SUM(CASE WHEN FULFILLINGDC = 'CLIPPER' THEN QUANTITY ELSE 0 END)CLP_QUANTITY,
    SUM(CASE WHEN FULFILLINGDC = '79' THEN QUANTITY ELSE 0 END)MAGNA_QUANTITY,
    SUM(BAGGABLE_PREFERRED)TOTAL_BP
  FROM ORDERLINES
  GROUP BY
    ORDERDATE,
    ORDERID
  )BASE
)
SELECT
  CASE
    WHEN HANGING_COUNT > 0 AND HANDLING_GROUPS = 1 THEN 'HANGING ONLY'
    WHEN BINNABLE_COUNT > 0 AND HANDLING_GROUPS = 1 THEN 'BINNABLE ONLY'
    WHEN FLAT_COUNT > 0 AND HANDLING_GROUPS = 1 THEN 'FLAT ONLY'
    WHEN HANGING_COUNT > 0 AND FLAT_COUNT > 0 AND HANDLING_GROUPS = 2 THEN 'HANGING-FLAT ONLY'
    WHEN HANGING_COUNT > 0 AND BINNABLE_COUNT > 0 AND HANDLING_GROUPS = 2 THEN 'HANGING-BIN ONLY'
    WHEN FLAT_COUNT > 0 AND BINNABLE_COUNT > 0 AND HANDLING_GROUPS = 2 THEN 'FLAT-BIN ONLY'
    WHEN HANGING_COUNT > 0 AND FLAT_COUNT > 0 AND BINNABLE_COUNT > 0  AND HANDLING_GROUPS = 3 AND BP_IND = 'BP' THEN 'HANGING-FLAT-BINNABLE ONLY (BP)'
    WHEN HANGING_COUNT > 0 AND FLAT_COUNT > 0 AND BINNABLE_COUNT > 0  AND HANDLING_GROUPS = 3 AND BP_IND = 'NOT BP' THEN 'HANGING-FLAT-BINNABLE ONLY (NOT BP)'
  END DESCRIPTION,
  COUNT(*)ORDERS,
  SUM(UNITS)TOTAL_UNITS,
  SUM(CLP_QUANTITY)CL_UNITS,
  SUM(MAGNA_QUANTITY)MAGNA_UNITS
FROM ORDER_BASE
GROUP BY
  CASE
    WHEN HANGING_COUNT > 0 AND HANDLING_GROUPS = 1 THEN 'HANGING ONLY'
    WHEN BINNABLE_COUNT > 0 AND HANDLING_GROUPS = 1 THEN 'BINNABLE ONLY'
    WHEN FLAT_COUNT > 0 AND HANDLING_GROUPS = 1 THEN 'FLAT ONLY'
    WHEN HANGING_COUNT > 0 AND FLAT_COUNT > 0 AND HANDLING_GROUPS = 2 THEN 'HANGING-FLAT ONLY'
    WHEN HANGING_COUNT > 0 AND BINNABLE_COUNT > 0 AND HANDLING_GROUPS = 2 THEN 'HANGING-BIN ONLY'
    WHEN FLAT_COUNT > 0 AND BINNABLE_COUNT > 0 AND HANDLING_GROUPS = 2 THEN 'FLAT-BIN ONLY'
    WHEN HANGING_COUNT > 0 AND FLAT_COUNT > 0 AND BINNABLE_COUNT > 0  AND HANDLING_GROUPS = 3 AND BP_IND = 'BP' THEN 'HANGING-FLAT-BINNABLE ONLY (BP)'
    WHEN HANGING_COUNT > 0 AND FLAT_COUNT > 0 AND BINNABLE_COUNT > 0  AND HANDLING_GROUPS = 3 AND BP_IND = 'NOT BP' THEN 'HANGING-FLAT-BINNABLE ONLY (NOT BP)'
  END;