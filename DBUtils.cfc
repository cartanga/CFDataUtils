<cfcomponent>
	<cffunction name="getAllTables" access="remote" returntype="Query">
		<cfargument name="srcDB" type="string" required="true"/>
		<cfquery name="qryData" datasource="#arguments.srcDB#" >
			SELECT 
			tables.name AS [TableName]
			From sys.tables tables 
			order by TableName;
		</cfquery>        
		<cfreturn qryData/>
	</cffunction>

	<cffunction name="getTableDesign" access="remote" returntype="Query">
		<cfargument name="srcDB" type="string" required="true"/>
		<cfargument name="tableName" type="string" required="true"/>
		<cfquery name="qryData" datasource="#arguments.srcDB#" >
			select ordinal_position,
	    	   column_name 'ColumnName', 
			   data_type 'DataType', 
			   character_maximum_length 'MaxLength', 
			   is_nullable 'AllowNull',
			   COLUMN_DEFAULT 'DefaultValue'
			from   information_schema.columns 
			where table_name = '#arguments.tableName#'
			order by ordinal_position;
		</cfquery>
		<cfreturn qryData/>
	</cffunction>
<!--- LIST ALL Primary Keys --->
<cffunction name="getPrimaryKeys" returntype="Query">
	<cfargument name="srcDB" type="string" required="true"/>
	<cfargument name="tableName" type="string" required="false" default=""/>
	<cfquery name="qryData" datasource="#arguments.srcDB#" >
		SELECT i.name AS IndexName,
		OBJECT_NAME(ic.OBJECT_ID) AS TableName,
		COL_NAME(ic.OBJECT_ID,ic.column_id) AS ColumnName
		FROM sys.indexes AS i
		INNER JOIN sys.index_columns AS ic
		ON i.OBJECT_ID = ic.OBJECT_ID
		AND i.index_id = ic.index_id
		WHERE i.is_primary_key = 1 
		<cfif #len(arguments.tableName)#>
		and OBJECT_NAME(ic.OBJECT_ID) = '#arguments.tableName#'
		</cfif>
		ORDER BY TABLENAME, ColumnName;
	</cfquery>
	<cfreturn qryData/>
</cffunction>
<cffunction name="getForeignKeys" returntype="Query">
	<cfargument name="srcDB" type="string" required="true"/>
	<cfargument name="tableName" type="string" required="false" default=""/>
	<cfquery name="qryData" datasource="#arguments.srcDB#" >
		SELECT f.name AS ForeignKey,
		OBJECT_NAME(f.parent_object_id) AS TableName,
		COL_NAME(fc.parent_object_id,
		fc.parent_column_id) AS ColumnName,
		OBJECT_NAME (f.referenced_object_id) AS ReferenceTableName,
		COL_NAME(fc.referenced_object_id,
		fc.referenced_column_id) AS ReferenceColumnName
		FROM sys.foreign_keys AS f
		INNER JOIN sys.foreign_key_columns AS fc
		ON f.OBJECT_ID = fc.constraint_object_id
		<cfif #len(arguments.tableName)#>
		WHERE OBJECT_NAME(f.parent_object_id) = '#arguments.tableName#'
		</cfif>
		ORDER BY TableName, ForeignKey;
	</cfquery>
	<cfreturn qryData/>
</cffunction>

<cffunction name="getIdentityColumn" returntype="Query">
	<cfargument name="srcDB" type="string" required="true"/>
	<cfargument name="tableName" type="string" required="false" default=""/>
	<cfquery name="qryData" datasource="#arguments.srcDB#" >
		select (COLUMN_NAME) as COLUMNNAME , TABLE_NAME as TABLENAME 
		from INFORMATION_SCHEMA.COLUMNS 
		where TABLE_SCHEMA = 'dbo'
		and COLUMNPROPERTY(object_id(TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1 
		<cfif #len(arguments.tableName)#>
		and TABLE_NAME = '#arguments.tableName#'
		</cfif>
		order by TABLE_NAME ;
	</cfquery>
	<cfreturn qryData/>
</cffunction>

<cffunction name="getColumnAutoIncrement" returntype="Query">
	<cfargument name="srcDB" type="string" required="true"/>
	<cfargument name="tableName" type="string" required="false" default=""/>
	<cfquery name="qryData" datasource="#arguments.srcDB#" >
		SELECT  IDENT_SEED(TABLE_NAME) AS Seed,
				IDENT_INCR(TABLE_NAME) AS Increment,
				IDENT_CURRENT(TABLE_NAME) AS Current_Identity,
				TABLE_NAME
		FROM INFORMATION_SCHEMA.TABLES
		WHERE OBJECTPROPERTY(OBJECT_ID(TABLE_NAME), 'TableHasIdentity') = 1
		AND TABLE_TYPE = 'BASE TABLE'
		<cfif #len(arguments.tableName)#>
		AND TABLE_NAME = '#arguments.tableName#';
		</cfif>
	</cfquery>
	<cfreturn qryData/>
</cffunction>

<!--- LIST ALL User Defined Stored Procedures --->
<cffunction name="getUserDefinedProcedures" returntype="Query" >
	<cfargument name="srcDB" type="string" required="true"/>
	<cfquery name="qryData" datasource="#arguments.srcDB#" >
		select routine_name as ProcedureName from information_schema.routines 
		where routine_type='procedure'
		and routine_name not like 'sp_%dia%';
	</cfquery>
	<cfreturn qryData/>
</cffunction>

<!--- LIST ALL User Defined Functions --->
<cffunction name="getUserDefinedFunctions" returntype="Query" >
	<cfargument name="srcDB" type="string" required="true"/>
	<cfquery name="qryData" datasource="#arguments.srcDB#" >
		select routine_name as FunctionName from information_schema.routines 
		where routine_type='function'
		and routine_name not like 'fn_%dia%';
	</cfquery>
	<cfreturn qryData/>
</cffunction>

</cfcomponent>
