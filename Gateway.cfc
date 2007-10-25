<cfcomponent>

<!-------------------------------------------------------------------------------------------------->
<!-------------------------------- Parameters and Initialization ----------------------------------->
<!-------------------------------------------------------------------------------------------------->

<!---------------------------------------------------------------------------------------------- init

	Description: Constructor
			
----------------------------------------------------------------------------------------------------->	

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="yes" />
		<cfargument name="table_name" type="string" required="yes" />
		
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.table_name = arguments.table_name />
	</cffunction>
			
<!-------------------------------------------------------------------------------------------------->
<!-------------------------------------- Gateway Functions ----------------------------------------->
<!-------------------------------------------------------------------------------------------------->

<!-------------------------------------------------------------------------------------------- select

	Description: Returns a query of all objects in this table or a subset if conditions are provided

----------------------------------------------------------------------------------------------------->	
	
	<cffunction name="select" access="public" returntype="query">
		<cfargument name="order_by" default="#variables.order_by#" />
		<cfargument name="sort_direction" default="" />
		<cfargument name="conditions" default="" />
		<cfargument name="columns" default="*" />
		
		<cfset var selectObject = "" />
		
		<cfif arguments.sort_direction EQ "">
			<cfif IsDefined("variables.sort_direction")>
				<cfset arguments.sort_direction = variables.sort_direction />
			<cfelse>
				<cfset arguments.sort_direction = "ASC" />
			</cfif>
		</cfif>
		
		<cfset selectObject = selectQuery(
			arguments.order_by, 
			arguments.sort_direction, 
			arguments.conditions, 
			arguments.columns) />

		<cfreturn selectObject />
	</cffunction>
	
	<cffunction name="initialize" access="public" returntype="void" output="false">
		<cfargument name="object" type="supermodel.datamodel" required="yes" />
		
		<cfset var field_types = StructNew() />
		<cfset var database_fields = "" />
		<cfset StructInsert(object, field_types) />

		<!--- Initiate all the fields (see the function's description for more info) --->
		<cfset initDatabaseFields() />
	
<!--------------------------------------------------------------------------------------- selectQuery

	Description:	Private function that executes a SELECT SQL query
			
----------------------------------------------------------------------------------------------------->	

<cffunction name="selectQuery" access="private">
		<cfargument name="order_by" required="yes" />
		<cfargument name="sort_direction" required="yes" />
		<cfargument name="conditions" required="yes" />
		<cfargument name="columns" required="yes" />
				
		<cfquery name="SelectObject" datasource="#variables.dsn#">
			SELECT * 
			FROM #variables.table_name#
			<cfif arguments.conditions NEQ "">
			WHERE #PreserveSingleQuotes(arguments.conditions)#
			</cfif>
			<cfif arguments.order_by NEQ "">
			ORDER BY #Arguments.order_by# #sort_direction#
			</cfif>
		</cfquery>
		
		<cfreturn SelectObject />
	</cffunction>
</cfcomponent>
