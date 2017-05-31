<cfif #IsDefined("FORM.submit")#>
<cfdump var="#form#"/>
<cfexit>
<cfdump var="#form.__CFGRID__MYEDITOR__DG1#"/>

</cfif>

<cfajaxproxy  cfc="dataManager" jsclassname="dataMgr"/>
<cfajaximport tags="cfform">
<cfajaximport tags="cfwindow">
<cfajaximport tags="cfgrid">

<cfscript>
function AddField(name, type, isPK, header, display, editable) {
	var field = StructNew();
	field.name=name;
	field.type=type;
	field.primarykey=isPK;
	field.header=header;
	field.display=display;
	field.editable = editable;
	return field;
}

function AddFKey(dataSource, tableName, valueField, displayField) {
	var key=StructNew();
	key.datasource=dataSource;
	key.table=tableName;
	key.value=valueField;
	key.display=displayField;
	return key;
}
/* Initialize */
page= StructNew();
page.title="Page Title";
page.form = StructNew();
page.form.datasource="GOPDb_LOCAL";
page.form.table = "tblTest";
page.form.sortfield = "lname";

/* Populate the fields structure */

field = ArrayNew(1);
field[1] = AddField("id","text",true,"ID",false, true);
field[2] = AddField("fname","text",false,"First Name",true, true);
field[3] = AddField("lname","text",false,"Last Name",true, true);
field[4] = AddField("email","text",false,"Email",true, true);
field[5] = AddField("isactive","select",false,"Active User",true, true);
field[5].key = AddFKey("GOPDb_LOCAL","tblYesNoUkn", "YesNoUknID","YesNoUkn");

page.form.fields = StructNew();
page.form.fields = field;

</cfscript>

<cfloop index="fld" from="1" to="#ArrayLen(page.form.fields)#">
	<cfif #Arraylen(StructFindKey(page.form.fields[fld], "key"))#>
		<cfquery name="getKeyRecords" datasource="#page.form.fields[fld].key.datasource#">
			select #page.form.fields[fld].key.value# as Value,
	   			   #page.form.fields[fld].key.display# as Display
 			from #page.form.fields[fld].key.table#
			order by Display;
		</cfquery>
		<cfset page.form.fields[fld].key.query=getKeyRecords>
	</cfif>
</cfloop>
<script>

var objMgr= new dataMgr();
objMgr.setErrorHandler(showError);
objMgr.setCallbackHandler(handleResult);

function addUser() {
	
	ColdFusion.Window.show('addNewWindow');
	var datagrid = ColdFusion.Grid.getGridObject('dg1');
	WriteDump ('HELLO' & datagrid);

}

function saveUser(){
	var form = document.addNewForm;
	
	for (fx = 0; fx < form.elements.length; fx++) {
		//alert(form.elements[fx].name + " " + form.elements[fx].value);
	}
	var fData = {};
	fData.fname = document.addNewForm.fname.value;
	fData.lname = document.addNewForm.lname.value;
	fData.isactive = document.addNewForm.isactive.value;
	//alert ('FDATA' + fData);
	objMgr.addRecord(fData);
	
}
function deleteUser() {
	var grid=ColdFusion.Grid.getGridObject("dg1");
	// Get the grid selectionModel, and selected Record
	record = grid.getSelectionModel().getSelected();
	// Get data, pick the data with column name
	
	var cf=confirm("DELETING" + document.MyEditor.selectedFname.value )
	if (cf == true) {
		objMgr.deleteRecord(document.MyEditor.selectedRowID.value);
	}
}

function handleResult(res){	
	ColdFusion.Window.hide('addNewWindow');
	ColdFusion.Grid.refresh('dg1');				
}

function showError(e)
{
	
			alert('ERROR ' + e.message);
}

