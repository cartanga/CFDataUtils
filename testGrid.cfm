<html>
<head>
<title>Custom Toolbars Example</title>

<!---<script type="text/javascript" src="/CFIDE/scripts/ajax/ext/package/toolbar/toolbar.js"></script>
--->
<script type="text/javascript">
function init(){
      grid = ColdFusion.Grid.getGridObject("ArtistGrid");
	  //alert (grid.id);
	  var jsgrid = document.getElementById(grid.id);
	  //alert (jsgrid.parentNode);
	  
      var gridFoot = grid.getBottomToolbar();
      var gridHead = grid.getTopToolbar();
	  
var sbun = new Ext.Toolbar.Button({
pressed: true,
enableToggle: false,
text: 'Create',
id: 'createId',
cls: ''
})	  
	  
	  gridFoot.add("-", sbun);
	  return;
	alert (typeof(grid));
      var bbar = new Ext.Toolbar(gridFoot);
      var tbar = new Ext.Toolbar();
      
      bbar.add(new Ext.Toolbar.TextItem('Total Artists: ' + grid.getStore().totalLength));
      
      tbar.addButton({
       text:"Add New Artist",
       cls:"x-btn-text-icon",
       icon:"add.png",
       handler:onAdd
      });
      tbar.addSeparator()
      tbar.addButton({
       text:"Delete Artist",
       cls:"x-btn-text-icon",
       icon:"delete.png",
       handler:onDelete
      });
	  grid.add(tbar);
	  grid.update();
      
      console.log(tbar);
      console.log(bbar);

}

function onAdd(button,event){
alert("Row Added");

console.log(button);
console.log(event);
}
function onDelete(){ 
var grid = ColdFusion.Grid.getGridObject("ArtistGrid");
var record = grid.getSelections(); 
alert("Artist " + record[0].data.FIRSTNAME + " " + record[0].data.LASTNAME + " deleted");
}
</script>
</head>
<body>

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

<cfform>
   <cfgrid  insert="true" delete="true" selectmode="row"  attributeCollection="#args#">
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

<cfset ajaxOnLoad("init")>



<cfsavecontent variable="head">
<link href="/CFIDE/scripts/ajax/ext/resources/css/ytheme-aero.css" rel="stylesheet" type="text/css">
<link href="/CFIDE/scripts/ajax/ext/resources/css/menu.css" type="text/css" rel="stylesheet"/>
</cfsavecontent>

<cfhtmlhead text="#head#">

</body>
</html>
