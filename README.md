Error Message library
=====================
This library provides a facility for handling error messages as objects within applications. The messages come from class texts which are normally generated from message source file(s). Each message has a String code, which may be something like "report_exception", or something that can be understood as a formal error code like "VDRC". The message texts can contain any number of substitutable parameters using $1, $2 etc. 

Messages are generated at run-time by calls which may provide arguments to fill the parameters in the message, and also classify the message as one of four levels: 'error', 'warning', 'info' and 'debug'.

Error Accumulators
------------------
The ERROR_ACCUMULATOR class provides an object that can store errors created in any application object, and from which the messages can be collected by a higher level object with access to the UI, or even by another application object that also generates its own messages. Errors, warnings etc can be generated, stored and pulled up a hierarchy of application objects so that top-level objects that connect to the UI can output them in a controlled way. The messages can be filtered according to level ('only errors' etc).

Merging errors up the hierarchy is done by a call like this:

	errors.append (app_obj_1.errors)

where in both cases, 'errors' is an ERROR_ACCUMULATOR instance.

Errors can be printed from an ERROR_ACCUMULATOR via the as_string call, or by filtering, as follows:

	print (errors.as_string_filtered (True, False, False))

Where the Boolean arguments are include_errors, include_warnings, include_info, respectively.


Global Error level
------------------
There is a global error level settable and readable via inheriting the class GLOBAL_ERROR_REPORTING_LEVEL. This enables application code to decide whether to print to output, e.g. only if in debug mode, and/or whether to record errors of certain levels in ERROR_ACCUMULATOR objects.

Messages
--------
The message source files are in messages/source, and have the following format:

	templates = <
		["en"] = <
			["message_code_error"] = <"Error code $1 does not exist (calling context = $2.$3)">

			-- APPLICATION
			["report_exception"] = <"Software Exception $1 caught; Stack:%N$2">
			["general_error"] = <"$1">
			-- etc

			-- APP_OBJECT_1
			["app_obj_1_path_error"] = <"App object 1 wrong path $1 on item $2">
			["app_obj_1_file_error"] = <"App object 1 wrong file $1 on system $2">

			-- etc
		>
		["fr"] = <
			["message_code_error"] = <"Code $1 n'existe pas (contexte appellant = $2.$3)">
			-- etc
		>
	>

This file is in [ODIN format](https://github.com/openEHR/odin), a simple, regular object serialisation format well-suited to Eiffel. The structure above corresponds to a nested HASH_TABLE [HASH_TABLE [STRING, STRING], STRING]] structure, i.e. a set of error message tables that is replicated for each language. Only one language is chosen at compilation time for an application.

Message Compilation
-------------------
Below, the details of message representation are described. To perform a regeneration from the message sources, run the generate_message_db.bat or .sh script.

Message Files
-------------

The files in the messages directory are example error message files. In realistic systems, they are generated from source files, typically in multiple languages, where one language has been specified at the moment of generation.

The general approach is for the application to know about the 'compiled' directory e.g. it may be in a structure as follows:

	.../messages
			/source
				message sourse files
			/compiled
				xxx_compiled_message_db.e
				xxx_compiled_message_ids.e

The message files can be named anything, and any class names used, as long as the application classes that use the error or UI messages know about it. A tool is provided here to perform the generation from ODIN language source files, but any other approach could be used.

The two generated classes are as follows.

An 'ids' class, containing String message ids, with the following typical format.  The 'ec_xxx' identifiers are used in the application to access error messages.
	
	class TEST_COMPILED_MESSAGE_IDS

	feature -- Definitions
		ec_message_code_error: STRING = "message_code_error"

		ec_report_exception: STRING = "report_exception"
		ec_general_error: STRING = "general_error"
		ec_read_failed_file_does_not_exist: STRING = "read_failed_file_does_not_exist"
		ec_file_not_found: STRING = "file_not_found"
		
	end

The messages DB class, with the following format:

	class TEST_COMPILED_MESSAGE_DB

	inherit
		TEST_COMPILED_MESSAGE_IDS

		MESSAGE_DB
			redefine
				make
			end

	create
		make

	feature -- Initialisation

		make
			do
				create message_table.make (20)
				message_table.put ("Error code $1 does not exist (calling context = $2.$3)", ec_message_code_error)
				message_table.put ("Software Exception $1 caught; Stack:%N$2", ec_report_exception)
				message_table.put ("$1", ec_general_error)
				message_table.put ("Read failed; file $1 does not exist.", ec_read_failed_file_does_not_exist)
				message_table.put ("File $1 not found", ec_file_not_found)
			end	
	end

Each such class inherits MESSAGE_DB facilities, and the message_table, which is just a string-keyed HASH_TABLE. An instance of XXXX_COMPILED_MESSAGE_DB is therefore a separate in-memory message database.


