/**
 * Server commands
 * You can specify the command name to use with: @command.name
 * and you can specify any aliases via: @command.aliases list,of,aliases
 **/
component output="false" persistent="false" trigger="" {

	java = {
		ServerSocket : createObject("java","java.net.ServerSocket")
		, Socket : createObject("java","java.net.Socket")
		, InetAddress : createObject("java","java.net.InetAddress")
	}

	function init(shell) output="false" {
		variables.shell = shell;
		cr = chr(10);
		if(isNull(server.servers)) {
			server.servers = {};
		}
		variables.servers = server.servers;
		return this;
	}

	/**
	 * Start server
	 *
	 * @background.hint start server in background
	 * @openbrowser.hint open a browser after starting
	 * @directory.hint web root for this server
	 * @name.hint short name for this server
	 * @port.hint port number
	 * @stopsocket.hint stop socket listener port number
	 * @force.hint force start if status is not stopped
	 * @debug.hint sets debug log level
	 **/
	function start(Boolean openbrowser=false, Boolean background=false, String directory="", String name="", Numeric port=0, Numeric stopsocket=0, Boolean force=false, Boolean debug=false)  {
		var manager = new ServerManager(shell);
		var webroot = directory is "" ? shell.pwd() : directory;
		var name = name is "" ? listLast(webroot,"\/") : name;
		var serverInfo = manager.getServerInfo(webroot);
		// we don't want to changes the ports if we're doing stuff already
		if(serverInfo.status is "stopped" || force) {
			serverInfo.name = name;
			serverInfo.port = port;
			serverInfo.stopsocket = stopsocket;
		}
		serverInfo.webroot = webroot;
		serverInfo.debug = debug;
		return manager.start(serverInfo, background, openbrowser, force, debug);
	}

	/**
	 * Stop a server instance
	 *
	 * @directory.hint web root for the server
	 * @name.hint short name for the server
	 * @force.hint force start if status != stopped
	 **/
	function stop(String directory="", String name="", Boolean force=false)  {
		var manager = new ServerManager(shell);
		var webroot = directory is "" ? shell.pwd() : directory;
		var serverInfo = manager.getServerInfo(webroot);
		manager.stop(serverInfo);
	}

	/**
	 * Show server status
	 *
	 * @directory.hint web root for the server
	 * @name.hint short name for the server
	 **/
	function status(String directory="", String name="")  {
		var manager = new ServerManager(shell);
		var servers = manager.getServers();
		for(serverKey in servers) {
			serv = servers[serverKey];
			if(directory != "" && serv.webroot != directory)
				continue;
			if(name != "" && serv.name != name)
				continue;
			if(isNull(serv.statusInfo.reslut)) {
				serv.statusInfo.reslut = "";
			}
			Shell.println(shell.ansi("yellow","name: " & serv.name));
			Shell.print(shell.ansi("white","  status: "));
			if(serv.status eq "running") {
				Shell.println(shell.ansi("green","running"));
				Shell.println(shell.ansi("white","  info: " & serv.statusInfo.result));
			} else if (serv.status eq "starting") {
				Shell.println(shell.ansi("yellow","starting"));
				Shell.println(shell.ansi("red","  info: " & serv.statusInfo.result));
			} else if (serv.status eq "unknown") {
				Shell.println(shell.ansi("red","unknown"));
				Shell.println(shell.ansi("red","  info: " & serv.statusInfo.result));
			} else {
				Shell.println(shell.ansi("white",serv.status));
			}
			Shell.println(shell.ansi("white","  webroot: " & serv.webroot));
			Shell.println(shell.ansi("white","  port: " & serv.port));
			Shell.println(shell.ansi("white","  stopsocket: " & serv.stopsocket));
			Shell.println(shell.ansi("white",""));
		}
	}

	/**
	 * Forgets one or all servers
	 *
	 * @directory.hint web root for this server
	 * @name.hint short name for this server
	 * @all.hint forget all servers
	 * @force.hint force
	 **/
	function forget(String directory="", String name="", Boolean all=false, Boolean force=false)  {
		var manager = new ServerManager(shell);
		var webroot = directory is "" ? shell.pwd() : directory;
		var serverInfo = manager.getServerInfo(webroot);
		if(!all) {
			if(!force && shell.ask("Are you sure you wish to forget: "
					& serverInfo.name &":" & serverInfo.webroot & "? (Y/N) :") == "y") {
				manager.forget(serverInfo);
			}
		} else {
			if(!force && shell.ask("Are you sure you wish to forget ALL servers? (Y/N) :") == "y") {
				manager.forget(serverInfo,true);
			}
		}
	}

	/**
	 * Show log
	 *
	 * @command.name log
	 * @directory.hint web root for the server
	 * @name.hint short name for the server
	 **/
	function showlog(String directory="", String name="")  {
		var manager = new ServerManager(shell);
		var webroot = directory is "" ? shell.pwd() : directory;
		var serverInfo = manager.getServerInfo(webroot);
		var logfile = serverInfo.logdir & "/server.out.txt";
		if(fileExists(logfile)) {
			return fileRead(logfile);
		} else {
			return "No log found";
		}
	}


	private function getRandomPort(host="127.0.0.1") {
		var nextAvail = java.ServerSocket.init(0, 1, java.InetAddress.getByName(host));
		var portNumber = nextAvail.getLocalPort();
		nextAvail.close();
		return portNumber;
	}

}