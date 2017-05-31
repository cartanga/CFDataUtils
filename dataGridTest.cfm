<cfsetting showdebugoutput="true"/>
 
<cfajaxproxy  cfc="cfsamples.artist.ARTISTSDAO" jsclassname="dataMgr"/>

<cfajaximport tags="cfwindow">
<cfajaximport tags="cfform">
<cfajaximport tags="cfgrid">
<cfscript>
//
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
page.form.datasource="GOPDb";
page.form.table = "tblTest";
page.form.sortfield = "lastname";
//page.form.updateurl = "index.cfm";
//page.form.addurl = "index.cfm";

/* Populate the fields structure */
field = ArrayNew(1);
fx=1;
field[fx++] = AddField("artistid","text",true,"ArtistID",false, true);
field[fx++] = AddField("firstname","text",false,"First Name",true, true);
field[fx++] = AddField("lastname","text",false,"Last Name",true, true);
field[fx++] = AddField("email","text",false,"Email",true, true);
field[fx++] = AddField("address","text",false,"Address",true, true);
field[fx++] = AddField("city","text",false,"City",true, true);
field[fx++] = AddField("state","text",false,"State",true, true);
field[fx++] = AddField("postalcode","text",false,"Postal Code",true, true);
page.form.fields = StructNew();
page.form.fields = field;

</cfscript>


<script>
var objMgr= new dataMgr();
objMgr.setErrorHandler(showError);
objMgr.setCallbackHandler(handleResult);

function addUser() {	
	ColdFusion.Window.show('addNewWindow');
}
function saveUser(){
	//ColdFusion.Window.hide('addNewWindow');
	var form = document.addNewForm;
	//alert(form.name);
	//alert (dataMgr);
	for (fx = 0; fx < form.elements.length; fx++) {
		//alert(form.elements[fx].name + " " + form.elements[fx].value);
	}
	var fData = {};
	fData.firstname  = document.addNewForm.firstname.value;
	fData.lastname   = document.addNewForm.lastname.value;
	fData.address    = document.addNewForm.address.value;
	fData.city       = document.addNewForm.city.value;
	fData.state      = document.addNewForm.state.value;
	fData.postalcode = document.addNewForm.postalcode.value;
	fData.email      = document.addNewForm.email.value;
	alert ('FDATA' + fData);
	objMgr.create(fData);
}
function deleteUser() {
	var grid=ColdFusion.Grid.getGridObject("ArtistGrid");
	// Get the grid selectionModel, and selected Record
	record = grid.getSelectionModel().getSelected();
	// Get data, pick the data with column name
	alert('GRID Column Model : ' + record.data.ID + ', '+ record.data.FNAME);
	//alert ("GRID " + document.MyEditor.selectedRowID.value);
	var cf=confirm("DELETING" + document.MyEditor.selectedFname.value )
	if (cf == true) {
		objMgr.delete(document.MyEditor.selectedRowID.value);
	}
}
function handleResult(res){	
	ColdFusion.Window.hide('addNewWindow');
	alert ('HANDLER Done ' + res);	
	ColdFusion.Grid.refresh('ArtistGrid');			
}
function showError(e)
{
	alert('ERROR ' + e.message);
}

function init()
{
	grid = ColdFusion.Grid.getGridObject("ArtistGrid");
	//alert ('Version ' + $ext.version);
	alert ('GRID ' + grid);
	return;
}

function onDelete(){ 
	var grid = ColdFusion.Grid.getGridObject("ArtistGrid");
	var record = grid.getSelections(); 
	alert("Artist " + record[0].data.FIRSTNAME + " " + record[0].data.LASTNAME + " deleted");
}
</script>

<cfquery name="getArtists" datasource="cfartgallery">
SELECT artistId, firstname, lastname, address, city, state, postalcode, email
FROM Artists
</cfquery>

<cfset args = structNew()>
<cfset args.name = "ArtistGrid">
<cfset args.format = "html">
<cfset args.query = "getArtists">
<cfset args.stripeRows = true>
<cfset args.selectColor = "##D9E8FB">

<cfform name="form1">
<a href="javascript:addUser();">Add User</a>
<cfinput type="text" name="selectedRowID" bind="{ArtistGrid.artistid@click}"/>
<cfinput type="text" name="selectedFname" bind="{ArtistGrid.firstname@click}"/>
<cfinput type="text" name="selectedLname" bind="{ArtistGrid.lastname@click}"/>
<a href="javascript:deleteUser();">Delete User</a>&nbsp;<a href="javascript:init();">Init</a>
   <cfgrid attributeCollection="#args#"  selectmode="edit" >
      <cfgridcolumn name="artistid" display="false">
      <cfgridcolumn name="firstname" header="First Name">
      <cfgridcolumn name="lastname" header="Last Name">
      <cfgridcolumn name="email" header="Email Address">
      <cfgridcolumn name="address" header="Address"> 
      <cfgridcolumn name="city" header="City"> 
      <cfgridcolumn name="state" header="State"> 
      <cfgridcolumn name="postalcode" header="Zip"> 
   </cfgrid>
</cfform>

<cfwindow name="addNewWindow" width="600" height="400"   modal="false" center="true"
  initshow="false" resizable="false"  title="Add New User">
			<cfform name="addNewForm" target="_parent">
			<table width="100%" border="1">
			<tr>
				<th colspan="2">Add New Record</th>
			</tr>
			<tr>
				<th>
				DataSource:
				</th>
				<th><cfinput type="hidden"  name="dataSource" value="#page.form.datasource#">
				<cfoutput>#page.form.datasource#</cfoutput>
				</th>
			</tr>
			<tr>
				<th>Data Table:</th>
				<th><cfinput type="hidden" name="table" value="#page.form.table#">
				<cfoutput>#page.form.table#</cfoutput>
				</th>
			</tr>
			<cfloop index="fld" from="1" to="#ArrayLen(page.form.fields)#">
				<cfif page.form.fields[fld].primarykey eq 1><cfcontinue></cfif>
				<tr>
				<td><cfoutput>#page.form.fields[fld].header#</cfoutput></td>
				<td>
					<cfinput type="#page.form.fields[fld].type#" name="#page.form.fields[fld].name#" value="">
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
