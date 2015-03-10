component extends="mxunit.framework.TestCase" {
//component extends="testbox.system.testing.TestBox" {

	candidates = createObject("java","java.util.TreeSet");

	public void function setUp()  {
		var shell = new cfml.cli.Shell();
		commandHandler = new cfml.cli.CommandHandler(shell);
		commandGrammar = new cfml.cli.commandgrammar.CommandGrammar();
		commandGrammar.setCommands(commandHandler.getCommands());
		fileWrite("/tmp/struct.txt", shell.formatJSON(serializeJSON(commandHandler.getCommands())));
		parser = commandGrammar;
	}


	public void function testParseCommands()  {
		var parse = parser.parse("dir");
		var commandLine = parse.tree;
		var messages = parse.messages;
		assertTrue(isNull(commandLine.namespace()));
		assertEquals("dir", commandLine.command().getText());
		assertEquals(0, commandLine.command().arguments().argument().size());
		assertEquals(0, messages.size());

		parse = parser.parse("dir /");
		commandLine = parse.tree;
		messages = parse.messages;
		debug(parse.stringtree);
		debug(parse.infostring);
		debug(messages);
		assertEquals(0, messages.size());
		assertTrue(isNull(commandLine.namespace()));
		assertEquals("dir", commandLine.command().commandName().getText());
		assertEquals(1, arrayLen(commandLine.command().arguments().argument()));
		assertEquals("/", commandLine.command().arguments().argument()[1].value().getText());

		parse = parser.parse("dir .");
		commandLine = parse.tree;
		messages = parse.messages;
		debug(parse.stringtree);
		debug(parse.infostring);
		debug(messages);
		assertEquals(0, messages.size());
		assertTrue(isNull(commandLine.namespace()));
		assertEquals("dir", commandLine.command().commandName().getText());
		assertEquals(1, arrayLen(commandLine.command().arguments().argument()));
		assertEquals(".", commandLine.command().arguments().argument()[1].value().getText());

		parse = parser.parse("dir /woot");
		commandLine = parse.tree;
		messages = parse.messages;
		debug(parse.stringtree);
		debug(parse.infostring);
		debug(messages);
		assertEquals(0, messages.size());
		assertTrue(isNull(commandLine.namespace()));
		assertEquals("dir", commandLine.command().commandName().getText());
		assertEquals(1, arrayLen(commandLine.command().arguments().argument()));
		assertEquals("/woot", commandLine.command().arguments().argument()[1].value().getText());

		parse = parser.parse("dir directory=/");
		commandLine = parse.tree;
		messages = parse.messages;
		debug(parse.stringtree);
		debug(parse.infostring);
		debug(messages);
		assertEquals(0, messages.size());
		assertTrue(isNull(commandLine.namespace()));
		assertEquals("dir", commandLine.command().commandName().getText());
		assertEquals(1, arrayLen(commandLine.command().arguments().argument()));
		assertEquals("directory", commandLine.command().arguments().argument()[1].argumentName().getText());
		assertEquals("/", commandLine.command().arguments().argument()[1].value().getText());

		parse = parser.parse("dir directory=blah ");
		commandLine = parse.tree;
		messages = parse.messages;
		debug(parse.stringtree);
		debug(parse.infostring);
		debug(messages);
		assertEquals(0, messages.size());
		assertTrue(isNull(commandLine.namespace()));
		assertEquals("dir", commandLine.command().commandName().getText());
		assertEquals(1, arrayLen(commandLine.command().arguments().argument()));
		assertEquals("directory", commandLine.command().arguments().argument()[1].argumentName().getText());
		assertEquals("blah", commandLine.command().arguments().argument()[1].value().getText());

		parse = parser.parse("dir directory=/ recurse=false");
		commandLine = parse.tree;
		messages = parse.messages;
		debug(parse.stringtree);
		debug(parse.infostring);
		debug(messages);
		assertEquals(0, messages.size());
		assertTrue(isNull(commandLine.namespace()));
		assertEquals("dir", commandLine.command().commandName().getText());
		assertEquals(2, arrayLen(commandLine.command().arguments().argument()));
		assertEquals("directory", commandLine.command().arguments().argument()[1].argumentName().getText());
		assertEquals("/", commandLine.command().arguments().argument()[1].value().getText());
		assertEquals("recurse", commandLine.command().arguments().argument()[2].argumentName().getText());
		assertEquals("false", commandLine.command().arguments().argument()[2].value().getText());

	}

	public void function testParseNamespace()  {
		parse = parser.parse("cfdistro");
		commandLine = parse.tree;
		messages = parse.messages;
		assertEquals("cfdistro", commandLine.namespace().getText());
		assertEquals("<missing commandname>", commandLine.command().getText());
		assertEquals(0, commandLine.command().arguments().argument().size());

		parse = parser.parse("server");
		commandLine = parse.tree;
		messages = parse.messages;
		assertEquals("server", commandLine.namespace().getText());
		assertEquals("<missing commandname>", commandLine.command().getText());
		assertEquals(0, commandLine.command().arguments().argument().size());

		parse = parser.parse("cfdistro dependency");
		commandLine = parse.tree;
		messages = parse.messages;
		assertEquals("cfdistro", commandLine.namespace().getText());
		assertEquals("dependency", commandLine.command().getText());
		assertEquals(0, commandLine.command().arguments().argument().size());

	}

	public void function testParseNamespaceCommand()  {
		parse = parser.parse("cfdistro dependency");
		commandLine = parse.tree;
		messages = parse.messages;
		assertEquals("cfdistro", commandLine.namespace().getText());
		assertEquals("dependency", commandLine.command().getText());
		assertEquals(0, commandLine.command().arguments().argument().size());

		parse = parser.parse("server start port=8765 force=true");
		commandLine = parse.tree;
		messages = parse.messages;
		debug(parse.stringtree);
		debug(parse.infostring);
		debug(messages);
		assertEquals(0, messages.size());
		assertEquals("server", commandLine.namespace().getText());
		assertEquals("start", commandLine.command().commandName().getText());
		assertEquals(2, arrayLen(commandLine.command().arguments().argument()));
		assertEquals("port", commandLine.command().arguments().argument()[1].argumentName().getText());
		assertEquals("8765", commandLine.command().arguments().argument()[1].value().getText());
		assertEquals("force", commandLine.command().arguments().argument()[2].argumentName().getText());
		assertEquals("true", commandLine.command().arguments().argument()[2].value().getText());

	}

}