select ora_rowscn meta_OraRowScn, {{SourceDatabase}} META_SourceDatabase, T.* from SAFRANSA.ACTIVITIES T WHERE rownum < 1000