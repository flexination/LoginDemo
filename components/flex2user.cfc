<cfcomponent output="false" alias="flextraining.logindemo.components.flex2user">
	<!---
		 These are properties that are exposed by this CFC object.
		 These property definitions are used when calling this CFC as a web services, 
		 passed back to a flash movie, or when generating documentation

		 NOTE: these cfproperty tags do not set any default property values.
	--->
	<cfproperty name="username" type="string" default="">
	<cfproperty name="fullname" type="string" default="">
	<cfproperty name="passwd" type="string" default="">
	<cfproperty name="email" type="string" default="">

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.username = "";
		variables.fullname = "";
		variables.email = "";
	</cfscript>

	<cffunction name="init" output="false" returntype="flex2user">
		<cfreturn this>
	</cffunction>
	<cffunction name="getUsername" output="false" access="public" returntype="any">
		<cfreturn variables.Username>
	</cffunction>

	<cffunction name="setUsername" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Username = arguments.val>
	</cffunction>

	<cffunction name="getFullname" output="false" access="public" returntype="any">
		<cfreturn variables.Fullname>
	</cffunction>

	<cffunction name="setFullname" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Fullname = arguments.val>
	</cffunction>

	<cffunction name="getEmail" output="false" access="public" returntype="any">
		<cfreturn variables.email>
	</cffunction>

	<cffunction name="setEmail" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.email = arguments.val>
	</cffunction>

	<cffunction name="getPasswd" output="false" access="public" returntype="any">
		<cfreturn variables.passwd>
	</cffunction>

	<cffunction name="setPasswd" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.passwd = arguments.val>
	</cffunction>


</cfcomponent>