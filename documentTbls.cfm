<style type="text/css">
* { font-family: "verdana"; font-size: 14px; }
h1 {font-size: 28px;  }
table { width: 1200px; margin:auto; padding:0px;  border-spacing:0px; border-collapse:collapse;  }
th { text-align: left;  background-color:#f0f0f0; color: #000;}
</style>

<cfset dbname=createObject("component", "model.generatedcfcs.GOPDDefaults").getDatasource()>
<cfif isdefined ("url.dbname")>
	<cfset dbname= #Trim(url.dbname)#/>
</cfif>

<cfset getUserDefinedProcedures=createObject("component", "utils.admin.DBUtils").getUserDefinedProcedures(dbname)/>
<table align="center">
<tr>
<th colspan="2"><h1>List of Stored Procedures in <cfoutput>#dbname#</cfoutput></h1></th>
</tr>
<tr>
<th>##</th>
<th>Procedure Name</th>
</tr>
<cfoutput query="getUserDefinedProcedures">
<tr>
<td>#getUserDefinedProcedures.CurrentRow#</td>
<td>#getUserDefinedProcedures.ProcedureName#</td>
</tr>
</cfoutput>
</table>
<p style="page-break-before:always;">

<cfset getUserDefinedFunctions=createObject("component", "utils.admin.DBUtils").getUserDefinedFunctions(dbname)/>
<table align="center">
<tr>
<th colspan="2"><h1>List of Function Names in <cfoutput>#dbname#</cfoutput></h1></th>
</tr>
<tr>
<th>##</th>
<th>Function Name</th>
</tr>
<cfoutput query="getUserDefinedFunctions">
<tr>
<td>#getUserDefinedFunctions.CurrentRow#</td>
<td>#getUserDefinedFunctions.FunctionName#</td>
</tr>
</cfoutput>
</table>
<p style="page-break-before:always;">

<cfset getTablePrimaryKeys=createObject("component", "utils.admin.DBUtils").getPrimaryKeys(dbname)/>
<table align="center">
<tr>
<th colspan="4"><h1>List of Primary Keys in <cfoutput>#dbname#</cfoutput></h1></th>
</tr>
<tr style="background-color: ##fff; text-align:left; height:30px;">
<th>#</th>
<th>TableName</th>
<th>ColumnName</th>
<th>IndexName</th>
</tr>
<cfif #getTablePrimaryKeys.RecordCount#>
<cfoutput query="getTablePrimaryKeys">
<tr>
<td>#getTablePrimaryKeys.CurrentRow#</td>
<td>#getTablePrimaryKeys.TableName#</td>
<td>#getTablePrimaryKeys.ColumnName#</td>
<td>#getTablePrimaryKeys.IndexName#</td>
</tr>
</cfoutput>
</table>
<p style="page-break-before:always;">
</cfif>

<cfset getTableForeignKeys=createObject("component", "utils.admin.DBUtils").getForeignKeys(dbname)/>

<table align="center">
<tr>
<th colspan="6"><h1>List of Foreign Keys in <cfoutput>#dbname#</cfoutput></h1></th>
</tr>
<tr>
<th>##</th>
<th>TableName</th>
<th>ColumnName</th>
<th>ReferenceTableName</th>
<th>ReferenceColumnName</th>
<th>ForeignKey</th>
</tr>
<cfif #getTableForeignKeys.RecordCount#>
<cfoutput query="getTableForeignKeys">
<tr>
<td>#getTableForeignKeys.CurrentRow#</td>
<td>#getTableForeignKeys.TableName#</td>
<td>#getTableForeignKeys.ColumnName#</td>
<td>#getTableForeignKeys.ReferenceTableName#</td>
<td>#getTableForeignKeys.ReferenceColumnName#</td>
<td>#getTableForeignKeys.ForeignKey#</td>
</tr>
</cfoutput>
</table>
<p style="page-break-before:always;">
</cfif>



<cfset getAllTables = createObject("component", "utils.admin.DBUtils").getAllTables(dbname)>

<cfoutput query="getAllTables">
<cfset getTables=createObject("component","utils.admin.DBUtils").getTableDesign(dbname,getAllTables.tableName)>
<cfset getTablePKey=createObject("component","utils.admin.DBUtils").getPrimaryKeys(dbname,getAllTables.tableName)>
<cfset getTableFKeys=createObject("component","utils.admin.DBUtils").getForeignKeys(dbname,getAllTables.tableName)>
<cfset getIdentity=createObject("component","utils.admin.DBUtils").getIdentityColumn(dbname,getAllTables.tableName)>
<cfif #getIdentity.RecordCount#>
<cfset getAutoIncrement=createObject("component","utils.admin.DBUtils").getColumnAutoIncrement(dbname,getAllTables.tableName)>
</cfif>

<table align="center">
	<tr style="background-color: ##fff; text-align:left; height:30px;">
		<th colspan="8">
		<h1>Database: #dbname#   Table Design : #getAllTables.tableName#</h1>
		</th>
	</tr>
	<tr style="background-color: ##fff; text-align:left; height:30px;">
		<th>&nbsp;</th>
		<th>Column Name</th>
		<th>Column Data Type</th>
		<th>Max Length</th>
		<th>Allow Null</th>
		<th>Default Value</th>
		<th>(Seed,Incr,Current)</th>
		<th>FKeys</th>
	</tr>
	<cfloop query="getTables">
		<tr>
			<cfset #isPKey#=false>
			<cfloop query="getTablePKey">
				<cfif #gettables.ColumnName# is #getTablePKey.ColumnName#>
					<cfset #isPKey#=true>
					<cfbreak>
				</cfif>
			</cfloop>
			<td><cfif isPKey eq true><b>* </b><cfelse>&nbsp;</cfif></td>
			<td>#getTables.ColumnName#</td>
			<td>#getTables.DataType#</td>
			<td>#getTables.MaxLength#</td>
			<td>#getTables.AllowNull#</td>
			<td>#getTables.DefaultValue#</td>
			<cfset #isAutoIncre#="">
			<cfloop query="getIdentity">
				<cfif #getIdentity.ColumnName# is #gettables.ColumnName#>
					<cfif #getAutoIncrement.RecordCount#>
					<cfset #isAutoIncre#= "(" & #getAutoIncrement.Seed# & "," & #getAutoIncrement.Increment# & "," & #getAutoIncrement.Current_Identity# & ")" >
					<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
			<td>#isAutoIncre#</td>
			<cfset #isFKey#="">
			<cfloop query="getTableFKeys">
				<cfif #gettables.ColumnName# is #getTableFKeys.ColumnName#>
					<cfset #isFKey#=#getTableFKeys.ReferenceTableName# & "." & #getTableFKeys.ReferenceColumnName# >
					<cfbreak>
				</cfif>
			</cfloop>
			<td>#isFKey#</td>
		</tr>
	</cfloop>
</table>
<h1>&nbsp;</h1>
<p style="page-break-before:always;">
</cfoutput>

