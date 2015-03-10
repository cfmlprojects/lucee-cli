component extends="mxunit.framework.TestCase" {
//component extends="testbox.system.testing.TestBox" {

	candidates = createObject("java","java.util.TreeSet");

	private function deANSIString(required stringLiteral) {
		var st = createObject("java","org.fusesource.jansi.AnsiString").init(stringLiteral);
		return st.getPlain();
	}

	public void function setUp()  {
		var shell = new cfml.cli.Shell();
		commandHandler = new cfml.cli.CommandHandler(shell);
	}

	public void function testCallCommands()  {
		commandHandler.initCommands();
		var result = commandHandler.callCommand("","echo",{message:"hello world named"});
		debug(result);
		var result = commandHandler.callCommand("","echo",["hello world array"]);
		debug(result);
	}

	public void function testExitCommand()  {
		commandHandler.initCommands();
		result = commandHandler.runCommandline('exit');
		assertTrue(isNull(result));
	}

	public void function runCommandline()  {
		commandHandler.initCommands();

		result = commandHandler.runCommandline('dir /');
		result = deANSIString(result);


		var result = commandHandler.runCommandline("echo hello");
		assertEquals("hello",result);

		result = commandHandler.runCommandline("echo message=hello");
		assertEquals("hello",result);

		result = commandHandler.runCommandline("echo message='hello brother!'");
		assertEquals("hello brother!",result);

		result = commandHandler.runCommandline('echo "hello \"there\" man"');
		debug(result);
		assertEquals('hello "there" man',result);

		result = commandHandler.runCommandline('dir');
		result = deANSIString(result);

		//ls is aliased dir command
		result = commandHandler.runCommandline('ls .');
		result = deANSIString(result);
		debug(result);

		result = commandHandler.runCommandline('dir .');
		result = deANSIString(result);
		debug(result.toString());

	}

	public void function testParseCommandline()  {
		result = commandHandler.parseCommandline('server forget all=true force=true');
		debug(result);
		assertEquals(result.command,"forget");
		assertEquals(result.namespace,"server");
		assertTrue(isStruct(result.args));
		assertTrue(structKeyExists(result.args,"force"));
	}

	public void function testLoadCommands()  {
		commandHandler.initCommands();
		candidates = commandHandler.getCommands();
		candidates.clear();
	}
}