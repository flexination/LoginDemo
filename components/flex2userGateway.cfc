<cfcomponent output="false">

	<cffunction name="save" output="false" access="remote">
		<cfargument name="isAuthenticated" default="N" hint="Did this request come from Flex?">
		<cfargument name="obj" required="true" default="" />
		<cftry>
			<cfif arguments.isAuthenticated eq "Y">
		 		<cfscript>
					return createObject("component", "flex2userDAO").create(arguments.obj);
				</cfscript>
			<cfelse>
		 		<cfscript>
					return;
				</cfscript>
			</cfif>
		<cfcatch type="any">
			<cfabort>
		</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="deleteById" output="false" access="remote">
		<cfargument name="id" required="true" />
		<cfset var obj = getById(arguments.id)>
		<cfset createObject("component", "flex2userDAO").delete(obj)>
	</cffunction>



	<cffunction name="getAll" output="false" access="remote" returntype="flextraining.logindemo.components.flex2user[]">
		<cfset var qRead="">
		<cfset var obj="">
		<cfset var ret=arrayNew(1)>

		<cfquery name="qRead" datasource="flex2rocks">
			select username
			from flex2user
		</cfquery>

		<cfloop query="qRead">
		<cfscript>
			obj = createObject("component", "flex2userDAO").read(qRead.username);
			ArrayAppend(ret, obj);
		</cfscript>
		</cfloop>
		<cfreturn ret>
	</cffunction>



	<cffunction name="getAllAsQuery" output="false" access="remote" returntype="query">
		<cfargument name="isAuthenticated" default="N" hint="Did this request come from Flex?">
		<cfset var qRead="">
		<cfif arguments.isAuthenticated eq "Y">
			<cfquery name="qRead" datasource="flex2rocks">
				select username, fullname
				from flex2user
			</cfquery>
		<cfelse>
			<cftransaction isolation="read_committed">
				<cfquery name="qRead" datasource="flex2rocks">
					insert into tbl_hackers (hackerIP) values ('#CGI.Remote_Addr#')
				</cfquery>
			
				<cfquery name="qRead" datasource="flex2rocks">
					select id from tbl_hackers where hackerIP = '#CGI.Remote_Addr#'
				</cfquery>
			</cftransaction>
		</cfif>
		
		<cfreturn qRead>
	</cffunction>

	<cffunction name="doLogin" output="false" access="remote" returntype="string">
		<cfargument name="isAuthenticated" default="N" hint="Did this request come from Flex?">
		<cfargument name="username" type="string" required="true" default="" hint="The Username">
		<cfargument name="password" type="string" required="true" default="" hint="The Username">

		<cfif arguments.isAuthenticated eq "N">
			<cfreturn createObject("component", "flex2userDAO").login(arguments.username,arguments.password) />
		<cfelse>
	 		<cfscript>
				return;
			</cfscript>
		</cfif>
	</cffunction>



</cfcomponent>