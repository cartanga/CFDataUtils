<cfcomponent>
	<cffunction name="editRecord" access="remote" output="true" >
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="table" type="string"  required="yes">
		<cfargument name="pkfield" type="string"  required="yes">
        <cfargument name="gridaction" type="string" hint="[Update|Delete]" required="yes">
        <cfargument name="gridrow" type="struct" required="yes">
        <cfargument name="gridchanged" type="struct" required="yes">
        <!--- Local variables --->
		<cfsetting showdebugoutput="true" />
        <cfset var colname="">
        <cfset var value="">
        <cfdump var="#ARGUMENTS.gridaction#">
        <h2>Data Row</h2>
        <cfdump var="#gridrow#">
        <h2>Changed Field</h2>
        <cfdump var="#gridchanged#">
        
        <!--- Process gridaction --->
        <cfswitch expression="#ARGUMENTS.gridaction#">
            <!--- Process updates --->
            <cfcase value="U">
                <!--- Get column name and value --->
                <cfset colname=StructKeyList(ARGUMENTS.gridchanged)>
                <cfset value=ARGUMENTS.gridchanged[colname]>
                <cfset pkvalue=arguments.gridrow[pkfield]>
                <!--- Perform actual update --->
                <cfquery datasource="#arguments.datasource#">
                UPDATE #arguments.table#
                SET #colname# = '#value#'
                WHERE #arguments.pkfield# = #pkvalue#;
                </cfquery>
            </cfcase>
            <!--- Process deletes --->
			<cfcase value="D">
                <cfset pkvalue=arguments.gridrow[pkfield]>
                <cfquery datasource="#arguments.datasource#">
                DELETE FROM #arguments.table#
                WHERE #arguments.pkfield# = #pkvalue#;
                </cfquery>
			</cfcase>
			<cfcase value="I">
			<cfdump var="#gridrow#">
			<cfdump var="#StructKeyArray(gridrow)#">
			 <!---<cfloop index="thisIndex" from="1" to="#arrayLen(form.myGrid.rowStatus.action)#" step="1">
                    <cfif form.myGrid.rowStatus.action[thisIndex] is "I">
                         <!---cfquery name="qSetUserList" datasource="#application.datasource#">
                              insert into adminUsers
                              (username,password,firstName,lastName)
                              values
                              ('#form.myGrid.username[thisIndex]#','#form.myGrid.newPassword[thisIndex]#','#trim(form.myGrid.FirstName[thisIndex])#','#trim(form.myGrid.lastName[thisIndex])#')
                         </cfquery--->
                    </cfif>
              </cfloop>--->
			</cfcase>
        </cfswitch>
    </cffunction>
	<cffunction name="addRecord" access="remote" returntype="Any">
		<cfargument name="fields" type="struct" required="yes">
		<cfquery name="insNew" datasource="GOPDb_LOCAL" result="qryRes">
			insert into tblTest (fname, lname, email, isactive)
			values ( '#arguments.fields.fname#', '#arguments.fields.lname#', 'email', #arguments.fields.isactive#);
		</cfquery>
		<cfreturn 1>		
	</cffunction>
	<cffunction name="deleteRecord" access="remote" returntype="Any">
		<cfargument name="id" type="numeric"  required="yes">
		<cfquery name="delRec" datasource="GOPDb_LOCAL" result="qryRes" >
			delete from tblTest 
			where id = #arguments.id#;
		</cfquery>
		<cfreturn 1>	
	</cffunction>

	<cffunction name="getGridRecordSet" access="remote" returntype="struct">
		<cfargument name="page" type="numeric" required="yes">
		<cfargument name="pageSize" type="numeric" required="yes">
		<cfargument name="gridSortColumn" type="string" required="no" default="">
		<cfargument name="gridSortDirection" type="string" required="no" default="">
		<cfargument name="datasource" type="string" required="false"  default="GOPDb">
		<cfargument name="table" type="string" required="false"  default="tblTest">
		<cfargument name="sortcolumn"  type="string" required="false" default="lname"/>
		<cfset sortstr="">
		<cfif len(trim(arguments.gridSortColumn))>
			<cfset sortstr= "ORDER BY " & #trim(arguments.gridSortColumn)# & " " &  #trim(arguments.gridSortDirection)#>
		<cfelse>
			<cfset sortstr= "ORDER BY " & #arguments.sortcolumn# & " ASC;">
		</cfif>
		<cfquery datasource="#arguments.datasource#" name="qryData">
			select * from #arguments.table# #sortstr#
		</cfquery>
		<cfset retData=QueryConvertForGrid(qryData, arguments.page, arguments.pageSize)>
		<cfreturn retData>
	</cffunction>
</cfcomponent>