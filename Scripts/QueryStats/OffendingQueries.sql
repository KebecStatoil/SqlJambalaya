/*

	-- #1
	SELECT * FROM OM.Workorder
	WHERE (Plant = '1320' ) AND (OrderType = 'PM01')

	-- #2
	SELECT * FROM OM.Workorder
	WHERE (Plant = '1333' ) AND (OrderType = 'PM02')

	-- #3
	SELECT * FROM OM.Workorder
	WHERE (Plant = '1320' ) AND OrderType = 'PM01'

	-- #4
	SELECT * FROM OM.Workorder
	WHERE (Plant = '1320' ) AND (OrderType = 'PM01' OR OrderType = 'PM02' OR OrderType = 'PM03' OR OrderType = 'PM06' OR OrderType = 'PM10'  )

	-- #5
	SELECT * FROM OM.Workorder
	WHERE (Plant = '1320' ) AND (OrderType = 'PM01' )

*/