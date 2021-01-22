<cfset data = QueryNew ("index,title,hours,count","Integer, Varchar,Double,Integer")/>
<cfloop index="ix" from="1" to="10" >
	<cfset t = QueryAddRow(data, 1)/>
	<cfset t= QuerySetCell (data, "index", ix)/>
	<cfset t= QuerySetCell (data, "title",  "Title" & #ix#)/>
	<cfset t= QuerySetCell (data, "hours", 100*ix*RandRange(200,1000))/>
	<cfset t= QuerySetCell (data, "count",  1*RandRange(1,50))/>
</cfloop>

<cfdump var="#data#" expand="false" label="Data Dump"/>

<cfsavecontent variable="mysave" >
	<table border="1" celllpadding="10" cellspacing="0" style="border: solid black 1px;">
			<tr><th colspan="4">REPORT OF TITLE & HOURS</th>
			<tr>
				<th>INDEX</th>
				<th>TITLE</th>
				<th>SUBTITLE</th>
				<th>HOURS</th>
				<th>COUNT</th>
			</tr>
	<cfoutput  query="data">
			<tr>
				<cfset stCnt= RandRange(1,5)/>
				<th rowspan="#stCnt#">#INDEX#</th>
				<th rowspan="#stCnt#">#TITLE#</th>
				<cfloop index="sx" from="1" to="#stCnt#" >
					<th>Subtitle #sx#</th>
					<th>#HOURS#</th>
					<th>&nbsp;(#COUNT#)&nbsp;</th>
					</tr>
				</cfloop>
	</cfoutput>
		<tr>
				<th colspan="3">TOTAL HOURS</th>
				<th colspan="1">20000.00</th>
				<th>&nbsp;(200)&nbsp;</th>
		</tr>
	</table>
</cfsavecontent>
<cfoutput>#mysave#</cfoutput>

<cfheader name="Content-Disposition" value="inline; filename=test.xls">
<cfcontent type="application/msexcel" reset="true"/>
<cfoutput>#mySave#</cfoutput>
