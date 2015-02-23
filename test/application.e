note
	component:   "Eiffel Application Framework"
	description: "Test application for error_message library"
	keywords:    "errors, messages"
	author:      "Thomas Beale <thomas.beale@oceaninformatics.com>"
	support:     "http://www.openehr.org/issues/browse/AWB"
	copyright:   "Copyright (c) 2015- Ocean Informatics Pty Ltd <http://www.oceaninfomatics.com>"
	license:     "Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>"

class APPLICATION

inherit
	APP_DEFINITIONS

create
	make

feature -- Initialisation

	make
		do
			initialise

			create app_obj_1.make
			create app_obj_2.make

			set_global_error_reporting_level (error_type_debug)

			create errors.make

			-- direct printing to output
			print (get_text (ec_app_launched)); io.new_line
			print (get_msg (ec_read_failed_file_does_not_exist, <<"bad_file.text">>)); io.new_line

			-- Now create some errors and warnings in the error accumulator
			errors.add_error (ec_general_error, <<"system fail">>, generator + ".make")
			errors.add_warning (ec_missing_config_file_warning, <<"/home/<user>/app.cfg">>, "")

			-- generate some direct debug, if the global error level is at debug
			if global_error_reporting_level = error_type_debug then
				print ("************* " + generator + ".make: debug info #1%N")
			end

			-- call other applications objects to do some work that will cause them to create error messages
			app_obj_1.do_work
			app_obj_2.do_work

			-- now we show just the top app's errors
			print ("-------------------- show APP's Errors only ----------------------%N")
			print (errors.as_string_filtered (True, False, False))

			-- now we show the top app's message of any kind
			print ("-------------------- show APP's messages ----------------------%N")
			print (errors.as_string_filtered (True, True, True))

			-- more realistic: merge the errors from the worker objects
			errors.append (app_obj_1.errors)
			errors.append (app_obj_2.errors)

			-- now we show whole lot filtered
			print ("-------------------- show all error messages ----------------------%N")
			print (errors.as_string_filtered (True, False, False))

			-- now we show whole lot unfiltered
			print ("-------------------- show all messages (any kind) ----------------------%N")
			print (errors.as_string)
		end

feature -- Access

	app_obj_1: APP_OBJECT_1

	app_obj_2: APP_OBJECT_2

feature {NONE} -- Implementation

	errors: ERROR_ACCUMULATOR

	initialise
		do
			-- set up the error message DB
			message_db.add_table (create {TEST_COMPILED_MESSAGE_DB}.make)
		end

end


