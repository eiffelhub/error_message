note
	component:   "Eiffel Application Framework"
	description: "Test application for error_message library"
	keywords:    "errors, messages"
	author:      "Thomas Beale <thomas.beale@oceaninformatics.com>"
	support:     "http://www.openehr.org/issues/browse/AWB"
	copyright:   "Copyright (c) 2015- Ocean Informatics Pty Ltd <http://www.oceaninfomatics.com>"
	license:     "Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>"

class APP_OBJECT_1

inherit
	APP_DEFINITIONS

create
	make

feature -- Initialisation

	make
		do
			create errors.make
		end

feature -- Commands

	do_work
		do
			errors.add_error (ec_app_obj_1_file_error, <<"file_xyz.txt", "heating">>, generator + ".do_work")
			errors.add_info (ec_app_obj_1_path_error, <<"/aaa/bbb/ccc", "parser">>, generator + ".do_work")

			if global_error_reporting_level = error_type_debug then
				print ("************* " + generator + ".do_work: debug info #1%N")
			end
		end

feature {APPLICATION} -- Implementation

	errors: ERROR_ACCUMULATOR

end


