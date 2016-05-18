<!--
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements.  See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership.  The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License.  You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
-->

<!DOCTYPE html>
<html>
<head>
<title>bootstrap datepicker examples</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
	function pigjobquery1() {

		var startdate = document.getElementById('startdate4').value;
		var enddate = document.getElementById('enddate4').value;

		var uname = document.getElementById("username4");
		uname = uname.options[uname.selectedIndex].value;
		var instance = document.getElementById("instance4");
		instance = instance.options[instance.selectedIndex].value;

		if (uname == "default") {
			alert("Please select an username");
		} else if (instance == "default") {
			alert("Please select an instance name");
		} else {
			$('#progressbar').show();
			$('#lines').hide();
			pigjob(uname, startdate, enddate, instance);
			interval = setInterval(loadpercentage, 1000 );
		}

	}

	function loadpercentage() {
     	$.ajax({
        url : "ProgressBarStatus",
        success : function(result) {
         $('#progressbarhivesavedquery').css('width', result);
          console.log("Got the precentage completion "+ result);
   			},

       });
  }

	function pigjob(uname, startdate, enddate, instance) {

		var url = "Pigjobsevlet?username=" + uname + "&startdate="
				+ startdate + "&enddate=" + enddate + "&instance=" + instance;

		$.ajax({
			url : url,
			success : function(result) {
				console.log("Got Result");
				document.getElementById("lines").innerHTML = result;
				clearInterval(interval);
				$('#progressbar').hide()
                $('#lines').show()
			}
		});

	}
</script>
<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.apache.ambari.view.huetoambarimigration.datasource.DataSourceAmbariDatabase"%>
<%@ page import="org.apache.ambari.view.huetoambarimigration.datasource.DataSourceHueDatabase"%>
<%@ page import="javax.servlet.ServletConfig"%>
<%@ page import="javax.servlet.ServletContext"%>
<%@ page import="org.apache.ambari.view.ViewContext"%>

</head>
<%
	ArrayList<String> username = new ArrayList<String>();
	ArrayList<String> instancename = new ArrayList<String>();
	int i;
	
	Connection conn = null;

	 ServletContext context = request.getServletContext();
     ViewContext view=(ViewContext) context.getAttribute(ViewContext.CONTEXT_ATTRIBUTE);

	conn = DataSourceHueDatabase.getInstance(view.getProperties().get("huedrivername"),view.getProperties().get("huejdbcurl"),view.getProperties().get("huedbusername"),view.getProperties().get("huedbpassword")).getConnection();
	Statement stat = conn.createStatement();

	ResultSet rs = stat.executeQuery("select * from auth_user;");

	while (rs.next()) {
		username.add(rs.getString(2));
	}

	rs.close();

	Connection c = null;
	Statement stmt = null;
	

	c =  DataSourceAmbariDatabase.getInstance(view.getProperties().get("ambaridrivername"),view.getProperties().get("ambarijdbcurl"),view.getProperties().get("ambaridbusername"),view.getProperties().get("ambaridbpassword")).getConnection();
	c.setAutoCommit(false);
	stmt = c.createStatement();

	ResultSet rs1=null;

	if(view.getProperties().get("ambaridrivername").contains("oracle"))
    		{
    		 rs1 = stmt
            	    .executeQuery("select distinct(view_instance_name) as instancename from viewentity where view_name='PIG{1.0.0}'");
    		}
    		else
    		{
    		 rs1 = stmt
            			.executeQuery("select distinct(view_instance_name) as instancename from viewentity where view_name='PIG{1.0.0}';");
    		}


	while (rs1.next()) {
		instancename.add(rs1.getString(1));

	}
	rs1.close();
	stmt.close();
	
%>
<div class="row">
	<div class="col-sm-12">
		<form method="GET" onSubmit="pigjobquery()">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3>Pig Job Migration</h3>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-sm-3">
							UserName<font size="3" color="red"> *</font>
						</div>
						<div class="col-sm-3">
							<!-- <input type="text" placeholder="Enter username(*)" name="username4" id="username4"> -->
							<select class="form-control" name="username4"
								placeholder="User name" id="username4" required>
								<option value="default" selected>Select below</option>
								<option value="all">ALL User</option>

								<%
									for (i = 0; i < username.size(); i++) {
								%><option value="<%=username.get(i)%>"><%=username.get(i)%></option>
								<%
									}
								%>
								<%
									username.clear();
								%>
							</select>
						</div>
					</div>
					<p></p>
					<p></p>
					<div class="row">
						<div class="col-sm-3">
							Instance name<font size="3" color="red"> *</font>
						</div>
						<div class="col-sm-3">
							<!-- <input type="text" placeholder="Enter Instance Name(*)" name="instance4" id="instance4"> -->
							<select class="form-control" name="instance4"
								placeholder="Instance name" id="instance4" required>
								<option value="default" selected>Select below</option>

								<%
									for (i = 0; i < instancename.size(); i++) {
								%><option value="<%=instancename.get(i)%>"><%=instancename.get(i)%></option>
								<%
									}
								%>
								<%
									instancename.clear();
								%>
							</select>
						</div>
					</div>
					<p></p>
					<p></p>
					<div class="row">
						<div class="col-sm-3">Start Date</div>
						<div class="col-sm-3">
							<input type="date" placeholder="Enter date" name="startdate4"
								id="startdate4">
						</div>
					</div>
					<p></p>
					<p></p>
					<div class="row">
						<div class="col-sm-3">End Date</div>
						<div class="col-sm-3">
							<input type="date" placeholder="Enter date" name="enddate4"
								id="enddate4">
						</div>
					</div>

					<div class="row">

						<div class="col-sm-3">
							<input type="button" id="submit" class="btn btn-success"
								value="submit" onclick="pigjobquery1()">
						</div>
					</div>

					<div id="lines" style="display: none;"></div>

					<br>
           <br>

           <div class="progress" id="progressbar" style="display: none;">
           <div id="progressbarhivesavedquery" class="progress-bar" role="progressbar" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"  style="width:0%">
           </div>
				</div>
			</div>
		</form>
	</div>
</div>