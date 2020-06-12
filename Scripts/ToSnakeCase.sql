
/*
 *  src: https://docs.microsoft.com/en-us/sql/t-sql/functions/string-split-transact-sql?view=sql-server-2017
 */

declare @Temp VarChar(1000) = 'FooBarBazQuz'

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^_][A-Z]%'
    While PatIndex(@KeepValues collate Latin1_General_Bin, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues collate Latin1_General_Bin, @Temp) + 1, 0, '_')

select lower(@Temp)