function init() {
var grid=ColdFusion.Grid.getGridObject("dg1");
grid.addListener("rowclick",editRow);	
}
function editRow(grid,rowIndex,e){
var grid=ColdFusion.Grid.getGridObject("dg1");
record = grid.getStore().getAt(rowIndex);
}
</script>
<cfform name="MyEditor" method="post">
	<cfset pkfield="id">
	<style type="text/css">
	a { font-size: 30px;}
	</style>
	<a href="javascript:addUser();" title="Add New User">Add User</a>
	<cfinput type="hidden" name="selectedRowID" bind="{dg1.id@click}"/>
	<cfinput type="hidden" name="selectedFname" bind="{dg1.fname@click}"/>
	<cfinput type="hidden" name="selectedLname" bind="{dg1.lname@click}"/>
	<a href="javascript:deleteUser();" title="Delete User">Delete User</a>
	

	<cfset width=300>
	<cfset headerfontSize=20>
	<cfset fontSize=20>

	<cfgrid  selectmode="edit"    deletebutton="Delete Record"   width="1200" fontsize="#fontSize#"     colheaderfontsize="#headerfontSize#"  
		onchange="cfc:utils.dataAdmin.dataManager.editRecord('GOPDb_LOCAL','tblTest','ID',{cfgridaction},{cfgridrow},{cfgridchanged})"
		 name="dg1" format="html" 
		pagesize="10" bindonload="true" 
		bind="cfc:datamanager.getGridRecordSet({cfgridpage},{cfgridpagesize}, {cfgridsortcolumn},{cfgridsortdirection})"  >
		<cfloop index="fld" from="1" to="#ArrayLen(page.form.fields)#">
			<cfset variables.name=page.form.fields[fld].name>
			<cfoutput>
				<cfif page.form.fields[fld].type is "select">
					<cfset dquery=page.form.fields[fld].key.query>
					<cfset variables.values=ValueList(dquery.value)>
					<cfset variables.valuesdisplay=ValueList(dquery.display)>
					<cfgridcolumn  display="true" select="true" type="combobox"      name="#Evaluate("page.form.fields[#fld#].name")#" width="#width#"  header="#Evaluate("page.form.fields[#fld#].header")#"  values="#variables.values#" valuesdisplay="#variables.valuesdisplay#">
				<cfelse>
					<cfif page.form.fields[#fld#].primarykey>
						<cfgridcolumn display="false" width="#width#"     name="#Evaluate("page.form.fields[#fld#].name")#" header="#Evaluate("page.form.fields[#fld#].header")#" >
					<cfelse>
						<cfgridcolumn display="true" width="#width#"  name="#Evaluate("page.form.fields[#fld#].name")#" header="#Evaluate("page.form.fields[#fld#].header")#" >
					</cfif>
				</cfif>
			</cfoutput>
		</cfloop>
	</cfgrid>
	<cfinput type="submit" name="submit" value="Submit"/>
</cfform>

<cfwindow name="addNewWindow"   modal="false" initshow="false"  resizable="false"  title="Add New User">
	<cfform name="addNewForm" target="_parent">
		<table width="100%" border="1">
			<tr>
				<th colspan="2">Add New Record</th>
			</tr>
			<tr>
				<th>
				DS:<cfinput type="text" name="dataSource" value="#page.form.datasource#">
				TBL:<cfinput type="text" name="dataSource" value="#page.form.table#">
				</th>
			</tr>
			<cfloop index="fld" from="1" to="#ArrayLen(page.form.fields)#">
				<cfif page.form.fields[fld].primarykey eq 1><cfcontinue></cfif>
				<tr>
				<td><cfoutput>#page.form.fields[fld].header#</cfoutput></td>
				<td>
				<cfset variables.value = ""/>
					<cfif page.form.fields[fld].type is "select">
						<cfset dquery=page.form.fields[fld].key.query>
						<cfselect  name="#page.form.fields[fld].name#" query="dquery" selected="#variables.value#" value="Value" display="Display" ></cfselect>
					<cfelse>
						<cfinput type="#page.form.fields[fld].type#" name="#page.form.fields[fld].name#" value="#variables.value#">
					</cfif>
				</td>
				</tr>
				</cfloop>
				<tr>
					<td colspan="2">
						<cfinput type="reset" name="btnClear" value="Clear Entries">
						<cfinput type="button" name="btnAdd" value="Add" onclick="javascript:saveUser(); return true;"  >
					</td>
				</tr>
		</table>
	</cfform>
</cfwindow>