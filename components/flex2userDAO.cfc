<cfcomponent output="false">

	<cffunction name="CreatePassword" access="public" output="No" returntype="string" displayname="I create a default password">
		<cfset var new_password = "">
		<!--- call the customtag make_password, returns a new_password --->
		<cf_make_password>

		<cfreturn new_password />
	</cffunction>
	
	<cffunction name="HashPassword" access="public" output="No" returntype="string" displayname="I convert a password to a hasshed one">
		<cfargument name="password" type="string" required="yes">
		<cfset var hash_pw = "">
		<cfset hash_pw = hash(arguments.password, "MD5")>
		<!--- Your hashed password is:<cfoutput>#hash_pw#</cfoutput> --->

		<cfreturn hash_pw />
	</cffunction>

	<cffunction name="notifyNewUser" access="public" output="No" returntype="void" displayname="I email a new user their password">
		<cfargument name="password" type="string" required="yes">
		<cfargument name="email" type="string" required="yes">
		
		<cfmail subject="Welcome To the Portal - Your Password is..." to="#arguments.email#" from="support@webmxml.com">
		Your password is: #arguments.password#
		</cfmail>
		
	</cffunction>

	<cffunction name="read" output="false" access="public" returntype="flextraining.logindemo.components.flex2user">
		<cfargument name="id" required="true">
		<cfset var qRead="">
		<cfset var obj="">

		<cfquery name="qRead" datasource="flex2rocks">
			select 	username, fullname
			from flex2user
			where username = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.id#" />
		</cfquery>

		<cfscript>
			obj = createObject("component", "flextraining.logindemo.components.flex2user").init();
			obj.setusername(qRead.username);
			obj.setfullname(qRead.fullname);
			return obj;
		</cfscript>
	</cffunction>



	<cffunction name="create" output="false" access="public" returntype="void">
		<cfargument name="bean" required="true" type="flextraining.logindemo.components.flex2user">
		<cfset var qCreate="">
		<cfset var qGetUsername="">

		<cfset var local0=arguments.bean.getUsername()>
		<cfset var local1=arguments.bean.getfullname()>
		<cfset var local2=arguments.bean.getEmail()>
		<cfset new_password = CreatePassword()>
		<cfscript>
			notifyNewUser(new_password,local2);
		</cfscript>
		<cfset hash_pw = hash(new_password, "MD5")>
		
		<cftransaction isolation="read_committed">
			<cfquery name="qCreate" datasource="flex2rocks">
				insert into flex2user(username,fullname, passwd)
				values (
					<cfqueryparam value="#local0#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#local1#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#hash_pw#" cfsqltype="CF_SQL_VARCHAR" />
				)
			</cfquery>

			<!--- If your server has a better way to get the latest record that is more reliable, use that instead --->
			<cfquery name="qGetUsername" datasource="flex2rocks">
				select username, fullname
				from flex2user
				where username = trim(<cfqueryparam value="#local0#" cfsqltype="CF_SQL_VARCHAR" />)
				  and fullname = trim(<cfqueryparam value="#local1#" cfsqltype="CF_SQL_VARCHAR" />)
				order by username desc
			</cfquery>
		</cftransaction>

		<cfscript>
			arguments.bean.setusername(qGetUsername.username);
		</cfscript>
	</cffunction>



	<cffunction name="update" output="false" access="public" returntype="void">
		<cfargument name="bean" required="true" type="flextraining.logindemo.components.flex2user">
		<cfset var qUpdate="">

		<cfquery name="qUpdate" datasource="flex2rocks" result="status">
			update flex2user
			set username = <cfqueryparam value="#arguments.bean.getUsername()#" cfsqltype="CF_SQL_VARCHAR" />,
				fullname = <cfqueryparam value="#arguments.bean.getfullname()#" cfsqltype="CF_SQL_VARCHAR" />
			where username = <cfqueryparam value="#arguments.bean.getusername()#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
	</cffunction>



	<cffunction name="delete" output="false" access="public" returntype="void">
		<cfargument name="bean" required="true" type="flextraining.logindemo.components.flex2user">
		<cfset var qDelete="">

		<cfquery name="qDelete" datasource="flex2rocks" result="status">
			delete
			from flex2user
			where username = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.bean.getusername()#" />
		</cfquery>

	</cffunction>

	<cffunction name="login" output="false" access="public" returntype="string">
		<cfargument name="username" type="string" required="true" hint="The Username">
		<cfargument name="password" type="string" required="true" hint="The Password">
		<cfset var qIsAuthenticated = "">
		<cfset var blnIsAuthenticated = "false">
		<cfscript>
			hash_pw = hash(arguments.password, "MD5");
		</cfscript>
		
		<cfquery name="qIsAuthenticated" datasource="flex2rocks" result="status">
			select username
			from flex2user
			where username = trim(<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.username#" />)
			and passwd = trim(<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#hash_pw#" />)
		</cfquery>
		<cfif qIsAuthenticated.recordcount gt 0>
			<cfset blnIsAuthenticated = "true">
		</cfif>	
		
		<cfreturn blnIsAuthenticated />
	</cffunction>

</cfcomponent>